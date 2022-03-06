--23
set pagesize 0
set feedback off
spool "c:\users\voicu\appdata\roaming\sql developer\insert_dep.sql"

with a as (select * from departments)
select 'insert into ' || table_name || ' (department_id, department_name, manager_id, location_id) values (' ||
        a.department_id || ', ''' || a.department_name || ''', ' || nvl(to_char(a.manager_id), 'null') || ', ' || a.location_id || ');' "Insert"
from user_tables, a
where table_name like upper('departments');

spool off;