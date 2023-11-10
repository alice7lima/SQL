-- Select que retorna comandos que geram partições para uma tabela

SELECT TO_CHAR(ADD_MONTHS(to_date('01-01-1989', 'dd-mm-yyyy'), (ROWNUM - 1)), 'MM') mes, 
		TO_NUMBER(TO_CHAR(ADD_MONTHS(to_date('01-01-1990', 'dd-mm-yyyy'), (ROWNUM - 1)), 'YYYY')) ano,
		TO_CHAR(ADD_MONTHS(to_date('01-01-1900', 'dd-mm-yyyy'), (ROWNUM - 1)), 'MON') || '_' || TO_CHAR(ADD_MONTHS(to_date('01-01-1990','dd-mm-yyyy'), (ROWNUM - 1)), 'YYYY') MES_ANO, 
		'PARTITION ' || TO_CHAR(ADD_MONTHS(to_date('01-01-1990', 'dd-mm-yyyy'), (ROWNUM - 1)), 'MON') || '_' || TO_CHAR(ADD_MONTHS(to_date('01-01-1990', 'dd-mm-yyyy'), (ROWNUM - 1)), 'YYYY') || 
		' VALUES LESS THAN (TO_DATE(''' || 
		DECODE(TO_CHAR(ADD_MONTHS(to_date('01-01-1990','dd-mm-yyyy'), (ROWNUM - 1)), 'MM'), 12, EXTRACT( YEAR FROM ADD_MONTHS(to_date('01-01-1990','dd-mm-yyyy'), (ROWNUM - 1)) ) + 1, 
		TO_CHAR(ADD_MONTHS(to_date('01-01-1990','dd-mm-yyyy'), (ROWNUM - 1)), 'YYYY'))
		|| '-' || 
		CASE  
			WHEN EXTRACT( MONTH FROM ADD_MONTHS(to_date('01-01-1990','dd-mm-yyyy'), (ROWNUM - 1)) )  = 12 THEN '01'
			WHEN EXTRACT( YEAR FROM ADD_MONTHS(to_date('01-01-1990', 'dd-mm-yyyy'), (ROWNUM - 1)) )  > 8 
			THEN TO_CHAR(EXTRACT( MONTH FROM ADD_MONTHS(to_date('01-01-1990', 'dd-mm-yyyy'), (ROWNUM - 1)))+1)
			ELSE '0' || TO_CHAR(EXTRACT( MONTH FROM ADD_MONTHS(to_date('01-01-1990','dd-mm-yyyy'), (ROWNUM - 1)))+1)
		END
		|| '-1'''  || ',''YYYY-MM-DD'')),' comando
		
		FROM dba_tables
	WHERE ROWNUM <= MONTHS_BETWEEN (TO_DATE('01-01-2041','DD-MM-YYYY'),TO_DATE('01-01-1990','DD-MM-YYYY'));