# Team To-Do

A simple to-do app for the team. Admins assign checklists; team members tick them off on their phones.
Installs on the phone like an app (from the browser, no app store). Free: Firebase (logins + data) and GitHub Pages (hosting).

| Who | Sees |
|-----|------|
| admin | **Assign** (pick people, day, title, tasks) · **Progress** (each person's lists by day, remind on WhatsApp, delete) · **My list** (if something is assigned to them) |
| team | Only their own lists: *Not finished yet*, *Today*, *Coming up* — with big tick boxes |

## One-time setup

### 1. Firebase
1. https://console.firebase.google.com → **Create a project**.
2. **Authentication → Get started → Sign-in method → Email/Password → Enable.**
   Then **Settings → User actions** → untick **Enable create (sign-up)**.
3. **Firestore Database → Create database** → keep Database ID `(default)` → location `asia-south1` → **production mode**.
   (If the database ends up with another name, put that name in `config.js` as `FIRESTORE_DATABASE`.)
4. Firestore → **Rules** tab → paste all of `firestore.rules` → **Publish**.
5. **Project settings → Your apps → Web (`</>`)** → register → copy the config values into `config.js`.

### 2. Add people
For each person:
1. **Authentication → Users → Add user** (email + starting password).
2. **Firestore → Data →** collection `staff` → **Add document**:
   - Document ID: their email, **all lowercase**
   - `name` (string): their name
   - `role` (string): `admin` or `team`
   - `phone` (string, optional): their WhatsApp number, e.g. `9876543210`, so WhatsApp messages open straight to their chat

People appear in the admin's **Who?** list straight away — they don't need to sign in first.

### 3. Put it online
1. GitHub repo → **Settings → Pages → Deploy from a branch → `main` / root → Save.**
2. Firebase → **Authentication → Settings → Authorized domains → Add** `<your-github-username>.github.io`.
3. The app is at `https://<your-github-username>.github.io/<repo-name>/`.

### 4. Install on phones
Open the link and sign in, then:
- **Android (Chrome):** tap **Install** on the banner, or menu ⋮ → **Install app**.
- **iPhone (Safari):** Share button → **Add to Home Screen**.

## Notes
- Works without internet once opened: ticks are saved and sync when the phone is back online.
- Lists load one month at a time, which keeps the app well inside Firebase's free daily limits.
- Optional later: package it for the Google Play Store with https://www.pwabuilder.com (one-time $25 Google developer fee).
