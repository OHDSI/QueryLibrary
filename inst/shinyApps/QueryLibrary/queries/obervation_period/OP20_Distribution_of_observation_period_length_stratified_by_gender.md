<!---
Group:observation period
Name:OP20 Distribution of observation period length, stratified by gender.
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP20: Distribution of observation period length, stratified by gender.

## Description
This query is used to provide summary statistics for the observation period length across all observation period records stratified by gender (gender_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The length of an is defined as the difference between the start date and the end date. All existing gender_concept_id values are summarized.

## Query
```sql
SELECT
  gender,
  COUNT(*)                                                   AS observation_periods_cnt,
  MIN(period_length)                                         AS min_period, 
  MAX(period_length)                                         AS max_period,
  ROUND(AVG( period_length ), 2)                             AS avg_period,
  ROUND(STDEV( period_length ), 1)                           AS STDEV_period,
  PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY period_length) AS percentile_25,
  PERCENTILE_DISC(0.5 ) WITHIN GROUP(ORDER BY period_length) AS median,
  PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY period_length) AS percentile_75
FROM 
  ( SELECT
      person_gender.person_id,
      gender,
      period_length
    FROM /* person, gender */ 
      ( SELECT
          person.person_id ,
          concept_name AS gender
        FROM 
          ( SELECT
              person_id,
              MIN(observation_period_start_date) AS first_observation_date
            FROM @cdm.observation_period
            GROUP BY person_id
          ) AS person_first_observation
    INNER JOIN @cdm.person 
    ON person_first_observation.person_id = person.person_id
    INNER JOIN @vocab.concept 
    ON concept.concept_id = person.gender_concept_id
    WHERE year_of_birth IS NOT NULL
      ) AS person_gender
    INNER JOIN 
      ( SELECT
          person_id,
          DATEDIFF(day,observation_period_start_date,observation_period_end_date) + 1 AS period_length
        FROM @cdm.observation_period
      ) AS person_period_length
    ON person_period_length.person_id = person_gender.person_id 
  ) AS w
GROUP BY gender;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| gender | Gender concept name |
| observations_period_cnt | Number of observation periods for specific gender |
| min_period | Minimum duration of observation period in days |
| max_period | Maximum duration of observation period in days |
| avg_period | Average duration of observation in days |
| STDEV_period | Standard deviation of observation |
| percentile_25 | 25th percentile of observation periods in days |
| median | Median of observation periods in days |
| percentile_75 | 75th percentile of observation periods in days |

## Sample output record

|  Field |  Description |
| --- | --- |
| gender |  MALE |
| observations_period_cnt |  1812743 |
| min_period |  1 |
| max_period |  2372 |
| avg_period |  653.77 |
| STDEV_period |  502.40 |
| percentile_25 |  365 |
| median |  457 |
| percentile_75 |  731 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
