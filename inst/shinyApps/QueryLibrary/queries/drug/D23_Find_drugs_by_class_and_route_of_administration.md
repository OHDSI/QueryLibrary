<!---
Group:drug
Name:D23  Find drugs by class and route of administration
Author:Patrick Ryan
CDM Version: 5.0
-->

# D23:  Find drugs by class and route of administration

## Description
This query is designed to return a list of drug concept IDs that belong to a drug class and require a certain route of administration. For example, it can be used to find all steroid drugs used intravaginally. The query ties together:

- Concept ancestor data to link drug concepts to therapeutic class
- RxNorm concept relationship 4 - 'Has dose form (RxNorm)
- Dose form to route of administration list

The results are combined to present a list of drugs from a specific therapeutic class with a specific route of administration. Permissible routes are:

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
SELECT        C.concept_id drug_concept_id,
                C.concept_name drug_concept_name,
                C.concept_code drug_concept_code
FROM        @vocab.concept C,
                @vocab.concept_ancestor CA,
                @vocab.concept_relationship CRF,
                @vocab.concept F,
                route
WHERE
        CA.ancestor_concept_id = 4318008
AND        C.concept_id = CA.descendant_concept_id
AND        C.vocabulary_id = 'RxNorm'
AND        C.standard_concept = 'S'
AND        CRF.concept_id_1 = C.concept_id
AND        CRF.relationship_ID = 'RxNorm has dose form'
AND        CRF.concept_id_2 = F.concept_id
AND        F.concept_id = route.concept_id
AND        (getdate() >= CRF.valid_start_date) AND (getdate() <= CRF.valid_end_date)
AND        CHARINDEX(LOWER(REPLACE(REPLACE(route.route_of_administration, ' ', ''), '-', '')), LOWER(REPLACE(REPLACE('vaginal' , ' ', ''), '-', ''))) > 0
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Therapeutic class Concept ID |  4318008 |  Yes | Concept ID for mechanism of action "Corticosteroid Hormone Receptor Agonists". Valid drug classes can be obtained using query  [D02](http://vocabqueries.omop.org/drug-queries/d2) |
|  Dose Form String |  'vaginal' |  Yes | Route of administration string. |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

|  Field |  Description |
| --- | --- |
|  Drug_Concept_ID |  Concept ID of drug with specified therapeutic class and dose form |
|  Drug_Name |  Name of drug with specified therapeutic class and dose form |
|  Drug_Concept_Code |  Source code of drug |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Drug_Concept_ID |  40230686 |
|  Drug_Name |  hydrocortisone acetate 10 MG/ML Vaginal Cream |
|  Drug_Concept_Code |  1039349 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
