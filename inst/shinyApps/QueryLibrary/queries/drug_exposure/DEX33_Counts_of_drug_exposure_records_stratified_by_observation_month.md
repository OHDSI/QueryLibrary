<!---
Group:drug exposure
Name:DEX33 Counts of drug exposure records stratified by observation month
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX33: Counts of drug exposure records stratified by observation month

## Description
| This query is used to count the drug exposure records stratified by observation month. The input to the query is a value (or a comma-separated list of values) of a month. If the input is omitted, all possible values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of month numbers | 3, 5 |  Yes |  

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
select MONTH(d.drug_exposure_start_date) month_num, COUNT(1) as exp_in_month_count
from @cdm.drug_exposure d 
where MONTH(d.drug_exposure_start_date) in (3, 5)
group by MONTH(d.drug_exposure_start_date) order by 1
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_exposure_start_date | The start date for the current instance of drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a drug administration procedure was recorded. |
| month |   |


## Sample output record

|  Field |  Description |
| --- | --- |
| drug_exposure_start_date |   |
| month |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
