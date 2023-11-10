-- Problem: Draw The Triangle 2

select rpad( '* ', level*2, '* ' )
from dual
connect by level <= 20;