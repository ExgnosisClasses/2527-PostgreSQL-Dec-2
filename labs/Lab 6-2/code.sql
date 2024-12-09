SELECT pid, usename, application_name, state, query, backend_start, state_change
FROM pg_stat_activity
WHERE state != 'idle';

SELECT * FROM pg_stat_activity;


SELECT usename, datname, client_addr, application_name,
       backend_start, query_start,
       state, backend_xid, query
FROM pg_stat_activity;

SELECT relname AS table_name,
       seq_scan,
       seq_tup_read,
       idx_scan,
       idx_tup_fetch,
       n_tup_ins,
       n_tup_upd,
       n_tup_del
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;


