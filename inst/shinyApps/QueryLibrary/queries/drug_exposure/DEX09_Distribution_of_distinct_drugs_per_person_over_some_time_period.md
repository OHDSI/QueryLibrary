<!---
Group:drug exposure
Name:DEX09 Distribution of distinct drugs per person over some time period
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX09: Distribution of distinct drugs per person over some time period

## Description
| This query is to determine the distribution of distinct drugs patients are exposed to during a certain time period. If the time period is omitted, the entire time span of the database is considered.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| date from | 01-Jan-2008 | Yes |   |
| date to | 31-Dec-2008 | Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.  

```sql
SELECT MIN ( drugs ) AS min ,
approximate  PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY drugs ) as percentile_25,
ROUND ( AVG ( drugs ), 2 ) AS mean,
approximate PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY drugs ) AS median ,
approximate PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY drugs ) AS percential_75,
MAX ( drugs ) AS max,
 ROUND ( STDDEV ( drugs ), 1 ) AS STDEV
 FROM  (SELECT person_id, ISNULL( drugs, 0 ) AS drugs FROM @cdm.person  JOIN
 ( SELECT person_id, COUNT( DISTINCT drug_concept_id ) AS drugs FROM @cdm.drug_exposure 
 WHERE drug_exposure_start_date BETWEEN '2017-01-01' AND '2017-12-31' GROUP BY person_id ) USING( person_id ) );
```

## Output


## Output field list

| Field |  Description |
| --- | --- |
| min | The minimum number of drugs taken by a patient |
| percentile_25 | The 25th percentile of the distibution |
| mean | The mean or average of drugs taken by patients |
| median | The median number of drugs take |
| percentile_75 | The 75th percentile of the distribution |
| max | The maximum number of drugs taken by a patient |
| stddev | The standard deviation of the age distribution |


## Sample output record

| Field |  Content |
| --- | --- |
| min | 0 |
| percentile_25 | 0 |
| mean | 1.73 |
| median | 0 |
| percentile_75 | 1 |
| max | 141 |
| stddev | 4.2 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
