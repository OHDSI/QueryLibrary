<!---
Group:drug exposure
Name:DEX13 Distribution of provider specialities prescribing a given drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX13: Distribution of provider specialities prescribing a given drug

## Description
| This query provides the provider specialties prescribing a given drug, and the frequencies for each provider prescribing the drug (drug exposure records). Note that many databases do not record the prescribing provider for drugs. See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| drug_concept_id | 2213473 | Yes | Influenza virus vaccine |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.

```sql
SELECT  concept_name AS specialty, 
  count(*) AS prescriptions_count
  FROM 
  /*first prescribing provider for statin*/
  ( SELECT person_id, provider_id
  FROM drug_exposure
  WHERE NVL( drug_exposure.provider_id, 0 ) > 0
  AND drug_concept_id = 2213473  /* Influenza virus vaccine */
  ) drug
  JOIN provider ON provider.provider_id = drug.provider_id 
  JOIN concept ON concept_id = provider.specialty_concept_id
  WHERE concept.vocabulary_id='Specialty'
  AND concept.standard_concept='S'
  GROUP BY concept_name
  ORDER BY prescriptions_count desc;
```

## Output


## Output field list

|  Field |  Description |
| --- | --- | 
| specialty | The concept name of the specialty concept |
| prescriptions_count | The count of drug exposure records providers from the specialties are listed as prescribing provider. |


## Sample output record

|  Field |  Value |
| --- | --- |
| specialty |  Family Practice |
| prescriptions_count |  214825 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
