<!---
Group:person
Name:PE06 Number of patients grouped by year of birth
Author:Patrick Ryan
CDM Version: 5.0
-->

# PE06: Number of patients grouped by year of birth

## Description
Counts the year of birth (year_of_birth) across all person records. All existing values for year of birth are summarized.

## Query
```sql
SELECT year_of_birth, COUNT(person_id) AS Num_Persons_count
FROM @cdm.person
GROUP BY year_of_birth
ORDER BY year_of_birth;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
|  year_of_birth |  Year of birth of the patient |
|  Num_Persons_count |  Number of patients in the dataset of specific year of birth |

## Sample output record

| Field |  Value |
| --- | --- |
|  year_of_birth |  1950 |
|  Num_Persons_count |  389019 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
