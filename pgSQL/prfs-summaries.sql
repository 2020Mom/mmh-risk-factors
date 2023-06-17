-- MMH Risk Factors 2
-- prfs-summaries.sql
-- Build summary tables for each of the (22) Perinatal Risk Factors Scores
-- This file defines the scoring algorithm and produces summary tables for each risk factor

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

-- i_2: Violent Crime Rate
DROP TABLE IF EXISTS i_2_prfs CASCADE;
CREATE TABLE i_2_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","VCR"
        FROM i_2
        GROUP BY "FIPS","STATE","VCR"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","AAVC","VCR"
        FROM i_2
        GROUP BY "FIPS","STATE","COUNTY","AAVC","VCR"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "VCR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "VCR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "VCR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "VCR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM i_2
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE i_2_prfs
    ADD COLUMN "I_2" smallint
    CONSTRAINT tierI
    GENERATED ALWAYS AS (
        case
        when "VCR"<="QRT2" or "VCR" is NULL
        then 0
        when "VCR"<="QRT3"
        then 2
        when "VCR"<="QRT4"
        then 3
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "VCR"<="QRT1"
        then 1
        when "VCR"<="QRT2"
        then 2
        when "VCR"<="QRT3"
        then 3
        when "VCR"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- i_3: Poor Mental Health Days
DROP TABLE IF EXISTS i_3_prfs CASCADE;
CREATE TABLE i_3_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","AVNMUD"
            FROM i_3
            GROUP BY "FIPS","STATE","AVNMUD"
            HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","AVNMUD"
            FROM i_3
            GROUP BY "FIPS","STATE","COUNTY","AVNMUD"
            HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "AVNMUD" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "AVNMUD" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "AVNMUD" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "AVNMUD" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM i_3
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE i_3_prfs
    ADD COLUMN "I_3" smallint
    CONSTRAINT nat_quartile
    GENERATED ALWAYS AS (
        case
        when "AVNMUD"<="QRT2" or "AVNMUD" is NULL
        then 0
        when "AVNMUD"<="QRT3"
        then 2
        when "AVNMUD"<="QRT4"
        then 3
        else 100
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "AVNMUD"<="QRT1"
        then 1
        when "AVNMUD"<="QRT2"
        then 2
        when "AVNMUD"<="QRT3"
        then 3
        when "AVNMUD"<="QRT4"
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

-- i_6: Children in poverty
DROP TABLE IF EXISTS i_6_prfs CASCADE;
CREATE TABLE i_6_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","CIPPCT"
            FROM i_6
            GROUP BY "FIPS","STATE","CIPPCT"
            HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","CIPPCT"
            FROM i_6
            GROUP BY "FIPS","STATE","COUNTY","CIPPCT"
            HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "CIPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "CIPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "CIPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "CIPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM i_6
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE i_6_prfs
    ADD COLUMN "I_6" smallint
    CONSTRAINT nat_quartile
    GENERATED ALWAYS AS (
        case
        when "CIPPCT"<="QRT2" or "CIPPCT" is NULL
        then 0
        when "CIPPCT"<="QRT3"
        then 2
        when "CIPPCT"<="QRT4"
        then 3
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "CIPPCT"<="QRT1"
        then 1
        when "CIPPCT"<="QRT2"
        then 2
        when "CIPPCT"<="QRT3"
        then 3
        when "CIPPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

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

-- ii_8: Children in single parent households
DROP TABLE IF EXISTS ii_8_prfs CASCADE;
CREATE TABLE ii_8_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","CHSPHHPCT"
        FROM ii_8
        GROUP BY "FIPS","STATE","CHSPHHPCT"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","CHSPHHPCT"
        FROM ii_8
        GROUP BY "FIPS","STATE","COUNTY","CHSPHHPCT"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "CHSPHHPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "CHSPHHPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "CHSPHHPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "CHSPHHPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM ii_8
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE ii_8_prfs
    ADD COLUMN "II_8" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "CHSPHHPCT"<="QRT2" or "CHSPHHPCT" is NULL
        then 0
        when "CHSPHHPCT"<="QRT3"
        then 1
        when "CHSPHHPCT"<="QRT4"
        then 2
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "CHSPHHPCT"<="QRT1"
        then 1
        when "CHSPHHPCT"<="QRT2"
        then 2
        when "CHSPHHPCT"<="QRT3"
        then 3
        when "CHSPHHPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- ii_9: Employment Status of Parents by Household presence and age of Children
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

-- ii_10: Teen Births
DROP TABLE IF EXISTS ii_10_prfs CASCADE;
CREATE TABLE ii_10_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","TNBR"
        FROM ii_10
        GROUP BY "FIPS","STATE","TNBR"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","TNBR"
        FROM ii_10
        GROUP BY "FIPS","STATE","COUNTY","TNBR"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "TNBR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "TNBR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "TNBR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "TNBR" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM ii_10   
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE ii_10_prfs
    ADD COLUMN "II_10" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "TNBR"<="QRT2" or "TNBR" is NULL
        then 0
        when "TNBR"<="QRT3"
        then 1
        when "TNBR"<="QRT4"
        then 2
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "TNBR"<="QRT1"
        then 1
        when "TNBR"<="QRT2"
        then 2
        when "TNBR"<="QRT3"
        then 3
        when "TNBR"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- ii_11: Cesarean Delivery Rate
DROP TABLE IF EXISTS ii_11_prfs CASCADE;
CREATE TABLE ii_11_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","CESPCT"
        FROM ii_11
        GROUP BY "FIPS","STATE","CESPCT"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","CESPCT"
        FROM ii_11
        GROUP BY "FIPS","STATE","COUNTY","CESPCT"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "CESPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "CESPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "CESPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "CESPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM counties
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE ii_11_prfs
    ADD COLUMN "II_11" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "CESPCT"<="QRT2" or "CESPCT" is NULL
        then 0
        when "CESPCT"<="QRT3"
        then 1
        when "CESPCT"<="QRT4"
        then 2
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "CESPCT"<="QRT1"
        then 1
        when "CESPCT"<="QRT2"
        then 2
        when "CESPCT"<="QRT3"
        then 3
        when "CESPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- ii_12: Pre-term Births
DROP TABLE IF EXISTS ii_12_prfs CASCADE;
CREATE TABLE ii_12_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "PRETBRPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "PRETBRPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "PRETBRPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "PRETBRPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
    FROM ii_12
)
SELECT ii_12."FIPS",
       ii_12."STATE",
       ii_12."COUNTY",
       ii_12."PRETBRPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM ii_12
LEFT JOIN quartiles ON ii_12."FIPS" IS NOT NULL;

ALTER TABLE ii_12_prfs
    ADD COLUMN "II_12" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "PRETBRPCT"<="QRT2" or "PRETBRPCT" is NULL
        then 0
        when "PRETBRPCT"<="QRT3"
        then 1
        when "PRETBRPCT"<="QRT4"
        then 2
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "PRETBRPCT"<="QRT1"
        then 1
        when "PRETBRPCT"<="QRT2"
        then 2
        when "PRETBRPCT"<="QRT3"
        then 3
        when "PRETBRPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_13: Mental Healthcare Providers
DROP TABLE IF EXISTS iii_13_prfs CASCADE;
CREATE TABLE iii_13_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","MHP_RATE"
        FROM iii_13
        GROUP BY "FIPS","STATE","MHP_RATE"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","MHP_RATE"
        FROM iii_13
        GROUP BY "FIPS","STATE","COUNTY","MHP_RATE"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "MHP_RATE" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "MHP_RATE" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "MHP_RATE" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "MHP_RATE" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM iii_13
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE iii_13_prfs
    ADD COLUMN "III_13" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "MHP_RATE"<="QRT2"
        then 1
        when "MHP_RATE"<="QRT4" or "MHP_RATE" is NULL
        then 0
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "MHP_RATE"<="QRT1"
        then 1
        when "MHP_RATE"<="QRT2"
        then 2
        when "MHP_RATE"<="QRT3"
        then 3
        when "MHP_RATE"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_14: Income Inequality
DROP TABLE IF EXISTS iii_14_prfs CASCADE;
CREATE TABLE iii_14_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","INC_RATIO"
        FROM iii_14
        GROUP BY "FIPS","STATE","INC_RATIO"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","INC_RATIO"
        FROM iii_14
        GROUP BY "FIPS","STATE","COUNTY","INC_RATIO"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "INC_RATIO" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "INC_RATIO" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "INC_RATIO" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "INC_RATIO" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM iii_14
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE iii_14_prfs
    ADD COLUMN "III_14" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "INC_RATIO"<="QRT2" or "INC_RATIO" is NULL
        then 0
        when "INC_RATIO"<="QRT4"
        then 1
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "INC_RATIO"<="QRT1"
        then 1
        when "INC_RATIO"<="QRT2"
        then 2
        when "INC_RATIO"<="QRT3"
        then 3
        when "INC_RATIO"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_15: Reproductive Age, % white
DROP TABLE IF EXISTS iii_15_prfs CASCADE;
CREATE TABLE iii_15_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "RPAWWHPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "RPAWWHPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "RPAWWHPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "RPAWWHPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
    FROM iii_15
)
SELECT iii_15."FIPS",
       iii_15."STATE",
       iii_15."COUNTY",
       iii_15."RPAWWHPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM iii_15
LEFT JOIN quartiles ON iii_15."FIPS" IS NOT NULL;

ALTER TABLE iii_15_prfs
    ADD COLUMN "III_15" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "RPAWWHPCT"<="QRT2"
        then 1
        when "RPAWWHPCT"<="QRT4" or "RPAWWHPCT" is NULL
        then 0
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "RPAWWHPCT"<="QRT1"
        then 1
        when "RPAWWHPCT"<="QRT2"
        then 2
        when "RPAWWHPCT"<="QRT3"
        then 3
        when "RPAWWHPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_16: Reproductive Age, % Hispanic or Latina
DROP TABLE IF EXISTS iii_16_prfs CASCADE;
CREATE TABLE iii_16_prfs AS
WITH quartiles AS (
    SELECT
        percentile_disc(0.25) within group (order by "RPAWHSPPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
        percentile_disc(0.5) within group (order by "RPAWHSPPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
        percentile_disc(0.75) within group (order by "RPAWHSPPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
        percentile_disc(1) within group (order by "RPAWHSPPCT" asc)
        FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
    FROM iii_16
)
SELECT iii_16."FIPS",
       iii_16."STATE",
       iii_16."COUNTY",
       iii_16."RPAWHSPPCT",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM iii_16
LEFT JOIN quartiles ON iii_16."FIPS" IS NOT NULL;

ALTER TABLE iii_16_prfs
    ADD COLUMN "III_16" smallint
    CONSTRAINT abovestavg
    GENERATED ALWAYS AS (
        case
        when "RPAWHSPPCT"<="QRT2" or "RPAWHSPPCT" is NULL
        then 0
        when "RPAWHSPPCT"<="QRT4"
        then 1
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "RPAWHSPPCT"<="QRT1"
        then 1
        when "RPAWHSPPCT"<="QRT2"
        then 2
        when "RPAWHSPPCT"<="QRT3"
        then 3
        when "RPAWHSPPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_17: Lack of Insurance Coverage
DROP TABLE IF EXISTS iii_17_prfs CASCADE;
CREATE TABLE iii_17_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","UIADPCT"
        FROM iii_17
        GROUP BY "FIPS","STATE","UIADPCT"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","UIADPCT"
        FROM iii_17
        GROUP BY "FIPS","STATE","COUNTY","UIADPCT"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "UIADPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "UIADPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "UIADPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "UIADPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM iii_17
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE iii_17_prfs
    ADD COLUMN "III_17" smallint
    CONSTRAINT tierIII
    GENERATED ALWAYS AS (
        case
        when "UIADPCT"<="QRT2" or "UIADPCT" is NULL
        then 0
        when "UIADPCT"<="QRT4"
        then 1
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "UIADPCT"<="QRT1"
        then 1
        when "UIADPCT"<="QRT2"
        then 2
        when "UIADPCT"<="QRT3"
        then 3
        when "UIADPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_18: Severe Housing Problems
DROP TABLE IF EXISTS iii_18_prfs CASCADE;
CREATE TABLE iii_18_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","SHPPCT"
        FROM iii_18
        GROUP BY "FIPS","STATE","SHPPCT"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","SHPPCT"
        FROM iii_18
        GROUP BY "FIPS","STATE","COUNTY","SHPPCT"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "SHPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "SHPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "SHPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "SHPPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM iii_18
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE iii_18_prfs
    ADD COLUMN "III_18" smallint
    CONSTRAINT tierIII
    GENERATED ALWAYS AS (
        case
        when "SHPPCT"<="QRT2" or "SHPPCT" is NULL
        then 0
        when "SHPPCT"<="QRT4"
        then 1
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "SHPPCT"<="QRT1"
        then 1
        when "SHPPCT"<="QRT2"
        then 2
        when "SHPPCT"<="QRT3"
        then 3
        when "SHPPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- iii_19: Food Insecurity
DROP TABLE IF EXISTS iii_19_prfs CASCADE;
CREATE TABLE iii_19_prfs AS
WITH states AS (
        SELECT "FIPS","STATE","FISPCT"
        FROM iii_19
        GROUP BY "FIPS","STATE","FISPCT"
        HAVING "COUNTY" IS NULL
), counties AS (
        SELECT "FIPS","STATE","COUNTY","FISPCT"
        FROM iii_19
        GROUP BY "FIPS","STATE","COUNTY","FISPCT"
        HAVING "COUNTY" IS NOT NULL
), quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "FISPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "FISPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "FISPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "FISPCT" asc)
            FILTER (WHERE "COUNTY" IS NOT NULL) AS "QRT4"
        FROM iii_19
)
SELECT counties.*,
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM counties
LEFT JOIN quartiles ON counties."FIPS" IS NOT NULL;

ALTER TABLE iii_19_prfs
    ADD COLUMN "III_19" smallint
    CONSTRAINT tierIII
    GENERATED ALWAYS AS (
        case
        when "FISPCT"<="QRT2" or "FISPCT" is NULL
        then 0
        when "FISPCT"<="QRT4"
        then 1
        else 0
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "FISPCT"<="QRT1"
        then 1
        when "FISPCT"<="QRT2"
        then 2
        when "FISPCT"<="QRT3"
        then 3
        when "FISPCT"<="QRT4"
        then 4
        else 0
        end
    ) STORED;

-- dmn_20: Poor Mental Health Among Mothers
DROP TABLE IF EXISTS dmn_20_states CASCADE;
CREATE TABLE dmn_20_states AS
    SELECT "STATE", 
           "STFP"
    FROM dmn_20 WHERE "STATE"!='United States';
ALTER TABLE dmn_20_states ADD COLUMN "FIPS" varchar(5);

UPDATE dmn_20_states
SET "FIPS" = fipscodes."FIPS"
FROM fipscodes
WHERE dmn_20_states."STATE"=fipscodes."STATE";

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
CREATE TABLE dmn_21_states AS
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

-- dmn_22: Fertility rates, by county for reproductive age women
DROP TABLE IF EXISTS dmn_22_prfs CASCADE;
CREATE TABLE dmn_22_prfs AS
WITH quartiles AS (
        SELECT
            percentile_disc(0.25) within group (order by "FERTRATE" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT1",
            percentile_disc(0.5) within group (order by "FERTRATE" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT2",
            percentile_disc(0.75) within group (order by "FERTRATE" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT3",
            percentile_disc(1) within group (order by "FERTRATE" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QRT4"
        FROM dmn_22
)
SELECT dmn_22."FIPS",
       dmn_22."STATE",
       dmn_22."COUNTY",
       dmn_22."FERTRATE",
       quartiles."QRT1" as "QRT1",
       quartiles."QRT2" as "QRT2",
       quartiles."QRT3" as "QRT3",
       quartiles."QRT4" as "QRT4"
FROM dmn_22, quartiles;

ALTER TABLE dmn_22_prfs
    ADD COLUMN "DMN_22" smallint
    CONSTRAINT tierD
    GENERATED ALWAYS AS (
        case
        when "FERTRATE"<="QRT2"
        then 0
        when "FERTRATE"<="QRT3"
        then 1
        when "FERTRATE"<="QRT4"
        then 2
        else NULL
        end
        ) STORED,
    ADD COLUMN "QRT" smallint
    CONSTRAINT quartile
    GENERATED ALWAYS AS (
        case
        when "FERTRATE"<="QRT1"
        then 1
        when "FERTRATE"<="QRT2"
        then 2
        when "FERTRATE"<="QRT3"
        then 3
        when "FERTRATE"<="QRT4"
        then 4
        else 0
        end
    ) STORED;
