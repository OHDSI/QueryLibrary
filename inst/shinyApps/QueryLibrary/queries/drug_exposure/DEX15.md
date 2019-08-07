<!---
Group:drug exposure
Name:DEX15 Number of persons taking a given drug having at least a 180 day period prior and a 365 day follow-up period
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX15: Number of persons taking a given drug having at least a 180 day period prior and a 365 day follow-up period

## Description

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.

```sql
WITH statins AS (
SELECT descendant_concept_id AS concept_id
  FROM @vocab.concept_ancestor
 WHERE ancestor_concept_id = 1539403
), statin_users AS (
SELECT de.person_id, MIN(de.drug_exposure_start_date) AS index_date
  FROM @cdm.drug_exposure de
  JOIN statins s
    ON de.drug_concept_id = s.concept_id
 GROUP BY de.person_id
)    
SELECT FLOOR(1.0*DATEDIFF(d,su.index_date,op.observation_period_end_date)/365) AS follow_up_years,
       COUNT(*) AS persons
       /* statin users with 180 clean period and at least 1 year follow up period */
  FROM statin_users su
  JOIN @cdm.observation_period op
    ON su.person_id  = op.person_id
 WHERE DATEADD(d,180,op.observation_period_start_date) < su.index_date
   AND op.observation_period_end_date                  > DATEADD(d,365,su.index_date)
 GROUP BY FLOOR(1.0*DATEDIFF(d,su.index_date,op.observation_period_end_date)/365)
 ORDER BY 1;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_id | 1539403 | Yes | Statins |

## Output

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept. |
| person_id | A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table. |
| ancestor_concept_id | A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship. |
| descendant_concept_id | A foreign key to the concept code in the concept table for the lower-level concept that forms the descendant in the relationship. |
| observation_period_start_date | The start date of the observation period for which data are available from the data source. |
| observation_period_end_date | The end date of the observation period for which data are available from the data source. |

## Example output record

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
