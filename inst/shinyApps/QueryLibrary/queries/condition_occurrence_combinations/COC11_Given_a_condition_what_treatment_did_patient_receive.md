<!---
Group:condition occurrence combinations
Name:COC11 Given a condition, what treatment did patient receive
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC11: Given a condition, what treatment did patient receive

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_code | '22851', '20936', '22612', '22523', '22630', '22614', '22842' , '22632', '20930', '22524', '27130', '22525' | Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT treatment, count(*) 
FROM
(
SELECT CASE WHEN surgery = 1
            THEN 'surgery'
            WHEN drug = 1 AND pt = 1 
            THEN 'PT Rx'
            WHEN drug = 1
            THEN 'Rx Only'
            ELSE 'No Treatment'
       END AS treatment
FROM
(
SELECT person_id, diag_date
     , max( drug ) AS drug, max( surgery ) AS surgery, max( pt ) AS PT
  FROM /* back pain and treatments over following 60 days */
     ( 
     SELECT era.person_id, condition_era_start_date AS diag_date
          , ISNULL( drug, 0 ) AS drug, ISNULL( surgery, 0 ) AS surgery
          , ISNULL( pt, 0 ) AS pt
       FROM @cdm.condition_era era
       JOIN /* SNOMed codes for back pain */
            ( SELECT DISTINCT ca.descendant_concept_id
            FROM @vocab.concept_ancestor ca JOIN
            ( SELECT cr.concept_id_2 AS target_concept_id
                FROM concept_relationship cr
                JOIN concept c1 ON cr.concept_id_1 = c1.concept_id
                JOIN concept c2 ON cr.concept_id_2 = c2.concept_id
                JOIN vocabulary v1 ON c1.vocabulary_id = v1.vocabulary_id
                JOIN vocabulary v2 ON c2.vocabulary_id = v2.vocabulary_id
                WHERE cr.relationship_id = 'Maps to'
                AND c1.concept_code like '724%'
                AND c2.standard_concept = 'S'
                AND v1.vocabulary_id = 'ICD9CM'
                AND v2.vocabulary_id = 'SNOMED'
                AND getdate() BETWEEN cr.valid_start_date AND cr.valid_end_date
            ) t ON ca.ancestor_concept_id = t.target_concept_id            
          ) ON descendant_concept_id = condition_concept_id
      LEFT OUTER JOIN /* surgery */
         ( SELECT person_id, procedure_date, 1 AS surgery
             FROM @cdm.procedure_occurrence proc
             JOIN @vocab.concept ON concept_id = procedure_concept_id
            WHERE vocabulary_id = 'CPT4' /* CPT-4 */
              AND concept_code
               IN( '22851', '20936', '22612', '22523', '22630',
                   '22614', '22842', '22632', '20930', '22524',
                   '27130', '22525'
                 )
         ) surgery
        ON surgery.person_id = era.person_id
       AND surgery.procedure_date BETWEEN condition_era_start_date
                                      AND condition_era_start_date + 60
      LEFT OUTER JOIN /* drugs */
         ( SELECT person_id, procedure_date AS drug_date, 1 AS drug
             FROM @cdm.procedure_occurrence proc
             JOIN @vocab.concept ON concept_id = procedure_concept_id
            WHERE vocabulary_id = 'CPT4' /* CPT-4 */
              AND concept_code
               IN( '20610','20552','207096','20553','20550','20605'
                 ,'20551','20600','23350' )
          UNION 
          SELECT person_id, drug_era_start_date, 1
            FROM @cdm.drug_era
           WHERE drug_concept_id
              IN( 1125315, 778711, 1115008, 1177480, 1112807, 1506270 )
         ) drug 
        ON drug.person_id = era.person_id
       AND drug.drug_date BETWEEN condition_era_start_date
                              AND condition_era_start_date + 60
      LEFT OUTER JOIN /* pt */
         ( SELECT person_id, procedure_date AS pt_date, 1 AS pt
             FROM @cdm.procedure_occurrence proc
             JOIN @vocab.concept ON concept_id = procedure_concept_id
            WHERE vocabulary_id = 'CPT4' /* CPT-4 */
              AND concept_code
               IN( '97001', '97140', '97002' )
           UNION
           SELECT person_id, procedure_date AS pt_date, 1 AS pt
             FROM @cdm.procedure_occurrence proc
             JOIN @vocab.concept ON concept_id = procedure_concept_id
            WHERE vocabulary_id = 'HCPCS' /* HCPCS */
              AND concept_code = 'G0283'
         ) pt
        ON pt.person_id = era.person_id
       AND pt.pt_date BETWEEN condition_era_start_date
                          AND condition_era_start_date + 60
     )
 WHERE diag_date > '2011-01-01'
 GROUP by person_id, diag_date
 ORDER BY person_id, diag_date
)
)
GROUP BY treatment ORDER BY treatment;
```



 Output:

## Output field list

|  Field |  Description |
| --- | --- |
| treatment |   |
| count |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| treatment |   |
| count |   |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
