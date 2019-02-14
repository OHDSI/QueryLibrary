<!---
Group:drug exposure
Name:DEX01 Counts of persons with any number of exposures to a certain drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX01: Counts of persons with any number of exposures to a certain drug

## Description
| This query is used to count the persons with at least one exposures to a certain drug (drug_concept_id).  See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. If the input is omitted, all drugs in the data table are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of drug_concept_id | 40165254, 40165258 | No | Crestor 20 and 40 mg tablets |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.  

```sql
SELECT c.concept_name, drug_concept_id, count(person_id) as num_persons 
FROM @cdm.drug_exposure join @vocab.concept c
ON drug_concept_id = c.concept_id
where
lower(domain_id)='drug' and vocabulary_id='RxNorm' and standard_concept='S'
and drug_concept_id in (40165254, 40165258 )
GROUP BY c.concept_name, drug_concept_id;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_name | An unambiguous, meaningful and descriptive name for the concept. |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept.  |
| num_persons | The patients count |

## Sample output record

|  Field |  Content |
| --- | --- |
| drug_name |  Rosuvastatin calcium 20 MG Oral Tablet [Crestor] |
| drug_concept_id |  40165254 |
| num_persons |  191244 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
