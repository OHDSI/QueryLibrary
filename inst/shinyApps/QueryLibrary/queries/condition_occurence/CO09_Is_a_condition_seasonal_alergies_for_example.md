<!---
Group:condition occurrence
Name:CO09 Is a condition seasonal, alergies for example
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO09: Is a condition seasonal, alergies for example

## Description
Returns the distribution of condition occurrence per season in the northern hemisphere, defined in the following way:

|  Spring |  March 21 - June 21 |
| --- | --- |
|  Summer |  June 22 - September 22 |
|  Fall |  September 23 - December 21 |
|  Winter |  December 22 - March 20 |

## Query
```sql
SELECT season, COUNT(*) as season_freq
FROM (
SELECT CASE
WHEN (daymonth>0320
AND daymonth<=0621) THEN 'Spring' WHEN (daymonth>0621
AND daymonth<=0922) THEN 'Summer' WHEN (daymonth>0922
AND daymonth<=1221) THEN 'Fall' WHEN (daymonth>1221
OR (daymonth>0000
AND daymonth<=0520)) THEN 'Winter' ELSE 'Unknown' end AS season
FROM (
SELECT cast(substring(condition_start_date
from 6 for 2)|| substring(condition_start_date
from 9 for 2) as int) AS daymonth,condition_start_date
FROM condition_occurrence
WHERE condition_concept_id = 31967 ) ) AS condition_season
GROUP BY season
ORDER BY season_freq;
```

## Input

| Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id | 31967 | Yes | Condition concept identifier for 'Nausea' |

## Output

| Field |  Description |
| --- | --- |
| season | Season as defined in the northern hemisphere. |
| season_freq | Frequency of condition occurrence in the season. |

## Sample output record

|  Field |  Description |
| --- | --- |
| season | Summer |
| season_freq | 62924 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
