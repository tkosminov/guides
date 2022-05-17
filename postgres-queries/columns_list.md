# Список колонок некоторых служебных таблиц для PostgreSQL 13

## pg_stat_statements

```sql
 table_schema |     table_name     |     column_name     |    data_type     | is_nullable | column_default 
--------------+--------------------+---------------------+------------------+-------------+----------------
 public       | pg_stat_statements | blk_read_time       | double precision | YES         | 
 public       | pg_stat_statements | blk_write_time      | double precision | YES         | 
 public       | pg_stat_statements | calls               | bigint           | YES         | 
 public       | pg_stat_statements | dbid                | oid              | YES         | 
 public       | pg_stat_statements | local_blks_dirtied  | bigint           | YES         | 
 public       | pg_stat_statements | local_blks_hit      | bigint           | YES         | 
 public       | pg_stat_statements | local_blks_read     | bigint           | YES         | 
 public       | pg_stat_statements | local_blks_written  | bigint           | YES         | 
 public       | pg_stat_statements | max_exec_time       | double precision | YES         | 
 public       | pg_stat_statements | max_plan_time       | double precision | YES         | 
 public       | pg_stat_statements | mean_exec_time      | double precision | YES         | 
 public       | pg_stat_statements | mean_plan_time      | double precision | YES         | 
 public       | pg_stat_statements | min_exec_time       | double precision | YES         | 
 public       | pg_stat_statements | min_plan_time       | double precision | YES         | 
 public       | pg_stat_statements | plans               | bigint           | YES         | 
 public       | pg_stat_statements | query               | text             | YES         | 
 public       | pg_stat_statements | queryid             | bigint           | YES         | 
 public       | pg_stat_statements | rows                | bigint           | YES         | 
 public       | pg_stat_statements | shared_blks_dirtied | bigint           | YES         | 
 public       | pg_stat_statements | shared_blks_hit     | bigint           | YES         | 
 public       | pg_stat_statements | shared_blks_read    | bigint           | YES         | 
 public       | pg_stat_statements | shared_blks_written | bigint           | YES         | 
 public       | pg_stat_statements | stddev_exec_time    | double precision | YES         | 
 public       | pg_stat_statements | stddev_plan_time    | double precision | YES         | 
 public       | pg_stat_statements | temp_blks_read      | bigint           | YES         | 
 public       | pg_stat_statements | temp_blks_written   | bigint           | YES         | 
 public       | pg_stat_statements | total_exec_time     | double precision | YES         | 
 public       | pg_stat_statements | total_plan_time     | double precision | YES         | 
 public       | pg_stat_statements | userid              | oid              | YES         | 
 public       | pg_stat_statements | wal_bytes           | numeric          | YES         | 
 public       | pg_stat_statements | wal_fpi             | bigint           | YES         | 
 public       | pg_stat_statements | wal_records         | bigint           | YES         | 
```

## pg_roles

```sql
 table_schema | table_name |  column_name   |        data_type         | is_nullable | column_default 
--------------+------------+----------------+--------------------------+-------------+----------------
 pg_catalog   | pg_roles   | oid            | oid                      | YES         | 
 pg_catalog   | pg_roles   | rolbypassrls   | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolcanlogin    | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolconfig      | ARRAY                    | YES         | 
 pg_catalog   | pg_roles   | rolconnlimit   | integer                  | YES         | 
 pg_catalog   | pg_roles   | rolcreatedb    | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolcreaterole  | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolinherit     | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolname        | name                     | YES         | 
 pg_catalog   | pg_roles   | rolpassword    | text                     | YES         | 
 pg_catalog   | pg_roles   | rolreplication | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolsuper       | boolean                  | YES         | 
 pg_catalog   | pg_roles   | rolvaliduntil  | timestamp with time zone | YES         | 
```

## pg_database

```sql
 table_schema | table_name  |  column_name  | data_type | is_nullable | column_default 
--------------+-------------+---------------+-----------+-------------+----------------
 pg_catalog   | pg_database | datacl        | ARRAY     | YES         | 
 pg_catalog   | pg_database | datallowconn  | boolean   | NO          | 
 pg_catalog   | pg_database | datcollate    | name      | NO          | 
 pg_catalog   | pg_database | datconnlimit  | integer   | NO          | 
 pg_catalog   | pg_database | datctype      | name      | NO          | 
 pg_catalog   | pg_database | datdba        | oid       | NO          | 
 pg_catalog   | pg_database | datfrozenxid  | xid       | NO          | 
 pg_catalog   | pg_database | datistemplate | boolean   | NO          | 
 pg_catalog   | pg_database | datlastsysoid | oid       | NO          | 
 pg_catalog   | pg_database | datminmxid    | xid       | NO          | 
 pg_catalog   | pg_database | datname       | name      | NO          | 
 pg_catalog   | pg_database | dattablespace | oid       | NO          | 
 pg_catalog   | pg_database | encoding      | integer   | NO          | 
 pg_catalog   | pg_database | oid           | oid       | NO          | 
```

## pg_indexes

```sql
 table_schema | table_name | column_name | data_type | is_nullable | column_default 
--------------+------------+-------------+-----------+-------------+----------------
 pg_catalog   | pg_indexes | indexdef    | text      | YES         | 
 pg_catalog   | pg_indexes | indexname   | name      | YES         | 
 pg_catalog   | pg_indexes | schemaname  | name      | YES         | 
 pg_catalog   | pg_indexes | tablename   | name      | YES         | 
 pg_catalog   | pg_indexes | tablespace  | name      | YES         | 
```

## pg_constraint

```sql
 table_schema |  table_name   |  column_name  |  data_type   | is_nullable | column_default 
--------------+---------------+---------------+--------------+-------------+----------------
 pg_catalog   | pg_constraint | conbin        | pg_node_tree | YES         | 
 pg_catalog   | pg_constraint | condeferrable | boolean      | NO          | 
 pg_catalog   | pg_constraint | condeferred   | boolean      | NO          | 
 pg_catalog   | pg_constraint | conexclop     | ARRAY        | YES         | 
 pg_catalog   | pg_constraint | confdeltype   | "char"       | NO          | 
 pg_catalog   | pg_constraint | conffeqop     | ARRAY        | YES         | 
 pg_catalog   | pg_constraint | confkey       | ARRAY        | YES         | 
 pg_catalog   | pg_constraint | confmatchtype | "char"       | NO          | 
 pg_catalog   | pg_constraint | confrelid     | oid          | NO          | 
 pg_catalog   | pg_constraint | confupdtype   | "char"       | NO          | 
 pg_catalog   | pg_constraint | conindid      | oid          | NO          | 
 pg_catalog   | pg_constraint | coninhcount   | integer      | NO          | 
 pg_catalog   | pg_constraint | conislocal    | boolean      | NO          | 
 pg_catalog   | pg_constraint | conkey        | ARRAY        | YES         | 
 pg_catalog   | pg_constraint | conname       | name         | NO          | 
 pg_catalog   | pg_constraint | connamespace  | oid          | NO          | 
 pg_catalog   | pg_constraint | connoinherit  | boolean      | NO          | 
 pg_catalog   | pg_constraint | conparentid   | oid          | NO          | 
 pg_catalog   | pg_constraint | conpfeqop     | ARRAY        | YES         | 
 pg_catalog   | pg_constraint | conppeqop     | ARRAY        | YES         | 
 pg_catalog   | pg_constraint | conrelid      | oid          | NO          | 
 pg_catalog   | pg_constraint | contype       | "char"       | NO          | 
 pg_catalog   | pg_constraint | contypid      | oid          | NO          | 
 pg_catalog   | pg_constraint | convalidated  | boolean      | NO          | 
 pg_catalog   | pg_constraint | oid           | oid          | NO          | 
```

## pg_namespace

```sql
 table_schema |  table_name  | column_name | data_type | is_nullable | column_default 
--------------+--------------+-------------+-----------+-------------+----------------
 pg_catalog   | pg_namespace | nspacl      | ARRAY     | YES         | 
 pg_catalog   | pg_namespace | nspname     | name      | NO          | 
 pg_catalog   | pg_namespace | nspowner    | oid       | NO          | 
 pg_catalog   | pg_namespace | oid         | oid       | NO          | 
```

## constraint_column_usage

```sql
    table_schema    |       table_name        |    column_name     | data_type | is_nullable | column_default 
--------------------+-------------------------+--------------------+-----------+-------------+----------------
 information_schema | constraint_column_usage | column_name        | name      | YES         | 
 information_schema | constraint_column_usage | constraint_catalog | name      | YES         | 
 information_schema | constraint_column_usage | constraint_name    | name      | YES         | 
 information_schema | constraint_column_usage | constraint_schema  | name      | YES         | 
 information_schema | constraint_column_usage | table_catalog      | name      | YES         | 
 information_schema | constraint_column_usage | table_name         | name      | YES         | 
 information_schema | constraint_column_usage | table_schema       | name      | YES         | 
```

## triggers

```sql
    table_schema    | table_name |        column_name         |        data_type         | is_nullable | column_default 
--------------------+------------+----------------------------+--------------------------+-------------+----------------
 information_schema | triggers   | action_condition           | character varying        | YES         | 
 information_schema | triggers   | action_order               | integer                  | YES         | 
 information_schema | triggers   | action_orientation         | character varying        | YES         | 
 information_schema | triggers   | action_reference_new_row   | name                     | YES         | 
 information_schema | triggers   | action_reference_new_table | name                     | YES         | 
 information_schema | triggers   | action_reference_old_row   | name                     | YES         | 
 information_schema | triggers   | action_reference_old_table | name                     | YES         | 
 information_schema | triggers   | action_statement           | character varying        | YES         | 
 information_schema | triggers   | action_timing              | character varying        | YES         | 
 information_schema | triggers   | created                    | timestamp with time zone | YES         | 
 information_schema | triggers   | event_manipulation         | character varying        | YES         | 
 information_schema | triggers   | event_object_catalog       | name                     | YES         | 
 information_schema | triggers   | event_object_schema        | name                     | YES         | 
 information_schema | triggers   | event_object_table         | name                     | YES         | 
 information_schema | triggers   | trigger_catalog            | name                     | YES         | 
 information_schema | triggers   | trigger_name               | name                     | YES         | 
 information_schema | triggers   | trigger_schema             | name                     | YES         | 
```

## pg_proc

```sql
 table_schema | table_name |   column_name   |  data_type   | is_nullable | column_default 
--------------+------------+-----------------+--------------+-------------+----------------
 pg_catalog   | pg_proc    | oid             | oid          | NO          | 
 pg_catalog   | pg_proc    | proacl          | ARRAY        | YES         | 
 pg_catalog   | pg_proc    | proallargtypes  | ARRAY        | YES         | 
 pg_catalog   | pg_proc    | proargdefaults  | pg_node_tree | YES         | 
 pg_catalog   | pg_proc    | proargmodes     | ARRAY        | YES         | 
 pg_catalog   | pg_proc    | proargnames     | ARRAY        | YES         | 
 pg_catalog   | pg_proc    | proargtypes     | ARRAY        | NO          | 
 pg_catalog   | pg_proc    | probin          | text         | YES         | 
 pg_catalog   | pg_proc    | proconfig       | ARRAY        | YES         | 
 pg_catalog   | pg_proc    | procost         | real         | NO          | 
 pg_catalog   | pg_proc    | proisstrict     | boolean      | NO          | 
 pg_catalog   | pg_proc    | prokind         | "char"       | NO          | 
 pg_catalog   | pg_proc    | prolang         | oid          | NO          | 
 pg_catalog   | pg_proc    | proleakproof    | boolean      | NO          | 
 pg_catalog   | pg_proc    | proname         | name         | NO          | 
 pg_catalog   | pg_proc    | pronamespace    | oid          | NO          | 
 pg_catalog   | pg_proc    | pronargdefaults | smallint     | NO          | 
 pg_catalog   | pg_proc    | pronargs        | smallint     | NO          | 
 pg_catalog   | pg_proc    | proowner        | oid          | NO          | 
 pg_catalog   | pg_proc    | proparallel     | "char"       | NO          | 
 pg_catalog   | pg_proc    | proretset       | boolean      | NO          | 
 pg_catalog   | pg_proc    | prorettype      | oid          | NO          | 
 pg_catalog   | pg_proc    | prorows         | real         | NO          | 
 pg_catalog   | pg_proc    | prosecdef       | boolean      | NO          | 
 pg_catalog   | pg_proc    | prosrc          | text         | NO          | 
 pg_catalog   | pg_proc    | prosupport      | regproc      | NO          | 
 pg_catalog   | pg_proc    | protrftypes     | ARRAY        | YES         | 
 pg_catalog   | pg_proc    | provariadic     | oid          | NO          | 
 pg_catalog   | pg_proc    | provolatile     | "char"       | NO          | 
```

## pg_tables

```sql
 table_schema | table_name | column_name | data_type | is_nullable | column_default 
--------------+------------+-------------+-----------+-------------+----------------
 pg_catalog   | pg_tables  | hasindexes  | boolean   | YES         | 
 pg_catalog   | pg_tables  | hasrules    | boolean   | YES         | 
 pg_catalog   | pg_tables  | hastriggers | boolean   | YES         | 
 pg_catalog   | pg_tables  | rowsecurity | boolean   | YES         | 
 pg_catalog   | pg_tables  | schemaname  | name      | YES         | 
 pg_catalog   | pg_tables  | tablename   | name      | YES         | 
 pg_catalog   | pg_tables  | tableowner  | name      | YES         | 
 pg_catalog   | pg_tables  | tablespace  | name      | YES         | 
```

## columns

```sql
    table_schema    | table_name |       column_name        |     data_type     | is_nullable | column_default 
--------------------+------------+--------------------------+-------------------+-------------+----------------
 information_schema | columns    | character_maximum_length | integer           | YES         | 
 information_schema | columns    | character_octet_length   | integer           | YES         | 
 information_schema | columns    | character_set_catalog    | name              | YES         | 
 information_schema | columns    | character_set_name       | name              | YES         | 
 information_schema | columns    | character_set_schema     | name              | YES         | 
 information_schema | columns    | collation_catalog        | name              | YES         | 
 information_schema | columns    | collation_name           | name              | YES         | 
 information_schema | columns    | collation_schema         | name              | YES         | 
 information_schema | columns    | column_default           | character varying | YES         | 
 information_schema | columns    | column_name              | name              | YES         | 
 information_schema | columns    | data_type                | character varying | YES         | 
 information_schema | columns    | datetime_precision       | integer           | YES         | 
 information_schema | columns    | domain_catalog           | name              | YES         | 
 information_schema | columns    | domain_name              | name              | YES         | 
 information_schema | columns    | domain_schema            | name              | YES         | 
 information_schema | columns    | dtd_identifier           | name              | YES         | 
 information_schema | columns    | generation_expression    | character varying | YES         | 
 information_schema | columns    | identity_cycle           | character varying | YES         | 
 information_schema | columns    | identity_generation      | character varying | YES         | 
 information_schema | columns    | identity_increment       | character varying | YES         | 
 information_schema | columns    | identity_maximum         | character varying | YES         | 
 information_schema | columns    | identity_minimum         | character varying | YES         | 
 information_schema | columns    | identity_start           | character varying | YES         | 
 information_schema | columns    | interval_precision       | integer           | YES         | 
 information_schema | columns    | interval_type            | character varying | YES         | 
 information_schema | columns    | is_generated             | character varying | YES         | 
 information_schema | columns    | is_identity              | character varying | YES         | 
 information_schema | columns    | is_nullable              | character varying | YES         | 
 information_schema | columns    | is_self_referencing      | character varying | YES         | 
 information_schema | columns    | is_updatable             | character varying | YES         | 
 information_schema | columns    | maximum_cardinality      | integer           | YES         | 
 information_schema | columns    | numeric_precision        | integer           | YES         | 
 information_schema | columns    | numeric_precision_radix  | integer           | YES         | 
 information_schema | columns    | numeric_scale            | integer           | YES         | 
 information_schema | columns    | ordinal_position         | integer           | YES         | 
 information_schema | columns    | scope_catalog            | name              | YES         | 
 information_schema | columns    | scope_name               | name              | YES         | 
 information_schema | columns    | scope_schema             | name              | YES         | 
 information_schema | columns    | table_catalog            | name              | YES         | 
 information_schema | columns    | table_name               | name              | YES         | 
 information_schema | columns    | table_schema             | name              | YES         | 
 information_schema | columns    | udt_catalog              | name              | YES         | 
 information_schema | columns    | udt_name                 | name              | YES         | 
 information_schema | columns    | udt_schema               | name              | YES         | 
```

## table_constraints

```sql
    table_schema    |    table_name     |    column_name     |     data_type     | is_nullable | column_default 
--------------------+-------------------+--------------------+-------------------+-------------+----------------
 information_schema | table_constraints | constraint_catalog | name              | YES         | 
 information_schema | table_constraints | constraint_name    | name              | YES         | 
 information_schema | table_constraints | constraint_schema  | name              | YES         | 
 information_schema | table_constraints | constraint_type    | character varying | YES         | 
 information_schema | table_constraints | enforced           | character varying | YES         | 
 information_schema | table_constraints | initially_deferred | character varying | YES         | 
 information_schema | table_constraints | is_deferrable      | character varying | YES         | 
 information_schema | table_constraints | table_catalog      | name              | YES         | 
 information_schema | table_constraints | table_name         | name              | YES         | 
 information_schema | table_constraints | table_schema       | name              | YES         | 
```

## key_column_usage

```sql
    table_schema    |    table_name    |          column_name          | data_type | is_nullable | column_default 
--------------------+------------------+-------------------------------+-----------+-------------+----------------
 information_schema | key_column_usage | column_name                   | name      | YES         | 
 information_schema | key_column_usage | constraint_catalog            | name      | YES         | 
 information_schema | key_column_usage | constraint_name               | name      | YES         | 
 information_schema | key_column_usage | constraint_schema             | name      | YES         | 
 information_schema | key_column_usage | ordinal_position              | integer   | YES         | 
 information_schema | key_column_usage | position_in_unique_constraint | integer   | YES         | 
 information_schema | key_column_usage | table_catalog                 | name      | YES         | 
 information_schema | key_column_usage | table_name                    | name      | YES         | 
 information_schema | key_column_usage | table_schema                  | name      | YES         | 
```

## constraint_column_usage

```sql
    table_schema    |       table_name        |    column_name     | data_type | is_nullable | column_default 
--------------------+-------------------------+--------------------+-----------+-------------+----------------
 information_schema | constraint_column_usage | column_name        | name      | YES         | 
 information_schema | constraint_column_usage | constraint_catalog | name      | YES         | 
 information_schema | constraint_column_usage | constraint_name    | name      | YES         | 
 information_schema | constraint_column_usage | constraint_schema  | name      | YES         | 
 information_schema | constraint_column_usage | table_catalog      | name      | YES         | 
 information_schema | constraint_column_usage | table_name         | name      | YES         | 
 information_schema | constraint_column_usage | table_schema       | name      | YES         | 
```

## pg_attribute

```sql
 table_schema |  table_name  |  column_name  | data_type | is_nullable | column_default 
--------------+--------------+---------------+-----------+-------------+----------------
 pg_catalog   | pg_attribute | attacl        | ARRAY     | YES         | 
 pg_catalog   | pg_attribute | attalign      | "char"    | NO          | 
 pg_catalog   | pg_attribute | attbyval      | boolean   | NO          | 
 pg_catalog   | pg_attribute | attcacheoff   | integer   | NO          | 
 pg_catalog   | pg_attribute | attcollation  | oid       | NO          | 
 pg_catalog   | pg_attribute | attfdwoptions | ARRAY     | YES         | 
 pg_catalog   | pg_attribute | attgenerated  | "char"    | NO          | 
 pg_catalog   | pg_attribute | atthasdef     | boolean   | NO          | 
 pg_catalog   | pg_attribute | atthasmissing | boolean   | NO          | 
 pg_catalog   | pg_attribute | attidentity   | "char"    | NO          | 
 pg_catalog   | pg_attribute | attinhcount   | integer   | NO          | 
 pg_catalog   | pg_attribute | attisdropped  | boolean   | NO          | 
 pg_catalog   | pg_attribute | attislocal    | boolean   | NO          | 
 pg_catalog   | pg_attribute | attlen        | smallint  | NO          | 
 pg_catalog   | pg_attribute | attmissingval | anyarray  | YES         | 
 pg_catalog   | pg_attribute | attname       | name      | NO          | 
 pg_catalog   | pg_attribute | attndims      | integer   | NO          | 
 pg_catalog   | pg_attribute | attnotnull    | boolean   | NO          | 
 pg_catalog   | pg_attribute | attnum        | smallint  | NO          | 
 pg_catalog   | pg_attribute | attoptions    | ARRAY     | YES         | 
 pg_catalog   | pg_attribute | attrelid      | oid       | NO          | 
 pg_catalog   | pg_attribute | attstattarget | integer   | NO          | 
 pg_catalog   | pg_attribute | attstorage    | "char"    | NO          | 
 pg_catalog   | pg_attribute | atttypid      | oid       | NO          | 
 pg_catalog   | pg_attribute | atttypmod     | integer   | NO          | 
```

## pg_stat_activity

```sql
 table_schema |    table_name    |   column_name    |        data_type         | is_nullable | column_default 
--------------+------------------+------------------+--------------------------+-------------+----------------
 pg_catalog   | pg_stat_activity | application_name | text                     | YES         | 
 pg_catalog   | pg_stat_activity | backend_start    | timestamp with time zone | YES         | 
 pg_catalog   | pg_stat_activity | backend_type     | text                     | YES         | 
 pg_catalog   | pg_stat_activity | backend_xid      | xid                      | YES         | 
 pg_catalog   | pg_stat_activity | backend_xmin     | xid                      | YES         | 
 pg_catalog   | pg_stat_activity | client_addr      | inet                     | YES         | 
 pg_catalog   | pg_stat_activity | client_hostname  | text                     | YES         | 
 pg_catalog   | pg_stat_activity | client_port      | integer                  | YES         | 
 pg_catalog   | pg_stat_activity | datid            | oid                      | YES         | 
 pg_catalog   | pg_stat_activity | datname          | name                     | YES         | 
 pg_catalog   | pg_stat_activity | leader_pid       | integer                  | YES         | 
 pg_catalog   | pg_stat_activity | pid              | integer                  | YES         | 
 pg_catalog   | pg_stat_activity | query            | text                     | YES         | 
 pg_catalog   | pg_stat_activity | query_start      | timestamp with time zone | YES         | 
 pg_catalog   | pg_stat_activity | state            | text                     | YES         | 
 pg_catalog   | pg_stat_activity | state_change     | timestamp with time zone | YES         | 
 pg_catalog   | pg_stat_activity | usename          | name                     | YES         | 
 pg_catalog   | pg_stat_activity | usesysid         | oid                      | YES         | 
 pg_catalog   | pg_stat_activity | wait_event       | text                     | YES         | 
 pg_catalog   | pg_stat_activity | wait_event_type  | text                     | YES         | 
 pg_catalog   | pg_stat_activity | xact_start       | timestamp with time zone | YES         | 
```

## pg_locks

```sql
 table_schema | table_name |    column_name     | data_type | is_nullable | column_default 
--------------+------------+--------------------+-----------+-------------+----------------
 pg_catalog   | pg_locks   | classid            | oid       | YES         | 
 pg_catalog   | pg_locks   | database           | oid       | YES         | 
 pg_catalog   | pg_locks   | fastpath           | boolean   | YES         | 
 pg_catalog   | pg_locks   | granted            | boolean   | YES         | 
 pg_catalog   | pg_locks   | locktype           | text      | YES         | 
 pg_catalog   | pg_locks   | mode               | text      | YES         | 
 pg_catalog   | pg_locks   | objid              | oid       | YES         | 
 pg_catalog   | pg_locks   | objsubid           | smallint  | YES         | 
 pg_catalog   | pg_locks   | page               | integer   | YES         | 
 pg_catalog   | pg_locks   | pid                | integer   | YES         | 
 pg_catalog   | pg_locks   | relation           | oid       | YES         | 
 pg_catalog   | pg_locks   | transactionid      | xid       | YES         | 
 pg_catalog   | pg_locks   | tuple              | smallint  | YES         | 
 pg_catalog   | pg_locks   | virtualtransaction | text      | YES         | 
 pg_catalog   | pg_locks   | virtualxid         | text      | YES         | 
```
