<!---
Group:drug
Name:D09 Find drugs by drug class
Author:Patrick Ryan
CDM Version: 5.0
-->

# D09: Find drugs by drug class

## Description
This query is designed to extract all drugs that belong to a therapeutic class. The query accepts a therapeutic class concept ID as the input and returns all drugs that are included under that class .
Therapeutic classes could be obtained using query  [D02](http://vocabqueries.omop.org/drug-queries/d2) and are derived from one of the following:

- Enhanced Therapeutic Classification (FDB ETC), VOCABULARY_ID = 20
- Anatomical Therapeutic Chemical classification (WHO ATC), VOCABULARY_ID = 21

– NDF-RT Mechanism of Action (MoA), Vocabulary ID = 7, Concept Class = 'Mechanism of Action'

– NDF-RT Physiologic effect (PE),        Vocabulary ID = 7, Concept Class = 'Physiologic Effect'

– NDF-RT Chemical Structure,              Vocabulary ID = 7, Concept Class = 'Chemical Structure'

- VA Class, Vocabulary ID = 32

## Query
```sql
SELECT  c.concept_id      drug_concept_id,
        c.concept_name   drug_concept_name,
        c.concept_class_id  drug_concept_class,
        c.concept_code   drug_concept_code
FROM    @vocab.concept          c,
         @vocab.concept_ancestor ca
WHERE   ca.ancestor_concept_id = 21506108
        AND  c.concept_id = ca.descendant_concept_id
        AND  c.vocabulary_id = 'RxNorm'
        AND  c.domain_id = 'Drug'
        AND  c.standard_concept = 'S'
        AND (getdate() >= c.valid_start_date)
        AND (getdate() <= c.valid_end_date);
```

## Input

| Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Therapeutic Class Concept ID |  21506108 |  Yes | Concept ID for 'ACE Inhibitors and ACE Inhibitor Combinations' |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

| Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept ID of drug included in therapeutic class |
|  Drug_Concept_Name |  Name of drug concept included in therapeutic class |
|  Drug_Concept_Class |  Concept class of drug concept included in therapeutic class |
|  Drug_Concept_Code |  RxNorm source code of drug concept |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  1308221 |
|  Drug_Concept_Name |  Lisinopril 40 MG Oral Tablet |
|  Drug_Concept_Class |  Clinical Drug |
|  Drug_Concept_Code |  197884 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
