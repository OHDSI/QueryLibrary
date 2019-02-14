<!---
Group:drug exposure
Name:DEX30 Counts of number of distinct drugs persons take
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX30: Counts of number of distinct drugs persons take

## Description
| This query is used to count the number of different distinct drugs (drug_concept_id) of all exposed persons. The input to the query is a value (or a comma-separated list of values) for a number of drug concepts. If the input is omitted, all possible values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| drug_concept_id | 15, 22 | Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  S

```sql
SELECT count(distinct t.drug_concept_id) AS stat_value, t.person_id
FROM @cdm.drug_exposure t
GROUP BY t.person_id HAVING count(DISTINCT t.drug_concept_id) in (15,22);
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| person_id | A foreign key identifier to the person who is subjected to the drug. The demographic details of that person are stored in the person table. |
| stat_value | The number of individual drug exposure occurrences used to construct the drug era. |

## Sample output record

|  Field |  Description |
| --- | --- |
| person |   |
| stat_value |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
