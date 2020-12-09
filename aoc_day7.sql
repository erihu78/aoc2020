-- Input is stored in simple table 
-- CREATE TABLE AOC7 (ID NUMBER,VAL VARCHAR2(100));
-- ID is just a sequence to use as as primary key, VAL is the row from input-text.

-- Part 1
WITH 
BAG_RULES AS (
SELECT 
ID,
VAL,
replace(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,1),'bags','bag') AS OUTER_BAG,
LEVELS.COLUMN_VALUE,
REPLACE(trim(regexp_substr(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,2), '(\d+)([^,^\.]+)', 1, levels.column_value,null,1)),'bags','bag') AS NUMBER_OF_INNER_BAGS,
replace(trim(regexp_substr(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,2), '(\d+)([^,^\.]+)', 1, levels.column_value,null,2)),'bags','bag') AS INNER_BAG
FROM AOC7 A, table(cast(multiset(select level from dual connect by  level <= regexp_count(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,2), '[^,]+')) as sys.OdciNumberList)) levels),
RULE_LEVELS AS
(SELECT 
connect_by_isleaf TOP_BAG,
SYS_CONNECT_BY_PATH(INNER_BAG, '/')||'/'||OUTER_BAG Path,
connect_by_root OUTER_BAG root,
level,
A.*
FROM BAG_RULES A
CONNECT BY NOCYCLE  INNER_BAG = PRIOR OUTER_BAG START WITH INNER_BAG IS NULL)
SELECT COUNT(DISTINCT OUTER_BAG) FROM RULE_LEVELS
--WHERE INNER_BAG='shiny gold bag' OR OUTER_BAG='shiny gold bag'
WHERE PATH LIKE '%shiny gold bag%' AND OUTER_BAG!='shiny gold bag'
;

-- Part 2
WITH 
BAG_RULES AS (
SELECT 
ID,
VAL,
replace(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,1),'bags','bag') AS OUTER_BAG,
LEVELS.COLUMN_VALUE,
REPLACE(trim(regexp_substr(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,2), '(\d+)([^,^\.]+)', 1, levels.column_value,null,1)),'bags','bag') AS NUMBER_OF_INNER_BAGS,
replace(trim(regexp_substr(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,2), '(\d+)([^,^\.]+)', 1, levels.column_value,null,2)),'bags','bag') AS INNER_BAG
FROM AOC7 A, table(cast(multiset(select level from dual connect by  level <= regexp_count(REGEXP_SUBSTR(VAL,'(^.+) contain (.+)$',1,1,null,2), '[^,]+')) as sys.OdciNumberList)) levels),
RULE_LEVELS AS
(SELECT 
connect_by_isleaf TOP_BAG,
SYS_CONNECT_BY_PATH(OUTER_BAG, '/')||'/'||INNER_BAG Path,
'1'||SYS_CONNECT_BY_PATH(NUMBER_OF_INNER_BAGS, '*') Path_sum,
connect_by_root OUTER_BAG root,
level,
A.*
FROM BAG_RULES A
CONNECT BY NOCYCLE PRIOR INNER_BAG =  OUTER_BAG START WITH OUTER_BAG ='shiny gold bag')
SELECT 
SUM(xmlquery(Path_sum returning content ).getNumberVal()) FROM RULE_LEVELS
WHERE INNER_BAG IS NOT NULL
--WHERE PATH LIKE '%shiny gold bag%' AND OUTER_BAG!='shiny gold bag'
;