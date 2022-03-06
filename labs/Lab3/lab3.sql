--TEMA: 6, ex: 2b), 3, 4, 5

--3V1
variable g_mesaj VARCHAR2(50)

begin
    :g_mesaj := 'Invat PL/SQL';
end;
/
print g_mesaj

--3V2
begin
    dbms_output.put_line('Invat PL/SQL');
end;
/

--3V3
VARIABLE g_mesaj VARCHAR2(35)
Exec :g_mesaj := 'Invat PL/SQL';
print g_mesaj

--4
DECLARE
    v_dep departments.department_name%TYPE;
BEGIN
    select department_name into v_dep
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    DBMS_OUTPUT.PUT_LINE('Departamentul ' || v_dep);
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multe linii');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nicio linie');
END;
/

--5
VARIABLE rezultat VARCHAR2(35)
BEGIN
    select department_name
    into :rezultat
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    DBMS_OUTPUT.PUT_LINE('Departamentul ' || :rezultat);
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multe linii');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nicio linie');
END;
/
PRINT rezultat

--6
VARIABLE departament VARCHAR2(35)
VARIABLE numarAngajati NUMBER(8)
BEGIN
    select department_name, count(*)
    into :departament, :numarAngajati
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    DBMS_OUTPUT.PUT_LINE('Departamentul ' || :departament || ' are ' || :numarAngajati || ' angajati.');
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multe linii');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nicio linie');
END;
/
PRINT departament
PRINT numarAngajati

--7
set verify off
declare
    v_cod employees.employee_id%type:=&p_cod;
    v_bonus number(8);
    v_salariu_anual number(8);
begin
    select salary*12 into v_salariu_anual
    from employees
    where employee_id = v_cod;
    if v_salariu_anual >= 200001
        then v_bonus:=20000;
    elsif v_salariu_anual between 100001 and 200000
        then v_bonus:=10000;
    else v_bonus:=5000;
    end if;

    dbms_output.put_line('Bonusul este '||v_bonus);
exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Niciun angajat gasit cu acest id'); 
end;
/
set verify on

set verify off
declare
    v_cod employees.employee_id%type:=&p_cod;
    v_bonus number(8);
    v_salariu_anual number(8);
begin
    select salary*12 into v_salariu_anual
    from employees
    where employee_id = &p_cod;
    if v_salariu_anual >= 200001
        then v_bonus:=20000;
    elsif v_salariu_anual between 100001 and 200000
        then v_bonus:=10000;
    else v_bonus:=5000;
    end if;

    dbms_output.put_line('Bonusul este '||v_bonus);
exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nu exista angajatul '||&p_cod); 
end;
/
set verify on

--8
declare
    v_cod employees.employee_id%type:=&p_codd;
    v_bonus number(8);
    v_salariu_anual number(8);
begin
    select salary*12 into v_salariu_anual
    from employees
    where employee_id = v_cod;
    case when v_salariu_anual >= 200001
                then v_bonus:=20000;
         when v_salariu_anual between 100001 and 200000
                then v_bonus:=10000;
         else v_bonus:=5000;
    end case;

    dbms_output.put_line('Bonusul este '||v_bonus);
exception
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nu exista angajatul '||v_bonus); 
end;
/

--9
select employee_id, department_id, salary
from emp_av
where employee_id = 150;

define p_cod_sal = 200
define p_cod_dept = 80
define p_procent = 20

undefine p_cod_sal;
undefine p_cod_dept;
undefine p_procent;

declare
    v_cod_sal emp_av.employee_id%type:=&p_cod_sal;
    v_cod_dept emp_av.department_id%type:=&p_cod_dept;
    v_procent number(8):=&p_procent;
begin
    update emp_av
    set department_id = v_cod_dept, salary = salary+(salary*v_procent/100)
    where employee_id = v_cod_sal;

    if sql%rowcount=0 then
        dbms_output.put_line('Nu exista un angajat cu acest cod');
    else dbms_output.put_line('Actualizare realizata');
    end if;
end;
/
rollback;

--10
create table zile_av
(id number(2),
data date,
nume_zi VARCHAR2(20));

drop table zile_av;

declare
    contor number(6) := 1;
    v_data date;
    maxim number(2) := last_day(sysdate)-sysdate;
begin
    loop
        v_data := sysdate+contor;
        insert into zile_av
        values (contor,v_data,to_char(v_data,'Day'));
        contor := contor + 1;
        exit when contor > maxim;
    end loop;
end;
/

select * from zile_av;

--11
declare
    contor number(6) := 1;
    v_data date;
    maxim number(2) := last_day(sysdate)-sysdate;
begin
    while contor <= maxim loop
        v_data := sysdate+contor;
        insert into zile_av
        values (contor,v_data,to_char(v_data,'Day'));
        contor := contor + 1;
    end loop;
end;
/

--12
declare
    contor number(6) := 1;
    v_data date;
    maxim number(2) := last_day(sysdate)-sysdate;
begin
    for contor in 1..maxim loop
        v_data := sysdate+contor;
        insert into zile_av
        values (contor,v_data,to_char(v_data,'Day'));
    end loop;
end;
/

--13
--V1
declare
    i positive := 1;
    max_loop constant positive := 10;
begin
    loop
        i := i + 1;
        if i > max_loop then
            dbms_output.put_line('in loop i = ' || i);
            goto urmator;
        end if;
    end loop;
<<urmator>>
i := 1;
dbms_output.put_line('dupa loop i = ' || i);
end;
/

--V2
declare
    i positive:=1;
    max_loop constant positive:=10;
begin
    i:=1;
    loop
        i:=i+1;
        dbms_output.put_line('in loop i=' || i);
        exit when i > max_loop;
    end loop;
    i:=1;
    dbms_output.put_line('dupa loop i=' || i);
end;
/

----Exercitii
--1
declare
    numar number(3):=100;
    mesaj1 varchar2(255):='text 1';
    mesaj2 varchar2(255):='text 2';
begin
    declare
        numar number(3):=1;
        mesaj1 varchar2(255):='text 2';
        mesaj2 varchar2(255):='text 3';
    begin
        numar:=numar+1;
        dbms_output.put_line('numar subbloc ' || numar);
        mesaj2:=mesaj2||' adaugat in sub-bloc';
        dbms_output.put_line('mesaj 2 subbloc ' || mesaj2);
    end;
    
    numar:=numar+1;
    dbms_output.put_line('numar bloc ' || numar);
    mesaj1:=mesaj1||' adaugat un blocul principal';
    dbms_output.put_line('mesaj 1 bloc ' || mesaj1);
    mesaj2:=mesaj2||' adaugat in blocul principal'; 
    dbms_output.put_line('mesaj 2 bloc ' || mesaj2);
end;
/

--2
--a = 12 c)
select ziua, (select count(*) from rental where to_char(book_date, 'dd.mm.yyyy') = to_char(ziua,'dd.mm.yyyy')) as nr
from (select trunc(add_months(sysdate,-1), 'month') + level-1 ziua
      from dual
      connect by level <= extract (day from last_day(add_months(sysdate,-1))));
      
--b
create table septembrie_av(id number, data date);
drop table septembrie_av;

--PL/SQL
declare
    d date := trunc(sysdate, 'mm');
    n number := extract (day from last_day(sysdate));
begin
    for i in 1..n loop
        insert into octombrie_av
        values (i, d);
        d := d+1;
    end loop;
end;
/

--SQL
create table octombrie_av(id number, data date);

drop table octombrie_av;

select * from octombrie_av;

insert into octombrie_av (id, data)
select level, trunc(sysdate, 'month') + level-1 ziua
from dual
connect by level <= extract (day from last_day(sysdate));

--3
set verify off
DECLARE
    nrFilme NUMBER(5);
    v_nume member.last_name%TYPE := '&p_nume';
BEGIN
    select count(*)
    into nrFilme
    from rental r, member m
    where last_name = v_nume
    and r.member_id = m.member_id
    group by last_name;
    
    DBMS_OUTPUT.PUT_LINE('Numarul de filme pe care ' || v_nume || ' le-a imprumutat este ' || nrFilme || '.');
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multi angajati care au imprumutat carti cu acest nume!');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat care a imprumutat carti cu acest nume.');

END;
/
set verify on

--4
DECLARE
    nrFilme NUMBER(5);
    v_nume member.last_name%TYPE := '&p_nume';
    nrTotal NUMBER(5);
BEGIN
    select count(*)
    into nrTotal
    from title;
    
    select count(*)
    into nrFilme
    from rental r, member m
    where last_name = v_nume
    and r.member_id = m.member_id
    group by last_name;
    
    case when nrFilme/nrTotal*100 >= 75
                then DBMS_OUTPUT.PUT_LINE('Categoria 1 (a imprumutat mai mult de 75% din titlurile existente)');
         when nrFilme/nrTotal*100 between 50 and 75
                then DBMS_OUTPUT.PUT_LINE('Categoria 2 (a imprumutat mai mult de 50% din titlurile existente)');
         when nrFilme/nrTotal*100 between 25 and 50
                then DBMS_OUTPUT.PUT_LINE('Categoria 3 (a imprumutat mai mult de 25% din titlurile existente)');
         else DBMS_OUTPUT.PUT_LINE('Categoria 4 (altfel)');
    end case;
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multi angajati care au imprumutat carti cu acest nume!');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat care a imprumutat carti cu acest nume.');
END;
/

--5
create table member_av as select * from member;

select * from member_av;

alter table member_av
add discount varchar2(5);

DECLARE
    nrFilme NUMBER(5);
    v_nume member.last_name%TYPE := '&p_numee';
    nrTotal NUMBER(5);
BEGIN
    select count(*)
    into nrTotal
    from title;
    
    select count(*)
    into nrFilme
    from rental r, member m
    where last_name = v_nume
    and r.member_id = m.member_id
    group by last_name;
    
    case when nrFilme/nrTotal*100 >= 75
                then update member_av set discount = '10%' where last_name = v_nume;
         when nrFilme/nrTotal*100 between 50 and 75
                then update member_av set discount = '5%' where last_name = v_nume;
         when nrFilme/nrTotal*100 between 25 and 50
                then update member_av set discount = '3%' where last_name = v_nume;
    end case;
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Prea multi angajati care au imprumutat carti cu acest nume!');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat care a imprumutat carti cu acest nume.');
END;
/