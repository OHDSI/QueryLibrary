<!---
Group:observation period
Name:OP08 Distribution of observation period records per person
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP08: Distribution of observation period records per person

## Description
Counts the number of observation period records (observation_period_id) for all persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. There is no input required for this query.

## Query
```sql
WITH obser_person AS
(
        SELECT        person_id,
                        count(*) as observation_periods
        FROM        @cdm.observation_period
                                JOIN        @cdm.person USING( person_id )
        GROUP BY        person_id
)
SELECT        min( observation_periods ) AS min_periods ,
                max( observation_periods ) AS max_periods ,
                round( avg( observation_periods ), 2 ) AS avg_periods ,
                round( stdDev( observation_periods ), 1 ) AS stdDev_periods ,
                (SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY observation_periods ) OVER() FROM obser_person) AS percentile_25 ,
                (SELECT DISTINCT PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY observation_periods ) OVER() FROM obser_person) AS median ,
                (SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY observation_periods ) OVER() FROM obser_person) AS percentile_75
FROM
        obser_person
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
|  min_periods |  Minimum number of periods  |
|  max_periods |  Maximum number of periods |
|  avg_periods |  Average number of periods |
|  stdDev_periods |  Standard Deviation of periods |
|  percentile_25 |  25th percentile of periods |
|  median |  Median of periods |
|  percentile_75 |  75th percentile of periods |

## Sample output record

| Field |  Value |
| --- | --- |
|  min_periods |  1 |
|  max_periods |  10 |
|  avg_periods |  1.12 |
|  stdDev_periods |  0.30 |
|  percentile_25 |  1 |
|  median |  1 |
|  percentile_75 |  1  |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
