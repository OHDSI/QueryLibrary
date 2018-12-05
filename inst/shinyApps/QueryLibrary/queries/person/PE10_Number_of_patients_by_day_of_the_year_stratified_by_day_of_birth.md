<!---
Group:person
Name:PE10 Number of patients by day of the year stratified by day of birth
Author:Patrick Ryan
CDM Version: 5.0
-->

# PE10: Number of patients by day of the year stratified by day of birth

## Description
This query is used to count the day of birth (day_of_birth) across all person records. All possible values for day of birth are summarized. Not all databases maintain day of birth. This query is only available from CDM V4 and above.

## Query
```sql
SELECT day_of_birth, COUNT(person_ID) AS num_persons
FROM @cdm.person
GROUP BY day_of_birth
ORDER BY day_of_birth;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| Day_Of_Year | Day of the year 1 through 365 |
| Num_Rows | Number of records |

## Sample output record

| Field |  Value |
| --- | --- |
| Day_Of_Year | 001 |
| Num_Rows | 34462921 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
