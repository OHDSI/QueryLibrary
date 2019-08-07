<!---
Group:drug exposure
Name:DEX30 Counts of number of distinct drugs persons take
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX30: Counts of number of distinct drugs persons take

## Description
This query is used to count the number of different distinct drugs (drug_concept_id) of all exposed persons. The input to the query is a value (or a comma-separated list of values) for a number of drug concepts. If the input is omitted, all possible values are summarized.

## Query
The following is a sample run of the query.

```sql
SELECT
  t.person_id,
  count(DISTINCT t.drug_concept_id) AS n_distinct_drugs
FROM @cdm.drug_exposure t
GROUP BY t.person_id
HAVING count(DISTINCT t.drug_concept_id) > 10
;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| min_distinct_drugs | 10 | No |   |


## Output

|  Field |  Description |
| --- | --- |
| person_id | A foreign key identifier to the person who is subjected to the drug. The demographic details of that person are stored in the person table. |
| stat_value | The number of individual drug exposure occurrences used to construct the drug era. |

## Example output record

|  Field |  Description |
| --- | --- |
| person | 1279  |
| n_distinct_drugs |  11 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
