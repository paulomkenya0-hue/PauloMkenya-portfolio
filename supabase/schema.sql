-- ============================================================================
-- PAULO MKENYA PORTFOLIO — SUPABASE SCHEMA
-- Run this whole file once in: Supabase Dashboard -> SQL Editor -> New query
-- ============================================================================

create table if not exists projects (
  id bigint generated always as identity primary key,
  title_sw text not null,
  title_en text not null,
  category text not null check (category in ('Web','Mobile')),
  tech text[] not null default '{}',
  desc_sw text default '',
  desc_en text default '',
  github text default '',
  live text default '',
  icon text default 'app',
  created_at timestamptz default now()
);

create table if not exists posts (
  id bigint generated always as identity primary key,
  title text not null,
  excerpt text default '',
  content text default '',
  category text default '',
  tags text[] default '{}',
  color text default '#E8A33D',
  status text not null default 'draft' check (status in ('draft','published')),
  date date default current_date,
  created_at timestamptz default now()
);

create table if not exists comments (
  id bigint generated always as identity primary key,
  post_id bigint references posts(id) on delete cascade,
  name text not null,
  comment text not null,
  created_at timestamptz default now()
);

create table if not exists messages (
  id bigint generated always as identity primary key,
  name text not null,
  email text not null,
  phone text default '',
  message text not null,
  read boolean default false,
  created_at timestamptz default now()
);

create table if not exists settings (
  id int primary key default 1,
  visitors int default 0,
  email text default 'paulo.mkenya@example.com',
  phone text default '+255 712 345 678',
  whatsapp text default '+255712345678',
  github text default 'https://github.com/',
  linkedin text default 'https://linkedin.com/',
  twitter text default 'https://twitter.com/',
  hero_tagline_sw text default '',
  hero_tagline_en text default '',
  about1_sw text default '',
  about1_en text default '',
  about2_sw text default '',
  about2_en text default '',
  seo_title text default 'Paulo Mkenya — Full-Stack Developer',
  seo_desc text default 'Paulo Mkenya is a Full-Stack Developer building web and mobile management systems in Tanzania.',
  constraint single_row check (id = 1)
);

insert into settings (id) values (1) on conflict (id) do nothing;

-- Seed a couple of example projects/posts so the site isn't empty on first deploy
insert into projects (title_sw, title_en, category, tech, desc_sw, desc_en, icon)
values
('Mfumo wa Usimamizi wa Shule', 'School Management System', 'Web', array['React','Node.js','MySQL'],
 'Mfumo kamili wa usimamizi wa shule za sekondari.', 'A complete secondary school management system.', 'school'),
('Mfumo wa Usimamizi wa Shamba', 'Farm Management System', 'Mobile', array['Flutter','Firebase'],
 'Programu ya simu ya kufuatilia mazao na mifugo.', 'A mobile app for tracking crops and livestock.', 'farm')
on conflict do nothing;

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
alter table projects enable row level security;
alter table posts enable row level security;
alter table comments enable row level security;
alter table messages enable row level security;
alter table settings enable row level security;

-- Projects: everyone can read, only logged-in admin can write
create policy "projects_public_read" on projects for select using (true);
create policy "projects_admin_write" on projects for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Posts: everyone can read published posts, admin can read/write everything
create policy "posts_public_read" on posts for select
  using (status = 'published' or auth.role() = 'authenticated');
create policy "posts_admin_write" on posts for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

-- Comments: everyone can read and add comments, only admin can delete
create policy "comments_public_read" on comments for select using (true);
create policy "comments_public_insert" on comments for insert with check (true);
create policy "comments_admin_delete" on comments for delete using (auth.role() = 'authenticated');

-- Messages: anyone can submit the contact form, only admin can read/manage them
create policy "messages_public_insert" on messages for insert with check (true);
create policy "messages_admin_read" on messages for select using (auth.role() = 'authenticated');
create policy "messages_admin_update" on messages for update using (auth.role() = 'authenticated');
create policy "messages_admin_delete" on messages for delete using (auth.role() = 'authenticated');

-- Settings: everyone can read, only admin can update
create policy "settings_public_read" on settings for select using (true);
create policy "settings_admin_update" on settings for update using (auth.role() = 'authenticated');

-- ============================================================================
-- Visitor counter — public visitors need to bump this without full write access,
-- so we use a SECURITY DEFINER function instead of loosening the settings policy.
-- ============================================================================
create or replace function increment_visitors()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update settings set visitors = visitors + 1 where id = 1;
end;
$$;

grant execute on function increment_visitors() to anon, authenticated;
