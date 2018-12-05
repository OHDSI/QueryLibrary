<!---
Group:condition occurrence
Name:CO12 Distribution of condition end dates.
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO12: Distribution of condition end dates.

## Description
This query is used to to provide summary statistics for condition occurrence end dates (condition_occurrence_end_date) across all condition occurrence records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
with end_rank as (
  SELECT
    condition_end_date-'0001-01-01' as num_end_date,
    condition_end_date,
    sum(1) over (partition by 1 order by condition_end_date asc rows between unbounded preceding and current row) as rownumasc
  FROM
    condition_occurrence
),
other_stat as (
  SELECT
    count(condition_end_date) as condition_end_date_count,
    min(condition_end_date) as condition_end_date_min,
    max(condition_end_date) as condition_end_date_max,
    to_date('0001-01-01', 'yyyy/mm/dd')+ cast(avg(condition_end_date-'0001-01-01') as int) as condition_end_date_average,
    stddev((condition_end_date-'0001-01-01')) as condition_end_date_stddev
  FROM
    condition_occurrence
  WHERE
    condition_end_date is not null
)
SELECT
  (SELECT count(condition_end_date) FROM condition_occurrence WHERE condition_end_date is null) AS condition_end_date_null_count,
  *
FROM
  other_stat,
  ( SELECT
      to_date('0001-01-01', 'yyyy/mm/dd')+cast(avg(condition_end_date-'0001-01-01') as int) AS condition_end_date_25percentile
    FROM
      (select *,(select count(*) from end_rank) as rowno from end_rank)
    WHERE
      (rownumasc=cast (rowno*0.25 as int) and mod(rowno*25,100)=0) or
      (rownumasc=cast (rowno*0.25 as int) and mod(rowno*25,100)>0) or
      (rownumasc=cast (rowno*0.25 as int)+1 and mod(rowno*25,100)>0)
  ) AS condition_end_date_25percentile,
  ( SELECT
      to_date('0001-01-01', 'yyyy/mm/dd')+cast(avg(condition_end_date-'0001-01-01') as int) as condition_end_date_median
    FROM
      (select *,(select count(*) from end_rank) as rowno from end_rank)
    WHERE
      (rownumasc=cast (rowno*0.50 as int) and mod(rowno*50,100)=0) or
      (rownumasc=cast (rowno*0.50 as int) and mod(rowno*50,100)>0) or
      (rownumasc=cast (rowno*0.50 as int)+1 and mod(rowno*50,100)>0)
  ) AS condition_end_date_median,
  ( SELECT
      to_date('0001-01-01', 'yyyy/mm/dd')+cast(avg(condition_end_date-'0001-01-01') as int) as condition_end_date_75percentile
    FROM
      (select *,(select count(*) from end_rank) as rowno from end_rank)
    WHERE
      (rownumasc=cast (rowno*0.75 as int) and mod(rowno*75,100)=0) or
      (rownumasc=cast (rowno*0.75 as int) and mod(rowno*75,100)>0) or
      (rownumasc=cast (rowno*0.75 as int)+1 and mod(rowno*75,100)>0)
  ) AS condition_end_date_75percentile;
```

## Input

None



## Output

| Field |  Description |
| --- | --- |
| condition_end_date_null_count | Number of condition occurrences where end date is null |
| condition_end_date_count | Number of condition occurrence end dates |
| condition_end_date_min | The earliest end date of a condition occurrence |
| condition_end_date_max | The latest end date of a condition occurrence |
| condition_end_date_average | The average end date (spanning from the earliest to the latest date and counted by days) |
| condition_end_date_stddev | The standard deviation of end dates, in number of days (spanning from the earliest to the latest date and counted by days) |
| condition_end_date_25percentile |  An end date where 25 percent of the other end dates are earlier |
| condition_end_date_median |  An end date where half of the other end dates are earlier and half are later |
| condition_end_date_75percentile |  An end date where 75 percent of the other end dates are earlier |

## Sample output record

|  Field |  Value |
| --- | --- |
| condition_end_date_null_count | 0 |
| condition_end_date_count | 224523674 |
| condition_end_date_min | 2003-01-01 |
| condition_end_date_max | 011-12-15 |
| condition_end_date_average | 2008-11-30 |
| condition_end_date_stddev | 651.19 |
| condition_end_date_25percentile | 2007-10-30 |
| condition_end_date_median | 2009-05-07 |
| condition_end_date_75percentile | 2010-05-04 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
