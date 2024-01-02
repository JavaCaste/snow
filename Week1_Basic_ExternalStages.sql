CREATE DATABASE SAMPLES;
CREATE SCHEMA SAMPLES.FROSTY;
USE SCHEMA SAMPLES.FROSTY ;

-- create stage
CREATE STAGE Week1_Basic_ExternalStage url='s3://frostyfridaychallenges/challenge_1/';

list @Week1_Basic_ExternalStage;


-- file format
CREATE OR REPLACE FILE FORMAT csv_ff
    TYPE = 'csv' 
    SKIP_HEADER=1
    NULL_IF=('NULL','totally_empty');


--select $1 from @Week1_Basic_ExternalStage (file_format => CSV_FF);

SELECT LISTAGG($1,' ') WITHIN GROUP (ORDER BY METADATA$FILENAME, METADATA$FILE_ROW_NUMBER) AS COL1
FROM @Week1_Basic_ExternalStage (file_format=>'csv_ff')

    
    -- store stage data into a table
CREATE TEMPORARY TABLE FROSTY.Week1_Basic_ExternalStage AS 
(SELECT LISTAGG($1,' ') WITHIN GROUP (ORDER BY METADATA$FILENAME, METADATA$FILE_ROW_NUMBER) AS COL1
FROM @FROSTY.Week1_Basic_ExternalStage  (file_format=>'csv_ff') );

-- display content
SELECT * FROM FROSTY.Week1_Basic_ExternalStage
