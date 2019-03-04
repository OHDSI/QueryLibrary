<!---
Group:drug cost
Name:DRC07 Distribution of costs paid by payer.
Author:Patrick Ryan
CDM Version: 5.0
-->

# DRC07: Distribution of costs paid by payer.

## Description
This query is used to to provide summary statistics for costs paid by coinsurance (paid_coinsurance) across all drug cost records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
with tt as (
  SELECT t.paid_patient_coinsurance AS stat_value
  FROM @cdm.cost t
  where t.paid_patient_coinsurance > 0
)
SELECT
  min(tt.stat_value) AS min_value,
  max(tt.stat_value) AS max_value,
  avg(tt.stat_value) AS avg_value,
  (round(STDEV(tt.stat_value), 0) ) AS STDEV_value ,
  (select distinct PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY tt.stat_value) OVER() from tt) AS percentile_25,
  (select distinct PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS median_value,
  (select distinct PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value) OVER() from tt) AS percential_75
FROM
 tt;
```

## Input

None

## Output

|   |
| --- |
|  Field |  Description |
| min_value | The portion of the drug expenses due to the cost charged by the manufacturer for the drug, typically a percentage of the Average Wholesale Price. |
| max_value |   |
| avg_value |   |
| STDEV_value |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| min_value |   |
| max_value |   |
| avg_value |   |
| STDEV_value |   |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
