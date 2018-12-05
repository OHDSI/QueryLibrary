<!---
Group:condition era
Name:CE13 Distribution of condition occurrence count
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE13: Distribution of condition occurrence count

## Description
This query is used to to provide summary statistics for condition occurrence counts (condition_occurrence_count) across all condition era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Input <None>

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT 
  condition_concept_id,
  MIN( condition_occurrence_count ) AS min , 
  max( condition_occurrence_count ) AS max, 
  avg( condition_occurrence_count ) AS average , 
  round( stdDev( condition_occurrence_count ) ) AS stdDev,
  percentile_25,
  median,
  percentile_75
FROM (
  select
    condition_concept_id,
    condition_occurrence_count,
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY condition_occurrence_count) over() AS percentile_25,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY condition_occurrence_count) over() AS median , 
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY condition_occurrence_count) over() AS percentile_75
  from condition_era 
  WHERE condition_concept_id IN( 254761, 257011, 320128, 432867, 25297 ) 
)
GROUP BY 
  condition_concept_id,
  percentile_25,
  median,
  percentile_75
;
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
