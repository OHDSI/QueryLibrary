<!---
Group:drug exposure
Name:DEX32 Counts of drug exposure records per person
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX32: Counts of drug exposure records per person

## Description
This query is used to count the number of drug exposure records (drug_exposure_id) for all persons. The input to the query is a value (or a comma-separated list of values) for a number of records per person. If the input is omitted, all possible values are summarized.

## Query
The following is a sample run of the query.

```sql
SELECT
  person_id,
  count(*) AS stat_value
FROM @cdm.drug_exposure
GROUP BY person_id
HAVING count(*) in (3,4)
;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| count | 3, 4 |  Yes |   

## Output

|  Field |  Description |
| --- | --- |
| person_id | A foreign key identifier to the person who is subjected to the drug. The demographic details of that person are stored in the person table. |
| count | The number of individual drug exposure occurrences used to construct the drug era. |


## Example output record

|  Field |  Description |
| --- | --- |
| person_id | 2026  |
| count |  4 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
