-- Base SQL Tables - County
LANGUAGE plpgsql;

-- fips and abreviations
DROP TABLE IF EXISTS counties CASCADE;
CREATE TABLE counties (
    "GEOID" varchar(5),
    "NAME" text,
    "NAMELSAD" text,
    "STUSPS" varchar(2),
    "STATE_NAME" text,
    "LSAD" smallint,
    PRIMARY KEY ("GEOID")
) WITH (
    OIDS = FALSE
);

\COPY counties FROM 'csv/cb_2021_us_county_5m.csv' HEADER CSV DELIMITER ',';

DROP TABLE IF EXISTS fipscodes CASCADE;
CREATE TABLE fipscodes AS
SELECT "GEOID" as "FIPS",
       "STATE_NAME" as "STATE",
       "NAMELSAD" as "COUNTY"
    FROM counties;

DROP TABLE IF EXISTS stabrv CASCADE;
CREATE TABLE stabrv AS
SELECT DISTINCT
    concat(substring("GEOID" from 1 for 2),'000') as "FIPS",
    "STUSPS" as "STABRV",
    "STATE_NAME" as "STATE"
    FROM counties;

-- i_2: Violent Crime Rate
DROP TABLE IF EXISTS i_2 CASCADE;
CREATE TABLE i_2 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "AAVC" integer,
    "VCR" integer,
    "VCRQRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY i_2 FROM 'csv/I-2.csv' HEADER CSV DELIMITER ',';

-- i_3: Poor Mental Health Days
DROP TABLE IF EXISTS i_3 CASCADE;
CREATE TABLE i_3 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "AVNMUD" numeric,
    "AVNMUD95CILB" numeric,
    "AVNMUD95CIUB" numeric,
    "AVMUDQRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY i_3 FROM 'csv/I-3.csv' HEADER CSV DELIMITER ',';

-- -- i_2_chr_b
-- DROP TABLE IF EXISTS i_2_chr_b CASCADE;
-- CREATE TABLE i_2_chr_b (
--     "FIPS" varchar(5),
--     "STATE" text,
--     "COUNTY" text,
--     "FMDPCT" integer,
--     "FMD95CILB" integer,
--     "FMD95CIUB" integer,
--     PRIMARY KEY ("FIPS")
-- ) WITH (
--     OIDS = FALSE
-- );

-- \COPY i_2_chr_b FROM 'csv/I-2_CHR_b.csv' HEADER CSV DELIMITER ',';

-- i_6: Children in poverty
DROP TABLE IF EXISTS i_6 CASCADE;
CREATE TABLE i_6 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "CIPPCT" integer,
    "CIP95CILB" integer,
    "CIP95CIUB" integer,
    "CIPQRT" integer,
    "CIPPCTAIAN" integer,
    "CIPPCTASIAN" integer,
    "CIPPCTBLACK" integer,
    "CIPPCTHSP" integer,
    "CIPPCTWH" integer,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY i_6 FROM 'csv/I-6.csv' HEADER CSV DELIMITER ',';

-- ii_8: Children in single parent households
DROP TABLE IF EXISTS ii_8 CASCADE;
CREATE TABLE ii_8 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "CHSPHHN" numeric,
    "CH__HHN" numeric,
    "CHSPHHPCT" smallint,
    "CHSPHH95CILB" smallint,
    "CHSPHH95CIUB" smallint,
    "CHSPHHQRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY ii_8 FROM 'csv/II-8.csv' HEADER CSV DELIMITER ',';

-- ii_10: Teen Births
DROP TABLE IF EXISTS ii_10 CASCADE;
CREATE TABLE ii_10 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "TNBR" smallint,
    "TNBR95CILB" smallint,
    "TNBR95CIUB" smallint,
    "TNBRQRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY ii_10 FROM 'csv/II-10.csv' HEADER CSV DELIMITER ',';

-- ii_11: Cesarean Delivery Rate
DROP TABLE IF EXISTS ii_11 CASCADE;
CREATE TABLE ii_11 (
    "NAME" text,
    "CESPCT" numeric,
    "FIPS" varchar(5),
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY ii_11 FROM 'csv/II-11.csv' HEADER CSV DELIMITER ',';

ALTER TABLE ii_11
ADD COLUMN "STATE" text,
ADD COLUMN "COUNTY" text;

UPDATE ii_11
    SET "STATE" = fipscodes."STATE"
FROM fipscodes
WHERE ii_11."FIPS"=fipscodes."FIPS";

UPDATE ii_11
    SET "COUNTY" = fipscodes."COUNTY"
FROM fipscodes
WHERE ii_11."FIPS"=fipscodes."FIPS";

-- ii_12: Preterm Birth Rates
DROP TABLE IF EXISTS ii_12 CASCADE;
CREATE TABLE ii_12 (
    "REGION" smallint,
    "STATE" text,
    "COUNTY" text,
    "PRETBRPCT" numeric,
    PRIMARY KEY ("STATE","COUNTY")
) WITH (
    OIDS = FALSE
);

\COPY ii_12 FROM 'csv/II-12.csv' HEADER CSV DELIMITER ',';

ALTER TABLE ii_12 ADD COLUMN "FIPS" varchar(5);

UPDATE ii_12
SET "FIPS" = fipscodes."FIPS"
FROM fipscodes
WHERE ii_12."COUNTY"=fipscodes."COUNTY" AND
      ii_12."STATE"=fipscodes."STATE";

-- iii_13: Mental Health Providers
DROP TABLE IF EXISTS iii_13 CASCADE;
CREATE TABLE iii_13 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "MHP_NUMBER" integer,
    "MHP_RATE" integer,
    "MHP_RATIO" text,
    "MHP_QRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY iii_13 FROM 'csv/III-13.csv' HEADER CSV DELIMITER ',';

-- iii_14: Income Inequality
DROP TABLE IF EXISTS iii_14 CASCADE;
CREATE TABLE iii_14 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "PCT80" integer,
    "PCT20" integer,
    "INC_RATIO" numeric,
    "INC_QRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY iii_14 FROM 'csv/III-14.csv' HEADER CSV DELIMITER ',';

-- iii_15: % Reproduction Age Women - white
DROP TABLE IF EXISTS iii_15 CASCADE;
CREATE TABLE iii_15 (
    "REGION" smallint,
    "STATE" text,
    "COUNTY" text,
    "NRPAWWH" integer,
    "RPAWWHPCT" numeric,
    PRIMARY KEY ("STATE","COUNTY")
) WITH (
    OIDS = FALSE
);

\COPY iii_15 FROM 'csv/III-15.csv' HEADER CSV DELIMITER ',';

ALTER TABLE iii_15 ADD COLUMN "FIPS" varchar(5);

UPDATE iii_15
SET "FIPS" = fipscodes."FIPS"
FROM fipscodes
WHERE iii_15."COUNTY"=fipscodes."COUNTY" AND
      iii_15."STATE"=fipscodes."STATE";

-- iii_16: % Reproductive Age Women - Hispanic or Latina
DROP TABLE IF EXISTS iii_16 CASCADE;
CREATE TABLE iii_16 (
    "REGION" smallint,
    "STATE" text,
    "COUNTY" text,
    "NRPAWHSP" integer,
    "RPAWHSPPCT" numeric,
    PRIMARY KEY ("STATE","COUNTY")
) WITH (
    OIDS = FALSE
);

\COPY iii_16 FROM 'csv/III-16.csv' HEADER CSV DELIMITER ',';

ALTER TABLE iii_16 ADD COLUMN "FIPS" varchar(5);

UPDATE iii_16
SET "FIPS" = fipscodes."FIPS"
FROM fipscodes
WHERE iii_16."COUNTY"=fipscodes."COUNTY" AND
      iii_16."STATE"=fipscodes."STATE";

-- iii_17: Lack of Insurance Coverage
DROP TABLE IF EXISTS iii_17 CASCADE;
CREATE TABLE iii_17 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "UIN" integer,
    "UIPCT" numeric,
    "UI95CILB" smallint,
    "UI95CIUB" smallint,
    "UIQRT" smallint,
    "UIADN" integer,
    "UIADPCT" smallint,
    "UIAD95CILB" smallint,
    "UIAD95CIUB" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY iii_17 FROM 'csv/III-17.csv' HEADER CSV DELIMITER ',';

-- iii_18: Severe Housing Problems
DROP TABLE IF EXISTS iii_18 CASCADE;
CREATE TABLE iii_18 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "SHPPCT" smallint,
    "SHP95CILB" smallint,
    "SHP95CIUB" smallint,
    "SHCB" smallint,
    "SHCB95CILB" smallint,
    "SHCB95CIUB" smallint,
    "OCRWDPCT" smallint,
    "OCRWD95CILB" smallint,
    "OCRWD95CIUB" smallint,
    "IAFPCT" smallint,
    "IAF95CILB" smallint,
    "IAF95CIUB" smallint,
    "IAFQRT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY iii_18 FROM 'csv/III-18.csv' HEADER CSV DELIMITER ',';

-- iii_19: Food Insecurity
DROP TABLE IF EXISTS iii_19 CASCADE;
CREATE TABLE iii_19 (
    "FIPS" varchar(5),
    "STATE" text,
    "COUNTY" text,
    "FEIDX" numeric,
    "FEIDXQRT" smallint,
    "FISN" integer,
    "FISPCT" smallint,
    "LIMAN" integer,
    "LIMAPCT" smallint,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY iii_19 FROM 'csv/III-19.csv' HEADER CSV DELIMITER ',';

-- dmn_22
-- DROP TABLE IF EXISTS dmn_18 CASCADE;
-- DROP TABLE IF EXISTS dmn_22 CASCADE;
-- CREATE TABLE dmn_22 (
--     "STATE" text,
--     "NBIRTH" integer,
--     "BR10_14" numeric,
--     "BR15_19" numeric,
--     "BR20_24" numeric,
--     "BR25_29" numeric,
--     "BR30_34" numeric,
--     "BR35_39" numeric,
--     "BR40_44" numeric,
--     "BR45_49" numeric
-- ) WITH (
--     OIDS = FALSE
-- );

-- \COPY dmn_22 FROM 'csv/DMN-18.csv' HEADER CSV DELIMITER ',';

-- DROP TABLE IF EXISTS dmn_18_states CASCADE;
-- CREATE TABLE dmn_18_states (
--     "STATE" text,
--     "FIPS" varchar(5),
--     "BIRTHS" integer,
--     "TOTPOP" integer,
--     "BIRTHRATE" numeric,
--     "FEMPOP" integer,
--     "FERTRATE" numeric,
--     PRIMARY KEY ("FIPS")
-- ) WITH (
--     OIDS = FALSE
-- );

-- \COPY dmn_18_states FROM 'csv/DMN-18_states.csv' HEADER CSV DELIMITER ',';

-- dmn_22: Fertility Rates for Reproductive Age Women
DROP TABLE IF EXISTS fertility CASCADE;
CREATE TABLE fertility (
    "COUNTY" text,
    "STABRV" varchar(2),
    "FIPS" varchar(5),
    "BIRTHS" integer,
    "TOTPOP" integer,
    "BIRTHRATE" numeric,
    "FEMPOP" integer,
    "FERTRATE" numeric,
    PRIMARY KEY ("FIPS")
) WITH (
    OIDS = FALSE
);

\COPY fertility FROM 'csv/fertility.csv' HEADER CSV DELIMITER ',';

ALTER TABLE fertility ADD COLUMN "STATE" text;

UPDATE fertility
SET "STATE" = stabrv."STATE"
FROM stabrv
WHERE fertility."STABRV"=stabrv."STABRV";

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
) WITH (
    OIDS = FALSE
);

\COPY rpragefem FROM 'csv/rpragefem.csv' HEADER CSV DELIMITER ',';

DROP TABLE IF EXISTS dmn_22 CASCADE;
CREATE TABLE dmn_22 AS
SELECT
    rpragefem."FIPS",
    fertility."STATE",
    fertility."COUNTY",
    fertility."STABRV",
    rpragefem."TOTPOP",
    rpragefem."FEMPOP",
    rpragefem."RPRAFEM",
    fertility."FERTRATE",
    fertility."BIRTHS",
    round(fertility."FERTRATE"*rpragefem."RPRAFEM"/1000) AS "BIRTHS_IMP"
FROM rpragefem
INNER JOIN fertility ON rpragefem."FIPS"=fertility."FIPS";

DROP TABLE IF EXISTS uidCounties CASCADE;
CREATE TABLE uidCounties AS
SELECT * from fertility WHERE "COUNTY"='Unidentified Counties';

DROP TABLE IF EXISTS rpragefem_uid CASCADE;
CREATE TABLE rpragefem_uid AS
SELECT
    rpragefem.*
FROM rpragefem
WHERE "FIPS" NOT IN (SELECT "FIPS" FROM fertility);

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
    uidCounties."FERTRATE",
    round(uidCounties."FERTRATE"*rpragefem_uid."RPRAFEM"/1000) AS "BIRTHS_IMP"
FROM rpragefem_uid
LEFT JOIN counties ON rpragefem_uid."FIPS"=counties."GEOID"
LEFT JOIN uidCounties ON counties."STATE_NAME"=uidCounties."STATE";

INSERT INTO dmn_22 ("FIPS","STATE","COUNTY","STABRV","TOTPOP","FEMPOP","RPRAFEM","FERTRATE","BIRTHS_IMP")
SELECT * FROM fertility_uid
WHERE fertility_uid."FERTRATE" IS NOT NULL;

\COPY dmn_22 TO 'csv/DMN-22.csv' HEADER CSV DELIMITER ',';
