<!---
Group:drug exposure
Name:DEX40 Counts of drugs, stratified by relevant condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX40: Counts of drugs, stratified by relevant condition

## Description
| This query is used to count all drugs (drug_concept_id) across all drug exposure records stratified by condition (relevant_condition_concept_id). The input to the query is a value (or a comma-separated list of values) of a drug_concept_id and a relevant_condition_concept_id. If the input is omitted, all existing value combinations are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of drug_concept_id | 906805, 1517070, 19010522 | Yes |  
| list of relevant_condition_concept_id | 26052, 258375 | Yes |   

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT
  t.drug_concept_id,
  count(1) as drugs_count,
  p.procedure_concept_id as relevant_condition_concept_id
FROM @cdm.drug_exposure t
    inner join @cdm.procedure_occurrence as p
        on    t.visit_occurrence_id = p.visit_occurrence_id
        and    t.person_id = p.person_id
where
  t.drug_concept_id in (906805, 1517070, 19010522)
  and p.procedure_concept_id in (26052, 258375)
group by  p.procedure_concept_id, t.drug_concept_id
;
  t.drug_concept_id in (906805, 1517070, 19010522)
  and t.relevant_condition_concept_id in (26052, 258375)
group by  t.relevant_condition_concept_id, t.drug_concept_id
;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| relevant_condition_concept_id | A foreign key to the predefined concept identifier in the vocabulary reflecting the condition that was the cause for initiation of the procedure. Note that this is not a direct reference to a specific condition record in the condition table, but rather a condition concept in the vocabulary |
| Count | The number of individual drug exposure occurrences used to construct the drug era. |


## Sample output record

|  Field |  Description |
| --- | --- |
| drug_concept_id |   
| relevant_condition_concept_id |   
| Count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
