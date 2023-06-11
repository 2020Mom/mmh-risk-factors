
# Maternal Mental Health Risk Factors

## Contents
- [Overview](#overview)
- [Geography](#geography)
- [Risk Factors](#risk-factors)\
&emsp;- [Tier I (18 pts max)](#tier-i-18-pts-max)\
&emsp;&emsp;&emsp;[Lifetime Prevalence of Psychological Aggression by an Intimate Partner](#1)\
&emsp;&emsp;&emsp;[Violent Crime](#2)\
&emsp;&emsp;&emsp;[Poor Mental Health Days](#3)\
&emsp;&emsp;&emsp;[Mother lacks emotional support](#4)\
&emsp;&emsp;&emsp;[Pregnancy: Mistimed, Unwanted, Unsure whether Wanted, Intended](#5)\
&emsp;&emsp;&emsp;[Children in poverty](#6)\
&emsp;- [Tier II (12 pts max)](#tier-ii-12-pts-max)\
&emsp;&emsp;&emsp;[Educational Attainment by Fertility Status (gave birth within last 12 months)](#7)\
&emsp;&emsp;&emsp;[Children in single parent households](#8)\
&emsp;&emsp;&emsp;[Employment Status of Parents by Household presence and age of Children](#9)\
&emsp;&emsp;&emsp;[Teen births](#10)\
&emsp;&emsp;&emsp;[Cesarean Delivery Rate](#11)\
&emsp;&emsp;&emsp;[Preterm birth rates](#12)\
&emsp;- [Tier III (7 pts max)](#tier-iii-7-pts-max)\
&emsp;&emsp;&emsp;[Mental Healthcare Providers](#13)\
&emsp;&emsp;&emsp;[Income Inequality](#14)\
&emsp;&emsp;&emsp;[Reproductive Age, % white](#15)\
&emsp;&emsp;&emsp;[Reproductive Age, % Hispanic](#16)\
&emsp;&emsp;&emsp;[Lack of insurance coverage](#17)\
&emsp;&emsp;&emsp;[Severe housing problems](#18)\
&emsp;&emsp;&emsp;[Food insecurity](#19)\
&emsp;- [Direct Measures of Need (8 pts max)](#direct-measures-of-need-8-pts-max)\
&emsp;&emsp;&emsp;[Poor mental health among mothers](#20)\
&emsp;&emsp;&emsp;[Mothers not coping well with raising their child](#21)\
&emsp;&emsp;&emsp;[Births and birth rates for reproductive age women](#22)
- [Perinatal Mental Healthcare Providers](#perinatal-mental-healthcare-providers)\
&emsp;&emsp;&emsp;[Certified Providers, by County](#23)
- [PostgreSQL Tables and Queries](#postgresql-tables-and-queries)
- [Perinatal Risk Factor Scores](#perinatal-risk-factor-scores)
## Overview

Risk Factors Scores for Perinatal Mental Health are derived by an algorithm incorporating:

- 19 factors that are shown to be associated with a greater risk of perinatal mental health disorders, and

- 3 factors which are direct measures of need.

US regions with compounded perinatal mental health risk factors may be in greater need of high-quality, person-centered perinatal mental health support.

<img src="png/prfs_composite_map.png">

## Geography

The study area consists of 3143 second level political divisions, including every county, parish, borough, and county-equivalent municipality within the 51 first level divisions which comprise the 50 states and the federal district.

A large contingent of the data is sourced from the County Health Rankings published by the University of Wisconsin Population Health Institute. The CHR data does not include data for the five populated U.S. territories, therefore those divisions have been omitted from the scoring and analysis.

The CHR and CDC data includes Valdez-Cordova census area (FIPS: 02261), an unorganized borough of Alaska that was abolished in 2019 and replaced by the census areas of Chugach (FIPS: 02063) and Copper River (FIPS: 02066). Data from Valdez-Cordova was applied to Chugach and Copper River for each risk factor component that uses CHR data.

Data from the CDC on Cesarean section deliveries includes Wade Hampton census area (AK FIPS:02270), which in 2015 was renamed Kusilvak census area (AK FIPS:02158); the data was adjusted accordingly.

Data from the CDC on Cesarean section deliveries includes Shannon County (SD FIPS:02270), which in 2015 was renamed Oglala County (SD FIPS:02158); the data was adjusted accordingly.

## Risk Factors

Perinatal health risk factors are divided into three tiers, using a scale which allocates:\
&emsp;&emsp;up to (3) points per Tier I qualifier,\
&emsp;&emsp;up to (2) points per Tier II qualifier, and\
&emsp;&emsp;up to (1) point per Tier III qualifier.\
Additionally, there are several Direct Measures of Need, which are allocated up to (3) points per qualifier.\
The Maximum Point Total is 45.

### Tier I (18 pts max)
Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="1"/>[I-1](csv/I-1.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2017) National Intimate Partner and Sexual Violence Survey,\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;State Reports 2010-2012\
Description:&emsp;&emsp;Lifetime Prevalence of Psychological Aggression by an Intimate Partner; State Level\
Key Variable:&emsp;&ensp;&nbsp;(%) Intimate-Partner Victimization of Any Kind\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within U.S: 2pts; Second-Highest Quartile: 1pt

<img src="png/I-1_map.png">
<pre>
    "STATE"         Name of state

    ***Any Psychological Aggression***
    "APPCT"         Weighted (%), Victimization
    "AP95PCTCILB"   Lower Bound, 95% C.I.
    "AP95PCTCIUB"   Upper Bound, 95% C.I.
    "APESTNV"       Estimated (#) Victims

    ***Any Expressive Aggression***
    "EVPCT"         Weighted (%), Victimization
    "EV95PCTCILB"   Lower Bound, 95% C.I.
    "EV95PCTCIUB"   Upper Bound, 95% C.I.
    "EVESTNV"       Estimated (#) Victims

    ***Any Coercive Control***
    "CCPCT"         Weighted (%), Victimization
    "CC95PCTCILB"   Lower Bound, 95% C.I.
    "CC95PCTCIUB"   Upper Bound, 95% C.I.
    "CCESTNV"       Estimated (#) Victims
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="2"/>[I-2](csv/I-2.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Violent Crime\
Key Variable:&emsp;&ensp;&nbsp;Violent Crime Rate: (#) violent crimes reported per 100,000 population; County Level\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt\

<img src="png/I-2_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "AAVC"          Average Annual Violent Crimes
    "VCR"           Violent Crime Rate: (#) violent crimes reported per 100,000 population
    "VCRQRT"        County Quartile within State
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="3"/>[I-3](csv/I-3.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Poor Mental Health Days; County Level\
Key Variable:&emsp;&ensp;&nbsp;Average (#) Mentally Unhealthy Days per Month\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US:3pts; Second-Highest Quartile:2pts

<img src="png/I-3_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "AVNMUD"        Average (#) Mentally Unhealthy Days per Month
    "AVNMUD95CILB"  Lower Bound, 95% C.I.
    "AVNMUD95CIUB"  Upper Bound, 95% C.I.
    "AVMUDQRT"      County Quartile within State
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="4"/>[I-4](csv/I-4.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2020-2021) National Survey of Children’s Health,\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;Health Resources and Services Administration, Maternal and Child Health Bureau\
Description:&emsp;&emsp;Mother lacks emotional support; State Level\
Key Variable:&emsp;&ensp;&nbsp;(%) Answering 'Yes'\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within U.S: 3pts; Second-Highest Quartile: 2pts

<img src="png/I-4_map.png">
<pre>
Indicator 6.15: During the past 12 months, was there someone that you could turn to for
                day-to-day emotional support with parenting or raising children?
    "STATE"         Name of State
    "YESPCT"        (%) Answering 'Yes'
    "NOPCT"         (%) Answering 'No'
    "TOTALPCT"      (%) Total
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="5"/>[I-5](csv/I-5.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2016-2020) Centers for Disease Control and Prevention (CDC)\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Pregnancy Risk Assessment Monitoring System (PRAMS)\
Description:&emsp;&emsp;Pregnancy: Mistimed, Unwanted, Unsure whether Wanted, Intended; State Level\
Key Variable:&emsp;&ensp;&nbsp;(%) Pregnancies: Intended\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Lowest Quartile within US: 3pts; Second-Lowest Quartile: 2pts

<img src="png/I-5_map.png">
<pre>
    "STATE"         Name of State
    "YEAR"          Year of Survey
    "HLTHIND"       Health Indicator: Mistimed, Unwanted, Unsure whether wanted, Intended 
    "N"             Sample Size
    "PCT"           (%)
    "PCT95CILB"     Lower Bound, 95% C.I.
    "PCT95CIUB"     Upper Bound, 95% C.I.
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="6"/>[I-6](csv/I-6.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps,\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Children in poverty; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) (all children)\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 3pts; Second-Highest Quartile: 2pts

<img src="png/I-6_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County

    ***Children in Poverty***
    "CIPPCT"        (%) (all children)
    "CIP95CILB"     Lower Bound, 95% C.I. (all children)
    "CIP95CIUB"     Upper Bound, 95% C.I. (all children)
    "CIPQRT"        County Quartile within State (all children)
    "CIPPCTAIAN"    (%) (American Indian and Alaska Native)
    "CIPPCTASIAN"   (%) (Asian)
    "CIPPCTBLACK"   (%) (Black)
    "CIPPCTHSP"     (%) (Hispanic)
    "CIPPCTWH"      (%) (white)  
</pre>

### Tier II (12 pts max)
Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="7"/>[II-7](csv/II-7.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2020)ACS 5-Year Estimates Public Use Microdata Sample\
Description:&emsp;&emsp;Educational Attainment by Fertility Status (gave birth last 12 mo); State Level\
Key Variable:&emsp;&ensp;&nbsp;Below College Degree, Gave birth to child within past 12 months=Yes\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt

<img src="png/II-7_map.png">
<pre>
    "STATEFP"       Federal Information Processing System Code
    "FER"           Gave birth to child within the past 12 months:
                        0=n/a
                        1=yes
                        2=no
    "EA0"           N/A (less than 3 years old)
    "EA1"           No schooling completed
    "EA2"           Nursery school, preschool
    "EA3"           Kindergarten
    "EA4"           Grade 1
    "EA5"           Grade 2 
    "EA6"           Grade 3
    "EA7"           Grade 4
    "EA8"           Grade 5
    "EA9"           Grade 6
    "EA10"          Grade 7
    "EA11"          Grade 8
    "EA12"          Grade 9
    "EA13"          Grade 10
    "EA14"          Grade 11
    "EA15"          12th grade - no diploma
    "EA16"          Regular high school diploma
    "EA17"          GED or alternative credential
    "EA18"          Some college, but less than 1 year
    "EA19"          1 or more years of college credit, no degree
    "EA20"          Associate's degree
    "EA21"          Bachelor's degree
    "EA22"          Master's degree
    "EA23"          Professional degree beyond a bachelor's degree
    "EA24"          Doctorate degree
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="8"/>[II-8](csv/II-8.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Children in single parent households; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) of Children in Single-Parent Households\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within state: 2pts; Second-Highest Quartile: 1pt

<img src="png/II-8_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "NCHSPHH"       (#) of Children in Single-Parent Households
    "NCHHH"         (#) of Children in Households
    "PCTCHSPHH"     (%) of Children in Single-Parent Households
    "PCT95CILB"     Lower Bound, 95% C.I.
    "PCT95CIUB"     Upper Bound, 95% C.I.
    "PCTQRT"        County Quartile within State
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="9"/>[II-9](csv/II-9.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2020)ACS 5-Year Estimates Public Use Microdata Sample\
Description:&emsp;&emsp;Employment Status of Parents by Household presence and age of Children; State Level\
Key Variable:&emsp;&ensp;&nbsp;At least one parent unemployed, HHs with children\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt

<img src="png/II-9_map.png">
<pre>
    "STATEFP"       Federal Information Processing System Code
    "HUPAC"         HH presence and age of children:
                        0=n/a (GQ/vacant)
                        1=With children less than 6 years only
                        2=With children 6 to 17 years only
                        3=With children under 6 years and 6 to 17 years
                        4=No children
    "ESP0"          N/A (not own child of householder, and not child in subfamily)
    "ESP1"          Living with two parents: Both parents in labor force
    "ESP2"          Living with two parents: Father only in labor force
    "ESP3"          Living with two parents: Mother only in labor force
    "ESP4"          Living with two parents: Neither parent in labor force
    "ESP5"          Living with father: Father in labor force
    "ESP6"          Living with father: Father not in labor force
    "ESP7"          Living with mother: Mother in labor force
    "ESP8"          Living with mother: Mother not in labor force
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="10"/>[II-10](csv/II-10.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Teen births; County Level\
Key Variable:&emsp;&ensp;&nbsp;(#) of births per 1,000 female population ages 15-19\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt

<img src="png/II-10_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "TNBR"          (#) of births per 1,000 female population ages 15-19
    "TNBR95CILB"    Lower Bound, 95% C.I.
    "TNBR95CIUB"    Upper Bound, 95% C.I.
    "TNBRQRT"       County Quartile within State
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="11"/>[II-11](csv/II-11.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2020) Centers for Disease Control and Prevention (CDC) National Center for Health Statistics\
Description:&emsp;&emsp;Cesarean Delivery Rate; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) of all live births that were cesarean deliveries\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt

<img src="png/II-11_map.png">
<pre>
    "NAME"          Name of State/County
    "PERCENT"       (%) of all live births that were cesarean deliveries
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="12"/>[II-12](csv/II-12.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2017-2019) Health Resources & Services Administration (HRSA) Maternal & Child Health Bureau\
Description:&emsp;&emsp;Preterm birth rates; County Level\
Key Variable:&emsp;&ensp;&nbsp;Estimated (%) of live births that are preterm (/> 37 weeks)\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt

<img src="png/II-12_map.png">
<pre>
    "REGION"        HRSA Region
    "STATE"         Name of State
    "COUNTY"        Name of County
    "PRETBRPCT"     Estimated (%) of live births that are preterm (/> 37 weeks)
    "FIPS"          Federal Information Processing System Code
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="13"/>[III-13](csv/III-13.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Mental Healthcare Providers; County Level\
Key Variable:&emsp;&ensp;&nbsp;(#) of mental healthcare providers\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Below median within US: 1pt

### Tier III (7 pts max)

<img src="png/III-13_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "MHP_NUMBER"    (#) of mental health providers
    "MHP_RATE"      Mental Health Providers per 100,000 population
    "MHP_RATIO"     Population to Mental Health Providers ratio
    "MHP_QRT"       Within-state rank: 1 = top quartile, 2=second quartile, 3= third quartile, 4=bottom quartile
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="14"/>[III-14](csv/III-14.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Income Inequality; County Level\
Key Variable:&emsp;&ensp;&nbsp;Income Ratio (80th percentile/20th percentile)\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Above median within US: 1pt

<img src="png/III-14_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "MHP_NUMBER"    (#) of mental healthcare providers
    "MHP_RATE"      Mental Healthcare Providers per 100,000 population
    "MHP_RATIO"     Population to Mental Healthcare Providers ratio
    "MHP_QRT"       Within-state rank: 1 = top quartile, 2=second quartile, 3= third quartile, 4=bottom quartile
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="15"/>[III-15](csv/III-15.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2019) CDC WONDER Single-Race Population Estimates\
Description:&emsp;&emsp;Reproductive Age, % white; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) of Women 15-44 Years of Age by Race - White\
Points:&emsp;&emsp;&emsp;&emsp;&ensp;Lowest Quartile within US: 2pts; Second-Lowest Quartile: 1pt

<img src="png/III-15_map.png">
<pre>
    "REGION"        HRSA Region
    "STATE"         Name of State
    "COUNTY"        Name of County
    "NRPAWWH"       (#) of Women 15-44 Years of Age by Race - White
    "PCTRPAWWH"     (%) of Women 15-44 Years of Age by Race - White
    "FIPS"          Federal Information Processing System Code
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="16"/>[III-16](csv/III-16.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2019) CDC WONDER Single-Race Population Estimates\
Description:&emsp;&emsp;Reproductive Age, % Hispanic; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) of Women 15-44 Years of Age by Ethnicity - Hispanic or Latina\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Highest-Lowest Quartile: 1pt

<img src="png/III-16_map.png">
<pre>
    "REGION"        HRSA Region
    "STATE"         Name of State
    "COUNTY"        Name of County
    "NRPAWHSP"      (#) of Women 15-44 Years of Age by Ethnicity - Hispanic or Latina
    "PCTRPAWHSP"    (%) of Women 15-44 Years of Age by Ethnicity - Hispanic or Latina
    "FIPS"          Federal Information Processing System Code
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="17"/>[III-17](csv/III-17.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Lack of insurance coverage; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) of Uninsured (adults)\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Above median within US: 1pt

<img src="png/III-17_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County

    ***Uninsured (all)***
    "NUI"           (#) of Uninsured (all)
    "PCTUI"         (%) of Uninsured (all)
    "UI95CILB"      Lower Bound, 95% C.I.
    "UI95CIUB"      Upper Bound, 95% C.I.
    "UIQRT"         County Quartile within State

    ***Uninsured (adults)***
    "NUIAD"         (#) of Uninsured (adults)
    "PCTUIAD"       (%) of Uninsured (adults)
    "UIAD95CILB"    Lower Bound, 95% C.I.
    "UIAD95CIUB"    Upper Bound, 95% C.I.
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="18"/>[III-18](csv/III-18.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Severe housing problems; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) with Severe Housing Problems\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Above median within US: 1pt

<img src="png/III-18_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County

    ***Severe Housing Problems***
    "PCTSHP"        (%) with Severe Housing Problems
    "SHP95CILB"     Lower Bound, 95% C.I.
    "SHP95CIUB"     Upper Bound, 95% C.I.

    ***Severe Housing Cost Burden***
    "SHCB"          (%) with Severe Housing Cost Burden
    "SHCB95CILB"    Lower Bound, 95% C.I.
    "SHCB95CIUB"    Upper Bound, 95% C.I.

    ***Overcrowding***
    "PCTOCRWD"      (%) with Overcrowding
    "OCRWD95CILB"   Lower Bound, 95% C.I.
    "OCRWD95CIUB"   Upper Bound, 95% C.I.

    ***Inadequate Facilities***
    "PCTIAF"        (%) with Inadequate Facilities
    "IAF95CILB"     Lower Bound, 95% C.I.
    "IAF95CIUB"     Upper Bound, 95% C.I.
    "IAFQRT" 
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="19"/>[III-19](csv/III-19.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) County Health Rankings & Roadmaps, University of Wisconsin Population Health Institute\
Description:&emsp;&emsp;Food insecurity; County Level\
Key Variable:&emsp;&ensp;&nbsp;(%) with Food insecurity\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Above median within US: 1pt

<img src="png/III-19_map.png">
<pre>
    "FIPS"          Federal Information Processing System Code
    "STATE"         Name of State
    "COUNTY"        Name of County
    "FEIDX"         Food Environment Index
    "FEIDXQRT"      County Quartile within State
    "NFIS"          (#) with Food insecurity
    "PCTFIS"        (%) with Food insecurity 
    "NLIMA"         (#) with Limited access to healthy foods
    "PCTLIMA"       (%) with Limited access to healthy foods
</pre>

### Direct Measures of Need (8 pts max)
Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="20"/>[DMN-20](csv/DMN-20.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2020-2021) National Survey of Children’s Health, Health Resources and Services Administration,\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Maternal and Child Health Bureau\
Description:&emsp;&emsp;Poor mental health among mothers; State Level\
Key Variable:&emsp;&ensp;(%) with 'Fair or poor' status\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 4pts; Second-Highest Quartile: 3pts

<img src="png/DMN-20_map.png">
<pre>
Indicator 6.2: If this child’s mother is a primary caregiver and lives in the household, in general,
               what is the status of mother's mental and emotional health? 
    "STATE"         Name of State
    "STEXVG"        (%) with 'Excellent or very good' status
    "STGD"          (%) with 'Good' status
    "STFP"          (%) with 'Fair or poor' status
    "STTOT"         (%) total
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="21"/>[DMN-21](csv/DMN-21.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2020-2021) National Survey of Children’s Health, Health Resources and Services Administration,\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; Maternal and Child Health Bureau\
Description:&emsp;&emsp;Mothers not coping well with raising their child; State Level\
Key Variable:&emsp;&ensp;&nbsp;(%) answering 'Very well'\
NOTES:&emsp;&emsp;&emsp;&ensp;Categories 2 & 3 are combined as a negative indicator\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;Scoring based on lowest % answering 'Very well'\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;48 states included, most recent year varies\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Lowest Quartile within US: 4pts; Second-Lowest Quartile: 3pts

<img src="png/DMN-21_map.png">
<pre>
Indicator 6.16: How well do you think you are handling the day-to-day demands of raising children? 
    "STATE"         Name of State
    "HD2DVW"        (%) answering 'Very well'
    "HD2DSW"        (%) answering 'Somewhat well, not very well or not very well at all'
    "HD2DNVW"       (%) answering 'Not very well or not very well at all'
    "HD2DTOT"       (%) total
</pre>

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="22"/>[DMN-22](csv/DMN-22.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2021) Centers for Disease Control and Prevention (CDC), National Center for Health Statistics\
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; (NCHS), National Vital Statistics System\
Description:&emsp;&emsp;Births and birth rates; County Level\
Key Variable:&emsp;&ensp;&nbsp;(#) Births Divided by (#) Females aged 15-44 years\
NOTES:&emsp;&emsp;&emsp;&emsp;Dataset included 626 counties w/ population above 100k\
Points:&emsp;&emsp;&emsp;&emsp;&nbsp;Highest Quartile within US: 2pts; Second-Highest Quartile: 1pt

<img src="png/DMN-22_map.png">
<pre>
    "COUNTY"        Name of County
    "STABRV"        State Abreviation
    "FIPS"          Federal Information Processing System Code
    "BIRTHS"        (#) of Births
    "TOTPOP"        Total Population
    "BIRTHRATE"     (#) Births Divided by Total Population
    "FEMPOP"        (#) Females aged 15-44 years
    "FERTRATE"      (#) Births Divided by (#) Females aged 15-44 years
</pre>

## Perinatal Mental Healthcare Providers

Perinatal mental healthcare providers are essential to the task of responding to and treating mothers experiencing mental distress. Without access to professional help, new mothers are left alone to struggle with their own thoughts and feelings, while they are also responsible for providing all the normal care required by their infants and young children.

The detrimental effects of a supply deficit in perinatal mental healthcare can spiral outward, as at-risk mothers left untreated begin to suffer collateral consequences, which can also involve their children and result in a diminishment in the level of care they receive.

We have gathered data from a variety of authoritative sources in order to quantify the level of provider care available in each county where risk factor scores have been produced.

### PSI Certified Mental Healthcare Providers

Factor:&emsp;&emsp;&emsp;&emsp;&nbsp;<a name="23"/>[PMH Certified Providers](csv/pmh_providers.csv)\
Source:&emsp;&emsp;&emsp;&emsp;(2022) Postpartum Support International, Member Roles\
Description:&emsp;&emsp;List of Certified Providers by Zip Code\
Key Variable:&emsp;&ensp;&nbsp;Count of providers by Zip Code\

<img src="png/providers_cert_county.png">
<img src="png/providers_cert_state.png">
<pre>
    "ACCOUNT_ID"    Certification Holder Account ID
    "CITY"          City of Residence
    "STATE"         State of Residence
    "ZIP"           ZIP Code of Residence
    "OCCUPATION"    Professional role
</pre>

## PostgreSQL Tables and Queries

The folder [pgSQL](pgSQL) contains the SQL files necessary to construct and populate the database from the CSV records contained in [csv](csv).

The file [pgSQL/factors-county.sql](pgSQL/factors-county.sql) defines the basic tables for all county level risk factors and loads each table from CSV.

The file [pgSQL/factors-state.sql](pgSQL/factors-county.sql) defines the basic tables for all state level risk factors and loads each table from CSV.

The file [pgSQL/prfs-county.sql](pgSQL/prfs-county.sql) defines the summary tables for each county level risk factor.

The file [pgSQL/prfs-state.sql](pgSQL/prfs-state.sql) defines the summary tables for each state level risk factor.

The file [pgSQL/scores.sql](pgSQL/scoring.sql) aggregates all of the factor data and scoring, and the composite score for each county, into one table, and exports to CSV at [csv/prfs_counties.csv](csv/prfs_counties.csv)

The file [pgSQL/providers.sql](pgSQL/providers.sql) constructs the PSI Certified MH Providers table and loads the data from CSV.

The file [pgSQL/copy2json.sql](pgSQL/copy2json.sql) creates JSON files for each table in the perinatal_risk_factors database.

## Perinatal Risk Factor Scores

The data was aggregated in [pgSQL/scores.sql](pgSQL/scoring.sql) and exported to CSV at [csv/prfs_counties.csv](csv/prfs_counties.csv)\
The aforementioned file is a table containing each county's FIPS identifier along with the risk factor scores for each of the 22 risk factors, and an aggregate column "PRFS".  Each risk factor includes the factor, the factor score, and the quartile of the factor within the national dataset.
