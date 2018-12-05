<!---
Group:observation period
Name:OP07 Distribution of age across all observation period records
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP07: Distribution of age across all observation period records

## Description
Count distribution of age across all observation period records:  the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
WITH t AS (
SELECT DISTINCT
              person_id, EXTRACT( YEAR FROM first_observation_date ) - year_of_birth AS age
         FROM -- person, first observation date
            ( SELECT person_id
                   , min( observation_period_start_date ) AS first_observation_date
                FROM observation_period
               GROUP BY person_id
            )
         JOIN person USING( person_id )
        WHERE year_of_birth IS NOT NULL
) SELECT count(*) AS num_people
     , min( age ) AS min_age
     , max( age ) AS max_age
     , round( avg( age ), 2 ) AS avg_age
     , round( stdDev( age ), 1 ) AS stdDev_age
     , (SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY age ) over () FROM t) AS percentile_25
     , (SELECT DISTINCT PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY age ) over () FROM t) AS median_age
     , (SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY age ) over () FROM t) AS percentile_75
        FROM t;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| num_people | Number of people in a dataset |
| min_age | Minimum age of person |
| max_age | Maximum age of a person |
| avg_age | Average age of people in the dataset |
| stdDev_age | Standard deviation of person age |
|  percentile_25 |  25th percentile of of the age group |
|  median_age |  50th percentile of the age group |
|  percentile_75 |  75th percentile of the age group |

## Sample output record

| Field |  Value |
| --- | --- |
| num_people | 151039265 |
| min_age |  0 |
| max_age |  85 |
| avg_age |  31 |
| stdDev_age |  19.4 |
| percentile_25 |  16 |
| median_age |  31 |
| percentile_75 |  47 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
