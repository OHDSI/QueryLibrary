<!---
Group:condition era
Name:CE08 Number of comorbidity for patients with condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE08: Number of comorbidity for patients with condition

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_era_end_date |   |   |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in blue

```sql
WITH SNOMed_diabetes AS ( 
  SELECT DISTINCT descendant_concept_id AS snomed_diabetes_id 
  FROM @vocab.source_to_concept_map map 
  JOIN @vocab.concept_ancestor  ON ancestor_concept_id = target_concept_id 
  WHERE 
    source_vocabulary_id = 2 /* icd9 */ AND 
    target_vocabulary_id = 1 /* SNOMed */ AND 
    source_code LIKE '250.%' AND 
    sysdate BETWEEN valid_start_date AND valid_end_date
),
tt as ( 
  SELECT 
    diabetic.person_id, 
    count( distinct condition_concept_id ) AS comorbidities 
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
    WHERE condition_concept_id NOT IN( SELECT snomed_diabetes_id FROM SNOMed_diabetes ) 
  ) comorb ON 
    comorb.person_id = diabetic.person_id AND 
    comorb.condition_era_start_date > diabetic.onset_date 
  JOIN @vocab.concept ON concept_id = comorb.condition_concept_id 
  GROUP BY diabetic.person_id 
)
SELECT 
  MIN( comorbidities ) AS min , 
  max( comorbidities ) AS max, 
  avg( comorbidities ) AS average , 
  (select distinct PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY comorbidities) over() from tt) AS percentile_25 , 
  (select distinct PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY comorbidities) over() from tt) AS median , 
  (select distinct PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY comorbidities) over() from tt) AS percentile_75 
FROM tt;
```


## Output

## Output field list

|  Field |  Description |
| --- | --- |
| min |   |
| max |   |
| average |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| min |   |
| max |   |
| average |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
