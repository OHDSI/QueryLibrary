<!---
Group:drug exposure
Name:DEX14 Among people who take drug A, how many take drug B at the same time?
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX14: Among people who take drug A, how many take drug B at the same time?

## Description


## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  S

```sql
WITH statins AS (
SELECT descendant_concept_id AS concept_id
  FROM @vocab.concept_ancestor
 WHERE ancestor_concept_id = 1539403
), diuretics AS (
SELECT descendant_concept_id AS concept_id
  FROM @vocab.concept_ancestor
 WHERE ancestor_concept_id = 974166
)
SELECT COUNT(DISTINCT de1.person_id) AS num_users,
       COUNT(DISTINCT de2.person_id) AS also_bp
  FROM @cdm.drug_exposure de1
  JOIN statins s
    ON de1.drug_concept_id = s.concept_id
  JOIN @cdm.drug_exposure de2
    ON de1.person_id = de2.person_id
  LEFT JOIN diuretics d
    ON de2.drug_concept_id = d.concept_id
   AND de2.drug_exposure_start_date < de1.drug_exposure_end_date
   AND de2.drug_exposure_end_date   > de1.drug_exposure_start_date;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_id | 1539403 | Yes | Statins |
| ancestor_concept_id | 974166 | Yes | Diuretics |

## Output

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept. |
| person_id | A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table. |
| ancestor_concept_id | A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship. |
| drug_exposure_start_date | The start date for the current instance of drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a drug administration procedure was recorded. |
| drug_exposure_end_date | The end date for the current instance of drug utilization. It is not available from all sources. |

## Example output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| person_id |   |
| ancestor_concept_id |   |
| drug_exposure_start_date |   |
| drug_exposure_end_date |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
