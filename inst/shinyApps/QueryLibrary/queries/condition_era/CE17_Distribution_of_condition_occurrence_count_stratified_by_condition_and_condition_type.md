<!---
Group:condition era
Name:CE17 Distribution of condition occurrence count, stratified by condition and condition type
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE17: Distribution of condition occurrence count, stratified by condition and condition type

## Description
This query is used to provide summary statistics for condition occurrence count (condition_occurrence_count) across all condition era records stratified by condition (condition_concept_id) and condition type (condition_type_concept_id, in CDM V2 condition_occurrence_type): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id and a condition_type_concept_id. If the input is omitted, all existing value combinations are summarized.
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id | 254761, 257011, 320128, 432867, 25297 | No |   |
| condition_type_concept_id |   | No |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT 
  condition_concept_id,
  MIN( occurrences ) AS min , 
  max( occurrences ) AS max, 
  avg( occurrences ) AS average , 
  round( stdDev( occurrences ) ) AS stdDev,
  percentile_25,
  median,
  percentile_75
FROM (
  select
    condition_concept_id, 
    occurrences,
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY occurrences) over() AS percentile_25,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY occurrences) over() AS median , 
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY occurrences) over() AS percentile_75
  from (
    select 
      person_id, 
      condition_concept_id,
      count(*) AS occurrences
    from @cdm.condition_era 
    WHERE condition_concept_id IN( 254761, 257011, 320128, 432867, 25297 ) 
    group by 
      person_id,
      condition_concept_id
  )
)
GROUP BY 
  condition_concept_id,
  percentile_25,
  median,
  percentile_75
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
