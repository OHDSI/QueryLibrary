<!---
Group:drug exposure
Name:DEX04 Distribution of gender in persons taking a drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX04: Distribution of gender in persons taking a drug

## Description
| This query is used to obtain the gender distribution of persons exposed to a certain drug (drug_concept_id). The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values. If the input is omitted, all drugs in the data table are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of drug_concept_id | 40165254, 40165258 | No | Crestor 20 and 40 mg tablets |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.

```sql
SELECT drug.concept_name as drug_name,
        drug_concept_id,    
        gender.concept_name as gender,
        count(1) as num_persons
FROM
@cdm.drug_exposure JOIN @cdm.person USING( person_id )
JOIN @vocab.concept drug ON drug.concept_id = drug_concept_id
JOIN @vocab.concept gender ON gender.concept_id = gender_concept_id
WHERE drug_concept_id IN ( 40165254, 40165258 )
GROUP by drug.concept_name, drug_concept_id, gender.concept_name
ORDER BY drug_name, drug_concept_id, gender;
```

## Output


## Output field list

|  Field |  Description |
| --- | --- |
| drug_name | An unambiguous, meaningful and descriptive name for the drug concept. |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| gender | The gender of the counted persons exposed to drug. |
| num_persons | The number of persons of a particular gender exposed to drug. |


## Sample output record

|  Field |  Content |
| --- | --- |
| drug_name | Rosuvastatin calcium 20 MG Oral Tablet [Crestor] |
| drug_concept_id | 40165254 |
| gender | FEMALE |
| num_persons | 12590 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
