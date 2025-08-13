create table if not exists public.users
(
    id            bigserial
        primary key,
    created_at    timestamp with time zone,
    updated_at    timestamp with time zone,
    deleted_at    timestamp with time zone,
    did           text    default gen_random_uuid(),
    name          text,
    username      text not null
        constraint uni_users_username
            unique,
    gender        smallint,
    email         text not null
        constraint uni_users_email
            unique,
    phone         text,
    avatar        text,
    avatar_url    text,
    address       text,
    auth_two_face text,
    dob           timestamp with time zone,
    password      text,
    status        text,
    role          text,
    role_id       bigint,
    department    text,
    department_id bigint,
    store_name    text,
    location_id   bigint,
    is_vip        boolean default false,
    bio           text,
    created_by    bigint,
    updated_by    bigint,
    queue_id      bigint
);

alter table public.users
    owner to hrm_user;

create index if not exists idx_users_status
    on public.users (status);

create index if not exists idx_users_phone
    on public.users (phone);

create index if not exists idx_users_name
    on public.users (name);

create index if not exists idx_users_deleted_at
    on public.users (deleted_at, deleted_at);

create table if not exists public.roles
(
    id          bigserial
        primary key,
    created_at  timestamp with time zone,
    updated_at  timestamp with time zone,
    deleted_at  timestamp with time zone,
    name        text,
    code        text,
    description text
);

alter table public.roles
    owner to hrm_user;

create index if not exists idx_roles_code
    on public.roles (code);

create index if not exists idx_roles_name
    on public.roles (name);

create index if not exists idx_roles_deleted_at
    on public.roles (deleted_at);

create table if not exists public.permissions
(
    id          bigserial
        primary key,
    created_at  timestamp with time zone,
    updated_at  timestamp with time zone,
    deleted_at  timestamp with time zone,
    module      text,
    name        text,
    code        text,
    description text
);

alter table public.permissions
    owner to hrm_user;

create index if not exists idx_permissions_code
    on public.permissions (code);

create index if not exists idx_permissions_name
    on public.permissions (name);

create index if not exists idx_permissions_module
    on public.permissions (module);

create index if not exists idx_permissions_deleted_at
    on public.permissions (deleted_at);

create table if not exists public.role_has_permissions
(
    id            bigserial
        primary key,
    created_at    timestamp with time zone,
    updated_at    timestamp with time zone,
    deleted_at    timestamp with time zone,
    role_id       bigint,
    permission_id bigint
);

alter table public.role_has_permissions
    owner to hrm_user;

create index if not exists idx_role_has_permissions_permission_id
    on public.role_has_permissions (permission_id);

create index if not exists idx_role_has_permissions_role_id
    on public.role_has_permissions (role_id);

create index if not exists idx_role_has_permissions_deleted_at
    on public.role_has_permissions (deleted_at);

create table if not exists public.user_sessions
(
    id                    bigserial
        primary key,
    created_at            timestamp with time zone,
    updated_at            timestamp with time zone,
    deleted_at            timestamp with time zone,
    user_session_id       text,
    firebase_token        text,
    access_token          text,
    access_token_expired  integer,
    refresh_token         text,
    refresh_token_expired integer,
    user_id               bigint,
    is_system             boolean
);

alter table public.user_sessions
    owner to hrm_user;

create index if not exists idx_user_sessions_user_id
    on public.user_sessions (user_id);

create index if not exists idx_user_sessions_refresh_token
    on public.user_sessions (refresh_token);

create index if not exists idx_user_sessions_access_token
    on public.user_sessions (access_token);

create index if not exists idx_user_sessions_user_session_id
    on public.user_sessions (user_session_id);

create index if not exists idx_user_sessions_deleted_at
    on public.user_sessions (deleted_at);

create table if not exists public.departments
(
    id          bigserial
        primary key,
    created_at  timestamp with time zone,
    updated_at  timestamp with time zone,
    deleted_at  timestamp with time zone,
    name        text not null,
    code        text not null
        constraint uni_departments_code
            unique,
    description text,
    parent_id   bigint,
    manager_id  bigint
);

alter table public.departments
    owner to hrm_user;

create index if not exists idx_departments_deleted_at
    on public.departments (deleted_at);

create table if not exists public.service_types
(
    id                              bigserial
        primary key,
    created_at                      timestamp with time zone,
    updated_at                      timestamp with time zone,
    name                            varchar(255),
    form_request_id                 integer                    not null,
    form_request_name               varchar(255),
    require_signature               boolean      default false,
    require_portrait_photo          boolean      default false not null,
    require_citizen_id              boolean      default false not null,
    require_video_call_confirmation boolean      default false not null,
    citizen_id_card_type            boolean      default false not null,
    print_ip                        varchar(255) default ''::character varying
);

alter table public.service_types
    owner to hrm_user;

create table if not exists public.stores
(
    id                                  bigserial
        primary key,
    created_at                          timestamp with time zone,
    updated_at                          timestamp with time zone,
    deleted_at                          timestamp with time zone,
    business_registration_number        varchar(100),
    issuing_authority                   varchar(255),
    date_of_issue                       timestamp with time zone,
    business_registration_address       varchar(255),
    business_registration_phone         varchar(255),
    business_registration_ward          varchar(255),
    business_registration_ward_code     varchar(255),
    business_registration_district      varchar(255),
    business_registration_district_code varchar(255),
    telecom_service_point_name          varchar(255),
    telecom_service_point_name_unaccent varchar(255),
    telecom_service_point_phone         varchar(255),
    telecom_service_point_address       varchar(255),
    telecom_service_point_ward          varchar(255),
    telecom_service_point_ward_code     varchar(255),
    telecom_service_point_district      varchar(255),
    telecom_service_point_district_code varchar(255),
    token                               varchar(255),
    print_ip                            varchar(255) default ''::character varying
);

alter table public.stores
    owner to hrm_user;

create index if not exists idx_stores_deleted_at
    on public.stores (deleted_at);

create table if not exists public.feedbacks
(
    id              uuid default uuid_generate_v4() not null
        primary key,
    created_at      timestamp with time zone,
    updated_at      timestamp with time zone,
    rating          integer                         not null,
    notes           text,
    queue_ticket_id bigint                          not null
);

alter table public.feedbacks
    owner to hrm_user;

create index if not exists idx_feedbacks_queue_ticket_id
    on public.feedbacks (queue_ticket_id);

create table if not exists public.customers
(
    id         uuid         default uuid_generate_v4() not null
        primary key,
    name       varchar(255)                            not null,
    email      varchar(255)
        constraint uni_customers_email
            unique,
    phone      varchar(20)
        constraint uni_customers_phone
            unique,
    address    varchar(255),
    ward       varchar(100),
    district   varchar(100),
    country    varchar(100) default 'Vietnam'::character varying,
    gender     varchar(10),
    dob        date,
    note       text,
    status     varchar(50)  default 'active'::character varying,
    created_at timestamp,
    updated_at timestamp
);

alter table public.customers
    owner to hrm_user;

create table if not exists public.service_sessions
(
    id              uuid         default uuid_generate_v4() not null
        primary key,
    store_id        bigint                                  not null,
    customer_id     uuid                                    not null,
    service_type_id bigint                                  not null,
    service_form_id bigint       default 0,
    status          varchar(255) default 'pending'::character varying,
    created_at      timestamp with time zone,
    updated_at      timestamp with time zone,
    deleted_at      timestamp with time zone
);

alter table public.service_sessions
    owner to hrm_user;

create index if not exists idx_service_sessions_deleted_at
    on public.service_sessions (deleted_at);

create table if not exists public.service_form_data
(
    id              uuid                     default uuid_generate_v4() not null
        primary key,
    data            jsonb                    default '{}'::jsonb,
    queue_ticket_id bigint                   default 0,
    created_at      timestamp with time zone default CURRENT_TIMESTAMP  not null,
    updated_at      timestamp with time zone default CURRENT_TIMESTAMP  not null,
    field           text                     default ''::text
);

alter table public.service_form_data
    owner to hrm_user;

create table if not exists public.queue_tickets
(
    id              bigserial
        primary key,
    created_at      timestamp with time zone,
    updated_at      timestamp with time zone,
    deleted_at      timestamp with time zone,
    did             text    default gen_random_uuid(),
    user_id         bigint,
    store_id        bigint,
    is_vip          boolean default false           not null,
    queue_id        bigint,
    ticket_number   text                            not null,
    customer_name   text                            not null,
    customer_phone  text                            not null,
    customer_id     text,
    service_type_id bigint,
    service_form_id bigint,
    time_called     timestamp with time zone,
    time_completed  timestamp with time zone,
    status          text    default 'waiting'::text not null,
    is_v_ip         boolean default false           not null
);

alter table public.queue_tickets
    owner to hrm_user;

create index if not exists idx_queue_tickets_deleted_at
    on public.queue_tickets (deleted_at);

create table if not exists public.otps
(
    id          bigserial
        primary key,
    email       text                     not null,
    otp         text                     not null,
    reset_token text                     not null,
    expires_at  timestamp with time zone not null,
    used        boolean default false,
    created_at  timestamp with time zone,
    updated_at  timestamp with time zone
);

alter table public.otps
    owner to hrm_user;

create table if not exists public.token_blacklists
(
    id         uuid                     default uuid_generate_v4() not null
        primary key,
    token      text                                                not null,
    created_at timestamp with time zone default CURRENT_TIMESTAMP  not null
);

alter table public.token_blacklists
    owner to hrm_user;

create table if not exists public.provinces
(
    "Id"        bigserial
        primary key,
    "Name"      varchar(100) not null,
    "Code"      varchar(50),
    "Type"      varchar(50),
    "CountryId" bigint       not null,
    "SortOrder" bigint       not null,
    "ZipCode"   varchar(50),
    "PhoneCode" varchar(50),
    "IsStatus"  bigint
);

alter table public.provinces
    owner to hrm_user;

create table if not exists public.wards
(
    "Id"         bigserial
        primary key,
    "Name"       varchar(100),
    "Code"       varchar(50),
    "Type"       varchar(50),
    "ProvinceId" bigint,
    "SortOrder"  bigint not null,
    "ZipCode"    varchar(50),
    "PhoneCode"  varchar(50),
    "IsStatus"   bigint
);

alter table public.wards
    owner to hrm_user;

create table if not exists public.form_requests
(
    id         uuid                     default uuid_generate_v4()    not null
        primary key,
    title      varchar(255)             default ''::character varying not null,
    data       jsonb                    default '{}'::jsonb,
    created_at timestamp with time zone default CURRENT_TIMESTAMP     not null,
    updated_at timestamp with time zone default CURRENT_TIMESTAMP     not null
);

alter table public.form_requests
    owner to hrm_user;

