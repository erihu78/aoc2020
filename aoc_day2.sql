-- Input is stored in simple table 
-- CREATE TABLE AOC1 (ID NUMBER,VAL VARCHAR2(100));
-- ID is just a sequence to use as as primary key, VAL is the row from input-text.

--Part 1
WITH PWD_RULE AS (
SELECT TO_NUMBER(regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,1)) as RULE_MIN,
       TO_NUMBER(regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,2)) as RULE_MAX,
       regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,3) as RULE_CHR,
       regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,4) as PWD,              
       val FROM AOC2)      
SELECT 
COUNT(1)
FROM PWD_RULE
WHERE regexp_count( PWD, RULE_CHR ) BETWEEN RULE_MIN AND RULE_MAX;

-- Part 2
WITH PWD_RULE AS (
SELECT TO_NUMBER(regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,1)) as RULE_MIN,
       TO_NUMBER(regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,2)) as RULE_MAX,
       regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,3) as RULE_CHR,
       regexp_substr(val, '^(\d+)-(\d+) (.): (.+)', 1, 1,NULL,4) as PWD,              
       val FROM AOC2)      
SELECT 
COUNT(1)
FROM PWD_RULE
WHERE (SUBSTR(PWD,RULE_MIN,1) = RULE_CHR OR SUBSTR(PWD,RULE_MAX,1)=RULE_CHR) AND NOT (SUBSTR(PWD,RULE_MIN,1) = RULE_CHR AND SUBSTR(PWD,RULE_MAX,1)=RULE_CHR);