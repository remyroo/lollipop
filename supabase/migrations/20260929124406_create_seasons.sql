create type public.season_status as enum ('draft', 'active', 'closed');
grant usage on type public.season_status to authenticated;

create table public.seasons (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete restrict,
  name text not null constraint seasons_name_not_blank check (name ~ '[^[:space:]]'),
  start_date date not null,
  week_count integer not null constraint seasons_week_count_positive check (week_count > 0),
  status public.season_status not null default 'draft',
  closed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint seasons_closure_consistent check (
    (status = 'closed' and closed_at is not null)
    or (status <> 'closed' and closed_at is null)
  )
);
create index seasons_user_status_idx on public.seasons (user_id, status);
-- Database uniqueness also protects concurrent activation requests.
create unique index seasons_one_active_per_user_idx on public.seasons (user_id)
  where status = 'active';

alter table public.seasons enable row level security;
revoke all on public.seasons from public, anon, authenticated, service_role;
grant select, insert, update, delete on public.seasons to authenticated;

create policy seasons_select_own on public.seasons
  for select to authenticated using ((select auth.uid()) = user_id);
create policy seasons_insert_own on public.seasons
  for insert to authenticated with check ((select auth.uid()) = user_id);
-- Keep owner updates visible to the lifecycle trigger, which raises a useful
-- error for closed seasons instead of silently updating zero rows.
create policy seasons_update_own on public.seasons
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy seasons_delete_own_draft on public.seasons
  for delete to authenticated using ((select auth.uid()) = user_id and status = 'draft');

create function private.enforce_season_lifecycle()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if tg_op = 'DELETE' then
    if old.status <> 'draft' then
      raise exception using errcode = '23514', message = 'Only draft seasons can be deleted';
    end if;
    return old;
  end if;

  if tg_op = 'UPDATE' then
    if old.status = 'closed' then
      raise exception using errcode = '23514', message = 'Closed seasons are immutable';
    end if;
    if old.status = 'active' and new.status = 'draft' then
      raise exception using errcode = '23514', message = 'Active seasons cannot return to draft';
    end if;
  elsif new.status = 'closed' then
    raise exception using errcode = '23514', message = 'New seasons must be draft or active';
  end if;

  if new.status = 'closed' then
    new.closed_at := statement_timestamp();
  elsif new.closed_at is not null then
    raise exception using errcode = '23514', message = 'Only closed seasons can have a closure timestamp';
  end if;
  return new;
end;
$$;
revoke all on function private.enforce_season_lifecycle()
  from public, anon, authenticated, service_role;

create trigger seasons_enforce_lifecycle
  before insert or update or delete on public.seasons
  for each row execute function private.enforce_season_lifecycle();
create trigger seasons_set_metadata
  before insert or update on public.seasons
  for each row execute function private.set_record_metadata();

comment on column public.seasons.week_count is
  'Snapshot of season length, independent of defaults for future seasons.';
comment on table public.seasons is
  'One active season per owner. Only drafts may be deleted; closed seasons are immutable. XP totals and end dates are derived, not stored.';
