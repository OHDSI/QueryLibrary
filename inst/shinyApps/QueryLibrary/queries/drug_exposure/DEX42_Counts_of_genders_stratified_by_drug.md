<!---
Group:drug exposure
Name:DEX42 Counts of genders, stratified by drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX42: Counts of genders, stratified by drug

## Description
| This query is used to count all gender values (gender_concept_id) for all exposed persons stratified by drug (drug_concept_id). The input to the query is a value (or a comma-separated list of values) of a gender_concept_id and drug_concept_id. If the input is omitted, all existing value combinations are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
| list of drug_concept_id | 906805, 1517070, 19010522 | Yes |   
| list of gender_concept_id | 8507, 8532 | Yes | Male, Female | 

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT p.gender_concept_id, count(1) as gender_count, t.drug_concept_id 
FROM drug_exposure t, person p 
where p.person_id = t.person_id
and t.drug_concept_id in (906805, 1517070, 19010522)  
and p.gender_concept_id in (8507, 8532)
group by t.drug_concept_id, p.gender_concept_id
order by t.drug_concept_id, p.gender_concept_id; 
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| gender_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the gender of the person. |
| Count | The number of individual drug exposure occurrences used to construct the drug era. |


## Sample output record

|  Field |  Description |
| --- | --- | 
| drug_concept_id |   |
| gender_concept_id |   |
| Count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
