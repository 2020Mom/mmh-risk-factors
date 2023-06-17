#!/bin/bash

# place the api key in a text file in the root directory 
# as CENSUS_API_KEY=YOUR_KEY and name the file ".env"
source .env

# the url query to call for female population tables for
# every county in each state
getFemPop='https://api.census.gov/data/2021/acs/acs5?get=NAME,B01001_001E,B01001_026E,B01001_030E,B01001_031E,B01001_032E,B01001_033E,B01001_034E,B01001_035E,B01001_036E,B01001_037E,B01001_038E&for=county:*&in=state:*'

# combine the url query with the api key
acsQuery=$getFemPop"&key="$CENSUS_API_KEY

# use curl to make the get request and save the response to JSON
curl $acsQuery -o json/rpr_age_fem_pop.json

# use ndjson to sum the reproductive age population and save to CSV
ndjson-cat json/rpr_age_fem_pop.json \
    | ndjson-split 'd.slice(1)' \
    | ndjson-map '{
        NAME: d[0],
        FIPS: d[12] + d[13],
        TOTPOP: d[1],
        FEMPOP: d[2],
        RPRAFPOP: [Number(d[3]),Number(d[4]),Number(d[5]),Number(d[6]),Number(d[7]),Number(d[8]),Number(d[9]),Number(d[10]),Number(d[11])].reduce((total,item) => total + item),
        F15to17: d[3],
        F18to19: d[4],
        F20: d[5],
        F21: d[6],
        F22to24: d[7],
        F25to29: d[8],
        F30to34: d[9],
        F35to39: d[10],
        F40to44: d[11]
        }' \
    | json2csv -n > csv/rpr_age_fem_pop_blank_ending.csv

sed 's/\\r//' < csv/rpr_age_fem_pop_blank_ending.csv > csv/rpr_age_fem_pop.csv
rm csv/rpr_age_fem_pop_blank_ending.csv