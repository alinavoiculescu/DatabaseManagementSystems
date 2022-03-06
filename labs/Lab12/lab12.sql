--ex4-pana la sf de la exercitii

--Exercitii
--1
create or replace trigger trig1_av
before delete on dept_av
begin
    if sys.login_user <> upper('Scott') then
        raise_application_error(-20900, 'Nu ai voie sa stergi!');
    end if;
end;
/

drop trigger trig1_av;

--2
create or replace trigger trig2_av
before update of commission_pct on emp_av
for each row
begin
    if nvl(:new.commission_pct, 0) >= 0.5 then
        raise_application_error(-20900, 'Comisionul nu are voie sa fie mai mare decat jumatate din salariu!');
    end if;
end;
/

drop trigger trig2_av;

--3
--a
alter table info_dept_av
add numar number(4);

update info_dept_av d
set numar = (select count(*)
             from emp_av e
             where e.department_id = d.id);

select * from info_dept_av;

--b
create or replace trigger trig3_av
after update or insert or delete on info_emp_av
for each row
begin
    if updating('id_dept') then
        update info_dept_av
        set numar = numar - 1
        where id = :old.id_dept;
        
        update info_dept_av
        set numar = numar + 1
        where id = :new.id_dept;
    end if;
    
    if inserting then
        update info_dept_av
        set numar = numar + 1
        where id = :new.id_dept;
    end if;
    
    if deleting then
        update info_dept_av
        set numar = numar - 1
        where id = :old.id_dept;
    end if;    
end;
/

update info_emp_av
set id_dept = 100
where id_dept = 50;

rollback;

--4
create or replace trigger trig4_av
before insert or update of department_id on emp_av
for each row
declare
    nr number(4);
begin
    select count(*) into nr
    from emp_av
    where department_id = :new.department_id;
    
    if nr = 45 then
        raise_application_error(-20900, 'Nu pot lucra mai mult de 45 de persoane intr-un departament!');
    end if;
end;
/

insert into emp_av(employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id)
values (207, 'FN', 'LN', 'EMAIL', sysdate, 'JID', 3000, 50);

select * from INFO_DEPT_av;

insert into emp_av(employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id)
select employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id
from emp_av
where department_id = 30;