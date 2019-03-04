<!---
Group:drug
Name:D24 Find the branded drugs in a list of drugs
Author:Patrick Ryan
CDM Version: 5.0
-->

# D24: Find the branded drugs in a list of drugs

## Description
This query is designed to identify branded drug concepts from a list of standard drug concept IDs. The query identifies branded drugs from the Concept table based on a concept class setting of 'Branded Drug'

## Query
```sql
SELECT C.concept_id drug_concept_id,
        C.concept_name drug_name,
        C.concept_code drug_concept_code,
        C.concept_class_id drug_concept_class,
        C.vocabulary_id drug_vocabulary_id,
        V.vocabulary_name drug_vocabulary_name
FROM @vocab.concept C,
        @vocab.vocabulary V
        WHERE C.vocabulary_id = 'RxNorm'
                AND C.concept_id IN (1396833, 19060643)
                AND C.concept_class_id = 'Clinical Drug'
                AND C.vocabulary_id = V.vocabulary_id
                AND (getdate() >= C.valid_start_date) AND (getdate() <= C.valid_end_date)
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Drug Concept ID list |  1516830, 19046168 |  Yes | List of drug concept id's |
|  As of date |  '01-Jan-2010' |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

|  Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept ID of branded drug or pack |
|  Drug_Name |  Name of branded drug or pack |
|  Drug_Concept_Code |  Concept code of branded drug or pack |
|  Drug_Concept_Class |  Concept class of branded drug or pack |
|  Drug_Vocabulary_ID |  Vocabulary the branded drug concept has been derived from, expressed as vocabulary ID |
|  Drug_Vocabulary_Name |  Name of the Vocabulary the branded drug concept has been derived from |

## Sample output record

| Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  19046168 |
|  Drug_Name |  Triamcinolone 0.055 MG/ACTUAT Nasal Spray [Nasacort AQ] |
|  Drug_Concept_Code |  211501 |
|  Drug_Concept_Class |  Branded Drug |
|  Drug_Vocabulary_ID |  8 |
|  Drug_Vocabulary_Name |  RxNorm |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
