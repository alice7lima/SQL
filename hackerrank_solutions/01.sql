-- Problem: Draw The Triangle 1

select * from (
select rpad( '* ', level*2, '* ' ) a
from dual
connect by level <= 20)
order by a desc;