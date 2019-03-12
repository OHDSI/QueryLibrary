<!---
Group:drug exposure
Name:DEX23 Distribution of days supply
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX23: Distribution of days supply

## Description
| This query is used to provide summary statistics for days supply (days_supply) across drug exposure records for a given year, month: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Input <None>

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
-- PERCENTILE_DISC performs dismally on pdw for large tables,
-- additionally, it doesn't function as an aggregate so it needs to run separately.
-- Limiting to a particular year and month, makes the performance tolerable (~30s)
WITH percentiles AS (
SELECT DISTINCT 
       PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY days_supply) OVER() AS percentile_25,
       PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY days_supply) OVER() AS median_value,
       PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY days_supply) OVER() AS percential_75
  FROM @cdm.drug_exposure 
 WHERE days_supply > 0 
   AND YEAR(drug_exposure_start_date)  = 2010
   AND MONTH(drug_exposure_start_date) = 12 
), de AS (
SELECT MIN(days_supply) AS min_value,
       MAX(days_supply) AS max_value,
       ROUND(AVG(1.0*days_supply),0) AS avg_value,    
       ROUND(STDEV(days_supply),0)   AS stdev_value 
  FROM @cdm.drug_exposure
 WHERE days_supply > 0
   AND YEAR(drug_exposure_start_date)  = 2010
   AND MONTH(drug_exposure_start_date) = 12 
)
SELECT de.*, p.*
  FROM percentiles p
 CROSS JOIN de;
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
