--ex 1 lab 5

--2 DBMS_JOB
--Varianta 1
VARIABLE nr_job NUMBER 
BEGIN 
    DBMS_JOB.SUBMIT( 
    -- întoarce num?rul jobului, printr-o variabil? de leg?tur?
    JOB => :nr_job, 
 
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_av(100, 1000);', 
 
    -- data de start a execu?iei (dupa 30 secunde) 
    NEXT_DATE => SYSDATE+30/86400, 
 
    -- intervalul de timp la care se repet? execu?ia 
    INTERVAL => 'SYSDATE+1'); 
 
    COMMIT; 
END; 
/

SELECT salary FROM emp_av WHERE employee_id = 100;
-- asteptati 30 de secunde 
SELECT salary FROM emp_av WHERE employee_id = 100;
-- numarul jobului 
PRINT nr_job; 
-- informatii despre joburi 
SELECT JOB, NEXT_DATE, WHAT 
FROM USER_JOBS;

-- lansarea jobului la momentul dorit 
SELECT salary FROM emp_av WHERE employee_id = 100;

BEGIN 
 -- presupunand ca jobul are codul 1 atunci: 
    DBMS_JOB.RUN(job => 1); 
END; 
/

SELECT salary FROM emp_av WHERE employee_id = 100;

-- stergerea unui job 
BEGIN 
    DBMS_JOB.REMOVE(job=>1); 
END; 
/ 
SELECT JOB, NEXT_DATE, WHAT 
FROM USER_JOBS; 
UPDATE emp_av 
SET salary = 24000 
WHERE employee_id = 100; 
COMMIT;

--Varianta 2
CREATE OR REPLACE PACKAGE pachet_job_av
IS 
    nr_job NUMBER; 
    FUNCTION obtine_job RETURN NUMBER; 
END; 
/ 
CREATE OR REPLACE PACKAGE body pachet_job_av 
IS 
    FUNCTION obtine_job RETURN NUMBER IS 
    BEGIN 
        RETURN nr_job; 
    END; 
END; 
/

BEGIN 
    DBMS_JOB.SUBMIT( 
    -- întoarce num?rul jobului, printr-o variabil? de leg?tur?
    JOB => pachet_job_av.nr_job, 
 
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_av(100, 1000);',
    -- data de start a execu?iei (dupa 30 secunde) 
    NEXT_DATE => SYSDATE+30/86400, 
 
    -- intervalul de timp la care se repet? execu?ia 
    INTERVAL => 'SYSDATE+1'); 
 
    COMMIT; 
END; 
/ 
-- informatii despre joburi 
SELECT JOB, NEXT_DATE, WHAT 
FROM USER_JOBS 
WHERE JOB = pachet_job_av.obtine_job; 

-- lansarea jobului la momentul dorit 
SELECT salary FROM emp_av WHERE employee_id = 100;
BEGIN 
 DBMS_JOB.RUN(JOB => pachet_job_av.obtine_job); 
END; 
/ 

SELECT salary FROM emp_av WHERE employee_id = 100;

-- stergerea unui job 
BEGIN 
 DBMS_JOB.REMOVE(JOB=>pachet_job_av.obtine_job);
END; 
/ 

SELECT JOB, NEXT_DATE, WHAT 
FROM USER_JOBS 
WHERE JOB = pachet_job_av.obtine_job;

UPDATE emp_av 
SET salary = 24000 
WHERE employee_id = 100; 
COMMIT;

--3 UTL_FILE
CREATE OR REPLACE PROCEDURE scriu_fisier_av (director VARCHAR2, fisier VARCHAR2) 
IS 
    v_file UTL_FILE.FILE_TYPE; 
    CURSOR cursor_rez IS 
    SELECT department_id departament, SUM(salary) suma 
    FROM employees 
    GROUP BY department_id 
    ORDER BY SUM(salary); 
    v_rez cursor_rez%ROWTYPE; 
BEGIN 
    v_file := UTL_FILE.FOPEN(director, fisier, 'w'); 
    
    UTL_FILE.PUTF(v_file, 'Suma salariilor pe departamente \n Raport generat pe data '); 
    UTL_FILE.PUT(v_file, SYSDATE); 
    UTL_FILE.NEW_LINE(v_file); 
    
    OPEN cursor_rez; 
    
    LOOP 
    FETCH cursor_rez INTO v_rez; 
    EXIT WHEN cursor_rez%NOTFOUND; 
    UTL_FILE.NEW_LINE(v_file); 
    UTL_FILE.PUT(v_file, v_rez.departament); 
    UTL_FILE.PUT(v_file, ' '); 
    UTL_FILE.PUT(v_file, v_rez.suma); 
    END LOOP; 
    
    CLOSE cursor_rez; 
    
    UTL_FILE.FCLOSE(v_file); 
END; 
/ 

--nu merge pt ca se face local
EXECUTE scriu_fisier('F:\','test.txt');

--LAB 6
--1
CREATE OR REPLACE TRIGGER trig1_av
BEFORE INSERT OR UPDATE OR DELETE ON emp_av
BEGIN
IF (TO_CHAR(SYSDATE,'D') = 1) OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20) THEN
    RAISE_APPLICATION_ERROR(-20001,'Tabelul nu poate fi actualizat');
END IF;
END;
/

DROP TRIGGER trig1_av;

--2
--Varianta 1
CREATE OR REPLACE TRIGGER trig21_av
BEFORE UPDATE OF salary ON emp_av
FOR EACH ROW
BEGIN
    IF (:NEW.salary < :OLD.salary) THEN
        RAISE_APPLICATION_ERROR(-20002,'Salariul nu poate fi micsorat');
    END IF;
END;
/

UPDATE emp_av
SET salary = salary - 100;

DROP TRIGGER trig21_av;

--Varianta 2
CREATE OR REPLACE TRIGGER trig22_av
BEFORE UPDATE OF salary ON emp_av
FOR EACH ROW
WHEN (NEW.salary < OLD.salary)
BEGIN
    RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END;
/

UPDATE emp_av
SET salary = salary - 100;

DROP TRIGGER trig22_av;

--3
create table job_grades_av as select * from job_grades;
select * from job_grades_av;

CREATE OR REPLACE TRIGGER trig3_av
BEFORE UPDATE OF lowest_sal, highest_sal ON job_grades_av
FOR EACH ROW
DECLARE
    v_min_sal emp_av.salary%TYPE;
    v_max_sal emp_av.salary%TYPE;
    exceptie EXCEPTION;
BEGIN
    SELECT MIN(salary), MAX(salary) INTO v_min_sal, v_max_sal
    FROM emp_av;
    
    IF (:OLD.grade_level = 1) AND (v_min_sal < :NEW.lowest_sal) THEN
        RAISE exceptie;
    END IF;

    IF (:OLD.grade_level = 7) AND (v_max_sal > :NEW.highest_sal) THEN
        RAISE exceptie;
    END IF;
EXCEPTION
    WHEN exceptie THEN
        RAISE_APPLICATION_ERROR (-20003, 'Exista salarii care se gasesc in afara intervalului'); 
END;
/

UPDATE job_grades_av 
SET lowest_sal = 3000
WHERE grade_level = 1;

UPDATE job_grades_av
SET highest_sal = 20000
WHERE grade_level = 7;

DROP TRIGGER trig3_av;

--4
--a
create table info_dept_av (id number(3) primary key,
                           nume_dept VARCHAR2(100),
                           plati number);

--b
select d.department_id, d.department_name, sum(salary)
from departments d, employees e
where d.department_id = e.department_id(+)
group by d.department_id, d.department_name;

insert into info_dept_av 
select d.department_id, d.department_name, sum(salary)
from departments d, employees e
where d.department_id = e.department_id(+)
group by d.department_id, d.department_name;

select * from info_dept_av;

--c
CREATE OR REPLACE PROCEDURE modific_plati_av (v_codd info_dept_av.id%TYPE, v_plati info_dept_av.plati%TYPE) AS
BEGIN
    UPDATE info_dept_av
    SET plati = NVL (plati, 0) + v_plati
    WHERE id = v_codd;
END;
/

CREATE OR REPLACE TRIGGER trig4_av
AFTER DELETE OR UPDATE OR INSERT OF salary ON emp_av
FOR EACH ROW
BEGIN
    IF DELETING THEN 
        -- se sterge un angajat
        modific_plati_av (:OLD.department_id, -1*:OLD.salary);
    ELSIF UPDATING THEN 
        --se modifica salariul unui angajat
        modific_plati_av(:OLD.department_id,:NEW.salary-:OLD.salary); 
    ELSE 
        -- se introduce un nou angajat
        modific_plati_av(:NEW.department_id, :NEW.salary);
    END IF;
END;
/

SELECT * FROM info_dept_av WHERE id = 90;

INSERT INTO emp_av (employee_id, last_name, email, hire_date, job_id, salary, department_id) 
VALUES (300, 'N1', 'n1@g.com', sysdate, 'SA_REP', 2000, 90);

SELECT * FROM info_dept_av WHERE id = 90;

UPDATE emp_av
SET salary = salary + 1000
WHERE employee_id = 300;

SELECT * FROM info_dept_av WHERE id = 90;

DELETE FROM emp_av
WHERE employee_id = 300;

SELECT * FROM info_dept_av WHERE id = 90;

DROP TRIGGER trig4_av;

--5
--a
create table info_emp_av (id number(3) primary key,
                          nume varchar2(50),
                          prenume varchar2(50),
                          salariu number(6),
                          id_dept number(3) references info_dept_av);

--b
insert into info_emp_av
select employee_id, last_name, first_name, salary, d.id
from employees e, info_dept_av d
where e.department_id = d.id;

--c
CREATE OR REPLACE VIEW v_info_av AS
    SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, d.nume_dept, d.plati
    FROM info_emp_av e, info_dept_av d
    WHERE e.id_dept = d.id;

--d
SELECT *
FROM user_updatable_columns
WHERE table_name = UPPER('v_info_av');

--e
CREATE OR REPLACE TRIGGER trig5_av
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_av
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        -- inserarea in vizualizare determina inserarea 
        -- in info_emp_av si reactualizarea in info_dept_av
        -- se presupune ca departamentul exista
        INSERT INTO info_emp_av 
        VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);
 
        UPDATE info_dept_av
        SET plati = plati + :NEW.salariu
        WHERE id = :NEW.id_dept;
    ELSIF DELETING THEN
        -- stergerea unui salariat din vizualizare determina
        -- stergerea din info_emp_av si reactualizarea in
        -- info_dept_av
        DELETE FROM info_emp_av
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('salariu') THEN
        /* modificarea unui salariu din vizualizare determina 
        modificarea salariului in info_emp_av si reactualizarea
        in info_dept_av */
 
        UPDATE info_emp_av
        SET salariu = :NEW.salariu
        WHERE id = :OLD.id;
 
        UPDATE info_dept_av
        SET plati = plati - :OLD.salariu + :NEW.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('id_dept') THEN
        /* modificarea unui cod de departament din vizualizare
        determina modificarea codului in info_emp_av
        si reactualizarea in info_dept_av */ 
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

--f
SELECT *
FROM user_updatable_columns
WHERE table_name = UPPER('v_info_av');

-- adaugarea unui nou angajat
SELECT * FROM info_dept_av WHERE id = 10;

INSERT INTO v_info_av 
VALUES (400, 'N1', 'P1', 3000, 10, 'Nume dept', 0);

SELECT * FROM info_emp_av WHERE id = 400;

SELECT * FROM info_dept_av WHERE id = 10;

-- modificarea salariului unui angajat
UPDATE v_info_av
SET salariu = salariu + 1000
WHERE id = 400;

SELECT * FROM info_emp_av WHERE id = 400;

SELECT * FROM info_dept_av WHERE id = 10;

-- modificarea departamentului unui angajat
SELECT * FROM info_dept_av WHERE id = 90;

UPDATE v_info_av
SET id_dept = 90
WHERE id = 400;

SELECT * FROM info_emp_av WHERE id = 400;

SELECT * FROM info_dept_av WHERE id IN (10,90);

-- eliminarea unui angajat
DELETE FROM v_info_av WHERE id = 400;

SELECT * FROM info_emp_av WHERE id = 400;

SELECT * FROM info_dept_av WHERE id = 90;

DROP TRIGGER trig5_av;

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

--6
CREATE OR REPLACE TRIGGER trig6_av
BEFORE DELETE ON emp_av
BEGIN
    IF USER = UPPER('grupa231') THEN
        RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!');
    END IF;
END;
/

DROP TRIGGER trig6_av;

--7
CREATE TABLE audit_av (utilizator VARCHAR2(30),
                       nume_bd VARCHAR2(50),
                       eveniment VARCHAR2(20),
                       nume_obiect VARCHAR2(30),
                       data DATE);

CREATE OR REPLACE TRIGGER trig7_av
AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO audit_av
    VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE INDEX ind_av ON info_emp_av(nume);

DROP INDEX ind_av;

SELECT * FROM audit_av;

DROP TRIGGER trig7_av;


--8
CREATE OR REPLACE PACKAGE pachet_av
AS
    smin emp_av.salary%type;
    smax emp_av.salary%type;
    smed emp_av.salary%type;
END pachet_av;
/

CREATE OR REPLACE TRIGGER trig81_av
BEFORE UPDATE OF salary ON emp_av
BEGIN
    SELECT MIN(salary), AVG(salary), MAX(salary)
    INTO pachet_av.smin, pachet_av.smed, pachet_av.smax
    FROM emp_av;
END;
/

CREATE OR REPLACE TRIGGER trig82_av
BEFORE UPDATE OF salary ON emp_av
FOR EACH ROW
BEGIN
    IF(:OLD.salary = pachet_av.smin) AND (:NEW.salary > pachet_av.smed) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Acest salariu depaseste valoarea medie');
    ELSIF (:OLD.salary = pachet_av.smax) AND (:NEW.salary < pachet_av.smed) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Acest salariu este sub valoarea medie');
END IF;
END;
/

SELECT AVG(salary)
FROM emp_av;

UPDATE emp_av 
SET salary = 10000 
WHERE salary = (SELECT MIN(salary)
                FROM emp_av);

UPDATE emp_av 
SET salary = 1000 
WHERE salary = (SELECT MAX(salary)
                FROM emp_av);

DROP TRIGGER trig81_av;

DROP TRIGGER trig82_av;