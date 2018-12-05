<!---
Group:drug exposure
Name:DEX41 Distribution of drug exposure start date, stratified by drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX41: Distribution of drug exposure start date, stratified by drug

## Description
| This query is used to provide summary statistics for start dates (drug_exposure_start_date) across all drug exposure records stratified by drug (drug_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. If the input is omitted, the drug_exposure_start_date for all existing values of drug_concept_id are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| drug_concept_id | 906805, 1517070, 19010522 | Yes |   

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT
    tt.drug_concept_id ,
    min(tt.start_date) AS min_date ,
    max(tt.start_date) AS max_date ,
    avg(tt.start_date_num) + tt.min_date AS avg_date ,
    (round(stdDev(tt.start_date_num)) ) AS stdDev_days ,
    tt.min_date + (APPROXIMATE PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY tt.start_date_num ) ) AS percentile_25_date ,
    tt.min_date + (APPROXIMATE PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.start_date_num ) ) AS median_date ,
    tt.min_date + (APPROXIMATE PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.start_date_num ) ) AS percential_75_date
FROM (
        SELECT
            (t.drug_exposure_start_date - MIN(t.drug_exposure_start_date) OVER(partition by t.drug_concept_id)) AS start_date_num,
            t.drug_exposure_start_date AS start_date,
            MIN(t.drug_exposure_start_date) OVER(partition by t.drug_concept_id) min_date,
            t.drug_concept_id
        FROM
            @cdm.drug_exposure t 
        where t.drug_concept_id in (906805, 1517070, 19010522)
    ) tt
GROUP BY tt.min_date , tt.drug_concept_id order by tt.drug_concept_id ;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| min_value |   |
| max_value |   |
| avg_value |   |
| stdDev_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |


## Sample output record

|  Field |  Description |
| --- | --- |
| drug_concept_id |   |
| min_value |   |
| max_value |   |
| avg_value |   |
| stdDev_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
