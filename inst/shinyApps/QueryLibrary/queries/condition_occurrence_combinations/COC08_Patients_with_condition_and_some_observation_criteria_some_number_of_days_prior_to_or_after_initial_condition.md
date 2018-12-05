<!---
Group:condition occurrence combinations
Name:COC08 Patients with condition and some observation criteria some number of days prior to or after initial condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC08: Patients with condition and some observation criteria some number of days prior to or after initial condition

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_name | OMOP Aplastic Anemia 1 | Yes |   |
| list of observation_concept_id | 3000905, 3003282, 3010813 |   | Leukocytes #/volume in blood |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT DISTINCT 
  condition.person_id , 
  observation_date, 
  condition_era_start_date 
FROM 
  @cdm.condition_era condition 
JOIN -- definition of Aplastic Anemia 
( 
  SELECT DISTINCT descendant_concept_id 
  FROM @vocab.relationship 
  JOIN @vocab.concept_relationship rel USING( relationship_id ) 
  JOIN @vocab.concept concept1 ON concept1.concept_id = concept_id_1 
  JOIN @vocab.concept_ancestor ON ancestor_concept_id = concept_id_2 
  WHERE 
    relationship_name = 'HOI contains SNOMED (OMOP)' AND 
    concept1.concept_name = 'OMOP Aplastic Anemia 1' AND 
    sysdate BETWEEN rel.valid_start_date and rel.valid_end_date 
) ON descendant_concept_id = condition_concept_id 
JOIN @cdm.observation observation
  ON observation.person_id = condition.person_id AND 
     observation_date BETWEEN condition_era_start_date - 7 AND condition_era_start_date + 7 
WHERE 
  observation_concept_id IN /* leukocytes #/volume in blood */ ( 3000905, 3003282, 3010813 ) AND 
  unit_concept_id = 8961 /* Thousand per cubic millimeter */ AND 
  value_as_number <= 3.5;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| person_id |   |
| observation_date |   |
| condition_era_start_date | The start date for the condition era constructed from the individual instances of condition occurrences. It is the start date of the very first chronologically recorded instance of the condition. |

## Sample output record

|  Field |  Description |
| --- | --- |
| person_id |   |
| observation_date |   |
| condition_era_start_date | The start date for the condition era constructed from the individual instances of condition occurrences. It is the start date of the very first chronologically recorded instance of the condition. |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
