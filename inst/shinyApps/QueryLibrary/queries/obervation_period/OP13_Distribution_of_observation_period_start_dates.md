<!---
Group:observation period
Name:OP13 Distribution of observation period start dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP13: Distribution of observation period start dates

## Description
This query is used to to provide summary statistics for observation period start dates (observation_period_start_date) across all observation period records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
WITH op AS
        ( SELECT to_number( to_char( observation_period_start_date, 'J' ), 9999999)::INT AS start_date FROM @cdm.observation_period )
SELECT
        to_date( min( start_date ), 'J' ) AS min_start_date ,
        to_date( max( start_date ), 'J' ) AS max_start_date ,
        to_date( round( avg( start_date ) ), 'J' ) AS avg_start_date ,
        round( STDEV( start_date ) ) AS STDEV_days,
        to_date( (SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY start_date )  OVER() FROM op), 'J' ) AS percentile_25 ,
        to_date( (SELECT DISTINCT PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY start_date )  OVER() FROM op), 'J' ) AS median ,
        to_date( (SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY start_date )  OVER() FROM op), 'J' ) AS percentile_75
FROM
                op
;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
|  min_start_date |  Minimum start date value |
|  max_start_date |  Maximum start date value |
|  avg_start_date |  Average start date value |
|  STDEV_days |  Standard Deviation of start date |
|  percentile_25 |  25th percentile of start date |
|  median |  Median of start date |
|  percentile_75 |  75th percentile of start date |

## Sample output record

|  Field |  Value |
| --- | --- |
|  min_start_date |  1/1/2003 |
|  max_start_date |  6/30/2011 |
|  avg_start_date |  2/5/2008 |
|  STDEV_days |  741 |
|  percentile_25 |  1/1/2006 |
|  median |  1/1/2009 |
|  percentile_75 |  1/1/2010 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
