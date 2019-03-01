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
WITH snomed_diabetes AS ( 
SELECT ca.descendant_concept_id AS snomed_diabetes_id 
  FROM @vocab.concept c 
  JOIN @vocab.concept_ancestor ca 
    ON ca.ancestor_concept_id = c.concept_id 
 WHERE c.concept_code = '73211009'
),  people_with_diabetes AS (
SELECT ce.person_id, 
       MIN(ce.condition_era_start_date) AS onset_date 
  FROM @cdm.condition_era ce
  JOIN snomed_diabetes sd
    ON sd.snomed_diabetes_id = ce.condition_concept_id 
 GROUP BY ce.person_id 
), non_diabetic AS (
SELECT person_id, 
       condition_concept_id, 
       condition_era_start_date 
  FROM @cdm.condition_era 
 WHERE condition_concept_id NOT IN (SELECT snomed_diabetes_id FROM snomed_diabetes) 
), comorbities_by_person AS (
SELECT diabetic.person_id, 
       COUNT(DISTINCT comorb.condition_concept_id) AS comorbidities         
  FROM people_with_diabetes diabetic 
  JOIN non_diabetic comorb 
	ON comorb.person_id = diabetic.person_id 
   AND comorb.condition_era_start_date > diabetic.onset_date 
  JOIN @vocab.concept c 
    ON c.concept_id = comorb.condition_concept_id 
 GROUP BY diabetic.person_id 
), percentiles as (  
SELECT DISTINCT 
       PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY comorbidities) OVER() AS percentile_25, 
       PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY comorbidities) OVER() AS median, 
       PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY comorbidities) OVER() AS percentile_75 
  FROM comorbities_by_person
)  
SELECT MIN(cbp.comorbidities) AS min_value, 
       MAX(cbp.comorbidities) AS max_value, 
       AVG(cbp.comorbidities) AS avg_value,
       p.percentile_25, 
       p.median, 
       p.percentile_75 
  FROM comorbities_by_person cbp
 CROSS JOIN percentiles p
 GROUP BY p.percentile_25,p.median,p.percentile_75;
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
