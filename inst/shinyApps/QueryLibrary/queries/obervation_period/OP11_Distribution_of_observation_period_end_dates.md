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
  (SELECT 
      CAST(CONVERT(VARCHAR, observation_period_end_date, 112) AS INTEGER) AS end_date
   FROM @cdm.observation_period 
  )

SELECT
  CONVERT(DATE, CAST( min(end_date) AS varchar ))                    AS min_end_date ,
  CONVERT(DATE, CAST( max(end_date) AS varchar ))                    AS max_end_date ,
  
  DATEADD(day, ROUND(AVG(DATEDIFF(day,'1900-01-01', CAST (end_date AS VARCHAR) ))), '1900-01-01') AS avg_end_date,
  
  ROUND(STDEV(end_date))                                             AS STDEV_days,
  
  CONVERT(DATE, CAST((SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY end_date) FROM op) AS VARCHAR))  AS percentile_25,
  CONVERT(DATE, CAST((SELECT DISTINCT PERCENTILE_DISC(0.5)  WITHIN GROUP(ORDER BY end_date) FROM op) AS VARCHAR))  AS median ,
  CONVERT(DATE, CAST((SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY end_date) FROM op) AS VARCHAR))  AS percentile_75
FROM op
;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| min_end_date |  Minimum value of observation period end date |
| max_end_date |  Maximum value of observation  period end date |
| avg_end_date |  Average value of observation period end date |
| STDEV_end_date |  Standard deviation of observation period end date |
| percentile_25 |  25th percentile of observation period end date |
| median |  Median value of observation period end date |
| percentile_75 |  75th percentile of observation period end date |

## Sample output record

|  Field |  Description |
| --- | --- |
| min_end_date | 1/31/2003 |
| max_end_date |  6/30/2011 |
|  avg_end_date |  11/21/2009 |
|  STDEV_end_date |  614 |
|  percentile_25 |  12/31/2008 |
|  median |  12/31/2009 |
|  percentile_75 |  12/31/2010 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
