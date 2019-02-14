<!---
Group:condition occurrence
Name:CO15 Distribution of number of distinct conditions persons have
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO15: Distribution of number of distinct conditions persons have

## Description
This query is used to provide summary statistics for the number of different distinct conditions (condition_concept_id) of all persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
with ranked as (
  SELECT
    num_of_conditions,
    row_number() over (order by num_of_conditions asc) AS rownumasc
  FROM(
    select
      person_id,
      count(distinct condition_concept_id) AS num_of_conditions
    FROM @cdm.condition_occurrence
    where person_id!=0
    GROUP BY person_id
  )
),
other_stat AS (
  SELECT
    count(num_of_conditions) as condition_dist_num_count,
    min(num_of_conditions) as condition_dist_num_min,
    max(num_of_conditions) as condition_dist_num_max,
    avg(num_of_conditions) as condition_dist_num_averege,
    stddev(num_of_conditions) as condition_dist_num_stddev
  FROM (
    SELECT
      count(distinct condition_concept_id) AS num_of_conditions,
      person_id
    FROM @cdm.condition_occurrence
    WHERE person_id!=0
    GROUP BY person_id
  )
)
SELECT
  (SELECT count(distinct person_id) FROM condition_occurrence WHERE person_id!=0 and condition_occurrence_id is null) AS condition_null_count,
  *
FROM
  other_stat,
  ( SELECT distinct
      num_of_conditions as condition_dist_num_25percentile
    FROM
      (select *,(select count(*) from ranked) as rowno from ranked)
    WHERE
      (rownumasc=cast (rowno*0.25 as int) and mod(rowno*25,100)=0) or
      (rownumasc=cast (rowno*0.25 as int) and mod(rowno*25,100)>0) or
      (rownumasc=cast (rowno*0.25 as int)+1 and mod(rowno*25,100)>0)
  ) AS condition_end_date_25percentile,
  ( SELECT distinct
      num_of_conditions as condition_dist_num_median
    FROM
      (select *,(select count(*) from ranked) as rowno from ranked)
    WHERE
      (rownumasc=cast (rowno*0.50 as int) and mod(rowno*50,100)=0) or
      (rownumasc=cast (rowno*0.50 as int) and mod(rowno*50,100)>0) or
      (rownumasc=cast (rowno*0.50 as int)+1 and mod(rowno*50,100)>0)
  ) AS condition_end_date_median,
  ( SELECT distinct
      num_of_conditions as condition_dist_num_75percentile
    FROM
      (select *,(select count(*) from ranked) as rowno from ranked)
    WHERE
      (rownumasc=cast (rowno*0.75 as int) and mod(rowno*75,100)=0) or
      (rownumasc=cast (rowno*0.75 as int) and mod(rowno*75,100)>0) or
      (rownumasc=cast (rowno*0.75 as int)+1 and mod(rowno*75,100)>0)
  ) AS condition_end_date_75percentile;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| condition_null_count | Number of condition occurrences where condition_occurrence_id is null |
| condition_count | Number of condition occurrences |
| condition_dist_num_min | The lowest number of distinct condition occurrences |
| condition_dist_num_max | The highest number of distinct condition occurrences |
| condition_dist_num_averege | The avarege number of distinct condition occurrences |
| condition_dist_num_stddev | The standard deviation of distinct condition occurence numbers |
| condition_dist_num_25percentile | A distinct condition occurrence number where 25 percent of the other numbers are lower |
| condition_dist_num_median | A distinct condition occurrence number where half of the other numbers are lower and half are higher |
| condition_dist_num_75percentile | A distinct condition occurrence number where 75 percent of the other numbers are lower |

## Sample output record

|  Field |  Description |
| --- | --- |
| condition_null_count | 0 |
| condition_count | 4395019 |
| condition_dist_num_min | 1 |
| condition_dist_num_max | 327 |
| condition_dist_num_averege | 17 |
| condition_dist_num_stddev | 16.94 |
| condition_dist_num_25percentile | 6 |
| condition_dist_num_median | 12 |
| condition_dist_num_75percentile | 23 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
