<!---
Group:drug exposure
Name:DEX21 How many people have a diagnosis of a contraindication for the drug they are taking?
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX21: How many people have a diagnosis of a contraindication for the drug they are taking?

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
|   |   |   |  |


## Query

The following is a sample run of the query. The input parameters are highlighted in  blue  ;


```sql
;WITH con_rel AS        
    (
    SELECT
        r1.concept_id_1,
        r2.concept_id_2
    FROM
        concept_relationship AS r1
        INNER JOIN concept_relationship r2
            ON    r2.concept_id_1    = r1.concept_id_2
    WHERE
        r1.relationship_id    = 'Has CI'
    AND    r2.relationship_id    = 'Ind/CI - SNOMED'
    )
SELECT    count(distinct d.person_id)
FROM
    con_rel AS cr
        INNER JOIN    drug_exposure AS d
            ON    cr.concept_id_1 = d.drug_concept_id
        INNER JOIN    condition_occurrence AS c
            ON    cr.concept_id_2    = c.condition_concept_id
            AND    d.person_id        = c.person_id
where
    d.drug_exposure_start_date >= c.condition_start_date 
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
