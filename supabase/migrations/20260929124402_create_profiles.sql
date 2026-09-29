-- Undo the baseline's administrative grants for future application objects.
-- Explicit table grants below are intentionally separate from row-level policies.
alter default privileges for role postgres in schema public
  revoke all on tables from public, anon, authenticated, service_role;
alter default privileges for role postgres in schema public
  revoke all on sequences from public, anon, authenticated, service_role;
alter default privileges for role postgres in schema public
  revoke all on functions from public, anon, authenticated, service_role;

create schema if not exists private;
revoke all on schema private from public, anon, authenticated, service_role;

-- Shared by user-owned tables. Identities and creation times cannot be rewritten.
create function private.set_record_metadata()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if tg_op = 'UPDATE' then
    if new.user_id is distinct from old.user_id
       or (to_jsonb(new) -> 'id') is distinct from (to_jsonb(old) -> 'id')
       or new.created_at is distinct from old.created_at then
      raise exception using errcode = '23514',
        message = 'Record identity and creation time are immutable';
    end if;
  else
    new.created_at := statement_timestamp();
  end if;
  new.updated_at := statement_timestamp();
  return new;
end;
$$;
revoke all on function private.set_record_metadata()
  from public, anon, authenticated, service_role;

-- user_id is also the primary key: exactly one profile per Auth account.
-- Additional profile fields will be added when the product needs them.
create table public.profiles (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
revoke all on public.profiles from public, anon, authenticated, service_role;
grant select, insert, update, delete on public.profiles to authenticated;

create policy profiles_select_own on public.profiles
  for select to authenticated using ((select auth.uid()) = user_id);
create policy profiles_insert_own on public.profiles
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy profiles_update_own on public.profiles
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy profiles_delete_own on public.profiles
  for delete to authenticated using ((select auth.uid()) = user_id);

create trigger profiles_set_metadata
  before insert or update on public.profiles
  for each row execute function private.set_record_metadata();

-- Auth creates users without an end-user session. NEW.id, supplied by this
-- auth.users trigger, is the identity source; no user-editable metadata is trusted.
-- This definer function is private, trigger-only, and not executable by API roles.
create function private.create_profile_for_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (user_id) values (new.id)
  on conflict (user_id) do nothing;
  return new;
end;
$$;
revoke all on function private.create_profile_for_auth_user()
  from public, anon, authenticated, service_role;

create trigger on_auth_user_created_profile
  after insert on auth.users
  for each row execute function private.create_profile_for_auth_user();

-- Include accounts created before this migration, including the owner account.
insert into public.profiles (user_id)
select id from auth.users
on conflict (user_id) do nothing;
