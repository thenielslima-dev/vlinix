# Vlinix

Vlinix is a Flutter web app for auto detailing business management. It includes authentication, client records, vehicles, services, appointments, expenses, dashboard views, admin controls, avatar upload, and multilingual UI support.

## Stack

- Flutter / Dart
- Supabase Auth
- Supabase Postgres
- Supabase Storage
- Vercel deployment for the web build

## Required Environment Variables

Create these variables in Vercel before deploying:

```env
SUPABASE_URL=https://hjjsohmziddrlqggaimm.supabase.co
SUPABASE_ANON_KEY=your_supabase_publishable_or_anon_key
```

Use the Supabase publishable key (`sb_publishable_...`) or the legacy `anon public` key. Never use `service_role` or `sb_secret_...` in this Flutter web app.

## Vercel

This repository includes `vercel.json`, so Vercel can use the correct Flutter web build settings automatically.

If filling the Vercel screen manually, use:

```text
Application Preset: Other
Root Directory: ./
Build Command: bash scripts/vercel-build.sh
Output Directory: build/web
Install Command: echo "Flutter dependencies are installed during build"
```

## Local Web Build

```bash
flutter pub get
flutter build web --release \
  --dart-define=SUPABASE_URL=https://hjjsohmziddrlqggaimm.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_supabase_publishable_or_anon_key
```

## Notes for Reviewers

The deployed app requires a configured Supabase project and valid test account credentials. Database access is protected by Supabase Row Level Security policies.
