<!---
Group:drug
Name:D17 Find ingredients for an indication
Author:Patrick Ryan
CDM Version: 5.0
-->

# D17: Find ingredients for an indication

## Description
This query provides ingredients that are designated for a certain indication. Indications have to be given as FDB indications (vocabulary_id=19) or NDF-RT indications (vocabulary_id=7). Indications can be identified using the generic query  [G03](http://vocabqueries.omop.org/general-queries/g3), or, if at least one drug is known for this indication, query  [D04](http://vocabqueries.omop.org/drug-queries/d4).

## Query
```sql
SELECT
  ingredient.concept_id as ingredient_concept_id,
  ingredient.concept_name as ingredient_concept_name,
  ingredient.concept_code as ingredient_concept_code
FROM
  @vocab.concept ingredient,
  @vocab.concept_ancestor a
WHERE
  a.ancestor_concept_id = 4345991 AND
  a.descendant_concept_id = ingredient.concept_id AND
  ingredient.concept_level = 2 AND
  ingredient.vocabulary_id = 'RxNorm' AND
  (getdate() >= ingredient.valid_start_date) AND (getdate() <= ingredient.valid_end_date);
```

## Input

| Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  Indication Concept ID |  4345991 |  Yes | FDB indication concept for 'Vomiting' |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

| Field |  Description |
| --- | --- |
|  Ingredient_Concept_ID |  Concept ID of the ingredient |
|  Ingredient_Concept_Name |  Name of the ingredient |
|  Ingredient_Concept_Code |  Concept code of the ingredient |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Ingredient_Concept_ID |  733008 |
|  Ingredient_Concept_Name |  Perphenazine |
|  Ingredient_Concept_Code |  8076 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
