<!---
Group:condition era
Name:CE16 Distribution of condition era length, stratified by condition and condition type
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE16: Distribution of condition era length, stratified by condition and condition type

## Description
This query is used to provide summary statistics for the condition era length across all condition era records stratified by condition (condition_concept_id) and condition type (condition_type_concept_id, in CDM V2 condition_occurrence_type): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The length of an era is defined as the difference between the start date and the end date. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id and a condition_type_concept_id. If the input is omitted, all existing value combinations are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id |   | No |   |
| condition_type_concept_id |   | No |   |

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
| stdDev |   |
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
| stdDev |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
