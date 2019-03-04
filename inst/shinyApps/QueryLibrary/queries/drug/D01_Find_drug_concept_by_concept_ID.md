<!---
Group:drug
Name:D01 Find drug concept by concept ID
Author:Patrick Ryan
CDM Version: 5.0
-->

# D01: Find drug concept by concept ID

## Description
This is the lookup for obtaining drug concept details associated with a concept identifier. This query is intended as a tool for quick reference for the name, class, level and source vocabulary details associated with a concept identifier.
This query is equivalent to  [G01](http://vocabqueries.omop.org/general-queries/g1), but if the concept is not in the drug domain the query still returns the concept details with the Is_Drug_Concept_Flag field set to 'No'.

## Query
```sql
SELECT
        C.concept_id Drug_concept_id,
        C.concept_name Drug_concept_name,
        C.concept_code Drug_concept_code,
        C.concept_class_id Drug_concept_class,
        C.standard_concept Drug_concept_level,
        C.vocabulary_id Drug_concept_vocab_id,
        V.vocabulary_name Drug_concept_vocab_code,
        /*( CASE C.vocabulary_id
                WHEN 'RxNorm' THEN
                        CASE lower(C.concept_class_id)
                        WHEN 'clinical drug' THEN 'Yes'
                        WHEN 'branded drug' THEN 'Yes'
                        WHEN 'ingredient' THEN 'Yes'
                        WHEN 'branded pack' THEN 'Yes'
                        WHEN 'clinical pack' THEN 'Yes'
                        ELSE 'No' END
                ELSE 'No' END) Is_Drug_Concept_flag */
        (CASE C.domain_id WHEN 'Drug' THEN 'Yes' ELSE 'No' END) Is_Drug_Concept_flag
FROM
        @vocab.concept C,
        @vocab.vocabulary V
WHERE
        C.vocabulary_id = V.vocabulary_id
        AND getdate() >= C.valid_start_date
        AND getdate() <= C.valid_end_date
        AND C.concept_id = 1545999;
```



## Input

| Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Concept ID |  1545999 |  Yes | Concept Identifier from RxNorm for 'atorvastatin 20 MG Oral Tablet [Lipitor]' |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

| Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept Identifier entered as input |
|  Drug_Concept_Name |  Name of the standard drug concept |
|  Drug_Concept_Code |  Concept code of the standard drug concept in the source vocabulary |
|  Drug_Concept_Class |  Concept class of standard drug concept |
|  Drug_Concept_Level |  Level of the concept if defined as part of a hierarchy |
|  Drug_Concept_Vocab_ID |  Vocabulary the standard drug concept is derived from as vocabulary ID |
|  Drug_Concept_Vocab_Name |  Name of the vocabulary the standard drug concept is derived from |
|  Is_Drug_Concept_Flag |  Flag indicating whether the Concept ID belongs to a drug concept
'Yes' if drug concept, 'No' if not a drug concept |

## Sample output record

| Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  1545999 |
|  Drug_Concept_Name |  atorvastatin 20 MG Oral Tablet [Lipitor] |
|  Drug_Concept_Code |  617318 |
|  Drug_Concept_Class |  Branded Drug |
|  Drug_Concept_Level |  1 |
|  Drug_Concept_Vocab_ID |  8 |
|  Drug_Concept_Vocab_Name |  RxNorm |
|  Is_Drug_Concept_Flag |  No |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
