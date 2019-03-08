<!---
Group:drug exposure
Name:DEX31 Distribution of drug exposure records per person
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX31: Distribution of drug exposure records per person

## Description
This query is used to provide summary statistics for the number of drug exposure records (drug_exposure_id) for all persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile and the maximum. There is no input required for this query.

## Input <None>
## Query
The following is a sample run of the query.

```sql
SELECT
    min(tt.stat_value) AS min_value,
    max(tt.stat_value) AS max_value,
    avg(tt.stat_value) AS avg_value,
    round(STDEV(tt.stat_value), 0) AS STDEV_value,
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY tt.stat_value) AS percentile_25,
    PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY tt.stat_value) AS median_value,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value) AS percentile_75
FROM (
   SELECT count(*) AS stat_value
   FROM @cdm.drug_exposure
   GROUP BY person_id
) tt
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
