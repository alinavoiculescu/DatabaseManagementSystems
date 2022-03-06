--1
SET SERVEROUT ON
DECLARE
    v NUMBER;
    CURSOR c IS
        SELECT employee_id FROM employees;
BEGIN
-- no data found
SELECT employee_id 
INTO v
FROM employees
WHERE 1 = 0;

-- too many rows
SELECT employee_id
INTO v
FROM employees;

-- invalid number
SELECT employee_id
INTO v
FROM employees
WHERE 2 = 's';

 -- when others
v := 's';

 -- cursor already open
 open c;
 open c;
EXCEPTION
WHEN NO_DATA_FOUND THEN 
 DBMS_OUTPUT.PUT_LINE (' no data found: ' ||SQLCODE || ' - ' || 
SQLERRM);
WHEN TOO_MANY_ROWS THEN 
 DBMS_OUTPUT.PUT_LINE (' too many rows: ' ||SQLCODE || ' - ' 
|| SQLERRM);
WHEN INVALID_NUMBER THEN 
 DBMS_OUTPUT.PUT_LINE (' invalid number: ' ||SQLCODE || ' - ' 
|| SQLERRM);
WHEN CURSOR_ALREADY_OPEN THEN
 DBMS_OUTPUT.PUT_LINE (' cursor already open: ' ||SQLCODE || ' 
- ' || SQLERRM);
WHEN OTHERS THEN 
 DBMS_OUTPUT.PUT_LINE (SQLCODE || ' - ' || SQLERRM);
END;
/
SET SERVEROUT OFF

--2
DROP TABLE error_av;
CREATE TABLE error_av
(cod NUMBER,
mesaj VARCHAR2(100));

--V1
DECLARE
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    x NUMBER;
    exceptie EXCEPTION;
BEGIN
    x:=1;
    IF x=1 THEN
        RAISE exceptie;
    ELSE 
        x:=x/(x-1);
END IF;
EXCEPTION
    WHEN exceptie THEN 
        v_cod := -20001;
        v_mesaj := 'x=1 determina o impartire la 0';
        INSERT INTO error_av
        VALUES (v_cod, v_mesaj);
END;
/
SELECT *
FROM error_av;

--V2
DECLARE
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    x NUMBER;
BEGIN
    x:=1;
    x:=x/(x-1);
EXCEPTION
    WHEN ZERO_DIVIDE THEN 
        v_cod := SQLCODE;
        v_mesaj := SUBSTR(SQLERRM,1,100); 
        -- mesajul erorii are dimensiune 512
        INSERT INTO error_av
        VALUES (v_cod, v_mesaj);
END;
/
SELECT *
FROM error_av;

ROLLBACK;

--3
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_loc PROMPT 'Dati locatia: '

DECLARE
    v_loc dept_av.location_id%TYPE:= &p_loc;
    v_nume dept_av.department_name%TYPE;
BEGIN
    SELECT department_name
    INTO v_nume
    FROM dept_av
    WHERE location_id = v_loc;
 
    DBMS_OUTPUT.PUT_LINE('In locatia '|| v_loc ||
                         ' functioneaza departamentul '||v_nume);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO error_av 
        VALUES ( -20002, 'nu exista departamente in locatia data');
 
        DBMS_OUTPUT.PUT_LINE('a aparut o exceptie ');
    
    WHEN TOO_MANY_ROWS THEN
        INSERT INTO error_av
        VALUES (-20003, 'exista mai multe departamente in locatia data');
 
        DBMS_OUTPUT.PUT_LINE('a aparut o exceptie ');
    WHEN OTHERS THEN
        INSERT INTO error_av (mesaj)
        VALUES ('au aparut alte erori');
END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF

--4
ALTER TABLE dept_av
ADD CONSTRAINT c_pr_av PRIMARY KEY(department_id);

ALTER TABLE emp_av
ADD CONSTRAINT c_ex_av FOREIGN KEY (department_id) 
REFERENCES dept_av;

DELETE FROM dept_av
WHERE department_id=10; --apare eroarea sistem -02292

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_cod PROMPT 'Dati un cod de departament ' 
DECLARE
    exceptie EXCEPTION;
    PRAGMA EXCEPTION_INIT(exceptie,-02292); 
    -- exceptia nu are un nume predefinit,
    -- cu PRAGMA EXCEPTION_INIT asociez erorii avand 
    -- codul -02292 un nume
BEGIN
    DELETE FROM dept_av
    WHERE department_id = &p_cod;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE ('nu puteti sterge un departament in care lucreaza salariati');
END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF

--5
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_val PROMPT 'Dati valoarea: '

DECLARE
    v_val NUMBER := &p_val;
    v_numar NUMBER(7);
    exceptie EXCEPTION;
BEGIN
    SELECT COUNT(*)
    INTO v_numar
    FROM emp_av
    WHERE (salary+salary*NVL(commission_pct,0))*12>v_val;
 
    IF v_numar = 0 THEN
        RAISE exceptie;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('NR de angajati este '||v_numar);
    END IF;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista angajati pentru care sa se indeplineasca aceasta conditie');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alta eroare');
END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF

--6
SET VERIFY OFF
ACCEPT p_cod PROMPT 'Dati codul: '

DECLARE
    v_cod NUMBER := &p_cod;
BEGIN
    UPDATE emp_av
    SET salary=salary+1000
    WHERE employee_id=v_cod;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20999,'salariatul nu exista');
    END IF;
END;
/
SET VERIFY ON

--7
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_cod PROMPT 'Dati codul: '

DECLARE
    v_cod NUMBER := &p_cod;
    v_nume emp_av.last_name%TYPE;
    v_sal emp_av.salary%TYPE;
BEGIN 
    SELECT last_name,salary
    INTO v_nume,v_sal
    FROM emp_av
    WHERE employee_id=v_cod;
    
    DBMS_OUTPUT.PUT_LINE(v_nume||' '||v_sal);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20999, 'salariatul nu exista');
END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF

--8
--V1 – fiecare comanda are un numar de ordine
SET SERVEROUTPUT ON
DECLARE
    v_localizare NUMBER(1):=1;
    v_nume emp_av.last_name%TYPE;
    v_sal emp_av.salary%TYPE;
    v_job emp_av.job_id%TYPE;
BEGIN 
    v_localizare:=1;

    SELECT last_name
    INTO v_nume
    FROM emp_av
    WHERE employee_id=200;

    DBMS_OUTPUT.PUT_LINE(v_nume);
    
    v_localizare:=2;
    
    SELECT salary
    INTO v_sal
    FROM emp_av
    WHERE employee_id=455;
    
    DBMS_OUTPUT.PUT_LINE(v_sal);

    v_localizare:=3;

    SELECT job_id
    INTO v_job
    FROM emp_av
    WHERE employee_id=200;
    
    DBMS_OUTPUT.PUT_LINE(v_job);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('comanda SELECT ' || v_localizare || ' nu returneaza nimic');
END;
/
SET SERVEROUTPUT OFF

--V2 – fiecare comanda este inclusa într-un subbloc
SET SERVEROUTPUT ON
DECLARE
    v_localizare NUMBER(1):=1;
    v_nume emp_av.last_name%TYPE;
    v_sal emp_av.salary%TYPE;
    v_job emp_av.job_id%TYPE;
BEGIN
    BEGIN
        SELECT last_name
        INTO v_nume
        FROM emp_av
        WHERE employee_id=200;
        
        DBMS_OUTPUT.PUT_LINE(v_nume);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('comanda SELECT1 nu returneaza nimic');
    END;
    
    BEGIN
        SELECT salary
        INTO v_sal
        FROM emp_av
        WHERE employee_id=455;
 
        DBMS_OUTPUT.PUT_LINE('v_sal');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('comanda SELECT2 nu returneaza nimic');
    END;
 
    BEGIN
        SELECT job_id
        INTO v_job
        FROM emp_av
        WHERE employee_id=200;

        DBMS_OUTPUT.PUT_LINE(v_job);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('comanda SELECT3 nu returneaza nimic');
    END;
END;
/
SET SERVEROUTPUT OFF

--9
DECLARE
    v_comm NUMBER(4);
BEGIN
    SELECT ROUND(salary*NVL(commission_pct,0))
    INTO v_comm
    FROM emp_av
    WHERE employee_id=455;

    <<eticheta>>

    UPDATE emp_av
    SET salary=salary+v_comm
    WHERE employee_id=200;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        v_comm:=5000;
        GOTO eticheta; 
END;
/

--10
SET SERVEROUTPUT ON
DECLARE
 v_comm_val NUMBER(4);
 v_comm emp_av.commission_pct%TYPE;
BEGIN
    SELECT NVL(commission_pct,0), ROUND(salary*NVL(commission_pct,0))
    INTO v_comm, v_comm_val
    FROM emp_av
    WHERE employee_id=200;
 
    IF v_comm=0 THEN 
        GOTO eticheta;
    ELSE 
        UPDATE emp_av
        SET salary=salary+ v_comm_val
        WHERE employee_id=200;
    END IF;
    
    <<eticheta>>
 
    --DBMS_OUTPUT.PUT_LINE('este ok!');
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('este o exceptie!'); 
END;
/
SET SERVEROUTPUT OFF

--Exercitii
--1
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_variabila PROMPT 'Dati variabila: '

DECLARE
    v_variabila NUMBER := &p_variabila;
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    exceptie EXCEPTION;
BEGIN
    IF v_variabila < 0 THEN
        RAISE exceptie;
    ELSE 
        DBMS_OUTPUT.PUT_LINE(SQRT(v_variabila));
END IF;
EXCEPTION
    WHEN exceptie THEN 
        v_cod := -20001;
        v_mesaj := 'Variabila nu poate fi negativa!';
        
        INSERT INTO error_av
        VALUES (v_cod, v_mesaj);
END;
/

SET VERIFY ON
SET SERVEROUTPUT OFF

SELECT *
FROM error_av;

--2
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_sal PROMPT 'Dati salariul: '

DECLARE
    v_sal NUMBER := &p_sal;
    v_nume emp_av.last_name%TYPE;
BEGIN 
    SELECT last_name
    INTO v_nume
    FROM emp_av
    WHERE salary = v_sal;
    
    DBMS_OUTPUT.PUT_LINE(v_nume);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista salariati care sa castige acest salariu.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multi salariati cre castiga acest salariu.');
END;
/

SET VERIFY ON
SET SERVEROUTPUT OFF

--3
update dept_av
set department_id = 30
where department_id = 100;

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_cod1 PROMPT 'Dati departamentul pe care doriti sa il modificati:'
ACCEPT p_cod2 PROMPT 'Dati departamentul care va fi modificat:'

DECLARE
    exceptie EXCEPTION;
    PRAGMA EXCEPTION_INIT(exceptie, -00001); 
BEGIN
    update dept_av
    set department_id = &p_cod2
    where department_id = &p_cod1;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE ('Nu puteti modifica un departament in care lucreaza salariati!');
END;
/
SET VERIFY ON
SET SERVEROUTPUT OFF

--4
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_nr1 PROMPT 'Introduceti capatul din stanga al intervalului:'
ACCEPT p_nr2 PROMPT 'Introduceti capatul din dreapta al intervalului:'

DECLARE
    exceptie EXCEPTION;
    v_nr_ang NUMBER;
    v_dept_name dept_av.department_name%type;
BEGIN
    select count(*)
    into v_nr_ang
    from emp_av
    where department_id = 10
    group by department_id;
    
    if v_nr_ang >= &p_nr1 and v_nr_ang <= &p_nr2 then
        select department_name
        into v_dept_name
        from dept_av
        where department_id = 10;
        
        DBMS_OUTPUT.PUT_LINE(v_dept_name);
    else
        raise exceptie;
    end if;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE('Conditia nu este indeplinita.');
END;
/

SET VERIFY ON
SET SERVEROUTPUT OFF

--5
SET VERIFY OFF
ACCEPT p_cod PROMPT 'Introduceti codul departamentului: '

DECLARE
    v_cod NUMBER := &p_cod;
BEGIN
    UPDATE dept_av
    SET department_name = department_name || ' Modified'
    WHERE department_id = v_cod;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20999, 'Departamentul nu exista.');
    END IF;
END;
/
SET VERIFY ON

--6
--V1
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_loc PROMPT 'Introduceti locatia: '
ACCEPT p_cod PROMPT 'Introduceti codul: '

DECLARE
    v_localizare NUMBER(1) := 1;
    v_loc dept_av.location_id%TYPE := &p_loc;
    v_nume1 dept_av.department_name%TYPE;
    v_cod dept_av.department_id%TYPE := &p_cod;
    v_nume2 dept_av.department_name%TYPE;
BEGIN 
    v_localizare := 1;

    SELECT department_name
    INTO v_nume1
    FROM dept_av
    WHERE location_id = v_loc;
     
    DBMS_OUTPUT.PUT_LINE('In locatia '|| v_loc || ' functioneaza departamentul ' || v_nume1);
    
    v_localizare := 2;
    
    SELECT department_name
    INTO v_nume2
    FROM dept_av
    WHERE department_id = v_cod;
     
    DBMS_OUTPUT.PUT_LINE('Codul '|| v_cod || ' corespunde departamentului ' || v_nume2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        IF v_localizare = 1 THEN
            DBMS_OUTPUT.PUT_LINE('SELECT1: Nu exista departamente in locatia data.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('SELECT2: Nu exista niciun departament cu codul dat.');
        END IF;
    WHEN TOO_MANY_ROWS THEN
        IF v_localizare = 1 THEN
            DBMS_OUTPUT.PUT_LINE('SELECT1: Exista mai multe departamente in locatia data.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('SELECT2: Exista mai multe departamente cu codul dat.');
        END IF;
    WHEN OTHERS THEN
        IF v_localizare = 1 THEN
            DBMS_OUTPUT.PUT_LINE('SELECT1: Au aparut alte erori.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('SELECT2: Au aparut alte erori.');
        END IF;
END;
/

SET VERIFY ON
SET SERVEROUTPUT OFF

--V2
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT p_loc PROMPT 'Introduceti locatia: '
ACCEPT p_cod PROMPT 'Introduceti codul: '

DECLARE
    v_loc dept_av.location_id%TYPE := &p_loc;
    v_nume1 dept_av.department_name%TYPE;
    v_cod dept_av.department_id%TYPE := &p_cod;
    v_nume2 dept_av.department_name%TYPE;
BEGIN
    BEGIN
        SELECT department_name
        INTO v_nume1
        FROM dept_av
        WHERE location_id = v_loc;
     
        DBMS_OUTPUT.PUT_LINE('In locatia '|| v_loc || ' functioneaza departamentul ' || v_nume1);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SELECT1: Nu exista departamente in locatia data.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('SELECT1: Exista mai multe departamente in locatia data.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('SELECT1: Au aparut alte erori.');
    END;
    
    BEGIN
        SELECT department_name
        INTO v_nume2
        FROM dept_av
        WHERE department_id = v_cod;
     
        DBMS_OUTPUT.PUT_LINE('Codul '|| v_cod || ' corespunde departamentului ' || v_nume2);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('SELECT2: Nu exista niciun departament cu codul dat.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('SELECT2: Exista mai multe departamente cu codul dat.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('SELECT2: Au aparut alte erori.');
    END;
END;
/

SET VERIFY ON
SET SERVEROUTPUT OFF