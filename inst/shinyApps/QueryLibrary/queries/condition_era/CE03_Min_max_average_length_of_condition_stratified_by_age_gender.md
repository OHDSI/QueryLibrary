<!---
Group:condition era
Name:CE03 Min/max, average length of condition stratified by age/gender
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE03: Min/max, average length of condition stratified by age/gender

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_name | OMOP Hip Fracture 1 |  Yes |  concept_id=500000601 |

## Query
The following is a sample run of the query. The input parameters are highlighted in blue

```sql
SELECT 
  gender, 
  CASE 
    WHEN age_grp = 0 THEN '0-9' 
    WHEN age_grp = 1 THEN '10-19' 
    WHEN age_grp = 2 THEN '20-29' 
    WHEN age_grp = 3 THEN '30-39' 
    WHEN age_grp = 4 THEN '40-49' 
    WHEN age_grp = 5 THEN '50-59' 
    WHEN age_grp = 6 THEN '60-69' 
    WHEN age_grp = 7 THEN '70-79' 
    WHEN age_grp = 8 THEN '80-89' 
    WHEN age_grp = 9 THEN '90-99' 
    WHEN age_grp > 9 THEN '100+' 
  END age_grp, 
  count(*) AS num_patients, 
  min( duration ) AS min_duration_count, 
  max( duration ) AS max_duration_count, 
  avg( duration ) AS avg_duration_count 
FROM -- patient with hip fracture, age, gender 
( 
  SELECT DISTINCT 
    condition.person_id , 
    gender.concept_name As gender , 
    EXTRACT( YEAR FROM condition_era_start_date ) - year_of_birth AS age, 
    condition_era_end_date - condition_era_start_date + 1 AS duration, 
    (EXTRACT( YEAR FROM condition_era_start_date) - person.year_of_birth)/10 AS age_grp 
  FROM condition_era condition 
  JOIN -- definition of Hip Fracture 
  ( 
    SELECT DISTINCT descendant_concept_id 
    FROM relationship 
    JOIN concept_relationship rel USING( relationship_id ) 
    JOIN concept concept1 ON concept1.concept_id = concept_id_1 
    JOIN concept_ancestor ON ancestor_concept_id = concept_id_2 
    WHERE 
      relationship_name = 'HOI contains SNOMED (OMOP)' AND 
      concept1.concept_name = 'OMOP Hip Fracture 1' AND 
      SYSDATE BETWEEN rel.valid_start_date and rel.valid_end_date 
  ) ON descendant_concept_id = condition_concept_id 
  JOIN person ON person.person_id = condition.person_id 
  JOIN concept gender ON gender.concept_id = gender_concept_id 
) t1 
GROUP BY 
  gender, 
  age_grp, 
  age 
ORDER BY age_grp, gender
```


## Output

## Output field list

|  Field |  Description |
| --- | --- |
| gender | Patient gender name. i.e. MALE, FEMALE... |
| age_grp | Age group in increments of 10 years |
| num_patients | Number of patients withing gender and age group with associated condition |
| min_duration | Minimum duration of condition in days |
| max_duration | Maximum duration of condition in days |
| avg_duration | Average duration of condition in days |

## Sample output record

|  Field |  Description |
| --- | --- |
| gender |  FEMALE |
| age_grp |  10-19 |
| num_patients |  518 |
| min_duration |  1 |
| max_duration | 130  |
| avg_duration |  8 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
