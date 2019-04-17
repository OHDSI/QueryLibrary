<!---
Group:drug era
Name:DER11 Distribution of drug era start dates
Author:Patrick Ryan
CDM Version: 5.0
-->

# DER11: Distribution of drug era start dates

## Description
This query is used to to provide summary statistics for drug era start dates (drug_era_start_date) across all drug era records: the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. No input is required for this query.

## Query
```sql
SELECT distinct min(tt.start_date) over () AS min_date
,      max(tt.start_date) over () AS max_date
,      dateadd(day, avg(tt.start_date_num) over (), tt.min_date) AS avg_date
,      round(STDEV(tt.start_date_num) over (),0) AS STDEV_days
,      dateadd(day, (PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY tt.start_date_num ) over ()), tt.min_date) AS percentile_25_date
,      dateadd(day, (PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY tt.start_date_num ) over()), tt.min_date) AS median_date
,      dateadd(day, (PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY tt.start_date_num ) over()), tt.min_date) AS percential_75_date
FROM (
       SELECT datediff(day, MIN(t.drug_era_start_date) OVER(), t.drug_era_start_date) AS start_date_num
       ,      t.drug_era_start_date AS start_date
       ,      MIN(t.drug_era_start_date) OVER() min_date
       FROM @cdm.drug_era t
) tt
GROUP BY tt.start_date, tt.start_date_num, tt.min_date;

!!! Should be something like the query below but the results differ:
!!! The original returns one row but the new one many (percentiles differ per line). 

SELECT DISTINCT tt.min_date
,      tt.max_date
,      DATEADD(day, AVG(tt.start_date_num) OVER (), tt.min_date) AS avg_date
,      ROUND(STDEV(tt.start_date_num) OVER (),0) AS STDEV_days
,      DATEADD(day, MIN(CASE WHEN order_nr < .25 * population_size THEN 9999 ELSE tt.start_date_num END), tt.start_date) AS percentile_25
,      DATEADD(day, MIN(CASE WHEN order_nr < .50 * population_size THEN 9999 ELSE tt.start_date_num END), tt.start_date) AS median_value
,      DATEADD(day, MIN(CASE WHEN order_nr < .75 * population_size THEN 9999 ELSE tt.start_date_num END), tt.start_date) AS percentile_75
FROM (
       SELECT DATEDIFF(day, MIN(t.drug_era_start_date) OVER(), t.drug_era_start_date) AS start_date_num
       ,      t.drug_era_start_date AS start_date
       ,      MIN(t.drug_era_start_date) OVER() min_date
       ,      MAX(t.drug_era_start_date) OVER() max_date
       ,      ROW_NUMBER() OVER (ORDER BY t.drug_era_start_date) order_nr
       ,      (SELECT COUNT(*) FROM @cdm.drug_era) AS population_size
       FROM @cdm.drug_era t
) tt
GROUP BY tt.start_date
,        tt.start_date_num
,        tt.min_date
,        tt.max_date;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- | 
| Min_date | Minimum drug era start date across all drug era records |
| Max_date | Maximum drug era start date across all drug era records |
| Avg_date | Average drug era start date across all drug era records |
| Stddev_days | Standard deviation of drug era start date across all drug era records |
| percentile_25_date | 25th percentile of the drug era start date |
| median_date | Median of the drug era start date |
| percentile_75_date | the 75th percentile of the drug era start date |

## Sample output record

|  Field |  Description |
| --- | --- |
| Min_date | 1997-01-01 00:00:00 |
| Max_date | 2017-12-31 00:00:00 |
| Avg_date | 2007-07-02 00:00:00 |
| Stddev_days | 2214 |
| percentile_25_date | 2002-04-02 00:00:00 |
| median_date | 2007-07-02 00:00:00 |
| percentile_75_date | 2012-10-01 00:00:00 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
