-- Exerc�cio - Manipula��o de Grandes Conjuntos de Dados

-- 1. Execute o script a seguir para criar a tabela SAL_HISTORY.

DROP TABLE SAL_HISTORY;

CREATE table SAL_HISTORY
(EMPLOYEE_ID NUMBER(6),
HIRE_DATE DATE,
SALARY NUMBER(8,2));

-- Descri��o da tabela SAL_HISTORY

desc SAL_HISTORY;

-- 2. Execute o script a seguir para criar a tabela

DROP TABLE MGR_HISTORY;

CREATE table MGR_HISTORY
(EMPLOYEE_ID NUMBER(6),
MANAGER_ID NUMBER(6),
SALARY NUMBER(8,2));

-- Descri��o da tabela SAL_HISTORY

desc SAL_HISTORY;

-- Execute o script a seguir para criar a tabela 

drop TABLE SPECIAL_SAL;

CREATE table SPECIAL_SAL
(EMPLOYEE_ID NUMBER(6),
SALARY NUMBER(8,2));

-- Descri��o da tabela SPECIAL_SAL

desc SPECIAL_SAL;

-- Exerc�cio (continua��o)

/*7. a. Crie uma consulta que fa�a o seguinte:

Recupere na tabela EMPLOYEES os detalhes de ID do funcion�rio, data de
admiss�o, sal�rio e o ID do gerente desses funcion�rios cujo ID � inferior a
125.

Se o sal�rio for superior a $20.000, insira os detalhessobre o ID do
funcion�rio e o sal�rio na tabela SPECIAL_SAL.

Insira o ID do funcion�rio, a data de admiss�o e o sal�rio na tabela
SAL_HISTORY.

Insira os detalhes sobre o ID do funcion�rio, o ID do gerente e o sal�rio na
tabela MGR_HISTORY. */

INSERT ALL
WHEN SAL> 20000 THEN
INTO  special_sal VALUES (EMPID, SAL)
ELSE
INTO sal_history VALUES(EMPID,HIREDATE,SAL)
INTO mgr_history VALUES(EMPID,MGR,SAL)   
SELECT employee_id EMPID, hire_date HIREDATE,
       salary SAL, manager_id MGR
FROM employees
WHERE employee_id < 125;

--7b
SELECT * FROM  special_sal;

--7c
SELECT * FROM  sal_history;

--7d
SELECT * FROM mgr_history; 

-- 8. a. Execute o script a seguir para criar a tabela SALES_SOURCE_DATA

drop TABLE SALES_SOURCE_DATA;

CREATE TABLE SALES_SOURCE_DATA
(employee_id NUMBER(6),
WEEK_ID NUMBER(2),
SALES_MON NUMBER(8,2),
SALES_TUE NUMBER(8,2),
SALES_WED NUMBER(8,2),
SALES_THUR NUMBER(8,2),
SALES_FRI NUMBER(8,2));

-- 8. b. Execute o script a seguir para inserir registros na tabela SALES_SOURCE_DATA.

INSERT INTO SALES_SOURCE_DATA VALUES
(178, 6, 1750,2200,1500,1500,3000);

commit;

-- 8. c. Exiba a estrutura da tabela SALES_SOURCE_DATA.

DESC SALES_SOURCE_DATA;

-- 8. d. Exiba os registros da tabela SALES_SOURCE_DATA

SELECT * FROM SALES_SOURCE_DATA;

-- 8. e. Execute o script a seguir para criar a tabela SALES_INFO.

drop TABLE SALES_INFO;

CREATE TABLE SALES_INFO
(employee_id NUMBER(6),
WEEK NUMBER(2),
SALES NUMBER(8,2));

-- 8. f. Exiba a estrutura da tabela SALES_INFO.

DESC SALES_INFO;

/* 8. g. Crie uma consulta que fa�a o seguinte:
Recupere da tabela SALES_SOURCE_DATA os detalhes sobre o ID do
funcion�rio, o ID da semana, vendas na segunda-feira, vendas na ter�a-feira,
vendas na quarta-feira, vendas na quinta-feira e vendas na sexta-feira.
Crie uma transforma��o de modo que cada registro recuperado da tabela
SALES_SOURCE_DATA seja convertido em v�rios registros para a tabela
SALES_INFO. */

INSERT ALL
    INTO SALES_INFO
    VALUES (EMPLOYEE_ID, WEEK_ID, SALES_MON)
    INTO SALES_INFO
    VALUES (EMPLOYEE_ID, WEEK_ID, SALES_TUE)
    INTO SALES_INFO
    VALUES (EMPLOYEE_ID, WEEK_ID, SALES_WED)
    INTO SALES_INFO
    VALUES (EMPLOYEE_ID, WEEK_ID, SALES_THUR)
    INTO SALES_INFO
    VALUES (EMPLOYEE_ID, WEEK_ID, SALES_FRI)
SELECT EMPLOYEE_ID, WEEK_ID,
    SALES_MON,   
    SALES_TUE,
    SALES_WED,
    SALES_THUR,
    SALES_FRI
FROM SALES_SOURCE_DATA;

 select * from SALES_INFO;
 
 -- Exerc�cio � Relat�rios por Agrupamento de Dados Relacionados
 
/* Crie uma consulta para exibir as seguintes informa��es sobre os funcion�rios
cujo ID de gerente � menor que 120:
ID do gerente
ID do cargo e sal�rio total para cada ID de cargo para funcion�rios que
est�o subordinados ao mesmo gerente
Sal�rio total desses gerentes
Sal�rio total desses gerentes, independentemente dos IDs dos cargos */

--01
SELECT manager_id,job_id,sum(salary)
FROM   employees
WHERE manager_id < 120
GROUP BY ROLLUP(manager_id,job_id);

--02
SELECT manager_id MGR ,job_id JOB,
sum(salary),GROUPING(manager_id),GROUPING(job_id)
FROM   employees
WHERE manager_id < 120
GROUP BY ROLLUP(manager_id,job_id);

--03
SELECT manager_id, job_id, sum(salary)
FROM   employees
WHERE manager_id < 120
GROUP BY CUBE(manager_id, job_id);

--04
SELECT manager_id MGR ,job_id JOB,
sum(salary),GROUPING(manager_id),GROUPING(job_id)
FROM   employees
WHERE manager_id < 120
GROUP BY CUBE(manager_id,job_id);

--05
SELECT department_id, manager_id, job_id,  SUM(salary)
FROM employees
GROUP BY 
GROUPING SETS
((department_id, manager_id, job_id),
(department_id, job_id),(manager_id,job_id));

-- Exerc�cio CONSULTAS HIER�QUICAS

--02
SELECT last_name, salary, department_id
FROM employees
START WITH last_name = 'Mourgos'
CONNECT BY PRIOR employee_id = manager_id;

--03
SELECT last_name
FROM employees
WHERE last_name != 'Lorentz'
START WITH last_name = 'Lorentz'
CONNECT BY PRIOR manager_id = employee_id
/

--04
COLUMN name FORMAT A20

SELECT LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_')  name,manager_id mgr, department_id deptno
FROM employees
START WITH last_name = 'Kochhar'                 
CONNECT BY PRIOR employee_id = manager_id
/
COLUMN name CLEAR

--05
SELECT last_name,employee_id, manager_id
FROM   employees
WHERE  job_id != 'IT_PROG' 
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id
AND last_name != 'De Haan'
/




