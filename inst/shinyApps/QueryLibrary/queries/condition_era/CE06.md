<!---
Group:condition era
Name:CE06 Conditions most likely to result in death
Author:Patrick Ryan
CDM Version: 5.3
-->

# CE06: Conditions most likely to result in death

## Description
| Most prevalent conditions within thirty days of death

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT concept_name, COUNT(*) as conditions_count
FROM  (
SELECT d.person_id, c.concept_name
  FROM @cdm.death d
  JOIN @cdm.condition_era ce
    ON ce.person_id = d.person_id
   AND DATEDIFF(d,ce.condition_era_end_date,d.death_date) <= 30
  JOIN @vocab.concept c
    ON c.concept_id = ce.condition_concept_id
	   ) TMP
GROUP BY concept_name
ORDER BY conditions_count DESC;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| Number of days since condition era end | 30 |  Yes |   |

## Output

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept |
| count |   |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |

## Example output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| count |   |
| condition_concept_id |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
