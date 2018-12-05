<!---
Group:condition era
Name:CE06 Conditions most likely to result in death
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE06: Conditions most likely to result in death

## Description
| Most prevalent conditions within thirty days of death
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| Number of days since condition era end | 30 |  Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT concept_name, count(*) as conditions_count 
FROM  ( 
SELECT death.person_id, concept_name 
FROM death 
JOIN condition_era condition ON condition.person_id = death.person_id 
AND death_date - condition_era_end_date <= 30 
JOIN concept ON concept_id = condition_concept_id ) 
GROUP BY concept_name 
ORDER BY conditions_count 
DESC;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept |
| count |   |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |

## Sample output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| count |   |
| condition_concept_id |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
