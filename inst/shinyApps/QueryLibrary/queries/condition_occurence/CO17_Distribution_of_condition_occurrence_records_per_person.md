<!---
Group:condition occurrence
Name:CO17 Distribution of condition occurrence records per person
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO17: Distribution of condition occurrence records per person

## Description
This query is used to provide summary statistics for the number of condition occurrence records (condition_occurrence_id) for all persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. There is no input required for this query.

## Query
```sql
with ranked as
  (
  SELECT num_of_conditions, sum(1) over (partition by 1
  ORDER BY num_of_conditions asc rows BETWEEN unbounded preceding AND current row) AS rownumasc
  FROM (
                                    SELECT count(*) as num_of_conditions
                                    FROM condition_occurrence
                                    WHERE person_id!=0
                                    GROUP BY person_id
                            )
  ),
  other_stat AS
  (
   SELECT count(num_of_conditions) AS condition_num_count,
                    min(num_of_conditions) AS condition_num_min,
  max(num_of_conditions) AS condition_num_max,
                    avg(num_of_conditions) AS condition_num_averege,
  stddev(num_of_conditions) as condition_num_stddev
   FROM (
                               SELECT count(*) AS num_of_conditions, person_id
                               FROM   condition_occurrence
                               WHERE person_id!=0
                               GROUP BY person_id
                       )
  )
SELECT
 (
        SELECT count(distinct person_id)
        FROM condition_occurrence
        WHERE person_id!=0 AND condition_occurrence_id IS NULL
 ) AS condition_null_count,
 * FROM other_stat,
 (
  SELECT num_of_conditions AS condition_num_25percentile
  FROM (SELECT *,(SELECT count(*) FROM ranked) as rowno FROM ranked)
  WHERE (rownumasc=cast (rowno*0.25 as int) AND mod(rowno*25,100)=0) OR
     (rownumasc=cast (rowno*0.25 as int) AND mod(rowno*25,100)>0) OR
     (rownumasc=cast (rowno*0.25 as int)+1 AND mod(rowno*25,100)>0)
 ) AS condition_num_25percentile,
 (
  SELECT num_of_conditions AS condition_num_median
  FROM (SELECT *,(SELECT count(*) FROM ranked) AS rowno FROM ranked)
  WHERE (rownumasc=cast (rowno*0.50 AS int) AND mod(rowno*50,100)=0) OR
     (rownumasc=cast (rowno*0.50 AS int) AND mod(rowno*50,100)>0) OR
     (rownumasc=cast (rowno*0.50 AS int)+1 AND mod(rowno*50,100)>0)
 ) AS condition_num_median,
 (
  SELECT num_of_conditions AS condition_num_75percentile
  FROM (SELECT *,(SELECT count(*) FROM ranked) as rowno FROM ranked)
  WHERE (rownumasc=cast (rowno*0.75 as int) AND mod(rowno*75,100)=0) OR
     (rownumasc=cast (rowno*0.75 as int) AND mod(rowno*75,100)>0) OR
     (rownumasc=cast (rowno*0.75 as int)+1 AND mod(rowno*75,100)>0)
 ) AS condition_num_75percentile
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| condition_null_count | Number of persons with at least one null condition_occurrence_id |
| condition_num_count | Number of distinct persons with conditions |
| condition_num_min | The lowest number of condition occurences |
| condition_num_max | The highest number of condition occurences |
| condition_num_averege | The average number of condition occurences |
| condition_num_stddev | The standard deviation of condition occurence numbers |
| condition_num_25percentile | A condition occurence number where 25 percent of the other numbers are lower |
| condition_num_median | A condition occurence number where half of the other numbers are lower and half are higher |
| condition_num_75percentile | A condition occurence number where 75 percent of the other numbers are lower |

## Sample output record

|  Field |  Description |
| --- | --- |
| condition_null_count | 4395019 |
| condition_num_count |   |
| condition_num_min | 1 |
| condition_num_max | 7144 |
| condition_num_averege | 51 |
| condition_num_stddev | 86.63 |
| condition_num_25percentile | 11 |
| condition_num_median | 26 |
| condition_num_75percentile | 58 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
