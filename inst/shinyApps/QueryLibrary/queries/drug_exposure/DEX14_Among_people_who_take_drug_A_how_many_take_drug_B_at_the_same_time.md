<!---
Group:drug exposure
Name:DEX14 Among people who take drug A, how many take drug B at the same time?
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX14: Among people who take drug A, how many take drug B at the same time?

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_id | 21502747 | Yes | Statins |
| ancestor_concept_id | 21500223 | Yes | Antihypertensive Therapy Agents |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  S

```sql
SELECT count(*) AS num_A_users , SUM( bp_also ) AS num_also_using_B
FROM /* people taking statin and possible taking antihypertensive agent */
    ( SELECT statin.person_id, MAX( NVL( bp, 0 ) ) AS bp_also
        FROM /*people taking statin */
            ( SELECT  person_id, drug_exposure_start_date, drug_exposure_end_date
                FROM @cdm.drug_exposure statin
                WHERE drug_concept_id IN /*statins*/
                    ( SELECT concept_id
                        FROM @vocab.concept
                        JOIN @cdm.concept_ancestor ON descendant_concept_id = concept_id
                        WHERE
                        ancestor_concept_id = 21502747
                        AND standard_concept = 'S'
                        AND getdate() BETWEEN valid_start_date AND valid_end_date ) ) statin                            
            LEFT OUTER JOIN /* people taking antihypertensive agent */
            ( SELECT  person_id, drug_exposure_start_date, drug_exposure_end_date , 1 AS bp
                FROM @cdm.drug_exposure
                WHERE drug_concept_id IN /*Antihypertensive Therapy Agents */
                    ( SELECT concept_id
                        FROM @cdm.concept
                        JOIN @cdm.concept_ancestor ON descendant_concept_id = concept_id 
                        WHERE
                        ancestor_concept_id = 21500223
                        AND standard_concept = 'S'
                        AND getdate() BETWEEN valid_start_date AND valid_end_date ) ) bp
    ON bp.person_id = statin.person_id
    AND bp.drug_exposure_start_date < statin.drug_exposure_end_date
    AND bp.drug_exposure_end_date > statin.drug_exposure_start_date
    GROUP BY statin.person_id );
```

## Output


## Output field list

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept. |
| person_id | A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table. |
| ancestor_concept_id | A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship. |
| drug_exposure_start_date | The start date for the current instance of drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a drug administration procedure was recorded. |
| drug_exposure_end_date | The end date for the current instance of drug utilization. It is not available from all sources. |


## Sample output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| person_id |   |
| ancestor_concept_id |   |
| drug_exposure_start_date |   |
| drug_exposure_end_date |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
