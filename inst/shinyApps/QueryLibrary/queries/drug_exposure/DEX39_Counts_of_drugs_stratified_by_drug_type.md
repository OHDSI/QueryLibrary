<!---
Group:drug exposure
Name:DEX39 Counts of drugs, stratified by drug type
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX39: Counts of drugs, stratified by drug type

## Description
| This query is used to count drugs (drug_concept_id) across all drug exposure records stratified by drug exposure type (drug_type_concept_id, in CDM V2 drug_exposure_type). The input to the query is a value (or a comma-separated list of values) of a drug_concept_id or a drug_type_concept_id. If the input is omitted, all existing value combinations are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
| list of drug_concept_id | 906805, 1517070, 19010522 | Yes |
| list of drug_type_concept_id | 38000180 | Yes | 


## Query

The following is a sample run of the query. The input parameters are highlighted in  blue 

```sql
SELECT t.drug_concept_id, count(1) as drugs_count, t.drug_TYPE_concept_id 
FROM drug_exposure t 
where
    t.drug_concept_id in (906805, 1517070, 19010522) 
and t.drug_TYPE_concept_id in ( 38000175,38000179 ) 
group by t.drug_TYPE_concept_id, t.drug_concept_id ;
```

## Output


## Output field list

|  Field |  Description |
| --- | --- | 
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| drug_type_concept_id | A foreign key to the predefined concept identifier in the vocabulary reflecting the parameters used to construct the drug era. |
| count | A foreign key to the predefined concept identifier in the vocabulary reflecting the parameters used to construct the drug era. |


## Sample output record

|  Field |  Description |
| --- | --- | 
| drug_concept_id |   |
| drug_type_concept_id |   |
| count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
