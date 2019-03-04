<!---
Group:drug era
Name:DER23 Distribution of drug era start dates, stratified by drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER23: Distribution of drug era start dates, stratified by drug

## Description
This query is used to summary statistics of the drug era start dates (drug_era_start_date) across all drug era records, stratified by drug (drug_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. If the input is omitted, all possible values are summarized.

## Query
```sql
with tt as (
  SELECT datediff(day, MIN(t.drug_era_start_date) OVER(partition by t.drug_concept_id), t.drug_era_start_date) AS start_date_num
  ,      t.drug_era_start_date AS start_date
  ,      MIN(t.drug_era_start_date) OVER(partition by t.drug_concept_id) min_date
  ,      t.drug_concept_id
  FROM @cdm.drug_era t
  where t.drug_concept_id in (1300978, 1304643, 1549080)
)
SELECT tt.drug_concept_id
,      min(tt.start_date_num) AS min_value
,      max(tt.start_date_num) AS max_value
,      dateadd(day, avg(tt.start_date_num), tt.min_date) AS avg_value
,      round(STDEV(tt.start_date_num), 0) AS STDEV_value
,      dateadd(day, (select distinct PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY tt.start_date_num) OVER() from tt), tt.min_date) AS percentile_25
,      dateadd(day, (select distinct PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.start_date_num) OVER() from tt), tt.min_date) AS median_value
,      dateadd(day, (select distinct PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.start_date_num) OVER() from tt), tt.min_date) AS percential_75
FROM tt
group by
  drug_concept_id,
  tt.min_date
order by
  drug_concept_id
;
```

## Input

| Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| drug_concept_id | 1300978, 1304643, 1549080 | Yes |   |

## Output

| Field |  Description |
| --- | --- |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| min_value |   |
| max_value |   |
| avg_value | The start date for the drug era constructed from the individual instances of drug exposures. It is the start date of the very first chronologically recorded instance of utilization of a drug. |
| stddev_value |   |
| percentile_25 |      |
| median_value |      |
| percentile_75 |      |

## Sample output record

| Field |  Description |
| --- | --- |
| drug_concept_id | 1300978 |
| min_value | 0 |
| max_value | 7156 |
| avg_value | 2006-04-13 00:00:00 |
| stddev_value | 1808 |
| percentile_25 | 2000-03-21 00:00:00 |
| median_value | 2002-07-29 00:00:00 |
| percentile_75 | 2005-01-15 00:00:00 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
