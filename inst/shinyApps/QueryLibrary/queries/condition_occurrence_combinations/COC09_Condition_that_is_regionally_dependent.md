<!---
Group:condition occurrence combinations
Name:COC09 Condition that is regionally dependent
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC09: Condition that is regionally dependent

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| source_code | 088.81 | Yes | lyme disease |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT    state,
        count(*) AS total_enroled,
        sum( lymed ) AS lyme_cases,
        TRUNC( ( sum(lymed) /count(*) ) * 100, 2 ) AS percentages
FROM
    (
    SELECT    person_id,
            state,
            NVL( lymed, 0 ) lymed
    FROM @cdm.person
        JOIN @cdm.location USING( location_id )
        LEFT OUTER JOIN
            (
            SELECT DISTINCT    person_id,
                            1 AS lymed
            FROM
                @cdm.condition_era
                    JOIN source_to_concept_map
                        ON    target_concept_id = condition_concept_id
            WHERE
                source_vocabulary_id     = 'ICD9CM'
            AND    target_vocabulary_id     = 'SNOMED'
            AND    source_code             = '088.81'
            AND sysdate                 BETWEEN valid_start_date and valid_end_date
            ) USING( person_id ) 
    )
GROUP BY    state
ORDER BY    4 DESC;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| state | The state field as it appears in the source data. |
| count |   |
| lyme_cases |   |
| percent |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| state |   |
| count |   |
| lyme_cases |   |
| percent |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
