<!---
Group:drug exposure
Name:DEX11 Distribution of brands used for a given generic drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX11: Distribution of brands used for a given generic drug

## Description
| This query provides the brands that are used for a generic drug. The input to the query is a value of a drug_concept_id. See [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values.  Note that depending on the mapping available for the source_values in the drug_exposure table, branded drug information might only partially or not be provided. See the Standard Vocabulary Specifications at  [http://omop.org/Vocabularies](http://omop.org/Vocabularies).

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
| drug_concept_id | 19019306 | Yes | Nicotine Patch | 

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue. S

```sql
SELECT    tt.drug_name,
        tt.brand_name,
        100.00*tt.part_brand/tt.total_brand as perc_brand_count
FROM
    (
    SELECT    t.drug_name,
            t.brand_name,
            t.cn_3_02 part_brand,
            SUM(t.cn_3_02) OVER() total_brand
            FROM
                (
                    SELECT    sum((select count(1) from drug_exposure d where d.drug_concept_id = cr003.concept_id_2)) cn_3_02,
                            A.Concept_Name drug_name,
                            D.Concept_Name brand_name
                    FROM
                        concept AS A
                        INNER JOIN    concept_relationship AS CR003
                            ON CR003.concept_id_1    = A.concept_id
                        INNER JOIN    concept_relationship AS CR007
                            ON    CR007.concept_id_2        = CR003.concept_id_2
                        INNER JOIN
                            concept_relationship AS CR006
                                ON    CR007.concept_id_1        = CR006.concept_id_1
                        INNER JOIN
                            concept D
                                ON    CR006.concept_id_2        = D.concept_id
                    WHERE
                        CR003.relationship_ID    = 'Has tradename'
                    AND    A.concept_class_id        = 'Clinical Drug'
                    AND    CR007.relationship_ID    = 'Constitutes'
                    AND    CR006.relationship_ID    = 'Has brand name'
                    AND    D.concept_class_id        = 'Brand Name'
                    AND    A.concept_id            = 35606533
                    GROUP BY    A.Concept_Name,
                                D.Concept_Name
                ) t 
    ) tt
WHERE tt.total_brand > 0 ;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| drug_name | The name of the query drug |
| brand_name | The name of the brand |
| perc_brand_count | The market share for each brand |

## Sample output record

|  Field |  Content |
| --- | --- | 
| drug_name |   |
| brand_name |   |
| perc_brand_count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
