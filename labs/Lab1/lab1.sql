--11
create table emp_av as select * from employees;

--comentariu pe tabel
comment on table emp_av is 'Informa?ii despre angaja?i';

--comentariu pe coloane
comment on column emp_av.salary is 'Salariu angajati';

--12
describe user_tab_comments;
desc user_tab_comments;

select comments
from user_tab_comments
where lower(table_name) = lower('emp_av');

select comments
from user_col_comments
where table_name = upper('emp_av');

--13
alter session set nls_date_format = 'dd.mm.yyyy hh24:mi:ss';

--14
select extract(year from sysdate)
from dual;

select sysdate
from dual;

--15
select extract(day from sysdate), extract(month from sysdate)
from dual;

--16
desc user_tables;

select table_name
from user_tables
where table_name like upper('%av');

--17
spool c:\users\voicu\appData\roaming\sterg_tabelee.sql

select 'drop table ' || table_name || ';'
from user_tables
where table_name like upper('%av');

spool off;

--20+21+22
create table dep_av as select * from departments;

set pagesize 0
set feedback off
spool "c:\users\voicu\appdata\roaming\sql developer\sterg_tabele.sql"

select 'drop table ' || table_name || ' cascade constraints;'
from user_tables
where table_name like upper('%av');

spool off;


--23 (tema)
set pagesize 0
set feedback off
spool "c:\users\voicu\appdata\roaming\sql developer\insert_dep.sql"

with a as (select * from departments)
select 'insert into ' || table_name || ' (department_id, department_name, manager_id, location_id) values (' ||
        a.department_id || ', ''' || a.department_name || ''', ' || nvl(to_char(a.manager_id), 'null') || ', ' || a.location_id || ');' "Insert"
from user_tables, a
where table_name like upper('departments');

spool off;