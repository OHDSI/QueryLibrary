<!---
Group:drug exposure
Name:DEX29 Distribution of number of distinct drugs persons take
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX29: Distribution of number of distinct drugs persons take

## Description
This query is used to provide summary statistics for the number of number of different distinct drugs (drug_concept_id) of all exposed persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile and the maximum. No input is required for this query.

## Input <None>
## Query

The following is a sample run of the query. The input parameters are highlighted in  blue

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
   SELECT count(DISTINCT t.drug_concept_id) AS stat_value
   FROM @cdm.drug_exposure t
   WHERE t.drug_concept_id > 0
   GROUP BY t.person_id
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
