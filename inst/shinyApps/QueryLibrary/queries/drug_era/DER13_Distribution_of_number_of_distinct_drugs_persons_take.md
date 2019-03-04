<!---
Group:drug era
Name:DER13 Distribution of number of distinct drugs persons take
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER13: Distribution of number of distinct drugs persons take

## Description
This query is used to provide summary statistics for the number of number of different distinct drugs (drug_concept_id) of all exposed persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
with tt as (
  SELECT
    count(distinct t.drug_concept_id) AS stat_value
  FROM @cdm.drug_era t
  where ISNULL(t.drug_concept_id, 0) > 0
  group by t.person_id
)
SELECT
  min(tt.stat_value) AS min_value,
  max(tt.stat_value) AS max_value,
  avg(tt.stat_value) AS avg_value,
  round(STDEV(tt.stat_value), 0) AS STDEV_value ,
  (select distinct PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY tt.stat_value) OVER() from tt) AS percentile_25,
  (select distinct PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS median_value,
  (select distinct PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS percential_75
FROM tt
;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| Min_value | Minimum number of distinct drugs persons take |
| Max_value | Maximum number of distinct drugs persons take |
| Avg_value | Average number of distinct drugs persons take |
| Stdev_value | Standard deviation of drug era start date across all drug era records |
| percentile_25_date | 25th percentile number of distinct drugs persons take |
| median_date | Median number of distinct drugs persons take |
| percentile_75_date | the 75th percentile number of distinct drugs persons take |

## Sample output record

|  Field |  Description |
| --- | --- |
| Min_value | 1 |
| Max_value | 580 |
| Avg_value | 12 |
| Stdev_value | 17 |
| percentile_25_date | 3 |
| median_date | 6 |
| percentile_75_date | 16 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
