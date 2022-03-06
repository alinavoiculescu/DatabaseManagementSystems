--5
--g
CREATE OR REPLACE TRIGGER trig5_av
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_av
FOR EACH ROW
DECLARE
    nr1 number;
    nr2 number;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO nr2
        FROM info_dept_av
        WHERE :NEW.id_dept = id;
        
        IF nr2 = 0 THEN
            INSERT INTO info_dept_av
            VALUES (:NEW.id_dept, 'Unknown', 0, 1);
        END IF;
        
        SELECT COUNT(*) INTO nr1
        FROM info_emp_av
        WHERE :NEW.id = id;
        
        IF nr1 = 0 THEN
            INSERT INTO info_emp_av
            VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);
        END IF;
        
        IF nr1 = 0 AND nr2 = 0 THEN
            UPDATE info_dept_av
            SET plati = plati + :NEW.salariu
            WHERE id = :NEW.id_dept;
        ELSE
            UPDATE info_dept_av
            SET plati = plati + :NEW.salariu
            WHERE id = :NEW.id_dept;
        END IF;
    ELSIF DELETING THEN
        DELETE FROM info_emp_av
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('salariu') THEN
        UPDATE info_emp_av
        SET salariu = :NEW.salariu
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu + :NEW.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('id_dept') THEN
        UPDATE info_emp_av
        SET id_dept = :NEW.id_dept
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
 
        UPDATE info_dept_av
        SET plati = plati + :NEW.salariu
        WHERE id = :NEW.id_dept;
    END IF;
END;
/

--h
INSERT INTO info_emp_av
VALUES (215, 'Nume1', 'Prenume1', 3023, 270);

INSERT INTO info_emp_av
VALUES (216, 'Nume2', 'Prenume2', 6032, 280);

--i
UPDATE v_info_av
SET nume = 'NumeModificat1'
where id = 215;
---OBSERV CA NU SE SCHIMBA

--j
CREATE OR REPLACE TRIGGER trig5_av
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_av
FOR EACH ROW
DECLARE
    nr1 number;
    nr2 number;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO nr2
        FROM info_dept_av
        WHERE :NEW.id_dept = id;
        
        IF nr2 = 0 THEN
            INSERT INTO info_dept_av
            VALUES (:NEW.id_dept, 'Unknown', 0, 1);
        END IF;
        
        SELECT COUNT(*) INTO nr1
        FROM info_emp_av
        WHERE :NEW.id = id;
        
        IF nr1 = 0 THEN
            INSERT INTO info_emp_av
            VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);
        END IF;
        
        IF nr1 = 0 AND nr2 = 0 THEN
            UPDATE info_dept_av
            SET plati = plati + :NEW.salariu
            WHERE id = :NEW.id_dept;
        ELSE
            UPDATE info_dept_av
            SET plati = plati + :NEW.salariu
            WHERE id = :NEW.id_dept;
        END IF;
    ELSIF DELETING THEN
        DELETE FROM info_emp_av
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('salariu') THEN
        UPDATE info_emp_av
        SET salariu = :NEW.salariu
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu + :NEW.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('id_dept') THEN
        UPDATE info_emp_av
        SET id_dept = :NEW.id_dept
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
 
        UPDATE info_dept_av
        SET plati = plati + :NEW.salariu
        WHERE id = :NEW.id_dept;
    ELSIF UPDATING('nume') THEN
        UPDATE info_emp_av
        SET nume = :NEW.nume
        WHERE id = :OLD.id;
    ELSIF UPDATING('prenume') THEN
        UPDATE info_emp_av
        SET prenume = :NEW.prenume
        WHERE id = :OLD.id;
    ELSIF UPDATING('nume_dept') THEN
        UPDATE info_dept_av
        SET nume_dept = :NEW.nume_dept
        WHERE id = :OLD.id_dept;
    END IF;
END;
/

--k
UPDATE v_info_av
SET nume = 'NumeModificat1'
where id = 215;

UPDATE v_info_av
SET prenume = 'PrenumeModificat1'
where id = 215;

UPDATE v_info_av
SET nume_dept = 'DeptModificat1'
where id_dept = 270;

UPDATE v_info_av
SET nume_dept = 'DeptModificat2'
where id_dept = 50;

rollback;

select * from v_info_av order by 1 desc;
select * from info_emp_av order by 1 desc;
select * from info_dept_av order by 1 desc;

--EXERCITII
--4
create or replace package pkg41_av as
    type t_id is table of dept_av.department_id%type index by pls_integer;
    v_dept_id t_id;
    v_nr number := 0;
end pkg41_av;
/

create or replace trigger trig42_av
before insert or update on emp_av
for each row
begin
    pkg41_av.v_nr := pkg41_av.v_nr + 1;
    pkg41_av.v_dept_id(pkg41_av.v_nr) := :new.department_id;
end trig42_av;
/

create or replace trigger trig43_av
before insert or update on emp_av
declare
    v_max_emp number := 48;
    v_emp_current number;
    v_dept_id dept_av.department_id%type;
begin
    for v_loopindex in 1..pkg41_av.v_nr loop
        v_dept_id := pkg41_av.v_dept_id(v_loopindex);
        
        select count(*)
        into v_emp_current
        from emp_av
        where department_id = v_dept_id;

        if v_emp_current >= v_max_emp then
            raise_application_error(-20001, 'Prea multi angajati in departamentul care are codul: ' || v_dept_id);
        end if;

    end loop;

    pkg41_av.v_nr := 0;
end trig43_av;
/

alter table EMP_AV disable all triggers;

alter trigger TRIG42_AV compile;

alter trigger TRIG43_AV compile;

INSERT INTO emp_av VALUES (207, 'Prenume1', 'Nume1', 'PNUME', '515.123.8468', sysdate, 'IT_PROG', 10000, 0.9, 100, 50);

--5
--a
create table emp_test_av(employee_id number(3) primary key,
                         last_name varchar2(20),
                         first_name varchar2(20),
                         department_id number(3));

create table dept_test_av(department_id number(3) primary key,
                          department_name varchar2(30));

insert into emp_test_av
select employee_id, last_name, first_name, department_id
from emp_av;

insert into dept_test_av
select department_id, department_name
from dept_av;

--b
create or replace trigger cascade_av
before delete or update of department_id on dept_test_av
for each row
begin
    if deleting then
        delete from emp_test_av
        where department_id = :old.department_id;
    elsif updating and :old.department_id != :new.department_id then
        update emp_test_av
        set department_id = :new.department_id
        where department_id = :old.department_id;
    end if;
end cascade_av;
/

--nu este definita constrangere de cheie externa intre cele doua tabele
select *
from emp_test_av
where department_id = 50; --46

delete from dept_test_av
where department_id = 50;

select *
from emp_test_av
where department_id = 50; --0

rollback;

--este definita constrangerea de cheie externa intre cele doua tabele
alter table emp_test_av
add constraint fk_emp_dept foreign key (department_id) references dept_test_av(department_id);

select *
from emp_test_av
where department_id = 50; --46

delete from dept_test_av
where department_id = 50;

select *
from emp_test_av
where department_id = 50; --0

rollback;

alter table emp_test_av drop constraint fk_emp_dept;

--este definita constrangerea de cheie externa intre cele doua tabele cu optiunea ON DELETE CASCADE
alter table emp_test_av
add constraint fk_emp_dept foreign key (department_id) references dept_test_av(department_id)
on delete cascade;

select *
from emp_test_av
where department_id = 50; --46

delete from dept_test_av
where department_id = 50;

select *
from emp_test_av
where department_id = 50; --0

rollback;

alter table emp_test_av drop constraint fk_emp_dept;

--este definita constrangerea de cheie externa intre cele doua tabele cu optiunea ON DELETE SET NULL
alter table emp_test_av
add constraint fk_emp_dept foreign key (department_id) references dept_test_av(department_id)
on delete set null;

select *
from emp_test_av
where department_id = 50; --46

delete from dept_test_av
where department_id = 50;

select *
from emp_test_av
where department_id = 50; --0

rollback;

alter table emp_test_av drop constraint fk_emp_dept;

--6
--a
create table ex6_av1 (user_id varchar2(50),
                      nume_bd varchar2(50),
                      erori varchar2(50),
                      data date);

--b
create or replace trigger trig6_av
before logoff on schema --database (nu avem permisiuni pt database)
begin
    insert into ex6_av1 values (sys.login_user, sys.database_name, dbms_utility.format_error_stack, sysdate);
end;
/