<!---
Group:observation period
Name:OP19 Distribution of observation period length, stratified by age.
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP19: Distribution of observation period length, stratified by age.

## Description
This query is used to provide summary statistics for the observation period length across all observation period records stratified by age: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The length of an is defined as the difference between the start date and the end date. The age value is defined at the time of the observation date. All existing age values are summarized.

## Query
```sql
SELECT
  age,
  count(*) AS observation_periods_cnt ,
  min( period_length ) AS min_period ,
  max( period_length ) AS max_period ,
  round( avg( period_length ), 2 ) AS avg_period ,
  round( stdDev( period_length ), 1 ) AS stdDev_period ,
  percentile_25,
  median,
  percentile_75
FROM (
  SELECT
    person_id,
    age,
    period_length,
    PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY period_length ) over(partition by age) AS percentile_25 ,
    PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY period_length ) over(partition by age) AS median ,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY period_length ) over(partition by age) AS percentile_75
  FROM /* person, age */ (
    SELECT
      person_id ,
      extract( YEAR FROM first_observation_date ) - year_of_birth AS age
    FROM (
      SELECT
        person_id ,
        min( observation_period_start_date ) AS first_observation_date
      FROM @cdm.observation_period
      GROUP BY person_id
    )
    JOIN @cdm.person USING( person_id )
    WHERE year_of_birth IS NOT NULL
  )
  JOIN  (
    SELECT
      person_id ,
      observation_period_end_date - observation_period_start_date + 1 AS period_length
    FROM @cdm.observation_period
  ) USING( person_id )
)
GROUP BY
  age,
  percentile_25 ,
  median ,
  percentile_75;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| age | Stratification age |
| observation_period_cnt | Number of observation periods |
| min_period | Minimum number of observation periods grouped by age |
| max_period | Maximum number of observation periods grouped by age |
| avg_period | Average number of observation periods grouped by age |
| stdDev_period | Standard deviation of observation periods grouped by age |
| percentile_25 | 25th percentile of observation periods stratified by age |
| median | Median of observation periods stratified by age |
| percentile_75   | 75th percentile of observation periods stratified by age |

## Sample output record

|  Field |  Description |
| --- | --- |
| age |  1 |
| observation_period_cnt |  49990 |
| min_period |  1 |
| max_period |  2372 |
| avg_period |  571.28 |
| stdDev_period |  40.60 |
| percentile_25 |  365 |
| median |  366 |
| percentile_75   |  730 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
