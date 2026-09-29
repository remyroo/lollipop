-- Fixtures and pgTAP installation are rolled back after this suite.

begin;

create extension if not exists pgtap with schema extensions;

set local search_path = public, extensions;

select no_plan();

select ok((select relrowsecurity from pg_class where oid = 'public.profiles'::regclass), 'profiles: RLS enabled');

select ok(not has_table_privilege('anon', 'public.profiles', 'TRUNCATE'), 'profiles: anon has no TRUNCATE');

select ok(not has_table_privilege('anon', 'public.profiles', 'TRIGGER'), 'profiles: anon has no TRIGGER');

select ok(not has_table_privilege('anon', 'public.profiles', 'REFERENCES'), 'profiles: anon has no REFERENCES');

select ok(not has_table_privilege('anon', 'public.profiles', 'MAINTAIN'), 'profiles: anon has no MAINTAIN');

select ok(not has_table_privilege('authenticated', 'public.profiles', 'TRUNCATE'), 'profiles: authenticated has no TRUNCATE');

select ok(not has_table_privilege('authenticated', 'public.profiles', 'TRIGGER'), 'profiles: authenticated has no TRIGGER');

select ok(not has_table_privilege('authenticated', 'public.profiles', 'REFERENCES'), 'profiles: authenticated has no REFERENCES');

select ok(not has_table_privilege('authenticated', 'public.profiles', 'MAINTAIN'), 'profiles: authenticated has no MAINTAIN');

select ok(not has_table_privilege('service_role', 'public.profiles', 'TRUNCATE'), 'profiles: service_role has no TRUNCATE');

select ok(not has_table_privilege('service_role', 'public.profiles', 'TRIGGER'), 'profiles: service_role has no TRIGGER');

select ok(not has_table_privilege('service_role', 'public.profiles', 'REFERENCES'), 'profiles: service_role has no REFERENCES');

select ok(not has_table_privilege('service_role', 'public.profiles', 'MAINTAIN'), 'profiles: service_role has no MAINTAIN');

select ok(not has_table_privilege('anon', 'public.profiles', 'SELECT'), 'profiles: anonymous SELECT denied');

select ok(not has_table_privilege('anon', 'public.profiles', 'INSERT'), 'profiles: anonymous INSERT denied');

select ok(not has_table_privilege('anon', 'public.profiles', 'UPDATE'), 'profiles: anonymous UPDATE denied');

select ok(not has_table_privilege('anon', 'public.profiles', 'DELETE'), 'profiles: anonymous DELETE denied');

select ok((select relrowsecurity from pg_class where oid = 'public.themes'::regclass), 'themes: RLS enabled');

select ok(not has_table_privilege('anon', 'public.themes', 'TRUNCATE'), 'themes: anon has no TRUNCATE');

select ok(not has_table_privilege('anon', 'public.themes', 'TRIGGER'), 'themes: anon has no TRIGGER');

select ok(not has_table_privilege('anon', 'public.themes', 'REFERENCES'), 'themes: anon has no REFERENCES');

select ok(not has_table_privilege('anon', 'public.themes', 'MAINTAIN'), 'themes: anon has no MAINTAIN');

select ok(not has_table_privilege('authenticated', 'public.themes', 'TRUNCATE'), 'themes: authenticated has no TRUNCATE');

select ok(not has_table_privilege('authenticated', 'public.themes', 'TRIGGER'), 'themes: authenticated has no TRIGGER');

select ok(not has_table_privilege('authenticated', 'public.themes', 'REFERENCES'), 'themes: authenticated has no REFERENCES');

select ok(not has_table_privilege('authenticated', 'public.themes', 'MAINTAIN'), 'themes: authenticated has no MAINTAIN');

select ok(not has_table_privilege('service_role', 'public.themes', 'TRUNCATE'), 'themes: service_role has no TRUNCATE');

select ok(not has_table_privilege('service_role', 'public.themes', 'TRIGGER'), 'themes: service_role has no TRIGGER');

select ok(not has_table_privilege('service_role', 'public.themes', 'REFERENCES'), 'themes: service_role has no REFERENCES');

select ok(not has_table_privilege('service_role', 'public.themes', 'MAINTAIN'), 'themes: service_role has no MAINTAIN');

select ok(not has_table_privilege('anon', 'public.themes', 'SELECT'), 'themes: anonymous SELECT denied');

select ok(not has_table_privilege('anon', 'public.themes', 'INSERT'), 'themes: anonymous INSERT denied');

select ok(not has_table_privilege('anon', 'public.themes', 'UPDATE'), 'themes: anonymous UPDATE denied');

select ok(not has_table_privilege('anon', 'public.themes', 'DELETE'), 'themes: anonymous DELETE denied');

select ok((select relrowsecurity from pg_class where oid = 'public.seasons'::regclass), 'seasons: RLS enabled');

select ok(not has_table_privilege('anon', 'public.seasons', 'TRUNCATE'), 'seasons: anon has no TRUNCATE');

select ok(not has_table_privilege('anon', 'public.seasons', 'TRIGGER'), 'seasons: anon has no TRIGGER');

select ok(not has_table_privilege('anon', 'public.seasons', 'REFERENCES'), 'seasons: anon has no REFERENCES');

select ok(not has_table_privilege('anon', 'public.seasons', 'MAINTAIN'), 'seasons: anon has no MAINTAIN');

select ok(not has_table_privilege('authenticated', 'public.seasons', 'TRUNCATE'), 'seasons: authenticated has no TRUNCATE');

select ok(not has_table_privilege('authenticated', 'public.seasons', 'TRIGGER'), 'seasons: authenticated has no TRIGGER');

select ok(not has_table_privilege('authenticated', 'public.seasons', 'REFERENCES'), 'seasons: authenticated has no REFERENCES');

select ok(not has_table_privilege('authenticated', 'public.seasons', 'MAINTAIN'), 'seasons: authenticated has no MAINTAIN');

select ok(not has_table_privilege('service_role', 'public.seasons', 'TRUNCATE'), 'seasons: service_role has no TRUNCATE');

select ok(not has_table_privilege('service_role', 'public.seasons', 'TRIGGER'), 'seasons: service_role has no TRIGGER');

select ok(not has_table_privilege('service_role', 'public.seasons', 'REFERENCES'), 'seasons: service_role has no REFERENCES');

select ok(not has_table_privilege('service_role', 'public.seasons', 'MAINTAIN'), 'seasons: service_role has no MAINTAIN');

select ok(not has_table_privilege('anon', 'public.seasons', 'SELECT'), 'seasons: anonymous SELECT denied');

select ok(not has_table_privilege('anon', 'public.seasons', 'INSERT'), 'seasons: anonymous INSERT denied');

select ok(not has_table_privilege('anon', 'public.seasons', 'UPDATE'), 'seasons: anonymous UPDATE denied');

select ok(not has_table_privilege('anon', 'public.seasons', 'DELETE'), 'seasons: anonymous DELETE denied');

select ok(not has_function_privilege('anon', 'private.set_record_metadata()', 'EXECUTE'), 'set_record_metadata: anon cannot execute directly');

select ok(not has_function_privilege('authenticated', 'private.set_record_metadata()', 'EXECUTE'), 'set_record_metadata: authenticated cannot execute directly');

select ok(not has_function_privilege('service_role', 'private.set_record_metadata()', 'EXECUTE'), 'set_record_metadata: service_role cannot execute directly');

select ok(not has_function_privilege('anon', 'private.create_profile_for_auth_user()', 'EXECUTE'), 'create_profile_for_auth_user: anon cannot execute directly');

select ok(not has_function_privilege('authenticated', 'private.create_profile_for_auth_user()', 'EXECUTE'), 'create_profile_for_auth_user: authenticated cannot execute directly');

select ok(not has_function_privilege('service_role', 'private.create_profile_for_auth_user()', 'EXECUTE'), 'create_profile_for_auth_user: service_role cannot execute directly');

select ok(not has_function_privilege('anon', 'private.enforce_season_lifecycle()', 'EXECUTE'), 'enforce_season_lifecycle: anon cannot execute directly');

select ok(not has_function_privilege('authenticated', 'private.enforce_season_lifecycle()', 'EXECUTE'), 'enforce_season_lifecycle: authenticated cannot execute directly');

select ok(not has_function_privilege('service_role', 'private.enforce_season_lifecycle()', 'EXECUTE'), 'enforce_season_lifecycle: service_role cannot execute directly');

insert into auth.users (id, raw_user_meta_data) values
  ('f1000000-0000-4000-8000-000000000001', '{"name":"Alex"}'),
  ('f1000000-0000-4000-8000-000000000002', '{"name":"Alex"}');

select is((select count(*) from profiles where user_id in (
  'f1000000-0000-4000-8000-000000000001',
  'f1000000-0000-4000-8000-000000000002'
) and name = 'Alex'), 2::bigint, 'Auth copies names and duplicate profile names are allowed');

select throws_ok($test$insert into auth.users (id) values ('f1000000-0000-4000-8000-000000000003')$test$,
  '23514', null, 'Auth account creation requires name metadata');

select throws_ok($test$insert into auth.users (id, raw_user_meta_data) values ('f1000000-0000-4000-8000-000000000003', '{"name":"  "}')$test$,
  '23514', null, 'Auth account creation rejects blank names');

select throws_ok($test$insert into auth.users (id, raw_user_meta_data) values ('f1000000-0000-4000-8000-000000000003', '{"name":123}')$test$,
  '23514', null, 'Auth account creation requires a string name');

select is((select count(*) from auth.users where id = 'f1000000-0000-4000-8000-000000000003'),
  0::bigint, 'Invalid account creation rolls back atomically');

select is((select count(*) from profiles where user_id in ('f1000000-0000-4000-8000-000000000001','f1000000-0000-4000-8000-000000000002')), 2::bigint, 'Auth trigger creates one profile per account');

insert into themes (id,user_id,name) values ('f2000000-0000-4000-8000-000000000001','f1000000-0000-4000-8000-000000000001','Music'), ('f2000000-0000-4000-8000-000000000002','f1000000-0000-4000-8000-000000000002','Music');

insert into seasons (id,user_id,name,start_date,week_count,status) values ('f3000000-0000-4000-8000-000000000001','f1000000-0000-4000-8000-000000000001','Season A','2026-09-01',8,'active'), ('f3000000-0000-4000-8000-000000000002','f1000000-0000-4000-8000-000000000002','Season B','2026-09-01',6,'active');

-- Test RLS using the real API role and simulated user claims.

set local role authenticated;

select set_config('request.jwt.claims', '{"sub":"f1000000-0000-4000-8000-000000000001","role":"authenticated"}', true);

select is((select count(*) from profiles where user_id = 'f1000000-0000-4000-8000-000000000001'), 1::bigint, 'profiles: owner can read own row');

select is((select count(*) from profiles where user_id = 'f1000000-0000-4000-8000-000000000002'), 0::bigint, 'profiles: other user is hidden');

with changed as (update profiles set updated_at = now() where user_id = 'f1000000-0000-4000-8000-000000000002' returning 1) select is((select count(*) from changed), 0::bigint, 'profiles: cannot update another user');

with removed as (delete from profiles where user_id = 'f1000000-0000-4000-8000-000000000002' returning 1) select is((select count(*) from removed), 0::bigint, 'profiles: cannot delete another user');

select throws_ok($test$update profiles set user_id = 'f1000000-0000-4000-8000-000000000002' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, '23514', null, 'profiles: ownership is immutable');

select throws_ok($test$update profiles set created_at = '2000-01-01' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, '23514', null, 'profiles: creation time is immutable');

select lives_ok($test$update profiles set updated_at = '2000-01-01' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, 'profiles: owner update succeeds');

select ok((select updated_at > '2000-01-01' from profiles where user_id = 'f1000000-0000-4000-8000-000000000001'), 'profiles: updated_at is database managed');

select is((select count(*) from themes where user_id = 'f1000000-0000-4000-8000-000000000001'), 1::bigint, 'themes: owner can read own row');

select is((select count(*) from themes where user_id = 'f1000000-0000-4000-8000-000000000002'), 0::bigint, 'themes: other user is hidden');

with changed as (update themes set updated_at = now() where user_id = 'f1000000-0000-4000-8000-000000000002' returning 1) select is((select count(*) from changed), 0::bigint, 'themes: cannot update another user');

with removed as (delete from themes where user_id = 'f1000000-0000-4000-8000-000000000002' returning 1) select is((select count(*) from removed), 0::bigint, 'themes: cannot delete another user');

select throws_ok($test$update themes set user_id = 'f1000000-0000-4000-8000-000000000002' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, '23514', null, 'themes: ownership is immutable');

select throws_ok($test$update themes set created_at = '2000-01-01' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, '23514', null, 'themes: creation time is immutable');

select lives_ok($test$update themes set updated_at = '2000-01-01' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, 'themes: owner update succeeds');

select ok((select updated_at > '2000-01-01' from themes where user_id = 'f1000000-0000-4000-8000-000000000001'), 'themes: updated_at is database managed');

select is((select count(*) from seasons where user_id = 'f1000000-0000-4000-8000-000000000001'), 1::bigint, 'seasons: owner can read own row');

select is((select count(*) from seasons where user_id = 'f1000000-0000-4000-8000-000000000002'), 0::bigint, 'seasons: other user is hidden');

with changed as (update seasons set updated_at = now() where user_id = 'f1000000-0000-4000-8000-000000000002' returning 1) select is((select count(*) from changed), 0::bigint, 'seasons: cannot update another user');

with removed as (delete from seasons where user_id = 'f1000000-0000-4000-8000-000000000002' returning 1) select is((select count(*) from removed), 0::bigint, 'seasons: cannot delete another user');

select throws_ok($test$update seasons set user_id = 'f1000000-0000-4000-8000-000000000002' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, '23514', null, 'seasons: ownership is immutable');

select throws_ok($test$update seasons set created_at = '2000-01-01' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, '23514', null, 'seasons: creation time is immutable');

select lives_ok($test$update seasons set updated_at = '2000-01-01' where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, 'seasons: owner update succeeds');

select ok((select updated_at > '2000-01-01' from seasons where user_id = 'f1000000-0000-4000-8000-000000000001'), 'seasons: updated_at is database managed');

select throws_ok($test$insert into profiles (user_id, name) values ('f1000000-0000-4000-8000-000000000002', 'Alex')$test$, '42501', null, 'Cannot forge profile ownership');

select throws_ok($test$insert into themes (user_id,name) values ('f1000000-0000-4000-8000-000000000002','Forged')$test$, '42501', null, 'Cannot forge theme ownership');

select throws_ok($test$insert into seasons (user_id,name,start_date,week_count) values ('f1000000-0000-4000-8000-000000000002','Forged','2026-09-01',8)$test$, '42501', null, 'Cannot forge season ownership');

select lives_ok($test$update profiles set name = 'Alex Morgan' where user_id = auth.uid()$test$,
  'Owner can change their profile name');

select is((select name from profiles where user_id = auth.uid()), 'Alex Morgan',
  'Updated profile name is persisted');

select throws_ok($test$update profiles set name = null where user_id = auth.uid()$test$,
  '23502', null, 'Profile name is required');

select throws_ok($test$update profiles set name = '' where user_id = auth.uid()$test$,
  '23514', null, 'Empty profile name is rejected');

select throws_ok($test$update profiles set name = E' \t\n' where user_id = auth.uid()$test$,
  '23514', null, 'Whitespace-only profile name is rejected');

select lives_ok($test$delete from profiles where user_id = 'f1000000-0000-4000-8000-000000000001'$test$, 'Owner can delete own profile');

select lives_ok($test$insert into profiles (name) values ('Alex')$test$, 'Owner can recreate own profile with auth.uid default');

select throws_ok($test$insert into profiles (name) values ('Alex')$test$, '23505', null, 'Only one profile per account');

select lives_ok($test$insert into themes (name,emoji) values ('Cooking','🍳')$test$, 'Owner can create theme with default ownership');

select lives_ok($test$update themes set name = 'Cooking basics' where name = 'Cooking'$test$, 'Owner can edit theme');

with removed as (delete from themes where name = 'Cooking basics' returning 1) select is((select count(*) from removed), 1::bigint, 'Owner can delete theme');

select throws_ok($test$insert into themes (name) values ('')$test$, '23514', null, 'Blank theme names rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count) values ('','2026-09-01',8)$test$, '23514', null, 'Blank season names rejected');

select throws_ok($test$insert into themes (name) values (' ')$test$, '23514', null, 'Blank theme names rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count) values (' ','2026-09-01',8)$test$, '23514', null, 'Blank season names rejected');

select throws_ok($test$insert into themes (name) values ('	
')$test$, '23514', null, 'Blank theme names rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count) values ('	
','2026-09-01',8)$test$, '23514', null, 'Blank season names rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count) values ('Invalid','2026-09-01',0)$test$, '23514', null, 'Nonpositive season lengths rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count) values ('Invalid','2026-09-01',-1)$test$, '23514', null, 'Nonpositive season lengths rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count) values ('Invalid','2026-09-01',null)$test$, '23502', null, 'Week count required');

select throws_ok($test$insert into seasons (name,start_date,week_count) values ('Invalid',null,8)$test$, '23502', null, 'Start date required');

select throws_ok($test$insert into seasons (name,start_date,week_count,status) values ('Invalid','2026-09-01',8,'unknown')$test$, '22P02', null, 'Unknown status rejected');

select throws_ok($test$insert into seasons (name,start_date,week_count,status) values ('Invalid','2026-09-01',8,'closed')$test$, '23514', null, 'Cannot insert already-closed seasons');

select throws_ok($test$insert into seasons (name,start_date,week_count,closed_at) values ('Invalid','2026-09-01',8,now())$test$, '23514', null, 'Draft cannot have closed_at');

select throws_ok($test$insert into seasons (name,start_date,week_count,status) values ('Second active','2026-09-01',8,'active')$test$, '23505', null, 'Second active season rejected on insert');

select lives_ok($test$insert into seasons (id,name,start_date,week_count) values ('f3000000-0000-4000-8000-000000000003','Next season','2026-11-01',12)$test$, 'Can create draft alongside active season');

select throws_ok($test$update seasons set status = 'active' where id = 'f3000000-0000-4000-8000-000000000003'$test$, '23505', null, 'Second active season rejected on update');

select throws_ok($test$update seasons set status = 'draft' where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Cannot downgrade active season to bypass deletion rule');

with removed as (delete from seasons where id = 'f3000000-0000-4000-8000-000000000001' returning 1) select is((select count(*) from removed), 0::bigint, 'RLS prevents active-season deletion');

select lives_ok($test$insert into seasons (name,start_date,week_count) values ('Discard me','2026-09-01',8)$test$, 'Multiple drafts allowed');

with removed as (delete from seasons where name = 'Discard me' returning 1) select is((select count(*) from removed), 1::bigint, 'Draft deletion succeeds');

select lives_ok($test$update seasons set status = 'closed', closed_at = '2000-01-01' where id = 'f3000000-0000-4000-8000-000000000001'$test$, 'Closing succeeds atomically');

select ok((select status = 'closed' and closed_at > '2000-01-01' from seasons where id = 'f3000000-0000-4000-8000-000000000001'), 'Database supplies the closure timestamp');

select throws_ok($test$update seasons set name = 'Changed' where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Closed season rejects name = ''Changed''');

select throws_ok($test$update seasons set week_count = 99 where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Closed season rejects week_count = 99');

select throws_ok($test$update seasons set status = 'active' where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Closed season rejects status = ''active''');

select throws_ok($test$update seasons set status = 'draft' where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Closed season rejects status = ''draft''');

select throws_ok($test$update seasons set closed_at = null where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Closed season rejects closed_at = null');

with removed as (delete from seasons where id = 'f3000000-0000-4000-8000-000000000001' returning 1) select is((select count(*) from removed), 0::bigint, 'RLS prevents closed-season deletion');

select lives_ok($test$update seasons set status = 'active' where id = 'f3000000-0000-4000-8000-000000000003'$test$, 'Closing frees the active-season slot');

select is((select week_count from seasons where id = 'f3000000-0000-4000-8000-000000000001'), 8, 'Historical season length is preserved');

select is((select week_count from seasons where id = 'f3000000-0000-4000-8000-000000000003'), 12, 'New season has independent length');

select lives_ok($test$update themes set name = 'Music theory' where id = 'f2000000-0000-4000-8000-000000000001'$test$, 'Global themes stay editable after closure');

select set_config('request.jwt.claims', '{"sub":"f1000000-0000-4000-8000-000000000002","role":"authenticated"}', true);

select is((select count(*) from seasons where user_id = 'f1000000-0000-4000-8000-000000000001'), 0::bigint, 'Second user cannot see first user history');

select is((select count(*) from seasons where status = 'active'), 1::bigint, 'Second user retains an independent active season');

reset role;

-- Trigger defenses also apply to writes that bypass RLS.

select throws_ok($test$delete from seasons where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Trigger blocks closed deletion even with RLS bypass');

select throws_ok($test$delete from seasons where id = 'f3000000-0000-4000-8000-000000000003'$test$, '23514', null, 'Trigger blocks active deletion even with RLS bypass');

select throws_ok($test$update seasons set name = 'Changed' where id = 'f3000000-0000-4000-8000-000000000001'$test$, '23514', null, 'Trigger blocks closed edits even with RLS bypass');

select throws_ok($test$delete from auth.users where id = 'f1000000-0000-4000-8000-000000000001'$test$, '23503', null, 'Account deletion cannot cascade away study history');

set local role anon;

select set_config('request.jwt.claims', '{}', true);

select throws_ok($test$select * from profiles$test$, '42501', null, 'profiles: anonymous read rejected');

select throws_ok($test$select * from themes$test$, '42501', null, 'themes: anonymous read rejected');

select throws_ok($test$select * from seasons$test$, '42501', null, 'seasons: anonymous read rejected');

reset role;

select * from finish();

rollback;
