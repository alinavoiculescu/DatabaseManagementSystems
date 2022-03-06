--tema: ex 2b) si 3

--4
select max(category), max(count(*))
from title t, rental r
where t.title_id = r.title_id
group by category;

select category, count(*), count(distinct title), count(r.copy_id) 
from title t, rental r
where t.title_id = r.title_id
group by category
having (category, count(*)) in (select max(category), max(count(*))
                                from title t, rental r
                                where t.title_id = r.title_id
                                group by category);

--5
--status corect
select title_id, count(*)
from title_copy
where status = 'AVAILABLE'
group by title_id
order by 1;

--status gresit
select title_id, count(*)
from title_copy
where (copy_id, title_id) not in (select copy_id, title_id
                                  from rental
                                  where act_ret_date is null)
group by title_id
order by 1;

select title_id, count(*)
from (select copy_id, title_id
      from title_copy
           minus
      select copy_id, title_id
      from rental
      where act_ret_date is null)
group by title_id
order by 1;

--6
select title, copy_id, status status_setat,
       case when (copy_id, t.title_id) not in (select copy_id, title_id
                                             from rental
                                             where act_ret_date is null) then 'AVAILABLE'
            else 'RENTED'
       end as status_corect
from title t, title_copy tc
where t.title_id = tc.title_id;

--7a
select count(*)
from (select title, copy_id, status status_setat,
      case when (copy_id, t.title_id) not in (select copy_id, title_id
                                              from rental
                                              where act_ret_date is null) then 'AVAILABLE'
           else 'RENTED'
      end as status_corect
      from title t, title_copy tc
      where t.title_id = tc.title_id)
where status_setat <> status_corect;

with a as (select title, copy_id, status status_setat,
           case when (copy_id, t.title_id) not in (select copy_id, title_id
                                                   from rental
                                                   where act_ret_date is null) then 'AVAILABLE'
                else 'RENTED'
           end as status_corect
           from title t, title_copy tc
           where t.title_id = tc.title_id)
select count(*)
from a
where status_setat != status_corect;

--7b
create table title_copy_av as
select * from title_copy;

update title_copy_av t
set status = case when (copy_id, t.title_id) not in (select copy_id, title_id
                                                     from rental
                                                     where act_ret_date is null) then 'AVAILABLE'
                  else 'RENTED'
             end
where status <> case when (copy_id, t.title_id) not in (select copy_id, title_id
                                                        from rental
                                                        where act_ret_date is null) then 'AVAILABLE'
                     else 'RENTED'
                end;

commit;

--8
select *
from rental
where (member_id, title_id) in (select member_id, title_id
                                from reservation);

select case when count(*) = 0 then 'DA'
            else 'NU'
            end raspuns
from (select res_date, member_id, title_id
      from reservation
           minus
      select book_date, member_id, title_id
      from rental) a;
   
   
select decode(count(*), 0, 'DA', 'NU') Raspuns
from  (
        select case when (res_date, title_id, member_id) in (select book_date, title_id, member_id
                                                             from rental) then 'DA'
                    else 'NU'
               end info
        from reservation
        
      )
where info = 'NU';

--9
select last_name || ' ' || first_name as name, title, count(*) as "RENT NUMBER"
from member m, title t, rental r
where m.member_id = r.member_id
and t.title_id = r.title_id
group by m.last_name, m.first_name, t.title
order by 1;

--10
select last_name || ' ' || first_name as name, copy_id, title, count(*) as "RENT NUMBER"
from member m, title t, rental r
where m.member_id = r.member_id
and t.title_id = r.title_id
group by m.last_name, m.first_name, copy_id, t.title
order by 1;

--11
select copy_id, title_id, status
from title_copy
where (copy_id, title_id) in (select copy_id, title_id
                              from rental r
                              group by copy_id, title_id
                              having count(*) = (select max(count(*))
                                                 from rental
                                                 where title_id = r.title_id
                                                 group by copy_id, title_id));
                                                 
--12a
select count(*) as "Numar imprumuturi A"
from rental
where to_char(book_date) = ('01-' || (select to_char(sysdate, 'MON-YY') from dual))
or to_char(book_date) = ('02-' || (select to_char(sysdate, 'MON-YY') from dual));

--12b
select count(*) as "Numar imprumuturi B "
from rental
where to_char(book_date) in (select distinct substr(to_char(book_date), 1, 3) || (select to_char(sysdate, 'MON-YY') from dual)
                             from rental);

--12c
select count(*) as "Numar imprumuturi C"
from rental
where to_char(book_date) in (select rownum || '-' || (select to_char(sysdate, 'MON-YY') from dual)
                             from rental, all_objects
                             where rownum <= 31);