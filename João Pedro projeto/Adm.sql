-- Rode no Supabase: SQL Editor -> New query -> Run
create table if not exists public.admins (
  email      text primary key,
  granted_by text,
  created_at timestamptz not null default now(),
  constraint admins_email_lower check (email = lower(email))
);

alter table public.admins enable row level security;

-- Cada usuário logado só enxerga a própria linha; o dono enxerga todas.
create policy "admins_select" on public.admins for select to authenticated
  using ( email = lower(auth.jwt() ->> 'email')
          or lower(auth.jwt() ->> 'email') = 'pedromartinsjoao35@gmail.com' );

-- Só o dono pode adicionar e remover admins.
create policy "admins_insert_owner" on public.admins for insert to authenticated
  with check ( lower(auth.jwt() ->> 'email') = 'pedromartinsjoao35@gmail.com' );

create policy "admins_delete_owner" on public.admins for delete to authenticated
  using ( lower(auth.jwt() ->> 'email') = 'pedromartinsjoao35@gmail.com' );