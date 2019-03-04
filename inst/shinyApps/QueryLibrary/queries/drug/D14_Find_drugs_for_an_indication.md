<!---
Group:drug
Name:D14 Find drugs for an indication
Author:Patrick Ryan
CDM Version: 5.0
-->

# D14: Find drugs for an indication

## Description
This query provides all clinical or branded drugs that are indicated for a certain indication. Indications have to be given as FDB indications (vocabulary_id=19) or NDF-RT indications (vocabulary_id=7). Indications can be identified using the generic query  [G03](http://vocabqueries.omop.org/general-queries/g3), or, if at least one drug is known for this indication, query  [D04](http://vocabqueries.omop.org/drug-queries/d4).

## Query
```sql
SELECT
        drug.concept_id      as drug_concept_id,
        drug.concept_name    as drug_concept_name,
        drug.concept_code    as drug_concept_code
 FROM   @vocab.concept drug,
        @vocab.concept_ancestor a
 WHERE  a.ancestor_concept_id   = 21000039
 AND    a.descendant_concept_id = drug.concept_id
 AND         drug.standard_concept = 'S'
 AND    drug.domain_id = 'Drug'
 AND    drug.vocabulary_id = 'RxNorm'
 AND    (getdate() >= drug.valid_start_date) AND (getdate() <= drug.valid_end_date)
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Indication Concept ID |  21000039 |  Yes | FDB indication concept ID |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

| Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept ID of the drug |
|  Drug_Concept_Name |  Name of the drug |
|  Drug_Concept_Code |  Concept code of the drug |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  1710446 |
|  Drug_Concept_Name |  Cycloserine |
|  Drug_Concept_Code |  3007 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
