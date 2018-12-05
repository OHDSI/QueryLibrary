<!---
Group:drug exposure
Name:DEX20 How many people taking a drug for a given indicaton actually have that disease in their record prior to exposure?
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX20: How many people taking a drug for a given indicaton actually have that disease in their record prior to exposure?

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_name | Acute Tuberculosis | Yes |   


## Query

The following is a sample run of the query. The input parameters are highlighted in  blue


```sql
SELECT
    count(*) AS treated
    FROM /* person and tuberculosis treatment start date */
    (
        SELECT
            person_id,
            min( drug_exposure_start_date ) AS treatment_start
        FROM @vocab.drug_exposure
    JOIN /*indication and associated drug ids */
        ( SELECT
            indication.concept_name,
            drug.concept_id
            --, indication.domain_id, drug.concept_id
            FROM @vocab.concept indication
            JOIN @vocab.concept_ancestor ON ancestor_concept_id = indication.concept_id
            JOIN @vocab.vocabulary indication_vocab ON indication_vocab.vocabulary_id = indication.vocabulary_id
            JOIN @vocab.concept drug ON drug.concept_id = descendant_concept_id
            JOIN @vocab.vocabulary drug_vocab ON drug_vocab.vocabulary_id = drug.vocabulary_id
            WHERE
            indication_vocab.vocabulary_name = 'Indications and Contraindications (FDB)'
            AND indication.domain_id = 'Drug'
            AND indication.concept_name = 'Active Tuberculosis'
            AND drug_vocab.vocabulary_name = 'RxNorm (NLM)'
            AND drug.standard_concept = 'S'
            AND sysdate BETWEEN drug.valid_start_date AND drug.valid_end_date )
    ON concept_id = drug_concept_id GROUP BY person_id ) treated
LEFT OUTER JOIN /*patient with Acute Tuberculosis diagnosis */
    ( SELECT
            person_id, min( condition_start_date ) first_diagnosis, 1 AS diagnosed
            FROM @cdm.condition_occurrence
            JOIN @cdm.source_to_concept_map ON target_concept_id = condition_concept_id
            JOIN @vocab.vocabulary ON vocabulary_id = source_vocabulary_id 
            WHERE source_code like '011.%'
            AND    vocabulary_id ='ICD9CM'
            GROUP BY person_id
    ) diagnosed
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| count |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
