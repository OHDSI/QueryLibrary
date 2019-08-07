<!---
Group:drug exposure
Name:DEX18 What is the distribution of DRUG_TYPE_CONCEPT_ID (modes of distribution) for a given drug?
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX18: What is the distribution of DRUG_TYPE_CONCEPT_ID (modes of distribution) for a given drug?

## Description

## Query
The following is a sample run of the query. The input parameters are highlighted in blue.

```sql
SELECT c.concept_name, COUNT(*) AS drug_type_count
  FROM @cdm.drug_exposure de
  JOIN @vocab.concept c
    ON c.concept_id = de.drug_type_concept_id
 GROUP BY c.concept_name
 ORDER BY drug_type_count DESC;
```

## Input

 None

## Output

|  Field |  Description |
| --- | --- |
| drug_type_concept_id | A foreign key to the predefined concept identifier in the vocabulary reflecting the type of drug exposure recorded. It indicates how the drug exposure was represented in the source data: as medication history, filled prescriptions, etc. |
| drug_type_count |   |


## Example output record

|  Field |  Description |
| --- | --- |
| drug_type_concept_id |   |
| drug_type_count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
