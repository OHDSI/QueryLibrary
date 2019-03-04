<!---
Group:drug
Name:D21 Find route of administration of a drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# D21: Find route of administration of a drug

## Description
This query accepts concept IDs for a drug product (clinical or branded drug or pack) and identifies the route of administration of the dose form. The following routes of administration are defined:

- Inhaled
- Intrathecal
- Nasal
- Ophthalmic
- Oral
- Unknown (cannot be defined from the dose form)
- Otic
- Parenteral
- Rectal
- Topical
- Urethral
- Vaginal

## Query
```sql
SELECT      A.concept_id drug_concept_id,
                A.concept_name drug_concept_name,
                A.concept_code drug_concept_code,
                D.concept_name dose_form_concept_name,
                R.Route_of_Administration
FROM        @vocab.concept_relationship CR,
                @vocab.concept A,
                @vocab.concept D,
                route R
WHERE       CR.concept_id_1 = 40236916
AND         CR.relationship_ID = 'RxNorm has dose form'
AND         CR.concept_id_1 = A.concept_id
AND         CR.concept_id_2 = D.concept_id
AND         D.concept_id = R.concept_id
AND         (getdate() >= CR.valid_start_date) AND (getdate() <= CR.valid_end_date)
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Drug Concept ID  |  19060647 |  Yes | Must be a level 1 Clinical or Branded Drug or Pack |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

|  Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept ID of drug entered with specified dose form |
|  Drug_Name |  Name of drug with specified dose form |
|  Drug_Concept_Code |  Concept code of the dose form |
|  Dose_Form_Concept_name |  Name of the dose form |
|  Route_Of_Administration |  Derived route of administration for the drug |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  19060647 |
|  Drug_Name |  Budesonide 0.2 MG/ACTUAT Inhalant Powder |
|  Drug_Concept_Code |  247047 |
|  Dose_Form_Concept_name |  Inhalant Powder |
|  Route_Of_Administration |  Inhaled |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
