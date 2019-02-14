<!---
Group:drug exposure
Name:DEX28 Counts of drug types
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX28: Counts of drug types

## Description
| This query is used to count the drug type concepts (drug_type_concept_id, in CDM V2 drug_exposure_type) across all drug exposure records. The input to the query is a value (or a comma-separated list of values) of a drug_type_concept_id. If the input is omitted, all possible values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of drug_type_concept_id | 38000175, 38000180 | Yes |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT count(1) as exposure_occurrence_count , drug_type_concept_id FROM @cdm.drug_exposure 
WHERE
drug_concept_id in (select distinct drug_concept_id from drug_era)
AND drug_type_concept_id in (38000175, 38000180)
GROUP BY drug_type_concept_id ;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_type_concept_id | A foreign key to the predefined concept identifier in the vocabulary reflecting the type of drug exposure recorded. It indicates how the drug exposure was represented in the source data: as medication history, filled prescriptions, etc. |
| exposure_occurrence_count | The number of individual drug exposure occurrences used to construct the drug era. |


## Sample output record

|  Field |  Description |
| --- | --- |
| drug_type_concept_id |   |
| exposure_occurrence_count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
