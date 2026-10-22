# Team To-Do

A simple to-do app for the team. Admins assign checklists; team members tick them off on their phones.
Team members never type an email or password: each person gets **their own link on WhatsApp**, taps it,
and sees their list. Free: Supabase (logins + data) and GitHub Pages (hosting).

| Who | Sees |
|-----|------|
| admin | **Assign** (pick people, day, title, tasks) · **Progress** (each person's lists by day, remind on WhatsApp, delete) · **Team** (add people, send their link, remove) · **My list** (if something is assigned to them) |
| team | Only their own lists: *Not finished yet*, *Today*, *Coming up*, with big tick boxes. Nothing else. |

## One-time setup (admin, about 10 minutes)

### 1. Supabase
1. Go to https://supabase.com → **Start your project** → sign in (GitHub or Google is fine) → **New project**.
   Name: `team-todo`, set a database password (save it somewhere), Region: **Mumbai** → **Create**.
2. **Authentication → Sign In / Providers** (or **Providers → Email**):
   - **Email** provider: enabled
   - **Allow new users to sign up**: **on** (the app uses it to create team members' logins; a login that isn't
     on your team list can't see anything)
   - **Confirm email**: **off**
   - Save.
3. **SQL Editor → New query**: paste all of `supabase.sql`. In its **last line**, put your own email (lowercase) and name.
   Click **Run**. You should see "Success".
4. **Authentication → Users → Add user → Create new user**: the same email as in step 3, a password,
   tick **Auto Confirm User** → **Create**.
5. **Project Settings → API** (or **Data API**): copy the **Project URL** and the **anon public** key into `config.js`.

### 2. Put it online
1. GitHub repo → **Settings → Pages → Deploy from a branch → `main` / root → Save.**
2. Supabase → **Authentication → URL Configuration → Site URL**: `https://<your-github-username>.github.io/<repo-name>/`
3. Open that link, tap **Admin sign-in**, sign in with the email and password from step 1.4.

## Daily use (admin)
- **Team tab:** type a name and WhatsApp number → **Add** → **Send link on WhatsApp**. That's their whole setup.
- **Assign tab:** tap who, when, type a title and tasks → **Assign** → **Send on WhatsApp**.
- **Progress tab:** see who has finished what (updates live). Tap a list for **Remind on WhatsApp** or **Delete**.
- Someone leaves or loses their phone: **Team → Remove**. Their link stops working at once.
  To give them a new link, add them again.
- Forgot your admin password: Supabase → **Authentication → Users** → your user → **Send password recovery**,
  or delete the user and add it again (step 1.4); your lists are kept.

## For team members
Tap the link in WhatsApp. That's it. Every to-do message includes the same link.
Optional: put it on the home screen like an app. Android: tap **Install** on the banner.
iPhone: **Share → Add to Home Screen**.

## Notes
- A personal link works like a key to that person's list, so it shouldn't be forwarded. Removing the person cancels it.
- Ticking needs internet. Without it, the tick is undone and a message says to check the connection.
- Supabase's free plan pauses a project after **7 days with no use**. Daily use keeps it awake; if it ever pauses,
  open the Supabase dashboard and click **Restore**. Nothing is lost.
- Free plan limits (500 MB database, 50,000 monthly users) are far more than a team to-do app needs.
- Optional later: package it for the Google Play Store with https://www.pwabuilder.com (one-time $25 Google developer fee).
