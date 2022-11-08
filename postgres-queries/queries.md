# Список полезных запросов

## Список индексов и их размер

```sql
SELECT
  pg_indexes.tablename AS table_name,
  pg_indexes.indexname AS index_name,
  pg_size_pretty(
    pg_indexes_size(
      pg_indexes.indexname::regclass
    )
  ) AS index_size,
  pg_indexes.indexdef AS index_query
FROM pg_catalog.pg_indexes AS pg_indexes
WHERE pg_indexes.schemaname = 'public'
ORDER BY pg_indexes_size(pg_indexes.indexname::regclass) DESC,
  pg_indexes.tablename ASC,
  pg_indexes.indexname ASC;
```

## Использование индексов

```sql
SELECT
  pg_stat_user_tables.relname AS table_name,
  pg_stat_user_tables.n_live_tup AS rows_in_table,
  100 * pg_stat_user_tables.idx_scan / (pg_stat_user_tables.seq_scan + pg_stat_user_tables.idx_scan) AS percent_of_times_index_used
FROM pg_stat_user_tables 
WHERE pg_stat_user_tables.seq_scan + pg_stat_user_tables.idx_scan > 0 
ORDER BY pg_stat_user_tables.n_live_tup DESC;
```

## Неиспользуемые индексы

```sql
SELECT
  pg_stat_all_indexes.schemaname AS table_schema,
  pg_stat_all_indexes.relname AS table_name,
  pg_stat_all_indexes.indexrelname AS index_name
FROM pg_stat_all_indexes
WHERE pg_stat_all_indexes.idx_scan = 0
  AND schemaname != 'pg_toast'
  AND schemaname != 'pg_catalog';
```

## Список констрейнтов

```sql
SELECT
  DISTINCT constraint_column_usage.table_schema,
  constraint_column_usage.table_name,
  constraint_column_usage.column_name,
  pg_constraint.conname AS constraint_name
FROM pg_catalog.pg_constraint AS pg_constraint
INNER JOIN pg_catalog.pg_namespace AS pg_namespace
  ON pg_namespace.oid = pg_constraint.connamespace
INNER JOIN information_schema.constraint_column_usage AS constraint_column_usage
  ON constraint_column_usage.constraint_name = pg_constraint.conname
  AND constraint_column_usage.constraint_schema = pg_namespace.nspname
WHERE pg_constraint.contype = 'c'
  AND pg_namespace.nspname != 'pg_catalog'
  AND pg_namespace.nspname != 'information_schema'
ORDER BY constraint_column_usage.table_schema ASC,
  constraint_column_usage.table_name ASC,
  constraint_column_usage.column_name ASC,
  pg_constraint.conname ASC;
```

## Список триггеров

```sql
SELECT
  triggers.event_object_schema AS table_schema,
  triggers.event_object_table AS table_name,
  triggers.trigger_schema,
  triggers.trigger_name,
  string_agg(triggers.event_manipulation, ',') AS trigger_events,
  triggers.action_timing AS action_prefix,
  triggers.action_condition AS condition,
  triggers.action_statement AS definition
FROM information_schema.triggers AS triggers
GROUP BY triggers.event_object_schema,
  triggers.event_object_table,
  triggers.trigger_schema,
  triggers.trigger_name,
  triggers.action_timing,
  triggers.action_condition,
  triggers.action_statement
ORDER BY triggers.event_object_schema ASC,
  triggers.event_object_table ASC;
```

## Список функций

```sql
SELECT
  pg_namespace.nspname AS function_schema,
  pg_proc.proname AS function_name,
  pg_catalog.pg_get_function_result(pg_proc.oid) AS function_result_type,
  pg_catalog.pg_get_function_arguments(pg_proc.oid) AS function_arguments
FROM pg_catalog.pg_proc AS pg_proc
INNER JOIN pg_catalog.pg_namespace AS pg_namespace
  ON pg_namespace.oid = pg_proc.pronamespace
WHERE pg_catalog.pg_function_is_visible(pg_proc.oid)
  AND pg_namespace.nspname != 'pg_catalog'
  AND pg_namespace.nspname != 'information_schema'
  AND pg_proc.prokind = 'f';
```

## Список схем в базе данных

```sql
SELECT
  pg_stat_user_tables.schemaname,
  pg_size_pretty(
    SUM(pg_relation_size(pg_class.oid))
  ) AS table_size, 
  pg_size_pretty(
    SUM(pg_total_relation_size(pg_class.oid) - pg_relation_size(pg_class.oid))
  ) AS index_size, 
  pg_size_pretty(
    SUM(pg_total_relation_size(pg_class.oid))
  ) AS total_size,
  SUM(pg_stat_user_tables.n_live_tup) AS rows_in_tables
FROM pg_class
LEFT JOIN pg_namespace
  ON pg_namespace.oid = pg_class.relnamespace
INNER JOIN pg_stat_user_tables
  ON pg_class.relname = pg_stat_user_tables.relname
WHERE pg_namespace.nspname NOT IN ('pg_catalog', 'information_schema')
  AND pg_class.relkind != 'i'
  AND pg_namespace.nspname !~ '^pg_toast'
GROUP BY pg_stat_user_tables.schemaname;
```

## Список баз данных и их размер

```sql
SELECT
  pg_database.datname AS db_name,  
  pg_size_pretty(
    pg_database_size(
      pg_database.datname
    )
  ) AS db_size
FROM pg_database
ORDER BY pg_database_size(pg_database.datname) DESC;
```

## Список таблиц и их размер

```sql
SELECT
  pg_stat_user_tables.schemaname AS table_schema,
  pg_class.relname AS table_name,
  pg_size_pretty(pg_relation_size(pg_class.oid)) AS table_size,
  pg_size_pretty(
    pg_total_relation_size(pg_class.oid) - pg_relation_size(pg_class.oid)
  ) AS index_size,
  pg_size_pretty(pg_total_relation_size(pg_class.oid)) AS total_size,
  pg_stat_user_tables.n_live_tup AS rows_in_table
FROM pg_class
LEFT JOIN pg_namespace
  ON pg_namespace.oid = pg_class.relnamespace
LEFT JOIN pg_stat_user_tables
  ON pg_class.relname = pg_stat_user_tables.relname
WHERE pg_namespace.nspname NOT IN ('pg_catalog', 'information_schema')
  AND pg_class.relkind != 'i'
  AND pg_namespace.nspname !~ '^pg_toast'
ORDER BY pg_total_relation_size(pg_class.oid) DESC;
```

## Список колонок таблиц(ы)

```sql
SELECT
  columns.table_schema,
  columns.table_name,
  columns.column_name,
  columns.data_type,
  columns.is_nullable,
  columns.column_default
FROM information_schema.columns AS columns
WHERE columns.table_schema != 'pg_catalog'
  AND columns.table_schema != 'information_schema'
  -- AND columns.table_name = 'table_name'
ORDER BY columns.table_schema ASC,
  columns.table_name ASC,
  columns.column_name ASC;
```

## Список внешних ключей таблиц(ы)

```sql
SELECT
  tc.constraint_name,
  tc.table_schema,
  tc.table_name,
  kcu.column_name,
  ccu.table_schema AS foreign_table_schema,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name,
  (
    CASE pc.confupdtype
      WHEN 'a' THEN 'no_action'
      WHEN 'r' THEN 'restrict'
      WHEN 'c' THEN 'cascade'
      WHEN 'n' THEN 'set_null'
      WHEN 'd' THEN 'set_default'
    END
  ) AS on_update,
  (
    CASE pc.confdeltype
      WHEN 'a' THEN 'no_action'
      WHEN 'r' THEN 'restrict'
      WHEN 'c' THEN 'cascade'
      WHEN 'n' THEN 'set_null'
      WHEN 'd' THEN 'set_default'
    END
  ) AS on_delete
FROM information_schema.table_constraints AS tc
INNER JOIN pg_constraint AS pc
  ON pc.conname = tc.constraint_name
INNER JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
  -- AND tc.table_name = 'table_name'
INNER JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
  -- AND ccu.table_name = 'table_name'
WHERE tc.constraint_type = 'FOREIGN KEY';
```

## Список enum

```sql
SELECT
  pg_namespace.nspname AS schema,  
  columns.table_name,
  columns.column_name,
  pg_type.typname AS enum_type_name,  
  jsonb_agg(pg_enum.enumlabel) AS enum_values
FROM pg_type
INNER JOIN pg_enum
  ON pg_type.oid = pg_enum.enumtypid  
INNER JOIN pg_catalog.pg_namespace AS pg_namespace
  ON pg_namespace.oid = pg_type.typnamespace
INNER JOIN information_schema.columns AS columns
  ON columns.udt_name = pg_type.typname
GROUP BY pg_namespace.nspname,  
  pg_type.typname,
  columns.table_name,
  columns.column_name;
```

## Список внешних ключей, у которых отсутствуют индексы

```sql
SELECT
  pg_constraint.conname AS constraint_name,
  pg_constraint.conrelid::regclass AS table_name,
  pg_constraint.confrelid::regclass AS referenced_table_name,
  string_agg(pg_attribute.attname, ',' ORDER BY x.pos) AS column
FROM pg_constraint
CROSS JOIN LATERAL
  unnest(pg_constraint.conkey) WITH ORDINALITY AS x(attnum, pos)
INNER JOIN pg_attribute
  ON pg_attribute.attnum = x.attnum
  AND pg_attribute.attrelid = pg_constraint.conrelid
WHERE pg_constraint.contype = 'f' /* FOREIGN KEY */
  AND NOT EXISTS (
    SELECT 1 FROM pg_index
    WHERE pg_index.indrelid = pg_constraint.conrelid
      AND pg_index.indpred IS NULL
      AND (pg_index.indkey::smallint[])[0:cardinality(pg_constraint.conkey)-1] OPERATOR(pg_catalog.@>) pg_constraint.conkey
  )
GROUP BY pg_constraint.conname,
  pg_constraint.conrelid,
  pg_constraint.confrelid,
  pg_constraint.conkey;
```

## Коэффициент кэширования

```sql
SELECT
  SUM(pg_statio_user_tables.heap_blks_read) AS heap_read,
  SUM(pg_statio_user_tables.heap_blks_hit) AS heap_hit,
  SUM(pg_statio_user_tables.heap_blks_hit) / (
    SUM(pg_statio_user_tables.heap_blks_hit) + SUM(pg_statio_user_tables.heap_blks_read)
  ) AS ratio
FROM pg_statio_user_tables;  
```

## Коэффициент кэшировани индексов

```sql
SELECT
  SUM(pg_statio_user_indexes.idx_blks_read) AS idx_read,
  SUM(pg_statio_user_indexes.idx_blks_hit) AS idx_hit,
  (
    SUM(pg_statio_user_indexes.idx_blks_hit) - SUM(pg_statio_user_indexes.idx_blks_read)
  ) / SUM(pg_statio_user_indexes.idx_blks_hit) AS ratio
FROM pg_statio_user_indexes;
```

## Проверка запусков VACUUM

```sql
SELECT
  pg_stat_user_tables.relname AS table_name,
  pg_stat_user_tables.last_vacuum,
  pg_stat_user_tables.last_autovacuum 
FROM pg_stat_user_tables;
```

## Количество открытых подключений

```sql
SELECT
  COUNT(*) as connections,
  pg_stat_activity.backend_type
FROM pg_stat_activity
WHERE pg_stat_activity.state = 'active'
  OR pg_stat_activity.state = 'idle'
GROUP BY pg_stat_activity.backend_type
ORDER BY connections DESC;
```

## Список выполняемых запросов

```sql
SELECT
  pg_stat_activity.pid,
  pg_database.datname,
  pg_stat_activity.state,
  pg_stat_activity.query,
  age(clock_timestamp(), pg_stat_activity.query_start) AS runtime_in_time,
  EXTRACT(EPOCH FROM age(clock_timestamp(), pg_stat_activity.query_start)) AS runtime_in_seconds
FROM pg_stat_activity 
INNER JOIN pg_database
  ON pg_database.oid = pg_stat_activity.datid
WHERE pg_stat_activity.query NOT ILIKE '%pg_stat_activity%' 
ORDER BY runtime_in_seconds DESC;
```

## Отменить running query

```sql
SELECT pg_cancel_backend(procpid);
```

## Отменить idle query (разорвать соединение)

```sql
SELECT pg_terminate_backend(procpid);
```

## Разорвать все соединения для баз(ы) данных

```sql
SELECT
  pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pid != pg_backend_pid()
  -- AND pg_stat_activity.datname = 'database_name';
```

## Убрать advisory lock

`Может понадобиться для проведения миграций, когда стоит bgbouncer и запущено несколько экземляров бэкэнда`

```sql
SELECT
  pid,
  locktype,
  mode
FROM pg_locks
WHERE locktype = 'advisory';

SELECT pg_advisory_unlock(<PID>); /* Если не помогает, то разорвите соединение */
```

## Аптайм сервера

```sql
SELECT date_trunc('second', CURRENT_TIMESTAMP - pg_postmaster_start_time()) as uptime;
```

## Узнать название таблицы по oid

*Названия папок, которые хранятся /var/lib/postgresql/${PG_VERSION}/main/base, и есть oid таблиц*

```sql
SELECT
  pg_database.datname
FROM pg_database
WHERE pg_database.oid = <OID>;
```
