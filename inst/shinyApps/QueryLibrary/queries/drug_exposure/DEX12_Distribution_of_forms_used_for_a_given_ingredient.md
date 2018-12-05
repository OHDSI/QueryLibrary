<!---
Group:drug exposure
Name:DEX12 Distribution of forms used for a given ingredient
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX12: Distribution of forms used for a given ingredient

## Description
| This query determines the percent distribution of forms of drug products containing a given ingredient. See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|  ingredient.concept_id |  1125315 |  Yes |  Acetaminophen |

## Query
The following is a sample run of the query. The input parameter is highlighted in  blue. 

```sql
SELECT tt.form_name,
(100.00 * tt.part_form / tt.total_forms) as percent_forms
FROM (
SELECT 
t.form_name,
t.cn part_form,
SUM(t.cn) OVER() total_forms
FROM (
select 
count(1) as cn,
drugform.concept_name form_name
FROM concept ingredient,
concept_ancestor a,
concept drug,
concept_relationship r,
concept drugform
WHERE ingredient.concept_id = 1125315 --Acetaminophen
AND ingredient.concept_class_id = 'Ingredient'
AND ingredient.concept_id = a.ancestor_concept_id
AND a.descendant_concept_id = drug.concept_id
--AND drug.concept_level = 1 --ensure it is drug product
ANd drug.standard_concept='S'
AND drug.concept_id = r.concept_id_1
AND r.concept_id_2 = drugform.concept_id
AND drugform.concept_class_id = 'Dose Form'
GROUP BY drugform.concept_name
) t 
WHERE t.cn>0 --don't count forms that exist but are not used in the data
) tt
WHERE tt.total_forms > 0 --avoid division by 0
ORDER BY percent_forms desc;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| form_name | The concept name of the dose form |
| percent_forms | The percent of forms drug products have containing the ingredient |


## Sample output record

|  Field |  Description |
| --- | --- | 
| form_name |  Oral Tablet |
| percent_forms |  95.69 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
