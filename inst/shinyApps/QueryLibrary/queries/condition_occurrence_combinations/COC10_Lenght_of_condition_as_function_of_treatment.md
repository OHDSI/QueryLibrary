<!---
Group:condition occurrence combinations
Name:COC10 Lenght of condition as function of treatment
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC10: Lenght of condition as function of treatment

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_code | '22851','20936','22612','22523','22630','22614','22842' , '22632', '20930','22524','27130','22525' | Yes |   |
| concept_code | 20610','20552','207096','20553','20550','20605' | Yes |   |
| drug_concept_id | 1125315, 778711, 115008, 1177480, 1112807, 1506270 | Yes |   |
| concept_code | '97001', '97140', '97002' | Yes |   |
| concept_code | G0283 | Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT 
  treatment, 
  count(*), 
  min( condition_days ) AS min , 
  max( condition_days ) AS max, 
  avg( condition_days ) As avg_condition_days 
FROM ( 
  SELECT 
    CASE WHEN surgery = 1 THEN 'surgery' 
         WHEN drug = 1 AND pt = 1 THEN 'PT Rx' 
         WHEN drug = 1 THEN 'Rx Only' 
         ELSE 'No Treatment' 
    END AS treatment , 
    condition_days 
  FROM ( 
    SELECT 
      person_id, 
      diag_date ,
      max( drug ) AS drug, 
      max( surgery ) AS surgery, 
      max( pt ) AS PT , 
      max( condition_days ) AS condition_days 
    FROM /* back pain and treatments over following 60 days */ ( 
      SELECT 
        era.person_id, 
        condition_era_start_date AS diag_date , 
        condition_era_end_date - condition_era_start_date AS condition_days, 
        NVL( drug, 0 ) AS drug, 
        NVL( surgery, 0 ) AS surgery , 
        NVL( pt, 0 ) AS pt 
      FROM @cdm.condition_era era 
      JOIN /* SNOMed codes for back pain */ ( 
        SELECT DISTINCT 
          descendant_concept_id -- concept_name 
        FROM @vocab.source_to_concept_map map 
        JOIN @vocab.concept_ancestor concept_ancestor ON ancestor_concept_id = target_concept_id 
        JOIN @vocab.concept ON concept_id = descendant_concept_id 
        WHERE 
          source_code like '724%' AND 
          source_vocabulary_id = 'ICD9CM' AND 
          target_vocabulary_id = 'SNOMED' AND 
          getdate() BETWEEN map.valid_start_date AND map.valid_end_date 
      ) ON descendant_concept_id = condition_concept_id 
      LEFT OUTER JOIN ( 
        SELECT 
          person_id, 
          procedure_date, 
          1 AS surgery 
        FROM @cdm.procedure_occurrence proc 
        JOIN @vocab.concept ON concept_id = procedure_concept_id 
        WHERE 
          vocabulary_id = 'CPT4' AND 
          concept_code IN( '22851','20936','22612','22523','22630','22614*','22842','22632','20930','22524','27130','22525' ) 
      ) surgery 
        ON surgery.person_id = era.person_id AND 
           surgery.procedure_date BETWEEN condition_era_start_date AND condition_era_start_date + 60 
      LEFT OUTER JOIN ( 
        SELECT 
          person_id, 
          procedure_date AS drug_date, 
          1 AS drug 
        FROM @cdm.procedure_occurrence proc 
        JOIN @vocab.concept ON concept_id = procedure_concept_id 
        WHERE 
          vocabulary_id = 'CPT4' AND 
          concept_code IN( '20610','20552','207096','20553','20550','20605' ,'20551','20600','23350' ) 
        UNION SELECT 
          person_id, 
          drug_era_start_date, 
          1 
        FROM @cdm.drug_era 
        WHERE drug_concept_id IN(1125315, 778711, 1115008, 1177480, 1112807,1506270 ) 
      ) drug 
        ON drug.person_id = era.person_id AND 
           drug.drug_date BETWEEN condition_era_start_date AND condition_era_start_date + 60 
      LEFT OUTER JOIN ( 
        SELECT 
          person_id, 
          procedure_date AS pt_date, 
          1 AS pt 
        FROM @cdm.procedure_occurrence proc 
        JOIN @vocab.concept ON concept_id = procedure_concept_id 
        WHERE 
          vocabulary_id = 'CPT4' AND 
          concept_code IN( '97001', '97140', '97002' ) 
        UNION SELECT 
          person_id, 
          procedure_date AS pt_date, 
          1 AS pt 
        FROM @cdm.procedure_occurrence proc 
        JOIN @vocab.concept ON concept_id = procedure_concept_id 
        WHERE 
          vocabulary_id = 'HCPCS' AND 
          concept_code = 'G0283' 
      ) pt 
        ON pt.person_id = era.person_id AND 
           pt.pt_date BETWEEN condition_era_start_date AND condition_era_start_date + 60 
    ) 
    WHERE diag_date > '01-jan-2011' 
    GROUP by 
      person_id, 
      diag_date 
    ORDER BY 
      person_id, 
      diag_date 
  ) 
) 
GROUP BY treatment 
ORDER BY treatment;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| treatment |   |
| count |   |
| min |   |
| max |   |
| avg_condition_days |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| treatment |   |
| count |   |
| min |   |
| max |   |
| avg_condition_days |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
