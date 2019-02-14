<!---
Group:observation period
Name:OP10 Observation period records stratified by observation month
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP10: Observation period records stratified by observation month

## Description
Counts the observation period records stratified by observation month. All possible values are summarized.

## Query
```sql
SELECT
  month,
  sum( observations ) AS num_observations
FROM (
  SELECT
    person_id,
    start_date,
    end_date ,
    month ,
    min_count,
    remainder ,
    start_month,
    IIF( SIGN(start_month + remainder - 12) = -1, start_month + remainder, 12) end1 ,
    1,
    start_month + remainder - 12 end2 ,
    min_count + CASE
      WHEN MONTH >= start_month AND MONTH <= IIF( SIGN(start_month + remainder - 12) = -1, start_month + remainder, 12) THEN 1
      WHEN MONTH >= 1 AND MONTH <= start_month + remainder - 12 THEN 1
      ELSE 0
    END AS observations
  FROM (
    SELECT 1 AS month
    UNION SELECT 2
    UNION SELECT 3
    UNION SELECT 4
    UNION SELECT 5
    UNION SELECT 6
    UNION SELECT 7
    UNION SELECT 8
    UNION SELECT 9
    UNION SELECT 10
    UNION SELECT 11
    UNION SELECT 12  )
  CROSS JOIN (
    SELECT
      person_id,
      start_date,
      end_date ,
      min_count,
      start_month,
      remainder
    FROM (
      SELECT
        person_id,
        observation_period_start_date start_date ,
        observation_period_end_date as end_date ,
        round(months_between( observation_period_end_date, observation_period_start_date ) ) AS months /* number of complete years */ ,
        floor( round(months_between( observation_period_end_date, observation_period_start_date ) ) / 12 ) AS min_count ,
        MONTH(observation_period_start_date ) start_month ,
        mod( cast(round(months_between( observation_period_end_date, observation_period_start_date ) ) AS integer), 12 ) AS remainder
      FROM
        @cdm.observation_period
    )
  )
) GROUP BY month order by month;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
|  month |  Month number 1-12 |
|  num_observations |  Number of observation in a specific month |

## Sample output record

| Field |  Value |
| --- | --- |
|  month |  1 |
|  num_observations |  12266979 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
