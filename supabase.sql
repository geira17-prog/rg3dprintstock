-- RG3DPrint Stock v2
create extension if not exists pgcrypto;

create table if not exists public.filamentos (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 nome text not null,
 marca text,
 tipo text not null default 'PLA',
 cor text,
 caixas integer not null default 0 check (caixas >= 0),
 valor_medio numeric(12,2) not null default 0,
 foto text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create unique index if not exists filamentos_user_nome_lower on public.filamentos(user_id, lower(nome));

create table if not exists public.compras (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 filamento_id uuid not null references public.filamentos(id) on delete cascade,
 data_compra date not null default current_date,
 quantidade integer not null check (quantidade > 0),
 preco_sem_iva numeric(12,2) not null default 0,
 iva numeric(6,2) not null default 23,
 preco_com_iva numeric(12,2) not null default 0,
 total_sem_iva numeric(12,2) not null default 0,
 total numeric(12,2) not null default 0,
 fatura text,
 fornecedor text,
 foto text,
 created_at timestamptz not null default now()
);

create table if not exists public.saidas (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 filamento_id uuid not null references public.filamentos(id) on delete cascade,
 data_saida date not null default current_date,
 quantidade integer not null check (quantidade > 0),
 tipo text not null,
 preco_venda numeric(12,2) not null default 0,
 total numeric(12,2) not null default 0,
 observacoes text,
 created_at timestamptz not null default now()
);

create table if not exists public.filamentos_para_comprar (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 nome text not null,
 marca text,
 tipo text not null default 'PLA',
 cor text,
 quantidade integer not null default 1 check (quantidade > 0),
 preco_sem_iva numeric(12,2) not null default 0,
 iva numeric(6,2) not null default 23,
 fornecedor text,
 prioridade text not null default 'Normal',
 foto text,
 created_at timestamptz not null default now()
);

alter table public.filamentos enable row level security;
alter table public.compras enable row level security;
alter table public.saidas enable row level security;
alter table public.filamentos_para_comprar enable row level security;

drop policy if exists filamentos_all_own on public.filamentos;
create policy filamentos_all_own on public.filamentos for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists compras_all_own on public.compras;
create policy compras_all_own on public.compras for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists saidas_all_own on public.saidas;
create policy saidas_all_own on public.saidas for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists comprar_all_own on public.filamentos_para_comprar;
create policy comprar_all_own on public.filamentos_para_comprar for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at=now(); return new; end $$;

drop trigger if exists filamentos_updated_at on public.filamentos;
create trigger filamentos_updated_at before update on public.filamentos for each row execute function public.set_updated_at();

-- Segurança: impedir que utilizadores alterem user_id para outro utilizador através da aplicação.
revoke all on public.filamentos, public.compras, public.saidas, public.filamentos_para_comprar from anon;
grant select, insert, update, delete on public.filamentos, public.compras, public.saidas, public.filamentos_para_comprar to authenticated;
