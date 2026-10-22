-- Team To-Do database setup for Supabase.
-- Supabase dashboard → SQL Editor → New query → paste this whole file → Run.
-- Before running, put YOUR email and name in the last line (that makes you the admin).

-- People who can use the app. Admins are added with SQL (last line); team members are added in the app.
create table if not exists public.staff (
  email text primary key,
  name text not null,
  role text not null check (role in ('admin', 'team')),
  phone text not null default '',
  created_at timestamptz not null default now()
);

-- Team members' personal-link logins (admins only)
create table if not exists public.keys (
  email text primary key references public.staff(email) on delete cascade,
  pw text not null
);

-- To-do lists
create table if not exists public.lists (
  id uuid primary key default gen_random_uuid(),
  person text not null,            -- email of the person it's assigned to
  person_name text not null default '',
  date date not null,
  ym text not null,                -- 'YYYY-MM', used to load a month at a time
  title text not null,
  items jsonb not null default '[]',
  by_email text not null default '',
  created_at timestamptz not null default now()
);
create index if not exists lists_person_ym on public.lists (person, ym);
create index if not exists lists_ym on public.lists (ym);

-- Who is asking (from their login)
create or replace function public.my_email() returns text
  language sql stable as $$ select lower(coalesce(auth.jwt() ->> 'email', '')) $$;
create or replace function public.is_staff() returns boolean
  language sql stable security definer set search_path = public
  as $$ select exists (select 1 from public.staff where email = public.my_email()) $$;
create or replace function public.is_admin() returns boolean
  language sql stable security definer set search_path = public
  as $$ select exists (select 1 from public.staff where email = public.my_email() and role = 'admin') $$;

alter table public.staff enable row level security;
alter table public.keys enable row level security;
alter table public.lists enable row level security;

drop policy if exists staff_read on public.staff;
drop policy if exists staff_add on public.staff;
drop policy if exists staff_edit on public.staff;
drop policy if exists staff_remove on public.staff;
create policy staff_read on public.staff for select to authenticated using (email = public.my_email() or public.is_admin());
create policy staff_add on public.staff for insert to authenticated with check (public.is_admin() and role = 'team');
create policy staff_edit on public.staff for update to authenticated using (public.is_admin() and role = 'team') with check (public.is_admin() and role = 'team');
create policy staff_remove on public.staff for delete to authenticated using (public.is_admin() and role = 'team');

drop policy if exists keys_admin on public.keys;
create policy keys_admin on public.keys for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists lists_read on public.lists;
drop policy if exists lists_add on public.lists;
drop policy if exists lists_tick on public.lists;
drop policy if exists lists_remove on public.lists;
create policy lists_read on public.lists for select to authenticated using (public.is_admin() or (public.is_staff() and person = public.my_email()));
create policy lists_add on public.lists for insert to authenticated with check (public.is_admin());
create policy lists_tick on public.lists for update to authenticated
  using (public.is_admin() or (public.is_staff() and person = public.my_email()))
  with check (public.is_admin() or (public.is_staff() and person = public.my_email()));
create policy lists_remove on public.lists for delete to authenticated using (public.is_admin());

-- Team members may only change the ticks, nothing else about a list
create or replace function public.lists_only_ticks() returns trigger
  language plpgsql as $$
declare its jsonb := new.items;
begin
  if not public.is_admin() then new := old; new.items := its; end if;
  return new;
end $$;
drop trigger if exists lists_only_ticks on public.lists;
create trigger lists_only_ticks before update on public.lists for each row execute function public.lists_only_ticks();

-- Removing a team member also deletes their login, so their link stops working
create or replace function public.remove_person(e text) returns void
  language plpgsql security definer set search_path = public, auth as $$
begin
  if not public.is_admin() then raise exception 'not allowed'; end if;
  if not exists (select 1 from public.staff where email = lower(e) and role = 'team') then raise exception 'not a team member'; end if;
  delete from public.staff where email = lower(e);
  delete from auth.users where lower(email) = lower(e);
end $$;
revoke all on function public.remove_person(text) from public, anon;
grant execute on function public.remove_person(text) to authenticated;

revoke all on public.staff, public.keys, public.lists from anon;
grant select, insert, update, delete on public.staff, public.keys, public.lists to authenticated;

-- Live updates for the Progress screen
do $$ begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
     and not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'lists') then
    alter publication supabase_realtime add table public.lists;
  end if;
end $$;

-- ✏️ Put your own email (lowercase) and name here, then Run:
insert into public.staff (email, name, role) values ('girichaitali18@gmail.com', 'Chaitali Giri', 'admin') on conflict (email) do update set role = 'admin';
