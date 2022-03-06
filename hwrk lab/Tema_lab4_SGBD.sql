--10
select last_name || ' ' || first_name as name, copy_id, title, count(*) as "RENT NUMBER"
from member m, title t, rental r
where m.member_id = r.member_id
and t.title_id = r.title_id
group by m.last_name, m.first_name, copy_id, t.title
order by 1;

--12a
select to_char(book_date) as "Book date", count(*) as "Numar imprumuturi A"
from rental
where to_char(book_date) = ('01-' || (select to_char(sysdate, 'MON-YY') from dual))
or to_char(book_date) = ('02-' || (select to_char(sysdate, 'MON-YY') from dual))
group by to_char(book_date);

--12b
select to_char(book_date) as "Book date", count(*) as "Numar imprumuturi B"
from rental
where to_char(book_date) in (select distinct substr(to_char(book_date), 1, 3) || (select to_char(sysdate, 'MON-YY') from dual)
                             from rental)
group by to_char(book_date);

--12c
select to_char(book_date) as "Book date", count(*) as "Numar imprumuturi C"
from rental
where to_char(book_date) in (select rownum || '-' || (select to_char(sysdate, 'MON-YY') from dual)
                             from rental, all_objects
                             where rownum <= to_number(substr(to_char(last_day(sysdate)), 1, 2)))
group by to_char(book_date);


-----
select employee_id, last_name, manager_id, level
from employees
connect by prior employee_id = manager_id;


--daca dorim sa incepem de la un anumit nr
select level + 5, rownum
from dual
connect by level <= extract (day from last_day(add_months(sysdate,-1)));


select trunc(add_moths(sysdate,-1),'mm') + level-1
from dual
connect by level <= extract (day from last_day(add_months(sysdate,-1)));

select ziua, (select count(*) from rental where to_char(book_date, 'dd.mm.yyyy') = to_char(ziua,'dd.mm.yyyy')) as nr
from (select trunc(add_months(sysdate,-1), 'month') + level-1 ziua
      from dual
      connect by level <= extract (day from last_day(add_months(sysdate,-1))));