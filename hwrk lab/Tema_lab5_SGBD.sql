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

--2 b) SQL
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
        DBMS_OUTPUT.PUT_LINE('Exista prea multi angajati care au imprumutat carti cu acest nume!');
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
        DBMS_OUTPUT.PUT_LINE('Exista prea multi angajati care au imprumutat carti cu acest nume!');
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
                then update member_av set discount = '10%' where last_name = v_nume;
         when nrFilme/nrTotal*100 between 50 and 75
                then update member_av set discount = '5%' where last_name = v_nume;
         when nrFilme/nrTotal*100 between 25 and 50
                then update member_av set discount = '3%' where last_name = v_nume;
         else NULL;
    end case;
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE('Exista prea multi angajati care au imprumutat carti cu acest nume!');
    when no_data_found then
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat care a imprumutat carti cu acest nume.');
END;
/