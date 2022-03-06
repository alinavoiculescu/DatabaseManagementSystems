--tema ex 10
--1 b, d ca tema
--2,3,4,5 tema (doar cu o varianta modificam,
----nu facem pt toate tipurile de cursoare)

--7
DECLARE
    top number(1):= 0; 
BEGIN
    FOR i IN (SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr
              FROM employees sef, employees ang
              WHERE ang.manager_id = sef.employee_id
              GROUP BY sef.employee_id
              ORDER BY nr DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('Managerul ' || i.cod || ' avand numele ' || i.nume || ' conduce ' || i.nr || ' angajati');
        top := top+1;
        EXIT WHEN top=3;
    END LOOP;
END;
/

--8
--V1
DECLARE
    v_x number(4) := &p_x;
    v_nr number(4);
    v_nume departments.department_name%TYPE;
    CURSOR c (parametru NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e
        WHERE d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(employee_id)> parametru; 
BEGIN
    OPEN c(v_x);
    LOOP
        FETCH c INTO v_nume,v_nr;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('In departamentul ' || v_nume || ' lucreaza ' || v_nr || ' angajati');
    END LOOP;
    CLOSE c;
END;
/

--V2
DECLARE
    v_x number(4) := &p_x;
    CURSOR c (paramentru NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(employee_id)> paramentru; 
BEGIN
    FOR i in c(v_x) LOOP
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati');
    END LOOP;
END;
/

--V2
DECLARE
    v_x number(4) := &p_x;
BEGIN
    FOR i in (SELECT department_name nume, COUNT(employee_id) nr
              FROM departments d, employees e
              WHERE d.department_id=e.department_id
              GROUP BY department_name 
              HAVING COUNT(employee_id) > v_x) LOOP
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume|| ' lucreaza '|| i.nr||' angajati');
    END LOOP;
END;
/

--9
SELECT last_name, hire_date, salary
FROM emp_av
WHERE TO_CHAR(hire_date, 'yyyy') = 2000;

DECLARE
    CURSOR c IS
        SELECT *
        FROM emp_av
        WHERE TO_CHAR(hire_date, 'YYYY') = 2000
        FOR UPDATE OF salary NOWAIT;
BEGIN
    FOR i IN c LOOP
        UPDATE emp_av
        SET salary = salary + 1000
        WHERE CURRENT OF c;
    END LOOP;
END;
/

rollback;

--10
--cursor clasic
DECLARE
    cursor j is select department_id, department_name
                from departments
                where department_id in (10,20,30,40);
    cursor e(department number) is select first_name, last_name
                                   from employees
                                   where department_id = department;
    f_name employees.first_name%type;
    l_name employees.last_name%type;
    dept_id departments.department_id%type;
    dept_name departments.department_name%type;
BEGIN
    open j;
    
    loop
        fetch j into dept_id, dept_name;
        exit when j%notfound;
        
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line('DEPARTAMENT ' || dept_name);
        dbms_output.put_line('-------------------------------------');
        
        open e(dept_id);
        
        loop
            fetch e into f_name, l_name;
            exit when e%notfound;

            dbms_output.put_line(f_name || ' ' || l_name);
        end loop;
        
        if e%rowcount = 0 then
            dbms_output.put_line('Fara angajati in acest departament');
        end if;
        
        close e;
    end loop;
    
    close j;
END;
/

--ciclu cursor
DECLARE
    cursor c1 is select department_id, department_name
                from departments
                where department_id in (10,20,30,40);
    cursor c2(department number) is select first_name, last_name
                   from employees
                   where department_id = department;
                                   
BEGIN
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line('DEPARTAMENT ' || i.department_name);
        dbms_output.put_line('-------------------------------------');
        for j in c2(i.department_id) loop
            dbms_output.put_line(j.first_name || ' ' || j.last_name);
        end loop;
    end loop;
END;
/

--ciclu cursor cu subcereri
BEGIN
    FOR v_dept IN ( SELECT department_id, department_name
                    FROM departments
                    WHERE department_id IN (10,20,30,40)) LOOP
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_dept.department_name);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        FOR v_emp IN (  SELECT last_name
                        FROM employees
                        WHERE department_id = v_dept.department_id) LOOP
            DBMS_OUTPUT.PUT_LINE (v_emp.last_name);
        END LOOP;
    END LOOP;
END;
/

--expresii cursor
DECLARE
    TYPE refcursor IS REF CURSOR;
    CURSOR c_dept IS
        SELECT department_name, 
        CURSOR (SELECT last_name 
                FROM employees e
                WHERE e.department_id = d.department_id)
        FROM departments d
        WHERE department_id IN (10,20,30,40);
        v_nume_dept departments.department_name%TYPE;
        v_cursor refcursor;
        v_nume_emp employees.last_name%TYPE;
BEGIN
    OPEN c_dept;
    LOOP
        FETCH c_dept INTO v_nume_dept, v_cursor;
        EXIT WHEN c_dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_nume_dept);
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        LOOP
            FETCH v_cursor INTO v_nume_emp;
            EXIT WHEN v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE (v_nume_emp);
        END LOOP;
    END LOOP;
 CLOSE c_dept;
END;
/

--11
DECLARE
    TYPE emp_tip IS REF CURSOR RETURN employees%ROWTYPE;
    -- sau 
    -- TYPE emp_tip IS REF CURSOR;
 
    v_emp emp_tip;
    v_optiune NUMBER := &p_optiune;
    v_ang employees%ROWTYPE;
BEGIN
    IF v_optiune = 1 THEN
        OPEN v_emp FOR SELECT * 
                       FROM employees;
    ELSIF v_optiune = 2 THEN
        OPEN v_emp FOR SELECT * 
                       FROM employees
                       WHERE salary BETWEEN 10000 AND 20000;
    ELSIF v_optiune = 3 THEN
        OPEN v_emp FOR SELECT * 
                       FROM employees
                       WHERE TO_CHAR(hire_date, 'YYYY') = 2000;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Optiune incorecta'); 
    END IF;
 
    IF v_emp%ISOPEN THEN
        LOOP
            FETCH v_emp into v_ang;
            EXIT WHEN v_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_ang.last_name);
        END LOOP;
 
        DBMS_OUTPUT.PUT_LINE('Au fost procesate ' || v_emp%ROWCOUNT || ' linii');
        CLOSE v_emp;
    END IF;
END;
/

--12
DECLARE
    TYPE empref IS REF CURSOR; 
    v_emp empref;
    v_nr INTEGER := &n;
    v_id number;
    v_sal number;
    v_comm number;
BEGIN
    OPEN v_emp FOR 
        'SELECT employee_id, salary, commission_pct ' ||
        'FROM employees WHERE salary > :bind_var'
        USING v_nr;
-- introduceti liniile corespunzatoare rezolvarii problemei
    LOOP
        FETCH v_emp into v_id, v_sal, v_comm;
        EXIT WHEN v_emp%NOTFOUND;
        if v_comm is not null then
            DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_sal || ' ' || v_comm);
        else
            DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_sal);
        end if;
    END LOOP;
    
    close v_emp;
END;
/

--EXERCITII
--1a cursoare clasice
DECLARE
    cursor j is select job_id, job_title
                from jobs;
    cursor e(job_curent varchar2) is select first_name, salary
                                        from employees
                                        where job_id = job_curent;
    nume employees.first_name%type;
    salariu employees.salary%type;
    titlu_job jobs.job_title%type;
    job jobs.job_id%type;
BEGIN
    open j;
    loop
        fetch j into job, titlu_job;
        exit when j%notfound;
        
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(titlu_job);
        dbms_output.put_line('-------------------------------------');
        
        open e(job);
        loop
            fetch e into nume, salariu;
            exit when e%notfound;

            dbms_output.put_line('Angajatul ' || nume || ' are salariul ' || salariu);
        end loop;
        
        if e%rowcount = 0 then
            dbms_output.put_line('Fara angajati');
        end if;
        close e;
    end loop;
    close j;
END;
/

--b ciclu cursoare
DECLARE
    cursor c1 is select job_id, job_title
                from jobs;
    cursor c2(job_curent varchar2) is select last_name, salary
                                      from employees
                                      where job_id = job_curent;
    nr number;
BEGIN
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(i.job_title);
        dbms_output.put_line('-------------------------------------');
        nr := 0;
        for j in c2(i.job_id) loop
            nr := nr + 1;
            dbms_output.put_line('Angajatul ' || j.last_name || ' are salariul ' || j.salary);
        end loop;
        
        if nr = 0 then
            dbms_output.put_line('Fara angajati');
        end if;
    end loop;
END;
/

--c ciclu cursoare cu subcereri
DECLARE
    nr number;
BEGIN
    for j in (select job_id, job_title from jobs) loop
        dbms_output.put_line(j.job_title);
        nr := 0;
        for e in (select last_name, salary from employees where job_id = j.job_id) loop
            nr := nr + 1;
            dbms_output.put_line('Angajatul ' || e.last_name || ' are salariul ' || e.salary);
        end loop;
        
        if nr = 0 then
            dbms_output.put_line('Fara angajati');
        end if;
    end loop;
END;
/

--d expresii cursor
DECLARE
    type refcursor is ref cursor;
    cursor c_job is select job_title,
                    cursor (select last_name, salary
                            from employees e
                            where e.job_id = j.job_id)
                    from jobs j;
    nume employees.last_name%type;
    salariu employees.salary%type;
    titlu_job jobs.job_title%type;
    v_cursor refcursor;
BEGIN
    open c_job;
    
    loop
        fetch c_job into titlu_job, v_cursor;
        exit when c_job%notfound;
        
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(titlu_job);
        dbms_output.put_line('-------------------------------------');
        
        loop
            fetch v_cursor into nume, salariu;
            exit when v_cursor%notfound;

            dbms_output.put_line('Angajatul ' || nume || ' are salariul ' || salariu);
        end loop;
        
        if v_cursor%rowcount = 0 then
            dbms_output.put_line('Fara angajati');
        end if;
    end loop;
    
    close c_job;
END;
/

--2
DECLARE
    cursor c1 is select job_id, job_title
                from jobs;
    cursor c2(job_curent varchar2) is select last_name, salary
                                      from employees
                                      where job_id = job_curent;
    nr number := 0;
    total_salary_job number := 0;
    total_salary number := 0;
    total_nr number := 0;
BEGIN
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(i.job_title);
        dbms_output.put_line('-------------------------------------');
        
        nr := 0;
        total_salary_job := 0;
        
        for j in c2(i.job_id) loop
            nr := nr + 1;
            total_salary_job := total_salary_job + j.salary;
            
            dbms_output.put_line('Angajatul ' || j.last_name || ' are salariul ' || j.salary);
        end loop;
        
        if nr = 0 then
            dbms_output.put_line('Nu exista angajati care lucreaza pe acest post.');
        elsif nr = 1 then
            dbms_output.put_line(nr || ' angajat lucreaza pe acest post');
        else
            dbms_output.put_line(nr || ' angajati lucreaza pe acest post');
        end if;
        
        dbms_output.put_line('Valoarea lunara a veniturilor angajatilor este: ' || total_salary_job);
        dbms_output.put_line('Valoarea medie a veniturilor angajatilor este: ' || total_salary_job / nr);
    
        total_salary := total_salary + total_salary_job;
        total_nr := total_nr + nr;
        
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
    
    dbms_output.put_line('Numarul total de angajati este: ' || total_nr);
    dbms_output.put_line('Valoarea totala lunara a veniturilor angajatilor este: ' || total_salary);
    dbms_output.put_line('Valoarea medie a veniturilor angajatilor este: ' || total_salary / total_nr);
END;
/

--3
DECLARE
    cursor c1 is select job_id, job_title
                from jobs;
    cursor c2(job_curent varchar2) is select last_name, salary, commission_pct
                                      from employees
                                      where job_id = job_curent;
    nr number := 0;
    total_salary_job number := 0;
    total_salary number := 0;
    total_nr number := 0;
    percent_commission number := 0;
    total_salary_commission number := 0;
BEGIN
    select sum(salary) + sum(salary * commission_pct)
    into total_salary_commission
    from employees;
    
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(i.job_title);
        dbms_output.put_line('-------------------------------------');
        
        nr := 0;
        total_salary_job := 0;
        
        for j in c2(i.job_id) loop
            nr := nr + 1;
            total_salary_job := total_salary_job + j.salary;
            
            dbms_output.put_line('Angajatul ' || j.last_name || ' are salariul ' || j.salary || ' si castiga ' || (j.salary + (j.salary * nvl(j.commission_pct, 0))) * 100 / total_salary_commission || '% din suma totala alocata lunar');
        end loop;
        
        if nr = 0 then
            dbms_output.put_line('Nu exista angajati care lucreaza pe acest post.');
        elsif nr = 1 then
            dbms_output.put_line(nr || ' angajat lucreaza pe acest post');
        else
            dbms_output.put_line(nr || ' angajati lucreaza pe acest post');
        end if;
        
        dbms_output.put_line('Valoarea lunara a veniturilor angajatilor este: ' || total_salary_job);
        dbms_output.put_line('Valoarea medie a veniturilor angajatilor este: ' || total_salary_job / nr);
    
        total_salary := total_salary + total_salary_job;
        total_nr := total_nr + nr;
        
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
    
    dbms_output.put_line('Numarul total de angajati este: ' || total_nr);
    dbms_output.put_line('Valoarea totala lunara a veniturilor angajatilor este: ' || total_salary);
    dbms_output.put_line('Valoarea medie a veniturilor angajatilor este: ' || total_salary / total_nr);
    dbms_output.put_line('Suma totala alocata lunar pentru plata salariilor si a comisioanelor tuturor angajatilor este: ' || total_salary_commission);

END;
/

--4
DECLARE
    cursor c1 is select job_id, job_title
                from jobs;
    cursor c2(job_curent varchar2) is select last_name, salary
                                      from employees
                                      where job_id = job_curent
                                      order by salary desc;
    nr number := 0;
BEGIN
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(i.job_title);
        dbms_output.put_line('-------------------------------------');
        
        nr := 0;
        
        for j in c2(i.job_id) loop
            nr := nr + 1;
            dbms_output.put_line('Pozitia ' || nr || ': ' || j.last_name || ' cu salariul ' || j.salary);
            exit when nr = 5;
        end loop;
        
        if nr < 5 then
            dbms_output.put_line('Lucreaza mai putin de 5 angajati pe acest post');
        end if;
        
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
END;
/

--5
DECLARE
    cursor c1 is select job_id, job_title
                from jobs;
    cursor c2(job_curent varchar2) is select last_name, salary
                                      from employees
                                      where job_id = job_curent
                                      order by salary desc;
    nr number := 0;
    salary employees.salary%type := -1;
BEGIN
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line(i.job_title);
        dbms_output.put_line('-------------------------------------');
        
        nr := 0;
        salary := -1;
        for j in c2(i.job_id) loop
            if salary <> j.salary then
                nr := nr + 1;
                salary := j.salary;
            end if;

            dbms_output.put_line('Pozitia ' || nr || ': ' || j.last_name || ' cu salariul ' || j.salary);
            exit when nr = 5;
        end loop;
        
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
END;
/

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