<!---
Group:condition occurrence combinations
Name:COC05 Mortality rate after initial diagnosis
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC05: Mortality rate after initial diagnosis

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_name | OMOP Acute Myocardial Infarction 1 | Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT 
  COUNT( DISTINCT diagnosed.person_id ) AS all_infarctions , 
  SUM( CASE WHEN death.person_id IS NULL THEN 0 ELSE 1 END ) AS death_from_infarction 
FROM -- Initial diagnosis of Acute Myocardial Infarction 
( 
  SELECT DISTINCT 
    person_id, 
    condition_era_start_date 
  FROM /* diagnosis of Acute Myocardial Infarction, ranked by date, 6 month clean period with 1 year follow-up */ 
  ( 
    SELECT 
      condition.person_id, 
      condition.condition_era_start_date , 
      sum(1) OVER(PARTITION BY condition.person_id ORDER BY condition_era_start_date ROWS UNBOUNDED PRECEDING) AS ranking 
    FROM 
      condition_era condition 
    JOIN --definition of Acute Myocardial Infarction 1 
    ( 
      SELECT DISTINCT descendant_concept_id 
      FROM relationship 
      JOIN concept_relationship rel USING( relationship_id ) 
      JOIN concept concept1 ON concept1.concept_id = concept_id_1 
      JOIN concept_ancestor ON ancestor_concept_id = concept_id_2 
      WHERE 
        relationship_name = 'HOI contains SNOMED (OMOP)' AND 
        concept1.concept_name = 'OMOP Acute Myocardial Infarction 1' AND 
        sysdate BETWEEN rel.valid_start_date and rel.valid_end_date 
    ) ON descendant_concept_id = condition_concept_id 
    JOIN observation_period obs 
      ON obs.person_id = condition.person_id AND 
         condition_era_start_date BETWEEN observation_period_start_date + 180 AND observation_period_end_date - 360 
  ) WHERE ranking = 1 
) diagnosed 
LEFT OUTER JOIN death /* death within a year */ 
  ON death.person_id = diagnosed.person_id AND 
  death.death_date <= condition_era_start_date + 360; 
```


## Output

## Output field list

|  Field |  Description |
| --- | --- |
| all_infarctions |   |
| death_from_infarction |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| all_infarctions |   |
| death_from_infarction |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
