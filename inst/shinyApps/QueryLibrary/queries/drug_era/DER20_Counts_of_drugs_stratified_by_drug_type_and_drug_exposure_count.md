<!---
Group:drug era
Name:DER20 Counts of drugs, stratified by drug type and drug exposure count
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER20: Counts of drugs, stratified by drug type and drug exposure count

## Description
This query is used to count drugs (drug_concept_id) across all drug exposure records stratified by drug exposure type (drug_type_concept_id, in CDM V2 drug_exposure_type) and drug exposure count (drug_exposure_count) for each era. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id, a drug_type_concept_id and a drug_exposure_count. If the input is omitted, all existing value combinations are summarized.

## Query
```sql
with tt as (
  SELECT
    YEAR((min(t.drug_era_start_date) over(partition by t.person_id, t.drug_concept_id))) - p.year_of_birth as stat_value,
    t.drug_concept_id
  FROM
    @cdm.drug_era t,
    @cdm.person p
  where
    t.person_id = p.person_id and
    t.drug_concept_id in (1300978, 1304643, 1549080)   --input
)
SELECT
  tt.drug_concept_id,
  min(tt.stat_value) AS min_value,
  max(tt.stat_value) AS max_value,
  avg(tt.stat_value) AS avg_value,
  round(STDEV(tt.stat_value), 0) AS STDEV_value ,
  (select distinct PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY tt.stat_value) OVER() from tt) AS percentile_25,
  (select distinct PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS median_value,
  (select distinct PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS percential_75
FROM tt
group by drug_concept_id;
```



## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_id |   | Yes |   |
| drug_exposure_count |   | Yes |   |

## Output

|  Field |  Description |
| --- | --- |
| drug_concept_id |  A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| min_value |   |
| max_value |   |
| avg_value |   |
| stddev_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| drug_concept_id |  1300978 |
| min_value | 0 |
| max_value | 89 |
| avg_value | 65 |
| stddev_value | 14 |
| percentile_25 | 59 |
| median_value | 70 |
| percentile_75 | 80 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
