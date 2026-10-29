# Team To-Do

A simple to-do app for the team. Admins assign checklists; team members tick them off on their phones.
Team members never type an email or password: each person gets **their own link on WhatsApp**, taps it,
and sees their list. Free: Firebase (logins + data) and GitHub Pages (hosting).

| Who | Sees |
|-----|------|
| admin | **Assign** (pick people, day, title, tasks) · **Progress** (each person's lists by day, remind on WhatsApp, delete) · **Team** (add people, send their link, remove) · **My list** (if something is assigned to them) |
| team | Only their own lists: *Not finished yet*, *Today*, *Coming up*, with big tick boxes. Nothing else. |

## One-time setup (admin)

### 1. Firebase
1. https://console.firebase.google.com → **Create a project**.
2. **Authentication → Get started → Sign-in method → Email/Password → Enable → Save.**
   Leave **Settings → User actions → Enable create (sign-up)** switched **on**: the app uses it to
   create logins for team members. It's safe: a login with no entry in the `staff` list can't see anything.
3. **Firestore Database → Create database** → keep Database ID `(default)` → location `asia-south1` → **production mode**.
   (If the database ends up with another name, put that name in `config.js` as `FIRESTORE_DATABASE`.)
4. Firestore → **Rules** tab → paste all of `firestore.rules` → **Publish**.
5. **Project settings → Your apps → Web (`</>`)** → register → copy the config values into `config.js`.

### 2. Add yourself as admin (once)
1. **Authentication → Users → Add user**: your email + a password.
2. **Firestore → Data → Start collection** `staff` → Document ID: your email, **all lowercase** →
   fields `name` (string, your name) and `role` (string, `admin`).

Repeat for any other admin. Team members are added inside the app (next step), not here.

### 3. Put it online
1. GitHub repo → **Settings → Pages → Deploy from a branch → `main` / root → Save.**
2. Firebase → **Authentication → Settings → Authorized domains → Add** `<your-github-username>.github.io`.
3. Open `https://<your-github-username>.github.io/<repo-name>/`, tap **Admin sign-in**, sign in.

## Daily use (admin)
- **Team tab:** type a name and WhatsApp number → **Add** → **Send link on WhatsApp**. That's their whole setup.
- **Assign tab:** tap who, when, type a title and tasks in English → **Assign in English** or **Assign in हिंदी** → **Send on WhatsApp**.
  With Hindi, the app translates it (free Google Translate) and shows the Hindi so you can correct any word before it goes out.
  The team member's screen and WhatsApp message are in Hindi; your Progress screen shows the English with the Hindi underneath.
- **Progress tab:** see who has finished what. Tap a list for **Remind on WhatsApp** or **Delete**.
- Someone leaves or loses their phone: **Team → Remove**. Their link stops working at once.
  To give them a new link, add them again.

## For team members
Tap the link in WhatsApp. That's it. Every to-do message includes the same link.
Optional: put it on the home screen like an app. Android: tap **Install** on the banner.
iPhone: **Share → Add to Home Screen**.

## Notes
- A personal link works like a key to that person's list, so it shouldn't be forwarded. Removing the person cancels it.
- Works without internet once opened: ticks are saved and sync when the phone is back online.
- Lists load one month at a time, which keeps the app well inside Firebase's free daily limits.
- Optional later: package it for the Google Play Store with https://www.pwabuilder.com (one-time $25 Google developer fee).
