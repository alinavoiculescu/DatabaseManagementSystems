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

--1
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