# Database foundation

The pulled remote baseline is preserved. The following ordered migrations follow it:

1. 20260929124402_create_profiles.sql: one profile per Auth user, automatic profile creation and existing-account backfill, private trigger helpers, and explicit privileges.
2. 20260929124405_create_themes.sql: user-owned reusable themes with a required name and optional emoji.
3. 20260929124406_create_seasons.sql: season dates, length snapshots, lifecycle rules, and one active season per user.
4. 20260929130025_add_profile_name.sql: required nonblank, non-unique profile names and Auth name metadata handling.

All tables use RLS with authenticated owner-only CRUD policies. Anonymous access and administrative table privileges are revoked. Future trusted service-role operations must receive explicit grants; BYPASSRLS does not substitute for table privileges.

Profiles use user_id as their primary key and have a required name plus timestamps. Names do not have to be unique. New Auth accounts must include a nonblank string in user_metadata.name (Supabase JS signup: options.data.name; Auth admin creation: user_metadata.name). Missing or blank names reject account creation atomically. Later profile-name edits happen on profiles, without syncing back to Auth metadata. Auth remains the source of account credentials. The name migration assumes no existing profiles; do not apply it to populated profiles without first planning a real-name backfill. Theme and season names are not identifiers and need not be unique. Themes and seasons reference Auth users with restrictive deletion to prevent accidental history loss. Future theme references must enforce same-owner relationships and prevent deletion while referenced.

Seasons may start as draft or active. Drafts may be activated or closed; active seasons may be closed but cannot return to draft. Only drafts may be deleted. Closing sets the timestamp in the database; all later updates and deletes are rejected, including writes that bypass RLS. End dates, week numbers, and future XP balances are derived rather than stored.

Private trigger functions manage immutable identity/creation fields and update timestamps. The only security-definer function is the Auth trigger that creates a profile from NEW.id; API roles cannot invoke it directly.

## Local workflow

With the local Supabase stack running on local-network:

    pnpm exec supabase migration up --local
    pnpm test:db
    pnpm db:types
    pnpm typecheck
    pnpm lint
    pnpm test
    pnpm build

Database tests use pgTAP, two simulated authenticated users, anonymous access, and transactional fixtures that are rolled back. Generated types live at src/types/database.types.ts; use Database with createClient<Database> when adding the Supabase client.

Inspect actual published ports after starting the stack. Attaching to local-network alone does not prove localhost-only bindings: published ports must show 127.0.0.1 (or ::1), not 0.0.0.0 or [::].

## Hosted deployment

These migrations have only been applied locally. Confirm the linked project and review the pending migrations before deployment:

    pnpm exec supabase db push --dry-run
    pnpm exec supabase db push

Do not reset the linked database. Keep applied migrations immutable and make later corrections in new migration files. This increment does not introduce authentication UI, business forms, XP tables, or seed production data.
