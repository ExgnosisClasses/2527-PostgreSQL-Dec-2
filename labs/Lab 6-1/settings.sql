SELECT name, setting || ' ' || unit as current_value, 
min_val, max_val, boot_val, reset_val 
from pg_settings;

SELECT name, short_desc from pg_settings;

SELECT name, setting as current_value, 
sourcefile, sourceline, pending_restart
from pg_settings
where sourcefile is not null;

SELECT name, setting, sourcefile, sourceline,
applied, error 
from pg_file_settings
where name = 'work_mem';

SELECT * 
FROM pg_file_settings 
WHERE applied = false;
