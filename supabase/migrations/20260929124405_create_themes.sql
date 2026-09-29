create table public.themes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete restrict,
  name text not null constraint themes_name_not_blank check (name ~ '[^[:space:]]'),
  emoji text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index themes_user_id_idx on public.themes (user_id);

alter table public.themes enable row level security;
revoke all on public.themes from public, anon, authenticated, service_role;
grant select, insert, update, delete on public.themes to authenticated;

create policy themes_select_own on public.themes
  for select to authenticated using ((select auth.uid()) = user_id);
create policy themes_insert_own on public.themes
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy themes_update_own on public.themes
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy themes_delete_own on public.themes
  for delete to authenticated using ((select auth.uid()) = user_id);

create trigger themes_set_metadata
  before insert or update on public.themes
  for each row execute function private.set_record_metadata();

comment on table public.themes is
  'User-owned categories reusable across seasons. Future referencing tables must protect same-owner relationships and restrict deletion of referenced themes.';
