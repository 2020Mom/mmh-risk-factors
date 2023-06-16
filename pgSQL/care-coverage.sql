-- MMH Providers & Prescribers
-- care-coverage.sql
-- Build the base data tables from CSV files
-- The final table produces the calculations
-- for the provider shortage gap.

-- Provider Data
-- PMH Certified Providers by State
DROP TABLE IF EXISTS pmh_provider_states CASCADE;
CREATE TABLE pmh_provider_states (
    "FIPS" varchar(5),
    "STABRV" varchar(2),
    "STATE" text,
    "PROVIDERS" integer
);

\COPY pmh_provider_states FROM 'csv/pmh_provider_states.csv' HEADER CSV DELIMITER ',';

-- PMH Certified Providers by County
DROP TABLE IF EXISTS pmh_provider_counties CASCADE;
CREATE TABLE pmh_provider_counties (
    "FIPS" varchar(5),
    "COUNTY" text,
    "STABRV" varchar(2),
    "STATE" text,
    "PROVIDERS" integer
);

\COPY pmh_provider_counties FROM 'csv/pmh_provider_counties.csv' HEADER CSV DELIMITER ',';

-- PMH Certified Reproductive Psychiatrists by State
DROP TABLE IF EXISTS reprx_psych_states CASCADE;
CREATE TABLE reprx_psych_states (
    "STABRV" varchar(2),
    "STATE" text,
    "PRESCRIBERS" integer
);

\COPY reprx_psych_states FROM 'csv/reprx_psych_states.csv' HEADER CSV DELIMITER ',';

-- PMH Certified Reproductive Psychiatrists by County
DROP TABLE IF EXISTS reprx_psych_counties;
CREATE TABLE reprx_psych_counties (
    "FIPS" varchar(5),
    "COUNTY" text,
    "STABRV" varchar(2),
    "STATE" text,
    "PRESCRIBERS" integer
);

\COPY reprx_psych_counties FROM 'csv/reprx_psych_counties.csv' HEADER CSV DELIMITER ',';

-- The table below, 'care_coverage', aggregates the coverage numbers
-- along with population, fertility, and birthrate estimates.
-- Estimates of the average and marginal MMH caseloads, the required
-- number of providers required to meet present demand, and
-- the gap (surplus, deficit) between the required and actual numbers
-- of providers, which we refer to as the Provider Shortage Gap.  

-- Reproductive-Aged Female Population
DROP TABLE IF EXISTS rpragefem CASCADE;
CREATE TABLE rpragefem (
    "COUNTY" text,
    "FIPS" varchar(5),
    "TOTPOP" integer,
    "FEMPOP" integer,
    "RPRAFEM" integer,
    "F15to17" integer,
    "F18to19" integer,
    "F20" integer,
    "F21" integer,
    "F22to24" integer,
    "F25to29" integer,
    "F30to34" integer,
    "F35to39" integer,
    "F40to44" integer
);

\COPY rpragefem FROM 'csv/test.csv' HEADER CSV DELIMITER ',';

-- Make a separate table of the 'Unidentified Counties' from table DMN_22
DROP TABLE IF EXISTS uidCounties CASCADE;
CREATE TABLE uidCounties AS
SELECT * from dmn_22 WHERE "COUNTY"='Unidentified Counties';

-- Make a separate table of the Reprx-aged Female Pop in 'Unidentified Counties'
DROP TABLE IF EXISTS rpragefem_uid CASCADE;
CREATE TABLE rpragefem_uid AS
SELECT * FROM rpragefem
WHERE "FIPS" NOT IN (SELECT "FIPS" FROM dmn_22);

DROP TABLE fertility_uid CASCADE;
CREATE TABLE fertility_uid AS
SELECT
    rpragefem_uid."FIPS",
    counties."STATE_NAME" AS "STATE",
    counties."NAMELSAD" AS "COUNTY",
    counties."STUSPS" AS "STABRV",
    rpragefem_uid."TOTPOP",
    rpragefem_uid."FEMPOP",
    rpragefem_uid."RPRAFEM",
    uidCounties."FERTRATE"
FROM rpragefem_uid
LEFT JOIN counties ON rpragefem_uid."FIPS"=counties."GEOID"
LEFT JOIN uidCounties ON counties."STATE_NAME"=uidCounties."STATE";

DROP TABLE IF EXISTS est_births;
CREATE TABLE est_births AS
SELECT 
    dmn_22.*,
    rpragefem."FEMPOP"
FROM dmn_22
JOIN rpragefem ON dmn_22."FIPS"=rpragefem."FIPS";

INSERT INTO est_births ("FIPS","STATE","COUNTY","STABRV","TOTPOP","FEMPOP","RPRAFEM","FERTRATE")
SELECT * FROM fertility_uid
WHERE fertility_uid."FERTRATE" IS NOT NULL;

ALTER TABLE est_births ADD COLUMN "BIRTHS_EST" integer;
UPDATE est_births
SET "BIRTHS_EST" = round("FERTRATE"*"RPRAFEM"/1000);

DROP TABLE IF EXISTS care_coverage CASCADE;
CREATE TABLE care_coverage AS
SELECT
    pmh_provider_counties."FIPS",
    pmh_provider_counties."COUNTY",
    pmh_provider_counties."STATE",
    est_births."STABRV",
    pmh_provider_counties."PROVIDERS" AS "PROVIDERS",
    reprx_psych_counties."PRESCRIBERS" AS "PRESCRIBERS",
    est_births."TOTPOP",
    est_births."FEMPOP",
    est_births."RPRAFEM",
    est_births."FERTRATE",
    est_births."BIRTHS_EST",
    ROUND(COALESCE(pmh_provider_counties."PROVIDERS"/NULLIF(est_births."BIRTHS_EST",0)*1000,0),2) AS "RATIO",
    ROUND(est_births."BIRTHS_EST"*0.2*30/1200,0) AS "REQPROV",
    COALESCE(ROUND(pmh_provider_counties."PROVIDERS"/NULLIF(ROUND(est_births."BIRTHS_EST"*0.2*30/1200,0),0),2),0) AS "COVERAGE",
    ROUND((est_births."BIRTHS_EST"*0.2*30/1200) - "PROVIDERS",0) AS "GAP"
FROM est_births
JOIN pmh_provider_counties ON est_births."FIPS"=pmh_provider_counties."FIPS"
JOIN reprx_psych_counties ON est_births."FIPS"=reprx_psych_counties."FIPS";

\COPY care_coverage TO 'csv/care_coverage.csv' HEADER CSV DELIMITER ',';
