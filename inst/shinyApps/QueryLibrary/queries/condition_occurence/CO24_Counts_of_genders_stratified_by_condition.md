<!---
Group:condition occurrence
Name:CO24 Counts of genders, stratified by condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO24: Counts of genders, stratified by condition

## Description
This query is used to count all genders (gender_concept_id), stratified by condition (condition_concept_id). All existing value combinations are summarized. Since some of the conditions have values only for one of the genders, in order not to present the concept id and name twice, a CASE clause is used.

## Query
```sql
SELECT  ( CASE WHEN (male_id<> null)
            THEN (male_id)
            ELSE (female_id) END) as concept_id,
        ( CASE WHEN (male_concept_name<> null)
                        THEN (male_concept_name)
                        ELSE (female_concept_name) END) AS name
                        , count_male,
                        count_female FROM (
SELECT    male_list.condition_concept_id male_id,
          male_list.concept_name male_concept_name,
                       male_list.count_male count_male ,
                       female_list.condition_concept_id female_id,
                       female_list.concept_name female_concept_name,
                       female_list.count_female count_female FROM (
SELECT    condition_concept_id,
          concept_name,
          count(*) AS count_male
FROM      condition_occurrence, concept
WHERE     condition_occurrence.condition_concept_id=concept.concept_id
          AND person_id IN (SELECT person_id
                           FROM   person
                           WHERE  gender_concept_id=8507)
GROUP BY  condition_concept_id, concept_name) male_list
FULL JOIN (
SELECT    condition_concept_id,
          concept_name,
          count(*) AS count_female
FROM      condition_occurrence, concept
WHERE     condition_occurrence.condition_concept_id=concept.concept_id and
          person_id in
          (SELECT person_id
FROM      person
WHERE     gender_concept_id =8532)
GROUP BY  condition_concept_id, concept_name) as female_list
          on male_list.condition_concept_id=female_list.condition_concept_id)
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| concept_id | Condition concept identifier |
| name | Concept name |
| count_male | Number of concepts for male patients |
| count_female | Number of concepts for female patients |

## Sample output record

|  Field |  Description |
| --- | --- |
| concept_id |  26711 |
| name |  Chronic pharyngitis |
| count_male |  6234 |
|  count_female |  11598 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
