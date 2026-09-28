# Personal Study Curriculum App — Technical Best Practices

Use this file as implementation guidance for the V1 build.

## 0.Workflow & Delivery

### Branch Workflow

Always create a new branch from `release`:

```bash
git checkout release
git pull
git checkout -b short-description
```

Open pull requests back into `release`. Do not work directly on `release`.
Use short, descriptive branch names, for example:

- `season-creation`
- `subject-progress`
- `xp-ledger`
- `reward-redemption`
- `fix-session-duration`

### Work in Small, Reviewable Increments

Prefer small, focused changes over large multi-feature implementations.

For each branch:

- Implement one clear feature, fix, or architectural change.
- Avoid unrelated refactors.
- Keep PRs easy to review.
- Do not change established architecture unless the task requires it.

If a feature requires database, domain, and UI changes, implement them together as one coherent vertical slice where practical.

Example:

`Create Subject`

1. database migration
2. generated database types
3. validation schema
4. query/mutation
5. UI
6. tests

### Before Writing Code

Before implementing a feature:

1. Read the relevant section of the PRD.
2. Inspect existing related code and database schema.
3. Reuse existing patterns and components where appropriate.
4. Identify whether the feature requires:
   - schema changes
   - RLS changes
   - Postgres/RPC logic
   - frontend queries/mutations
   - UI changes
   - tests

Do not invent requirements that conflict with the PRD.

If the PRD is genuinely ambiguous, surface the ambiguity rather than silently making a major product decision.

### Database Changes

All Supabase schema changes must be made through migrations.

Do not make undocumented manual changes to the remote database.

Database changes include:

- tables
- columns
- constraints
- enums
- indexes
- RLS policies
- database functions
- triggers

After changing the schema:

- apply/test the migration locally
- regenerate Supabase TypeScript types
- update affected application code
- test RLS and business rules

Never modify an existing migration that may already have been applied remotely. Create a new migration instead.

### Database Types

Use generated Supabase database types as the source of truth for database records.

Do not manually duplicate database row types.

Regenerate types whenever the schema changes.

Derived UI types and form input types may be defined separately when needed.

### Environment Variables

Never commit secrets.

Frontend environment variables may include only values safe for browser exposure, such as:

- Supabase URL
- Supabase publishable/anon key

Never expose:

- Supabase service-role key
- database password
- secret keys

Keep `.env` files out of Git and maintain an `.env.example` containing variable names only.

### Data Fetching

Use TanStack Query for Supabase server state.

Prefer:

- feature-specific query keys
- reusable query/mutation functions
- targeted cache invalidation after mutations

Do not add another global server-state library.

Use local React state only for temporary UI state.

### Forms and Validation

Use TanStack Form + Zod for forms.

Validation should exist at the appropriate layers:

- Zod → user input and UX validation
- PostgreSQL constraints / RLS / RPC → data integrity and security

Do not rely on frontend validation alone for important business rules.

### Business Logic

Keep domain calculations outside UI components.

Examples:

- XP calculations
- session duration penalties
- Subject progress
- Subject derived status
- Reward unlock state
- Career level
- suggested Milestone weeks

Prefer pure functions where possible and cover important rules with unit tests.

Do not duplicate the same calculation in multiple components.

### Historical Data

Do not allow current Settings to retroactively change historical records.

When a configurable default matters historically, save a snapshot onto the created record.

Examples:

- Season week count
- Study Session planned minutes
- XP awarded
- Reward redemption cost

Closed Seasons must remain historically accurate.

### Testing

Before considering a branch complete:

- run TypeScript checks
- run linting
- run relevant tests
- confirm the app builds successfully
- manually test the primary user flow
- test important empty, loading, and error states

For database work, also verify:

- RLS behavior
- relevant constraints
- RPC success and failure cases

Prioritize tests for business-critical logic over snapshot tests.

### Completion Checklist

Before opening a PR:

- Feature matches the PRD.
- No unrelated changes are included.
- Database changes use migrations.
- Supabase types are regenerated if needed.
- RLS is added or updated where required.
- No secrets are committed.
- Relevant tests pass.
- Type checking passes.
- Production build succeeds.
- New behavior works on desktop and mobile layouts.
- Historical data behavior has been considered.

## 1. Keep the Architecture Simple

Use:

- React + TypeScript + Vite
- Tailwind CSS v4
- ShadCN
- TanStack Router
- TanStack Query
- TanStack Form
- Zod
- Supabase
- Netlify

Do not introduce:

- a custom Node API
- TanStack Start
- server-side rendering
- Netlify Functions

unless a concrete requirement appears that Supabase cannot handle cleanly.

Supabase is the backend for V1.

---

## 2. Database-First Domain Modeling

Use normalized relational tables and foreign keys.

Prefer:

- UUID primary keys
- explicit join tables for many-to-many relationships
- enums or constrained text fields for stable statuses
- database timestamps using `timestamptz`

Never use human-readable names as identifiers.

Example:

- two Subjects may both be named `Reading Music`
- they remain distinct because they have different UUIDs and Season relationships

---

## 3. Store Historical Snapshots Where Defaults May Change

Settings define defaults for future records.

Historical records must preserve the values that were true when they were created.

Examples:

### Season

Store `week_count` directly on the Season.

Do not derive old Seasons from a current global default.

### Study Session

Store:

- session preset reference or label
- planned minutes snapshot

If `Long` later changes from 90 to 75 minutes, existing sessions must remain 90 minutes.

Apply the same principle to any configurable value that needs historical accuracy.

---

## 4. Derive Values Instead of Duplicating Them

Do not persist values that can reliably be calculated.

Examples:

Subject progress:

`completed modules / total modules`

Season XP available:

`positive Season XP - redeemed Season XP`

Career XP:

`sum of all positive XP transactions`

Current level:

highest Level where:

`career_xp >= min_xp`

Avoid storing mutable cached totals unless performance later proves it is necessary.

---

## 5. Use an Immutable XP Ledger

`xp_transactions` is the source of truth for XP.

Never directly mutate fields such as:

- `career_xp`
- `season_xp`
- `available_xp`

Each earning or spending event creates a transaction.

Recommended fields:

- `id`
- `user_id`
- `season_id`
- `amount`
- `transaction_type`
- `source_type`
- `source_id`
- `description`
- `created_at`

Positive amount = earned XP.

Negative amount = spent XP.

Career XP sums only positive transactions.

Do not delete XP transactions during normal app usage.

If correction is required, prefer a compensating transaction or a controlled correction workflow.

---

## 6. Make Multi-Write Business Actions Atomic

Use Supabase Postgres functions / RPC for actions that require multiple dependent writes.

Required atomic operations include:

- redeem reward
- complete study session
- complete milestone
- complete field trip
- complete side quest

Do not rely on a sequence of independent browser writes for these actions.

Example reward redemption must atomically:

1. calculate available XP
2. validate sufficient balance
3. validate one-time redemption rules
4. insert redemption
5. insert negative XP transaction

This prevents race conditions, stale balances, and partial writes.

---

## 7. Enforce Important Rules in the Database

Client-side validation improves UX.

Database validation protects data integrity.

Important rules to enforce at the database level where practical:

- authenticated owner only
- maximum 4 Subjects per Season
- unique Subject name within a Season
- Study Session targets Module XOR Milestone
- no negative actual duration
- no reward redemption above available Season XP
- one-time reward cannot be redeemed twice
- closed Season-owned records cannot be modified
- Side Quest difficulty uses known allowed values
- stable status values use enums/check constraints

Do not trust the browser as the final authority.

---

## 8. Row Level Security Is Mandatory

Enable RLS on all exposed user-owned tables.

Every user-owned row should include:

`user_id uuid references auth.users(id)`

Core policy rule:

`auth.uid() = user_id`

Create policies for:

- SELECT
- INSERT
- UPDATE
- DELETE

For INSERT/UPDATE, use appropriate `WITH CHECK` conditions.

Even though V1 has one user, implement authorization properly.

---

## 9. Never Expose Privileged Supabase Credentials

Frontend may use:

- Supabase project URL
- Supabase publishable / anon key

Frontend must never contain:

- service-role key
- secret key
- database password

Service-role access bypasses RLS.

If privileged credentials are ever required later, they must live in a trusted server environment.

---

## 10. Use Supabase Auth Directly

Use Supabase Email + Password authentication.

Keep auth flow minimal:

- login
- logout
- authenticated route guard

After the owner account is created, public signup UI is unnecessary.

Do not build custom password/session handling.

---

## 11. Keep TanStack Query as the Server-State Layer

Use TanStack Query for:

- Supabase reads
- mutations
- cache invalidation
- loading/error states

Do not duplicate Supabase data into unnecessary global client stores.

Avoid adding Zustand, Redux, or another state library unless a clear UI-only state requirement emerges.

Use local React state for temporary UI state.

---

## 12. Use TanStack Router for Typed Routing

Use route structure that mirrors the product information architecture.

Example:

- `/`
- `/season/$seasonId`
- `/season/$seasonId/subjects`
- `/season/$seasonId/planner`
- `/season/$seasonId/review`
- `/courses`
- `/courses/$courseId`
- `/library`
- `/quests/side`
- `/quests/field-trips`
- `/rewards`
- `/progress/xp`
- `/progress/badges`
- `/settings`

Protect authenticated routes at the router level.

---

## 13. Validate Forms with Zod

Use Zod schemas as the shared validation source for form input.

Validate:

- required strings
- URL format
- positive durations
- XP values
- week numbers
- enum/status values
- date relationships where useful

Prefer schemas that can be reused between form validation and mutation input validation.

---

## 14. Keep UI Components Focused

Prefer small domain-focused components.

Examples:

- `SubjectProgress`
- `XPBalance`
- `RewardCard`
- `StudySessionCard`
- `MilestoneCard`
- `WeeklyPlannerDay`
- `ResourceStatusBadge`

Avoid large page components containing:

- fetching
- mutation logic
- business rules
- rendering

all in one file.

Separate:

- data access
- domain calculations
- mutations
- presentation

without over-engineering.

---

## 15. Centralize Domain Calculations

Pure business rules should live in reusable utilities or domain modules.

Examples:

- study duration penalty
- final Study Session XP
- suggested Milestone target week
- Subject derived status
- progress percentage
- Reward lock state
- level from Career XP

Write unit tests for these rules.

Do not repeat XP calculations inside multiple UI components.

---

## 16. Use Database Types in TypeScript

Generate Supabase TypeScript types from the database schema.

Use those generated types rather than manually redefining database records.

Keep separate types for:

- database rows
- form inputs
- derived UI view models

Regenerate types after schema changes.

---

## 17. Manage Schema Changes with Migrations

Do not make undocumented production schema edits manually.

Use Supabase migrations for:

- tables
- columns
- constraints
- indexes
- enums
- RLS policies
- database functions

Commit migrations to Git.

The repository should be sufficient to recreate the database structure.

---

## 18. Add Indexes for Common Relationships and Filters

At minimum, index frequently queried foreign keys and filters such as:

- `user_id`
- `season_id`
- `subject_id`
- `course_id`
- `theme_id`
- `planned_date`
- `status`
- `created_at`

Composite indexes may be useful for patterns such as:

- current user + active Season
- Season + planned date
- Subject + module order

Avoid premature indexing beyond real query patterns.

---

## 19. Prefer Soft Archival Over Deletion for Long-Lived Learning Data

Use explicit archived states where appropriate for:

- Courses
- Resources
- Rewards

Avoid destructive deletion of:

- closed Seasons
- XP Transactions
- Badge Awards
- completed activity history

If deletion exists, protect entities that have important historical references.

---

## 20. Closed Seasons Must Be Immutable

Once a Season is `closed`:

Prevent edits to:

- Season details
- Subjects
- Modules
- Milestones
- Study Sessions
- Weekly Reviews
- Season-specific Reward configuration

Global entities remain editable.

Prefer enforcing this with database logic in addition to hiding edit controls in the UI.

---

## 21. Treat Dates and Weeks Carefully

Store timestamps in UTC.

Render dates in the user's local timezone.

Season week number should be derived consistently from:

- Season start date
- target date

Do not rely on browser locale string parsing.

Use a lightweight date utility only if needed; avoid unnecessary date libraries.

---

## 22. Keep V1 Mobile-Friendly, Not Mobile-First Complex

Use responsive layouts.

Priority screens:

- Dashboard
- Today / Weekly Planner
- Study Session completion
- Reward Shop

Make these comfortable on phone and desktop.

Do not build native mobile functionality.

---

## 23. Build for Failure States

Every mutation should have:

- loading state
- error state
- success feedback
- disabled repeat-submit behavior

Important examples:

- reward redemption
- Study Session completion
- Season closure

Never optimistically display irreversible outcomes before the database confirms success unless rollback is handled correctly.

---

## 24. Testing Priorities

Prioritize tests around business rules rather than visual snapshots.

Unit test:

- XP deduction
- XP floor at zero
- Subject progress calculation
- derived Subject status
- Reward unlock logic
- level calculation
- suggested Milestone week logic

Integration/database test:

- RLS blocks unauthorized access
- insufficient XP blocks Reward redemption
- one-time Reward cannot be redeemed twice
- closed Seasons reject mutation
- atomic completion functions create the correct XP transaction

---

## 25. Keep Dependencies Lean

Before adding a package, ask:

- does React already solve this?
- does TanStack already solve this?
- does Supabase already solve this?
- is the dependency meaningfully reducing complexity?

Avoid adding:

- redundant state libraries
- date libraries for trivial formatting
- generic backend frameworks
- ORM layers over Supabase
- unnecessary animation libraries

V1 should remain easy to understand and maintain.

---

## 26. Suggested Project Structure

A reasonable starting point:

```text
src/
  components/
  features/
    auth/
    seasons/
    courses/
    subjects/
    modules/
    milestones/
    planner/
    library/
    quests/
    rewards/
    progress/
    settings/
  routes/
  lib/
    supabase/
    query/
    validation/
    domain/
  types/
```

Within each feature, keep:

- queries
- mutations
- schemas
- components
- domain helpers

close to the feature when practical.

Avoid creating excessive abstraction layers before they are needed.

---

## 27. Recommended Build Order

1. Project setup and routing
2. Supabase project + migrations
3. Authentication
4. RLS
5. Seasons
6. Courses / Themes
7. Subjects
8. Modules
9. Milestones
10. Study Sessions / Weekly Planner
11. XP Ledger
12. Session completion RPC
13. Library
14. Field Trips
15. Side Quests
16. Rewards + redemption RPC
17. Levels / Badges
18. Weekly Reviews
19. Season Review / closure
20. Dashboard polish
21. Responsive QA
22. Production deployment

Keep each stage working before proceeding.

---

## 28. V1 Engineering Principle

Prefer the simplest implementation that preserves:

- historical correctness
- data integrity
- secure access
- atomic XP/reward behavior
- clear domain relationships

Do not optimize for hypothetical future scale.

Optimize for a small, reliable personal app that remains easy to understand six months from now.

## 29. Package Management & Supply Chain Safety

Use pnpm only.

Do not use npm, yarn, bun, or `npx` unless explicitly approved.

Before installing dependencies, verify that `pnpm-workspace.yaml` contains the project's security settings.

Do not:

- disable `minimumReleaseAge`
- weaken `minimumReleaseAgeStrict`
- add packages to `minimumReleaseAgeExclude`
- disable `blockExoticSubdeps`
- broadly enable dependency lifecycle/build scripts

without explicit approval.

Prefer exact direct dependency versions.

If a dependency requires an install/build script:

1. identify the package
2. verify that the script is expected for the dependency
3. allow only that package
4. do not globally enable build scripts

Do not install dependencies that are not required by the current implementation.

Before adding a new package, check whether the existing stack already provides the required functionality.

After dependency changes:

- inspect `package.json`
- inspect `pnpm-lock.yaml`
- run `pnpm audit`
- run typecheck/tests/build
