<!---
Group:condition era
Name:CE05 Conditions that are seasonally dependent
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE05: Conditions that are seasonally dependent

## Description
This query is used to count conditions (condition_concept_id) across all condition era records stratified by year, age group and gender (gender_concept_id). The age groups are calculated as 10 year age bands from the age of a person at the condition era start date. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id , year, age_group (10 year age band) and gender_concept_id. If the input is ommitted, all existing value combinations are summarized..

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id |   |   |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in blue

```sql
SELECT season, count(*) AS cases
FROM /* Extrinsic Asthma/season */
( SELECT CASE 
WHEN condition_era_start_date
BETWEEN convert( DATE, '20170101') AND convert( DATE, '20170321' )
THEN 'Winter'
WHEN condition_era_start_date
BETWEEN convert( DATE, '20170322') AND convert( DATE, '20170621' )
THEN 'Spring'
WHEN condition_era_start_date
BETWEEN convert( DATE, '20170622') AND convert( DATE, '20170921' )
THEN 'Summer'
WHEN condition_era_start_date
BETWEEN convert( DATE, '20170922') AND convert( DATE, '20171221' )
THEN 'Fall'
WHEN condition_era_start_date
BETWEEN convert( DATE, '20171222') AND convert( DATE, '20171231' )
THEN 'Winter'
END AS season
FROM @cdm.condition_era
JOIN /* Extrinsic Asthma ICD-9 493.* Get associated SNOMed codes
with their 12endents */
(
-- descendant standard concept id for asthma
SELECT DISTINCT ca.descendant_concept_id AS snomed_asthma
FROM @vocab.concept_ancestor ca 
JOIN
(SELECT c2.concept_id FROM @vocab.concept c1 
JOIN concept_relationship cr ON c1.concept_id = cr.concept_id_1 
AND cr.relationship_id = 'Maps to'
JOIN @vocab.concept c2 ON cr.concept_id_2 = c2.concept_id
WHERE c1.concept_code LIKE '493.0%') t -- standard concept id for asthma
ON ca.ancestor_concept_id = t.concept_id)
ON snomed_asthma = condition_concept_id
) GROUP BY season;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| season |   |
| cases |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| season |   |
| cases |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
