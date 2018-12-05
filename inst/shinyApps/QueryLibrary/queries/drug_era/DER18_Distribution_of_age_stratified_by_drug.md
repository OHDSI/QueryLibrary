<!---
Group:drug era
Name:DER18 Distribution of age, stratified by drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER18: Distribution of age, stratified by drug

## Description
This query is used to provide summary statistics for the age across all drug era records stratified by drug (drug_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The age value is defined by the earliest exposure. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. If the input is omitted, age is summarized for all existing drug_concept_id values.

## Query
```sql
SELECT DISTINCT tt.drug_concept_id,
        min(tt.stat_value) over () AS min_value,
        max(tt.stat_value) over () AS max_value,
        avg(tt.stat_value) over () AS avg_value,
        PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY tt.stat_value ) over() AS percentile_25,
        PERCENTILE_DISC(0.5)  WITHIN GROUP( ORDER BY tt.stat_value ) over() AS median_value,
        PERCENTILE_DISC(0.75) WITHIN GROUP( ORDER BY tt.stat_value ) over() AS percential_75
        FROM
    (
        SELECT
      extract(year from (min(t.drug_era_start_date) over(partition by t.person_id, t.drug_concept_id) )) - p.year_of_birth as stat_value,
      t.drug_concept_id
      FROM @cdm.drug_era t, @cdm.person p
      WHERE t.person_id = p.person_id
       and t.drug_concept_id in (1300978, 1304643, 1549080)
    ) tt
```



## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of concept_id | 1300978, 1304643, 1549080 | Yes |   |

## Output

|  Field |  Description |
| --- | --- |
| Drug_concept_id | Unique identifier for drug |
| Min_value | Minimum number of drug era records for drug |
| Max_value | Maximum number of drug era records for drug |
| Avg_value | Average number of drug era records for drug |
| percentile_25_date | 25th percentile number of drug era records for drug |
| median_date | Median number of drug era records for drug |
| percentile_75_date | the 75th percentile number of drug era records for drug |

## Sample output record

|  Field |  Description |
| --- | --- |
| Drug_concept_id | 1304643 |
| Min_value | 0 |
| Max_value | 108 |
| Avg_value | 69 |
| percentile_25_date | 59 |
| median_date | 70 |
| percentile_75_date | 80 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
