<!---
Group:drug exposure
Name:DEX38 Counts of stop reasons
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX38: Counts of stop reasons

## Description
| This query is used to count stop reasons (stop_reason) across all drug exposure records. The input to the query is a value (or a comma-separated list of values) of a stop_reason. If the input is omitted, all existing values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| stop_reason | 1 | Yes |   


## Query

The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
select count(1) as totExp , d.stop_reason from @cdm.drug_exposure d 
where d.stop_reason in ('INVALID')
group by d.stop_reason ;
```

## Output


## Output field list

|  Field |  Description |
| --- | --- |
| Count | The number of individual drug exposure occurrences used to construct the drug era. |
| stop_reason | The reason the medication was stopped, where available. Reasons include regimen completed, changed, removed, etc. |


## Sample output record

|  Field |  Description |
| --- | --- |
| Count |   |
| stop_reason |   |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
