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
ORDER BY pg_indexes.tablename ASC,
  pg_indexes.indexname ASC;
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

## Список таблиц и их размер

```sql
SELECT
  pg_tables.schemaname AS table_schema,
  pg_tables.tablename AS table_name,
  pg_size_pretty(
    pg_total_relation_size(
      pg_tables.tablename::regclass
    )
  ) AS table_size
FROM pg_catalog.pg_tables AS pg_tables
WHERE pg_tables.schemaname != 'pg_catalog' AND 
    pg_tables.schemaname != 'information_schema'
ORDER BY pg_tables.schemaname ASC,
  pg_tables.tablename ASC;
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

## Список выполняемых запросов

```sql
SELECT
  pid,
  age(clock_timestamp(), query_start) AS runtime,
  usename,
  datname,
  state,
  query 
FROM pg_stat_activity 
WHERE query NOT ILIKE '%pg_stat_activity%' 
  -- AND query != '<IDLE>'
ORDER BY query_start desc;
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
