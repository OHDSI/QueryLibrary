<!---
Group:drug exposure
Name:DEX29 Distribution of number of distinct drugs persons take
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX29: Distribution of number of distinct drugs persons take

## Description
| This query is used to provide summary statistics for the number of number of different distinct drugs (drug_concept_id) of all exposed persons: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Input <None>
## Query

The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT
     min(tt.stat_value) AS min_value ,
    max(tt.stat_value) AS max_value ,
    avg(tt.stat_value) AS avg_value ,
    (round(STDEV(tt.stat_value)) ) AS STDEV_value ,
    APPROXIMATE PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY tt.stat_value ) AS percentile_25 ,
    APPROXIMATE PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.stat_value ) AS median_value ,
    APPROXIMATE PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value ) AS percential_75
FROM (
        SELECT count(distinct t.drug_concept_id) AS stat_value
        FROM @cdm.drug_exposure t 
         where ISNULL(t.drug_concept_id, 0) > 0
        group by t.person_id ) tt ;
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
