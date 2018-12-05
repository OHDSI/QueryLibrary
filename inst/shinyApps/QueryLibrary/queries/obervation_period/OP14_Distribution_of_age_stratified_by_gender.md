<!---
Group:observation period
Name:OP14 Distribution of age, stratified by gender
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP14: Distribution of age, stratified by gender

## Description
This query is used to provide summary statistics for the age across all observation records stratified by gender (gender_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The age value is defined by the earliest observation date. Age is summarized for all existing gender_concept_id values.

## Query
```sql
WITH t AS /* person, gender, age */
     ( SELECT person_id, NVL( concept_name, 'MISSING' ) AS gender
            , extract( year FROM first_observation_date ) - year_of_birth AS age
         FROM -- person, first observation period date
            ( SELECT person_id
                   , min( observation_period_start_date ) AS first_observation_date
                FROM observation_period
               GROUP BY person_id
            )
         JOIN person USING( person_id )
         LEFT OUTER JOIN concept ON concept_id = gender_concept_id
        WHERE year_of_birth IS NOT NULL
     )
SELECT gender
     , count(*) AS num_people
     , min( age ) AS min_age
     , max( age ) AS max_age
     , round( avg( age ), 2 ) AS avg_age
     , round( stdDev( age ), 1 ) AS stdDev_age
     , (SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY age ) over ()
                                     AS percentile_25 FROM t)
     , (SELECT DISTINCT PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY age ) over ()
                                     AS median FROM t)
     , (SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY age ) over ()
                                     AS percential_75 FROM t)
  FROM t
GROUP BY gender
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
|  gender |  Gender concept name |
|  num_people |  Number of people with specific gender |
|  min_age |  Minimum age across observation of people with specific gender |
|  max_age |  Maximum age across observation of people with specific gender |
|  avg_age |  Average age across observation of people with specific gender |
|  stdDev_age |  Standard deviation of age across observation within specific gender |
|  percentile_25 |  25th percentile age across observation within specific gender |
|  median |  Median age across observation within specific gender |
|  percentile_75 |  75th percentile age across observation within specific gender |

## Sample output record

|  Field |  Description |
| --- | --- |
|  gender |  MALE |
|  num_people |  1607472 |
|  min_age |  0 |
|  max_age |  103 |
|  avg_age |  40.78 |
|  stdDev_age |  18.60 |
|  percentile_25 |  29 |
|  median |  45 |
|  percentile_75 |  55 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
