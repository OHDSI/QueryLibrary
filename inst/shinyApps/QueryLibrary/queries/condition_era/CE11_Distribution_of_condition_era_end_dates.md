<!---
Group:condition era
Name:CE11 Distribution of condition era end dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE11: Distribution of condition era end dates

## Description
This query is used to to provide summary statistics for condition era end dates (condition_era_end_date) across all condition era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Input <None>

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
WITH percentiles AS (
SELECT DISTINCT 
       condition_concept_id,
       PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY condition_era_end_date) over (PARTITION BY condition_concept_id) AS percentile_25, 
       PERCENTILE_DISC(0.50) WITHIN GROUP(ORDER BY condition_era_end_date) over (PARTITION BY condition_concept_id) AS median,
       PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY condition_era_end_date) over (PARTITION BY condition_concept_id) AS percentile_75
  FROM @cdm.condition_era 
 WHERE condition_concept_id IN ( 201826, 437827, 140673, 313217, 439926 )
), aggregates AS (
SELECT condition_concept_id,
       MIN(condition_era_end_date) AS min_end_date,
       MAX(condition_era_end_date) AS max_end_date,
       -- Julian Date arithmetic doesn't seem natively supported by all RDBMS,
       -- using days since Jan 1 of Year 1 ('0001-01-01','YYYY-MM-DD') instead.
       DATEADD(d,AVG(CAST(DATEDIFF(day,CAST('0001-01-01' AS DATE),condition_era_end_date) AS FLOAT)),CAST('0001-01-01' AS DATE)) AS avg_end_date,
       ROUND(STDEV(CAST(DATEDIFF(day,CAST('0001-01-01' AS DATE),condition_era_end_date) AS FLOAT)),0) AS std_dev_days
  FROM @cdm.condition_era
 WHERE condition_concept_id IN ( 201826, 437827, 140673, 313217, 439926 )
 GROUP BY condition_concept_id
 )
 SELECT a.*, p.*
   FROM aggregates a
   JOIN percentiles p
     ON a.condition_concept_id = p.condition_concept_id
  ORDER BY a.condition_concept_id;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| min |   |
| max |   |
| avg |   |
| std_dev_days |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| condition_concept_id |   |
| min |   |
| max |   |
| avg |   |
| std_dev_days |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
