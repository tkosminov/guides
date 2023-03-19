DB_SEARCH_PATTERN="bugfix-8756042"

dbNames=$(su - postgres -c "psql -q -A -t -c \"SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';\"" | grep ${DB_SEARCH_PATTERN} | awk '{print $1}')

for dbName in ${dbNames}; do
  {
    # разрываем все соединения с этой бд
    su - postgres -c "psql -q -A -t -c \"SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pid != pg_backend_pid() AND pg_stat_activity.datname = '${dbName}';\""
  }
  {
    # удаляем существующую базу
    su - postgres -c "dropdb ${dbName}"
  }
done
