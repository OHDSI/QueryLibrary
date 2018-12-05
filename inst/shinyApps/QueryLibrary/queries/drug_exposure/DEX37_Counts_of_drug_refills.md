<!---
Group:drug exposure
Name:DEX37 Counts of drug refills
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX37: Counts of drug refills

## Description
| This query is used to count the drug refills (refills) across all drug exposure records. The input to the query is a value (or a comma-separated list of values) of refills. If the input is omitted, all existing values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| refills count (list of numbers) | 10,20 | Yes |


## Query

The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT count(1) as drug_exposure_count, d.refills AS refills_count
FROM @cdm.drug_exposure d 
WHERE d.refills in (10, 20)
GROUP BY d.refills ;
```

## Output


## Output field list

|  Field |  Description |
| --- | --- |
| drug_exposure_count | The number of individual drug exposure occurrences used to construct the drug era. |
| Refills_Count | The number of refills after the initial prescription. The initial prescription is not counted, values start with 0. |


## Sample output record

|  Field |  Description |
| --- | --- |
| drug_exposure_count |   |
| Refills_Count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
