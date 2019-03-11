<!---
Group:drug exposure
Name:DEX27 Distribution of drug exposure start dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX27: Distribution of drug exposure start dates

## Description
This query is used to to provide summary statistics for drug exposure start dates (drug_exposure_start_date) across all drug exposure records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile and the maximum. No input is required for this query.

## Input <None>
## Query
The following is a sample run of the query.  

```sql
SELECT
  min(tt.start_date)                                                                        AS min_date,
  max(tt.start_date)                                                                        AS max_date,
  dateadd(dd, avg(tt.start_date_num), tt.min_date)                                          AS avg_date,
  round(STDEV(tt.start_date_num), 0)                                                        AS stdev_days,
  dateadd(dd, PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY tt.start_date_num), tt.min_date) AS percentile_25_date,
  dateadd(dd, PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY tt.start_date_num), tt.min_date) AS median_date,
  dateadd(dd, PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.start_date_num), tt.min_date) AS percentile_75_date
FROM (
       SELECT
         (t.drug_exposure_start_date - MIN(t.drug_exposure_start_date) OVER ()) AS start_date_num,
         t.drug_exposure_start_date                                             AS start_date,
         MIN(t.drug_exposure_start_date) OVER ()                                AS min_date
       FROM @cdm.drug_exposure t
     ) tt
GROUP BY tt.min_date
;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| min_value |   |
| max_value |   |
| avg_value |   |
| STDEV_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| min_value |   |
| max_value |   |
| avg_value |   |
| STDEV_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
