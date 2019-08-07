<!---
Group:condition era
Name:CE13 Distribution of condition occurrence count
Author:Patrick Ryan
CDM Version: 5.3
-->

# CE13: Distribution of condition occurrence count

## Description
This query is used to to provide summary statistics for condition occurrence counts (condition_occurrence_count) across all condition era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
WITH count_data AS (
SELECT condition_concept_id, COUNT(*) AS condition_occurrence_count
  FROM @cdm.condition_era
 WHERE condition_concept_id IN ( 256723, 372906, 440377, 441202, 435371 )
 GROUP BY condition_concept_id
), ordered_data AS (
SELECT condition_concept_id, condition_occurrence_count,
       ROW_NUMBER()OVER(ORDER BY condition_occurrence_count) AS order_nr
  FROM count_data
)
SELECT condition_concept_id,
       condition_occurrence_count,
       MIN(condition_occurrence_count)over() AS min_count,
       MAX(condition_occurrence_count)over() AS max_count,
       AVG(condition_occurrence_count)over() AS avg_count,
       ROUND(STDEV(condition_occurrence_count)over(),0) AS stdev_count,
       MAX(CASE WHEN order_nr = 2 then condition_occurrence_count else 0 END)OVER() AS percentile_25,
       MAX(CASE WHEN order_nr = 3 then condition_occurrence_count else 0 END)OVER() AS median,
       MAX(CASE WHEN order_nr = 4 then condition_occurrence_count else 0 END)OVER() AS percentile_75
  FROM ordered_data;
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
