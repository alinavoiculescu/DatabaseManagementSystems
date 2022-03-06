--5
create or replace procedure ex5_av is
    cursor c1 is select department_id, department_name
                 from departments;
    cursor c2(department number) is select last_name, trunc(months_between(sysdate, hire_date) / 12) as vechime, salary, to_char(hire_date, 'Day') as day
                                    from employees
                                    where department_id = department
                                    and to_char(hire_date, 'Day') in (select to_char(hire_date, 'Day')
                                                                      from employees
                                                                      where department_id = department
                                                                      group by to_char(hire_date, 'Day')
                                                                      having count(*) in (select max(count(*))
                                                                                          from employees
                                                                                          where department_id = department
                                                                                          group by to_char(hire_date, 'Day')));
    nr number;
begin
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line('DEPARTAMENT ' || i.department_name);
        dbms_output.put_line('-------------------------------------');
        nr := 0;
        for j in c2(i.department_id) loop
            if nr = 0 then
                nr := 1;
                dbms_output.put_line('Ziua din saptamana in care au fost angajate cele mai multe persoane: ' || j.day);
            end if;
            
            nr := nr + 1;
            
            dbms_output.put_line('Nume: ' || j.last_name || '; Vechime: ' || j.vechime ||' ani; Venit lunar: ' || j.salary);
        end loop;
        
        if nr = 0 then
            dbms_output.put_line('Nu lucreaza angajati in acest departament.');
        end if;
    end loop;
end;
/

begin
    ex5_av;
end;
/

--6
create or replace procedure ex6_av is
    cursor c1 is select department_id, department_name
                 from departments;
    cursor c2(department number) is select last_name, trunc(months_between(sysdate, hire_date) / 12) as vechime, salary, to_char(hire_date, 'Day') as day
                                    from employees
                                    where department_id = department
                                    and to_char(hire_date, 'Day') in (select to_char(hire_date, 'Day')
                                                                      from employees
                                                                      where department_id = department
                                                                      group by to_char(hire_date, 'Day')
                                                                      having count(*) in (select max(count(*))
                                                                                          from employees
                                                                                          where department_id = department
                                                                                          group by to_char(hire_date, 'Day')))
                                    order by vechime desc;
    nr number;
    pos number := 1;
    v_vechime number;
begin
    for i in c1 loop
        dbms_output.put_line('-------------------------------------');
        dbms_output.put_line('DEPARTAMENT ' || i.department_name);
        dbms_output.put_line('-------------------------------------');
        nr := 0;
        pos := 1;
        for j in c2(i.department_id) loop
            if nr = 0 then
                nr := 1;
                v_vechime := j.vechime;
                dbms_output.put_line('Ziua din saptamana in care au fost angajate cele mai multe persoane: ' || j.day);
            end if;
            
            nr := nr + 1;
            
            if j.vechime != v_vechime then
                pos := pos + 1;
                v_vechime := j.vechime;
            end if;

            dbms_output.put_line(pos || '. Nume: ' || j.last_name || '; Vechime: ' || j.vechime ||' ani; Venit lunar: ' || j.salary);
        end loop;
        
        if nr = 0 then
            dbms_output.put_line('Nu lucreaza angajati in acest departament.');
        end if;
    end loop;
end;
/

begin
    ex6_av;
end;
/