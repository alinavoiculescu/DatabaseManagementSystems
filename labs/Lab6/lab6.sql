select * from v$open_cursor;

--6
DECLARE
    TYPE tablou_imbricat IS TABLE OF NUMBER;
    t tablou_imbricat := tablou_imbricat();
BEGIN
-- punctul a
    FOR i IN 1..10 LOOP
        t.extend;
        t(i):=i;
    END LOOP;
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 
    FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i) || ' '); 
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

-- punctul b
    FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN t(i) := null;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
    FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

-- punctul c
    t.DELETE(t.first);
    t.DELETE(5,7);
    t.DELETE(t.last);
    DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
                         ' si valoarea ' || nvl(t(t.first),0));
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
                         ' si valoarea ' || nvl(t(t.last),0));
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN 
            DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' '); 
        END IF;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
-- punctul d
    t.delete;
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

--7
DECLARE
    TYPE tablou_imbricat IS TABLE OF CHAR(1);
    t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm');
    i INTEGER;
BEGIN
    i := t.FIRST;
    WHILE i <= t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i));
        i := t.NEXT(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    i := t.LAST;
    WHILE i >= t.FIRST LOOP
        DBMS_OUTPUT.PUT(t(i));
        i := t.PRIOR(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    t.delete(2); 
    t.delete(4);
    
    i := t.FIRST;
    WHILE i <= t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i));
        i := t.NEXT(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
    i := t.LAST;
    WHILE i >= t.FIRST LOOP
        DBMS_OUTPUT.PUT(t(i));
        i := t.PRIOR(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;
/

--8
DECLARE
    TYPE vector IS VARRAY(20) OF NUMBER;
    t vector:= vector();
BEGIN
-- punctul a
    FOR i IN 1..10 LOOP
        t.extend;
        t(i):=i;
    END LOOP;
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 
    FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT(t(i) || ' '); 
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

-- punctul b
    FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN t(i):=null;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
 
    FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' '); 
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

-- punctul c
-- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!! 
-- din vectori nu se pot sterge elemente individuale!!!
    t.TRIM;
    t.TRIM(2);
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
    
-- punctul d
    t.delete;
    DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/

--9
CREATE OR REPLACE TYPE subordonati_av AS VARRAY(10) OF NUMBER(4);
/

CREATE TABLE manageri_av (cod_mgr NUMBER(10),
                          nume VARCHAR2(20),
                          lista subordonati_av);

DECLARE 
    v_sub subordonati_av:= subordonati_av(100,200,300);
    v_lista manageri_av.lista%TYPE;
BEGIN
    INSERT INTO manageri_av VALUES (1, 'Mgr 1', v_sub);
    INSERT INTO manageri_av VALUES (2, 'Mgr 2', null);
 
    INSERT INTO manageri_av VALUES (3, 'Mgr 3', subordonati_av(400,500));
    
    INSERT INTO manageri_av VALUES (4, 'Mgr 4', subordonati_av());
 
    SELECT lista
    INTO v_lista
    FROM manageri_av
    WHERE cod_mgr=1;
 
    FOR j IN v_lista.FIRST..v_lista.LAST loop
        DBMS_OUTPUT.PUT_LINE (v_lista(j));
    END LOOP;
END;
/

SELECT * FROM manageri_av;
DROP TABLE manageri_av;
DROP TYPE subordonati_av;

--10
CREATE TABLE emp_test_av AS 
                    SELECT employee_id, last_name
                    FROM employees
                    WHERE ROWNUM <= 2;

CREATE OR REPLACE TYPE tip_telefon_av IS TABLE OF VARCHAR(12);
/

ALTER TABLE emp_test_av
ADD (telefon tip_telefon_av) 
NESTED TABLE telefon STORE AS tabel_telefon_av;

select * from SYS.dba_nested_tables;

INSERT INTO emp_test_av
VALUES (500, 'XYZ',tip_telefon_av('074XXX', '0213XXX', '037XXX'));

select * from emp_test_av;

UPDATE emp_test_av
SET telefon = tip_telefon_av('073XXX', '0214XXX')
WHERE employee_id = 198;

SELECT a.employee_id, b.*
FROM emp_test_av a, TABLE (a.telefon) b;

SELECT a.employee_id, b.*
FROM emp_test_av a, TABLE (a.telefon)(+) b;

SELECT a.employee_id, cardinality(a.telefon), b.*
FROM emp_test_av a, TABLE (a.telefon)(+) b;

DROP TABLE emp_test_av;
DROP TYPE tip_telefon_av;

--11
--V1
DECLARE
    TYPE tip_cod IS VARRAY(5) OF NUMBER(3);
    coduri tip_cod := tip_cod(205,206); 
BEGIN
    FOR i IN coduri.FIRST..coduri.LAST LOOP
        DELETE FROM emp_av
        WHERE employee_id = coduri(i);
    END LOOP;
END; 
/

SELECT employee_id FROM emp_av;

ROLLBACK;

--V2 (BETTER)
DECLARE
    TYPE tip_cod IS VARRAY(20) OF NUMBER;
    coduri tip_cod := tip_cod(205,206);
BEGIN
    FORALL i IN coduri.FIRST..coduri.LAST
        DELETE FROM emp_av
        WHERE employee_id = coduri(i);
END;
/

SELECT employee_id FROM emp_av;

ROLLBACK;

--EXERCITII
--1
DECLARE
    type t_ang is varray(5) OF emp_av.employee_id%type;
    type t_sal is varray(5) OF emp_av.salary%type;
    v_ang t_ang := t_ang();
    v_sal t_sal := t_sal();
BEGIN
    select employee_id, salary
    bulk collect into v_ang, v_sal
    from (select employee_id, salary
          from emp_av
          where commission_pct is null
          order by salary asc)
    where rownum <= 5;
    
    for i in v_ang.first..v_ang.last loop
        DBMS_OUTPUT.PUT_LINE('Angajatul cu codul ' || v_ang(i) || ' are salariul '
                                                   || v_sal(i));
    end loop;
    
    forall i in v_ang.first..v_ang.last
        update emp_av
        set salary = salary * 1.05
        where employee_id = v_ang(i)
        returning salary bulk collect into v_sal;
    
    for i in v_ang.first..v_ang.last loop
        DBMS_OUTPUT.PUT_LINE('Angajatul cu codul ' || v_ang(i) || ' are noul salariu '
                                                   || v_sal(i));
    end loop;
END;
/

--Ex2
CREATE OR REPLACE TYPE tip_orase_av AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TABLE excursie_av (cod_excursie NUMBER(4),
                          denumire VARCHAR2(20),
                          orase tip_orase_av,
                          status VARCHAR2(15));

DECLARE
    v_orase tip_orase_av := tip_orase_av('Oras11', 'Oras12', 'Oras13', 'Oras14');
    v_lista_orase excursie_av.orase%TYPE;
    v_lista_excursii tip_orase_av := tip_orase_av();
    v_denumire excursie_av.denumire%TYPE := '&p_denumire';
    v_oras1 VARCHAR2(20) := '&p_oras1';
    v_oras2 VARCHAR2(20) := '&p_oras2';
    v_oras VARCHAR2(20) := '&p_oras';
    v_cod excursie_av.cod_excursie%TYPE := &p_cod;
    i PLS_INTEGER;
    j PLS_INTEGER;
    minim PLS_INTEGER := 10000;
BEGIN
--a
    INSERT INTO excursie_av VALUES (1, 'Denumire1', v_orase, 'Disponibila');
    INSERT INTO excursie_av VALUES (2, 'Denumire2', tip_orase_av('Oras21', 'Oras22', 'Oras23'), 'Disponibila');
    INSERT INTO excursie_av VALUES (3, 'Denumire3', tip_orase_av('Oras31', 'Oras32', 'Oras33'), 'Disponibila');
    INSERT INTO excursie_av VALUES (4, 'Denumire4', tip_orase_av('Oras41', 'Oras42', 'Oras43', 'Oras44'), 'Disponibila');
    INSERT INTO excursie_av VALUES (5, 'Denumire5', tip_orase_av('Oras51', 'Oras52', 'Oras53'), 'Disponibila');
  
--b
    SELECT orase
    INTO v_lista_orase
    FROM excursie_av
    WHERE denumire = v_denumire;

----1
    v_lista_orase.EXTEND();
    i := v_lista_orase.last;
    v_lista_orase(i) := 'OrasNou1';

----2
    v_lista_orase.EXTEND();
    i := v_lista_orase.LAST - 1;
    
    WHILE i >= 2 LOOP
        v_lista_orase(i + 1) := v_lista_orase(i);
        i := v_lista_orase.PRIOR(i);
    END LOOP;
    
    v_lista_orase(2) := 'OrasNou2';
    
----3
    FOR k IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
        IF v_lista_orase(k) = v_oras1 THEN
            i := k;
        END IF;
        
        IF v_lista_orase(k) = v_oras2 THEN
            j := k;
        END IF;
    END LOOP;
    
    v_lista_orase(i) := v_oras2;
    v_lista_orase(j) := v_oras1;
    
----4
    FOR i IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
        IF v_lista_orase(i) = v_oras THEN
            j := i;
        END IF;
    END LOOP;
    
    j := j + 1;
    
    FOR i IN j..v_lista_orase.LAST LOOP
        v_lista_orase(i - 1) := v_lista_orase(i);
    END LOOP;

    v_lista_orase.TRIM;
    
    UPDATE excursie_av
    SET orase = v_lista_orase
    WHERE denumire = v_denumire;
    
--c
    SELECT orase
    INTO v_lista_orase
    FROM excursie_av
    WHERE cod_excursie = v_cod;
    
    DBMS_OUTPUT.PUT('Numarul de orase vizitate in excursia cu codul ' || v_cod || ' este ' || v_lista_orase.COUNT ||'. Acestea sunt: ');
    FOR i IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
        DBMS_OUTPUT.PUT(v_lista_orase(i) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

--d
    v_lista_excursii.EXTEND(5);
    
    SELECT denumire
    BULK COLLECT INTO v_lista_excursii
    FROM excursie_av;
    
    FOR i IN v_lista_excursii.FIRST..v_lista_excursii.LAST LOOP
        SELECT orase
        INTO v_lista_orase
        FROM excursie_av
        WHERE denumire = v_lista_excursii(i);
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT('Numarul de orase vizitate in excursia ' || v_lista_excursii(i) || ' este ' || v_lista_orase.COUNT ||'. Acestea sunt: ');
        
        IF v_lista_orase.COUNT < minim THEN
            minim := v_lista_orase.COUNT;
        END IF;
        
        FOR j IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
            DBMS_OUTPUT.PUT(v_lista_orase(j) || ' ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;

--e
    FOR i IN v_lista_excursii.FIRST..v_lista_excursii.LAST LOOP
        SELECT orase
        INTO v_lista_orase
        FROM excursie_av
        WHERE denumire = v_lista_excursii(i);
        
        IF v_lista_orase.COUNT = minim THEN
            UPDATE excursie_av
            SET status = 'Anulata'
            WHERE denumire = v_lista_excursii(i);
        END IF;
    END LOOP;  
END;
/
    

--Ex3 --TABLOU IMBRICAT
CREATE OR REPLACE TYPE tip_orase_av IS TABLE OF VARCHAR2(20);
/

CREATE TABLE excursie_av (cod_excursie NUMBER(4),
                          denumire VARCHAR2(20),
                          status VARCHAR2(15));
                          
ALTER TABLE excursie_av
ADD (orase tip_orase_av)
NESTED TABLE orase STORE AS tabel_orase_av;

DECLARE
    v_orase tip_orase_av := tip_orase_av('Oras11', 'Oras12', 'Oras13', 'Oras14');
    v_lista_orase excursie_av.orase%TYPE;
    v_lista_excursii tip_orase_av := tip_orase_av();
    v_denumire excursie_av.denumire%TYPE := '&p_denumire';
    v_oras1 VARCHAR2(20) := '&p_oras1';
    v_oras2 VARCHAR2(20) := '&p_oras2';
    v_oras VARCHAR2(20) := '&p_oras';
    v_cod excursie_av.cod_excursie%TYPE := &p_cod;
    i PLS_INTEGER;
    j PLS_INTEGER;
    minim PLS_INTEGER := 10000;
BEGIN
--a
    INSERT INTO excursie_av VALUES (1, 'Denumire1', 'Disponibila', v_orase);
    INSERT INTO excursie_av VALUES (2, 'Denumire2', 'Disponibila', tip_orase_av('Oras21', 'Oras22', 'Oras23'));
    INSERT INTO excursie_av VALUES (3, 'Denumire3', 'Disponibila', tip_orase_av('Oras31', 'Oras32', 'Oras33'));
    INSERT INTO excursie_av VALUES (4, 'Denumire4', 'Disponibila', tip_orase_av('Oras41', 'Oras42', 'Oras43', 'Oras44'));
    INSERT INTO excursie_av VALUES (5, 'Denumire5', 'Disponibila', tip_orase_av('Oras51', 'Oras52', 'Oras53'));
  
--b
    SELECT orase
    INTO v_lista_orase
    FROM excursie_av
    WHERE denumire = v_denumire;

----1
    v_lista_orase.EXTEND();
    i := v_lista_orase.last;
    v_lista_orase(i) := 'OrasNou1';

----2
    v_lista_orase.EXTEND();
    i := v_lista_orase.LAST - 1;
    
    WHILE i >= 2 LOOP
        v_lista_orase(i + 1) := v_lista_orase(i);
        i := v_lista_orase.PRIOR(i);
    END LOOP;
    
    v_lista_orase(2) := 'OrasNou2';
    
----3
    FOR k IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
        IF v_lista_orase(k) = v_oras1 THEN
            i := k;
        END IF;
        
        IF v_lista_orase(k) = v_oras2 THEN
            j := k;
        END IF;
    END LOOP;
    
    v_lista_orase(i) := v_oras2;
    v_lista_orase(j) := v_oras1;
    
----4
    FOR i IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
        IF v_lista_orase(i) = v_oras THEN
            j := i;
        END IF;
    END LOOP;

    v_lista_orase.DELETE(j);
    
    UPDATE excursie_av
    SET orase = v_lista_orase
    WHERE denumire = v_denumire;
    
--c
    SELECT orase
    INTO v_lista_orase
    FROM excursie_av
    WHERE cod_excursie = v_cod;
    
    DBMS_OUTPUT.PUT('Numarul de orase vizitate in excursia cu codul ' || v_cod || ' este ' || v_lista_orase.COUNT ||'. Acestea sunt: ');
    FOR i IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
        DBMS_OUTPUT.PUT(v_lista_orase(i) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

--d
    v_lista_excursii.EXTEND(5);
    
    SELECT denumire
    BULK COLLECT INTO v_lista_excursii
    FROM excursie_av;
    
    FOR i IN v_lista_excursii.FIRST..v_lista_excursii.LAST LOOP
        SELECT orase
        INTO v_lista_orase
        FROM excursie_av
        WHERE denumire = v_lista_excursii(i);
        
        DBMS_OUTPUT.NEW_LINE;
        DBMS_OUTPUT.PUT('Numarul de orase vizitate in excursia ' || v_lista_excursii(i) || ' este ' || v_lista_orase.COUNT ||'. Acestea sunt: ');
        
        IF v_lista_orase.COUNT < minim THEN
            minim := v_lista_orase.COUNT;
        END IF;
        
        FOR j IN v_lista_orase.FIRST..v_lista_orase.LAST LOOP
            DBMS_OUTPUT.PUT(v_lista_orase(j) || ' ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;

--e
    FOR i IN v_lista_excursii.FIRST..v_lista_excursii.LAST LOOP
        SELECT orase
        INTO v_lista_orase
        FROM excursie_av
        WHERE denumire = v_lista_excursii(i);
        
        IF v_lista_orase.COUNT = minim THEN
            UPDATE excursie_av
            SET status = 'Anulata'
            WHERE denumire = v_lista_excursii(i);
        END IF;
    END LOOP;  
END;
/

SELECT * FROM excursie_av;
drop type tip_orase_av;
drop table excursie_av;