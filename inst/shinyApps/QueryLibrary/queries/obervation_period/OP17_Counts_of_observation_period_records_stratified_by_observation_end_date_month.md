<!---
Group:observation period
Name:OP17 Counts of observation period records stratified by observation end date month.
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP17: Counts of observation period records stratified by observation end date month.

## Description
This query is used to count the observation period records stratified by observation month and person end. person end is an indicator whether a person has completed the last observation period in a given observation month. All possible values are summarized.

## Query
```sql
SELECT EXTRACT( month
FROM observation_period_end_date ) observation_month , count(*) AS num_observations
FROM @cdm.observation_period
GROUP BY observation_month
ORDER BY 1;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| observation_month | Month of observation |
| num_observations | Number of observation within end of observation period month |

## Sample output record

|  Field |  Description |
| --- | --- |
| observation_month |  1 |
| num_observations |  62183 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
