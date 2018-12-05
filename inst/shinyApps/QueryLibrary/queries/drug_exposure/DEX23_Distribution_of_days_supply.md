<!---
Group:drug exposure
Name:DEX23 Distribution of days supply
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX23: Distribution of days supply

## Description
| This query is used to provide summary statistics for days supply (days_supply) across all drug exposure records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Input <None>

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT 
    min(tt.stat_value) AS min_value , 
    max(tt.stat_value) AS max_value , 
    avg(tt.stat_value) AS avg_value ,    
    (round(stdDev(tt.stat_value)) ) AS stdDev_value ,
    APPROXIMATE PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY tt.stat_value ) AS percentile_25 , 
    APPROXIMATE PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.stat_value ) AS median_value , 
    APPROXIMATE PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.stat_value ) AS percential_75 
FROM 
    ( SELECT t.days_supply AS stat_value FROM drug_exposure t where t.days_supply > 0 ) tt ;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| min_value |   |
| max_value |   |
| avg_value |   |
| stdDev_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |


## Sample output record

|  Field |  Description |
| --- | --- | 
| min_value |   |
| max_value |   |
| avg_value |   |
| stdDev_value |   |
| percentile_25 |   |
| median_value |   |
| percentile_75 |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
