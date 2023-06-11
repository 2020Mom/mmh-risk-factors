-- Base SQL Tables - State
LANGUAGE plpgsql;

-- -- i_1: intimate partner violence
-- DROP TABLE IF EXISTS i_1_nipsvs_a CASCADE;
-- DROP TABLE IF EXISTS i_1;
-- CREATE TABLE i_1 (
--     "STATE" text,
--     "AVPCT" numeric,
--     "AV95PCTCILB" numeric,
--     "AV95PCTCIUB" numeric,
--     "AVESTNV" integer,
--     "CSVPCT" numeric,
--     "CSV95PCTCILB" numeric,
--     "CSV95PCTCIUB" numeric,
--     "CSVESTNV" integer,
--     "PVPCT" numeric,
--     "PV95PCTCILB" numeric,
--     "PV95PCTCIUB" numeric,
--     "PVESTNV" integer,
--     "SPCT" numeric,
--     "S95PCTCILB" numeric,
--     "S95PCTCIUB" numeric,
--     "SESTNV" integer,
--     "AIVPCT" numeric,
--     "AIV95PCTCILB" numeric,
--     "AIV95PCTCIUB" numeric,
--     "AIVESTNV" integer,
--     PRIMARY KEY ("STATE")
-- ) WITH (
--     OIDS = FALSE
-- );

-- \COPY i_1 FROM 'csv/I-1.csv' HEADER CSV DELIMITER ',';

-- i_1: intimate partner psychological aggresssion
DROP TABLE IF EXISTS i_1;
CREATE TABLE i_1 (
    "STATE" text,
    "APPCT" numeric,
    "AP95PCTCILB" numeric,
    "AP95PCTCIUB" numeric,
    "APESTNV" integer,
    "EVPCT" numeric,
    "EV95PCTCILB" numeric,
    "EV95PCTCIUB" numeric,
    "EVESTNV" integer,
    "CCPCT" numeric,
    "CC95PCTCILB" numeric,
    "CC95PCTCIUB" numeric,
    "CCESTNV" integer,
    PRIMARY KEY ("STATE")
) WITH (
    OIDS = FALSE
);

\COPY i_1 FROM 'csv/I-1.csv' HEADER CSV DELIMITER ',';

-- i_4: Mother Lacks Emotional Support
DROP TABLE IF EXISTS i_4 CASCADE;
CREATE TABLE i_4 (
    "STATE" text,
    "YESPCT" numeric,
    "NOPCT" numeric,
    "TOTALPCT" numeric,
    PRIMARY KEY ("STATE")
) WITH (
    OIDS = FALSE
);

\COPY i_4 FROM 'csv/I-4.csv' HEADER CSV DELIMITER ',';

-- i_5: Intended Pregnancy
DROP TABLE IF EXISTS i_5 CASCADE;
CREATE TABLE i_5 (
    "STATE" text,
    "YEAR" char(4),
    "HLTHIND" text,
    "N" integer,
    "PCT" numeric,
    "PCT95CILB" numeric,
    "PCT95CIUB" numeric,
    PRIMARY KEY ("STATE","YEAR","HLTHIND")
) WITH (
    OIDS = FALSE
);

\COPY i_5 FROM 'csv/I-5.csv' HEADER CSV DELIMITER ',';

-- ii_7: Education Attainment by Fertility Status
-- https://data.census.gov/mdat/#/search?ds=ACSPUMS5Y2020&cv=SCHL&rv=ucgid,FER&wt=PWGTP&g=0400000US01,02,04,05,06,08,09,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,49,50,51,53,54,55,56
DROP TABLE IF EXISTS ii_7 CASCADE;
CREATE TABLE ii_7 (
    "STATEFP" text,
    "FER" integer,
    "EA0" integer,
    "EA1" integer,
    "EA2" integer,
    "EA3" integer,
    "EA4" integer,
    "EA5" integer,
    "EA6" integer,
    "EA7" integer,
    "EA8" integer,
    "EA9" integer,
    "EA10" integer,
    "EA11" integer,
    "EA12" integer,
    "EA13" integer,
    "EA14" integer,
    "EA15" integer,
    "EA16" integer,
    "EA17" integer,
    "EA18" integer,
    "EA19" integer,
    "EA20" integer,
    "EA21" integer,
    "EA22" integer,
    "EA23" integer,
    "EA24" integer,
    PRIMARY KEY ("STATEFP","FER")
) WITH (
    OIDS = FALSE
);

\COPY ii_7 FROM 'csv/II-7.csv' HEADER CSV DELIMITER ',';

-- -- ii_9: Employment Status by Fertility Status
-- -- https://data.census.gov/mdat/#/search?ds=ACSPUMS5Y2020&cv=ESR&rv=ucgid,FER&wt=PWGTP&g=0400000US01,02,04,05,06,08,09,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,49,50,51,53,54,55,56
-- DROP TABLE IF EXISTS ii_8_esrxfer CASCADE;
-- DROP TABLE IF EXISTS ii_9 CASCADE;
-- CREATE TABLE ii_9 (
--     "STATEFP" text,
--     "FER" integer,
--     "ESR0" integer,
--     "ESR1" integer,
--     "ESR2" integer,
--     "ESR3" integer,
--     "ESR4" integer,
--     "ESR5" integer,
--     "ESR6" integer,
--     PRIMARY KEY ("STATEFP","FER")
-- ) WITH (
--     OIDS = FALSE
-- );

-- \COPY ii_9 FROM 'csv/II-9.csv' HEADER CSV DELIMITER ',';

-- ii_9: Employment Status of Parents by Household presence and age of Chilren
-- https://data.census.gov/mdat/#/search?ds=ACSPUMS5Y2020&cv=ESP&rv=ucgid,HUPAC&wt=PWGTP&g=0400000US01,02,04,05,06,08,09,10,11,12,13,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,49,50,51,53,54,55,56
DROP TABLE IF EXISTS ii_9 CASCADE;
CREATE TABLE ii_9 (
    "STATEFP" text,
    "HUPAC" integer,
    "ESP0" integer,
    "ESP1" integer,
    "ESP2" integer,
    "ESP3" integer,
    "ESP4" integer,
    "ESP5" integer,
    "ESP6" integer,
    "ESP7" integer,
    "ESP8" integer,
    PRIMARY KEY ("STATEFP","HUPAC")
) WITH (
    OIDS = FALSE
);

\COPY ii_9 FROM 'csv/II-9.csv' HEADER CSV DELIMITER ',';

-- dmn_20
DROP TABLE IF EXISTS dmn_20 CASCADE;
CREATE TABLE dmn_20 (
    "STATE" text,
    "STEXVG" numeric,
    "STGD" numeric,
    "STFP" numeric,
    "STTOT" numeric,
    PRIMARY KEY ("STATE")
) WITH (
    OIDS = FALSE
);

\COPY dmn_20 FROM 'csv/DMN-20.csv' HEADER CSV DELIMITER ',';

-- dmn_21
DROP TABLE IF EXISTS dmn_21 CASCADE;
CREATE TABLE dmn_21 (
    "STATE" text,
    "HD2DVW" numeric,
    "HD2DSW" numeric,
    "HD2DNVW" numeric,
    "HD2DTOT" numeric,
    PRIMARY KEY ("STATE")
) WITH (
    OIDS = FALSE
);

\COPY dmn_21 FROM 'csv/DMN-21.csv' HEADER CSV DELIMITER ',';
