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