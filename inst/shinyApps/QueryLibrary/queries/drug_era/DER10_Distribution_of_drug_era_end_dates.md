<!---
Group:drug era
Name:DER10 Distribution of drug era end dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER10: Distribution of drug era end dates

## Description
This query is used to to provide summary statistics for drug era end dates (drug_era_end_date) across all drug era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
SELECT DISTINCT min(tt.end_date) over () AS min_date
     , max(tt.end_date) over () AS max_date
     , dateadd(day, (avg(tt.end_date_num) over ()), tt.min_date) AS avg_date
     , round(STDEV(tt.end_date_num), 0) AS STDEV_days
     , dateadd(day, (PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY tt.end_date_num ) over ()), tt.min_date) AS percentile_25_date
     , dateadd(day, (PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY tt.end_date_num ) over ()), tt.min_date) AS median_date
     , dateadd(day, (PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.end_date_num ) over ()), tt.min_date) AS percential_75_date
  FROM
    ( SELECT datediff(day, (MIN(t.drug_era_end_date) OVER()), t.drug_era_end_date) AS end_date_num,
             t.drug_era_end_date AS end_date,
             MIN(t.drug_era_end_date) OVER() min_date
      FROM @cdm.drug_era t
    ) tt
        GROUP BY tt.min_date, tt.end_date, tt.end_date_num;

!!! Should be something like the query below but the results differ:
!!! The original returns one row but the new one many (percentiles differ per line). 

SELECT DISTINCT tt.min_date
,      tt.max_date
,      DATEADD(day, (AVG(tt.end_date_num) OVER ()), tt.min_date) AS avg_date
,      ROUND(STDEV(tt.end_date_num), 0) AS STDEV_days
,      DATEADD(day, MIN(CASE WHEN order_nr < .25 * population_size THEN 9999 ELSE tt.end_date_num END), tt.end_date) AS percentile_25_date
,      DATEADD(day, MIN(CASE WHEN order_nr < .50 * population_size THEN 9999 ELSE tt.end_date_num END), tt.end_date) AS median_date
,      DATEADD(day, MIN(CASE WHEN order_nr < .75 * population_size THEN 9999 ELSE tt.end_date_num END), tt.end_date) AS percentile_75_date
FROM
    (
        SELECT DATEDIFF(day, (MIN(t.drug_era_end_date) OVER()), t.drug_era_end_date) AS end_date_num
        ,      t.drug_era_end_date AS end_date
        ,      MIN(t.drug_era_end_date) OVER() AS min_date
        ,      MAX(t.drug_era_end_date) OVER () AS max_date
        ,      ROW_NUMBER() OVER (ORDER BY t.drug_era_end_date) order_nr
        ,      (SELECT COUNT(*) FROM @cdm.drug_era) AS population_size
        FROM @cdm.drug_era t
    ) tt
GROUP BY tt.min_date
,        tt.max_date
,        tt.end_date
,        tt.end_date_num;

```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| Min_date | Minimum drug era end date across all drug era records |
| Max_date | Maximum drug era end date across all drug era records |
| Avg_date | Average drug era end date across all drug era records |
| percentile_25_date | 25th percentile of the drug era end date |
| median_date | Median of the drug era end date |
| percentile_75_date | the 75th percentile of the drug era end date |

## Sample output record

|  Field |  Description |
| --- | --- |
| Min_date | 2006-01-01 00:00:00 |
| Max_date | 2017-09-30 00:00:00 |
| Avg_date | 2011-11-16 00:00:00 |
| percentile_25_date | 2008-12-08 00:00:00 |
| median_date | 2011-11-16 00:00:00 |
| percentile_75_date | 2014-10-24 00:00:00 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
