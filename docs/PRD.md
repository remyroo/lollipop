# Personal Study Curriculum App — V1 Product Requirements Document

## 1. Product Summary

A single-user personal study planner inspired by a season-based curriculum system.

The app helps the user:

- Create finite study **Seasons** with configurable lengths.
- Enroll in up to 4 **Subjects** per season.
- Organize long-term areas of study as optional **Courses**.
- Break each Subject into approximately 6 **Modules**.
- Define 1–2 **Milestones** per Subject as evidence of learning.
- Plan study activity by week and day without building a full calendar.
- Track planned vs actual study duration.
- Maintain a permanent **Library** of learning resources.
- Track **Field Trips** and **Side Quests**.
- Earn and spend **XP** through a season-specific reward economy.
- Accumulate permanent **Career XP**, levels, and badges across seasons.
- Complete weekly and season reviews.
- Preserve all closed-season history without later settings changes affecting it.

V1 is intentionally a focused planner/tracker, not a notes app, social product, LMS, or calendar replacement.

---

## 2. Target User

Single authenticated user.

No collaboration, sharing, multi-user roles, public profiles, or admin tooling are required in V1.

---

## 3. Core Product Concepts

### Season

A finite study cycle.

Each Season has:

- Name
- Start date
- Configurable number of weeks
- Status: `draft | active | closed`
- Up to 4 Subjects
- Season XP earned
- Season XP spent
- Season XP available
- Weekly reviews
- Final season review

Season length is stored on each Season record.

Changing the default length for future seasons must never modify existing or closed Seasons.

Closed Seasons are historical and read-only.

---

### Course

A long-term area of study that may span multiple Seasons.

Examples:

- Music Theory
- Graphic Design
- Swahili Cooking

Fields:

- Name
- Theme
- Description, optional
- Status: `wishlist | in_progress | completed | archived`

A Course may contain many Subjects across different Seasons.

Course status is user-managed and must not be automatically set to `completed` when a Subject is completed.

A Subject does not have to belong to a Course.

---

### Subject

A season-specific syllabus.

Examples:

- Reading Music: Beginner
- Bauhaus and Modernism
- Stew Fundamentals

Fields:

- Name
- Season
- Course, optional
- Theme
- Status: `enrolled | in_progress | on_hold | completed`
- Badge name
- Badge emoji
- 1–2 Milestones
- Modules
- Linked resources

Subject status should normally be derived from module progress:

- 0 completed modules → `enrolled`
- At least 1 but not all modules complete → `in_progress`
- All modules complete → `completed`

`on_hold` is a manual override.

Subject progress is based only on Modules:

`completed modules / total modules`

Example:

- 3 of 6 Modules complete → 50%

Milestones are shown separately and do not affect the Subject progress percentage.

Duplicate Subject names are allowed across different Seasons.

---

### Theme

A global category used across learning objects.

Examples:

- 🎨 Design
- 🎵 Music
- 🍳 Cooking
- 🌿 Nature
- 📚 Literature

Themes can be linked to:

- Courses
- Subjects
- Resources
- Field Trips
- Side Quests

When creating a Subject from a Course, prefill the Course Theme but allow it to be changed.

---

### Module

One concrete study sitting within a Subject.

Fields:

- Subject
- Title
- Sort order
- Status: `not_started | complete`

A Subject will typically contain 6 Modules, but V1 should not hard-code exactly 6.

Completing a Module should update Subject progress automatically.

---

### Milestone

Evidence that learning happened.

Examples:

- Write a short article
- Complete a painting
- Play one song on guitar
- Hold a 10-minute conversation in a foreign language
- Complete a quiz

Fields:

- Subject
- Title
- Description / evidence expected
- Order: 1 or 2
- Target week
- Due date
- Status: `not_started | in_progress | completed`
- XP award
- Completed at

Guidance:

- Milestone 1 should default to approximately 40% through the Season.
- Milestone 2 should default to approximately 80–90% through the Season.
- For an 8-week Season, sensible defaults are approximately Week 3 and Week 7.
- Defaults must be editable.

A Milestone may require one or multiple Study Sessions.

Completing a Milestone awards a milestone XP bonus separately from XP earned for the Study Sessions used to work on it.

---

### Study Session

A planned block of study work.

A Study Session should target either:

- a Module, or
- a Milestone

It should normally not target both.

Fields:

- Subject
- Module, nullable
- Milestone, nullable
- Planned date
- Session preset
- Planned minutes
- Actual minutes
- Completed at
- XP awarded

Default session presets:

- Mini → 15 minutes
- Short → 30 minutes
- Long → 90 minutes

Session presets are editable in Settings.

When a Study Session is scheduled, save the planned minutes as a snapshot. If session preset defaults change later, historical sessions must not change.

Going over the planned duration does not award additional XP.

Going under the planned duration reduces XP using:

`floor((planned_minutes - actual_minutes) / 10) * 2`

Only apply the deduction when actual duration is lower than planned duration.

Final session XP must never be negative:

`max(0, base_xp - deduction)`

---

## 4. Weekly Planning

The app should provide a lightweight weekly schedule, not a full calendar system.

The user should be able to open the app on a given day and quickly see:

- Current Season
- Current week number
- Today’s planned study sessions
- Subject
- Module or Milestone
- Session type
- Planned duration
- Completion state

Example:

**Tuesday · Week 3**

- Long · 90 min  
  Music  
  Reading Music: Beginner  
  Module 4 — Note Values

- Short · 30 min  
  Design  
  Bauhaus and Modernism  
  Milestone — Draft article

No external calendar sync is required in V1.

---

## 5. Weekly Review

Each Season week has one optional Weekly Review.

Fields:

- Season
- Week number
- What actually happened
- What I would change
- Optional brief note

Weekly XP is derived from XP transactions for that week and should not be manually entered.

---

## 6. Library

A permanent global resource library.

Fields:

- Title
- Author / creator
- Type
- URL, optional
- Notes, optional
- Status
- Themes
- Linked Courses
- Linked Subjects

Resource types:

- `book`
- `course`
- `article`
- `video`
- `podcast`
- `website`
- `other`

Resource statuses:

- `not_started`
- `in_progress`
- `finished`
- `archived`

Resources can belong to multiple Courses and Subjects.

A Subject may additionally identify linked resources as:

- Anchor resource
- Supporting resource

No file uploads are required.

The Library overview should make it easy to filter or group by status.

---

## 7. Field Trips

Field Trips are standalone learning activities.

Fields:

- Name
- Date
- Theme
- Subject, optional
- Course, optional
- Notes / what I noticed
- Status
- XP award

Completing a Field Trip creates an XP transaction.

---

## 8. Side Quests

Side Quests are global, optional learning challenges that persist across Seasons.

Fields:

- Name
- Description, optional
- Theme
- Date, optional
- Status: `available | in_progress | completed`
- Repeatable: boolean
- Difficulty: `easy | medium | hard | epic`
- XP award

Suggested defaults:

- Easy → 40 XP
- Medium → 75 XP
- Hard → 100 XP
- Epic → 200 XP

Repeatable Side Quests should use separate completion records rather than resetting the same completion state.

Each completion can generate its own XP transaction.

---

## 9. XP System

XP is ledger-driven.

Do not store mutable XP totals as the source of truth.

Every earning or spending event creates an immutable XP Transaction.

Examples:

- +20 Study Session
- +100 Resource finished
- +150 Milestone completed
- +75 Side Quest completed
- +50 Field Trip completed
- -150 Reward redeemed

### Derived balances

**Career XP**  
All positive XP ever earned.

Career XP never decreases.

**Season XP Earned**  
All positive XP transactions for the active Season.

**Season XP Spent**  
Total absolute value of reward redemption transactions for the active Season.

**Season XP Available**  
`Season XP Earned - Season XP Spent`

Rewards can only be redeemed using the current Season’s available XP.

XP from a previous closed Season contributes to Career XP but cannot be spent in a later Season.

---

## 10. XP Rules

XP defaults should be configurable.

Initial defaults may include:

- Mini Study Session
- Short Study Session
- Long Study Session
- Book finished
- Milestone completed
- Subject completed
- Field Trip
- Side Quest

Settings should use the term **XP Rules**, not “Activity Types”.

---

## 11. Levels

Career rank is based on Career XP.

Default levels:

| Level      | Minimum Career XP |
| ---------- | ----------------: |
| Apprentice |                 0 |
| Novice     |               150 |
| Adept      |               300 |
| Scholar    |               600 |
| Sage       |             1,000 |
| Megamind   |             2,000 |
| Avatar     |             3,000 |

Levels should be configurable.

Changing a Level threshold should affect current rank calculation but must not alter historical XP transactions.

---

## 12. Badges

Each Subject may define:

- Badge name
- Badge emoji

When the Subject is completed, create a permanent Badge Award.

Badges persist across Seasons.

No uploaded badge images are required.

---

## 13. Rewards

Rewards are global and persistent.

Fields:

- Name
- Emoji
- Description, optional
- XP cost
- Repeatable: boolean
- Active: boolean

Each Season can choose which Rewards are active.

A Reward is unlocked when:

`Season XP Available >= Reward XP Cost`

Rules:

- User cannot redeem more XP than is currently available in the active Season.
- One-time Rewards cannot be redeemed more than once.
- Repeatable Rewards remain redeemable as long as sufficient XP is available.
- Reward redemption creates:
  1. a Reward Redemption record
  2. a negative XP Transaction
- Redeeming a Reward does not reduce Career XP.

The database must enforce sufficient available XP at redemption time.

---

## 14. Season Review and Closure

A Season Review may contain:

- Season XP earned
- Season XP spent
- Level reached
- Badges earned
- Resources finished
- Subject that surprised me
- What I made this Season
- What I would balance differently
- Note to next-season self

Closing a Season:

- Sets status to `closed`
- Stores closed timestamp
- Makes Season-owned records read-only
- Preserves all Subjects, Modules, Milestones, Study Sessions, Reviews, and XP history

Global entities remain reusable:

- Courses
- Themes
- Resources
- Rewards
- Side Quests
- XP Rules
- Levels
- Badges / Career XP history

Optional V1 convenience:

- “Create next Season”
- “Copy Subject structure from previous Season” without copying completion progress

---

## 15. Dashboard

The default dashboard should prioritize the active Season.

Show:

### Current Season

- Name
- Week X of Y
- Season XP earned
- Season XP spent
- Season XP available
- Career XP
- Current level

### Today / This Week

- Planned Study Sessions
- Subject
- Module or Milestone
- Session type
- Planned duration
- Completion state

### Subject Progress

For every Subject in the active Season:

- Name
- Course, if any
- Theme
- Module progress bar
- Modules completed / total
- Milestones completed / total
- Status

### Reward Progress

- Active Rewards
- Locked / unlocked state
- XP remaining to unlock locked Rewards

---

## 16. Navigation

Suggested V1 navigation:

- Dashboard
- Current Season
  - Overview
  - Subjects
  - Weekly Planner
  - Weekly Review
  - Season Review
- Courses
  - All Courses
  - Wishlist
  - Archived
- Library
- Quests
  - Side Quests
  - Field Trips
- Rewards
  - Reward Shop
  - Redemption History
- Progress
  - XP Ledger
  - Levels
  - Badges
- Settings
  - Season Defaults
  - Session Presets
  - XP Rules
  - Levels
  - Themes

---

## 17. Suggested Database Tables

Core tables:

- `profiles`
- `themes`
- `courses`
- `seasons`
- `subjects`
- `modules`
- `milestones`
- `study_sessions`
- `weekly_reviews`
- `resources`
- `resource_courses`
- `resource_subjects`
- `field_trips`
- `side_quests`
- `side_quest_completions`
- `rewards`
- `season_rewards`
- `reward_redemptions`
- `xp_rules`
- `xp_transactions`
- `levels`
- `badge_awards`

Most user-owned tables should include:

- `id uuid primary key`
- `user_id uuid references auth.users(id)`
- `created_at timestamptz`
- `updated_at timestamptz`

Use UUID relationships internally. Never use names as record identifiers.

---

## 18. V1 Technical Stack

Preferred V1 stack:

- React
- TypeScript
- Vite
- Tailwind CSS v4
- ShadCN
- TanStack Router
- TanStack Query
- TanStack Form
- Zod
- Supabase
  - Postgres
  - Auth
  - Data API
  - Row Level Security
  - Postgres functions / RPC
- Netlify static hosting

Do not use TanStack Start in V1 unless a concrete server-side requirement emerges.

---

## 19. Authentication

Single-user authentication using Supabase Email + Password.

Requirements:

- No public registration flow required after the owner account exists.
- App routes require authentication.
- Use Supabase session management.
- Never expose service-role credentials in the frontend.

---

## 20. Security Requirements

Enable Row Level Security on all exposed user-owned tables.

Core authorization rule:

`auth.uid() = user_id`

Policies must cover:

- SELECT
- INSERT
- UPDATE
- DELETE

Use a Supabase publishable key in the frontend.

Never place:

- database password
- secret key
- service role key

in client-side code.

Closed Season data should also be protected against modification through database-level logic or policies where practical.

---

## 21. Database Operations That Must Be Atomic

Use Postgres functions / RPC for business operations where multiple writes must succeed or fail together.

### Redeem Reward

Must:

1. Calculate current Season available XP.
2. Verify sufficient XP.
3. Verify one-time Reward has not already been redeemed.
4. Create Reward Redemption.
5. Create negative XP Transaction.
6. Commit atomically.

### Complete Study Session

Should:

1. Validate actual duration.
2. Calculate under-time penalty.
3. Calculate final XP.
4. Mark Study Session complete.
5. Mark Module complete if the session targets a Module.
6. Create XP Transaction.
7. Commit atomically.

Milestone sessions do not automatically complete the Milestone.

### Complete Milestone

Should:

1. Mark Milestone complete.
2. Set completed timestamp.
3. Create milestone XP Transaction.
4. Commit atomically.

### Complete Side Quest

Should:

1. Create completion record.
2. Create XP Transaction.
3. Commit atomically.

### Complete Field Trip

Should:

1. Mark Field Trip complete.
2. Create XP Transaction.
3. Commit atomically.

---

## 22. Explicitly Out of Scope for V1

Do not build:

- Social features
- Collaboration
- Multi-user roles
- Public profiles
- Native mobile apps
- Calendar sync
- Notifications / reminders
- File uploads
- Rich-text note-taking
- AI-generated curricula
- Complex analytics
- Images for resources or badges
- Third-party integrations

Keep V1 focused on planning, completing, tracking, XP, and reflection.

---

## 23. V1 Success Criteria

V1 is successful when the user can:

1. Sign in securely.
2. Create a Season with a configurable number of weeks.
3. Create or select Courses.
4. Create up to 4 Subjects for a Season.
5. Add Modules and 1–2 Milestones to Subjects.
6. Schedule Module or Milestone Study Sessions by day.
7. Log actual duration and complete Study Sessions.
8. See Subject progress update automatically.
9. Earn XP automatically from completed activities.
10. Add and track Library resources.
11. Create and complete Field Trips and Side Quests.
12. Create Rewards and activate them for a Season.
13. Redeem only unlocked Rewards with sufficient Season XP.
14. See Career XP and rank persist across Seasons.
15. Complete Weekly Reviews.
16. Close a Season without losing or mutating its history.
17. Create a new Season with a different length.
18. Continue the same Course across multiple Seasons through different Subjects.
