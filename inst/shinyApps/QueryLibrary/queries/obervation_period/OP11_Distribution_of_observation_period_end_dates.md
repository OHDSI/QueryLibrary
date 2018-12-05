<!---
Group:observation period
Name:OP11 Distribution of observation period end dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP11: Distribution of observation period end dates

## Description
This query is used to to provide summary statistics for observation period end dates (observation_period_end_date) across all observation period records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
WITH op AS
( SELECT to_number( to_char( observation_period_end_date, 'J' ), 9999999 )::INT AS end_date
         FROM @cdm.observation_period)
SELECT to_date( min( end_date ), 'J' ) AS min_end_date
     , to_date( max( end_date ), 'J' ) AS max_end_date
     , to_date( round( avg( end_date ) ), 'J' ) AS avg_end_date
     , round( stdDev( end_date ) ) AS stdDev_end_days
     , to_date( (SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY end_date ) OVER () FROM op), 'J' ) AS percentile_25
     , to_date( (SELECT DISTINCT PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY end_date ) OVER () FROM op), 'J' ) AS median
     , to_date( (SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY end_date ) OVER () FROM op), 'J' ) AS percentile_75
  FROM op; /* end_date */
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| min_end_date |  Minimum value of observation period end date |
| max_end_date |  Maximum value of observation  period end date |
| avg_end_date |  Average value of observation period end date |
| stdDev_end_date |  Standard deviation of observation period end date |
| percentile_25 |  25th percentile of observation period end date |
| median |  Median value of observation period end date |
| percentile_75 |  75th percentile of observation period end date |

## Sample output record

|  Field |  Description |
| --- | --- |
| min_end_date | 1/31/2003 |
| max_end_date |  6/30/2011 |
|  avg_end_date |  11/21/2009 |
|  stdDev_end_date |  614 |
|  percentile_25 |  12/31/2008 |
|  median |  12/31/2009 |
|  percentile_75 |  12/31/2010 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
