<!---
Group:person
Name:PE08 Number of patients grouped by zip code of residence
Author:Patrick Ryan
CDM Version: 5.0
-->

# PE08: Number of patients grouped by zip code of residence

## Description
Counts the patients' zip of their residence location across all person records. All possible values for zip are summarized. Zip code contains only the first 3 digits in most databases.

## Query
```sql
SELECT state, NVL( zip, '9999999' ) AS zip, count(*) Num_Persons_count
FROM person
LEFT OUTER JOIN location
USING( location_id )
GROUP BY state, NVL( zip, '9999999' )
ORDER BY 1, 2;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| State | State of residence |
| Zip | 3 digit zip code of residence |
| Num_Persons_count | Number of patients in the dataset residing in a specific zip code |

## Sample output record

| Field |  Value |
| --- | --- |
| State | MA |
| Zip | 019 |
| Num_Persons_count | 477825 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
