<!---
Group:drug cost
Name:DRC03 What is out-of-pocket cost for a given drug?
Author:Patrick Ryan
CDM Version: 5.3
-->

# DRC03: What is out-of-pocket cost for a given drug?

## Description
## Query
```sql
SELECT avg(c.paid_by_patient - c.paid_patient_copay) AS avg_out_pocket_cost, d.drug_concept_id
FROM @cdm.cost c, @cdm.drug_exposure d
WHERE d.drug_exposure_id = c.cost_event_id
AND (c.paid_by_patient - c.paid_patient_copay) > 0
AND d.drug_concept_id
IN (906805, 1517070, 19010522)
GROUP BY d.drug_concept_id;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of drug_concept_id | 906805, 1517070, 19010522 | Yes |   |

## Output

|  Field |  Description |
| --- | --- |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| total_out_of_pocket | The total amount paid by the person as a share of the expenses, excluding the copay. |
| avg_out_pocket_cost | The average amount paid by the person as a share of the expenses, excluding the copay. |

## Example output record

|   |
| --- |
| Field |  Description |
| avg_out_pocket_cost |   |
| drug_concept_id |   |
| total_out_of_pocket |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
