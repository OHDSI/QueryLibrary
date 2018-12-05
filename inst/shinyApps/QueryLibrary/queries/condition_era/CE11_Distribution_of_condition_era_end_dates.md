<!---
Group:condition era
Name:CE11 Distribution of condition era end dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE11: Distribution of condition era end dates

## Description
This query is used to to provide summary statistics for condition era end dates (condition_era_end_date) across all condition era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Input <None>

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT condition_concept_id
     , min(condition_era_end_date)
     , max(condition_era_end_date)
     , to_date( round( avg( to_char( condition_era_end_date, 'J' ))), 'J')
     , round( stdDev( to_number( to_char( condition_era_end_date, 'J' ), 9999999 ))) AS std_dev_days
     , ( SELECT DISTINCT PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY condition_era_end_date ) over () 
     FROM condition_era) AS percentile_25
     , ( SELECT DISTINCT PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY condition_era_end_date ) over ()
     FROM condition_era) AS median
     , ( SELECT DISTINCT PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY condition_era_end_date ) over ()
     FROM condition_era) AS percentile_75
  FROM condition_era
 WHERE condition_concept_id IN( 254761, 257011, 320128, 432867, 25297 )
  GROUP BY condition_concept_id;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| min |   |
| max |   |
| avg |   |
| std_dev_days |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| condition_concept_id |   |
| min |   |
| max |   |
| avg |   |
| std_dev_days |   |
| percentile_25 |   |
| median |   |
| percentile_75 |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
