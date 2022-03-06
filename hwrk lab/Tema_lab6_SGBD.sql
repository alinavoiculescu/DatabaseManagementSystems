--Ex2 --VECTOR
CREATE OR REPLACE TYPE tip_orase_av AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TABLE excursie_av (cod_excursie NUMBER(4) NOT NULL,
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

CREATE TABLE excursie_av (cod_excursie NUMBER(4) NOT NULL,
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