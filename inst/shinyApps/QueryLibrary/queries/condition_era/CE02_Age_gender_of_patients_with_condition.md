<!---
Group:condition era
Name:CE02 Age/gender of patients with condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE02: Age/gender of patients with condition

## Description
List of patient counts of specific age and gender for specific medical condition

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- | 
| concept_name | OMOP Hip Fraction 1 |  Yes |  Concept ID=500000601 |


## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT gender, age, count(*) num_patients 
FROM -- patient with hip fracture, age, gender 
( 
SELECT DISTINCT condition.person_id , gender.concept_name As GENDER , YEAR(CONDITION_ERA_START_DATE ) - year_of_birth AS age 
FROM @cdm.condition_era condition 
JOIN -- definition of Hip Fracture 
( 
SELECT DISTINCT descendant_concept_id 
FROM @vocab.relationship 
JOIN concept_relationship rel 
USING( relationship_id ) 
JOIN @vocab.concept concept1 ON concept1.concept_id = concept_id_1 
JOIN @vocab.concept_ancestor ON ancestor_concept_id = concept_id_2 
WHERE relationship_name = 'HOI contains SNOMED (OMOP)' AND concept1.concept_name = 'OMOP Hip Fracture 1' AND sysdate BETWEEN rel.valid_start_date 
AND rel.valid_end_date ) ON descendant_concept_id = condition_concept_id 
JOIN @vocab.concept gender ON gender.concept_id = gender_concept_id ) 
JOIN @cdm.person person ON person.person_id = condition.person_id 
GROUP BY gender, age 
ORDER BY gender, age;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| gender | Patients gender, i.e. MALE, FEMALE |
| age | The year of birth of the person. For data sources with date of birth, the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available. |
| num_patients | Number of patients for specific gender and age and selected condition |

## Sample output record

|  Field |  Description |
| --- | --- |
| gender |  FEMALE |
| age |  16 |
| num_patients |  22 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
