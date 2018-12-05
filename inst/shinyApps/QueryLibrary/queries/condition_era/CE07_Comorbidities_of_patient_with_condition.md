<!---
Group:condition era
Name:CE07 Comorbidities of patient with condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE07: Comorbidities of patient with condition

## Description
This query counts the top ten comorbidities for patients with diabetes

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_era_end_date |   |   |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
WITH SNOMed_diabetes AS ( 
  SELECT DISTINCT 
    descendant_concept_id AS snomed_diabetes_id 
  FROM @vocab.source_to_concept_map map 
  JOIN @vocab.concept_ancestor ON ancestor_concept_id = target_concept_id 
  WHERE 
    source_vocabulary_id = 2 /* icd9 */ AND 
    target_vocabulary_id = 1 /* SNOMed */ AND 
    source_code LIKE '250.%' AND 
    sysdate BETWEEN valid_start_date AND valid_end_date
) 
SELECT 
  comorbidity, 
  frequency 
FROM /* top 10 */ ( 
  SELECT 
    comorbidity, 
    count(*) frequency 
  FROM /* commorbidities for patients with diabetes */ ( 
    SELECT DISTINCT 
      diabetic.person_id, 
      concept_name AS comorbidity 
    FROM /* people with diabetes/onset date */ ( 
      SELECT 
        person_id, 
        MIN( condition_era_start_date ) AS onset_date 
      FROM @cdm.condition_era 
      JOIN SNOMed_diabetes ON snomed_diabetes_id = condition_concept_id 
      GROUP BY person_id 
    ) diabetic 
    JOIN /* condition after onset date, that are not diabetes */ ( 
      SELECT 
        person_id, 
        condition_concept_id, 
        condition_era_start_date 
      FROM @cdm.condition_era 
      WHERE 
        condition_concept_id NOT IN( SELECT snomed_diabetes_id FROM SNOMed_diabetes ) 
    ) comorb ON 
      comorb.person_id = diabetic.person_id AND 
      comorb.condition_era_start_date > diabetic.onset_date 
    JOIN @vocab.concept ON concept_id = comorb.condition_concept_id 
  ) 
  GROUP BY comorbidity 
  ORDER BY frequency DESC 
) 
limit 10;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| comorbidity |   |
| frequency |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| comorbidity |   |
| frequency |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
