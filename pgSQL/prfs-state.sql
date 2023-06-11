-- Risk Factor Scores - State
LANGUAGE plpgsql;

-- -- i_1: intimate partner violence
-- DROP TABLE IF EXISTS i_1_states;
-- CREATE TEMP TABLE i_1_states AS
-- SELECT * FROM i_1
--     GROUP BY "STATE" HAVING "STATE"!='United States';

-- DROP TABLE IF EXISTS i_1_national;
-- CREATE TEMP TABLE i_1_national AS
-- SELECT * FROM i_1
--     GROUP BY "STATE" HAVING "STATE"='United States';

-- DROP TABLE IF EXISTS i_1_quartiles CASCADE;
-- CREATE TEMP TABLE i_1_quartiles AS
-- SELECT
--     percentile_disc(0.25) within group (order by "AVPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
--     percentile_disc(0.5) within group (order by "AVPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
--     percentile_disc(0.75) within group (order by "AVPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
--     percentile_disc(1) within group (order by "AVPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
-- FROM i_1;

-- DROP TABLE IF EXISTS i_1_prfs CASCADE;
-- CREATE TABLE i_1_prfs AS
-- SELECT i_1_states."STATE",
--        i_1_states."AVPCT",
--        i_1_quartiles."QRT1" as "QRT1",
--        i_1_quartiles."QRT2" as "QRT2",
--        i_1_quartiles."QRT3" as "QRT3",
--        i_1_quartiles."QRT4" as "QRT4"
-- FROM i_1_states
-- JOIN i_1_quartiles
-- ON i_1_states."STATE" IS NOT NULL;

-- ALTER TABLE i_1_prfs
--     ADD COLUMN "I_1" smallint
--     CONSTRAINT tierI
--     GENERATED ALWAYS AS (
--         case
--         when "AVPCT"<="QRT2" or "AVPCT" is NULL
--         then 0
--         when "AVPCT"<="QRT3"
--         then 2
--         when "AVPCT"<="QRT4"
--         then 3
--         else 0
--         end
--         ) STORED;

-- i_1: intimate partner psychological aggresssion
DROP TABLE IF EXISTS i_1_prfs CASCADE;
CREATE TABLE i_1_prfs AS
WITH states AS (
        SELECT * FROM i_1
        GROUP BY "STATE" HAVING "STATE"!='United States'
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "APPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "APPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "APPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "APPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
        FROM i_1
)
SELECT states."STATE",
       states."APPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM states
JOIN quartiles
ON states."STATE" IS NOT NULL;

ALTER TABLE i_1_prfs
    ADD COLUMN "I_1" smallint
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "APPCT"<="QRT2" or "APPCT" is NULL
        then 0
        when "APPCT"<="QRT3"
        then 2
        when "APPCT"<="QRT4"
        then 3
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "APPCT"<="QRT1"
        then 1
        when "APPCT"<="QRT2"
        then 2
        when "APPCT"<="QRT3"
        then 3
        when "APPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- i_4: Mother Lacks Emotional Support
DROP TABLE IF EXISTS i_4_prfs CASCADE;
CREATE TABLE i_4_prfs AS
WITH states AS (
        SELECT * FROM i_4
            GROUP BY "STATE" HAVING "STATE"!='United States'
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "YESPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "YESPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "YESPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "YESPCT" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
        FROM i_4
)
SELECT states."STATE",
       states."YESPCT" AS "MLESPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM states
JOIN quartiles
ON states."STATE" IS NOT NULL;

ALTER TABLE i_4_prfs
    ADD COLUMN "I_4" smallint
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "MLESPCT"<="QRT2" or "MLESPCT" is NULL
        then 0
        when "MLESPCT"<="QRT3"
        then 2
        when "MLESPCT"<="QRT4"
        then 3
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "MLESPCT"<="QRT1"
        then 1
        when "MLESPCT"<="QRT2"
        then 2
        when "MLESPCT"<="QRT3"
        then 3
        when "MLESPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- i_5: Intended Pregnancy
DROP TABLE IF EXISTS i_5_prfs CASCADE;
CREATE TABLE i_5_prfs AS
WITH valid AS (
    SELECT "STATE","YEAR","HLTHIND","PCT",max("YEAR") OVER (PARTITION BY "STATE")
    FROM i_5
    WHERE "N" IS NOT NULL
), latest AS (
    SELECT "STATE","YEAR","HLTHIND","PCT"
    FROM valid
    WHERE valid."YEAR" = valid.max
), quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "PCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "PCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "PCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "PCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
    FROM latest
    WHERE latest."HLTHIND"='Intended pregnancy'
)
SELECT latest."STATE",
       latest."YEAR",
       latest."PCT" as "INTDPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM latest
JOIN quartiles
ON latest."STATE" IS NOT NULL
WHERE latest."HLTHIND"='Intended pregnancy';

ALTER TABLE i_5_prfs
    ADD COLUMN "I_5" integer
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "INTDPCT"<="QRT1"
        then 3
        when "INTDPCT"<="QRT2"
        then 2
        when "INTDPCT"<="QRT4" or "INTDPCT" is NULL
        then 0
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "INTDPCT"<="QRT1"
        then 1
        when "INTDPCT"<="QRT2"
        then 2
        when "INTDPCT"<="QRT3"
        then 3
        when "INTDPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- ii_7: Educational Attainment by Fertility Status
DROP TABLE IF EXISTS ii_7_clg CASCADE;
CREATE TEMP TABLE ii_7_clg AS
WITH tallies AS (
SELECT
    concat("STATEFP",'000') as "FIPS",
    "FER",
    "EA0"+"EA1"+"EA2"+"EA3"+
    "EA4"+"EA5"+"EA6"+"EA7"+
    "EA8"+"EA9"+"EA10"+"EA11"+
    "EA12"+"EA13"+"EA14"+"EA15"+
    "EA16"+"EA17"+"EA18"+"EA19"+"EA20"+
    "EA21"+"EA22"+"EA23"+"EA24" AS "TOTAL",
    "EA0"+"EA1"+"EA2"+"EA3"+
    "EA4"+"EA5"+"EA6"+"EA7"+
    "EA8"+"EA9"+"EA10"+"EA11"+
    "EA12"+"EA13"+"EA14"+"EA15"+
    "EA16"+"EA17"+"EA18"+"EA19"+"EA20" AS "BLWCLG",
    "EA21"+"EA22"+"EA23"+"EA24" AS "CLGABV"
    FROM ii_7
    WHERE "FER"=1
)
SELECT
    tallies."FIPS",
    stabrv."STATE",
    "FER",
    round(sum("BLWCLG"::numeric/"TOTAL"::numeric) OVER (PARTITION BY tallies."FIPS","FER"),2) AS "BLWCLGPCT"
FROM tallies
INNER JOIN stabrv ON tallies."FIPS"=stabrv."FIPS"
GROUP BY tallies."FIPS","FER","TOTAL","BLWCLG","CLGABV","STATE";

DROP TABLE IF EXISTS ii_7_prfs CASCADE;
CREATE TABLE ii_7_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "BLWCLGPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "BLWCLGPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "BLWCLGPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "BLWCLGPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
    FROM ii_7_clg
)
SELECT ii_7_clg."STATE",
       ii_7_clg."BLWCLGPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM ii_7_clg
JOIN quartiles
ON ii_7_clg."STATE" IS NOT NULL;

ALTER TABLE ii_7_prfs
    ADD COLUMN "II_7" integer
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "BLWCLGPCT"<="QRT2" or "BLWCLGPCT" is NULL
        then 0
        when "BLWCLGPCT"<="QRT3"
        then 1
        when "BLWCLGPCT"<="QRT4"
        then 2
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "BLWCLGPCT"<="QRT1"
        then 1
        when "BLWCLGPCT"<="QRT2"
        then 2
        when "BLWCLGPCT"<="QRT3"
        then 3
        when "BLWCLGPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- -- ii_9: Employment Status by Fertility Status
-- DROP TABLE IF EXISTS ii_8_esrxfer_rbue CASCADE;
-- DROP TABLE IF EXISTS ii_9_rbue CASCADE;
-- CREATE TABLE ii_9_rbue AS
-- WITH tallies AS (
-- SELECT
--     concat("STATEFP",'000') as "FIPS",
--     "FER",
--     "ESR0"+"ESR1"+"ESR2"+"ESR3"+"ESR4"+"ESR5"+"ESR6" AS "TOTAL",
--     "ESR3" AS "RBUE"
--     FROM ii_9
--     WHERE "FER"=1
-- )
-- SELECT
--     tallies."FIPS",
--     stabrv."STATE",
--     "FER",
--     round(sum("RBUE"::numeric/"TOTAL"::numeric) OVER (PARTITION BY tallies."FIPS","FER"),3) AS "RBUEPCT"
-- FROM tallies
-- INNER JOIN stabrv ON tallies."FIPS"=stabrv."FIPS"
-- GROUP BY tallies."FIPS","FER","TOTAL","RBUE","STATE";

-- DROP TABLE IF EXISTS ii_9_quartiles CASCADE;
-- CREATE TEMP TABLE ii_9_quartiles AS
-- SELECT
--     percentile_disc(0.25) within group (order by "RBUEPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
--     percentile_disc(0.5) within group (order by "RBUEPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
--     percentile_disc(0.75) within group (order by "RBUEPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
--     percentile_disc(1) within group (order by "RBUEPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
-- FROM ii_9_rbue;

-- DROP TABLE IF EXISTS ii_9_prfs CASCADE;
-- CREATE TABLE ii_9_prfs AS
-- SELECT ii_9_rbue."STATE",
--        ii_9_rbue."RBUEPCT",
--        ii_9_quartiles."QRT1" as "QRT1",
--        ii_9_quartiles."QRT2" as "QRT2",
--        ii_9_quartiles."QRT3" as "QRT3",
--        ii_9_quartiles."QRT4" as "QRT4"
-- FROM ii_9_rbue
-- JOIN ii_9_quartiles
-- ON ii_9_rbue."STATE" IS NOT NULL;

-- ALTER TABLE ii_9_prfs
--     ADD COLUMN "II_9" integer
--     CONSTRAINT tierI
--     GENERATED ALWAYS AS (
--         case
--         when "RBUEPCT"<="QRT2" or "RBUEPCT" is NULL
--         then 0
--         when "RBUEPCT"<="QRT3"
--         then 1
--         when "RBUEPCT"<="QRT4"
--         then 2
--         else 0
--         end
--         ) STORED;

-- ii_9: Employment Status of Parents by Household presence and age of Children
-- DROP TABLE IF EXISTS ii_9_hhwch CASCADE;
-- CREATE TABLE ii_9_hhwch AS
-- SELECT "STATEFP",
--        sum("ESP0") as "ESP0",
--        sum("ESP1") as "ESP1",
--        sum("ESP2") as "ESP2",
--        sum("ESP3") as "ESP3",
--        sum("ESP4") as "ESP4",
--        sum("ESP5") as "ESP5",
--        sum("ESP6") as "ESP6",
--        sum("ESP7") as "ESP7",
--        sum("ESP8") as "ESP8"
-- FROM ii_9
-- WHERE ii_9."HUPAC" IN (1,3)
-- GROUP BY "STATEFP";

DROP TABLE IF EXISTS ii_9_chwuep CASCADE;
CREATE TEMP TABLE ii_9_chwuep AS
WITH hhwch AS (
    SELECT "STATEFP",
        sum("ESP0") as "ESP0",
        sum("ESP1") as "ESP1",
        sum("ESP2") as "ESP2",
        sum("ESP3") as "ESP3",
        sum("ESP4") as "ESP4",
        sum("ESP5") as "ESP5",
        sum("ESP6") as "ESP6",
        sum("ESP7") as "ESP7",
        sum("ESP8") as "ESP8"
    FROM ii_9
    WHERE ii_9."HUPAC" IN (1,3)
    GROUP BY "STATEFP"
), tallies AS (
SELECT
    concat("STATEFP",'000') AS "FIPS",
    "ESP1"+"ESP2"+"ESP3"+"ESP4"+"ESP5"+"ESP6"+"ESP7"+"ESP8" AS "CHTOTAL",
    "ESP2"+"ESP3"+"ESP4"+"ESP6"+"ESP8" AS "CHWUEP"
    FROM hhwch
)
SELECT
    tallies."FIPS",
    stabrv."STATE",
    round(avg("CHWUEP"::numeric/"CHTOTAL"::numeric) OVER (PARTITION BY tallies."FIPS"),2) AS "CHWUEPPCT"
FROM tallies
INNER JOIN stabrv ON tallies."FIPS"=stabrv."FIPS"
GROUP BY tallies."FIPS","CHTOTAL","CHWUEP","STATE";

-- DROP TABLE IF EXISTS ii_9_quartiles CASCADE;
-- CREATE TEMP TABLE ii_9_quartiles AS
-- SELECT
--     percentile_disc(0.25) within group (order by "CHWUEPPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
--     percentile_disc(0.5) within group (order by "CHWUEPPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
--     percentile_disc(0.75) within group (order by "CHWUEPPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
--     percentile_disc(1) within group (order by "CHWUEPPCT" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
-- FROM ii_9_chwuep;

DROP TABLE IF EXISTS ii_9_prfs CASCADE;
CREATE TABLE ii_9_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "CHWUEPPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "CHWUEPPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "CHWUEPPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "CHWUEPPCT" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
    FROM ii_9_chwuep
)
SELECT ii_9_chwuep."STATE",
       ii_9_chwuep."CHWUEPPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM ii_9_chwuep
JOIN quartiles
ON ii_9_chwuep."STATE" IS NOT NULL;

ALTER TABLE ii_9_prfs
    ADD COLUMN "II_9" integer
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "CHWUEPPCT"<="QRT2" or "CHWUEPPCT" is NULL
        then 0
        when "CHWUEPPCT"<="QRT3"
        then 1
        when "CHWUEPPCT"<="QRT4"
        then 2
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "CHWUEPPCT"<="QRT1"
        then 1
        when "CHWUEPPCT"<="QRT2"
        then 2
        when "CHWUEPPCT"<="QRT3"
        then 3
        when "CHWUEPPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- dmn_20: Poor Mental Health Among Mothers 
DROP TABLE IF EXISTS dmn_20_states CASCADE;
CREATE TEMP TABLE dmn_20_states AS
    SELECT "STATE", 
           "STFP"
    FROM dmn_20 WHERE "STATE"!='United States';
ALTER TABLE dmn_20_states ADD COLUMN "FIPS" varchar(5);

UPDATE dmn_20_states
SET "FIPS" = fipscodes."FIPS"
FROM fipscodes
WHERE dmn_20_states."STATE"=fipscodes."STATE";

-- DROP TABLE IF EXISTS dmn_20_quartiles CASCADE;
-- CREATE TEMP TABLE dmn_20_quartiles AS
-- SELECT
--     percentile_disc(0.25) within group (order by "STFP" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
--     percentile_disc(0.5) within group (order by "STFP" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
--     percentile_disc(0.75) within group (order by "STFP" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
--     percentile_disc(1) within group (order by "STFP" asc)
--     FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
-- FROM dmn_20_states;

DROP TABLE IF EXISTS dmn_20_prfs CASCADE;
CREATE TABLE dmn_20_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "STFP" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "STFP" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "STFP" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "STFP" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
    FROM dmn_20_states
)
SELECT dmn_20_states."FIPS",
       dmn_20_states."STATE",
       dmn_20_states."STFP",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM dmn_20_states
JOIN quartiles
ON dmn_20_states."STATE" IS NOT NULL;

ALTER TABLE dmn_20_prfs
    ADD COLUMN "DMN_20" integer
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "STFP"<="QRT2" or "STFP" is NULL
        then 0
        when "STFP"<="QRT3"
        then 2
        when "STFP"<="QRT4"
        then 3
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "STFP"<="QRT1"
        then 1
        when "STFP"<="QRT2"
        then 2
        when "STFP"<="QRT3"
        then 3
        when "STFP"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- dmn_21: Mothers not coping well with raising their child
DROP TABLE IF EXISTS dmn_21_states CASCADE;
CREATE TEMP TABLE dmn_21_states AS
    SELECT "STATE", 
           "HD2DVW"
    FROM dmn_21 WHERE "STATE"!='United States';
ALTER TABLE dmn_21_states ADD COLUMN "FIPS" varchar(5);

UPDATE dmn_21_states
SET "FIPS" = fipscodes."FIPS"
FROM fipscodes, dmn_21
WHERE dmn_21."STATE"=fipscodes."STATE";

DROP TABLE IF EXISTS dmn_21_prfs CASCADE;
CREATE TABLE dmn_21_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "HD2DVW" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "HD2DVW" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "HD2DVW" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "HD2DVW" asc)
        FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
    FROM dmn_21_states
)
SELECT dmn_21_states."FIPS",
       dmn_21_states."STATE",
       dmn_21_states."HD2DVW",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM dmn_21_states
JOIN quartiles
ON dmn_21_states."STATE" IS NOT NULL;

ALTER TABLE dmn_21_prfs
    ADD COLUMN "DMN_21" integer
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "HD2DVW"<="QRT1"
        then 3
        when "HD2DVW"<="QRT2"
        then 2
        when "HD2DVW"<="QRT4" or "HD2DVW" is NULL
        then 0
        else 0
        end
    ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "HD2DVW"<="QRT1"
        then 1
        when "HD2DVW"<="QRT2"
        then 2
        when "HD2DVW"<="QRT3"
        then 3
        when "HD2DVW"<="QRT4"
        then 4
        else 0
        end
    ) STORED;