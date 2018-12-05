<!---
Group:drug exposure
Name:DEX43 Counts of drug exposure records per person, stratified by drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX43: Counts of drug exposure records per person, stratified by drug

## Description
| This query is used to count the number of drug exposure records for all exposed persons stratified by drug (drug_concept_id). The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. If the input is omitted, all existing values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
| list of drug_concept_id | 906805, 1517070, 19010522 | Yes |  

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue 

```sql
SELECT t.drug_concept_id, t.person_id, count(1) as drug_exposure_count 
FROM drug_exposure t 
where t.drug_concept_id in (906805, 1517070, 19010522) 
group by t.person_id, t.drug_concept_id 
order by t.drug_concept_id, t.person_id;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| person_id | A system-generated unique identifier for each person. |
| count |   |


## Sample output record

|  Field |  Description |
| --- | --- | 
| drug_concept_id |   |
| person_id |   |
| count |   |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
