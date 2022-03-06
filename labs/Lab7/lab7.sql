--1
DECLARE
    v_nr   NUMBER(4);
    v_nume departments.department_name%TYPE;
    CURSOR c IS
    SELECT
        department_name    nume,
        COUNT(employee_id) nr
    FROM
        departments d,
        employees   e
    WHERE
        d.department_id = e.department_id (+)
    GROUP BY
        department_name;

BEGIN
    OPEN c;
    LOOP
        FETCH c INTO
            v_nume,
            v_nr;
        EXIT WHEN c%notfound;
        IF v_nr = 0 THEN
            dbms_output.put_line('In departamentul '
                                 || v_nume
                                 || ' nu lucreaza angajati');
        ELSIF v_nr = 1 THEN
            dbms_output.put_line('In departamentul '
                                 || v_nume
                                 || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul '
                                 || v_nume
                                 || ' lucreaza '
                                 || v_nr
                                 || ' angajati');
        END IF;

    END LOOP;

    CLOSE c;
END;

--SQL
with tabel as ( SELECT department_name nume, COUNT(employee_id) nr 
                FROM departments d, employees e
                WHERE d.department_id=e.department_id(+) 
                GROUP BY department_name )
select case
            when nr = 0 then 'In departamentul ' || nume || ' nu lucreaza angajati.'
            when nr = 1 then 'In departamentul ' || nume || ' lucreaza un angajat.'
            else 'In departamentul ' || nume || ' lucreaza ' || nr || ' angajati.'
       end DeptNameNoEmp
from tabel;

--2
DECLARE
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS TABLE OF NUMBER(4);
    t_nr tab_nr;
    t_nume tab_nume;
    CURSOR c IS
            SELECT department_name nume, COUNT(employee_id) nr
            FROM departments d, employees e
            WHERE d.department_id = e.department_id (+)
            GROUP BY department_name;
BEGIN
    OPEN c;
    FETCH c BULK COLLECT INTO t_nume, t_nr;
    CLOSE c;
    FOR i IN t_nume.first..t_nume.last LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati.');
        ELSIF t_nr(i) = 1 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza un angajat.');
        ELSE
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati.');
        END IF;
    END LOOP;

END;
/

DECLARE
    TYPE tab_nume IS
        TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS
        TABLE OF NUMBER(4);
    t_nr   tab_nr;
    t_nume tab_nume;
    CURSOR c IS
    SELECT
        department_name    nume,
        COUNT(employee_id) nr
    FROM
        departments d,
        employees   e
    WHERE
        d.department_id = e.department_id (+)
    GROUP BY
        department_name;

BEGIN
    OPEN c;
    FETCH c
    BULK COLLECT INTO
        t_nume,
        t_nr
    LIMIT 5;
    IF t_nume.count = 0 THEN
        dbms_output.put_line('Nicio linie returnata');
    ELSE
        dbms_output.put_line('Primele 5 linii returnate');
    END IF;

    FOR i IN t_nume.first..t_nume.last LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' nu lucreaza angajati');
        ELSIF t_nr(i) = 1 THEN
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' lucreaza '
                                 || t_nr(i)
                                 || ' angajati');
        END IF;
    END LOOP;

    dbms_output.new_line;
    dbms_output.put_line('Urmatoarele linii returnate');
    FETCH c
    BULK COLLECT INTO
        t_nume,
        t_nr
    LIMIT 5;
    FOR i IN t_nume.first..t_nume.last LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' nu lucreaza angajati');
        ELSIF t_nr(i) = 1 THEN
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' lucreaza '
                                 || t_nr(i)
                                 || ' angajati');
        END IF;
    END LOOP;

    dbms_output.new_line;
    dbms_output.put_line('Ultimele linii returnate');
    FETCH c
    BULK COLLECT INTO
        t_nume,
        t_nr;
    FOR i IN t_nume.first..t_nume.last LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' nu lucreaza angajati');
        ELSIF t_nr(i) = 1 THEN
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul '
                                 || t_nume(i)
                                 || ' lucreaza '
                                 || t_nr(i)
                                 || ' angajati');
        END IF;
    END LOOP;

    CLOSE c;
END;
/

--cursor si o singura colectie
DECLARE
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    t_nume tab_nume;
    v_nr PLS_INTEGER;
    CURSOR c IS
            SELECT department_name nume
            FROM departments;
BEGIN
    OPEN c;
    FETCH c BULK COLLECT INTO t_nume;
    CLOSE c;
    FOR i IN t_nume.first..t_nume.last LOOP
        SELECT nr
        INTO v_nr
        FROM ( SELECT department_name nume, COUNT(employee_id) nr
               FROM departments d, employees e
               WHERE d.department_id = e.department_id (+)
               GROUP BY department_name )
        WHERE nume = t_nume(i);
        
        IF v_nr = 0 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati');
        ELSIF v_nr = 1 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || v_nr || ' angajati');
        END IF;
    END LOOP;
END;
/

--doar colectii
DECLARE
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS TABLE OF NUMBER(4);
    t_nr tab_nr;
    t_nume tab_nume;
BEGIN
    SELECT department_name nume, COUNT(employee_id) nr
    BULK COLLECT INTO t_nume, t_nr
    FROM departments d, employees e
    WHERE d.department_id = e.department_id (+)
    GROUP BY department_name;
    
    FOR i IN t_nume.first..t_nume.last LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati.');
        ELSIF t_nr(i) = 1 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza un angajat.');
        ELSE
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati.');
        END IF;
    END LOOP;
END;
/

--3
DECLARE
    CURSOR c IS
    SELECT
        department_name    nume,
        COUNT(employee_id) nr
    FROM
        departments d,
        employees   e
    WHERE
        d.department_id = e.department_id (+)
    GROUP BY
        department_name;

BEGIN
    FOR i IN c LOOP
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul '
                                 || i.nume
                                 || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul '
                                 || i.nume
                                 || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul '
                                 || i.nume
                                 || ' lucreaza '
                                 || i.nr
                                 || ' angajati');
        END IF;
    END LOOP;
END;
/

--4
BEGIN
    FOR i IN (
        SELECT
            department_name    nume,
            COUNT(employee_id) nr
        FROM
            departments d,
            employees   e
        WHERE
            d.department_id = e.department_id (+)
        GROUP BY
            department_name
    ) LOOP
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul '
                                 || i.nume
                                 || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul '
                                 || i.nume
                                 || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul '
                                 || i.nume
                                 || ' lucreaza '
                                 || i.nr
                                 || ' angajati');
        END IF;
    END LOOP;
END;
/

--5
-- 3 manageri
DECLARE
    v_cod  employees.employee_id%TYPE;
    v_nume employees.last_name%TYPE;
    v_nr   NUMBER(4);
    CURSOR c IS
    SELECT
        sef.employee_id    cod,
        MAX(sef.last_name) nume,
        COUNT(*)           nr
    FROM
        employees sef,
        employees ang
    WHERE
        ang.manager_id = sef.employee_id
    GROUP BY
        sef.employee_id
    ORDER BY
        nr DESC;

BEGIN
    OPEN c;
    
    LOOP
        FETCH c INTO
            v_cod,
            v_nume,
            v_nr;
        EXIT WHEN c%rowcount > 3 OR c%notfound;
        dbms_output.put_line('Managerul '
                             || v_cod
                             || ' avand numele '
                             || v_nume
                             || ' conduce '
                             || v_nr
                             || ' angajati');

    END LOOP;

    CLOSE c;
END;
/

--4 manageri
DECLARE
    v_cod  employees.employee_id%TYPE;
    v_nume employees.last_name%TYPE;
    v_nr   NUMBER(4);
    CURSOR c IS
    SELECT
        sef.employee_id    cod,
        MAX(sef.last_name) nume,
        COUNT(*)           nr
    FROM
        employees sef,
        employees ang
    WHERE
        ang.manager_id = sef.employee_id
    GROUP BY
        sef.employee_id
    ORDER BY
        nr DESC;

BEGIN
    OPEN c;
    
    LOOP
        FETCH c INTO
            v_cod,
            v_nume,
            v_nr;
        EXIT WHEN c%rowcount > 4 OR c%notfound;
        dbms_output.put_line('Managerul '
                             || v_cod
                             || ' avand numele '
                             || v_nume
                             || ' conduce '
                             || v_nr
                             || ' angajati');

    END LOOP;

    CLOSE c;
END;
/

--top 3 la nr de angajati
DECLARE
    v_cod  employees.employee_id%TYPE;
    v_nume employees.last_name%TYPE;
    v_nr   NUMBER(4);
    CURSOR c IS
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, COUNT(*) nr
        FROM employees sef, employees ang
        WHERE ang.manager_id = sef.employee_id
        GROUP BY sef.employee_id
        ORDER BY nr DESC;
    top BINARY_INTEGER := 1;
    v_nr_anterior BINARY_INTEGER;

BEGIN
    OPEN c;
    
    FETCH c INTO v_cod, v_nume, v_nr;
    dbms_output.put_line('Pe pozitia ' || top || ': Managerul ' || v_cod || ' avand numele ' || v_nume || ' conduce ' || v_nr || ' angajati');
    v_nr_anterior := v_nr;

    LOOP
        FETCH c INTO v_cod, v_nume, v_nr;
        
        IF v_nr <> v_nr_anterior THEN
            top := top + 1;
            v_nr_anterior := v_nr;
        END IF;

        EXIT WHEN top > 3 OR c%notfound;
        
        dbms_output.put_line('Pe pozitia ' || top || ': Managerul ' || v_cod || ' avand numele ' || v_nume || ' conduce ' || v_nr || ' angajati');
    END LOOP;

    CLOSE c;
END;
/

--tema
with tabel as( SELECT sef.employee_id cod, MAX(sef.last_name) nume, COUNT(*) nr
               FROM employees sef, employees ang
               WHERE ang.manager_id = sef.employee_id
               GROUP BY sef.employee_id
               ORDER BY nr DESC )
select *
from tabel t
where 3 > ( select count(distinct nr)
            from tabel
            where nr > t.nr);

declare
    cursor c is
        with tabel as( SELECT sef.employee_id cod, MAX(sef.last_name) nume, COUNT(*) nr
                       FROM employees sef, employees ang
                       WHERE ang.manager_id = sef.employee_id
                       GROUP BY sef.employee_id
                       ORDER BY nr DESC )
        select *
        from tabel t
        where 3 > ( select count(distinct nr)
                    from tabel
                    where nr > t.nr);
begin
    for i in c loop
        exit when c%notfound;
        dbms_output.put_line('Managerul ' || i.cod || ' avand numele ' || i.nume || ' conduce ' || i.nr || ' angajati');
    end loop;
end;

--6
DECLARE
    CURSOR c IS
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr
        FROM employees sef, employees ang
        WHERE ang.manager_id = sef.employee_id
        GROUP BY sef.employee_id
        ORDER BY nr DESC;
BEGIN
    FOR i IN c LOOP
        EXIT WHEN c%ROWCOUNT > 3 OR c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Managerul ' || i.cod || ' avand numele ' || i.nume || ' conduce '|| i.nr || ' angajati');
    END LOOP;
END;
/

--7
DECLARE
    top number(1):= 0; 
BEGIN
    FOR i IN ( SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr
               FROM employees sef, employees ang
               WHERE ang.manager_id = sef.employee_id
               GROUP BY sef.employee_id
               ORDER BY nr DESC ) LOOP
        DBMS_OUTPUT.PUT_LINE('Managerul ' || i.cod || ' avand numele ' || i.nume || ' conduce '|| i.nr || ' angajati');
        top := top+1;
        EXIT WHEN top = 3;
    END LOOP;
END;
/
