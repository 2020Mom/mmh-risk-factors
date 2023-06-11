-- Risk Factor Scores
LANGUAGE plpgsql;

-- Aggregate Table - by County
DROP TABLE IF EXISTS prfs_counties CASCADE;
CREATE TABLE prfs_counties AS
SELECT
    counties."GEOID" as "FIPS",
    counties."STUSPS" as "STABRV",
    counties."STATE_NAME" as "STATE",
    counties."NAMELSAD" as "COUNTY" ,
    i_1_prfs."APPCT",
    i_1_prfs."I_1",
    i_1_prfs."QRT" as "I_1_QRT",
    i_2_prfs."VCR",
    i_2_prfs."I_2",
    i_2_prfs."QRT" as "I_2_QRT",
    i_3_prfs."AVNMUD",
    i_3_prfs."I_3",
    i_3_prfs."QRT" as "I_3_QRT",
    i_4_prfs."MLESPCT",
    i_4_prfs."I_4",
    i_4_prfs."QRT" as "I_4_QRT",
    i_5_prfs."INTDPCT",
    i_5_prfs."I_5",
    i_5_prfs."QRT" as "I_5_QRT",
    i_6_prfs."CIPPCT",
    i_6_prfs."I_6",
    i_6_prfs."QRT" as "I_6_QRT",
    ii_7_prfs."BLWCLGPCT",
    ii_7_prfs."II_7",
    ii_7_prfs."QRT" as "II_7_QRT",
    ii_8_prfs."CHSPHHPCT",
    ii_8_prfs."II_8",
    ii_8_prfs."QRT" as "II_8_QRT",
    ii_9_prfs."CHWUEPPCT",
    ii_9_prfs."II_9",
    ii_9_prfs."QRT" as "II_9_QRT",
    ii_10_prfs."TNBR",
    ii_10_prfs."II_10",
    ii_10_prfs."QRT" as "II_10_QRT",
    ii_11_prfs."CESPCT",
    ii_11_prfs."II_11",
    ii_11_prfs."QRT" as "II_11_QRT",
    ii_12_prfs."PRETBRPCT",
    ii_12_prfs."II_12",
    ii_12_prfs."QRT" as "II_12_QRT",
    iii_13_prfs."MHP_RATE",
    iii_13_prfs."III_13",
    iii_13_prfs."QRT" as "III_13_QRT",
    iii_14_prfs."INC_RATIO",
    iii_14_prfs."III_14",
    iii_14_prfs."QRT" as "III_14_QRT",
    iii_15_prfs."RPAWWHPCT",
    iii_15_prfs."III_15",
    iii_15_prfs."QRT" as "III_15_QRT",
    iii_16_prfs."RPAWHSPPCT",
    iii_16_prfs."III_16",
    iii_16_prfs."QRT" as "III_16_QRT",
    iii_17_prfs."UIADPCT",
    iii_17_prfs."III_17",
    iii_17_prfs."QRT" as "III_17_QRT",
    iii_18_prfs."SHPPCT",
    iii_18_prfs."III_18",
    iii_18_prfs."QRT" as "III_18_QRT",
    iii_19_prfs."FISPCT",
    iii_19_prfs."III_19",
    iii_19_prfs."QRT" as "III_19_QRT",
    dmn_20_prfs."STFP",
    dmn_20_prfs."DMN_20",
    dmn_20_prfs."QRT" as "DMN_20_QRT",
    dmn_21_prfs."HD2DVW",
    dmn_21_prfs."DMN_21",
    dmn_21_prfs."QRT" as "DMN_21_QRT",
    dmn_22_prfs."FERTRATE",
    dmn_22_prfs."DMN_22",
    dmn_22_prfs."QRT" AS "DMN_22_QRT"
FROM counties
JOIN i_1_prfs ON counties."STATE_NAME"=i_1_prfs."STATE"
JOIN i_2_prfs ON counties."GEOID"=i_2_prfs."FIPS"
JOIN i_3_prfs ON counties."GEOID"=i_3_prfs."FIPS"
JOIN i_4_prfs ON counties."STATE_NAME"=i_4_prfs."STATE"
LEFT JOIN i_5_prfs ON counties."STATE_NAME"=i_5_prfs."STATE"
JOIN i_6_prfs ON counties."GEOID"=i_6_prfs."FIPS"
JOIN ii_7_prfs ON counties."STATE_NAME"=ii_7_prfs."STATE"
JOIN ii_8_prfs ON counties."GEOID"=ii_8_prfs."FIPS"
JOIN ii_9_prfs ON counties."STATE_NAME"=ii_9_prfs."STATE"
JOIN ii_10_prfs ON counties."GEOID"=ii_10_prfs."FIPS"
JOIN ii_11_prfs ON counties."GEOID"=ii_11_prfs."FIPS"
JOIN ii_12_prfs ON counties."GEOID"=ii_12_prfs."FIPS"
JOIN iii_13_prfs ON counties."GEOID"=iii_13_prfs."FIPS"
JOIN iii_14_prfs ON counties."GEOID"=iii_14_prfs."FIPS"
JOIN iii_15_prfs ON counties."GEOID"=iii_15_prfs."FIPS"
JOIN iii_16_prfs ON counties."GEOID"=iii_16_prfs."FIPS"
JOIN iii_17_prfs ON counties."GEOID"=iii_17_prfs."FIPS"
JOIN iii_18_prfs ON counties."GEOID"=iii_18_prfs."FIPS"
JOIN iii_19_prfs ON counties."GEOID"=iii_19_prfs."FIPS"
JOIN dmn_20_prfs ON counties."STATE_NAME"=dmn_20_prfs."STATE"
JOIN dmn_21_prfs ON counties."STATE_NAME"=dmn_21_prfs."STATE"
LEFT JOIN dmn_22_prfs ON counties."GEOID"=dmn_22_prfs."FIPS"
;

ALTER TABLE prfs_counties
ADD COLUMN "PRFS" smallint;

WITH scores AS (
    SELECT
        "FIPS",
        CAST(SUM(
            "I_1"+"I_2"+"I_3"+"I_4"+coalesce("I_5",0)+"I_6"+
            "II_7"+"II_8"+"II_9"+"II_10"+"II_11"+"II_12"+
            "III_13"+"III_14"+"III_15"+ "III_16"+ "III_17"+
            "III_18"+"III_19"+"DMN_20"+
            "DMN_21"+coalesce("DMN_22",0)) OVER (PARTITION BY "FIPS") AS integer)
        as "PRFS"
    FROM prfs_counties
)
UPDATE prfs_counties
SET "PRFS" = scores."PRFS"
FROM scores
WHERE prfs_counties."FIPS"=scores."FIPS";

ALTER TABLE prfs_counties
    DROP COLUMN "I_1",
    DROP COLUMN "I_1_QRT",
    DROP COLUMN "I_2",
    DROP COLUMN "I_2_QRT",
    DROP COLUMN "I_3",
    DROP COLUMN "I_3_QRT",
    DROP COLUMN "I_4",
    DROP COLUMN "I_4_QRT",
    DROP COLUMN "I_5",
    DROP COLUMN "I_5_QRT",
    DROP COLUMN "I_6",
    DROP COLUMN "I_6_QRT",
    DROP COLUMN "II_7",
    DROP COLUMN "II_7_QRT",
    DROP COLUMN "II_8",
    DROP COLUMN "II_8_QRT",
    DROP COLUMN "II_9",
    DROP COLUMN "II_9_QRT",
    DROP COLUMN "II_10",
    DROP COLUMN "II_10_QRT",
    DROP COLUMN "II_11",
    DROP COLUMN "II_11_QRT",
    DROP COLUMN "II_12",
    DROP COLUMN "II_12_QRT",
    DROP COLUMN "III_13",
    DROP COLUMN "III_13_QRT",
    DROP COLUMN "III_14",
    DROP COLUMN "III_14_QRT",
    DROP COLUMN "III_15",
    DROP COLUMN "III_15_QRT",
    DROP COLUMN "III_16",
    DROP COLUMN "III_16_QRT",
    DROP COLUMN "III_17",
    DROP COLUMN "III_17_QRT",
    DROP COLUMN "III_18",
    DROP COLUMN "III_18_QRT",
    DROP COLUMN "III_19",
    DROP COLUMN "III_19_QRT",
    DROP COLUMN "DMN_20",
    DROP COLUMN "DMN_20_QRT",
    DROP COLUMN "DMN_21",
    DROP COLUMN "DMN_21_QRT",
    DROP COLUMN "DMN_22",
    DROP COLUMN "DMN_22_QRT"
;

DROP TABLE IF EXISTS prfs_scores;
CREATE TABLE prfs_scores AS
WITH quantiles AS (
        SELECT
            percentile_disc(0.2) within group (order by "PRFS" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QNT1",
            percentile_disc(0.4) within group (order by "PRFS" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QNT2",
            percentile_disc(0.6) within group (order by "PRFS" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QNT3",
            percentile_disc(0.8) within group (order by "PRFS" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QNT4",
            percentile_disc(1) within group (order by "PRFS" asc)
            FILTER (WHERE "STATE" IS NOT NULL) AS "QNT5"
        FROM prfs_counties
)
SELECT
    prfs_counties.*,
    quantiles."QNT1" as "QNT1",
    quantiles."QNT2" as "QNT2",
    quantiles."QNT3" as "QNT3",
    quantiles."QNT4" as "QNT4",
    quantiles."QNT5" as "QNT5"
FROM prfs_counties, quantiles;

ALTER TABLE prfs_scores
    ADD COLUMN "RISK_Q" smallint
    CONSTRAINT quantile
    GENERATED ALWAYS AS (
        case
        when "PRFS"<="QNT1"
        then 1
        when "PRFS"<="QNT2"
        then 2
        when "PRFS"<="QNT3"
        then 3
        when "PRFS"<="QNT4"
        then 4
        when "PRFS"<="QNT5"
        then 5
        else 0
        end
    ) STORED;

DROP TABLE IF EXISTS final_score;
CREATE TABLE final_score AS
SELECT
    prfs_scores.*,
    provider_coverage_county."PROVIDERS",
    provider_coverage_county."PRESCRIBERS",
    provider_coverage_county."TOTPOP",
    provider_coverage_county."FEMPOP",
    provider_coverage_county."RPRAFEM",
    provider_coverage_county."BIRTHS_IMP",
    -- provider_coverage_county."RATIO1",
    provider_coverage_county."RATIO2",
    provider_coverage_county."MARGINAL_LOAD",
    provider_coverage_county."COVERAGE_Q",
    provider_coverage_county."REQPROV",
    provider_coverage_county."COVERAGE",
    provider_coverage_county."GAP"
FROM prfs_scores
LEFT JOIN provider_coverage_county on prfs_scores."FIPS"=provider_coverage_county."FIPS";

DROP TABLE IF EXISTS cbsa_consolidated_scores;
CREATE TABLE cbsa_consolidated_scores AS
WITH wavg AS (
SELECT
    "GEOID",
    "NAME",
    "NAMELSAD",
    "NAMELSAD_2",
    "PROVIDERS",
    "PRFS",
    "RPRAFEM",
    "BIRTHS_IMP",
    ROUND(
        "BIRTHS_IMP"::numeric/(SUM("BIRTHS_IMP"::numeric) OVER (PARTITION BY "NAMELSAD")),2) AS "WEIGHT",
    ROUND(
        "PRFS"::numeric*("BIRTHS_IMP"::numeric/(SUM("BIRTHS_IMP"::numeric) OVER (PARTITION BY "NAMELSAD")))
    ,2) AS "WPRFS"
FROM cbsa_counties
), countycount AS (
SELECT
    "NAMELSAD",
    COUNT("NAMELSAD_2") OVER (PARTITION BY "NAMELSAD") AS "COUNTIES"
FROM cbsa_counties
GROUP BY "NAMELSAD", "NAMELSAD_2"
)
SELECT
    DISTINCT wavg."GEOID",
    "NAME",
    "NAMELSAD",
    COUNT("NAMELSAD_2") OVER (PARTITION BY wavg."NAMELSAD") AS "COUNTIES",
    ROUND(SUM("WPRFS"::numeric) OVER (PARTITION BY wavg."NAMELSAD"),0) AS "WPRFS",
    ROUND(SUM("PROVIDERS"::numeric) OVER (PARTITION BY wavg."NAMELSAD"),0) AS "PROVIDERS",
    SUM("BIRTHS_IMP"::numeric) OVER (PARTITION BY wavg."NAMELSAD") AS "TOTBIRTHS",
    ROUND(SUM("PROVIDERS"::numeric) OVER (PARTITION BY wavg."NAMELSAD")/SUM(NULLIF("BIRTHS_IMP"::numeric,0)) OVER (PARTITION BY wavg."NAMELSAD")*1000,2) AS "RATIO",
    ROUND(SUM("BIRTHS_IMP"::numeric) OVER (PARTITION BY wavg."NAMELSAD")/(SUM("PROVIDERS"::numeric) OVER (PARTITION BY wavg."NAMELSAD") + 1),0) AS "MARGINAL_LOAD"
FROM wavg
ORDER BY "MARGINAL_LOAD" DESC;

-- This function prints all the relevant tables in the DB to JSON.
SELECT json_over_tables();