create sequence sequence_av
start with 207
increment by 1
minvalue 207
nocycle
nocache;

drop sequence sequence_av;

create or replace package ex1_av as
--a
procedure add_emp(v_first_name emp_av.first_name%type,
                  v_last_name emp_av.last_name%type,
                  v_phone_number emp_av.phone_number%type,
                  v_email emp_av.email%type);

function sal(v_dept_id emp_av.department_id%type,
             v_job_id emp_av.job_id%type)
return number;

function id_manager(v_first_name emp_av.first_name%type,
                    v_last_name emp_av.last_name%type)
return number;

function id_dept(v_dept_name dept_av.department_name%type)
return number;

function id_job(v_job_name jobs.job_title%type)
return varchar2;

--b
procedure change_dept(v_first_name emp_av.first_name%type,
                      v_last_name emp_av.last_name%type,
                      v_dept_name dept_av.department_name%type,
                      v_job_name jobs.job_title%type,
                      v_manager_first_name emp_av.first_name%type,
                      v_manager_last_name emp_av.last_name%type);

function commission(v_dept_id emp_av.department_id%type,
                    v_job_id emp_av.job_id%type)
return number;

--c
function nr_subordinates(v_first_name emp_av.first_name%type,
                         v_last_name emp_av.last_name%type)
return number;

--d
procedure promovation(v_first_name emp_av.first_name%type,
                      v_last_name emp_av.last_name%type);

--e
procedure update_salary(v_last_name emp_av.last_name%type,
                        v_salary emp_av.salary%type);

--f
cursor cursor_f(v_job_id jobs.job_id%type)
return emp_av%rowtype;

--g
cursor cursor_g
return jobs%rowtype;

--h
procedure jobs_list;

end ex1_av;
/

create or replace package body ex1_av as
--f
cursor cursor_f(v_job_id jobs.job_id%type)
return emp_av%rowtype is
    select *
    from emp_av
    where job_id = v_job_id;

--g
cursor cursor_g
return jobs%rowtype is
    select *
    from jobs;

--a
function sal(v_dept_id emp_av.department_id%type,
             v_job_id emp_av.job_id%type)
return number is
    v_sal emp_av.salary%type;
begin
    select min(salary) into v_sal
    from emp_av
    where department_id = v_dept_id
    and job_id = v_job_id;
    
    return v_sal;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista angajati care lucreaza in acest departament si la acest job.');
    when others then
        dbms_output.put_line('Alta eroare!');
end sal;

function id_manager(v_first_name emp_av.first_name%type,
                    v_last_name emp_av.last_name%type)
return number is
    v_manager_id emp_av.employee_id%type;
begin
    select employee_id into v_manager_id
    from emp_av
    where v_first_name = first_name
    and v_last_name = last_name;
    
    return v_manager_id;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista angajati cu numele dat.');
    when TOO_MANY_ROWS then
        dbms_output.put_line('Exista mai multi angajati cu numele dat.');
    when others then
        dbms_output.put_line('Alta eroare!');
end id_manager;

function id_dept(v_dept_name dept_av.department_name%type)
return number is
    v_dept_id emp_av.department_id%type;
begin
    select department_id into v_dept_id
    from dept_av
    where v_dept_name = department_name;
    
    return v_dept_id;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista departament cu numele dat.');
    when TOO_MANY_ROWS then
        dbms_output.put_line('Exista mai multe departamente cu numele dat.');
    when others then
        dbms_output.put_line('Alta eroare!');
end id_dept;

function id_job(v_job_name jobs.job_title%type)
return varchar2 is
    v_job_id emp_av.job_id%type;
begin
    select job_id into v_job_id
    from jobs
    where v_job_name = job_title;
    
    return v_job_id;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista job cu numele dat.');
    when TOO_MANY_ROWS then
        dbms_output.put_line('Exista mai multe job-uri cu numele dat.');
    when others then
        dbms_output.put_line('Alta eroare!');
end id_job;

procedure add_emp(v_first_name emp_av.first_name%type,
                  v_last_name emp_av.last_name%type,
                  v_phone_number emp_av.phone_number%type,
                  v_email emp_av.email%type) is
    v_salary emp_av.salary%type;
    v_manager_id emp_av.employee_id%type;
    v_dept_id emp_av.department_id%type;
    v_job_id emp_av.job_id%type;
begin
    v_manager_id := id_manager('Douglas', 'Grant');
    v_dept_id := id_dept('Administration');
    v_job_id := id_job('Accountant');
    v_salary := sal(v_dept_id, v_job_id);
    
    insert into emp_av values(sequence_av.nextval, v_first_name, v_last_name, v_email, v_phone_number, sysdate, v_job_id, v_salary, null, v_manager_id, v_dept_id);
end add_emp;

--b
function commission(v_dept_id emp_av.department_id%type,
                    v_job_id emp_av.job_id%type)
return number is
    v_commission_pct emp_av.commission_pct%type;
begin
    select min(commission_pct) into v_commission_pct
    from emp_av
    where department_id = v_dept_id
    and job_id = v_job_id;
    
    return v_commission_pct;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista angajati care lucreaza in acest departament si la acest job.');
    when others then
        dbms_output.put_line('Alta eroare!');
end commission;
    
procedure change_dept(v_first_name emp_av.first_name%type,
                      v_last_name emp_av.last_name%type,
                      v_dept_name dept_av.department_name%type,
                      v_job_name jobs.job_title%type,
                      v_manager_first_name emp_av.first_name%type,
                      v_manager_last_name emp_av.last_name%type) is
    v_salary emp_av.salary%type;
    v_manager_id emp_av.employee_id%type;
    v_dept_id emp_av.department_id%type;
    v_job_id emp_av.job_id%type;
    v_emp_id emp_av.employee_id%type;
    v_commission_pct emp_av.commission_pct%type;
    v_ex_hire_date emp_av.hire_date%type;
    v_ex_job_id emp_av.job_id%type;
    v_ex_dept_id emp_av.department_id%type;
begin
    v_manager_id := id_manager(v_manager_first_name, v_manager_last_name);
    v_dept_id := id_dept(v_dept_name);
    v_job_id := id_job(v_job_name);
    v_emp_id := id_manager(v_first_name, v_last_name);
    v_commission_pct := commission(v_dept_id, v_job_id);
    
    select salary into v_salary
    from emp_av
    where employee_id = v_emp_id;
    
    if (v_salary < sal(v_dept_id, v_job_id)) then
        v_salary := sal(v_dept_id, v_job_id);
    end if;
    
    select hire_date into v_ex_hire_date
    from emp_av
    where employee_id = v_emp_id;
    
    select job_id into v_ex_job_id
    from emp_av
    where employee_id = v_emp_id;
    
    select department_id into v_ex_dept_id
    from emp_av
    where employee_id = v_emp_id;
    
    update emp_av
    set department_id = v_dept_id,
        job_id = v_job_id,
        manager_id = v_manager_id,
        salary = v_salary,
        commission_pct = v_commission_pct,
        hire_date = sysdate
    where employee_id = v_emp_id;
    
    insert into job_history_av values (v_emp_id, v_ex_hire_date, sysdate, v_ex_job_id, v_ex_dept_id);
end change_dept;

--c
function nr_subordinates(v_first_name emp_av.first_name%type,
                         v_last_name emp_av.last_name%type)
return number is
    nr_emp number;
begin
    select count(employee_id) - 1 into nr_emp
    from emp_av
    start with last_name = v_last_name and first_name = v_first_name
    connect by manager_id = prior employee_id;
    
    if nr_emp = 0 then
        raise NO_DATA_FOUND;
        return -1;
    end if;
    
    return nr_emp;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista manager cu numele dat.');
    when TOO_MANY_ROWS then
        dbms_output.put_line('Exista mai multi manageri cu numele dat.');
    when others then
        dbms_output.put_line('Alta eroare!');
end nr_subordinates;

--d
procedure promovation(v_first_name emp_av.first_name%type,
                      v_last_name emp_av.last_name%type) is
    v_emp_id emp_av.employee_id%type;
    v_manager_id emp_av.employee_id%type;
    type tab_imb is table of emp_av.employee_id%type;
    t tab_imb := tab_imb();
begin
    select employee_id
    into v_emp_id
    from emp_av
    where last_name = v_last_name and first_name = v_first_name;
    
    select manager_id
    into v_manager_id
    from emp_av
    where employee_id = v_emp_id;
    
    select employee_id bulk collect into t
    from emp_av
    where manager_id = v_manager_id;
    
    for i in t.first..t.last loop
        if t.exists(i) then
            update emp_av
            set manager_id = v_manager_id
            where employee_id = t(i) and employee_id != v_emp_id;
        end if;
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista angajat cu numele dat.');
    when TOO_MANY_ROWS then
        dbms_output.put_line('Exista mai multi angajati cu numele dat.');
    when others then
        dbms_output.put_line('Alta eroare!');
end promovation;

--e
procedure update_salary(v_last_name emp_av.last_name%type,
                        v_salary emp_av.salary%type) is
    v_sal_max number;
    v_sal_min number;
    nr_emp number;
    type emp_same_name is table of emp_av%rowtype index by pls_integer;
    t emp_same_name;
begin
    select * bulk collect into t
    from emp_av
    where last_name = v_last_name;
    
    select count(*) into nr_emp
    from emp_av
    where last_name = v_last_name;
    
    if nr_emp > 1 then
        raise TOO_MANY_ROWS;
    elsif nr_emp > 0 then
        select min_salary into v_sal_min
        from jobs
        where job_id = (select job_id
                        from emp_av
                        where last_name = v_last_name);
                        
        select max_salary into v_sal_max
        from jobs
        where job_id = (select job_id
                        from emp_av
                        where last_name = v_last_name);
        
        if v_salary >= v_sal_min and v_salary <= v_sal_max then
            update emp_av
            set salary = v_salary
            where last_name = v_last_name;
            
            dbms_output.put_line('Noul salariu al angajatului cu numele ' || v_last_name || ': ' || v_salary);
        else
            dbms_output.put_line('Noul salariu nu respecta limitele impuse pentru acest job!');
        end if;
    else
        raise NO_DATA_FOUND;
    end if;
exception 
    when NO_DATA_FOUND then 
        dbms_output.put_line('Nu exista angajat cu numele dat.');

    when TOO_MANY_ROWS then  
        dbms_output.put_line('Exista mai multi angajati cu numele dat. Acestia sunt: ');
        
        for i in t.first..t.last loop
            if t.exists(i) then
                dbms_output.put_line('   ' || t(i).last_name || ' ' || t(i).first_name);
            end if;
        end loop;
end update_salary;

--h
procedure jobs_list is
    nr_emp number := 0;
    my_list emp_av%rowtype;
    job_count number := 0;
begin
    for i in cursor_g loop
        dbms_output.put_line('Nume job: ' || i.job_title);
        dbms_output.put_line('Lista angajati:');
        
        select count(employee_id) into nr_emp
        from emp_av
        where job_id = i.job_id;
        
        if nr_emp > 0 then
            for j in cursor_f(i.job_id) loop
                select count(employee_id) into job_count
                from emp_av join job_history_av using (employee_id)
                where employee_id = j.employee_id;
                
                if job_count > 0 then
                    dbms_output.put_line('  ' || j.last_name || ' ' || j.first_name ||  ' a mai avut jobul in trecut.');
                else
                    dbms_output.put_line('  ' || j.last_name || ' ' || j.first_name ||  ' nu a mai avut jobul in trecut.');
                end if;
            
                job_count := 0;
            end loop;
        else
            dbms_output.put_line('  Nu exista angajati cu acest job.');
        end if;

        dbms_output.new_line();
    end loop;
end jobs_list;

end ex1_av;
/

--verificare punctul a
begin
    ex1_av.add_emp('Ion', 'Popescu', '0123.456.789', 'ion@yahoo.com');
end;
/

--verificare punctul b
begin
    ex1_av.change_dept('William', 'Gietz', 'Administration', 'President', 'David', 'Austin');
end;
/

--verificare punctul c
begin
    dbms_output.put_line('King Steven are ' || ex1_av.nr_subordinates('King', 'Steven') || ' subalterni');
exception 
    when others then
        dbms_output.put_line('Cod eroare = ' || sqlcode);
end;
/

select * from emp_av join jobs using (job_id);

--verificare punctul e
begin
    ex1_av.update_salary('Tobias', 35000);
end;
/

begin
    ex1_av.update_salary('King', 35000);
end;
/

begin
    ex1_av.update_salary('Austin', 4900);
end;
/

rollback;
/


--verificare punctul h
begin
    ex1_av.jobs_list; 
end;
/

select employee_id
from job_history_av join employees using (employee_id);

select employee_id, last_name, first_name, job_title
from emp_av join jobs using (job_id)
where employee_id in (101, 102, 114, 122, 176, 200, 201);