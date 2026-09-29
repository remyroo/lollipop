-- Profiles are empty at this stage; no placeholder names or backfill are needed.
alter table public.profiles
  add column name text not null
  constraint profiles_name_not_blank check (name ~ '[^[:space:]]');

comment on column public.profiles.name is
  'Required display name; duplicates are allowed. user_id remains the identity.';

-- New Auth accounts must supply a nonblank string in user_metadata.name.
-- Metadata supplies display text only; ownership still comes exclusively from NEW.id.
create or replace function private.create_profile_for_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if jsonb_typeof(new.raw_user_meta_data -> 'name') is distinct from 'string'
     or not ((new.raw_user_meta_data ->> 'name') ~ '[^[:space:]]') then
    raise exception using errcode = '23514',
      message = 'A nonblank name is required in user_metadata when creating an account';
  end if;

  insert into public.profiles (user_id, name)
  values (new.id, new.raw_user_meta_data ->> 'name')
  on conflict (user_id) do nothing;
  return new;
end;
$$;
revoke all on function private.create_profile_for_auth_user()
  from public, anon, authenticated, service_role;
