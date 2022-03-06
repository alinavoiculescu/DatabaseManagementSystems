-----------LAB4
select *
from user_objects
where object_type in ('PROCEDURE','FUNCTION');

select text
from user_source
where name = upper('nume_subprogram');

SELECT LINE, POSITION, TEXT
FROM USER_ERRORS
WHERE NAME =UPPER('nume');

--1
DECLARE
    v_nume employees.last_name%TYPE := Initcap('&p_nume'); 
    FUNCTION f1 RETURN NUMBER IS
        salariu employees.salary%type; 
    BEGIN
        SELECT salary INTO salariu 
        FROM employees
        WHERE last_name = v_nume;
        RETURN salariu;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare!');
    END f1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| f1);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '||SQLCODE
        || ' si mesajul = ' || SQLERRM);
END;
/

DECLARE
    v_nume employees.last_name%TYPE := Initcap('&p_nume'); 
    FUNCTION f1 RETURN NUMBER IS
        salariu employees.salary%type; 
    BEGIN
        SELECT salary INTO salariu 
        FROM employees
        WHERE last_name = v_nume;
        RETURN salariu;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat');
            return -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Alta eroare!');
    END f1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| f1);
--EXCEPTION
--    WHEN OTHERS THEN
--        DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '||SQLCODE
--        || ' si mesajul = ' || SQLERRM);
END;
/

--2
CREATE OR REPLACE FUNCTION f2_av 
    (v_nume employees.last_name%TYPE DEFAULT 'Bell') 
RETURN NUMBER IS
    salariu employees.salary%type; 
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
    RETURN salariu;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_av;
/

--metode de apelare
-- 1. bloc plsql
BEGIN
 DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_av);
END;
/

BEGIN
 DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_av('King'));
END;
/

-- 2. SQL
 SELECT f2_av FROM DUAL;
 SELECT f2_av('King') FROM DUAL;

-- 3. SQL*PLUS CU VARIABILA HOST
 VARIABLE nr NUMBER
 EXECUTE :nr := f2_av('Bell');
 PRINT nr
 
 
--3
-- varianta 1
DECLARE
    v_nume employees.last_name%TYPE := Initcap('&p_nume'); 
PROCEDURE p3
IS
    salariu employees.salary%TYPE;
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
    
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '|| 'cu numele dat');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alta eroare!');
END p3;
BEGIN
    p3;
END;
/

-- varianta 2
DECLARE
    v_nume employees.last_name%TYPE := Initcap('&p_nume'); 
    v_salariu employees.salary%type;
PROCEDURE p3(salariu OUT employees.salary%type) IS
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END p3;
BEGIN
    p3(v_salariu);
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/

--4
-- varianta 1
CREATE OR REPLACE PROCEDURE p4_av(v_nume employees.last_name%TYPE)
IS
    salariu employees.salary%TYPE;
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
    
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END p4_av;
/
-- metode apelare
-- 1. Bloc PLSQL
BEGIN
    p4_av('Bell');
END;
/
-- 2. SQL*PLUS
EXECUTE p4_av('Bell');
EXECUTE p4_av('King');
EXECUTE p4_av('Kimball');

-- varianta 2
CREATE OR REPLACE PROCEDURE p4_av(v_nume IN employees.last_name%TYPE,
                                  salariu OUT employees.salary%type) IS
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000,
            'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END p4_av;
/
-- metode apelare
-- 1. Bloc PLSQL
DECLARE
 v_salariu employees.salary%type;
BEGIN
 p4_av('Bell',v_salariu);
 DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/
-- 2. SQL*PLUS
VARIABLE v_sal NUMBER
EXECUTE p4_av ('Bell', :v_sal)
PRINT v_sal

--5
VARIABLE ang_man NUMBER
BEGIN
:ang_man := 200;
END;
/

CREATE OR REPLACE PROCEDURE p5_av (nr IN OUT NUMBER) IS 
BEGIN
SELECT manager_id INTO nr
FROM employees
WHERE employee_id = nr;
END p5_av;
/

EXECUTE p5_av (:ang_man)
PRINT ang_man

--6
DECLARE
    nume employees.last_name%TYPE;
PROCEDURE p6 (rezultat OUT employees.last_name%TYPE,
              comision IN employees.commission_pct%TYPE := NULL,
              cod IN employees.employee_id%TYPE := NULL) 
IS
BEGIN
    IF (comision IS NOT NULL) THEN
        SELECT last_name 
        INTO rezultat
        FROM employees
        WHERE commission_pct= comision;
        DBMS_OUTPUT.PUT_LINE('numele salariatului care are comisionul '||
                             comision || ' este ' || rezultat);
    ELSE
        SELECT last_name 
        INTO rezultat
        FROM employees
        WHERE employee_id =cod;
        DBMS_OUTPUT.PUT_LINE('numele salariatului avand codul '||
                             cod || ' este ' || rezultat);
    END IF;
END p6;
BEGIN
    p6(nume, 0.4);
    p6(nume, cod=>200);
END;
/

--7
DECLARE
    medie1 NUMBER(10,2);
    medie2 NUMBER(10,2);
FUNCTION medie (v_dept employees.department_id%TYPE) 
RETURN NUMBER IS
    rezultat NUMBER(10,2);
BEGIN
    SELECT AVG(salary) 
    INTO rezultat 
    FROM employees
    WHERE department_id = v_dept;
    
    RETURN rezultat;
END;
 
FUNCTION medie (v_dept employees.department_id%TYPE,
                v_job employees.job_id %TYPE) 
RETURN NUMBER IS
    rezultat NUMBER(10,2);
BEGIN
    SELECT AVG(salary) 
    INTO rezultat 
    FROM employees
    WHERE department_id = v_dept AND job_id = v_job;
    
    RETURN rezultat;
END;
BEGIN
    medie1:=medie(80);
    DBMS_OUTPUT.PUT_LINE('Media salariilor din departamentul 80' 
                         || ' este ' || medie1);
    medie2 := medie(80,'SA_MAN');
    DBMS_OUTPUT.PUT_LINE('Media salariilor managerilor din'
                         || ' departamentul 80 este ' || medie2);
END;
/

--8
CREATE OR REPLACE FUNCTION factorial_av(n NUMBER) 
RETURN INTEGER IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE
        RETURN n*factorial_av(n-1);
    END IF;
END factorial_av;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Factorial 5 = ' || factorial_av(5));
END;
/

--9
CREATE OR REPLACE FUNCTION medie_av 
RETURN NUMBER 
IS 
    rezultat NUMBER;
BEGIN
    SELECT AVG(salary) INTO rezultat
    FROM employees;

    RETURN rezultat;
END;
/

SELECT last_name, salary
FROM employees
WHERE salary >= medie_av;

--Exercitii
--1
create table info_av
(
    id number(3) primary key,
    utilizator varchar2(50),
    data timestamp(3),
    comanda varchar2(50),
    nr_linii number(2),
    eroare varchar2(500)
);

create sequence s_info
start with 1;

--2
--functie
CREATE OR REPLACE FUNCTION f2_av2
    (v_nume employees.last_name%TYPE DEFAULT 'Bell') 
RETURN NUMBER IS
    salariu employees.salary%type;
    v_mesaj varchar2(500);
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
    
    insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 1, null);
    
    RETURN salariu;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 0, 'Nu exista angajati cu numele dat');
        return -1;
    WHEN TOO_MANY_ROWS THEN
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 2, 'Exista mai multi angajati cu numele dat');
        return -2;
    WHEN OTHERS THEN
        v_mesaj := sqlcode || ' ' || sqlerrm;
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', null, v_mesaj);
        return -3;
END f2_av2;
/

select * from info_av;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul este ' || f2_av2);
    DBMS_OUTPUT.PUT_LINE('Salariul este ' || f2_av2('King'));
    DBMS_OUTPUT.PUT_LINE('Salariul este ' || f2_av2('Kimball'));
END;
/

--procedura
CREATE OR REPLACE PROCEDURE p4_av3(v_nume employees.last_name%TYPE)
IS
    salariu employees.salary%TYPE;
    v_mesaj varchar2(500);
BEGIN
    SELECT salary INTO salariu 
    FROM employees
    WHERE last_name = v_nume;
    
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
    
    insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 1, null);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 0, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 2, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
        v_mesaj := sqlcode || ' ' || sqlerrm;
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', null, v_mesaj);
END p4_av3;
/

BEGIN
    p4_av3('Bell');
    p4_av3('King');
    p4_av3('Kimball');
END;
/

--3

select count(*)
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and upper(city) = 'SEATTLE'
and employee_id in (select employee_id
                    from job_history
                    group by employee_id
                    having count(distinct(job_id)) >= 2);
                    
select count(*)
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and upper(city) = 'SEATTLE'
and exists (select 1
            from job_history
            where employee_id = e.employee_id
            group by employee_id
            having count(distinct(job_id)) >= 2);
            
select count(*)
from (select employee_id
      from job_history jh
      where exists (select employee_id
                    from employees e, departments d, locations l
                    where l.location_id = d.location_id
                    and e.department_id = d.department_id
                    and jh.employee_id = e.employee_id
                    and upper(city) = 'SEATTLE')
      group by employee_id
      having count(distinct(job_id)) >= 2);

create or replace function ex3_av(v_oras locations.city%TYPE)
return number
is
nr number;
nr_oras number;
nr_ang number;
begin
    select count(*) into nr_oras
    from locations
    where upper(city) = upper(v_oras);

    if nr_oras = 0 then
        raise NO_DATA_FOUND;
    end if;
    
    select count(*) into nr_ang
    from employees e, departments d, locations l
    where l.location_id = d.location_id
    and e.department_id = d.department_id
    and upper(city) = upper(v_oras);
    
    if nr_ang = 0 then
        insert into info_av values(s_info.nextval, user, SYSTIMESTAMP, 'SELECT', 0, 'Nu exista niciun angajat in orasul dat ca parametru!');
        return -1;
    end if;
    
    select count(*) into nr
    from employees e, departments d, locations l
    where e.department_id = d.department_id
    and d.location_id = l.location_id
    and upper(city) = upper(v_oras)
    and employee_id in (select employee_id
                        from job_history
                        group by employee_id
                        having count(distinct(job_id)) >= 2);
    return nr;
exception
    when NO_DATA_FOUND then
        insert into info_av values(s_info.nextval, user, systimestamp, 'SELECT', 0, 'Nu exista orasul dat ca parametru!');
end ex3_av;
/

begin
    dbms_output.put_line('Numarul de angajati ' || ex3_av('SEATTLE'));
end;
/

--4
create or replace procedure ex4_av(v_cod employees.employee_id%type)
is
begin
    update emp_av
    set salary = salary * 1.1
    where employee_id != v_cod
    and employee_id in (select employee_id
                        from employees
                        start with employee_id = v_cod
                        connect by manager_id = prior employee_id);

    insert into info_av values(s_info.nextval, user, systimestamp, 'UPDATE', 1, null);
exception
    when no_data_found then
        insert into info_av values(s_info.nextval, user, systimestamp, 'UPDATE', 0, 'Nu exista angajatul dat');
end ex4_av;
/

begin
    ex4_av(102);
end;
/

select * from info_av;
select * from employees;

select employee_id, manager_id, level
from employees
start with employee_id = 102
connect by prior employee_id = manager_id;

select employee_id, manager_id, level
from employees
start with employee_id = 102
connect by manager_id = prior employee_id;