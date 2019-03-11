<!---
Group:drug exposure
Name:DEX36 Distribution of drug refills
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX36: Distribution of drug refills

## Description
This query is used to provide summary statistics for drug refills (refills) across all drug exposure records: 
the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, 
the maximum and the number of missing values. No input is required for this query.

## Input 
None 

## Query
The following is a sample run of the query.

```sql
WITH pos_refills AS 
  (SELECT
        refills AS stat_value
    FROM @cdm.drug_exposure
    WHERE refills > 0
   )
SELECT
    MIN(stat_value)                                           AS min_value,
    MAX(stat_value)                                           AS max_value,
    AVG(stat_value)                                           AS avg_value,
    ROUND(STDEV(stat_value))                                  AS STDEV_value,
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY stat_value)  AS percentile_25,
    PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY stat_value)  AS median_value,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY stat_value)  AS percentile_75
FROM pos_refills;
```

## Output

|  Field |  Description |
| --- | --- |
| min_value | Minimum refill value |
| max_value |  Maximum refill value |
| avg_value |  Average refill value |
| STDEV_value |  Standard deviation refill value |
| percentile_25 |   |
| median_value |   |
| percentile_75 |  |

## Sample output record

|  Field |  Description |
| --- | --- |
| min_value | 1  |
| max_value |  25 |
| avg_value |  3.74 |
| STDEV_value |  3 |
| percentile_25 | 2  |
| median_value |  3 |
| percentile_75 |  5 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
