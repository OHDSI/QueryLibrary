<!---
Group:observation period
Name:OP18 Counts of observation period records stratified by start of observation month
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP18: Counts of observation period records stratified by start of observation month

## Description
This query is used to count the observation period records stratified by observation month and person end. person end is an indicator whether a person has initiated the first observation period in a given observation month. All possible values are summarized.

## Query
```sql
SELECT MONTH(observation_period_start_date ) observation_month , count(*) AS num_observations
FROM @cdm.observation_period
GROUP BY observation_month
ORDER BY 1;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| observation_month | Month of start of observation period |
| num_observations | Number of observations within specific month of observation |

## Sample output record

|  Field |  Description |
| --- | --- |
| observation_month |  1 |
| num_observations |  3987706 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
