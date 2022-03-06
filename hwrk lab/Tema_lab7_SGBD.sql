--1
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