-- Arquivo que cria e alimenta uma tabela de dimensão de datas (Oracle)

create table DM_CORPORATIVO.DIM_DATA (
   ID_DATA              NUMBER(8)             not null,			--feito
   DATA                 DATE                  not null,			--feito
   FLG_DIA_UTIL_PERIODO NUMBER(1),								--feito
   FLG_RECESSO_JUDICIARIO NUMBER(1),							--feito
   FLG_FERIADO_NACIONAL_PERIODO NUMBER(1),						--feito
   NUM_DIA_MES          NUMBER(2),								--feito
   NOM_ABREV_DIA_SEMANA VARCHAR2(4),							--feito
   NUM_MES_PERIODO      NUMBER(2),								--feito
   NOM_MES_PERIODO      VARCHAR2(20),							--feito
   NUM_ANO_PERIODO      NUMBER(4),								--feito
   NOM_ABREV_MES_PERIODO VARCHAR2(3),							--feito
   NUM_DIA_SEMANA       NUMBER(1),								--feito
   NOM_DIA_SEMANA       VARCHAR2(30),							--feito
   NUM_SEMANA_CORR_MES  NUMBER(1),								--feito
   NUM_SEMANA_CORR_ANO  NUMBER(2),								--feito
   NUM_TRIMESTRE_CORR_ANO NUMBER(1),							--feito
   NUM_MES_CORR_TRIMESTRE NUMBER(1),							--feito
   NUM_SMNA_CORR_TRIMESTRE NUMBER(2),							--feito
   NUM_DIA_CORR_TRIMESTRE NUMBER(2),							--feito
   NOM_SEMESTRE_PERIODO VARCHAR2(20),							--feito
   NUM_SEMESTRE_PERIODO NUMBER(1),								--feito
   QTD_DIAS_RESTA_ANO   NUMBER(3),								--feito
   QTD_DIAS_RESTA_BIMESTRE NUMBER(2),							--feito
   QTD_DIAS_RESTA_MES   NUMBER(2),								--feito
   QTD_DIAS_RESTA_TRIMESTRE NUMBER(2),							--feito
   QTD_DIAS_RESTA_QUADRIMESTRE NUMBER(3),						--feito
   QTD_DIAS_RESTA_SEMESTRE NUMBER(3),							--feito
   NOM_BIMESTRE_PERIODO VARCHAR2(20),							--feito
   NUM_BIMESTRE_PERIODO NUMBER(1),								--feito
   NUM_DIA_CORR_BIMESTRE NUMBER(2),								--feito
   NUM_MES_CORR_BIMESTRE NUMBER(1),								--feito
   NUM_SMNA_CORR_BIMESTRE NUMBER(2),							--feito
   NUM_DIA_CORR_QUADRIMESTRE NUMBER(3),							--feito
   NUM_MES_CORR_QUADRIMESTRE NUMBER(1),							--feito
   NUM_SMNA_CORR_QUADRIMESTRE NUMBER(2),						--feito
   NUM_DIA_CORR_SEMESTRE NUMBER(3),								--feito
   NUM_MES_CORR_SEMESTRE NUMBER(1),								--feito
   NUM_SMNA_CORR_SEMESTRE NUMBER(2),							--feito
   NUM_QUADRIMESTRE_PERIODO NUMBER(1),							--feito
   NOM_QUADRIMESTRE_PERIODO VARCHAR2(35),						--feito
   NOM_TRIMESRE_PERIODO VARCHAR2(20),						    --feito
   NOM_ESTACAO_PERIODO  VARCHAR2(20),							--feito
   SIG_ESTACAO_PERIODO  VARCHAR2(3),							--feito
   constraint PK_DIM_DATA primary key (ID_DATA)
);


DECLARE 
id_data number(8);
p_data date;
u_data date;
a_data date;
ano number(4);
dia number(2);
mes number(2);
dutil number(1);
semana varchar2(4);
nusemana number;
nmes varchar2(20);
abvmes varchar2(3);
nome_dsem varchar2(30);
ns_mes number(1);
ns_ano number(2);
trimestre number(1);
feriado number(1);
feriadojud number(1);
semana_tri number(2);
dia_tri number(2);
mes_tri number(1);
nome_semestre varchar2(20);
num_semestre number(1);
nome_trimestre varchar2(20);
--dia_ano number(3);
resta_ano number(3);
bimestre number(1);
resta_bim number(2);
resta_mes number(2);
resta_tri number(2);
resta_qua number(3);
quadrimestre number(1);
resta_sem number(3);
nome_bimestre varchar2(20);
mes_bim number(1);
dia_bim number(2);
semana_bim number(2);
semana_qua number(2);
mes_qua number(1);
dia_qua number(3);
dia_sem number(3);
mes_sem number(1);
semana_sem number(2);
nome_qua varchar2(35);
estacao  VARCHAR2(20);
sig_estacao varchar2(3);



BEGIN
p_data := TO_DATE('01-01-1900', 'DD-MM-YYYY');
u_data := TO_DATE('31-12-2102', 'DD-MM-YYYY');

WHILE p_data <= u_data
LOOP

 a_data := p_data;
 ano := EXTRACT(YEAR FROM a_data);
 mes := EXTRACT(MONTH FROM a_data);
 dia := EXTRACT(DAY FROM a_data);
 id_data := TO_NUMBER(TO_CHAR(a_data,'YYYYMMDD'));
 
 semana := TO_CHAR(a_data, 'DY', 'nls_date_language =''brazilian portuguese''');
 nusemana := to_number(to_char(a_data, 'D'));
 nome_dsem := to_char(a_data, 'DAY', 'nls_date_language =''brazilian portuguese''');
 
 nmes := TO_CHAR(a_data, 'MONTH', 'nls_date_language =''brazilian portuguese''');
 abvmes := TO_CHAR(a_data, 'MON', 'nls_date_language =''brazilian portuguese''');
 ns_mes := to_number(to_char(a_data, 'W'));
 ns_ano := to_number(to_char(a_data, 'IW')); -- confirmar
 trimestre := to_number(to_char(a_data, 'Q'));

 resta_ano := add_months( trunc(a_data, 'y' ), 12 ) - a_data;
 resta_mes := last_day(a_data) - a_data;
 quadrimestre := round((EXTRACT(MONTH FROM a_data) + 1) /4);


	
	--bimestre--
	
	IF MOD(mes, 2) = 0 THEN
		bimestre := mes/2;
		resta_bim := last_day(a_data) - a_data;
		mes_bim := 2;
	ELSE 
		bimestre := (mes+1)/2;
		resta_bim := (last_day(to_date(''|| to_char(1) || '-' || to_char(mes+1) || '-' || to_char(ano) || '' , 'dd-mm-yyyy')) - a_data); --confirmar
		mes_bim := 1;
	END IF;
	
	IF bimestre = 1 then
		nome_bimestre := 'PRIMEIRO BIMESTRE';
	ELSIF bimestre = 2 then
		nome_bimestre := 'SEGUNDO BIMESTRE';
	ELSIF bimestre = 3 then
		nome_bimestre := 'TERCEIRO BIMESTRE';
	ELSIF bimestre = 4 then
		nome_bimestre := 'QUARTO BIMESTRE';
	ELSIF bimestre = 5 then
		nome_bimestre := 'QUINTO BIMESTRE';
	ELSE 
		nome_bimestre := 'SEXTO BIMESTRE';
	END IF;
	
	IF bimestre != trunc((EXTRACT(MONTH FROM (a_data-1))+1)/2) then  ---testar
		semana_bim := 1;
	ELSIF nusemana = 1 then 
		semana_bim := semana_bim + 1;
	END IF;
		
	IF to_char(a_data, 'dd-mm') in ('01-01', '01-03', '01-05', '01-07', '01-09', '01-11') then
		dia_bim := 1;
	ELSE
		dia_bim := dia_bim + 1;
	END IF;
		
		
	-- trimestre --
		
	IF trimestre = 1 then
		resta_tri := last_day(to_date(('01-03-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
	ELSIF trimestre = 2 then
		resta_tri := last_day(to_date(('01-06-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
	ELSIF trimestre = 3 then
		resta_tri := last_day(to_date(('01-09-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
	ELSE
		resta_tri := last_day(to_date(('01-12-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
	END IF;	
		

	IF trimestre = 1 THEN
		nome_trimestre := 'PRIMEIRO TRIMESTRE';
	ELSIF trimestre = 2 THEN
		nome_trimestre := 'SEGUNDO TRIMESTRE';
	ELSIF trimestre = 3 THEN
		nome_trimestre := 'TERCEIRO TRIMESTRE';
	ELSE
		nome_trimestre := 'QUARTO TRIMESTRE';
	END IF;
 
 
	IF(trimestre != to_number(to_char(a_data-1, 'Q'))) then
		dia_tri := 1;
	ELSE
		dia_tri := dia_tri + 1;
	END IF;
	
	IF mes IN (1, 4, 7, 10) THEN 
		mes_tri := 1;
	ELSIF mes IN (2, 5, 8, 11) THEN
		mes_tri := 2;
	ELSIF mes IN (3, 6, 9, 12) THEN 
		mes_tri := 3;
	END IF;
 
 IF trimestre != to_number(to_char(a_data-1, 'Q')) then
		semana_tri := 1;
	ELSIF nusemana = 1 then 
		semana_tri := semana_tri + 1;
	END IF;
	
	
	-- quadrimestre --
	
	IF quadrimestre = 1 then
		resta_qua := last_day(to_date(('01-04-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
		nome_qua := 'PRIMEIRO QUADRIMESTRE';
	ELSIF quadrimestre = 2 then
		resta_qua := last_day(to_date(('01-08-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
		nome_qua := 'SEGUNDO QUADRIMESTRE';
	ELSE 
		resta_qua := last_day(to_date(('01-12-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
		nome_qua := 'TERCEIRO QUADRIMESTRE';
	END IF;
	
	
	IF(quadrimestre != round((EXTRACT(MONTH FROM a_data-1) + 1) /4)) then
		dia_qua := 1;
	ELSE
		dia_qua := dia_qua + 1;
	END IF;
	
	
	IF (quadrimestre != round((EXTRACT(MONTH FROM a_data-1) + 1) /4)) THEN
		semana_qua := 1;
	ELSIF nusemana = 1 THEN
		semana_qua := semana_qua + 1;
	END IF;
	
	IF mes IN (1, 5, 9) THEN 
		mes_qua := 1;
	ELSIF mes IN (2, 6, 10) THEN
		mes_qua := 2;
	ELSIF mes IN (3, 7, 11) THEN 
		mes_qua := 3;
	ELSE
		mes_qua := 4;
	END IF;
 
	
	-- semestre --
	
	IF mes < 7 THEN
		nome_semestre := 'PRIMEIRO SEMESTRE';
		num_semestre := 1;
		resta_sem := last_day(to_date(('01-06-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
	ELSE
		nome_semestre := 'SEGUNDO SEMESTRE';
		num_semestre := 2;
		resta_sem := last_day(to_date(('01-12-' || to_char(ano) || ''), 'dd-mm-yyyy')) - a_data;
	END IF;
	
	IF mes IN (1, 7) THEN 
		mes_sem := 1;
	ELSIF mes IN (2, 8) THEN
		mes_sem := 2;
	ELSIF mes IN (3, 9) THEN 
		mes_sem := 3;
	ELSIF mes IN (4, 10) THEN	
		mes_sem := 4;
	ELSIF mes IN (5, 11) THEN
		mes_sem := 5;
	ELSE
		mes_sem := 6;
	END IF;
	
	
	IF num_semestre != trunc((EXTRACT(MONTH FROM a_data-1)-1)/6+1) then
		dia_sem := 1;
	ELSE
		dia_sem := dia_sem + 1;
	END IF;
  
	
	IF num_semestre != trunc((EXTRACT(MONTH FROM a_data-1)-1)/6+1) then
		semana_sem := 1;
	ELSIF nusemana = 1 then 
		semana_sem := semana_sem + 1;
	END IF;
	
	
	-- feriados
	
 
	IF (ano <= 2016 and ((mes = 12 and dia >= 20) or (mes = 1 and dia = 1))) THEN
	    feriadojud := 1;
	    
	ELSIF (ano > 2016 and ((mes = 12 and dia >= 20) or (mes = 1 and dia <= 6))) THEN
	    feriadojud := 1;
	
	ELSE
	    feriadojud := 0;
	END IF;
			
	
	IF to_char(a_data, 'dd-mm') in ('01-01', '25-12', '07-09', '01-05', '15-11', '02-11', '12-10', '21-04', '02-04', '11-08', '28-10') THEN
		feriado := 1;
	ELSE 
		feriado := 0;
	END IF;
	
		
	IF (nusemana in (1,7) and feriado = 1) then
        dutil := 0;
    ELSE
        dutil := 1;
    END IF;
	
	-- estacoes do ano
	
	IF a_data between to_date(('23-09-' || to_char(ano) || ''), 'dd-mm-yyyy') and to_date(('20-12-' || to_char(ano) || ''), 'dd-mm-yyyy') THEN
		sig_estacao := 'PRI';
		estacao := 'PRIMAVERA';
	ELSIF a_data between to_date(('21-03-' || to_char(ano) || ''), 'dd-mm-yyyy') and to_date(('20-06-' || to_char(ano) || ''), 'dd-mm-yyyy') THEN
		sig_estacao := 'OUT';
		estacao := 'OUTONO';
	ELSIF a_data between to_date(('21-06-' || to_char(ano) || ''), 'dd-mm-yyyy') and to_date(('22-09-' || to_char(ano) || ''), 'dd-mm-yyyy') THEN
		sig_estacao := 'INV';
		estacao := 'INVERNO';
	ELSE
		sig_estacao := 'VER';
		estacao := 'VERÃO';
	END IF;
		
		
    insert 
    into DM_CORPORATIVO.dim_data(
	ID_DATA,
	DATA,
	FLG_DIA_UTIL_PERIODO,
	FLG_RECESSO_JUDICIARIO,
	FLG_FERIADO_NACIONAL_PERIODO,
	NUM_DIA_MES,
	NOM_ABREV_DIA_SEMANA,
	NUM_MES_PERIODO,
	NOM_MES_PERIODO,
	NUM_ANO_PERIODO,
	NOM_ABREV_MES_PERIODO,
	NUM_DIA_SEMANA,
	NOM_DIA_SEMANA,
	NUM_SEMANA_CORR_MES,
	NUM_SEMANA_CORR_ANO,
	NUM_TRIMESTRE_CORR_ANO,
	NUM_MES_CORR_TRIMESTRE,
	NUM_SMNA_CORR_TRIMESTRE,
	NUM_DIA_CORR_TRIMESTRE,
	NOM_SEMESTRE_PERIODO,
	NUM_SEMESTRE_PERIODO,
	QTD_DIAS_RESTA_ANO,
	QTD_DIAS_RESTA_BIMESTRE,
	QTD_DIAS_RESTA_MES,
	QTD_DIAS_RESTA_TRIMESTRE,
	QTD_DIAS_RESTA_QUADRIMESTRE,
	QTD_DIAS_RESTA_SEMESTRE,
	NOM_BIMESTRE_PERIODO,
	NUM_DIA_CORR_BIMESTRE,
	NUM_BIMESTRE_PERIODO,
	NUM_MES_CORR_BIMESTRE,
	NUM_SMNA_CORR_BIMESTRE,
	NUM_DIA_CORR_QUADRIMESTRE,
	NUM_MES_CORR_QUADRIMESTRE,
	NUM_SMNA_CORR_QUADRIMESTRE,
	NUM_DIA_CORR_SEMESTRE,
	NUM_MES_CORR_SEMESTRE,
	NUM_SMNA_CORR_SEMESTRE,
	NUM_QUADRIMESTRE_PERIODO,
	NOM_QUADRIMESTRE_PERIODO,
	NOM_TRIMESRE_PERIODO,
	NOM_ESTACAO_PERIODO, 
	SIG_ESTACAO_PERIODO
	)
	
    values (
	id_data,
	a_data,
	dutil,
	feriadojud,
	feriado,
	dia,
	semana,
	mes,
	nmes,
	ano,
	abvmes,
	nusemana,
	nome_dsem,
	ns_mes,
	ns_ano,
	trimestre,
	mes_tri,
	semana_tri,
	dia_tri,
	nome_semestre,
	num_semestre,
	resta_ano,
	resta_bim,
	resta_mes,
	resta_tri,
	resta_qua,
	resta_sem,
	nome_bimestre,
	dia_bim,
	bimestre,
	mes_bim,
	semana_bim,
	dia_qua,
	mes_qua,
	semana_qua,
	dia_sem,
	mes_sem,
	semana_sem,
	quadrimestre,
	nome_qua,
	nome_trimestre,
	estacao,
	sig_estacao
	);
    
    p_data := p_data + 1;


END LOOP;
END;
/
COMMIT;