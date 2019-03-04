<!---
Group:drug era
Name:DER15 Distribution of drug era records per person
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER15: Distribution of drug era records per person

## Description
This query is used to provide summary statistics for the number of drug era records (drug_era_id) for all persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. There is no input required for this query.

## Query
```sql
with tt as
(
  SELECT count(1) AS stat_value
  FROM @cdm.drug_era t
  group by t.person_id
)
SELECT
  min(tt.stat_value) AS min_value ,
  max(tt.stat_value) AS max_value ,
  avg(tt.stat_value) AS avg_value ,
  round(STDEV(tt.stat_value), 0) AS STDEV_value,
  (select distinct PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS percentile_25,
  (select distinct PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS median_value,
  (select distinct PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS percential_75
FROM tt;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| Min_value | Minimum number of drug era records for all persons |
| Max_value | Maximum number of drug era records for all persons |
| Avg_value | Average number of drug era records for all persons |
| Stdev_value | Standard deviation of drug era record count across all drug era records |
| percentile_25_date | 25th percentile number of drug era record count for all persons |
| median_date | Median number of drug era record for all persons |
| percentile_75_date | the 75th percentile number of drug era record for all persons |

## Sample output record

|  Field |  Description |
| --- | --- |
| Min_value | 1 |
| Max_value | 1908 |
| Avg_value | 23 |
| Stdev_value | 47 |
| percentile_25_date | 3 |
| median_date | 7 |
| percentile_75_date | 22 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
