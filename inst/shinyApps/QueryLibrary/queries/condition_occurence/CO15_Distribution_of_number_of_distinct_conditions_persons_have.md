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
WITH ranked AS 
  (SELECT
    num_of_conditions,
    row_number() over (ORDER BY num_of_conditions ASC) AS rownumasc
  FROM 
    (SELECT
      person_id,
      COUNT(DISTINCT condition_concept_id) AS num_of_conditions
     FROM @cdm.condition_occurrence
     WHERE person_id!=0
     GROUP BY person_id
    ) AS counts_conditions_person_1
  ),
  other_stat AS 
  (SELECT
    COUNT(num_of_conditions) AS condition_dist_num_count,
    MIN(num_of_conditions) AS condition_dist_num_min,
    MAX(num_of_conditions) AS condition_dist_num_max,
    AVG(num_of_conditions) AS condition_dist_num_averege,
    stddev(num_of_conditions) AS condition_dist_num_stddev
   FROM 
    (SELECT
      person_id,
      COUNT(DISTINCT condition_concept_id) AS num_of_conditions
     FROM @cdm.condition_occurrence
     WHERE person_id!=0
     GROUP BY person_id
    ) AS counts_conditions_person_2
  )
  
SELECT
  (SELECT 
    COUNT(DISTINCT person_id) 
   FROM @cdm.condition_occurrence 
   WHERE person_id!=0 AND condition_occurrence_id IS NULL
  ) AS condition_null_count,
  *
FROM
  other_stat,
  (SELECT 
    DISTINCT num_of_conditions AS condition_dist_num_25percentile
    FROM
      (SELECT *,(SELECT COUNT(*) FROM ranked) AS rowno FROM ranked) AS a_1
    WHERE (rownumasc=CAST (rowno*0.25 AS INT) AND mod(rowno*25,100)=0)
          OR (rownumasc=CAST (rowno*0.25 AS INT) AND mod(rowno*25,100)>0)
          OR (rownumasc=CAST (rowno*0.25 AS INT)+1 AND mod(rowno*25,100)>0)
  ) AS condition_end_date_25percentile,
  (SELECT
    DISTINCT num_of_conditions AS condition_dist_num_median
   FROM
      (SELECT *,(SELECT COUNT(*) FROM ranked) AS rowno FROM ranked) AS a_2
   WHERE (rownumasc=cast (rowno*0.50 AS INT) AND mod(rowno*50,100)=0)
         OR (rownumasc=cast (rowno*0.50 AS INT) AND mod(rowno*50,100)>0)
         OR (rownumasc=cast (rowno*0.50 AS INT)+1 AND mod(rowno*50,100)>0)
  ) AS condition_end_date_median,
  (SELECT
    DISTINCT num_of_conditions AS condition_dist_num_75percentile
   FROM
      (SELECT *,(SELECT COUNT(*) FROM ranked) AS rowno FROM ranked) AS A_3
   WHERE (rownumasc=cast (rowno*0.75 AS INT) AND mod(rowno*75,100)=0) 
         OR (rownumasc=cast (rowno*0.75 AS INT) AND mod(rowno*75,100)>0)
         OR (rownumasc=cast (rowno*0.75 AS INT)+1 AND mod(rowno*75,100)>0)
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
