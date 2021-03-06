-- Input is stored in simple table 
-- CREATE TABLE AOC6 (ID NUMBER,VAL VARCHAR2(100));
-- ID is just a sequence to use as as primary key, VAL is the row from input-text.

-- Part 1 and Part 2
WITH ANSWERS AS (
SELECT A.START_ROW,A.END_ROW,LISTAGG(B.VAL,' ') WITHIN GROUP(ORDER BY B.ID) AS LIST_VAL  FROM (
SELECT ID AS START_ROW,NVL(LEAD(ID,1) OVER (ORDER BY ID)-1,LAST_ROW) AS END_ROW,VAL,PREV_ROW,PREV_ROW_IS_NULL FROM (
SELECT ID,VAL,
LAG(VAL,1) OVER (ORDER BY ID) AS PREV_ROW,
NVL2(LAG(VAL,1) OVER (ORDER BY ID),0,1) AS PREV_ROW_IS_NULL,
MAX(ID) OVER() AS LAST_ROW
FROM AOC6
) WHERE PREV_ROW IS NULL
) A INNER JOIN AOC6 B ON B.ID BETWEEN A.START_ROW AND A.END_ROW
GROUP BY A.START_ROW,A.END_ROW ),
DISTINCT_ANSWERS AS (
SELECT     
  A.START_ROW, A.END_ROW,
  A.LIST_VAL,  
  LEVELS.COLUMN_VALUE AS QUESTION_ID,
  trim(regexp_substr(A.LIST_VAL, '[^ ]+', LEVELS.COLUMN_VALUE , 1)) AS YES_GROUP,  
  trim(regexp_substr(A.LIST_VAL, '[^ ]', 1, levels.column_value)) AS YES_QUESTION,  
  COUNT(DISTINCT trim(regexp_substr(A.LIST_VAL, '[^ ]', 1, levels.column_value))) over(PARTITION BY START_ROW) AS COUNT_DISTINCT_YES   ,
  COUNT(trim(regexp_substr(A.LIST_VAL, '[^ ]+', 1, levels.column_value))) over(PARTITION BY START_ROW) AS COUNT_GROUPS   
FROM ANSWERS A, table(cast(multiset(select level from dual connect by  level <= regexp_count(A.LIST_VAL, '[^ ]')) as sys.OdciNumberList)) levels),
YES_GROUPS AS (
SELECT START_ROW,YES_QUESTION,COUNT_GROUPS,COUNT(YES_QUESTION) AS COUNT_ALL,CASE WHEN COUNT(YES_QUESTION)=COUNT_GROUPS THEN 1 ELSE 0 END AS ALL_YES FROM DISTINCT_ANSWERS GROUP BY START_ROW,YES_QUESTION,COUNT_GROUPS )
SELECT COUNT(*) AS NUMBER_OF_QUESTIONS_ONE_YES,SUM(ALL_YES) AS NUMBER_OF_QUESTIONS_ALL_YES FROM YES_GROUPS 
;

-- Only Part 1
WITH ANSWERS AS (
SELECT A.START_ROW,A.END_ROW,LISTAGG(B.VAL,' ') WITHIN GROUP(ORDER BY B.ID) AS LIST_VAL  FROM (
SELECT ID AS START_ROW,NVL(LEAD(ID,1) OVER (ORDER BY ID)-1,LAST_ROW) AS END_ROW,VAL,PREV_ROW,PREV_ROW_IS_NULL FROM (
SELECT ID,VAL,
LAG(VAL,1) OVER (ORDER BY ID) AS PREV_ROW,
NVL2(LAG(VAL,1) OVER (ORDER BY ID),0,1) AS PREV_ROW_IS_NULL,
MAX(ID) OVER() AS LAST_ROW
FROM AOC6
) WHERE PREV_ROW IS NULL
) A INNER JOIN AOC6 B ON B.ID BETWEEN A.START_ROW AND A.END_ROW
GROUP BY A.START_ROW,A.END_ROW ),
DISTINCT_ANSWERS AS (
SELECT DISTINCT 
  A.START_ROW, A.END_ROW,
  A.LIST_VAL,  
  COUNT(DISTINCT trim(regexp_substr(A.LIST_VAL, '[^ ]', 1, levels.column_value))) over(PARTITION BY START_ROW) AS COUNT_DISTINCT   
FROM ANSWERS A, table(cast(multiset(select level from dual connect by  level <= regexp_count(A.LIST_VAL, '[^ ]')) as sys.OdciNumberList)) levels)
SELECT SUM(COUNT_DISTINCT) FROM DISTINCT_ANSWERS
;
