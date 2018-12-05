<!---
Group:condition occurrence combinations
Name:COC01 Determines first line of therapy for a condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC01: Determines first line of therapy for a condition

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of condition_concept_id | 432791, 4080130, 4081073, 4083996, 4083997, 4083998, 4084171, 4084172, 4084173, 4084174, 4086741, 4086742, 4086744, 4120778, 4125819, 4140613, 4161207, 4224624, 4224625, 4270861, 4270862, 4270865, 4292365, 4292366, 4292524, 4299298, 4299302, 4301157, 4307793 | Yes | Angioedema 1 |
| ancestor_concept_id | 21003378 | Yes | Angioedema |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT 
  ingredient_name, 
  ingredient_concept_id, 
  count(*) num_patients 
FROM /*Drugs started by people up to 30 days after Angioedema diagnosis */ ( 
  SELECT 
    condition.person_id, 
    condition_start_date , 
    drug_era_start_date , 
    ingredient_name, 
    ingredient_concept_id 
  FROM /* people with Angioedema with 180 clean period and 180 day follow-up */ ( 
    SELECT 
      era.person_id, 
      condition_era_start_date AS condition_start_date 
    FROM @cdm.condition_era era 
    JOIN @vocab.observation_period obs 
      ON obs.person_id = era.person_id AND 
         condition_era_start_date BETWEEN observation_period_start_date + 180 AND observation_period_end_date - 180 
    WHERE 
      condition_concept_id IN -- SNOMed codes for OMOP Angioedema 1 
      ( 432791, 4080130, 4081073, 4083996, 4083997, 4083998, 4084171, 4084172, 4084173, 4084174, 4086741, 4086742, 
        4086744, 4120778, 4125819, 4140613, 4161207, 4224624, 4224625, 4270861, 4270862, 4270865, 4292365, 4292366, 
        4292524, 4299298, 4299302, 4301157, 4307793 ) 
  ) condition 
  JOIN @cdm.drug_era rx /* Drug_era has drugs at ingredient level */ 
    ON rx.person_id = condition.person_id AND 
       rx.drug_era_start_date BETWEEN condition_start_date AND condition_start_date + 30 
  JOIN /* Ingredients for indication Angioedema */ ( 
    SELECT 
      ingredient.concept_id AS ingredient_concept_id , 
      ingredient.concept_name AS ingredient_name 
    FROM @vocab.concept ingredient 
    JOIN @vocab.concept_ancestor a ON a.descendant_concept_id = ingredient.concept_id 
    WHERE 
      a.ancestor_concept_id = 21003378 /* indication for angioedema */ AND 
      ingredient.vocabulary_id = 8 AND 
      sysdate BETWEEN ingredient.valid_start_date AND ingredient.valid_end_date 
  ) ON ingredient_concept_id = drug_concept_id 
) 
GROUP by ingredient_name, ingredient_concept_id 
ORDER BY num_patients DESC;
```



 Output:

## Output field list

|  Field |  Description |
| --- | --- |
| ingredient_name |   |
| ingredient_concept_id |   |
| count |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| ingredient_name |   |
| ingredient_concept_id |   |
| count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
