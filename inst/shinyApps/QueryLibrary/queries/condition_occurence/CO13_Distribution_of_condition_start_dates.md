<!---
Group:condition occurrence
Name:CO13 Distribution of condition start dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO13: Distribution of condition start dates

## Description
This query is used to to provide summary statistics for condition occurrence start dates (condition_occurrence_start_date) across all condition occurrence records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
WITH end_rank AS 
  (SELECT
    condition_start_date,
    SUM(1) over (partition BY 1 ORDER BY condition_start_date ASC ROWS BETWEEN unbounded preceding AND CURRENT row) AS rownumASc
  FROM @cdm.condition_occurrence
  ),
    other_stat AS 
  (SELECT
    COUNT(condition_start_date)                       AS condition_start_date_count,
    MIN(condition_start_date)                         AS condition_start_date_min,
    MAX(condition_start_date)                         AS condition_start_date_max,
    to_date('0001-01-01', 'yyyy/mm/dd')+ CAST(AVG(condition_start_date-'0001-01-01') AS INT) AS condition_start_date_average,
    stddev((condition_start_date-'0001-01-01'))       AS condition_start_date_stddev
   FROM @cdm.condition_occurrence
   WHERE condition_start_date IS NOT NULL
  )

SELECT
  (SELECT 
    COUNT(condition_start_date) 
   FROM @cdm.condition_occurrence 
   WHERE condition_start_date IS NULL
  ) AS condition_start_date_null_count,
  *
FROM other_stat,
    (SELECT
      to_date('0001-01-01', 'yyyy/mm/dd')+CAST(AVG(condition_start_date-'0001-01-01') AS INT) AS condition_start_date_25percentile
     FROM
      (SELECT *,(SELECT COUNT(*) FROM end_rank) AS rowno FROM end_rank) a_1
     WHERE (rownumASc=CAST(rowno*0.25 AS int) 
            AND mod(rowno*25,100)=0) OR
            (rownumASc=CAST(rowno*0.25 AS int)
            AND mod(rowno*25,100)>0)
            OR (rownumASc=CAST(rowno*0.25 AS int)+1 
            AND mod(rowno*25,100)>0)
    ) AS condition_start_date_25percentile,
    (SELECT
      to_date('0001-01-01', 'yyyy/mm/dd')+CAST(avg(condition_start_date-'0001-01-01') AS int) AS condition_start_date_median
     FROM
      (SELECT *, (SELECT COUNT(*) FROM end_rank) AS rowno FROM end_rank) a_2
     WHERE (rownumASc=CAST(rowno*0.50 AS int) 
            AND mod(rowno*50,100)=0)
            OR (rownumASc=CAST(rowno*0.50 AS int)
            AND mod(rowno*50,100)>0)
            OR (rownumASc=CAST(rowno*0.50 AS int)+1
            AND mod(rowno*50,100)>0)
    ) AS condition_start_date_median,
    (SELECT
      to_date('0001-01-01', 'yyyy/mm/dd')+CAST(AVG(condition_start_date-'0001-01-01') AS int) AS condition_start_date_75percentile
     FROM
      (select *, (select count(*) from end_rank) AS rowno from end_rank) a_3
     WHERE (rownumASc=CAST(rowno*0.75 AS int) AND mod(rowno*75,100)=0) 
           OR  (rownumASc=CAST(rowno*0.75 AS int) AND mod(rowno*75,100)>0) 
           OR  (rownumASc=CAST(rowno*0.75 AS int)+1 AND mod(rowno*75,100)>0)
    ) AS condition_start_date_75percentile
;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| condition_start_date_null_count | Number of condition occurrences where start date is null |
| condition_start_date_count | Number of condition occurrence start dates |
| condition_start_date_min | The earliest start date of a condition occurrence |
| condition_start_date_max | The latest start date of a condition occurrence |
| condition_start_date_average | The average start date (spanning from the earliest to the latest date and counted by days) |
| condition_start_date_stddev | The standard deviation of start dates, in number of days (spanning from the earliest to the latest date and counted by days) |
| condition_start_date_25percentile | A start date where 25 percent of the other end dates are earlier |
| condition_start_date_median | A start date where half of the other end dates are earlier and half are later |
| condition_start_date_75percentile | A start date where 75 percent of the other end dates are earlier |

## Sample output record

|  Field |  Value |
| --- | --- |
| condition_start_date_null_count | 0 |
| condition_start_date_count | 224523674 |
| condition_start_date_min | 2003-01-01 |
| condition_start_date_max | 2011-11-08 |
| condition_start_date_average | 2008-11-30 |
| condition_start_date_stddev | 651.27 |
| condition_start_date_25percentile | 2007-10-30 |
| condition_start_date_median | 2009-05-06 |
| condition_start_date_75percentile | 2010-05-03 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
