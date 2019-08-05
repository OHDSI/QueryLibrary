<!---
Group:condition era
Name:CE16 Distribution of condition era length, stratified by condition and condition type
Author:Patrick Ryan
CDM Version: 5.3
-->

# CE16: Distribution of condition era length, stratified by condition and condition type

## Description
This query is used to provide summary statistics for the condition era length across all condition era records stratified by condition (condition_concept_id) and condition type (condition_type_concept_id, in CDM V2 condition_occurrence_type): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The length of an era is defined as the difference between the start date and the end date. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id and a condition_type_concept_id. If the input is omitted, all existing value combinations are summarized.

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql

WITH count_data AS (
SELECT ce.condition_concept_id, co.condition_type_concept_id, COUNT(*) AS condition_occurrence_count
  FROM @cdm.condition_era ce
  JOIN @cdm.condition_occurrence co
    ON ce.condition_concept_id = co.condition_concept_id
   AND ce.person_id            = co.person_id
 WHERE ce.condition_concept_id IN ( 256723, 372906, 440377, 441202, 435371 )
 GROUP BY ce.condition_concept_id, co.condition_type_concept_id
), ordered_data AS (
SELECT condition_concept_id, condition_type_concept_id, condition_occurrence_count,
       ROW_NUMBER()OVER(PARTITION BY condition_type_concept_id ORDER BY condition_occurrence_count) AS order_nr,
       COUNT(*)OVER(PARTITION BY condition_type_concept_id) AS population_size
  FROM count_data
)
SELECT condition_concept_id,
       condition_type_concept_id,
       condition_occurrence_count,
       MIN(condition_occurrence_count)over(PARTITION BY condition_type_concept_id) AS min_count,
       MAX(condition_occurrence_count)over(PARTITION BY condition_type_concept_id) AS max_count,
       AVG(condition_occurrence_count)over(PARTITION BY condition_type_concept_id) AS avg_count,
       ROUND(STDEV(condition_occurrence_count)over(PARTITION BY condition_type_concept_id),0) AS stdev_count,
       MIN(CASE WHEN order_nr < .25 * population_size then 9999999999 else condition_occurrence_count END)OVER(PARTITION BY condition_type_concept_id) AS percentile_25,
       MIN(CASE WHEN order_nr < .50 * population_size then 9999999999 else condition_occurrence_count END)OVER(PARTITION BY condition_type_concept_id) AS median,
       MIN(CASE WHEN order_nr < .75 * population_size then 9999999999 else condition_occurrence_count END)OVER(PARTITION BY condition_type_concept_id) AS percentile_75
  FROM ordered_data
 ORDER BY condition_type_concept_id, condition_concept_id;
```


## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id |   | No |   |
| condition_type_concept_id |   | No |   |

## Output

|  Field |  Description |
| --- | --- |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| min |   |
| max |   |
| avg |   |
| STDEV |   |
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
| STDEV |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
