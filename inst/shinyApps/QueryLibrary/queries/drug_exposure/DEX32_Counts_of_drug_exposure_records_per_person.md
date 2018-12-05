<!---
Group:drug exposure
Name:DEX32 Counts of drug exposure records per person
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX32: Counts of drug exposure records per person

## Description
| This query is used to count the number of drug exposure records (drug_exposure_id) for all persons. The input to the query is a value (or a comma-separated list of values) for a number of records per person. If the input is omitted, all possible values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
| count | 3, 4 |  Yes |   

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  S

```sql
SELECT count(1) AS stat_value, person_id
FROM drug_exposure
group by person_id
having count(1) in (3,4);
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| person_id | A foreign key identifier to the person who is subjected to the drug. The demographic details of that person are stored in the person table. |
| count | The number of individual drug exposure occurrences used to construct the drug era. |


## Sample output record

|  Field |  Description |
| --- | --- | 
| person_id |   |
| count |   |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
