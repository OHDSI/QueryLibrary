<!---
Group:drug exposure
Name:DEX34 Distribution of drug quantity
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX34: Distribution of drug quantity

## Description
This query is used to provide summary statistics for drug quantity (quantity) across all drug exposure records: 
the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, 
the maximum and the number of missing values. No input is required for this query.

## Input <None>
## Query

The following is a sample run of the query.

```sql
WITH positive_quantity AS 
  (
    SELECT quantity AS stat_value
    FROM @cdm.drug_exposure 
    where quantity > 0
  )
SELECT
    MIN(stat_value)                                           AS min_value,
    MAX(stat_value)                                           AS max_value,
    AVG(stat_value)                                           AS avg_value,
    ROUND(STDEV(stat_value))                                  AS STDEV_value,
    PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY stat_value)  AS percentile_25,
    PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY stat_value)  AS median_value,
    PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY stat_value)  AS percentile_75
FROM positive_quantity;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| min_value |  minimum quantity |
| max_value |  maximum quantity |
| avg_value | average quantity  |
| STDEV_value |  quantity standard deviation |
| percentile_25 | quantity 25th percentile  |
| median_value | quantity median  |
| percentile_75 | quantity 75th percentile  |

## Sample output record

|  Field |  Description |
| --- | --- |
| min_value | 0.14  |
| max_value |  16650 |
| avg_value | 254  |
| STDEV_value | 699  |
| percentile_25 |  29 |
| median_value | 98  |
| percentile_75 |  237 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/