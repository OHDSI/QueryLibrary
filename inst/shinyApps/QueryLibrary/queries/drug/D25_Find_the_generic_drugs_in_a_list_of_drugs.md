<!---
Group:drug
Name:D25 Find the generic drugs in a list of drugs
Author:Patrick Ryan
CDM Version: 5.0
-->

# D25: Find the generic drugs in a list of drugs

## Description
This query is designed to identify generic drug concepts among from a list of standard drug concept IDs. The query identifies branded drugs from the CONCEPT table based on a concept class setting of 'Clinical Drug'

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
        AND (getdate()  >= C.valid_start_date) AND (getdate() <= C.valid_end_date)
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Drug Concept ID list |  1396833, 19060643 |  Yes | List of drug concept id's |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

|  Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept ID of generic drug or pack |
|  Drug_Name |  Name of generic drug or pack |
|  Drug_Concept_Code |  Concept code of generic drug or pack |
|  Drug_Concept_Class |  Concept class of generic drug or pack |
|  Drug_Vocabulary_ID |  Vocabulary the generic drug concept has been derived from, expressed as vocabulary ID |
|  Drug_Vocabulary_Name |  Name of the Vocabulary the generic drug concept has been derived from |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  19060643 |
|  Drug_Name |  Budesonide 0.05 MG/ACTUAT Nasal Spray |
|  Drug_Concept_Code |  247042 |
|  Drug_Concept_Class |  Clinical Drug |
|  Drug_Vocabulary_ID |  8 |
|  Drug_Vocabulary_Name |  RxNorm |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
