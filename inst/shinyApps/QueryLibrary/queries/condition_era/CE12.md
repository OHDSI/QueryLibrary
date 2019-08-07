<!---
Group:condition era
Name:CE12 Distribution of condition era start dates
Author:Patrick Ryan
CDM Version: 5.3
-->

# CE12: Distribution of condition era start dates

## Description
This query is used to to provide summary statistics for condition era start dates (condition_era_start_date) across all condition era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
WITH ordered_data AS (
SELECT condition_concept_id,
       condition_era_start_date,
       ROW_NUMBER() OVER (PARTITION BY condition_concept_id ORDER BY condition_era_start_date) order_nr,
       COUNT(*) OVER (PARTITION BY condition_concept_id) AS population_size
  FROM @cdm.condition_era
 WHERE condition_concept_id IN ( 256723, 372906, 440377, 441202, 435371 )
), percentiles AS (
SELECT condition_concept_id,
       MIN(CASE WHEN order_nr < .25 * population_size THEN DATEFROMPARTS(9999,1,1) ELSE condition_era_start_date END) AS pct_25,
       MIN(CASE WHEN order_nr < .50 * population_size THEN DATEFROMPARTS(9999,1,1) ELSE condition_era_start_date END) AS median,
       MIN(CASE WHEN order_nr < .75 * population_size THEN DATEFROMPARTS(9999,1,1) ELSE condition_era_start_date END) AS pct_75
  FROM ordered_data
 GROUP BY condition_concept_id
), aggregates AS (
SELECT condition_concept_id,
       MIN(condition_era_start_date) AS min_start_date,
       MAX(condition_era_start_date) AS max_start_date,
       -- Julian Date arithmetic doesn't seem natively supported by all RDBMS,
       -- using days since Jan 1 of Year 1 ('0001-01-01','YYYY-MM-DD') instead.
       DATEADD(d,AVG(CAST(DATEDIFF(day,DATEFROMPARTS(1,1,1),condition_era_start_date) AS FLOAT)),DATEFROMPARTS(1,1,1)) AS avg_start_date,
       ROUND(STDEV(CAST(DATEDIFF(day,DATEFROMPARTS(1,1,1),condition_era_start_date) AS FLOAT)),0) AS std_dev_days
  FROM @cdm.condition_era
 WHERE condition_concept_id IN ( 256723, 372906, 440377, 441202, 435371 )
 GROUP BY condition_concept_id
 )
 SELECT a.*, p.*
   FROM aggregates a
   JOIN percentiles p
     ON a.condition_concept_id = p.condition_concept_id
  ORDER BY a.condition_concept_id;
```
## Input
  None

## Output

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

## Example output record

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
