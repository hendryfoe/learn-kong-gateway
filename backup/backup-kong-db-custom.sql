PGDMP     "                
    z            kong    9.6.24    15.0    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ?           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            ?           1262    16384    kong    DATABASE     o   CREATE DATABASE kong WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE kong;
                kong    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                kong    false            ?           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   kong    false    7                       1255    16567    sync_tags()    FUNCTION     ?  CREATE FUNCTION public.sync_tags() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'TRUNCATE') THEN
            DELETE FROM tags WHERE entity_name = TG_TABLE_NAME;
            RETURN NULL;
          ELSIF (TG_OP = 'DELETE') THEN
            DELETE FROM tags WHERE entity_id = OLD.id;
            RETURN OLD;
          ELSE

          -- Triggered by INSERT/UPDATE
          -- Do an upsert on the tags table
          -- So we don't need to migrate pre 1.1 entities
          INSERT INTO tags VALUES (NEW.id, TG_TABLE_NAME, NEW.tags)
          ON CONFLICT (entity_id) DO UPDATE
                  SET tags=EXCLUDED.tags;
          END IF;
          RETURN NEW;
        END;
      $$;
 "   DROP FUNCTION public.sync_tags();
       public          kong    false    7            ?            1259    16910    acls    TABLE       CREATE TABLE public.acls (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    "group" text,
    cache_key text,
    tags text[],
    ws_id uuid
);
    DROP TABLE public.acls;
       public            kong    false    7            ?            1259    16954    acme_storage    TABLE     ?   CREATE TABLE public.acme_storage (
    id uuid NOT NULL,
    key text,
    value text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);
     DROP TABLE public.acme_storage;
       public            kong    false    7            ?            1259    17806    admins    TABLE     ?  CREATE TABLE public.admins (
    id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    rbac_user_id uuid,
    rbac_token_enabled boolean NOT NULL,
    email text,
    status integer,
    username text,
    custom_id text,
    username_lower text
);
    DROP TABLE public.admins;
       public            kong    false    7                        1259    17948    application_instances    TABLE     Z  CREATE TABLE public.application_instances (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status integer,
    service_id uuid,
    application_id uuid,
    composite_id text,
    suspended boolean NOT NULL,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
 )   DROP TABLE public.application_instances;
       public            kong    false    7            ?            1259    17929    applications    TABLE     d  CREATE TABLE public.applications (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name text,
    description text,
    redirect_uri text,
    meta text,
    developer_id uuid,
    consumer_id uuid,
    custom_id text,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
     DROP TABLE public.applications;
       public            kong    false    7            ?            1259    17848    audit_objects    TABLE     r  CREATE TABLE public.audit_objects (
    id uuid NOT NULL,
    request_id character(32),
    entity_key uuid,
    dao_name text NOT NULL,
    operation character(6) NOT NULL,
    entity text,
    rbac_user_id uuid,
    signature text,
    ttl timestamp with time zone DEFAULT (timezone('utc'::text, ('now'::text)::timestamp(0) with time zone) + '720:00:00'::interval)
);
 !   DROP TABLE public.audit_objects;
       public            kong    false    7            ?            1259    17857    audit_requests    TABLE     -  CREATE TABLE public.audit_requests (
    request_id character(32) NOT NULL,
    request_timestamp timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(3) with time zone),
    client_ip text NOT NULL,
    path text NOT NULL,
    method text NOT NULL,
    payload text,
    status integer NOT NULL,
    rbac_user_id uuid,
    workspace uuid,
    signature text,
    ttl timestamp with time zone DEFAULT (timezone('utc'::text, ('now'::text)::timestamp(0) with time zone) + '720:00:00'::interval),
    removed_from_payload text
);
 "   DROP TABLE public.audit_requests;
       public            kong    false    7            ?            1259    16965    basicauth_credentials    TABLE       CREATE TABLE public.basicauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    password text,
    tags text[],
    ws_id uuid
);
 )   DROP TABLE public.basicauth_credentials;
       public            kong    false    7            ?            1259    16585    ca_certificates    TABLE     ?   CREATE TABLE public.ca_certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text NOT NULL,
    tags text[],
    cert_digest text NOT NULL
);
 #   DROP TABLE public.ca_certificates;
       public            kong    false    7            ?            1259    16440    certificates    TABLE       CREATE TABLE public.certificates (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    cert text,
    key text,
    tags text[],
    ws_id uuid,
    cert_alt text,
    key_alt text
);
     DROP TABLE public.certificates;
       public            kong    false    7            ?            1259    16402    cluster_events    TABLE     ?   CREATE TABLE public.cluster_events (
    id uuid NOT NULL,
    node_id uuid NOT NULL,
    at timestamp with time zone NOT NULL,
    nbf timestamp with time zone,
    expire_at timestamp with time zone NOT NULL,
    channel text,
    data text
);
 "   DROP TABLE public.cluster_events;
       public            kong    false    7            ?            1259    16825    clustering_data_planes    TABLE     s  CREATE TABLE public.clustering_data_planes (
    id uuid NOT NULL,
    hostname text NOT NULL,
    ip text NOT NULL,
    last_seen timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    config_hash text NOT NULL,
    ttl timestamp with time zone,
    version text,
    sync_status text DEFAULT 'unknown'::text NOT NULL
);
 *   DROP TABLE public.clustering_data_planes;
       public            kong    false    7                       1259    18244    consumer_group_consumers    TABLE     ?   CREATE TABLE public.consumer_group_consumers (
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_group_id uuid NOT NULL,
    consumer_id uuid NOT NULL,
    cache_key text
);
 ,   DROP TABLE public.consumer_group_consumers;
       public            kong    false    7                       1259    18226    consumer_group_plugins    TABLE     `  CREATE TABLE public.consumer_group_plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_group_id uuid,
    name text NOT NULL,
    cache_key text,
    config jsonb NOT NULL,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
 *   DROP TABLE public.consumer_group_plugins;
       public            kong    false    7                       1259    18214    consumer_groups    TABLE       CREATE TABLE public.consumer_groups (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
 #   DROP TABLE public.consumer_groups;
       public            kong    false    7            ?            1259    17790    consumer_reset_secrets    TABLE     ?  CREATE TABLE public.consumer_reset_secrets (
    id uuid NOT NULL,
    consumer_id uuid,
    secret text,
    status integer,
    client_addr text,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(0) with time zone),
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(0) with time zone)
);
 *   DROP TABLE public.consumer_reset_secrets;
       public            kong    false    7            ?            1259    16466 	   consumers    TABLE     1  CREATE TABLE public.consumers (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    username text,
    custom_id text,
    tags text[],
    ws_id uuid,
    username_lower text,
    type integer DEFAULT 0 NOT NULL
);
    DROP TABLE public.consumers;
       public            kong    false    7            ?            1259    17774    credentials    TABLE       CREATE TABLE public.credentials (
    id uuid NOT NULL,
    consumer_id uuid,
    consumer_type integer,
    plugin text NOT NULL,
    credential_data json,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(0) with time zone)
);
    DROP TABLE public.credentials;
       public            kong    false    7            ?            1259    17009    degraphql_routes    TABLE     ?   CREATE TABLE public.degraphql_routes (
    id uuid NOT NULL,
    service_id uuid,
    methods text[],
    uri text,
    query text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);
 $   DROP TABLE public.degraphql_routes;
       public            kong    false    7            ?            1259    17830 
   developers    TABLE     J  CREATE TABLE public.developers (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email text,
    status integer,
    meta text,
    custom_id text,
    consumer_id uuid,
    rbac_user_id uuid,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
    DROP TABLE public.developers;
       public            kong    false    7                       1259    17968    document_objects    TABLE        CREATE TABLE public.document_objects (
    id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    service_id uuid,
    path text,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
 $   DROP TABLE public.document_objects;
       public            kong    false    7                       1259    17983    event_hooks    TABLE     1  CREATE TABLE public.event_hooks (
    id uuid,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    source text NOT NULL,
    event text,
    handler text NOT NULL,
    on_change boolean,
    snooze integer,
    config json NOT NULL
);
    DROP TABLE public.event_hooks;
       public            kong    false    7            ?            1259    17736    files    TABLE     -  CREATE TABLE public.files (
    id uuid NOT NULL,
    path text NOT NULL,
    checksum text,
    contents text,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(0) with time zone),
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
    DROP TABLE public.files;
       public            kong    false    7            ?            1259    17023 -   graphql_ratelimiting_advanced_cost_decoration    TABLE     Q  CREATE TABLE public.graphql_ratelimiting_advanced_cost_decoration (
    id uuid NOT NULL,
    service_id uuid,
    type_path text,
    add_arguments text[],
    add_constant double precision,
    mul_arguments text[],
    mul_constant double precision,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);
 A   DROP TABLE public.graphql_ratelimiting_advanced_cost_decoration;
       public            kong    false    7            ?            1259    17879    group_rbac_roles    TABLE     ?   CREATE TABLE public.group_rbac_roles (
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    group_id uuid NOT NULL,
    rbac_role_id uuid NOT NULL,
    workspace_id uuid
);
 $   DROP TABLE public.group_rbac_roles;
       public            kong    false    7            ?            1259    17867    groups    TABLE     ?   CREATE TABLE public.groups (
    id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text,
    comment text
);
    DROP TABLE public.groups;
       public            kong    false    7            ?            1259    17037    hmacauth_credentials    TABLE       CREATE TABLE public.hmacauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    username text,
    secret text,
    tags text[],
    ws_id uuid
);
 (   DROP TABLE public.hmacauth_credentials;
       public            kong    false    7            ?            1259    17081    jwt_secrets    TABLE     0  CREATE TABLE public.jwt_secrets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    secret text,
    algorithm text,
    rsa_public_key text,
    tags text[],
    ws_id uuid
);
    DROP TABLE public.jwt_secrets;
       public            kong    false    7            ?            1259    17127    jwt_signer_jwks    TABLE     ?   CREATE TABLE public.jwt_signer_jwks (
    id uuid NOT NULL,
    name text NOT NULL,
    keys jsonb[] NOT NULL,
    previous jsonb[],
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);
 #   DROP TABLE public.jwt_signer_jwks;
       public            kong    false    7            ?            1259    17153    keyauth_credentials    TABLE       CREATE TABLE public.keyauth_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    tags text[],
    ttl timestamp with time zone,
    ws_id uuid
);
 '   DROP TABLE public.keyauth_credentials;
       public            kong    false    7            ?            1259    17199    keyauth_enc_credentials    TABLE       CREATE TABLE public.keyauth_enc_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid,
    key text,
    key_ident text,
    ws_id uuid
);
 +   DROP TABLE public.keyauth_enc_credentials;
       public            kong    false    7            	           1259    18309    keyring_keys    TABLE     ?   CREATE TABLE public.keyring_keys (
    id text NOT NULL,
    recovery_key_id text NOT NULL,
    key_encrypted text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);
     DROP TABLE public.keyring_keys;
       public            kong    false    7            ?            1259    17921    keyring_meta    TABLE     ?   CREATE TABLE public.keyring_meta (
    id text NOT NULL,
    state text NOT NULL,
    created_at timestamp with time zone NOT NULL
);
     DROP TABLE public.keyring_meta;
       public            kong    false    7            ?            1259    17251    konnect_applications    TABLE     ?   CREATE TABLE public.konnect_applications (
    id uuid NOT NULL,
    ws_id uuid,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    client_id text,
    scopes text[],
    tags text[]
);
 (   DROP TABLE public.konnect_applications;
       public            kong    false    7            ?            1259    17748    legacy_files    TABLE       CREATE TABLE public.legacy_files (
    id uuid NOT NULL,
    auth boolean NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    contents text,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, ('now'::text)::timestamp(0) with time zone)
);
     DROP TABLE public.legacy_files;
       public            kong    false    7            ?            1259    17900    license_data    TABLE     ?   CREATE TABLE public.license_data (
    node_id uuid NOT NULL,
    req_cnt bigint,
    license_creation_date timestamp without time zone,
    year smallint NOT NULL,
    month smallint NOT NULL
);
     DROP TABLE public.license_data;
       public            kong    false    7                       1259    18187    licenses    TABLE     ?   CREATE TABLE public.licenses (
    id uuid NOT NULL,
    payload text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);
    DROP TABLE public.licenses;
       public            kong    false    7            ?            1259    16393    locks    TABLE     g   CREATE TABLE public.locks (
    key text NOT NULL,
    owner text,
    ttl timestamp with time zone
);
    DROP TABLE public.locks;
       public            kong    false    7            ?            1259    17906    login_attempts    TABLE       CREATE TABLE public.login_attempts (
    consumer_id uuid NOT NULL,
    attempts json DEFAULT '{}'::json,
    ttl timestamp with time zone,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone)
);
 "   DROP TABLE public.login_attempts;
       public            kong    false    7            ?            1259    17271    mtls_auth_credentials    TABLE     J  CREATE TABLE public.mtls_auth_credentials (
    id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    consumer_id uuid NOT NULL,
    subject_name text NOT NULL,
    ca_certificate_id uuid,
    cache_key text,
    ws_id uuid,
    tags text[]
);
 )   DROP TABLE public.mtls_auth_credentials;
       public            kong    false    7            ?            1259    17339    oauth2_authorization_codes    TABLE     ?  CREATE TABLE public.oauth2_authorization_codes (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    code text,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    challenge text,
    challenge_method text,
    ws_id uuid
);
 .   DROP TABLE public.oauth2_authorization_codes;
       public            kong    false    7            ?            1259    17321    oauth2_credentials    TABLE     o  CREATE TABLE public.oauth2_credentials (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text,
    consumer_id uuid,
    client_id text,
    client_secret text,
    redirect_uris text[],
    tags text[],
    client_type text,
    hash_secret boolean,
    ws_id uuid
);
 &   DROP TABLE public.oauth2_credentials;
       public            kong    false    7            ?            1259    17363    oauth2_tokens    TABLE     ?  CREATE TABLE public.oauth2_tokens (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    credential_id uuid,
    service_id uuid,
    access_token text,
    refresh_token text,
    token_type text,
    expires_in integer,
    authenticated_userid text,
    scope text,
    ttl timestamp with time zone,
    ws_id uuid
);
 !   DROP TABLE public.oauth2_tokens;
       public            kong    false    7            ?            1259    17486    oic_issuers    TABLE     ?   CREATE TABLE public.oic_issuers (
    id uuid NOT NULL,
    issuer text,
    configuration text,
    keys text,
    secret text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone)
);
    DROP TABLE public.oic_issuers;
       public            kong    false    7            ?            1259    17498    oic_jwks    TABLE     G   CREATE TABLE public.oic_jwks (
    id uuid NOT NULL,
    jwks jsonb
);
    DROP TABLE public.oic_jwks;
       public            kong    false    7            ?            1259    16835 
   parameters    TABLE     |   CREATE TABLE public.parameters (
    key text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone
);
    DROP TABLE public.parameters;
       public            kong    false    7            ?            1259    16480    plugins    TABLE     ?  CREATE TABLE public.plugins (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    consumer_id uuid,
    service_id uuid,
    route_id uuid,
    config jsonb NOT NULL,
    enabled boolean NOT NULL,
    cache_key text,
    protocols text[],
    tags text[],
    ws_id uuid,
    ordering jsonb
);
    DROP TABLE public.plugins;
       public            kong    false    7            ?            1259    17507    ratelimiting_metrics    TABLE     q  CREATE TABLE public.ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer,
    ttl timestamp with time zone
);
 (   DROP TABLE public.ratelimiting_metrics;
       public            kong    false    7            ?            1259    17721    rbac_role_endpoints    TABLE     C  CREATE TABLE public.rbac_role_endpoints (
    role_id uuid NOT NULL,
    workspace text NOT NULL,
    endpoint text NOT NULL,
    actions smallint NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    negative boolean NOT NULL
);
 '   DROP TABLE public.rbac_role_endpoints;
       public            kong    false    7            ?            1259    17706    rbac_role_entities    TABLE     E  CREATE TABLE public.rbac_role_entities (
    role_id uuid NOT NULL,
    entity_id text NOT NULL,
    entity_type text NOT NULL,
    actions smallint NOT NULL,
    negative boolean NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone)
);
 &   DROP TABLE public.rbac_role_entities;
       public            kong    false    7            ?            1259    17677 
   rbac_roles    TABLE     A  CREATE TABLE public.rbac_roles (
    id uuid NOT NULL,
    name text NOT NULL,
    comment text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    is_default boolean DEFAULT false,
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
    DROP TABLE public.rbac_roles;
       public            kong    false    7            ?            1259    17689    rbac_user_roles    TABLE     ^   CREATE TABLE public.rbac_user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);
 #   DROP TABLE public.rbac_user_roles;
       public            kong    false    7            ?            1259    17661 
   rbac_users    TABLE     r  CREATE TABLE public.rbac_users (
    id uuid NOT NULL,
    name text NOT NULL,
    user_token text NOT NULL,
    user_token_ident text,
    comment text,
    enabled boolean NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    ws_id uuid DEFAULT 'db8d9a77-6e83-4c04-8de9-9e8819692767'::uuid
);
    DROP TABLE public.rbac_users;
       public            kong    false    7            ?            1259    17519    response_ratelimiting_metrics    TABLE     X  CREATE TABLE public.response_ratelimiting_metrics (
    identifier text NOT NULL,
    period text NOT NULL,
    period_date timestamp with time zone NOT NULL,
    service_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    route_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    value integer
);
 1   DROP TABLE public.response_ratelimiting_metrics;
       public            kong    false    7            ?            1259    17561    rl_counters    TABLE     ?   CREATE TABLE public.rl_counters (
    key text NOT NULL,
    namespace text NOT NULL,
    window_start integer NOT NULL,
    window_size integer NOT NULL,
    count integer
);
    DROP TABLE public.rl_counters;
       public            kong    false    7            ?            1259    16424    routes    TABLE     w  CREATE TABLE public.routes (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    service_id uuid,
    protocols text[],
    methods text[],
    hosts text[],
    paths text[],
    snis text[],
    sources jsonb[],
    destinations jsonb[],
    regex_priority bigint,
    strip_path boolean,
    preserve_host boolean,
    tags text[],
    https_redirect_status_code integer,
    headers jsonb,
    path_handling text DEFAULT 'v0'::text,
    ws_id uuid,
    request_buffering boolean,
    response_buffering boolean,
    expression text,
    priority bigint
);
    DROP TABLE public.routes;
       public            kong    false    7            ?            1259    16385    schema_meta    TABLE     ?   CREATE TABLE public.schema_meta (
    key text NOT NULL,
    subsystem text NOT NULL,
    last_executed text,
    executed text[],
    pending text[]
);
    DROP TABLE public.schema_meta;
       public            kong    false    7            ?            1259    16414    services    TABLE     ?  CREATE TABLE public.services (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    retries bigint,
    protocol text,
    host text,
    port bigint,
    path text,
    connect_timeout bigint,
    write_timeout bigint,
    read_timeout bigint,
    tags text[],
    client_certificate_id uuid,
    tls_verify boolean,
    tls_verify_depth smallint,
    ca_certificates uuid[],
    ws_id uuid,
    enabled boolean DEFAULT true
);
    DROP TABLE public.services;
       public            kong    false    7            ?            1259    17529    sessions    TABLE     ?   CREATE TABLE public.sessions (
    id uuid NOT NULL,
    session_id text,
    expires integer,
    data text,
    created_at timestamp with time zone,
    ttl timestamp with time zone
);
    DROP TABLE public.sessions;
       public            kong    false    7            ?            1259    16886 	   sm_vaults    TABLE     O  CREATE TABLE public.sm_vaults (
    id uuid NOT NULL,
    ws_id uuid,
    prefix text,
    name text NOT NULL,
    description text,
    config jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    updated_at timestamp with time zone,
    tags text[]
);
    DROP TABLE public.sm_vaults;
       public            kong    false    7            ?            1259    16449    snis    TABLE     ?   CREATE TABLE public.snis (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    name text NOT NULL,
    certificate_id uuid,
    tags text[],
    ws_id uuid
);
    DROP TABLE public.snis;
       public            kong    false    7            ?            1259    16557    tags    TABLE     a   CREATE TABLE public.tags (
    entity_id uuid NOT NULL,
    entity_name text,
    tags text[]
);
    DROP TABLE public.tags;
       public            kong    false    7            ?            1259    16522    targets    TABLE     +  CREATE TABLE public.targets (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    upstream_id uuid,
    target text NOT NULL,
    weight integer NOT NULL,
    tags text[],
    ws_id uuid,
    cache_key text
);
    DROP TABLE public.targets;
       public            kong    false    7            ?            1259    16547    ttls    TABLE     ?   CREATE TABLE public.ttls (
    primary_key_value text NOT NULL,
    primary_uuid_value uuid,
    table_name text NOT NULL,
    primary_key_name text NOT NULL,
    expire_at timestamp without time zone NOT NULL
);
    DROP TABLE public.ttls;
       public            kong    false    7            ?            1259    16511 	   upstreams    TABLE     r  CREATE TABLE public.upstreams (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(3) with time zone),
    name text,
    hash_on text,
    hash_fallback text,
    hash_on_header text,
    hash_fallback_header text,
    hash_on_cookie text,
    hash_on_cookie_path text,
    slots integer NOT NULL,
    healthchecks jsonb,
    tags text[],
    algorithm text,
    host_header text,
    client_certificate_id uuid,
    ws_id uuid,
    hash_on_query_arg text,
    hash_fallback_query_arg text,
    hash_on_uri_capture text,
    hash_fallback_uri_capture text
);
    DROP TABLE public.upstreams;
       public            kong    false    7            ?            1259    17551    vault_auth_vaults    TABLE     ?   CREATE TABLE public.vault_auth_vaults (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    protocol text,
    host text,
    port bigint,
    mount text,
    vault_token text
);
 %   DROP TABLE public.vault_auth_vaults;
       public            kong    false    7            ?            1259    17541    vaults    TABLE     ?   CREATE TABLE public.vaults (
    id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    protocol text,
    host text,
    port bigint,
    mount text,
    vault_token text
);
    DROP TABLE public.vaults;
       public            kong    false    7            ?            1259    17609    vitals_code_classes_by_cluster    TABLE     ?   CREATE TABLE public.vitals_code_classes_by_cluster (
    code_class integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
);
 2   DROP TABLE public.vitals_code_classes_by_cluster;
       public            kong    false    7            ?            1259    17625     vitals_code_classes_by_workspace    TABLE     ?   CREATE TABLE public.vitals_code_classes_by_workspace (
    workspace_id uuid NOT NULL,
    code_class integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
);
 4   DROP TABLE public.vitals_code_classes_by_workspace;
       public            kong    false    7            ?            1259    17620    vitals_codes_by_consumer_route    TABLE     S  CREATE TABLE public.vitals_codes_by_consumer_route (
    consumer_id uuid NOT NULL,
    service_id uuid,
    route_id uuid NOT NULL,
    code integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
)
WITH (autovacuum_vacuum_scale_factor='0.01', autovacuum_analyze_scale_factor='0.01');
 2   DROP TABLE public.vitals_codes_by_consumer_route;
       public            kong    false    7            ?            1259    17614    vitals_codes_by_route    TABLE     +  CREATE TABLE public.vitals_codes_by_route (
    service_id uuid,
    route_id uuid NOT NULL,
    code integer NOT NULL,
    at timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    count integer
)
WITH (autovacuum_vacuum_scale_factor='0.01', autovacuum_analyze_scale_factor='0.01');
 )   DROP TABLE public.vitals_codes_by_route;
       public            kong    false    7            ?            1259    17630    vitals_locks    TABLE     a   CREATE TABLE public.vitals_locks (
    key text NOT NULL,
    expiry timestamp with time zone
);
     DROP TABLE public.vitals_locks;
       public            kong    false    7            ?            1259    17601    vitals_node_meta    TABLE     ?   CREATE TABLE public.vitals_node_meta (
    node_id uuid NOT NULL,
    first_report timestamp without time zone,
    last_report timestamp without time zone,
    hostname text
);
 $   DROP TABLE public.vitals_node_meta;
       public            kong    false    7                       1259    18175    vitals_stats_days    TABLE     ?  CREATE TABLE public.vitals_stats_days (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);
 %   DROP TABLE public.vitals_stats_days;
       public            kong    false    7            ?            1259    17570    vitals_stats_hours    TABLE     ?   CREATE TABLE public.vitals_stats_hours (
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer
);
 &   DROP TABLE public.vitals_stats_hours;
       public            kong    false    7            ?            1259    17589    vitals_stats_minutes    TABLE     ?  CREATE TABLE public.vitals_stats_minutes (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);
 (   DROP TABLE public.vitals_stats_minutes;
       public            kong    false    7            ?            1259    17577    vitals_stats_seconds    TABLE     ?  CREATE TABLE public.vitals_stats_seconds (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);
 (   DROP TABLE public.vitals_stats_seconds;
       public            kong    false    7            
           1259    18902    vitals_stats_seconds_1669438800    TABLE     ?  CREATE TABLE public.vitals_stats_seconds_1669438800 (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);
 3   DROP TABLE public.vitals_stats_seconds_1669438800;
       public            kong    false    7                       1259    18914    vitals_stats_seconds_1669442400    TABLE     ?  CREATE TABLE public.vitals_stats_seconds_1669442400 (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);
 3   DROP TABLE public.vitals_stats_seconds_1669442400;
       public            kong    false    7                       1259    18927    vitals_stats_seconds_1669446000    TABLE     ?  CREATE TABLE public.vitals_stats_seconds_1669446000 (
    node_id uuid NOT NULL,
    at integer NOT NULL,
    l2_hit integer DEFAULT 0,
    l2_miss integer DEFAULT 0,
    plat_min integer,
    plat_max integer,
    ulat_min integer,
    ulat_max integer,
    requests integer DEFAULT 0,
    plat_count integer DEFAULT 0,
    plat_total integer DEFAULT 0,
    ulat_count integer DEFAULT 0,
    ulat_total integer DEFAULT 0
);
 3   DROP TABLE public.vitals_stats_seconds_1669446000;
       public            kong    false    7            ?            1259    17638    workspace_entities    TABLE     ?   CREATE TABLE public.workspace_entities (
    workspace_id uuid NOT NULL,
    workspace_name text,
    entity_id text NOT NULL,
    entity_type text,
    unique_field_name text NOT NULL,
    unique_field_value text
);
 &   DROP TABLE public.workspace_entities;
       public            kong    false    7            ?            1259    17648    workspace_entity_counters    TABLE     ?   CREATE TABLE public.workspace_entity_counters (
    workspace_id uuid NOT NULL,
    entity_type text NOT NULL,
    count integer
);
 -   DROP TABLE public.workspace_entity_counters;
       public            kong    false    7            ?            1259    16623 
   workspaces    TABLE     ?   CREATE TABLE public.workspaces (
    id uuid NOT NULL,
    name text,
    comment text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone),
    meta jsonb,
    config jsonb
);
    DROP TABLE public.workspaces;
       public            kong    false    7                       1259    17992    ws_migrations_backup    TABLE       CREATE TABLE public.ws_migrations_backup (
    entity_type text,
    entity_id text,
    unique_field_name text,
    unique_field_value text,
    created_at timestamp with time zone DEFAULT timezone('UTC'::text, ('now'::text)::timestamp(0) with time zone)
);
 (   DROP TABLE public.ws_migrations_backup;
       public            kong    false    7            K          0    16910    acls 
   TABLE DATA                 public          kong    false    203   ݸ      L          0    16954    acme_storage 
   TABLE DATA                 public          kong    false    204   ??      v          0    17806    admins 
   TABLE DATA                 public          kong    false    246   ?      ?          0    17948    application_instances 
   TABLE DATA                 public          kong    false    256   (?                0    17929    applications 
   TABLE DATA                 public          kong    false    255   B?      x          0    17848    audit_objects 
   TABLE DATA                 public          kong    false    248   \?      y          0    17857    audit_requests 
   TABLE DATA                 public          kong    false    249   v?      M          0    16965    basicauth_credentials 
   TABLE DATA                 public          kong    false    205   ??      F          0    16585    ca_certificates 
   TABLE DATA                 public          kong    false    198   ??      >          0    16440    certificates 
   TABLE DATA                 public          kong    false    190   ??      ;          0    16402    cluster_events 
   TABLE DATA                 public          kong    false    187   ׻      H          0    16825    clustering_data_planes 
   TABLE DATA                 public          kong    false    200   T?      ?          0    18244    consumer_group_consumers 
   TABLE DATA                 public          kong    false    264   n?      ?          0    18226    consumer_group_plugins 
   TABLE DATA                 public          kong    false    263   ??      ?          0    18214    consumer_groups 
   TABLE DATA                 public          kong    false    262   ??      u          0    17790    consumer_reset_secrets 
   TABLE DATA                 public          kong    false    245   ??      @          0    16466 	   consumers 
   TABLE DATA                 public          kong    false    192   ??      t          0    17774    credentials 
   TABLE DATA                 public          kong    false    244   ?      N          0    17009    degraphql_routes 
   TABLE DATA                 public          kong    false    206   ?      w          0    17830 
   developers 
   TABLE DATA                 public          kong    false    247   9?      ?          0    17968    document_objects 
   TABLE DATA                 public          kong    false    257   S?      ?          0    17983    event_hooks 
   TABLE DATA                 public          kong    false    258   m?      r          0    17736    files 
   TABLE DATA                 public          kong    false    242   ??      O          0    17023 -   graphql_ratelimiting_advanced_cost_decoration 
   TABLE DATA                 public          kong    false    207   ??      {          0    17879    group_rbac_roles 
   TABLE DATA                 public          kong    false    251   ??      z          0    17867    groups 
   TABLE DATA                 public          kong    false    250   ??      P          0    17037    hmacauth_credentials 
   TABLE DATA                 public          kong    false    208   ??      Q          0    17081    jwt_secrets 
   TABLE DATA                 public          kong    false    209   	?      R          0    17127    jwt_signer_jwks 
   TABLE DATA                 public          kong    false    210   B?      S          0    17153    keyauth_credentials 
   TABLE DATA                 public          kong    false    211   \?      T          0    17199    keyauth_enc_credentials 
   TABLE DATA                 public          kong    false    212   t?      ?          0    18309    keyring_keys 
   TABLE DATA                 public          kong    false    265   ??      ~          0    17921    keyring_meta 
   TABLE DATA                 public          kong    false    254   ??      U          0    17251    konnect_applications 
   TABLE DATA                 public          kong    false    213   ??      s          0    17748    legacy_files 
   TABLE DATA                 public          kong    false    243   ??      |          0    17900    license_data 
   TABLE DATA                 public          kong    false    252   ??      ?          0    18187    licenses 
   TABLE DATA                 public          kong    false    261   ;?      :          0    16393    locks 
   TABLE DATA                 public          kong    false    186   U?      }          0    17906    login_attempts 
   TABLE DATA                 public          kong    false    253   o?      V          0    17271    mtls_auth_credentials 
   TABLE DATA                 public          kong    false    214   ??      X          0    17339    oauth2_authorization_codes 
   TABLE DATA                 public          kong    false    216   ??      W          0    17321    oauth2_credentials 
   TABLE DATA                 public          kong    false    215   ??      Y          0    17363    oauth2_tokens 
   TABLE DATA                 public          kong    false    217   ??      Z          0    17486    oic_issuers 
   TABLE DATA                 public          kong    false    218   ??      [          0    17498    oic_jwks 
   TABLE DATA                 public          kong    false    219   ?      I          0    16835 
   parameters 
   TABLE DATA                 public          kong    false    201   >?      A          0    16480    plugins 
   TABLE DATA                 public          kong    false    193   ??      \          0    17507    ratelimiting_metrics 
   TABLE DATA                 public          kong    false    220   4?      q          0    17721    rbac_role_endpoints 
   TABLE DATA                 public          kong    false    241   N?      p          0    17706    rbac_role_entities 
   TABLE DATA                 public          kong    false    240   o?      n          0    17677 
   rbac_roles 
   TABLE DATA                 public          kong    false    238   ??      o          0    17689    rbac_user_roles 
   TABLE DATA                 public          kong    false    239   X?      m          0    17661 
   rbac_users 
   TABLE DATA                 public          kong    false    237   B?      ]          0    17519    response_ratelimiting_metrics 
   TABLE DATA                 public          kong    false    221   ??      a          0    17561    rl_counters 
   TABLE DATA                 public          kong    false    225   ??      =          0    16424    routes 
   TABLE DATA                 public          kong    false    189   ??      9          0    16385    schema_meta 
   TABLE DATA                 public          kong    false    185   P?      <          0    16414    services 
   TABLE DATA                 public          kong    false    188   ??      ^          0    17529    sessions 
   TABLE DATA                 public          kong    false    222   J?      J          0    16886 	   sm_vaults 
   TABLE DATA                 public          kong    false    202   d?      ?          0    16449    snis 
   TABLE DATA                 public          kong    false    191   ~?      E          0    16557    tags 
   TABLE DATA                 public          kong    false    197   ??      C          0    16522    targets 
   TABLE DATA                 public          kong    false    195   ?       D          0    16547    ttls 
   TABLE DATA                 public          kong    false    196   '      B          0    16511 	   upstreams 
   TABLE DATA                 public          kong    false    194   A      `          0    17551    vault_auth_vaults 
   TABLE DATA                 public          kong    false    224   ?      _          0    17541    vaults 
   TABLE DATA                 public          kong    false    223   ?      f          0    17609    vitals_code_classes_by_cluster 
   TABLE DATA                 public          kong    false    230   ?      i          0    17625     vitals_code_classes_by_workspace 
   TABLE DATA                 public          kong    false    233   ?      h          0    17620    vitals_codes_by_consumer_route 
   TABLE DATA                 public          kong    false    232   ?      g          0    17614    vitals_codes_by_route 
   TABLE DATA                 public          kong    false    231         j          0    17630    vitals_locks 
   TABLE DATA                 public          kong    false    234         e          0    17601    vitals_node_meta 
   TABLE DATA                 public          kong    false    229   ?      ?          0    18175    vitals_stats_days 
   TABLE DATA                 public          kong    false    260   !      b          0    17570    vitals_stats_hours 
   TABLE DATA                 public          kong    false    226   ;      d          0    17589    vitals_stats_minutes 
   TABLE DATA                 public          kong    false    228   U      c          0    17577    vitals_stats_seconds 
   TABLE DATA                 public          kong    false    227   a      ?          0    18902    vitals_stats_seconds_1669438800 
   TABLE DATA                 public          kong    false    266   {      ?          0    18914    vitals_stats_seconds_1669442400 
   TABLE DATA                 public          kong    false    267   ?4      ?          0    18927    vitals_stats_seconds_1669446000 
   TABLE DATA                 public          kong    false    268   -\      k          0    17638    workspace_entities 
   TABLE DATA                 public          kong    false    235   X]      l          0    17648    workspace_entity_counters 
   TABLE DATA                 public          kong    false    236   ?_      G          0    16623 
   workspaces 
   TABLE DATA                 public          kong    false    199   ?`      ?          0    17992    ws_migrations_backup 
   TABLE DATA                 public          kong    false    259   <a      :
           2606    16920    acls acls_cache_key_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_cache_key_key UNIQUE (cache_key);
 A   ALTER TABLE ONLY public.acls DROP CONSTRAINT acls_cache_key_key;
       public            kong    false    203            >
           2606    16948    acls acls_id_ws_id_unique 
   CONSTRAINT     Y   ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_id_ws_id_unique UNIQUE (id, ws_id);
 C   ALTER TABLE ONLY public.acls DROP CONSTRAINT acls_id_ws_id_unique;
       public            kong    false    203    203            @
           2606    16918    acls acls_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.acls DROP CONSTRAINT acls_pkey;
       public            kong    false    203            C
           2606    16963 !   acme_storage acme_storage_key_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_key_key UNIQUE (key);
 K   ALTER TABLE ONLY public.acme_storage DROP CONSTRAINT acme_storage_key_key;
       public            kong    false    204            E
           2606    16961    acme_storage acme_storage_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.acme_storage
    ADD CONSTRAINT acme_storage_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.acme_storage DROP CONSTRAINT acme_storage_pkey;
       public            kong    false    204                       2606    17819    admins admins_custom_id_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_custom_id_key UNIQUE (custom_id);
 E   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_custom_id_key;
       public            kong    false    246                       2606    17815    admins admins_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_pkey;
       public            kong    false    246                       2606    17817    admins admins_username_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);
 D   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_username_key;
       public            kong    false    246            7           2606    18159 ;   application_instances application_instances_id_ws_id_unique 
   CONSTRAINT     {   ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_id_ws_id_unique UNIQUE (id, ws_id);
 e   ALTER TABLE ONLY public.application_instances DROP CONSTRAINT application_instances_id_ws_id_unique;
       public            kong    false    256    256            9           2606    17955 0   application_instances application_instances_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.application_instances DROP CONSTRAINT application_instances_pkey;
       public            kong    false    256            ;           2606    18171 E   application_instances application_instances_ws_id_composite_id_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_ws_id_composite_id_unique UNIQUE (ws_id, composite_id);
 o   ALTER TABLE ONLY public.application_instances DROP CONSTRAINT application_instances_ws_id_composite_id_unique;
       public            kong    false    256    256            0           2606    18000 '   applications applications_custom_id_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_custom_id_key UNIQUE (custom_id);
 Q   ALTER TABLE ONLY public.applications DROP CONSTRAINT applications_custom_id_key;
       public            kong    false    255            3           2606    18133 )   applications applications_id_ws_id_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_id_ws_id_unique UNIQUE (id, ws_id);
 S   ALTER TABLE ONLY public.applications DROP CONSTRAINT applications_id_ws_id_unique;
       public            kong    false    255    255            5           2606    17936    applications applications_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.applications DROP CONSTRAINT applications_pkey;
       public            kong    false    255                       2606    17856     audit_objects audit_objects_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.audit_objects
    ADD CONSTRAINT audit_objects_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.audit_objects DROP CONSTRAINT audit_objects_pkey;
       public            kong    false    248                        2606    17866 "   audit_requests audit_requests_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.audit_requests
    ADD CONSTRAINT audit_requests_pkey PRIMARY KEY (request_id);
 L   ALTER TABLE ONLY public.audit_requests DROP CONSTRAINT audit_requests_pkey;
       public            kong    false    249            I
           2606    17001 ;   basicauth_credentials basicauth_credentials_id_ws_id_unique 
   CONSTRAINT     {   ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);
 e   ALTER TABLE ONLY public.basicauth_credentials DROP CONSTRAINT basicauth_credentials_id_ws_id_unique;
       public            kong    false    205    205            K
           2606    16973 0   basicauth_credentials basicauth_credentials_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.basicauth_credentials DROP CONSTRAINT basicauth_credentials_pkey;
       public            kong    false    205            M
           2606    17008 A   basicauth_credentials basicauth_credentials_ws_id_username_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);
 k   ALTER TABLE ONLY public.basicauth_credentials DROP CONSTRAINT basicauth_credentials_ws_id_username_unique;
       public            kong    false    205    205            $
           2606    16616 /   ca_certificates ca_certificates_cert_digest_key 
   CONSTRAINT     q   ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_cert_digest_key UNIQUE (cert_digest);
 Y   ALTER TABLE ONLY public.ca_certificates DROP CONSTRAINT ca_certificates_cert_digest_key;
       public            kong    false    198            &
           2606    16593 $   ca_certificates ca_certificates_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ca_certificates
    ADD CONSTRAINT ca_certificates_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.ca_certificates DROP CONSTRAINT ca_certificates_pkey;
       public            kong    false    198            ?	           2606    16715 )   certificates certificates_id_ws_id_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_id_ws_id_unique UNIQUE (id, ws_id);
 S   ALTER TABLE ONLY public.certificates DROP CONSTRAINT certificates_id_ws_id_unique;
       public            kong    false    190    190            ?	           2606    16448    certificates certificates_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.certificates DROP CONSTRAINT certificates_pkey;
       public            kong    false    190            ?	           2606    16409 "   cluster_events cluster_events_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.cluster_events
    ADD CONSTRAINT cluster_events_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.cluster_events DROP CONSTRAINT cluster_events_pkey;
       public            kong    false    187            ,
           2606    16833 2   clustering_data_planes clustering_data_planes_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.clustering_data_planes
    ADD CONSTRAINT clustering_data_planes_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.clustering_data_planes DROP CONSTRAINT clustering_data_planes_pkey;
       public            kong    false    200            Z           2606    18254 ?   consumer_group_consumers consumer_group_consumers_cache_key_key 
   CONSTRAINT        ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_cache_key_key UNIQUE (cache_key);
 i   ALTER TABLE ONLY public.consumer_group_consumers DROP CONSTRAINT consumer_group_consumers_cache_key_key;
       public            kong    false    264            ^           2606    18252 6   consumer_group_consumers consumer_group_consumers_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_pkey PRIMARY KEY (consumer_group_id, consumer_id);
 `   ALTER TABLE ONLY public.consumer_group_consumers DROP CONSTRAINT consumer_group_consumers_pkey;
       public            kong    false    264    264            R           2606    18236 ;   consumer_group_plugins consumer_group_plugins_cache_key_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_cache_key_key UNIQUE (cache_key);
 e   ALTER TABLE ONLY public.consumer_group_plugins DROP CONSTRAINT consumer_group_plugins_cache_key_key;
       public            kong    false    263            U           2606    18303 =   consumer_group_plugins consumer_group_plugins_id_ws_id_unique 
   CONSTRAINT     }   ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_id_ws_id_unique UNIQUE (id, ws_id);
 g   ALTER TABLE ONLY public.consumer_group_plugins DROP CONSTRAINT consumer_group_plugins_id_ws_id_unique;
       public            kong    false    263    263            W           2606    18234 2   consumer_group_plugins consumer_group_plugins_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.consumer_group_plugins DROP CONSTRAINT consumer_group_plugins_pkey;
       public            kong    false    263            K           2606    18283 /   consumer_groups consumer_groups_id_ws_id_unique 
   CONSTRAINT     o   ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_id_ws_id_unique UNIQUE (id, ws_id);
 Y   ALTER TABLE ONLY public.consumer_groups DROP CONSTRAINT consumer_groups_id_ws_id_unique;
       public            kong    false    262    262            N           2606    18222 $   consumer_groups consumer_groups_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.consumer_groups DROP CONSTRAINT consumer_groups_pkey;
       public            kong    false    262            P           2606    18285 1   consumer_groups consumer_groups_ws_id_name_unique 
   CONSTRAINT     s   ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_ws_id_name_unique UNIQUE (ws_id, name);
 [   ALTER TABLE ONLY public.consumer_groups DROP CONSTRAINT consumer_groups_ws_id_name_unique;
       public            kong    false    262    262                       2606    17799 2   consumer_reset_secrets consumer_reset_secrets_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.consumer_reset_secrets
    ADD CONSTRAINT consumer_reset_secrets_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.consumer_reset_secrets DROP CONSTRAINT consumer_reset_secrets_pkey;
       public            kong    false    245            ?	           2606    16695 #   consumers consumers_id_ws_id_unique 
   CONSTRAINT     c   ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_id_ws_id_unique UNIQUE (id, ws_id);
 M   ALTER TABLE ONLY public.consumers DROP CONSTRAINT consumers_id_ws_id_unique;
       public            kong    false    192    192            ?	           2606    16474    consumers consumers_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.consumers DROP CONSTRAINT consumers_pkey;
       public            kong    false    192            ?	           2606    16699 *   consumers consumers_ws_id_custom_id_unique 
   CONSTRAINT     q   ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_custom_id_unique UNIQUE (ws_id, custom_id);
 T   ALTER TABLE ONLY public.consumers DROP CONSTRAINT consumers_ws_id_custom_id_unique;
       public            kong    false    192    192            ?	           2606    16697 )   consumers consumers_ws_id_username_unique 
   CONSTRAINT     o   ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_username_unique UNIQUE (ws_id, username);
 S   ALTER TABLE ONLY public.consumers DROP CONSTRAINT consumers_ws_id_username_unique;
       public            kong    false    192    192            	           2606    17782    credentials credentials_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.credentials DROP CONSTRAINT credentials_pkey;
       public            kong    false    244            Q
           2606    17016 &   degraphql_routes degraphql_routes_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.degraphql_routes
    ADD CONSTRAINT degraphql_routes_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.degraphql_routes DROP CONSTRAINT degraphql_routes_pkey;
       public            kong    false    206                       2606    18079 %   developers developers_id_ws_id_unique 
   CONSTRAINT     e   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_id_ws_id_unique UNIQUE (id, ws_id);
 O   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_id_ws_id_unique;
       public            kong    false    247    247                       2606    17837    developers developers_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_pkey;
       public            kong    false    247                       2606    18093 ,   developers developers_ws_id_custom_id_unique 
   CONSTRAINT     s   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_ws_id_custom_id_unique UNIQUE (ws_id, custom_id);
 V   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_ws_id_custom_id_unique;
       public            kong    false    247    247                       2606    18091 (   developers developers_ws_id_email_unique 
   CONSTRAINT     k   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_ws_id_email_unique UNIQUE (ws_id, email);
 R   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_ws_id_email_unique;
       public            kong    false    247    247            =           2606    18109 1   document_objects document_objects_id_ws_id_unique 
   CONSTRAINT     q   ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_id_ws_id_unique UNIQUE (id, ws_id);
 [   ALTER TABLE ONLY public.document_objects DROP CONSTRAINT document_objects_id_ws_id_unique;
       public            kong    false    257    257            ?           2606    17975 &   document_objects document_objects_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.document_objects DROP CONSTRAINT document_objects_pkey;
       public            kong    false    257            A           2606    18116 3   document_objects document_objects_ws_id_path_unique 
   CONSTRAINT     u   ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_ws_id_path_unique UNIQUE (ws_id, path);
 ]   ALTER TABLE ONLY public.document_objects DROP CONSTRAINT document_objects_ws_id_path_unique;
       public            kong    false    257    257            C           2606    17991    event_hooks event_hooks_id_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.event_hooks
    ADD CONSTRAINT event_hooks_id_key UNIQUE (id);
 H   ALTER TABLE ONLY public.event_hooks DROP CONSTRAINT event_hooks_id_key;
       public            kong    false    258            ?
           2606    18059    files files_id_ws_id_unique 
   CONSTRAINT     [   ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_id_ws_id_unique UNIQUE (id, ws_id);
 E   ALTER TABLE ONLY public.files DROP CONSTRAINT files_id_ws_id_unique;
       public            kong    false    242    242            ?
           2606    17744    files files_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.files DROP CONSTRAINT files_pkey;
       public            kong    false    242                        2606    18061    files files_ws_id_path_unique 
   CONSTRAINT     _   ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_ws_id_path_unique UNIQUE (ws_id, path);
 G   ALTER TABLE ONLY public.files DROP CONSTRAINT files_ws_id_path_unique;
       public            kong    false    242    242            T
           2606    17030 `   graphql_ratelimiting_advanced_cost_decoration graphql_ratelimiting_advanced_cost_decoration_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.graphql_ratelimiting_advanced_cost_decoration
    ADD CONSTRAINT graphql_ratelimiting_advanced_cost_decoration_pkey PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.graphql_ratelimiting_advanced_cost_decoration DROP CONSTRAINT graphql_ratelimiting_advanced_cost_decoration_pkey;
       public            kong    false    207            (           2606    17884 &   group_rbac_roles group_rbac_roles_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_pkey PRIMARY KEY (group_id, rbac_role_id);
 P   ALTER TABLE ONLY public.group_rbac_roles DROP CONSTRAINT group_rbac_roles_pkey;
       public            kong    false    251    251            $           2606    17877    groups groups_name_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);
 @   ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_name_key;
       public            kong    false    250            &           2606    17875    groups groups_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_pkey;
       public            kong    false    250            W
           2606    17073 9   hmacauth_credentials hmacauth_credentials_id_ws_id_unique 
   CONSTRAINT     y   ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);
 c   ALTER TABLE ONLY public.hmacauth_credentials DROP CONSTRAINT hmacauth_credentials_id_ws_id_unique;
       public            kong    false    208    208            Y
           2606    17045 .   hmacauth_credentials hmacauth_credentials_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.hmacauth_credentials DROP CONSTRAINT hmacauth_credentials_pkey;
       public            kong    false    208            [
           2606    17080 ?   hmacauth_credentials hmacauth_credentials_ws_id_username_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_username_unique UNIQUE (ws_id, username);
 i   ALTER TABLE ONLY public.hmacauth_credentials DROP CONSTRAINT hmacauth_credentials_ws_id_username_unique;
       public            kong    false    208    208            _
           2606    17119 '   jwt_secrets jwt_secrets_id_ws_id_unique 
   CONSTRAINT     g   ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_id_ws_id_unique UNIQUE (id, ws_id);
 Q   ALTER TABLE ONLY public.jwt_secrets DROP CONSTRAINT jwt_secrets_id_ws_id_unique;
       public            kong    false    209    209            a
           2606    17089    jwt_secrets jwt_secrets_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.jwt_secrets DROP CONSTRAINT jwt_secrets_pkey;
       public            kong    false    209            d
           2606    17126 (   jwt_secrets jwt_secrets_ws_id_key_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_key_unique UNIQUE (ws_id, key);
 R   ALTER TABLE ONLY public.jwt_secrets DROP CONSTRAINT jwt_secrets_ws_id_key_unique;
       public            kong    false    209    209            g
           2606    17136 (   jwt_signer_jwks jwt_signer_jwks_name_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.jwt_signer_jwks
    ADD CONSTRAINT jwt_signer_jwks_name_key UNIQUE (name);
 R   ALTER TABLE ONLY public.jwt_signer_jwks DROP CONSTRAINT jwt_signer_jwks_name_key;
       public            kong    false    210            i
           2606    17134 $   jwt_signer_jwks jwt_signer_jwks_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.jwt_signer_jwks
    ADD CONSTRAINT jwt_signer_jwks_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.jwt_signer_jwks DROP CONSTRAINT jwt_signer_jwks_pkey;
       public            kong    false    210            l
           2606    17191 7   keyauth_credentials keyauth_credentials_id_ws_id_unique 
   CONSTRAINT     w   ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_id_ws_id_unique UNIQUE (id, ws_id);
 a   ALTER TABLE ONLY public.keyauth_credentials DROP CONSTRAINT keyauth_credentials_id_ws_id_unique;
       public            kong    false    211    211            n
           2606    17161 ,   keyauth_credentials keyauth_credentials_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.keyauth_credentials DROP CONSTRAINT keyauth_credentials_pkey;
       public            kong    false    211            q
           2606    17198 8   keyauth_credentials keyauth_credentials_ws_id_key_unique 
   CONSTRAINT     y   ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_key_unique UNIQUE (ws_id, key);
 b   ALTER TABLE ONLY public.keyauth_credentials DROP CONSTRAINT keyauth_credentials_ws_id_key_unique;
       public            kong    false    211    211            u
           2606    17243 ?   keyauth_enc_credentials keyauth_enc_credentials_id_ws_id_unique 
   CONSTRAINT        ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_id_ws_id_unique UNIQUE (id, ws_id);
 i   ALTER TABLE ONLY public.keyauth_enc_credentials DROP CONSTRAINT keyauth_enc_credentials_id_ws_id_unique;
       public            kong    false    212    212            w
           2606    17207 4   keyauth_enc_credentials keyauth_enc_credentials_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_pkey PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.keyauth_enc_credentials DROP CONSTRAINT keyauth_enc_credentials_pkey;
       public            kong    false    212            y
           2606    17250 @   keyauth_enc_credentials keyauth_enc_credentials_ws_id_key_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_ws_id_key_unique UNIQUE (ws_id, key);
 j   ALTER TABLE ONLY public.keyauth_enc_credentials DROP CONSTRAINT keyauth_enc_credentials_ws_id_key_unique;
       public            kong    false    212    212            `           2606    18316    keyring_keys keyring_keys_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.keyring_keys
    ADD CONSTRAINT keyring_keys_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.keyring_keys DROP CONSTRAINT keyring_keys_pkey;
       public            kong    false    265            .           2606    17928    keyring_meta keyring_meta_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.keyring_meta
    ADD CONSTRAINT keyring_meta_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.keyring_meta DROP CONSTRAINT keyring_meta_pkey;
       public            kong    false    254            {
           2606    17263 =   konnect_applications konnect_applications_client_id_ws_id_key 
   CONSTRAINT     ?   ALTER TABLE ONLY public.konnect_applications
    ADD CONSTRAINT konnect_applications_client_id_ws_id_key UNIQUE (client_id, ws_id);
 g   ALTER TABLE ONLY public.konnect_applications DROP CONSTRAINT konnect_applications_client_id_ws_id_key;
       public            kong    false    213    213            }
           2606    17261 6   konnect_applications konnect_applications_id_ws_id_key 
   CONSTRAINT     v   ALTER TABLE ONLY public.konnect_applications
    ADD CONSTRAINT konnect_applications_id_ws_id_key UNIQUE (id, ws_id);
 `   ALTER TABLE ONLY public.konnect_applications DROP CONSTRAINT konnect_applications_id_ws_id_key;
       public            kong    false    213    213            
           2606    17259 .   konnect_applications konnect_applications_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.konnect_applications
    ADD CONSTRAINT konnect_applications_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.konnect_applications DROP CONSTRAINT konnect_applications_pkey;
       public            kong    false    213                       2606    17758 "   legacy_files legacy_files_name_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.legacy_files
    ADD CONSTRAINT legacy_files_name_key UNIQUE (name);
 L   ALTER TABLE ONLY public.legacy_files DROP CONSTRAINT legacy_files_name_key;
       public            kong    false    243                       2606    17756    legacy_files legacy_files_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.legacy_files
    ADD CONSTRAINT legacy_files_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.legacy_files DROP CONSTRAINT legacy_files_pkey;
       public            kong    false    243            G           2606    18212    licenses licenses_payload_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_payload_key UNIQUE (payload);
 G   ALTER TABLE ONLY public.licenses DROP CONSTRAINT licenses_payload_key;
       public            kong    false    261            I           2606    18196    licenses licenses_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.licenses DROP CONSTRAINT licenses_pkey;
       public            kong    false    261            ?	           2606    16400    locks locks_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (key);
 :   ALTER TABLE ONLY public.locks DROP CONSTRAINT locks_pkey;
       public            kong    false    186            +           2606    17915 "   login_attempts login_attempts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_pkey PRIMARY KEY (consumer_id);
 L   ALTER TABLE ONLY public.login_attempts DROP CONSTRAINT login_attempts_pkey;
       public            kong    false    253            ?
           2606    17311 ;   mtls_auth_credentials mtls_auth_credentials_id_ws_id_unique 
   CONSTRAINT     {   ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_id_ws_id_unique UNIQUE (id, ws_id);
 e   ALTER TABLE ONLY public.mtls_auth_credentials DROP CONSTRAINT mtls_auth_credentials_id_ws_id_unique;
       public            kong    false    214    214            ?
           2606    17279 0   mtls_auth_credentials mtls_auth_credentials_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.mtls_auth_credentials DROP CONSTRAINT mtls_auth_credentials_pkey;
       public            kong    false    214            ?
           2606    17318 B   mtls_auth_credentials mtls_auth_credentials_ws_id_cache_key_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_ws_id_cache_key_unique UNIQUE (ws_id, cache_key);
 l   ALTER TABLE ONLY public.mtls_auth_credentials DROP CONSTRAINT mtls_auth_credentials_ws_id_cache_key_unique;
       public            kong    false    214    214            ?
           2606    17438 E   oauth2_authorization_codes oauth2_authorization_codes_id_ws_id_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_id_ws_id_unique UNIQUE (id, ws_id);
 o   ALTER TABLE ONLY public.oauth2_authorization_codes DROP CONSTRAINT oauth2_authorization_codes_id_ws_id_unique;
       public            kong    false    216    216            ?
           2606    17347 :   oauth2_authorization_codes oauth2_authorization_codes_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.oauth2_authorization_codes DROP CONSTRAINT oauth2_authorization_codes_pkey;
       public            kong    false    216            ?
           2606    17450 G   oauth2_authorization_codes oauth2_authorization_codes_ws_id_code_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_code_unique UNIQUE (ws_id, code);
 q   ALTER TABLE ONLY public.oauth2_authorization_codes DROP CONSTRAINT oauth2_authorization_codes_ws_id_code_unique;
       public            kong    false    216    216            ?
           2606    17411 5   oauth2_credentials oauth2_credentials_id_ws_id_unique 
   CONSTRAINT     u   ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_id_ws_id_unique UNIQUE (id, ws_id);
 _   ALTER TABLE ONLY public.oauth2_credentials DROP CONSTRAINT oauth2_credentials_id_ws_id_unique;
       public            kong    false    215    215            ?
           2606    17329 *   oauth2_credentials oauth2_credentials_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth2_credentials DROP CONSTRAINT oauth2_credentials_pkey;
       public            kong    false    215            ?
           2606    17418 <   oauth2_credentials oauth2_credentials_ws_id_client_id_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_client_id_unique UNIQUE (ws_id, client_id);
 f   ALTER TABLE ONLY public.oauth2_credentials DROP CONSTRAINT oauth2_credentials_ws_id_client_id_unique;
       public            kong    false    215    215            ?
           2606    17471 +   oauth2_tokens oauth2_tokens_id_ws_id_unique 
   CONSTRAINT     k   ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_id_ws_id_unique UNIQUE (id, ws_id);
 U   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_id_ws_id_unique;
       public            kong    false    217    217            ?
           2606    17371     oauth2_tokens oauth2_tokens_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_pkey;
       public            kong    false    217            ?
           2606    17483 5   oauth2_tokens oauth2_tokens_ws_id_access_token_unique 
   CONSTRAINT        ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_access_token_unique UNIQUE (ws_id, access_token);
 _   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_ws_id_access_token_unique;
       public            kong    false    217    217            ?
           2606    17485 6   oauth2_tokens oauth2_tokens_ws_id_refresh_token_unique 
   CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_refresh_token_unique UNIQUE (ws_id, refresh_token);
 `   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_ws_id_refresh_token_unique;
       public            kong    false    217    217            ?
           2606    17496 "   oic_issuers oic_issuers_issuer_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.oic_issuers
    ADD CONSTRAINT oic_issuers_issuer_key UNIQUE (issuer);
 L   ALTER TABLE ONLY public.oic_issuers DROP CONSTRAINT oic_issuers_issuer_key;
       public            kong    false    218            ?
           2606    17494    oic_issuers oic_issuers_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.oic_issuers
    ADD CONSTRAINT oic_issuers_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.oic_issuers DROP CONSTRAINT oic_issuers_pkey;
       public            kong    false    218            ?
           2606    17505    oic_jwks oic_jwks_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.oic_jwks
    ADD CONSTRAINT oic_jwks_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.oic_jwks DROP CONSTRAINT oic_jwks_pkey;
       public            kong    false    219            /
           2606    16842    parameters parameters_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (key);
 D   ALTER TABLE ONLY public.parameters DROP CONSTRAINT parameters_pkey;
       public            kong    false    201            
           2606    16490    plugins plugins_cache_key_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_cache_key_key UNIQUE (cache_key);
 G   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_cache_key_key;
       public            kong    false    193            
           2606    16809    plugins plugins_id_ws_id_unique 
   CONSTRAINT     _   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_id_ws_id_unique UNIQUE (id, ws_id);
 I   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_id_ws_id_unique;
       public            kong    false    193    193            
           2606    16488    plugins plugins_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_pkey;
       public            kong    false    193            ?
           2606    17516 .   ratelimiting_metrics ratelimiting_metrics_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.ratelimiting_metrics
    ADD CONSTRAINT ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);
 X   ALTER TABLE ONLY public.ratelimiting_metrics DROP CONSTRAINT ratelimiting_metrics_pkey;
       public            kong    false    220    220    220    220    220            ?
           2606    17729 ,   rbac_role_endpoints rbac_role_endpoints_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_role_endpoints
    ADD CONSTRAINT rbac_role_endpoints_pkey PRIMARY KEY (role_id, workspace, endpoint);
 V   ALTER TABLE ONLY public.rbac_role_endpoints DROP CONSTRAINT rbac_role_endpoints_pkey;
       public            kong    false    241    241    241            ?
           2606    17714 *   rbac_role_entities rbac_role_entities_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.rbac_role_entities
    ADD CONSTRAINT rbac_role_entities_pkey PRIMARY KEY (role_id, entity_id);
 T   ALTER TABLE ONLY public.rbac_role_entities DROP CONSTRAINT rbac_role_entities_pkey;
       public            kong    false    240    240            ?
           2606    18040 %   rbac_roles rbac_roles_id_ws_id_unique 
   CONSTRAINT     e   ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_id_ws_id_unique UNIQUE (id, ws_id);
 O   ALTER TABLE ONLY public.rbac_roles DROP CONSTRAINT rbac_roles_id_ws_id_unique;
       public            kong    false    238    238            ?
           2606    17686    rbac_roles rbac_roles_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.rbac_roles DROP CONSTRAINT rbac_roles_pkey;
       public            kong    false    238            ?
           2606    18042 '   rbac_roles rbac_roles_ws_id_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_ws_id_name_unique UNIQUE (ws_id, name);
 Q   ALTER TABLE ONLY public.rbac_roles DROP CONSTRAINT rbac_roles_ws_id_name_unique;
       public            kong    false    238    238            ?
           2606    17693 $   rbac_user_roles rbac_user_roles_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_pkey PRIMARY KEY (user_id, role_id);
 N   ALTER TABLE ONLY public.rbac_user_roles DROP CONSTRAINT rbac_user_roles_pkey;
       public            kong    false    239    239            ?
           2606    18020 %   rbac_users rbac_users_id_ws_id_unique 
   CONSTRAINT     e   ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_id_ws_id_unique UNIQUE (id, ws_id);
 O   ALTER TABLE ONLY public.rbac_users DROP CONSTRAINT rbac_users_id_ws_id_unique;
       public            kong    false    237    237            ?
           2606    17669    rbac_users rbac_users_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.rbac_users DROP CONSTRAINT rbac_users_pkey;
       public            kong    false    237            ?
           2606    17673 $   rbac_users rbac_users_user_token_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_user_token_key UNIQUE (user_token);
 N   ALTER TABLE ONLY public.rbac_users DROP CONSTRAINT rbac_users_user_token_key;
       public            kong    false    237            ?
           2606    18022 '   rbac_users rbac_users_ws_id_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_ws_id_name_unique UNIQUE (ws_id, name);
 Q   ALTER TABLE ONLY public.rbac_users DROP CONSTRAINT rbac_users_ws_id_name_unique;
       public            kong    false    237    237            ?
           2606    17528 @   response_ratelimiting_metrics response_ratelimiting_metrics_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.response_ratelimiting_metrics
    ADD CONSTRAINT response_ratelimiting_metrics_pkey PRIMARY KEY (identifier, period, period_date, service_id, route_id);
 j   ALTER TABLE ONLY public.response_ratelimiting_metrics DROP CONSTRAINT response_ratelimiting_metrics_pkey;
       public            kong    false    221    221    221    221    221            ?
           2606    17568    rl_counters rl_counters_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.rl_counters
    ADD CONSTRAINT rl_counters_pkey PRIMARY KEY (key, namespace, window_start, window_size);
 F   ALTER TABLE ONLY public.rl_counters DROP CONSTRAINT rl_counters_pkey;
       public            kong    false    225    225    225    225            ?	           2606    16781    routes routes_id_ws_id_unique 
   CONSTRAINT     ]   ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_id_ws_id_unique UNIQUE (id, ws_id);
 G   ALTER TABLE ONLY public.routes DROP CONSTRAINT routes_id_ws_id_unique;
       public            kong    false    189    189            ?	           2606    16431    routes routes_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.routes DROP CONSTRAINT routes_pkey;
       public            kong    false    189            ?	           2606    16788    routes routes_ws_id_name_unique 
   CONSTRAINT     a   ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_name_unique UNIQUE (ws_id, name);
 I   ALTER TABLE ONLY public.routes DROP CONSTRAINT routes_ws_id_name_unique;
       public            kong    false    189    189            ?	           2606    16392    schema_meta schema_meta_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.schema_meta
    ADD CONSTRAINT schema_meta_pkey PRIMARY KEY (key, subsystem);
 F   ALTER TABLE ONLY public.schema_meta DROP CONSTRAINT schema_meta_pkey;
       public            kong    false    185    185            ?	           2606    16756 !   services services_id_ws_id_unique 
   CONSTRAINT     a   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_id_ws_id_unique UNIQUE (id, ws_id);
 K   ALTER TABLE ONLY public.services DROP CONSTRAINT services_id_ws_id_unique;
       public            kong    false    188    188            ?	           2606    16421    services services_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.services DROP CONSTRAINT services_pkey;
       public            kong    false    188            ?	           2606    16763 #   services services_ws_id_name_unique 
   CONSTRAINT     e   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_name_unique UNIQUE (ws_id, name);
 M   ALTER TABLE ONLY public.services DROP CONSTRAINT services_ws_id_name_unique;
       public            kong    false    188    188            ?
           2606    17536    sessions sessions_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
       public            kong    false    222            ?
           2606    17538     sessions sessions_session_id_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_session_id_key UNIQUE (session_id);
 J   ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_session_id_key;
       public            kong    false    222            1
           2606    16898     sm_vaults sm_vaults_id_ws_id_key 
   CONSTRAINT     `   ALTER TABLE ONLY public.sm_vaults
    ADD CONSTRAINT sm_vaults_id_ws_id_key UNIQUE (id, ws_id);
 J   ALTER TABLE ONLY public.sm_vaults DROP CONSTRAINT sm_vaults_id_ws_id_key;
       public            kong    false    202    202            3
           2606    16894    sm_vaults sm_vaults_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.sm_vaults
    ADD CONSTRAINT sm_vaults_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sm_vaults DROP CONSTRAINT sm_vaults_pkey;
       public            kong    false    202            5
           2606    16896    sm_vaults sm_vaults_prefix_key 
   CONSTRAINT     [   ALTER TABLE ONLY public.sm_vaults
    ADD CONSTRAINT sm_vaults_prefix_key UNIQUE (prefix);
 H   ALTER TABLE ONLY public.sm_vaults DROP CONSTRAINT sm_vaults_prefix_key;
       public            kong    false    202            7
           2606    16900 $   sm_vaults sm_vaults_prefix_ws_id_key 
   CONSTRAINT     h   ALTER TABLE ONLY public.sm_vaults
    ADD CONSTRAINT sm_vaults_prefix_ws_id_key UNIQUE (prefix, ws_id);
 N   ALTER TABLE ONLY public.sm_vaults DROP CONSTRAINT sm_vaults_prefix_ws_id_key;
       public            kong    false    202    202            ?	           2606    16733    snis snis_id_ws_id_unique 
   CONSTRAINT     Y   ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_id_ws_id_unique UNIQUE (id, ws_id);
 C   ALTER TABLE ONLY public.snis DROP CONSTRAINT snis_id_ws_id_unique;
       public            kong    false    191    191            ?	           2606    16459    snis snis_name_key 
   CONSTRAINT     M   ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_name_key UNIQUE (name);
 <   ALTER TABLE ONLY public.snis DROP CONSTRAINT snis_name_key;
       public            kong    false    191            ?	           2606    16457    snis snis_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.snis DROP CONSTRAINT snis_pkey;
       public            kong    false    191            !
           2606    16564    tags tags_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (entity_id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public            kong    false    197            
           2606    16909    targets targets_cache_key_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_cache_key_key UNIQUE (cache_key);
 G   ALTER TABLE ONLY public.targets DROP CONSTRAINT targets_cache_key_key;
       public            kong    false    195            
           2606    16671    targets targets_id_ws_id_unique 
   CONSTRAINT     _   ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_id_ws_id_unique UNIQUE (id, ws_id);
 I   ALTER TABLE ONLY public.targets DROP CONSTRAINT targets_id_ws_id_unique;
       public            kong    false    195    195            
           2606    16530    targets targets_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.targets DROP CONSTRAINT targets_pkey;
       public            kong    false    195            
           2606    16554    ttls ttls_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.ttls
    ADD CONSTRAINT ttls_pkey PRIMARY KEY (primary_key_value, table_name);
 8   ALTER TABLE ONLY public.ttls DROP CONSTRAINT ttls_pkey;
       public            kong    false    196    196            
           2606    16651 #   upstreams upstreams_id_ws_id_unique 
   CONSTRAINT     c   ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_id_ws_id_unique UNIQUE (id, ws_id);
 M   ALTER TABLE ONLY public.upstreams DROP CONSTRAINT upstreams_id_ws_id_unique;
       public            kong    false    194    194            
           2606    16519    upstreams upstreams_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.upstreams DROP CONSTRAINT upstreams_pkey;
       public            kong    false    194            
           2606    16653 %   upstreams upstreams_ws_id_name_unique 
   CONSTRAINT     g   ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_name_unique UNIQUE (ws_id, name);
 O   ALTER TABLE ONLY public.upstreams DROP CONSTRAINT upstreams_ws_id_name_unique;
       public            kong    false    194    194            ?
           2606    17560 ,   vault_auth_vaults vault_auth_vaults_name_key 
   CONSTRAINT     g   ALTER TABLE ONLY public.vault_auth_vaults
    ADD CONSTRAINT vault_auth_vaults_name_key UNIQUE (name);
 V   ALTER TABLE ONLY public.vault_auth_vaults DROP CONSTRAINT vault_auth_vaults_name_key;
       public            kong    false    224            ?
           2606    17558 (   vault_auth_vaults vault_auth_vaults_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vault_auth_vaults
    ADD CONSTRAINT vault_auth_vaults_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.vault_auth_vaults DROP CONSTRAINT vault_auth_vaults_pkey;
       public            kong    false    224            ?
           2606    17550    vaults vaults_name_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.vaults
    ADD CONSTRAINT vaults_name_key UNIQUE (name);
 @   ALTER TABLE ONLY public.vaults DROP CONSTRAINT vaults_name_key;
       public            kong    false    223            ?
           2606    17548    vaults vaults_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.vaults
    ADD CONSTRAINT vaults_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.vaults DROP CONSTRAINT vaults_pkey;
       public            kong    false    223            ?
           2606    17613 B   vitals_code_classes_by_cluster vitals_code_classes_by_cluster_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_code_classes_by_cluster
    ADD CONSTRAINT vitals_code_classes_by_cluster_pkey PRIMARY KEY (code_class, duration, at);
 l   ALTER TABLE ONLY public.vitals_code_classes_by_cluster DROP CONSTRAINT vitals_code_classes_by_cluster_pkey;
       public            kong    false    230    230    230            ?
           2606    17629 F   vitals_code_classes_by_workspace vitals_code_classes_by_workspace_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_code_classes_by_workspace
    ADD CONSTRAINT vitals_code_classes_by_workspace_pkey PRIMARY KEY (workspace_id, code_class, duration, at);
 p   ALTER TABLE ONLY public.vitals_code_classes_by_workspace DROP CONSTRAINT vitals_code_classes_by_workspace_pkey;
       public            kong    false    233    233    233    233            ?
           2606    17624 B   vitals_codes_by_consumer_route vitals_codes_by_consumer_route_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_codes_by_consumer_route
    ADD CONSTRAINT vitals_codes_by_consumer_route_pkey PRIMARY KEY (consumer_id, route_id, code, duration, at);
 l   ALTER TABLE ONLY public.vitals_codes_by_consumer_route DROP CONSTRAINT vitals_codes_by_consumer_route_pkey;
       public            kong    false    232    232    232    232    232            ?
           2606    17618 0   vitals_codes_by_route vitals_codes_by_route_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_codes_by_route
    ADD CONSTRAINT vitals_codes_by_route_pkey PRIMARY KEY (route_id, code, duration, at);
 Z   ALTER TABLE ONLY public.vitals_codes_by_route DROP CONSTRAINT vitals_codes_by_route_pkey;
       public            kong    false    231    231    231    231            ?
           2606    17637    vitals_locks vitals_locks_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.vitals_locks
    ADD CONSTRAINT vitals_locks_pkey PRIMARY KEY (key);
 H   ALTER TABLE ONLY public.vitals_locks DROP CONSTRAINT vitals_locks_pkey;
       public            kong    false    234            ?
           2606    17608 &   vitals_node_meta vitals_node_meta_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.vitals_node_meta
    ADD CONSTRAINT vitals_node_meta_pkey PRIMARY KEY (node_id);
 P   ALTER TABLE ONLY public.vitals_node_meta DROP CONSTRAINT vitals_node_meta_pkey;
       public            kong    false    229            E           2606    18186 (   vitals_stats_days vitals_stats_days_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.vitals_stats_days
    ADD CONSTRAINT vitals_stats_days_pkey PRIMARY KEY (node_id, at);
 R   ALTER TABLE ONLY public.vitals_stats_days DROP CONSTRAINT vitals_stats_days_pkey;
       public            kong    false    260    260            ?
           2606    17576 *   vitals_stats_hours vitals_stats_hours_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.vitals_stats_hours
    ADD CONSTRAINT vitals_stats_hours_pkey PRIMARY KEY (at);
 T   ALTER TABLE ONLY public.vitals_stats_hours DROP CONSTRAINT vitals_stats_hours_pkey;
       public            kong    false    226            ?
           2606    17600 .   vitals_stats_minutes vitals_stats_minutes_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.vitals_stats_minutes
    ADD CONSTRAINT vitals_stats_minutes_pkey PRIMARY KEY (node_id, at);
 X   ALTER TABLE ONLY public.vitals_stats_minutes DROP CONSTRAINT vitals_stats_minutes_pkey;
       public            kong    false    228    228            b           2606    18913 D   vitals_stats_seconds_1669438800 vitals_stats_seconds_1669438800_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_stats_seconds_1669438800
    ADD CONSTRAINT vitals_stats_seconds_1669438800_pkey PRIMARY KEY (node_id, at);
 n   ALTER TABLE ONLY public.vitals_stats_seconds_1669438800 DROP CONSTRAINT vitals_stats_seconds_1669438800_pkey;
       public            kong    false    266    266            d           2606    18925 D   vitals_stats_seconds_1669442400 vitals_stats_seconds_1669442400_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_stats_seconds_1669442400
    ADD CONSTRAINT vitals_stats_seconds_1669442400_pkey PRIMARY KEY (node_id, at);
 n   ALTER TABLE ONLY public.vitals_stats_seconds_1669442400 DROP CONSTRAINT vitals_stats_seconds_1669442400_pkey;
       public            kong    false    267    267            f           2606    18938 D   vitals_stats_seconds_1669446000 vitals_stats_seconds_1669446000_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.vitals_stats_seconds_1669446000
    ADD CONSTRAINT vitals_stats_seconds_1669446000_pkey PRIMARY KEY (node_id, at);
 n   ALTER TABLE ONLY public.vitals_stats_seconds_1669446000 DROP CONSTRAINT vitals_stats_seconds_1669446000_pkey;
       public            kong    false    268    268            ?
           2606    17588 .   vitals_stats_seconds vitals_stats_seconds_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.vitals_stats_seconds
    ADD CONSTRAINT vitals_stats_seconds_pkey PRIMARY KEY (node_id, at);
 X   ALTER TABLE ONLY public.vitals_stats_seconds DROP CONSTRAINT vitals_stats_seconds_pkey;
       public            kong    false    227    227            ?
           2606    17645 *   workspace_entities workspace_entities_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.workspace_entities
    ADD CONSTRAINT workspace_entities_pkey PRIMARY KEY (workspace_id, entity_id, unique_field_name);
 T   ALTER TABLE ONLY public.workspace_entities DROP CONSTRAINT workspace_entities_pkey;
       public            kong    false    235    235    235            ?
           2606    17655 8   workspace_entity_counters workspace_entity_counters_pkey 
   CONSTRAINT     ?   ALTER TABLE ONLY public.workspace_entity_counters
    ADD CONSTRAINT workspace_entity_counters_pkey PRIMARY KEY (workspace_id, entity_type);
 b   ALTER TABLE ONLY public.workspace_entity_counters DROP CONSTRAINT workspace_entity_counters_pkey;
       public            kong    false    236    236            (
           2606    16633    workspaces workspaces_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.workspaces DROP CONSTRAINT workspaces_name_key;
       public            kong    false    199            *
           2606    16631    workspaces workspaces_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.workspaces DROP CONSTRAINT workspaces_pkey;
       public            kong    false    199            ;
           1259    16926    acls_consumer_id_idx    INDEX     L   CREATE INDEX acls_consumer_id_idx ON public.acls USING btree (consumer_id);
 (   DROP INDEX public.acls_consumer_id_idx;
       public            kong    false    203            <
           1259    16927    acls_group_idx    INDEX     B   CREATE INDEX acls_group_idx ON public.acls USING btree ("group");
 "   DROP INDEX public.acls_group_idx;
       public            kong    false    203            A
           1259    16928    acls_tags_idex_tags_idx    INDEX     F   CREATE INDEX acls_tags_idex_tags_idx ON public.acls USING gin (tags);
 +   DROP INDEX public.acls_tags_idex_tags_idx;
       public            kong    false    203            F
           1259    16964    acme_storage_ttl_idx    INDEX     L   CREATE INDEX acme_storage_ttl_idx ON public.acme_storage USING btree (ttl);
 (   DROP INDEX public.acme_storage_ttl_idx;
       public            kong    false    204            1           1259    17947    applications_developer_id_idx    INDEX     ^   CREATE INDEX applications_developer_id_idx ON public.applications USING btree (developer_id);
 1   DROP INDEX public.applications_developer_id_idx;
       public            kong    false    255                       1259    18174    audit_objects_ttl_idx    INDEX     N   CREATE INDEX audit_objects_ttl_idx ON public.audit_objects USING btree (ttl);
 )   DROP INDEX public.audit_objects_ttl_idx;
       public            kong    false    248            !           1259    18173    audit_requests_ttl_idx    INDEX     P   CREATE INDEX audit_requests_ttl_idx ON public.audit_requests USING btree (ttl);
 *   DROP INDEX public.audit_requests_ttl_idx;
       public            kong    false    249            G
           1259    16981    basicauth_consumer_id_idx    INDEX     b   CREATE INDEX basicauth_consumer_id_idx ON public.basicauth_credentials USING btree (consumer_id);
 -   DROP INDEX public.basicauth_consumer_id_idx;
       public            kong    false    205            N
           1259    16982    basicauth_tags_idex_tags_idx    INDEX     \   CREATE INDEX basicauth_tags_idex_tags_idx ON public.basicauth_credentials USING gin (tags);
 0   DROP INDEX public.basicauth_tags_idex_tags_idx;
       public            kong    false    205            ?	           1259    16572    certificates_tags_idx    INDEX     L   CREATE INDEX certificates_tags_idx ON public.certificates USING gin (tags);
 )   DROP INDEX public.certificates_tags_idx;
       public            kong    false    190            ?	           1259    16410    cluster_events_at_idx    INDEX     N   CREATE INDEX cluster_events_at_idx ON public.cluster_events USING btree (at);
 )   DROP INDEX public.cluster_events_at_idx;
       public            kong    false    187            ?	           1259    16411    cluster_events_channel_idx    INDEX     X   CREATE INDEX cluster_events_channel_idx ON public.cluster_events USING btree (channel);
 .   DROP INDEX public.cluster_events_channel_idx;
       public            kong    false    187            ?	           1259    16584    cluster_events_expire_at_idx    INDEX     \   CREATE INDEX cluster_events_expire_at_idx ON public.cluster_events USING btree (expire_at);
 0   DROP INDEX public.cluster_events_expire_at_idx;
       public            kong    false    187            -
           1259    16834    clustering_data_planes_ttl_idx    INDEX     `   CREATE INDEX clustering_data_planes_ttl_idx ON public.clustering_data_planes USING btree (ttl);
 2   DROP INDEX public.clustering_data_planes_ttl_idx;
       public            kong    false    200            [           1259    18266 (   consumer_group_consumers_consumer_id_idx    INDEX     t   CREATE INDEX consumer_group_consumers_consumer_id_idx ON public.consumer_group_consumers USING btree (consumer_id);
 <   DROP INDEX public.consumer_group_consumers_consumer_id_idx;
       public            kong    false    264            \           1259    18265 %   consumer_group_consumers_group_id_idx    INDEX     w   CREATE INDEX consumer_group_consumers_group_id_idx ON public.consumer_group_consumers USING btree (consumer_group_id);
 9   DROP INDEX public.consumer_group_consumers_group_id_idx;
       public            kong    false    264            S           1259    18242 #   consumer_group_plugins_group_id_idx    INDEX     s   CREATE INDEX consumer_group_plugins_group_id_idx ON public.consumer_group_plugins USING btree (consumer_group_id);
 7   DROP INDEX public.consumer_group_plugins_group_id_idx;
       public            kong    false    263            X           1259    18243 &   consumer_group_plugins_plugin_name_idx    INDEX     i   CREATE INDEX consumer_group_plugins_plugin_name_idx ON public.consumer_group_plugins USING btree (name);
 :   DROP INDEX public.consumer_group_plugins_plugin_name_idx;
       public            kong    false    263            L           1259    18225    consumer_groups_name_idx    INDEX     T   CREATE INDEX consumer_groups_name_idx ON public.consumer_groups USING btree (name);
 ,   DROP INDEX public.consumer_groups_name_idx;
       public            kong    false    262            
           1259    17805 &   consumer_reset_secrets_consumer_id_idx    INDEX     p   CREATE INDEX consumer_reset_secrets_consumer_id_idx ON public.consumer_reset_secrets USING btree (consumer_id);
 :   DROP INDEX public.consumer_reset_secrets_consumer_id_idx;
       public            kong    false    245            ?	           1259    16576    consumers_tags_idx    INDEX     F   CREATE INDEX consumers_tags_idx ON public.consumers USING gin (tags);
 &   DROP INDEX public.consumers_tags_idx;
       public            kong    false    192            ?	           1259    17773    consumers_type_idx    INDEX     H   CREATE INDEX consumers_type_idx ON public.consumers USING btree (type);
 &   DROP INDEX public.consumers_type_idx;
       public            kong    false    192            ?	           1259    16479    consumers_username_idx    INDEX     W   CREATE INDEX consumers_username_idx ON public.consumers USING btree (lower(username));
 *   DROP INDEX public.consumers_username_idx;
       public            kong    false    192    192                       1259    17789    credentials_consumer_id_plugin    INDEX     e   CREATE INDEX credentials_consumer_id_plugin ON public.credentials USING btree (consumer_id, plugin);
 2   DROP INDEX public.credentials_consumer_id_plugin;
       public            kong    false    244    244                       1259    17788    credentials_consumer_type    INDEX     X   CREATE INDEX credentials_consumer_type ON public.credentials USING btree (consumer_id);
 -   DROP INDEX public.credentials_consumer_type;
       public            kong    false    244            O
           1259    17022    degraphql_routes_fkey_service    INDEX     `   CREATE INDEX degraphql_routes_fkey_service ON public.degraphql_routes USING btree (service_id);
 1   DROP INDEX public.degraphql_routes_fkey_service;
       public            kong    false    206                       1259    17847    developers_rbac_user_id_idx    INDEX     Z   CREATE INDEX developers_rbac_user_id_idx ON public.developers USING btree (rbac_user_id);
 /   DROP INDEX public.developers_rbac_user_id_idx;
       public            kong    false    247            ?
           1259    17747    files_path_idx    INDEX     @   CREATE INDEX files_path_idx ON public.files USING btree (path);
 "   DROP INDEX public.files_path_idx;
       public            kong    false    242            R
           1259    17036 :   graphql_ratelimiting_advanced_cost_decoration_fkey_service    INDEX     ?   CREATE INDEX graphql_ratelimiting_advanced_cost_decoration_fkey_service ON public.graphql_ratelimiting_advanced_cost_decoration USING btree (service_id);
 N   DROP INDEX public.graphql_ratelimiting_advanced_cost_decoration_fkey_service;
       public            kong    false    207            "           1259    17878    groups_name_idx    INDEX     B   CREATE INDEX groups_name_idx ON public.groups USING btree (name);
 #   DROP INDEX public.groups_name_idx;
       public            kong    false    250            U
           1259    17053 $   hmacauth_credentials_consumer_id_idx    INDEX     l   CREATE INDEX hmacauth_credentials_consumer_id_idx ON public.hmacauth_credentials USING btree (consumer_id);
 8   DROP INDEX public.hmacauth_credentials_consumer_id_idx;
       public            kong    false    208            \
           1259    17054    hmacauth_tags_idex_tags_idx    INDEX     Z   CREATE INDEX hmacauth_tags_idex_tags_idx ON public.hmacauth_credentials USING gin (tags);
 /   DROP INDEX public.hmacauth_tags_idex_tags_idx;
       public            kong    false    208            ]
           1259    17097    jwt_secrets_consumer_id_idx    INDEX     Z   CREATE INDEX jwt_secrets_consumer_id_idx ON public.jwt_secrets USING btree (consumer_id);
 /   DROP INDEX public.jwt_secrets_consumer_id_idx;
       public            kong    false    209            b
           1259    17098    jwt_secrets_secret_idx    INDEX     P   CREATE INDEX jwt_secrets_secret_idx ON public.jwt_secrets USING btree (secret);
 *   DROP INDEX public.jwt_secrets_secret_idx;
       public            kong    false    209            e
           1259    17099    jwtsecrets_tags_idex_tags_idx    INDEX     S   CREATE INDEX jwtsecrets_tags_idex_tags_idx ON public.jwt_secrets USING gin (tags);
 1   DROP INDEX public.jwtsecrets_tags_idex_tags_idx;
       public            kong    false    209            j
           1259    17169 #   keyauth_credentials_consumer_id_idx    INDEX     j   CREATE INDEX keyauth_credentials_consumer_id_idx ON public.keyauth_credentials USING btree (consumer_id);
 7   DROP INDEX public.keyauth_credentials_consumer_id_idx;
       public            kong    false    211            o
           1259    17172    keyauth_credentials_ttl_idx    INDEX     Z   CREATE INDEX keyauth_credentials_ttl_idx ON public.keyauth_credentials USING btree (ttl);
 /   DROP INDEX public.keyauth_credentials_ttl_idx;
       public            kong    false    211            s
           1259    17215    keyauth_enc_credentials_consum    INDEX     i   CREATE INDEX keyauth_enc_credentials_consum ON public.keyauth_enc_credentials USING btree (consumer_id);
 2   DROP INDEX public.keyauth_enc_credentials_consum;
       public            kong    false    212            r
           1259    17170    keyauth_tags_idex_tags_idx    INDEX     X   CREATE INDEX keyauth_tags_idex_tags_idx ON public.keyauth_credentials USING gin (tags);
 .   DROP INDEX public.keyauth_tags_idex_tags_idx;
       public            kong    false    211            ?
           1259    17269    konnect_applications_tags_idx    INDEX     \   CREATE INDEX konnect_applications_tags_idx ON public.konnect_applications USING gin (tags);
 1   DROP INDEX public.konnect_applications_tags_idx;
       public            kong    false    213                       1259    17759    legacy_files_name_idx    INDEX     N   CREATE INDEX legacy_files_name_idx ON public.legacy_files USING btree (name);
 )   DROP INDEX public.legacy_files_name_idx;
       public            kong    false    243            )           1259    18213    license_data_key_idx    INDEX     d   CREATE UNIQUE INDEX license_data_key_idx ON public.license_data USING btree (node_id, year, month);
 (   DROP INDEX public.license_data_key_idx;
       public            kong    false    252    252    252            ?	           1259    16401    locks_ttl_idx    INDEX     >   CREATE INDEX locks_ttl_idx ON public.locks USING btree (ttl);
 !   DROP INDEX public.locks_ttl_idx;
       public            kong    false    186            ,           1259    18172    login_attempts_ttl_idx    INDEX     P   CREATE INDEX login_attempts_ttl_idx ON public.login_attempts USING btree (ttl);
 *   DROP INDEX public.login_attempts_ttl_idx;
       public            kong    false    253            ?
           1259    17292    mtls_auth_common_name_idx    INDEX     c   CREATE INDEX mtls_auth_common_name_idx ON public.mtls_auth_credentials USING btree (subject_name);
 -   DROP INDEX public.mtls_auth_common_name_idx;
       public            kong    false    214            ?
           1259    17293    mtls_auth_consumer_id_idx    INDEX     b   CREATE INDEX mtls_auth_consumer_id_idx ON public.mtls_auth_credentials USING btree (consumer_id);
 -   DROP INDEX public.mtls_auth_consumer_id_idx;
       public            kong    false    214            ?
           1259    17319    mtls_auth_credentials_tags_idx    INDEX     ^   CREATE INDEX mtls_auth_credentials_tags_idx ON public.mtls_auth_credentials USING gin (tags);
 2   DROP INDEX public.mtls_auth_credentials_tags_idx;
       public            kong    false    214            ?
           1259    17360 3   oauth2_authorization_codes_authenticated_userid_idx    INDEX     ?   CREATE INDEX oauth2_authorization_codes_authenticated_userid_idx ON public.oauth2_authorization_codes USING btree (authenticated_userid);
 G   DROP INDEX public.oauth2_authorization_codes_authenticated_userid_idx;
       public            kong    false    216            ?
           1259    17391 "   oauth2_authorization_codes_ttl_idx    INDEX     h   CREATE INDEX oauth2_authorization_codes_ttl_idx ON public.oauth2_authorization_codes USING btree (ttl);
 6   DROP INDEX public.oauth2_authorization_codes_ttl_idx;
       public            kong    false    216            ?
           1259    17361 &   oauth2_authorization_credential_id_idx    INDEX     v   CREATE INDEX oauth2_authorization_credential_id_idx ON public.oauth2_authorization_codes USING btree (credential_id);
 :   DROP INDEX public.oauth2_authorization_credential_id_idx;
       public            kong    false    216            ?
           1259    17362 #   oauth2_authorization_service_id_idx    INDEX     p   CREATE INDEX oauth2_authorization_service_id_idx ON public.oauth2_authorization_codes USING btree (service_id);
 7   DROP INDEX public.oauth2_authorization_service_id_idx;
       public            kong    false    216            ?
           1259    17337 "   oauth2_credentials_consumer_id_idx    INDEX     h   CREATE INDEX oauth2_credentials_consumer_id_idx ON public.oauth2_credentials USING btree (consumer_id);
 6   DROP INDEX public.oauth2_credentials_consumer_id_idx;
       public            kong    false    215            ?
           1259    17338    oauth2_credentials_secret_idx    INDEX     e   CREATE INDEX oauth2_credentials_secret_idx ON public.oauth2_credentials USING btree (client_secret);
 1   DROP INDEX public.oauth2_credentials_secret_idx;
       public            kong    false    215            ?
           1259    17389 %   oauth2_credentials_tags_idex_tags_idx    INDEX     b   CREATE INDEX oauth2_credentials_tags_idex_tags_idx ON public.oauth2_credentials USING gin (tags);
 9   DROP INDEX public.oauth2_credentials_tags_idex_tags_idx;
       public            kong    false    215            ?
           1259    17386 &   oauth2_tokens_authenticated_userid_idx    INDEX     p   CREATE INDEX oauth2_tokens_authenticated_userid_idx ON public.oauth2_tokens USING btree (authenticated_userid);
 :   DROP INDEX public.oauth2_tokens_authenticated_userid_idx;
       public            kong    false    217            ?
           1259    17387    oauth2_tokens_credential_id_idx    INDEX     b   CREATE INDEX oauth2_tokens_credential_id_idx ON public.oauth2_tokens USING btree (credential_id);
 3   DROP INDEX public.oauth2_tokens_credential_id_idx;
       public            kong    false    217            ?
           1259    17388    oauth2_tokens_service_id_idx    INDEX     \   CREATE INDEX oauth2_tokens_service_id_idx ON public.oauth2_tokens USING btree (service_id);
 0   DROP INDEX public.oauth2_tokens_service_id_idx;
       public            kong    false    217            ?
           1259    17392    oauth2_tokens_ttl_idx    INDEX     N   CREATE INDEX oauth2_tokens_ttl_idx ON public.oauth2_tokens USING btree (ttl);
 )   DROP INDEX public.oauth2_tokens_ttl_idx;
       public            kong    false    217            
           1259    16507    plugins_consumer_id_idx    INDEX     R   CREATE INDEX plugins_consumer_id_idx ON public.plugins USING btree (consumer_id);
 +   DROP INDEX public.plugins_consumer_id_idx;
       public            kong    false    193            
           1259    16506    plugins_name_idx    INDEX     D   CREATE INDEX plugins_name_idx ON public.plugins USING btree (name);
 $   DROP INDEX public.plugins_name_idx;
       public            kong    false    193            
           1259    16509    plugins_route_id_idx    INDEX     L   CREATE INDEX plugins_route_id_idx ON public.plugins USING btree (route_id);
 (   DROP INDEX public.plugins_route_id_idx;
       public            kong    false    193            	
           1259    16508    plugins_service_id_idx    INDEX     P   CREATE INDEX plugins_service_id_idx ON public.plugins USING btree (service_id);
 *   DROP INDEX public.plugins_service_id_idx;
       public            kong    false    193            

           1259    16578    plugins_tags_idx    INDEX     B   CREATE INDEX plugins_tags_idx ON public.plugins USING gin (tags);
 $   DROP INDEX public.plugins_tags_idx;
       public            kong    false    193            ?
           1259    17517    ratelimiting_metrics_idx    INDEX     ~   CREATE INDEX ratelimiting_metrics_idx ON public.ratelimiting_metrics USING btree (service_id, route_id, period_date, period);
 ,   DROP INDEX public.ratelimiting_metrics_idx;
       public            kong    false    220    220    220    220            ?
           1259    17518    ratelimiting_metrics_ttl_idx    INDEX     \   CREATE INDEX ratelimiting_metrics_ttl_idx ON public.ratelimiting_metrics USING btree (ttl);
 0   DROP INDEX public.ratelimiting_metrics_ttl_idx;
       public            kong    false    220            ?
           1259    17705    rbac_role_default_idx    INDEX     R   CREATE INDEX rbac_role_default_idx ON public.rbac_roles USING btree (is_default);
 )   DROP INDEX public.rbac_role_default_idx;
       public            kong    false    238            ?
           1259    17735    rbac_role_endpoints_role_idx    INDEX     _   CREATE INDEX rbac_role_endpoints_role_idx ON public.rbac_role_endpoints USING btree (role_id);
 0   DROP INDEX public.rbac_role_endpoints_role_idx;
       public            kong    false    241            ?
           1259    17720    rbac_role_entities_role_idx    INDEX     ]   CREATE INDEX rbac_role_entities_role_idx ON public.rbac_role_entities USING btree (role_id);
 /   DROP INDEX public.rbac_role_entities_role_idx;
       public            kong    false    240            ?
           1259    17704    rbac_roles_name_idx    INDEX     J   CREATE INDEX rbac_roles_name_idx ON public.rbac_roles USING btree (name);
 '   DROP INDEX public.rbac_roles_name_idx;
       public            kong    false    238            ?
           1259    17676    rbac_token_ident_idx    INDEX     W   CREATE INDEX rbac_token_ident_idx ON public.rbac_users USING btree (user_token_ident);
 (   DROP INDEX public.rbac_token_ident_idx;
       public            kong    false    237            ?
           1259    17674    rbac_users_name_idx    INDEX     J   CREATE INDEX rbac_users_name_idx ON public.rbac_users USING btree (name);
 '   DROP INDEX public.rbac_users_name_idx;
       public            kong    false    237            ?
           1259    17675    rbac_users_token_idx    INDEX     Q   CREATE INDEX rbac_users_token_idx ON public.rbac_users USING btree (user_token);
 (   DROP INDEX public.rbac_users_token_idx;
       public            kong    false    237            ?	           1259    16439    routes_service_id_idx    INDEX     N   CREATE INDEX routes_service_id_idx ON public.routes USING btree (service_id);
 )   DROP INDEX public.routes_service_id_idx;
       public            kong    false    189            ?	           1259    16570    routes_tags_idx    INDEX     @   CREATE INDEX routes_tags_idx ON public.routes USING gin (tags);
 #   DROP INDEX public.routes_tags_idx;
       public            kong    false    189            ?	           1259    16602     services_fkey_client_certificate    INDEX     f   CREATE INDEX services_fkey_client_certificate ON public.services USING btree (client_certificate_id);
 4   DROP INDEX public.services_fkey_client_certificate;
       public            kong    false    188            ?	           1259    16568    services_tags_idx    INDEX     D   CREATE INDEX services_tags_idx ON public.services USING gin (tags);
 %   DROP INDEX public.services_tags_idx;
       public            kong    false    188            ?
           1259    17539    session_sessions_expires_idx    INDEX     T   CREATE INDEX session_sessions_expires_idx ON public.sessions USING btree (expires);
 0   DROP INDEX public.session_sessions_expires_idx;
       public            kong    false    222            ?
           1259    17540    sessions_ttl_idx    INDEX     D   CREATE INDEX sessions_ttl_idx ON public.sessions USING btree (ttl);
 $   DROP INDEX public.sessions_ttl_idx;
       public            kong    false    222            8
           1259    16901    sm_vaults_tags_idx    INDEX     F   CREATE INDEX sm_vaults_tags_idx ON public.sm_vaults USING gin (tags);
 &   DROP INDEX public.sm_vaults_tags_idx;
       public            kong    false    202            ?	           1259    16465    snis_certificate_id_idx    INDEX     R   CREATE INDEX snis_certificate_id_idx ON public.snis USING btree (certificate_id);
 +   DROP INDEX public.snis_certificate_id_idx;
       public            kong    false    191            ?	           1259    16574    snis_tags_idx    INDEX     <   CREATE INDEX snis_tags_idx ON public.snis USING gin (tags);
 !   DROP INDEX public.snis_tags_idx;
       public            kong    false    191            ?
           1259    17569    sync_key_idx    INDEX     W   CREATE INDEX sync_key_idx ON public.rl_counters USING btree (namespace, window_start);
     DROP INDEX public.sync_key_idx;
       public            kong    false    225    225            
           1259    16565    tags_entity_name_idx    INDEX     L   CREATE INDEX tags_entity_name_idx ON public.tags USING btree (entity_name);
 (   DROP INDEX public.tags_entity_name_idx;
       public            kong    false    197            "
           1259    16566    tags_tags_idx    INDEX     <   CREATE INDEX tags_tags_idx ON public.tags USING gin (tags);
 !   DROP INDEX public.tags_tags_idx;
       public            kong    false    197            
           1259    16582    targets_tags_idx    INDEX     B   CREATE INDEX targets_tags_idx ON public.targets USING gin (tags);
 $   DROP INDEX public.targets_tags_idx;
       public            kong    false    195            
           1259    16536    targets_target_idx    INDEX     H   CREATE INDEX targets_target_idx ON public.targets USING btree (target);
 &   DROP INDEX public.targets_target_idx;
       public            kong    false    195            
           1259    16537    targets_upstream_id_idx    INDEX     R   CREATE INDEX targets_upstream_id_idx ON public.targets USING btree (upstream_id);
 +   DROP INDEX public.targets_upstream_id_idx;
       public            kong    false    195            
           1259    16555    ttls_primary_uuid_value_idx    INDEX     Z   CREATE INDEX ttls_primary_uuid_value_idx ON public.ttls USING btree (primary_uuid_value);
 /   DROP INDEX public.ttls_primary_uuid_value_idx;
       public            kong    false    196            
           1259    16622 !   upstreams_fkey_client_certificate    INDEX     h   CREATE INDEX upstreams_fkey_client_certificate ON public.upstreams USING btree (client_certificate_id);
 5   DROP INDEX public.upstreams_fkey_client_certificate;
       public            kong    false    194            
           1259    16580    upstreams_tags_idx    INDEX     F   CREATE INDEX upstreams_tags_idx ON public.upstreams USING gin (tags);
 &   DROP INDEX public.upstreams_tags_idx;
       public            kong    false    194            ?
           1259    17619    vcbr_svc_ts_idx    INDEX     e   CREATE INDEX vcbr_svc_ts_idx ON public.vitals_codes_by_route USING btree (service_id, duration, at);
 #   DROP INDEX public.vcbr_svc_ts_idx;
       public            kong    false    231    231    231            ?
           1259    17647     workspace_entities_composite_idx    INDEX     ?   CREATE INDEX workspace_entities_composite_idx ON public.workspace_entities USING btree (workspace_id, entity_type, unique_field_name);
 4   DROP INDEX public.workspace_entities_composite_idx;
       public            kong    false    235    235    235            ?
           1259    17646     workspace_entities_idx_entity_id    INDEX     d   CREATE INDEX workspace_entities_idx_entity_id ON public.workspace_entities USING btree (entity_id);
 4   DROP INDEX public.workspace_entities_idx_entity_id;
       public            kong    false    235            ?           2620    16929    acls acls_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER acls_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.acls FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 4   DROP TRIGGER acls_sync_tags_trigger ON public.acls;
       public          kong    false    203    203    281            ?           2620    16983 1   basicauth_credentials basicauth_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER basicauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.basicauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 J   DROP TRIGGER basicauth_sync_tags_trigger ON public.basicauth_credentials;
       public          kong    false    281    205    205            ?           2620    16596 1   ca_certificates ca_certificates_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER ca_certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.ca_certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 J   DROP TRIGGER ca_certificates_sync_tags_trigger ON public.ca_certificates;
       public          kong    false    198    281    198            ?           2620    16573 +   certificates certificates_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER certificates_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.certificates FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 D   DROP TRIGGER certificates_sync_tags_trigger ON public.certificates;
       public          kong    false    281    190    190            ?           2620    16577 %   consumers consumers_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER consumers_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.consumers FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 >   DROP TRIGGER consumers_sync_tags_trigger ON public.consumers;
       public          kong    false    192    281    192            ?           2620    17055 /   hmacauth_credentials hmacauth_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER hmacauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.hmacauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 H   DROP TRIGGER hmacauth_sync_tags_trigger ON public.hmacauth_credentials;
       public          kong    false    208    281    208            ?           2620    17100 (   jwt_secrets jwtsecrets_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER jwtsecrets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.jwt_secrets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 A   DROP TRIGGER jwtsecrets_sync_tags_trigger ON public.jwt_secrets;
       public          kong    false    209    281    209            ?           2620    17171 -   keyauth_credentials keyauth_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER keyauth_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.keyauth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 F   DROP TRIGGER keyauth_sync_tags_trigger ON public.keyauth_credentials;
       public          kong    false    211    211    281            ?           2620    17270 ;   konnect_applications konnect_applications_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER konnect_applications_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.konnect_applications FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 T   DROP TRIGGER konnect_applications_sync_tags_trigger ON public.konnect_applications;
       public          kong    false    213    281    213            ?           2620    18317 =   mtls_auth_credentials mtls_auth_credentials_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER mtls_auth_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.mtls_auth_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 V   DROP TRIGGER mtls_auth_credentials_sync_tags_trigger ON public.mtls_auth_credentials;
       public          kong    false    214    214    281            ?           2620    17390 7   oauth2_credentials oauth2_credentials_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER oauth2_credentials_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.oauth2_credentials FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 P   DROP TRIGGER oauth2_credentials_sync_tags_trigger ON public.oauth2_credentials;
       public          kong    false    215    281    215            ?           2620    16579 !   plugins plugins_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER plugins_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.plugins FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 :   DROP TRIGGER plugins_sync_tags_trigger ON public.plugins;
       public          kong    false    193    281    193            ?           2620    16571    routes routes_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER routes_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.routes FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 8   DROP TRIGGER routes_sync_tags_trigger ON public.routes;
       public          kong    false    281    189    189            ?           2620    16569 #   services services_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER services_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.services FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 <   DROP TRIGGER services_sync_tags_trigger ON public.services;
       public          kong    false    281    188    188            ?           2620    16902 %   sm_vaults sm_vaults_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER sm_vaults_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.sm_vaults FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 >   DROP TRIGGER sm_vaults_sync_tags_trigger ON public.sm_vaults;
       public          kong    false    202    281    202            ?           2620    16575    snis snis_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER snis_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.snis FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 4   DROP TRIGGER snis_sync_tags_trigger ON public.snis;
       public          kong    false    191    281    191            ?           2620    16583 !   targets targets_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER targets_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.targets FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 :   DROP TRIGGER targets_sync_tags_trigger ON public.targets;
       public          kong    false    195    281    195            ?           2620    16581 %   upstreams upstreams_sync_tags_trigger    TRIGGER     ?   CREATE TRIGGER upstreams_sync_tags_trigger AFTER INSERT OR DELETE OR UPDATE OF tags ON public.upstreams FOR EACH ROW EXECUTE PROCEDURE public.sync_tags();
 >   DROP TRIGGER upstreams_sync_tags_trigger ON public.upstreams;
       public          kong    false    194    281    194            x           2606    16949    acls acls_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.acls DROP CONSTRAINT acls_consumer_id_fkey;
       public          kong    false    2550    203    203    192    192            y           2606    16931    acls acls_ws_id_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.acls
    ADD CONSTRAINT acls_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 >   ALTER TABLE ONLY public.acls DROP CONSTRAINT acls_ws_id_fkey;
       public          kong    false    203    199    2602            ?           2606    17820    admins admins_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id);
 H   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_consumer_id_fkey;
       public          kong    false    192    246    2552            ?           2606    17825    admins admins_rbac_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_rbac_user_id_fkey FOREIGN KEY (rbac_user_id) REFERENCES public.rbac_users(id);
 I   ALTER TABLE ONLY public.admins DROP CONSTRAINT admins_rbac_user_id_fkey;
       public          kong    false    2788    246    237            ?           2606    18160 ?   application_instances application_instances_application_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_application_id_fkey FOREIGN KEY (application_id, ws_id) REFERENCES public.applications(id, ws_id);
 i   ALTER TABLE ONLY public.application_instances DROP CONSTRAINT application_instances_application_id_fkey;
       public          kong    false    255    256    256    255    2867            ?           2606    18165 ;   application_instances application_instances_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);
 e   ALTER TABLE ONLY public.application_instances DROP CONSTRAINT application_instances_service_id_fkey;
       public          kong    false    188    256    256    188    2522            ?           2606    18145 6   application_instances application_instances_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.application_instances
    ADD CONSTRAINT application_instances_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 `   ALTER TABLE ONLY public.application_instances DROP CONSTRAINT application_instances_ws_id_fkey;
       public          kong    false    256    199    2602            ?           2606    18134 *   applications applications_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id);
 T   ALTER TABLE ONLY public.applications DROP CONSTRAINT applications_consumer_id_fkey;
       public          kong    false    192    255    255    2550    192            ?           2606    18139 +   applications applications_developer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_developer_id_fkey FOREIGN KEY (developer_id, ws_id) REFERENCES public.developers(id, ws_id);
 U   ALTER TABLE ONLY public.applications DROP CONSTRAINT applications_developer_id_fkey;
       public          kong    false    247    255    255    2836    247            ?           2606    18118 $   applications applications_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 N   ALTER TABLE ONLY public.applications DROP CONSTRAINT applications_ws_id_fkey;
       public          kong    false    199    255    2602            z           2606    17002 <   basicauth_credentials basicauth_credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 f   ALTER TABLE ONLY public.basicauth_credentials DROP CONSTRAINT basicauth_credentials_consumer_id_fkey;
       public          kong    false    2550    205    205    192    192            {           2606    16985 6   basicauth_credentials basicauth_credentials_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.basicauth_credentials
    ADD CONSTRAINT basicauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 `   ALTER TABLE ONLY public.basicauth_credentials DROP CONSTRAINT basicauth_credentials_ws_id_fkey;
       public          kong    false    199    2602    205            k           2606    16701 $   certificates certificates_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 N   ALTER TABLE ONLY public.certificates DROP CONSTRAINT certificates_ws_id_fkey;
       public          kong    false    199    2602    190            ?           2606    18255 H   consumer_group_consumers consumer_group_consumers_consumer_group_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_consumer_group_id_fkey FOREIGN KEY (consumer_group_id) REFERENCES public.consumer_groups(id) ON DELETE CASCADE;
 r   ALTER TABLE ONLY public.consumer_group_consumers DROP CONSTRAINT consumer_group_consumers_consumer_group_id_fkey;
       public          kong    false    2894    264    262            ?           2606    18260 B   consumer_group_consumers consumer_group_consumers_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_group_consumers
    ADD CONSTRAINT consumer_group_consumers_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;
 l   ALTER TABLE ONLY public.consumer_group_consumers DROP CONSTRAINT consumer_group_consumers_consumer_id_fkey;
       public          kong    false    264    2552    192            ?           2606    18304 D   consumer_group_plugins consumer_group_plugins_consumer_group_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_consumer_group_id_fkey FOREIGN KEY (consumer_group_id, ws_id) REFERENCES public.consumer_groups(id, ws_id) ON DELETE CASCADE;
 n   ALTER TABLE ONLY public.consumer_group_plugins DROP CONSTRAINT consumer_group_plugins_consumer_group_id_fkey;
       public          kong    false    263    262    262    2891    263            ?           2606    18287 8   consumer_group_plugins consumer_group_plugins_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_group_plugins
    ADD CONSTRAINT consumer_group_plugins_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 b   ALTER TABLE ONLY public.consumer_group_plugins DROP CONSTRAINT consumer_group_plugins_ws_id_fkey;
       public          kong    false    2602    199    263            ?           2606    18268 *   consumer_groups consumer_groups_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_groups
    ADD CONSTRAINT consumer_groups_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 T   ALTER TABLE ONLY public.consumer_groups DROP CONSTRAINT consumer_groups_ws_id_fkey;
       public          kong    false    262    199    2602            ?           2606    17800 >   consumer_reset_secrets consumer_reset_secrets_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumer_reset_secrets
    ADD CONSTRAINT consumer_reset_secrets_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.consumer_reset_secrets DROP CONSTRAINT consumer_reset_secrets_consumer_id_fkey;
       public          kong    false    2552    245    192            n           2606    16678    consumers consumers_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 H   ALTER TABLE ONLY public.consumers DROP CONSTRAINT consumers_ws_id_fkey;
       public          kong    false    2602    192    199            ?           2606    17783 (   credentials credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.credentials
    ADD CONSTRAINT credentials_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.credentials DROP CONSTRAINT credentials_consumer_id_fkey;
       public          kong    false    2552    244    192            |           2606    17017 1   degraphql_routes degraphql_routes_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.degraphql_routes
    ADD CONSTRAINT degraphql_routes_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 [   ALTER TABLE ONLY public.degraphql_routes DROP CONSTRAINT degraphql_routes_service_id_fkey;
       public          kong    false    2524    188    206            ?           2606    18080 &   developers developers_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id);
 P   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_consumer_id_fkey;
       public          kong    false    192    192    247    247    2550            ?           2606    18085 '   developers developers_rbac_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_rbac_user_id_fkey FOREIGN KEY (rbac_user_id, ws_id) REFERENCES public.rbac_users(id, ws_id);
 Q   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_rbac_user_id_fkey;
       public          kong    false    247    237    2785    247    237            ?           2606    18063     developers developers_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.developers
    ADD CONSTRAINT developers_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 J   ALTER TABLE ONLY public.developers DROP CONSTRAINT developers_ws_id_fkey;
       public          kong    false    199    247    2602            ?           2606    18110 1   document_objects document_objects_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);
 [   ALTER TABLE ONLY public.document_objects DROP CONSTRAINT document_objects_service_id_fkey;
       public          kong    false    188    188    257    257    2522            ?           2606    18095 ,   document_objects document_objects_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.document_objects
    ADD CONSTRAINT document_objects_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 V   ALTER TABLE ONLY public.document_objects DROP CONSTRAINT document_objects_ws_id_fkey;
       public          kong    false    199    2602    257            ?           2606    18044    files files_ws_id_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 @   ALTER TABLE ONLY public.files DROP CONSTRAINT files_ws_id_fkey;
       public          kong    false    199    242    2602            }           2606    17031 k   graphql_ratelimiting_advanced_cost_decoration graphql_ratelimiting_advanced_cost_decoration_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.graphql_ratelimiting_advanced_cost_decoration
    ADD CONSTRAINT graphql_ratelimiting_advanced_cost_decoration_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.graphql_ratelimiting_advanced_cost_decoration DROP CONSTRAINT graphql_ratelimiting_advanced_cost_decoration_service_id_fkey;
       public          kong    false    188    207    2524            ?           2606    17885 /   group_rbac_roles group_rbac_roles_group_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.group_rbac_roles DROP CONSTRAINT group_rbac_roles_group_id_fkey;
       public          kong    false    250    251    2854            ?           2606    17890 3   group_rbac_roles group_rbac_roles_rbac_role_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_rbac_role_id_fkey FOREIGN KEY (rbac_role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.group_rbac_roles DROP CONSTRAINT group_rbac_roles_rbac_role_id_fkey;
       public          kong    false    2799    238    251            ?           2606    17895 3   group_rbac_roles group_rbac_roles_workspace_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.group_rbac_roles
    ADD CONSTRAINT group_rbac_roles_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.group_rbac_roles DROP CONSTRAINT group_rbac_roles_workspace_id_fkey;
       public          kong    false    199    2602    251            ~           2606    17074 :   hmacauth_credentials hmacauth_credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 d   ALTER TABLE ONLY public.hmacauth_credentials DROP CONSTRAINT hmacauth_credentials_consumer_id_fkey;
       public          kong    false    2550    192    192    208    208                       2606    17057 4   hmacauth_credentials hmacauth_credentials_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.hmacauth_credentials
    ADD CONSTRAINT hmacauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 ^   ALTER TABLE ONLY public.hmacauth_credentials DROP CONSTRAINT hmacauth_credentials_ws_id_fkey;
       public          kong    false    208    199    2602            ?           2606    17120 (   jwt_secrets jwt_secrets_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.jwt_secrets DROP CONSTRAINT jwt_secrets_consumer_id_fkey;
       public          kong    false    209    192    2550    209    192            ?           2606    17102 "   jwt_secrets jwt_secrets_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.jwt_secrets
    ADD CONSTRAINT jwt_secrets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 L   ALTER TABLE ONLY public.jwt_secrets DROP CONSTRAINT jwt_secrets_ws_id_fkey;
       public          kong    false    199    209    2602            ?           2606    17192 8   keyauth_credentials keyauth_credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 b   ALTER TABLE ONLY public.keyauth_credentials DROP CONSTRAINT keyauth_credentials_consumer_id_fkey;
       public          kong    false    192    192    211    211    2550            ?           2606    17174 2   keyauth_credentials keyauth_credentials_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.keyauth_credentials
    ADD CONSTRAINT keyauth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 \   ALTER TABLE ONLY public.keyauth_credentials DROP CONSTRAINT keyauth_credentials_ws_id_fkey;
       public          kong    false    211    199    2602            ?           2606    17244 @   keyauth_enc_credentials keyauth_enc_credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 j   ALTER TABLE ONLY public.keyauth_enc_credentials DROP CONSTRAINT keyauth_enc_credentials_consumer_id_fkey;
       public          kong    false    192    212    212    192    2550            ?           2606    17228 :   keyauth_enc_credentials keyauth_enc_credentials_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.keyauth_enc_credentials
    ADD CONSTRAINT keyauth_enc_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 d   ALTER TABLE ONLY public.keyauth_enc_credentials DROP CONSTRAINT keyauth_enc_credentials_ws_id_fkey;
       public          kong    false    199    212    2602            ?           2606    17264 4   konnect_applications konnect_applications_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.konnect_applications
    ADD CONSTRAINT konnect_applications_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 ^   ALTER TABLE ONLY public.konnect_applications DROP CONSTRAINT konnect_applications_ws_id_fkey;
       public          kong    false    213    2602    199            ?           2606    17916 .   login_attempts login_attempts_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.login_attempts
    ADD CONSTRAINT login_attempts_consumer_id_fkey FOREIGN KEY (consumer_id) REFERENCES public.consumers(id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.login_attempts DROP CONSTRAINT login_attempts_consumer_id_fkey;
       public          kong    false    192    253    2552            ?           2606    17287 B   mtls_auth_credentials mtls_auth_credentials_ca_certificate_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_ca_certificate_id_fkey FOREIGN KEY (ca_certificate_id) REFERENCES public.ca_certificates(id) ON DELETE CASCADE;
 l   ALTER TABLE ONLY public.mtls_auth_credentials DROP CONSTRAINT mtls_auth_credentials_ca_certificate_id_fkey;
       public          kong    false    214    2598    198            ?           2606    17312 <   mtls_auth_credentials mtls_auth_credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 f   ALTER TABLE ONLY public.mtls_auth_credentials DROP CONSTRAINT mtls_auth_credentials_consumer_id_fkey;
       public          kong    false    192    214    192    2550    214            ?           2606    17295 6   mtls_auth_credentials mtls_auth_credentials_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.mtls_auth_credentials
    ADD CONSTRAINT mtls_auth_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 `   ALTER TABLE ONLY public.mtls_auth_credentials DROP CONSTRAINT mtls_auth_credentials_ws_id_fkey;
       public          kong    false    214    2602    199            ?           2606    17444 H   oauth2_authorization_codes oauth2_authorization_codes_credential_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;
 r   ALTER TABLE ONLY public.oauth2_authorization_codes DROP CONSTRAINT oauth2_authorization_codes_credential_id_fkey;
       public          kong    false    215    2700    215    216    216            ?           2606    17439 E   oauth2_authorization_codes oauth2_authorization_codes_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;
 o   ALTER TABLE ONLY public.oauth2_authorization_codes DROP CONSTRAINT oauth2_authorization_codes_service_id_fkey;
       public          kong    false    216    188    216    188    2522            ?           2606    17420 @   oauth2_authorization_codes oauth2_authorization_codes_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_authorization_codes
    ADD CONSTRAINT oauth2_authorization_codes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 j   ALTER TABLE ONLY public.oauth2_authorization_codes DROP CONSTRAINT oauth2_authorization_codes_ws_id_fkey;
       public          kong    false    2602    216    199            ?           2606    17412 6   oauth2_credentials oauth2_credentials_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.oauth2_credentials DROP CONSTRAINT oauth2_credentials_consumer_id_fkey;
       public          kong    false    215    192    215    2550    192            ?           2606    17394 0   oauth2_credentials oauth2_credentials_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_credentials
    ADD CONSTRAINT oauth2_credentials_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 Z   ALTER TABLE ONLY public.oauth2_credentials DROP CONSTRAINT oauth2_credentials_ws_id_fkey;
       public          kong    false    2602    199    215            ?           2606    17477 .   oauth2_tokens oauth2_tokens_credential_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_credential_id_fkey FOREIGN KEY (credential_id, ws_id) REFERENCES public.oauth2_credentials(id, ws_id) ON DELETE CASCADE;
 X   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_credential_id_fkey;
       public          kong    false    217    215    215    2700    217            ?           2606    17472 +   oauth2_tokens oauth2_tokens_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_service_id_fkey;
       public          kong    false    188    217    188    217    2522            ?           2606    17452 &   oauth2_tokens oauth2_tokens_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.oauth2_tokens
    ADD CONSTRAINT oauth2_tokens_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 P   ALTER TABLE ONLY public.oauth2_tokens DROP CONSTRAINT oauth2_tokens_ws_id_fkey;
       public          kong    false    199    2602    217            o           2606    16820     plugins plugins_consumer_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_consumer_id_fkey FOREIGN KEY (consumer_id, ws_id) REFERENCES public.consumers(id, ws_id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_consumer_id_fkey;
       public          kong    false    193    2550    192    193    192            p           2606    16810    plugins plugins_route_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_route_id_fkey FOREIGN KEY (route_id, ws_id) REFERENCES public.routes(id, ws_id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_route_id_fkey;
       public          kong    false    193    189    189    2529    193            q           2606    16815    plugins plugins_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_service_id_fkey;
       public          kong    false    193    2522    188    188    193            r           2606    16790    plugins plugins_ws_id_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 D   ALTER TABLE ONLY public.plugins DROP CONSTRAINT plugins_ws_id_fkey;
       public          kong    false    199    2602    193            ?           2606    17730 4   rbac_role_endpoints rbac_role_endpoints_role_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_role_endpoints
    ADD CONSTRAINT rbac_role_endpoints_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;
 ^   ALTER TABLE ONLY public.rbac_role_endpoints DROP CONSTRAINT rbac_role_endpoints_role_id_fkey;
       public          kong    false    2799    241    238            ?           2606    17715 2   rbac_role_entities rbac_role_entities_role_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_role_entities
    ADD CONSTRAINT rbac_role_entities_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.rbac_role_entities DROP CONSTRAINT rbac_role_entities_role_id_fkey;
       public          kong    false    238    240    2799            ?           2606    18024     rbac_roles rbac_roles_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 J   ALTER TABLE ONLY public.rbac_roles DROP CONSTRAINT rbac_roles_ws_id_fkey;
       public          kong    false    2602    238    199            ?           2606    17699 ,   rbac_user_roles rbac_user_roles_role_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.rbac_user_roles DROP CONSTRAINT rbac_user_roles_role_id_fkey;
       public          kong    false    238    239    2799            ?           2606    17694 ,   rbac_user_roles rbac_user_roles_user_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.rbac_users(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.rbac_user_roles DROP CONSTRAINT rbac_user_roles_user_id_fkey;
       public          kong    false    237    239    2788            ?           2606    18002     rbac_users rbac_users_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.rbac_users
    ADD CONSTRAINT rbac_users_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 J   ALTER TABLE ONLY public.rbac_users DROP CONSTRAINT rbac_users_ws_id_fkey;
       public          kong    false    199    237    2602            i           2606    16782    routes routes_service_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_service_id_fkey FOREIGN KEY (service_id, ws_id) REFERENCES public.services(id, ws_id);
 G   ALTER TABLE ONLY public.routes DROP CONSTRAINT routes_service_id_fkey;
       public          kong    false    188    188    189    189    2522            j           2606    16765    routes routes_ws_id_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 B   ALTER TABLE ONLY public.routes DROP CONSTRAINT routes_ws_id_fkey;
       public          kong    false    2602    199    189            g           2606    16757 ,   services services_client_certificate_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_client_certificate_id_fkey FOREIGN KEY (client_certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);
 V   ALTER TABLE ONLY public.services DROP CONSTRAINT services_client_certificate_id_fkey;
       public          kong    false    188    2537    190    190    188            h           2606    16740    services services_ws_id_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 F   ALTER TABLE ONLY public.services DROP CONSTRAINT services_ws_id_fkey;
       public          kong    false    188    2602    199            w           2606    16903    sm_vaults sm_vaults_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.sm_vaults
    ADD CONSTRAINT sm_vaults_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 H   ALTER TABLE ONLY public.sm_vaults DROP CONSTRAINT sm_vaults_ws_id_fkey;
       public          kong    false    199    2602    202            l           2606    16734    snis snis_certificate_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_certificate_id_fkey FOREIGN KEY (certificate_id, ws_id) REFERENCES public.certificates(id, ws_id);
 G   ALTER TABLE ONLY public.snis DROP CONSTRAINT snis_certificate_id_fkey;
       public          kong    false    190    2537    190    191    191            m           2606    16717    snis snis_ws_id_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.snis
    ADD CONSTRAINT snis_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 >   ALTER TABLE ONLY public.snis DROP CONSTRAINT snis_ws_id_fkey;
       public          kong    false    191    2602    199            u           2606    16672     targets targets_upstream_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_upstream_id_fkey FOREIGN KEY (upstream_id, ws_id) REFERENCES public.upstreams(id, ws_id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.targets DROP CONSTRAINT targets_upstream_id_fkey;
       public          kong    false    194    195    195    194    2573            v           2606    16655    targets targets_ws_id_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public.targets
    ADD CONSTRAINT targets_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 D   ALTER TABLE ONLY public.targets DROP CONSTRAINT targets_ws_id_fkey;
       public          kong    false    195    199    2602            s           2606    16617 .   upstreams upstreams_client_certificate_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_client_certificate_id_fkey FOREIGN KEY (client_certificate_id) REFERENCES public.certificates(id);
 X   ALTER TABLE ONLY public.upstreams DROP CONSTRAINT upstreams_client_certificate_id_fkey;
       public          kong    false    190    2539    194            t           2606    16635    upstreams upstreams_ws_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.upstreams
    ADD CONSTRAINT upstreams_ws_id_fkey FOREIGN KEY (ws_id) REFERENCES public.workspaces(id);
 H   ALTER TABLE ONLY public.upstreams DROP CONSTRAINT upstreams_ws_id_fkey;
       public          kong    false    2602    194    199            ?           2606    17656 E   workspace_entity_counters workspace_entity_counters_workspace_id_fkey    FK CONSTRAINT     ?   ALTER TABLE ONLY public.workspace_entity_counters
    ADD CONSTRAINT workspace_entity_counters_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;
 o   ALTER TABLE ONLY public.workspace_entity_counters DROP CONSTRAINT workspace_entity_counters_workspace_id_fkey;
       public          kong    false    236    199    2602            K   
   x???          L   
   x???          v     x?}?=k?0???
mN?
?dIV:u?0.4IW??s1?G?$??+R:?.???sܝ?????N??ݣz??n?'???ˑ]@p?9?w???y?q??]??h?F?{
??&mH??r???'Sb'=B?D?????a??e?>^??񌶙?U)?Ԙ8?pɬ??$
Ҫ
t?3Y?2ZP?	?D?B?<????(?rL?dMB?Ķ?R?(?b?:'?`??Tu?Z??8?TP?HVqX}a????Z?Ϛ????}<3?+۽l6?oF?o?      ?   
   x???             
   x???          x   
   x???          y   
   x???          M     x???n?0D?|?w5???6]u?	Q?@??74*IP??߯a7?93???v?g?????}	?.????????&???2Yw?&??3???E?C^z??g?d??cM?>??8o??\?G.???|.?YWLq?XB*?TY??2?i??D?tB`UM*????S?3[[???+??v)Q&??JrG?*??$?0O?o??O}7?Z????s%8??L?A0?cmT??????P)??< 5h%U?)j:??Z??`??|?V?t6Z2      F   
   x???          >   
   x???          ;   m  x?ݘOoG????9AMa??P=??C? ??W?3??Bdɐd#???jm???,??IZ?`?߾yK?ͻ???0y??ï?뛺??i[?l????[Yn7??s>?,W,??????'??z????{???R??-?????ۏ??O^???%[??Q???P?!8!J??T???'g?Ř?H??????k??rX????Zpib???,?i?'c???>?}???}??|yK???9_-7Å???v-t????5{??#S`ŵ?;%?\#?I??д??R??\N????/?<#Y?h"R???Œ?Z?Zv??Dۻ5??&?4ٝ??҂?Mֳ?WY????? ?3]]/?bw???mO?qV?? ?|j?Pn6????]?;?吅?4?,?B=p?????Z%lȃ?%5??XgN?©?jQ????Պ?--?M?T??&??i?;?#n??X? ??VK?oea+s(E-?C?̀?R=DOD?Ɓ?Ӑ?	??4_ZxK??d{??/W???W퓬???"Z?b捱????C$?dIk40?CB??g?<23f9?N????@???1ȟ?6?IC?'?s?D?.w??Kb4hz̺??1???y?iOƟ\l?Hz?A?`?9-?z7?IG?.?i?;ͩ??|+???{? u?Ҟ?m?Ř?\?Q?b???????|?Ѝ?o?M63S?u/lX'??"???z?*???Nf ¤?0Cv?i??I=?|iٰ????DR?????_l@???%}?Z???ըj???,?.?/6????Q?d???%xQ܀?f??}ˢ?`<?#,??׫mtv+??^znY??D?R??ᚮB?Bh?G΍c?#?#<?j??l/??Yr??>QW???????:DS???Kvm?O?I??<??(?e??1??`IX????C??1?ο??C{???t?w??뾜?u^??&?????Fb	cN???S?C???,??PDnB	??SoC6?U?E??Jwp?z?9??ʕ??!????T?kX?,Vk?ؖ???73???d?=͏Y???Iy????AgV-$????:??X????C???9??bL?????5??F?.5??Å?eD??0??4?;?R??M;?~?#$j?A?e??͈????M?i ;????/????[      H   
   x???          ?   
   x???          ?   
   x???          ?   
   x???          u   
   x???          @     x???Kk?0????9??"ɲd??@s0?.?I?F?mj???PJ?{??@????????????iO?b?H?ɞ*w??f?j???|L\?fD_?1&Ӏ}cj?4?m]΁?????qI????}8~t?"/??a?L?Q*???{??? ????2???3.??D?r?ӄ?u??\?P:_???X_WM??ȋ2??a??????k?H??
?<jИeLK͕Ts?oIX??n??/????X??Q???%R?,3	K?k? ?ur?`??4?]?P?Y~???U,?o ?      t   
   x???          N   
   x???          w   
   x???          ?   
   x???          ?   
   x???          r   
   x???          O   
   x???          {   
   x???          z   
   x???          P   
   x???          Q   )  x?5?]O?0??????t]??J#2g`??-???!ss+"??M??ɓ??99?"N??Xě???̮?'?v6k????4>?Q9kR?z???ce?t>????P?m??+??J/???ũ??????&`wm?	{J?????jIF2??f?H"B???{>?0?? >?bJ?BC??Vb?4?,C?М@i? f\*(?hپ??-ۦ??f+Gܩz???lr?~??jp滇?_????<9??T[?}?S,M????<&???m?O?ha??2+¾"P+?O?$??3?MnF??/njG      R   
   x???          S     x???N?0??y?ޱE??iKi??1?2C0f??B7ql#4??????ON?u?/7Yg??F?6???]?8|?????44??ɬ?#??\]????S?ݥ?????`???C????9y?O?˜?B???()?4
??1???P?E?T:?È??2??$?r?l?????????UEA?;?q??QL,?q<??|s<?}z*??_???ի?????~??V?}???????|?2d?4?????&I@:?ATT?????B-5Kd??? ??V?      T   
   x???          ?   
   x???          ~   
   x???          U   
   x???          s   
   x???          |   5  x??ӻJCA?>O?]8#3?????"E@??a/s0?'c?ۻ???????+?Y_ެ?o?????<???m=??ӫnZ>d??vM7?6???l?t?W^????t<???k??i7?????nucs?$?Z??s?k??9?q??j????`??$????sz??<???l??V?+7??1w?'??1e/ʶ???X1SM??k'1A??Z+y
??t??'??O?Z?u?ؤ\?R?U(7[E0?????I??!B??t>HDZTWE?=6D??\???B
?<???-ѷе)+???z????l(q      ?   
   x???          :   
   x???          }   
   x???          V   
   x???          X   
   x???          W   
   x???          Y   
   x???          Z   
   x???          [      x??z׮?H??{E?_zh
?Fz?K?I?? ?ޓI#̿+o?Uuk???98????w,LI?y??E????H?&?oS????m??[????????V\??????!Y?&p@8D (??@?B8??^?)VR	??????????????_???????O׾?!???6q????ry???f??Ԗ?G(+2NF	?????ߓ????h??c?5???,K>ѱ???~????k2??Ɠ??Jh?(????????Ԕ??V?V?XmM?????/???ފFi???< ??Lk?[Ճn'wjYQ??#?U??[뷁?>? ???EH??b????~M?=@?
?%?N??Z?1??h?-	 ???J7?}?{wwNxt???4??>˽???#	??????g?1?q??GW߀6S=ܖ??????0?i?&???
:l??yͮ?9U???8? ^	??????_?¯?Ѧ5tC;?;L9?93(?????p?????pA?Ȯ<???T?'?g	???}??l?? ?>A????q?x??s[?<oq??9??ɯuj>??2:b?*?3??r)??ά?mV?"??;j???
l~:?7?}әnmܓ??[ ?*??i?r???Mjc??~?1xt?(Z"?7?;?Q???4D?ĸ????.????h?['/???h׼??w??? E???C?N)?????R?0^?([S>V??????e??|ʳb?vB??ι?ۋ??_[?+??Af~,??Ug;Vï+yZ??}6^)???K}?;n:X??}r{?'?p@9??D??`UW?X4??H'?p????Uh#	?"u٨??$&S?Ĕ?\?	C?jM0	w??Ͼ??2??}Eq??vD׍=TI??????Z??(??? ?|?Wh-?`P?Kr?(??3???rF~????z?Qt??Z#K?[?ꚲ;}??????wݵ?d??-ӈO?}_?IaeOg?Sd&W??k??U???q~??X{?? )R3j??C??m????;?=?;????a???MC/$?7????:?&5
t&gW??g1?a?(EH????K8?#,dN?Q@??? 絗v??ֆ%?q??+i???n?S??=??!1??n?mϧ&?_ګ??
wHk????G?Dˆf?G?ˏ??2-?J?B???͜~æ?V?'^??{??b?B{?
 ?I??P??&???_H/d?d?B_?j??".??hyIFn?9??+V@Gk?V????{?#?\%????V?|w|;GN???2???.?zy?k?sZ	????W?[????c#6?2?Ʀ8??t/??z??&??/{???-????}T??P?^?5"?z2y??????h0?d?????a_%l?꣘?٩O7S????c?8Jߡ??N?ĺR?vD	??;,?y??+A̕8??W??_?.???y5#q?ixӃ?k???B?w?3$??UL????8^?^?mP2E0????婆D??C?Z0?????:z?d?ډy?VE??????Tàz ?IԗXz[$7R?k???d/???u.!ȁW?ԉ?ե?:͏?? (?Jr?3s?
P???G6??Pp??BN???{????9?q??TR??KJ????????T??b?h?o\%?a ??_?T????,JQ??QwEr??n;??b o?LF!qc?X??F?D?Ut??ܨ????c?I?????r????}?y??u&???{?????H????(??'ղl?OUKK?4a#jIK???Y?t?a? ?ާ???g?拺?g}K??3& ٛ 5??Ɔ?????pJ??????)???1??G??? \?
#'??;C?V2Z????F??ԭR{?/?g`"w????????-l;++????h?^J?AQb??042?== ???HY%???"m!iљ??8k?'X?=k????zޑ8?St_?H???pI?n???ؿ???<?Q\??D?n????׬?t?wj%??zG??ĞA;<??????ٛ2????"???;????????^r???9?0?$??e?-A?}?5??????]?ZG?<8Ǯ?CR$v???5?:?1??qݝ??e??b?Ѫ?,??F??7^?uv?g?m*???,L$?T?-?Z?nU ?w=?\Q??uO?|?ѹ? ??9&<!O<?w]`z?MA?K??G١?*[lO???7?3͘??}?)(c_Q?ǀړ	??[?z??#???
'?BAJ?ž?????f?0?HFE??	????G?S??Й??WO?;M_?9?c?6??K\?8?$?????fx?E3dX??D/a?h?S&Yx#???(i#^?}?^??7??r3I t0?M6u????a9????qC????6-??$~??<{?Q?T?I?7?:??*?i[,?I??I?y
/Ы**S???6Nk?3?R?5????{N?B?*?ަkN2Ύ}???x??o'\?)(V)?????f??7?O??1???????n???	?Ҋ?7?9?O??P??V????Nv?w?? ??4v?T?????7??_?c?ꝏ?}|?;*???[IL?Q]??vy??????ÓK?????v??i?u???NN????b??!??s???ph!?1[?xP_?˞?Է? ?+V! y??!???i??I??W-?-???l?c???C?l>??e?2e$?  ڡZ:/ ?s??????2Ǘ0^Q_/2B?JM{??_???????ş????˚:Yۦ???E[)????c͐??X?!zh??ơ?U?L???楃ȋ?]????)??Jy?g?MTv#0?^?N'6?N????S1???Lkq??Ȭ?WYR ??97 ??!?~??
͌,?l?z??V?%??!??N??\<m6u$?E?s?	???Bzh?l??^!ε??,C?}?*g?A??+lʖ?@??_?W?2???D??w>?V?????N?Q?|??2F??1?ie_??Fh?c??????z?Txfx?g?CK?W?l??ph!??w?8???T? c3?f???8????w ???S?.?F/uD?;?W??????????9??K?Q,?!?k\?C?W6?2x?KF?	s??Me??j,tG]?W??/.!ә--,?889????%?Cc?-,bX??!$5\(??7??????#?;5y÷?G<?Rt?????&?/
T??	g?잕??eҳX????F??zn?#'????)??S-?Q?5kH?G_?tm???.=??D??ӱ?h?	!Ϟ?,Rk??bxU????w
?r?T?/y???<???????:?ㅓM?:?f????^&a???y?{)'?H??8?v???6?
sAc&}9?{?#
??jwG?4???,???t???j??o?4?Sw??/"??Dk???0rcw?^?FJϞ??i̹???r>???`?o??uM?z?G???,??V?q,??p?K?~J?Q?۾;8`??85Z??????7?B????i?}?<]~j??>:w+?Q?Ux?)d~FW??????lX????Z?81??k7???(? ??s?zV?G???K!6H?q???׹?azt&?g?+#U??h??Dw#:?/yA?I1???;?F??3?ah`???M?.?K%?h???? Ӥ???P6??+䜻&D*3'^u2h?????? Q_??'㻅}O???W????t?{?ǻ?@?S??^?Zۭn??¥*?V??Qҿڹ?J?G??;"<?w|???U
x9??!???4?OY?թԆ??3
?j&q?'?Kū?E^-ְ]?Zm???d<??(?~{?3?E??%???O/\??͒\{ sEw$?^$???1ӯ?p?q[͵jjq`?8?(?K?:?:9ޘ????}a:?f?]????????I?4?=|??18??4?7?4?W??5?ؽ?2??b?]??Y???? ?RF?ȏ)??Lwcq???& ?|H?>??G???.?Eݮ?h??c?C??0?????'~`???a?U?;??<WƋ&űk	 ?-\?4???Zv.???W"???| ?ȕW?<]?ǣ$?:?
y??Rov?6??ǝcg?uc-?y???G???-?4?f??󒴾?E????M??Ƶ~V??bM??ߵ????È?O?#&lJ?M    Z3???? A???AH???Z?!\7Ҥ??k?]I??*???7?O?aM8?.??_T?????Җ,?)??U?4?=/$?%N?ݩ???c`??٨Fr?K????J?|o`#??o}K?9???ņ??p??3~}?ؤ?p??o?b????n??R??B??????gZ????/?? 6???C	???-?:?ߞm?\H?2z?s???*???g????w4S- ??>M^?%???-0p?&???鲙?2d?ד?Ix??0?a?Ao?KX0?????u?TgId?j??UW??	?s?	X^?m??j??rW?UD?????Yw%?>??T??ۺ,?P??o?'??H????ɗ???C??d?0U?fQ?G?Hϓx?2?P'?o??? vSg͕E?oB>?RCM??4?????????߯?~??QRv??Ɔp??F??Rv???rg?0?>-?#G??A???v??C?c?k?WFJ?5??k????i??aK??@}??)U?+	?ۜ??'?u+Uڨ???}z?Y ?,?יЕ?Uhһ?L??V?wg????u%`z??R???QY??<?^s?iV?????? V?;???!@?}gm?^@+;?=/?C&ƴd]???"!5s??G??Zs????_??݈????&X1`?}9?????@8?????ս?9?L??????.?$_??H?A1???v?????{?mHۊҪǨѽߓ???\?<?_?Sp?Vl??3Q+?????[?u??-k???蟼?]y?ȼ&?_?q?J??/?ۙ??Y?4?v*???? ?J??sa?????? ??????j?(?* ?>i9????N?_???H????????YnW?*??a?{&.?-B[??m?s(?.o?>@-Fg???=E?a?*|??RD???R???f^"??????O?Gs?????G?5?ruL??x???t8;???*P?x??+Żd|?ϝ???E????V:?f???f?d?t??KL??#x6?୷??F?&???r?? ??%-???)!{s?N?WVtok??Exo$<?]qI-?FBQ???J????,??????x?/?W??{?/ҕX???m^r???W?@^??:Ř??V?)??+Y?tJz?b?i?tWy?4+?NV?7?R1
???"ӌ??r???E_??XO6/??e??heY?[?9????Y???7?v?????+??S?%????h? ??6?H???^????<???>?>X ߫t???J?i????s?'?:׏
I}=:0BN?\?D`??35????????s??BWv?U???x????u???̝??a?!?LB *}MLְ??X&t?hDi?ʰ6a&?S3#"??\C??v?0_c??(0?V$?S^
?>/?;??
?5/???%w5;?q:?Ņ??N+`?̓?|3U??l?;?mFY46?I=??n?an???`nk??N}sR
?	???Z2=?? ??R@??Xs?n>Y???@?I??N=?U?????'qH?m??? mo??6U%h?4?k??HT@?*n?^?1????*N@"???va4?c?#?ޱ?s_?Ld>?;?]??}?fg?[A1????"c^ӡ?T??Z????=??)Y?u????;lL7???c?????_??q?H??????S:b?N?ar?O?>]?>?g??i?C?H??0)??:?]?Ի?x?Y??؜.?9?w?Щ?']l(??Sٛ?,??d???Z?į??[??A?X???????̤??}??????%??T?'Rg
?^XZCl?r??P?7????c?????"???6?*N??~?>??QA#??????i?fn??Q8?jS?V??}zh??iS???Ԧ@?.??? \??sԌ ?ëSwh???>\?Lp>?	???too?]??CE[r?T?¿??]?Rz?޾???W???2H???{Һ_??k?\??7*?\?[:_?&L??M?1?d??2t<?!j?\ސD??r?????}L??J?y?gh_?St?0?????`\?Z???|?	??(NH????^???v???٫??$?????i?$qn???]?B9}?
?T?fW^t?lb{?P?.2?b?`5?N?Q($vEG?????X?N]?_a??P?k???+T?J:(?+ց??P?L>U?4?8????fCdL???3?xx?4???b)??I;? ????⮀???r?9L???Vk;??? Tp??x?rr?}???4=???v?5?	???7D?U\*?-\Z?N??bްd???w?i?S??uN |?M?3b@x?/&??Ktil?^?P?^??铂??XɄ ˋ??TA?n?|?97?q?OIKh??2?7Z?F??T?5t?????B5l??K??û
?????їό??뿑?L??????ĹY?K???)	??$??c????җ6=8O'Y?w?50?y?Rc??Z!eJ?.%??4?????i@H???	G?A??x?YE͑?R??nl?Î??~?s????? ?U???w?G:\?????X?S???ˀ????
?3i?%W???8??Y??Ʒ&j}"g?;#7??t?!?#?{??۞?4??|?a???+[?ב?xP.?CR???Rk??????@/7???L???ģ@??yLH?% ?Qbv?0?Cf??'YQ???\?~???2?)I??mp{?Iݖ?????X??aR?7?????q?&!yc(?A??Qۏ?ĩ??(_?:o?V?$???fz5??<?Ȝ?????Z??^Bb??j?X?=???5???V???? ???r]?(??F??Y?ȡ?S@Z???ԟ???p?????_?p438?_??X??=j?-???Δ#????~;s?
*??RQ??_?ˡ?jA0??<?*ʀ1????t?8L?????~?wF?>#???Z?f??Ħ?wR~>??wpO??ѡ]YA??i?Ѫ?{?p?????ú?/?/??N????M?.z6?,g?ڭ6t???-?^??O?*?$?%\??^?????ɩ;??a?]??S?<vǴoX~oN???N?,???4?4???F??ٺ??q?RDVb?~??<???V?ʹ?7}?F??{??~?\b?????A=??Lk???e??7?7?P??LL5?Ni???G???=$%8
?k?tN??NW????ع ?y????.GJ?1??????÷?F?E[??h0???5Ԥ,?6?????g?}?|?i(e??5삭")?`e|<?1????n<^bﲧ/????`??Қp??*?U^?)㊡Ӱml?o?I??E??F?*K??/????S??OY??v?g&?j??O딤?Tz??????????#zn/|2)D?I????? ?:?w?y????1\????$%E???~r?,?5?<?J????K?	??KH?r+e??O??}??H]?h?S????? ???N?R???Ԋ??JZ??:f???Z?8??????׼?????*dVN)??X??&cy?j??1=?K????K".???|o??\qH*???w;???Yl?jo????I????s???C\??h???$p璸??}?????e"?
)<	?4?p,??]???e3{ú?hvjb?&
?X)8??Ww?/?׷͖??N??mQ??V??j?7q????tE`g̝?&??<??6| ??ޟsL????????s4H??????ۛT?
??կ?9?kU?_T-A ???wx^k?쒂2(???-?$X?? Zm}??_????????p???PPfi?O}Mk???k_D{??ӑ????[??xV?[ؿA???V?ԯ?Bi???????:o??d?.
???f?~~??c????(/??O7?uc??*i?p?C?s??F?A??|_ʳ
?????<?????bK???~eB?J???$ߐ?^7?r!'??~??y??????q?=9??}?T[??+??????4??L????j?F?Ъ?`?CIF`%?߀????^?tu?&?s?%?a3yrF/?kk?[{)?=(/?????IKe:??????/???D͙?#???6??G?z??Y???z.?J?w?\?E4??L?????z???,??0T   ???{????"?O2p???S??o??W?????ܫ?\у????ƥ?P?Ӓ??F.v?*???g?W?????><K?t p>9?)?V??.??6j?????t??)v?k|M?N??>???;?GQxl?&?"|S5
4?P>"??v??s?+???J?߉*?qZmENNeA,?4?P?1??+?:??u?????^8???M˯?<ߐ?t}?AT??W5Z1r??֕????7?>?ORTW?ڒ놾?<?nȎ???)C
?????
??g>@????$?!?SU??H?}????ÖV?Z??_??????0??is5(7???i"?Ͽ?@?m???????qѱ~ޜ.??&??;??Ry;??dV???6o?_Z	?;f??j?r???Vʇ2???Ŵ<8??>?AC?O????xsl?j?:??Ј?????s+,Z??~?xp?Fi????ǟt.:?M?q#V????????%B'?b????U??LXw}?'?(>?͛?L7`jA3?kt????????????Ҍ?o      I   ?   x?ʻ
?0 ?ݯ?[??	?:8!??]??Q?? 1)?????`??1?`?;l??՝6L?	9??w?Q?b,??Ks???7=?#??ŲuY=?@??V(Ι?݋u?;fm???t^?Q??xfֺ?VU??$?      A   T  x???Ko?6????/?E?]?a?z
?F7@`??ł?ȑͮ$?????;?퍛??E??C??|?/??_V??b??????????Z???NI??ɸ???7???C?9s?F	e???ХRk߃??58`?a?{??V]??g???~??F?Q??????????{7?dDi?g??*!qRe$xDI$JQIH????!C$?MJ?Y????ۭ???????N??
d?GDB?8J?q?Q?B*`???V??F???ڡ?}o"?????B8??o?? Ǔ??&|?m??*?N?&?D?U3z??D???Q???7G?x?1h????SmG#?u??-?-?T?Zo,??;??e??????$FK??ޙ~???a?ev?+<,?滋??{_?!??T???,3??4%	d??I?!$?,?$?$+?6?????k?q?F??Qx??\/??|r?/?D?f?8 Y?"?U??bb4,yR:|????G???=??#q,=%8??WiL??ľ?$O?P??\?2?w?U??????)??????Zn???k????????FI`Xw	?U?z?
?/?wȼxK?A???I$?Q7???2?!-ˊ??ĜW?????K???0B(?D
m?'4ߏ??Xa۟?C?C????J??E?b??\????'w??o/OWg?Gay5*>?/櫹???????ʉ?/?g??l?X??V?n????a\??&?D?c_??p??Xe???1/P??S??_?O?x?h?aEbW$?	I0?2-?L????7???k^?H?ׯ!?q?q׏??>:???p0?;h??-????U
j??-??????z??n??ɟ???B      \   
   x???          q     x??ԽN?0 ??O?--???8qR&???"і5:?g?&Q????"u`C,?YN?7ܷ?f?_??fwxf??V?{?,??k**??mS?C???u?9?l???EG?]ǜ?ʦ?9s??D?????yMo8??`?O??z???ϝMI???&?	$Z?sZK0?,??????ݎ?J?? s&?UbVJ?1??zZ<?6?C"J??m??t*2L??T,C?')??iy?h?[?Нo6i??q??????yO0?1h?XD>K??????????H??      p   
   x???          n   ?  x?Ւ?n1E???u"???v?1??H(D??vT??Q+=ݣ~(??#?B??!??-W?|??w??????y?N????x??????ڸf=i??p<R?g1??u;"%\????C?ٛ????쬊.x]? ?&?2???H???*a?fU^a??w????a4Mlv?>?????un?Cn???a??N?˵??5?1?7????繓????*z???Ɂ#k?Ӯ6?T?OV????1?y	<?J??	?Z?Ɛ/Q0۾?K??{(>??@o?f??}ƶe?^?? y??`??xD?jn?y??-Q??D#???p??	?=(?|̿ǻ ?Qz?J????=|????:?L4?b??ROcy??ad?N??<.????r.av?P^jp"x0hk%#?s?$??w??W|???@?Qo??#??'????      o   ?   x????j1?{?·M *K?-z?!???B??,˂@?eC???~C?m?M???????-|??ziO??v???|????ֿ?b???K؄ϗ׏?1?7N?%C?@5?P<!D?9??%u?ah86?NP?!???:?sU?2l?W??p*?$!;$7]v*?&*edC-??X????O?Y?B??3??<#?8?J"^?;' E?5?\K$?^E??Y?~ ?7{1      m   ^  x?ŐKO?@??|?=?"??t?<m$4???l?S)?????ӻ?d?y?4??????x???ޑx~???C?-??:?yz?c?'????;???6??O??m3 y??Z?m?M?5?M?]?}????~4[N???G<???*?2-|*?(??A????y?m*??j?+m?5?o\?/g3?ŶlJ?%??ф,0??H?Η?h??3??@????|?!??o7?L???eHY?3**?P?@q??މ?H$w4Xʙ3?fL2Z?Bp?y!B?>??!??Vw!???F???k?"a?D?????|s???3|?7?𕄯u2?\??;+.???y?g ????~K1?!????|?U??      ]   
   x???          a   
   x???          =   \  x???Ko?6????m?.k??)?.?<?C???J???????õ?n?-?Hr????H53~/?޾??]sq???f܆u??m??yѧe'?R?˲َ??x?o`??0????r??2?a=/?(?!?`5??/+|̛??a;E?A???_?a??	????~???.+S?v??j?'誽eS?u?]?8w?~?X??????8$?k>????[?MZ???e?yޅ:??-:??6g?v?0b???????!??????????͋?V?l$?.p"?L?z-???????^-?͂S?	c?ӆ?V?V?_(}?1-????d? A???????ĳ?DM????? ??yֱ??R??e?O?_????*_?o?9?=??x?????i?i?~=C?éK%??L???L?&??!? 2R???8??9???f??ܽ????Wg'???>ǣ?QZ?,"??$G?R"(?$?c?????U?}O5p?o?5??!~?? ?gH3?=?%?PHm???z???j?X??#8???"/G/???H??!qN?SCE???n????{??Z?????X`???3?R"=?$p?)?͓=?:,x????=[ޢ??y?????9?{?7D	?`Q??T񖳖???F????V>??'?Q? i֡??)??x?
,??ѐ?Q???mϖ6j???[?<G 1p?S,&?5s???Lqq?6????VV??9Вs?"/?˙xg"?JrSB??x?O?=[???cY(J?Ҏ?`?#????`?O??????JۯoU?2Sǔ3????
???`n<t????<??ly?<?$? iǁ????<?U????????~???ġ?M?C?po????????????0V?      9   ?  x??X?O?0??W?V?d'm??$Ĥ?v??Ĵ??E?2???}~???M?:????s?{?y???????????[ЬE???t?JJJ&hp??m?|?+à?\??ҵ`Yl?Vey?<~~??q}?N??L?`??E?1?R??(?$F?????毫zU???ٗ????LiE??x?el??f?Th??,(g????ݏ?ۣ?2???
y?	?h?L??e6W?|*?Hs?o{??iY????d?T?O????K2?J?Ft-V?b2?W?T  ??'
??(t7?1B?&*??xݜ7Q˸h??????_6QJ?v??0A???ٖ?V?????⽴??&?d?|Y??`*l????q???֭?R <?f?܋5M???SX??8?U?	?s74?*q?%??b????ɧ?؈X??=8?b"?V%?{?e???{?V%?A??????*?҈~??k?6???S ?1@?/"W??Xy?O??\????F1sf?(?q??c?pA|?x?Y?d!?D1A]d???u?*ԦD_ꀙ?Z?3g??u>=X?μbjH?P????|҇????@ӢB?&\??6????Ɏ?tzCJǞ????y???L?n)tyoo???1^?|????
9?Z??9bU??ҕ4??=3????U?RѦ?o?0O[?Hk?@|Ǭ=/)??֙?f? y????A??ޥ(????????ڕv۩??KB=?u!,K?U????\k k?3kv9k??(?4u?`????{???3r??N[????a??k?ȳ(?]??xHt?&??????Y;u߇?????j???.??9$?͘p????_ñ&?Ÿ?U?	????OD?'GO?#??[e8?6Ҳ?5??O????u[?v??v?q?ψ?ˊ??sF"      <   W  x???MO?0??|
?
Z\ُ??N;p@BL?k??'4Z?D???}??l???Qi????</???????]\?~?"gW??0ٶq??m?p$Ǎψh"?????`wf?	C?cF?????mF????C֭??T??:tq??S
߅&⣛f??^47??k???a?Mݸ4?b?5????˦??8?Od6?*w??(??mџ???ίO/???)rU0*ui???Q????	'5+???,#3` ?s?K??
x?cΘa???Of??e??:?ޖ???'???:Ӧ?`2rq}~??ҳ??}M???~?y?μվ4EAjA?c?j?%-1-?T%?H?c??????
\I ????:?kj??Q?K???\H??????_Ľ????G.kV??,(????v??i?2????`?b??Ff??7qy ??ĭ?w&?P??? I???H??r53fqQ?gD????f5?HW???u?6ݼ7???ԛ??????$$????`7`??)ޥ?\?׿1FXQq^q???if?r3???*?*}?,???????kȩ?X??E?Z?m-S;?+?t%X:?7????E?3J?a?i???_????}t?????      ^   
   x???          J   
   x???          ?   
   x???          E   >  x??VMk\W??W??	XE?J??????`\h?n?t??;???#m(???3?B?]?m?10GG:?H??????as{??????O???I??7?|ڞ?<l?????g???f????ן?>?{?ys??ajc Rn???^c)AG1_?l?????????????ݽ????B#B?k?&P1%??d?Ұ???q??|???l,?(O,??WQ$9??P??ԵO/c,e??Ώ????/????? ???%?t? ?F?JY?????8=???.H?z-5q?????a)?Q%?B??w?????,'?H????B?
?9y|+q
?-??ɾ|G??Gˈ?:?z0`?	?A?X???????0J? %Bhq#O??Z??;??9Y-????0=
A?5w????????&?ʰ?Jf?õ??(C?kHQ?^i???xY????z?4?PkPH?+6???>o?]???9?8:??W???????1??[H?@???9{?i?5????r??ll?>?? ?? ?k?>t7?7?????O????"U???UH?
0?ٴ4??H6%]?/??Z5??E?מ?b?@?N?ك????WQ>?}?z??????}???g??Ϳg.MZ????v?7?h,?(?/\
??W??4V?±B???3w|k^I
}P̡1???Gt?SB???YZT?
Ӄ?ǁ?Ե?k?aP#?n'O?Z ? RX??+A??R?~N???7?????i???P?X	?\?=fJ?>k?n??ΚF???q??2nvqa{?2???\hT???.???J?;???Qc??;y?4??·???????WW? ?7?y      C   1  x?őOk1??~??T??d??I??<b?j?????hUv#?߾???,?vn?????o?XN?Vl?X=?????'?l)?lTǌ??\??q)c?s?:??鍏T?^???R??m?ګ\??fOoc??0_O?l4?Qy#??G??4???, C?N?'??
. ?(7??%׹???WWM?h4`?4?*?`?? *SBmP\s?S??x
{j????9?C)9??D?3?X??].z??
2T?
L?n)???B??????????򲛛???ٟ??ZiG????&???pS8;Q\?_?A?+U??O2?#2??;??f      D   
   x???          B   2  x??SMO?0??+?\Ԥ?N6q??H?Jz?P?uf?E?I?A?B??z??vw?P???~3?<?O?nn/?ߑ???od?^??atނ\9r?۔?8??6ҧ??????k??,e?/?z??M?{>dc??'??f??K???bd?;Ձz?+/#??q??w??ߝ?z?7
??K?????vӰ??+?]7?>?;??`u??胅?????????????x1Q1??<Y?duVS?g|)J???YJf?r?1???Pq???>?)"?1d?7@?Dbo????>??y??_??$Ry??yI?z?I?y?&i'?\?L??7"?????`?e?????9p?5??8/}x?~r??S???^?`>?l??/??ϓ?g????|P}s޶?Wc4_???=?q?^???EJ??vNG???|???
ւQ(?ѝ?g?z??o??6 ??s???޿??QG}?q????D?D^????lz??@?#L)??.x???4x?m??:?B???oq???cgv?????樍g?B??????g??E&Z?????UY????g_NNN? O8u:      `   
   x???          _   
   x???          f   
   x???          i   
   x???          h   
   x???          g   
   x???          j   ^   x???v
Q???W((M??L?+?,I?)???O?.V??N??QH?(?,??Ts?	uV?POI?I-I?/.I,)-?O?OI-V?Q???Ѵ??? ?i$      e   ?  x???Mk1????9k?i4????%?&???k?????????S]????????m?_?~?????w??;?e???????8ֶ{os2???n̴???ݩ}O???????y?H????????ӋyX7,Ab????{!Kf?H?4??ZM??YYD?j@F??? ??sG?*??r?*?]e?׏_V?;?p?Ԩ?????SWa?Sr.jbi???F??????>Q????Vc??Q???%@??6??ᐭ"F[c?@Ļ?~x?0@?7????????????4??{?@¢???^???z?? c??&q0????ǁ??F?}!?m@?*??????
;??:m???KR-`?`???@???:2}??n??^W立L?/??VyE.      ?   
   x???          b   
   x???          d   ?  x????k?P???+tKVy???詇!?&??Ȳ??N+???o??&3?????$?8?????}O??Wg_???????ݼ?n??7S????M??v???aLNv???ܬI7-?m???y?}??Er?????}z??Z$??g??g????0NO??????~??????}?|~??4??????*99]ַ??<??4?M???2KWY??2??yX/????X?U????????????ǣ??I?7@"??H?H????D 	H^C?ȫ??????H?Q?4?kHb?)??%?ʒ??O!?#ի@RDX"?D??BR88$acI	$
I$fGS??????U#?h???%8d7?D]?y5?y5-?.Q?0v-!p̎&p?{?h???Dz
zw???׆$???h??qh?LKJ
zZ ?8ȫ??"p???Cߐql?Kԡ??q4pZ ??!?X?4@?,	@bF#?mG#???rj? A^?Uc?ƴ?]5Z?q?%?}6? pԎ??D?W??&?t¦%?%?%ds??W???xơz5? ??+?q,p0,?`G?L??ѡu?τ?8?GY?¸M?H???rm??$ ?6 E^?%8?~D	?(K?? ?C_??YZ?C?ƪX?mۇ???n]?u??_?wN8?qHt??88Q2??%?%?YfG????{ȫ? ?T?????=?i	{???DG[<??Om??uh?~??Ht???q4p?W????????q?W??K?<p??	???Z ??+v?y?h?mpˍ??lG?hy5-?US???W?淡?b????,?T3?P?????-p??H?%,y?? ??9Kh???>?%?_B?Q????,$?`?KlL????HTK?K??c????<?%,y?Ђ%O?V??شH?x????qլ?!	{?GAo~	?h'??V?S?z'L???H4p0????(?lh$j??-??>?/!	+$\?c?p	$??qǫW2??%?h?.?C??8V?Q?ؘ?($,f9$?BB?j????%H^Br????u??      c   
   x???          ?      x???M??@?y~ři?#?u???!?I??N??????-?|M?k?c?7??a?]?-?z?g/^>????ًW?~???????o?.?߾????{??????nߌ??-??<???||w??????????~z???????????????w????W?\?????????????ۻ???????>????ß?????????Ǉ?{??????_???6l?O??j{???ۓ??q|?v??㸾???_]>????????_/^??o????o=??l?????D'tf:???	?#??Y??ΉN??鄎V??y???	?\:Z?t?r?h???ʥ??KG+??V?Q+?Τ?KG+??V.?\:Z?t?r?h???ʥ??KG+?ά?KG+??V.?\:Z?t?r?h???ʥ??KG+?΢?KG+??V.?\:Z?t?r?h???ʥ??KG+??Q+??V.?\:Z?t?r?h???ʥ??KG+??V?U+??V.?\:Z?t?r?h???ʥ??KG+??V??V.?\:Z?t?r?h???ʥ??KG+??V.?:g?\:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?????E?:Z?t?r?h???ʥ??KG+??V.?\:Z9tF?\:Z?t?r?h???ʥ??KG+??V.?\:Z9t??K?\:Z?t?r?h???ʥ??KG+??V.?:????V.?\:Z?t?r?h???ʥ??KG+???t??KG??,5X:j?t?`????Q????i??ER:v????D?8I???D?8I???D?8I???D?8I??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h???ʥ??C?.???ʥ??KG+??V.?\:Z?t?r?h???ʻ:?`I?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?:6???V.?\:Z?t?r?h???ʥ??KG+??V??V.?\:Z?t?r?h???ʥ??KG+??V?HJ?.???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t????hI?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?:?+???ʩ??KG+??V.?\:Z?t?r?h???ʥ??C?|???ʥ??KG+??V.?\:Z?t?r?h???ʡ?j???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.???3??\:?+??V.?\:Z?t?r?h???ʥ??KG+??	©?KG??,5X:j?t?`????Q????i??Z?t?r?h???ʥ??KG+??V.?\:Z?t?r?ض?:Z?t?r?h???ʥ??KG+??V.?\:Z9tl?H?\:Z?t?r?h???ʥ??KG+??V.?:?m??V.?\:Z?t?r?h???ʥ??KG+??V?6RG+??V.?\:Z?t?r?h???ʥ??KG+??m???KG+??V.?\:Z?t?r?h???ʡ?i?}?y?ʥ??KG+??V.?\:Z?t?r?h???ʥ??CǶ???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h???ʡcI?,v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h???ʥ??C?.???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r蘃Q:?`??V.?\:Z?t?r?h???ʥ??KG+??V?M+??V.?\:Z?t?r?h???ʥ??KG+?[w?:v\??V.?\:Z?t?r?h???ʥ??KG+??V;?SG+??V.?\:Z?t?r?h???ʥ??KG+?mn?\:Z?t?r?h???ʥ??KG+??V.?\7T?????޾??ʥ??KG+??V.?\:Z?t?r?h?б??t?"I?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+???q???KG+??V.?\:Z?t?r?h???ʥ??C?̸??ʥ??KG+??V.?\:Z?t?r?h?б??t??N?\:Z?t?r?h???ʥ??KG+??V??Y?:?V.?\:Z?t?r?h???ʥ??KG+??V???V?M+??V.?\:Z?t?r?h???ʥ??KG+?I?}??q_9u?r?h???ʥ??KG+??V.?\:Z?NZ?n?h???ʥ??KG+??V.?\:Z?t?r?h??13.ߺk???ʥ??KG+??V.?\:Z?t?r?h?z뮕C礕KG+??V.?\:Z?t?r?h???ʥ????G?:?V.?\:Z?t?r?h???ʥ??KG+??V;????V.?\:Z?t?r?h???ʥ??KG+??V???Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+?????+{?RG+??V.?\:Z?t?r?h???ʥ??KG+??o?RG+??V.?\:Z?t?r?h???ʥ??KG+?ά?KG+??V.?\:Z?t?r?h???ʥ??C?.?ұ?$u?r?h???ʥ??KG+??V.?\:Z?t?r??Z?t?r?h???ʥ??KG+??V.?\:Z?t?r??ۗ:Z?t?r?h???ʥ??KG+??V.?\:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+??V??y???	?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??C?|??1_9u?r?h???ʥ??KG+??V.?\:Z?NZ9t??K?\:Z?t?r?h???ʥ??KG+??V???V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h???ʥ??C?.???ʥ??KG+??V.?\:Z?t?r?h??1_9t6??SG+??V.?\:Z?t?r?h???ʥ??KG+???ʩ??KG+??V.?\:Z?t?r?h???ʥ??C?|???ʥ??KG+??V.?\:Z?t?r?h???ʡcf\?h???ʥ??KG+??V.?\:Z?t?r?h??Y?r?h???ʥ??KG+??V.?\:Z?t?r?h?б?/u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?????o?JǷ}???KG+??V.?\:Z?t?r?h????q????t?"I?\:Z?t?r?h???ʥ??KG+??V?H??eI?h???ʥ??KG+??V.?\:Z?t?r?h庡??KG+??V.?\:Z?t?r?h???ʥ??뭻V???Z?t?r?h???ʥ??KG+??V.?\:Z9N?+???ʩ??KG+??V.?\:Z?t?r?h???ʥ??C?|???ʥ??KG+??V.?\:Z?t?r?h???ʡc?r?h???ʥ??KG+??V.?\:Z?t?r?h??9i???ʥ??KG+??V.?\:Z?t?r?h???ʡc?r?h???ʥ??KG+??V.?\:Z?t?r蘯:??ʩ??KG+??V.?\:Z?t?r?h???ʥ??C?|???ʥ??KG+??V.?\:Z?t?r?h???ʡ3i???ʥ??KG+??V.?\:Z?t?r?h??1_?t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?    +??V.?\:Z?t?r?h???ʥ??KG+??V??SG+??V.?\:Z?t?r?h???ʥ??C??Й??H?\:Z?t?r?h???ʥ??KG+??V?I+?ά?KG+??V.?\:Z?t?r?h???ʥ??KG+??o?RG+??V.?\:Z?t?r?h???ʥ??Cǎ?ұ?:u?r?h???ʥ??KG+??V.?\:Z?nsk???ʩ??KG+??V.?\:Z?t?r?h???ʥ??C笕KG+??V.?\:Z?t?r?h???ʥ??KG+ה?\:Z?t?r?h???ʥ??KG+??V.?\SB?r??Z?t?r?h???ʥ??KG+??V.?\:Z?t?rM??ʥ??KG+??V.?\:Z?t?r?h????5%D+??ש??KG+??V.?\:Z?t?r?h????5%D+??o?RG+??V.?\:Z?t?r?h???ʥ??KG+??o?RG+??V.?\:Z?t?r?h???ʥ??KG+??̃V.?\:Z?t?r?h???ʥ??KG+??V.?:?`??V.?\:Z?t?r?h???ʥ??KG+??Vs0RG+??V.?\:Z?t?r?h???ʥ??KG+?ά?KG+??V.?\:Z?t?r?h???ʥ??KG+?΢?KG+??V.?\:Z?t?r?h???ʥ??KG+???ʩ??KG+??V.?\:Z?t?r?h?????:??ʥ??r?h???ʥ??KG+??V.?\:Z?t?r??r??Z?t?r?h???ʥ??KG+??V.?\:Z9tl?K5X:j?t?`????Q???KG??,oN???J'tNN??$Q:N??$Q:N??$Q:N??$Q:Nq???9u?`????Q???KG??,5X:j?Zٛ??q#u?r?h???ʥ??KG+??V.?\:Z9t6???A+??V.?\:Z?t?r?h???ʥ??KG+??V??qZ?t?r?h???ʥ??KG+??V.?\:Z9tl?+??RG+??V.?\:Z?t?r?h???ʥ???u??+???ʩ??KG+??V.?\:Z?t?r?h????u?[+?mn?\:Z?t?r?h???ʥ??KG+??V.?\oݵr???ʥ??KG+??V.?\:Z?t?r?h???ʵ?O+??m???KG+??V.?\:Z?t?r?h????qCeR???KG??,5X:j?t?`????Q????i??Z?t?r?h???ʥ??KG+??V.?\:Z9t??-7rSG+??V.?\:Z?t?r?h???ʥ??KG+?Ϊ?KG+??V.?\:Z?t?r?h???ʥ??KG+????RG+??V.?\:Z?t?r?h???ʥ??KG+??Y+??V.?\:Z?t?r?h???ʥ??KG+?Φ??u?A+??V.?\:Z?t?r?h???ʥ??KG+??V[?SG+??V.?\:Z?t?r?h???ʥ??KG+???ʩ??KG+??V.?\:Z?t?r?h???ʡ3k??Y?r?h???ʥ??KG+??V.?\:Z?t?r踯:'??SG+??V.?\:Z?t?r?h???ʥ??KG+???ʩ??KG+??V.?\:Z?t?r?h???ʡc?r阯?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V??9??Q:?`??V.?\:Z?t?r?h???ʥ??KG+ה?\SB?r?h???ʥ??KG+??V.?\:Z?t?r蜵rM	?ʥ??KG+??V.?\:Z?t?r?h???????V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??;???KG+??V.?\:Z?t?r?h???ʥ??C?޾??ʥ??KG+??V.?\:Z?t?r?h????C?}???ʥ??KG+??V.?\:Z?t?r?h???}?ʡ?j???ʥ??KG+??V.?\:Z?t?r?h???ʡco_?h???ʥ??KG+??V.?\:Z?t?r?h嚨??KG+??V.?\:Z?t?r?h???ʥ??ㆊ;??F?h???ʥ??KG+??V.?\:Z?t?r???ʵ\+??V.?\:Z?t?r?h???ʥ??KG+?p?:v???V.?\:Z?t?r?h???ʥ??KG+??m??KG??,5X:j?t?`????Q????i?,tB??$Q:N??$Q:N??$Q:N??$Q:N??$Q:Z9t|ۗ:Z?t?r?h???ʥ??KG+??V.?\:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+??V?M+??V.?\:Z?t?r?h???ʥ??KG+??V????WN?\:Z?t?r?h???ʥ??KG+??V???3Z9u?r?h???ʥ??KG+??V.?\:Z9t&?:?O??V.?\:Z?t?r?h???ʥ??KG+?댃V?Q+??V.?\:Z?t?r?h???ʥ??KG+?;?Kǎ???ʥ??KG+??V.?\:Z?t?r?h???ʡ?F?h???ʥ??KG+??V.?\:Z?t?r?h??Y?r?h???ʥ??KG+??V.?\:Z?t?r???W:????V.?\:Z?t?r?h???ʥ??KG+??]$9QO+??V.?\:Z?t?r?h???ʥ??KG+?D=?:?`??V.?\:Z?t?r?h???ʥ??KG+??V???Z?t?r?h???ʥ??KG+??V.?\:Z??Ok???m_?h???ʥ??KG+??V.?\:Z?t?r?h??9j???ʥ??KG+??V.?\:Z?t?r?h???ʡ?j???ʥ??KG+??V.?\s?<?C?ۯ??D/O???D/O???D/o?J?ۯ????t?r???ʥ??KG+??V.?\:Z?t?r?h?????????16u?r?h???ʥ??KG+??V.?\:Z?n??'?t??U:??
??Sh?ѝBK?)?t?BK?)?t?BK?)?t?r?h????uF???:㠕KG+??V.?\:Z?t?r?h???ʥ??CǶ??Q???KG??,5X:j?t?`??????4tf?\:Z?t?r?h???ʥ??KG+??V.?:???y????KG+??V.?\:Z?t?r?h???ʥ??CǼ???ʥ??KG+??V.?\:Z?t?r?h???ʡs?ʥ??KG+??V.?\:Z?t?r?h???ʥ??C?T???ʥ??KG+??V.?\:Z?t?r?h??1-t&S?RG+??V.?\:Z?t?r?h???ʥ??KG+?Ψ?KG+??V.?\:Z?t?r?h???ʥ??CǷ}??۾??ʥ??KG+??V.?\:Z?t?r?h??q#tfw0RG+??V.?\:Z?t?r?h???ʥ??C笕Cg?ʥ??KG+??V.?\:Z?t?r?h????uCE+??ש??KG+??V.?\:Z?t?r?h???ʡ3k??Y?r?h???ʥ??KG+??V.?\:Z?t?r?h???Q+??V.?\:Z?t?r?h???ʥ??KG+??\:Z9u?r?h???ʥ??KG+??V.?\:Z9t??.;?SG+??V.?\:Z?t?r?h???ʥ??KG+ה?\:Z?t?r?h???ʥ??KG+??V.?\SB????b?r?h???ʥ??KG+??V.?\:Z?t?rM	??5%D+??V.?\:Z?t?r?h???ʥ??KG+?VC?:?+??V.?\:Z?t?r?h???ʥ??KG+??V??SG+??V.?\:Z?t?r?h???ʥ??KG+??ש??KG+??V.?\:Z?t?r?h?????m?ץc?u?h???ʥ??KG+??V.?\:Z?t?r?h???m_?h???ʥ??KG+??V.?\:Z?t?r?h??j??KG+??V.?\:Z?t?r?h???ʥ??c??;??F?h???ʥ??KG+??V.?\:Z?t?r?h??q#u?r?h???ʥ??KG+??V.?\:Z9t?:G?\:Z?t?r?h???ʥ??KG+??V.?\:Z9tV?\:Z?t?r?h???ʥ??KG+??V.???st_?t?WN?\:Z?t?r?h???ʥ??KG+??Vw0J????ʥ??KG+??V.?\:Z?t?r?h??ٴ???:h???ʥ??KG+??V.?\:Z?t?r?h???ʡ3j???ʥ??KG+??V.?\:Z?t?r?h??13?ťK?\:Z?t?r?h???ʥ??KG+??V??K?}???ʥ??KG+??V.?\:Z?t?r?h???ʡcf\?h???ʥ??KG+??V.?\:Z?t?r?h??9i???ʥ??KG+??V.?\:Z?t?r?h??1#tN?`??V.?\S???	g???s?t??)g??qF/g??qF/g??qF??V?M+??V.?\:Z?t?r?h???ʥ??KG+??V????}V?h???ʥ??KG+??V 	  .?\:Z?t?r?h??1?=u?r?h???ʥ??KG+??V.?\:Z9t?u/s?SG+??V.?\:Z?t?r?h???ʥ??KG+?΢?KG+??V.?\:Z?t?r?h???ʥ??C?\??1?=u?r?h???ʥ??KG+??V.?\:Z?t?r???:Z?t?r?h???ʥ??KG+??V.?\:Z9t?Z?t?r?h???ʥ??KG+??V.?\:Z9v ??\:?+??V.?\:Z?t?r?h???ʥ??KG+?6U?:?+??V.?\:Z?t?r?h???ʥ??KG+?p?:?+??V.?\:Z?t?r?h???ʥ??KG+W+{f??gV?xf??gV?xf??gV=ѽ?	??????~?t??)?\:Z?t?r?h???ʥ??Cǜ??1?4u?r?h???ʥ??KG+??V.?\:Z?t?r??s?:Z?t?r?h???ʥ??KG+??V.?\oݵr??Z?t?r?h???ʥ??KG+??V.?\:Z?t?r??s?:Z?t?r?h???ʥ??KG+??V.?\:Z?nsk???ʥ??KG+??V.?\:Z?t?r?h庡??C?N???ʥ??KG+??V.?\:Z?t?r?h???ʡ?i???ʥ??KG+??V.?\:Z?t?r?h?}???Y?cV?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r???:Z?t?r?h???ʥ??KG+??V.?\:Z9ťK?\:Z?t?r?h???ʥ??KG+??V.?:fƥ?V.?\:Z?t?r?h???ʥ??KG+??V?U+??V.?\:Z?t?r?h???ʥ??KG+??V??V.?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??l?V.?\:Z?t?r?h???ʥ??KG+??V.?:????V.?\:Z?t?r?h???ʥ??KG+???ʥc?r?h???ʥ??KG+??V.?\:Z?t????4??W:????V.?\:Z?t?r?h???ʥ??KG+??V??SG+??V.?\:Z?t?r?h???ʥ??KG+???}???KG+??8?wBg?s?t??)?wJ??t??K??t??K??t??KG+?W$Z?t?r?h???ʥ??KG+??V.?\:Z??"?ʡ??g??V.?\:Z?t?r?h???ʥ??KG+?w0??k?\:Z?t?r?h???ʥ??KG+??V.?:????}????KG+??V.?\:Z?t?r?h???ʥ???uF?BSG+??V.?\:Z?t?r?h???ʥ??놊V?U+??V.?\:Z?t?r?h???ʥ??KG+??V??V.?\:Z?t?r?h???ʥ??KG+??V.?:g?\:Z?t?r?h???ʥ??KG+??V.?:?^K5X:j?t?`????Q???KG??,oN?۾?NM?s?('??q?('??q?('??q?('??q???Z9t|ۗ:Z?t?r?h???ʥ??KG+??V.?\SB?r?x??:Z?t?r?h???ʥ??KG+??V.?:6ӥ?,5X:j?t?`????Q???KG??7?u??t<?K??t<?K??t<?C???????W?x?U:?~??V.?\:Z?t?r?h??????k?ʡ?h???ʥ??KG+??V.?\:Z?t?r?h???ʡs?ʥ??KG+??V.?\:Z?t?r?h???ʥ??C?????ʥ??KG+??V.?\:Z?t?r?h???ʡs?ʥ??KG+??V.?\:Z?t?r?h???ʥ??CǷ}???KG+??V.?\:Z?t?r?h???ʡco?L?V.?\:Z?t?r?h???ʥ??KG+??V.?:?g??V.?\:Z?t?r?h???ʥ??KG+??V??RG+??V.?\:Z?t?r?h???ʥ??KG+?ά?KG+??V.?\:Z?t?r?h???ʥ??CǷ}??۾??ʥ??KG+??V.?\:Z?t?r?h?}??{???^9u?r?h???ʥ??KG+??V.?\:Z9t?W.??SG+??V.?\:Z?t?r?h???ʥ??놊V?E+??V.?\:Z?t?r?h???ʥ??KG+??ץc?u?h???ʥ??KG+??V.?\:Z?t?r?h???Q+??V.?\:Z?t?r?h???ʥ??KG+ח?Z9t6?\:Z?t?r?h???ʥ??KG+??V.?\:Z9???q?:Z?t?r?h???ʥ??KG+??V.?\:Z9t??N?\:Z?t?r?h???ʥ??KG+??V??zZ9t??H?\:Z?t?r?h???ʥ??KG+??Vs0J????ʥ??KG+??V.?\:Z?t?r?h?z뮕k??V.?\:Z?t?r?h???ʥ??KG+??V???V???Z?t?r?h???ʥ??KG+??V.?\:???=?¶Y      ?      x???MkU??}Ż?B*3?????E?R??nK??VM"?|??Ņ??^ ??pA??gr?y??x???W?g/^}????????o~???|????????뫏?ݾ????x??i???????ܼ??]?]?????t???????????????>????????????g?]?z}{?????x??????>>|???O~????~?????/w_5]?W۴]??ﯶ'?eݞ?=??'o??j>??w???W?O_?a?.v?_??x?????:?????>z????&:?3?	?=??9?	?#??9?	?3??Y???J't??X??k?:Z?t?r?h???ʥ??KG+??V.?\:Z9tf?\:Z?t?r?h???ʥ??KG+??V.?\:Z9t?Z?t?r?h???ʥ??KG+??V.?\:Z9tZ9t?Z?t?r?h???ʥ??KG+??V.?\:Z?t?r蜴r?h???ʥ??KG+??V.?\:Z?t?r?h??9k???ʥ??KG+??V.?\:Z?t?r?h???ʡ?h???ʥ??KG+??V.?\:Z?t?r?h???ʡ?j???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t??X?d?r阯?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?\:Z?t?r?h???ʥ??KG+??V.?:?m??,5X:j?t?`????Q???KG??'??c?r阯?:N??$Q:N??$Q:N??$Q:N??$Q:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+?Φ??:?I+??V.?\:Z?t?r?h???ʥ??KG+??V??SG+??V.?\:Z?t?r?h???ʥ??KG+???ʩ??KG+??V.?\:Z?t?r?h???ʥ??C?|???ʥ??KG+??V.?\:Z?t?r?h???ʡc?t?h???ʥ??KG+??V.?\:Z?t?r?h??9i???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?\:Z9t6?\:Z?t?r?h???ʥ??KG+??V.?\:Zy???ۗ:Z?t?r?h???ʥ??KG+??V.?\:Z9t??K?\:Z?t?r?h???ʥ??KG+??V.?:????V.?\:Z?t?r?h???ʥ??KG+??V{?RG+??V.?\:Z?t?r?h???ʥ??KG+???}???KG+??V.?\:Z?t?r?h???ʥ??C?޾??ʥ??KG+??V.?\:Z?t?r?h?б??t?"I?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+?uV?HRG+??V.?\:Z?t?r?h???ʥ??C?|??1_9u?r?h???ʥ??KG+??V.?\:Z?t?r蘯?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+??V??V.?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h????c?????Xg?ʥ??KG+??V.?\:Z?t?r?h???ʡc?F????Q???KG??,5X:j?t?`?xr:?m??V.?\:Z?t?r?h???ʥ??KG+??V?6RG+??V.?\:Z?t?r?h???ʥ??KG+??m???KG+??V.?\:Z?t?r?h???ʥ??CǶ???ʥ??KG+??V.?\:Z?t?r?h??1A?tLN?\:Z?t?r?h???ʥ??KG+??V.?:&??V.?\:Z?t?r?h???ʥ??KG+??V??I+??V.?\:Z?t?r?h???ʥ??KG+?ά?C?|???ʥ??KG+??V.?\:Z?t?r?h???ʡc?r?h???ʥ??KG+??V.?\:Z?t?r=u????]+??V.?\:Z?t?r?h???ʥ??KG+?IB+??]$???KG+??V.?\:Z?t?r?h???ʥ??C?.???ʥ??KG+??V.?\:Z?t?r?h??9k??Y?r?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?\:Zy?3?E?:Z?t?r?h???ʥ??KG+??V.?\:Z9ťK?\:Z?t?r?h???ʥ??KG+??V?HJ?.???ʥ??KG+??V.?\:Z?t?r?h???ʡc?r?h???ʥ??KG+??V.?\:Z?t?r蘃Q:?`??V.?\:Z?t?r?h???ʥ??KG+??Vs0RG+??V.?\:Z?t?r?h???ʥ??멻V{?RG+??V.?\:Z?t?r?h???ʥ??KG+??Y+??V.?\:Z?t?r?h???ʥ??KG+??V???Z?t?r?h???ʥ??KG+??V.?\:Z?n?h????.???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r?h???k???ʥ??KG+??V.?\:Z?t?r?h???ʡco_?h???ʥ??KG+??V.?\:Z?t?r??W:fƥ?V.?\:Z?t?r?h???ʥ??KG+??V3?RG+??V.?\:Z?t?r?h???ʥ??KG+???q???KG+??V.?\:Z?t?r?h???ʥ??Cg?ʥ??KG+??V.?\:Z?t?r?h???ʥ??Cg?ʥ??KG+??V.?\:Z?t?r?h????c???ʥc?r?h???ʥ??KG+??V.?\:Z?t?r??W:fƥ?V.?\:Z?t?r?h???ʥ??KG+???q?cf\?h???ʥ??KG+??V.?\:Z?t?r?x??t?ۗ:Z?t?r?h???ʥ??KG+??V.?\:Z9t?ۗ:Z?t?r?h???ʥ??KG+??V.?\???r???ʥ??KG+??V.?\:Z?t?r?h????uCE+???}???KG+??V.?\:Z?t?r?h???ʥ???6?V.?\:Z?t?r?h???ʥ??KG+??V?*Zy?????	?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??]$?cI?h???ʥ??KG+??V.?\:Z?t?r?h??9j???ʥ??KG+??V.?\:Z?t?r?h???ʡco_?h???ʥ??KG+??V.?\:Z?t?r?h??13.u?r?h???ʥ??KG+??V.?\:Z?t?r???:Z?t?r?h???ʥ??KG+??V.?:v\??ש??KG+??V.?\:Z?t?r?h???ʥ???:'??SG+??V.?\:Z?t?r?h???ʥ??KG+???ʩ??KG+??V.?\:Z?t?r?h???ʡc?r阯?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?WN?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+??\7T?r?h???ʥ??KG+??V.?\:Z?t?r?$?r??E?:Z?t?r?h???ʥ??KG+??V.?:?V?U+??V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+?u?v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??9???KG+??V.?\:Z?t?r?h???ʡcI??E?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?:?+??V.?\:Z?t?r?h???ʥ??KG+??V?E+??V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h???ʥ???:?]$???KG+??V.?\:Z?t?r?h???ʡc?r阯?:Z?t?r?h???ʥ??KG+??V.?\:Z9tZ?t?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:    Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??V?HRG+??V.?\:Z?t?r?h???ʥ??KG+??]$???KG+??V.?\:Z?t?r?h???ʥ??C?.???ʥ??KG+??V.?\:Z?t?r?h???:i?Й?r?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??E?:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?:v???V.?\:Z?t?r?h???ʥ??KG+??9?cF?h???ʥ??KG+??V.?\:Z?t??Xg3?t??H?\:Z?t?r?h???ʥ??KG+??V.?:?`??V.?\:Z?t?r?h???ʥ??KG+??Vs0RG+??V.?\:Z?t?r?h???ʥ??KG+??9???KG+??V.?\:Z?t?r?h???ʡ????Q???KG??,5X:j?t?`??????4?|<?	??I?t?$J?I?t?$J?I?t?$J?I?t?$J?I?t?rM??ʥ??KG+??V.?\:Z?t?r?h???????s???\9u?r?h???ʥ??KG+??V.?\:Z?nsk?б?/u?r?h???ʥ??KG+??V.?\:Z?t?r=u?ʥ??KG+??V.?\:Z?t?r?h???ʡ?i???×??KG+??V.?\:Z?t?r?h???ʥ??KG+??ש??KG+??V.?\:Z?t?r?h???ʥ??Cǎ???ʥ??KG+??V.?\:Z?t?r?h???ʡc?u?h???ʥ??KG+??V.?\:Z?t?r?h?б?:u?r?h???ʥ??KG+??V.?\:Z?t?r???:Z?t?r?h???ʥ??KG+??V.?\:Z9ťK?\:Z?t?r?h???ʥ??KG+??V.?:????V.?\:Z?t?r?h???ʥ??KG+?Ϊ?Cg?ʥ??KG+??V.?\:Z?t?r?h???ʥ???:?]$???KG+??V.?\:Z?t?r?h???ʥ??C?.???ʥ??KG+??V.?\:Z?t?r?h???ʡcI?h???ʥ??KG+??V.?\:Z?t?r蘃Q:?`??V.?\:Z?t?r?h???ʥ??KG+??w?Jǻ}???KG+??V.?\:Z?t?r?h????c????RG??,5X:j?t?`????Q???KǓ??q_?t?WN'??q?('??q?('??q?('??q????Z9tZ?t?r?h???ʥ??KG+??V.?\:Z?t?r??r?h???ʥ??KG+??V.?\:Z?t?r?h????KG+??V.?\:Z?t?r?h???ʥ??Cg??5%D+??V.?\:Z?t?r?h???ʥ??KG+?mn?:?+??V.?\:Z?t?r?h???ʥ??KG+??V??SG+??V.?\:Z?t?r?h???ʥ??C?޾ұ?/u?r?h???ʥ??KG+??V.?\:Z?t?r?,Z?t?r?h???ʥ??KG+??V.?\:Z?t?r?x?/u?r?h???ʥ??KG+??V.?\:Z?t?r?lZ?t?r?h???ʥ??KG+??V.?\:Z?t??X?0i???ʥ??KG+??V.?\:Z?t?r?h??13?ťK?\:Z?t?r?h???ʥ??KG+??V{?J?޾??ʥ??KG+??V.?\:Z?t?r?h???n_?x?/u?r?h???ʥ??KG+??V.?\:Z?t?r?x?/u?r?h???ʥ??KG+??V.?\:Z?t??X??ݾ??ʥ??KG+??V.?\:Z?t?r?h???ʡ3k???ʥ??KG+??V.?\:Z?t?r?h??1?t??H?\:Z?t?r?h???ʥ??KG+??V??V??V.?\:Z?t?r?h???ʥ??KG+??V.?:?V.?\:Z9ޓ?}ߩ????;???N?8???3z?8???3z?8???3zM??ʡ??Y???KG+??V.?\:Z?t?r?h???ʥ??k??V.?\:Z?t?r?h???ʥ??KG+??V?7??r?q??KG+??V.?\:Z?t?r?h???ʥ??C稕??k?\:Z?t?r?h???ʥ??KG+??V.?<?9??^:溧?V.?\:Z?t?r?h???ʥ??KG+?????c?{?h???ʥ??KG+??V.?\:Z?t?rM???U:>?J?gV???*?Y??3?t<?	??????|?t<?)?\:Z?t?r?h???ʥ??KG+?Φ?KG+??V.?\:Z?t?r?h???ʥ??KG+?HZ?t?r?h???ʥ??KG+??V.?\:Z9t?j?t?`????Q???KG??,5X:j?t<9?<SG+??V.?\:Z?t?r?h???ʥ??KG+??]??c?l?8I???D?8I???D?8I???D?8I???D?h??1#u?r?h???ʥ??KG+??V.?\:Z?t?r蘃?:Z?t?r?h???ʥ??KG+??V.?\:Zy?s6#u?r?h???ʥ??KG+??V.?\:Z?t?r??Z?t?r?h???ʥ??KG+??V.?\:Zy???Z9t?Z?t?r?h???ʥ??KG+??V.?\:Z?t?r??r?h???ʥ??KG+??V.?\:Z?t?r=u?ʡ??r?h???ʥ??KG+??V.?\:Z?t?r???R:6???V.?\:Z?t?r?h???ʥ??KG+???ʥc?r?h???ʥ??KG+??V.?\:Z?t?r?h??1_9u?r?h???ʥ??KG+??V.?\:Z?t??Xg1_9u?r?h???ʥ??KG+??V.?\:Z9tZ9t?Z?t?r?h???ʥ??KG+??V.?\:Z?t?r?x?/u?r?h???ʥ??KG+??V.?\:Z?t?r蜵r?h???ʥ??KG+??V.?\:Z?t?rM??ʡcI?h???ʥ??KG+??V.?\:Z?t?r?h??>??KG+??V.?\:Z?t?r?h???ʥ??멻V?E+??V.?\:Z?t?r?h???ʥ??KG+צ?:?+??V.?\:Z?t?r?h???ʥ??KG+?D=?:?V.?\:Z?t?r?h???ʥ??KG+??V????i?\:Z?t?r?h???ʥ??KG+??V.?\7T?r??Z?t?r?h???ʥ??KG+??V.?\:Z9t???Վ???ʥ??KG+??V.?\:Z?t?r?h???ʡ??r?h???ʥ??KG+??V.?\:Z?t?r蘯\:?+??V.?\:Z?t?r?h???ʥ??KG+???q?cf\?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r蘃?:Z?t?r?h???ʥ??KG+??V.?<??V?:?V.?\:Z?t?r?h???ʥ??KG+??V??&????w?RG+??V.?\:Z?t?r?h???ʥ??C?}??q_9u?r?h???ʥ??KG+??V.?\:Zy?3???:j?t?`????Q???KG??,5X:?????ʥ??r?8I???D?8I???D?8I???D?8I???D?h??1#u?r?h???ʥ??KG+??V.?\:Z???h??1#u?r?h???ʥ??KG+??V.?\:Z?t?r?P??r?h???ʥ??KG+??V.?\:Z?t?r?h?Й?r?h???ʥ??KG+??V.?\:Z?t?r???r???:Z?t?r?h???ʥ??KG+??V.?\:Z9t?"I?\:Z?t?r?h???ʥ??KG+??V.?:'?\:Z?t?r?h???ʥ??KG+??V.?\:Z9t?Z?t?r?h???ʥ??KG+??V.?\:Z9t?W.??SG+??V.?\:Z?t?r?h???ʥ??C?̸ڏnf\?h???ʥ??KG+??V.?\:Z?t?r?h??13.u?r?h???ʥ??KG+??V.?\:Z9t??W:??K?\:Z?t?r?h???ʥ??KG+??V??{5X:j?t?`????Q???KG??,5X:?????ʥ??r?8I???D?8I???D?8I???D?8I???D??Z9t6?\:Z?t?r?h???ʥ??KG+??V.?\???r踡?:Z?t?r?h???ʥ??KG+??V.?:?+???ʩ??KG+??V.?\:Z?t?r?h????uCE+???}???KG+??V.?\:Z?t?r?h??????]+??A+??V.?\:Z?t?r?h???ʥ??KG+?Sw?:??K?\:Z?t?r?h???ʥ??KG+??V.?????:u?r?h???ʥ??KG+??V.?\:Z?t?r??q?:Z?t?r?h???ʥ??KG+??V.?\???Xg??r?h???ʥ??KG+??V.?\:Z?t?r?xr? {  :j?t?`????Q???KG??,5X:????9?cF?8I???D?8I???D?8I???D?8I???D?h??9j???ʥ??KG+??V.?\:Z?t?r?h???ʡs?ʥ??KG+??V.?\:Z?t?r?h???ʥ??C?޾??ʥ??KG+??V.?\:Z?t?r?h???ʡ?h???ʥ??KG+??V.?\:Z?t?r?h???a?ʡ?j???ʥ??KG+??V.?\:Z?t?r?h????.??1Q/u?r?h???ʥ??KG+??V.?\:Z9tV?:?V.?\:Z?t?r?h???ʥ??KG+??V?*Z9t??H?\:Z?t?r?h???ʥ??KG+??V;????ש??KG+??V.?\:Z?t?r?h???ʥ??C?}???ʥ??KG+??V.?\:Z?t?r?h?б??t??K?\:Z?t?r?h???ʥ??KG+??V.?:????V.?\:Z?t?r?h???ʥ??KG+??V{?RG+??V.?\:Z?t?r?h???ʥ??KG+צ?\:Z?t?r?h???ʥ??KG+??V.?:?`???\:Z?t?r?h???ʥ??KG+??V.?:{?:?\:Z?t?r?h???ʥ??KG+??V.?:??+????V.?\:Z?t?r?h????=t?>?K?'z??D/?????t|????_???W?x?U:Z?f?j???ʥ??KG+??V.?\:Z?t?r?h??9?V???k???ʥ??KG+??V.?\:Z?t?r?h庡??C????ʥ??KG+??V.?\:Z?t?r?h???ʡc
l?h???ʥ??KG+??V.?\:Z?t?r?h??Y?r?h???ʥ??KG+??V.?\:Z?t??X?dF阃?:Z?t?r?h???ʥ??KG+??V.?\:Z9t??H?\:Z?t?r?h???ʥ??KG+??VJ?Ƅ??ʥ??KG+??V.?\:Z?t?r?h嚃?oV???U:?f????)??~9???Sh?8???Sh?8???Sh?h???ʥ????YZ?~???KG+??V.?\:Z?t?r?h???ʥ????YZ9tL.O?\:Z?t?r?h???ʥ??KG+??V.?:&???V.?\:Z?t?r?h???ʥ??KG+??V??SG+??V.?\:Z?t?r?h???ʥ??Cg??c????KG+??V.?\:Z?t?r?h???ʥ??KG+??9???KG+??V.?\:Z?t?r?h???ʥ??C?F???ʥ??KG+??V.?\:Z?t?r?h???ʡc#f?h???ʥ??KG+??V.?\:Z?t?r?h??1_9u?r?h???ʥ??KG+??V.?\:Z9t?W.??SG+??V.?\:Z?t?r?h???ʥ??C?̸?13.u?r?h???ʥ??KG+??V.?\:Zy????Q:?`??V.?\:Z?t?r?h???ʥ??KG+??;??F?h???ʥ??KG+??V.?\:Z?t?r?h?б?:u?r?h???ʥ??KG+??V.?\:Z9tV?:?V.?\:Z?t?r?h???ʥ??KG+??V??v???]$???KG+??V.?\:Z?t?r?h???ʡ?ݾ??n_?h???ʥ??KG+??V.?\:Z?t?rM???5QO+??V.?\:Z?t?r?h???ʥ??KG+?Ib??uCE+??V.?\:Z?t?r?h???ʥ??KG+???q?cf\?h???ʥ??KG+??V.?\:Z?t?r?h??q#u?r?h???ʥ??KG+??V.?\:Z??j??13.u?r?h???ʥ??KG+??V.?\:Z?t?r???r?h???ʥ??KG+??V.?\:Z?t?r?h???n_?h???ʥ??KG+??V.?\:Z?t?r?h?б?$u?r?h???ʥ??KG+??V.?\:Z?t?r??r?h???ʥ??KG+??V.?\:Z?t?r?,Z9tV?\:Z?t?r?h???ʥ??KG+??V.?:???M-Z?t?r?h???ʥ??KG+??V.?\:Z9t??(w0RG+??V.?\:Z?t?r?h???ʥ??[?ѣ?????      ?     x????J?0?{?bn???m?<y?C?Tpw???,?v5???V?-???d?|?????#?????????G?u?絟vkơuM"?Br?a;??m??????y?.?k??s??TK?????޻}???????ڏ??ݹ??????? ۍ5y&?H?LY???R?ǦHt????:?0?̞+?28??TU?v?s??????d??I犎 D''DG??S??sK:??"??t?g'D'!D'%D??2?CYӡ???PV?t(+c:??1??g?(?׬#D      k   .  x???Ko?0????&??V??UYD??R?t??????)?V??(m&#??]Bv??Y?????????fw?)9??,???u???SNUWt????Z?????=m???8=zv?ð?W????XP?J_,????????ۇ???r?	?E???L?	d??1?U6?Jo??&Pľ즡?Ne?GAh??0$`???B?"?X?8?yS?Ԏ?"??^}??Y%?q/'/z?????$DR?80o?"?(??e<???k???]-?s?`??px?|$ e$BDp??QL?u.F??efiW???2m?c??T?h?l?@??7J??t?57??(}K͉qfiW???q??k?r??????g??X O??*???,????Y?-S?;_?Y??2:?e??TĤW?@i?????????j???ȝ%]+?1e???????mW???8????p@o??!|??s?????Re?n?Ӈ?M?9?U?Yn??;?????X???D?\???j?0)?䌜???4???Ǿ????¸K,Od?k?p?-O..~/??g      l   ?   x????j?0?{?·??????N;????ƱE?5??-???릅?????CR??o???>???`??j?98?@??'?l| ?????<c?TdnZ?????vO?????Һ?Z7ꥩ?^s`l?[??--+R?^*?? !U??[?e!?!??E?,F?js?xq??4ʎ!^2:??E ??!?a?DB??@9dCsC<???ir?DЃ?d??????M????D      G   ?   x?=ɽ?0?ᝫ8?i+?'????)?`??!޾??|y??I????????V][????L??x?`0=P?}?òaF??}??=.fOCӾ|x\?2??sm??6R??D?DY?D?RLͥ?n ??Ƭݲ1+?t;8??0F?*???8;P?????q~?2?      ?   ?   x?]?1o?0???
o5?'?&??J?Z/?X8&?v+?}?ԉ?????n?~?n?$c??Q??^?<A07?e?G2CLx??? ????Dg?eo?j?`??6>??j	aN?7??????Q?E>c?F??? 9?ˊ1??Z4??m?T5}??Jh\?ԋ???????????`\??qN˒?+??X?\?1???Y???lP?     