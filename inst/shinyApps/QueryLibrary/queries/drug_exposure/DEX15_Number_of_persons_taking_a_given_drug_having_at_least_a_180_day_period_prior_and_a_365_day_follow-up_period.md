<!---
Group:drug exposure
Name:DEX15 Number of persons taking a given drug having at least a 180 day period prior and a 365 day follow-up period
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX15: Number of persons taking a given drug having at least a 180 day period prior and a 365 day follow-up period

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_id | 21502747 | Yes | Statins |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.

```sql
SELECT
    floor( ( observation_period_end_date - index_date ) / 365 ) AS follow_up_years, 
    count(*) AS persons FROM /* statin users with 180 clean period and at least 1 year follow up period */ 
    ( 
    SELECT person_id, index_date , observation_period_start_date , observation_period_end_date 
    FROM /*statin user start_date */ 
        ( 
        SELECT 
            person_id, 
            min( drug_exposure_start_date ) AS index_date 
        FROM drug_exposure statin 
        WHERE drug_concept_id IN /*statins */ 
              ( 
            SELECT concept_id 
            FROM concept 
            JOIN concept_ancestor ON descendant_concept_id = concept_id 
            WHERE ancestor_concept_id = 21502747 
            --AND vocabulary_id = 8 
            AND vocabulary_id = 'RxNorm'
            AND standard_concept = 'S' 
            AND sysdate BETWEEN valid_start_date AND valid_end_date ) GROUP BY person_id ) 
    JOIN observation_period USING( person_id ) 
    WHERE observation_period_start_date + 180 < index_date AND observation_period_end_date > index_date + 365
    ) 
GROUP BY floor( ( observation_period_end_date - index_date ) / 365 ) 
ORDER BY 1; 
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| concept_name | An unambiguous, meaningful and descriptive name for the concept. |
| person_id | A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table. |
| ancestor_concept_id | A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship. |
| descendant_concept_id | A foreign key to the concept code in the concept table for the lower-level concept that forms the descendant in the relationship. |
| observation_period_start_date | The start date of the observation period for which data are available from the data source. |
| observation_period_end_date | The end date of the observation period for which data are available from the data source. |

## Sample output record

|  Field |  Description |
| --- | --- | 
| concept_name |   |
| person_id |   |
| ancestor_concept_id |   |
| descendant_concept_id |   |
| observation_period_start_date |   |
| observation_period_end_date |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
