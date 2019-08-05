<!---
Group:drug exposure
Name:DEX29 Distribution of number of distinct drugs persons take
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX29: Distribution of number of distinct drugs persons take

## Description
This query is used to provide summary statistics for the number of number of different distinct drugs (drug_concept_id)
of all exposed persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile
 and the maximum. No input is required for this query.

## Query

The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT
    MIN(stat_value)                                                                    AS min_value,
    MAX(stat_value)                                                                    AS max_value,
    ROUND(AVG(stat_value), 1)                                                          AS avg_value,
    ROUND(STDEV(stat_value), 1)                                                        AS STDEV_value,
    MIN(CASE WHEN order_nr < .25 * population_size THEN 9999 ELSE stat_value END)      AS percentile_25,
    MIN(CASE WHEN order_nr < .50 * population_size THEN 9999 ELSE stat_value END)      AS median_value,
    MIN(CASE WHEN order_nr < .75 * population_size THEN 9999 ELSE stat_value END)      AS percentile_75

FROM (
  SELECT
    COUNT(DISTINCT drug_concept_id)                                 AS stat_value,
    ROW_NUMBER() OVER (ORDER BY count(DISTINCT drug_concept_id) )   AS order_nr,
    (SELECT COUNT(DISTINCT person_id) FROM @cdm.drug_exposure )     AS population_size
  FROM @cdm.drug_exposure
  GROUP BY person_id
) ordered_data;
```


## Input

 None

## Output

|  Field |  Description |
| --- | --- |
| min_value |   |
| max_value |   |
| avg_value |   |
| STDEV_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |

## Example output record

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
