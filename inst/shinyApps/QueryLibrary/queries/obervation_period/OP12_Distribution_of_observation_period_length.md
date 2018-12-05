<!---
Group:observation period
Name:OP12 Distribution of observation period length
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP12: Distribution of observation period length

## Description
This query is used to provide summary statistics for the observation period length across all observation period records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The length of an is defined as the difference between the start date and the end date. No input is required for this query.

## Query
```sql
SELECT
        min( period_length ) OVER() AS min_period,
        max( period_length ) OVER() AS max_period,
        round( avg( period_length ) OVER(), 2 ) AS avg_period,
        round( stdDev( period_length ) OVER(), 1 ) AS stdDev_period,
        PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY period_length ) OVER() AS percentile_25,
        PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY period_length ) OVER() AS median,
        PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY period_length ) OVER() AS percentile_75
FROM /* period_length */
        (
                SELECT
                        observation_period_end_date - observation_period_start_date + 1 AS period_length
                FROM
                        observation_period
        )
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| min_period | Minimum observation period duration in days |
| max_period | Maximum observation period duration in days |
| avg_period | Average observation period in days |
| stdDev_period | Standard deviation of observation period days |
| percentile_25 | 25th percentile of observation period days |
| median | Median value of of observation period |
| percentile_75 | 25th percentile of observation period days  |

## Sample output record

|  Field |  Value |
| --- | --- |
|  min_period |  1 |
|  max_period |  2372 |
|  avg_period |  655.91 |
|  stdDev_period |  501 |
|  percentile_25 |  365 |
|  median |  487 |
|  percentile_75 |  731 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
