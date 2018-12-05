<!---
Group:person
Name:PE07 Number of patients grouped by residence state location
Author:Patrick Ryan
CDM Version: 5.0
-->

# PE07: Number of patients grouped by residence state location

## Description
This query is used to count the locations (location_id) across all person records. All possible values for location are summarized.

## Query
```sql
SELECT NVL( state, 'XX' )
AS state_abbr, count(*) as Num_Persons_count
FROM person
LEFT OUTER JOIN location
USING( location_id )
GROUP BY NVL( state, 'XX' )
ORDER BY 1;
```

## Input

None

## Output

| Field |  Description |
| --- | --- |
| State | State of residence |
| Num_Persons_count | Number of patients in the dataset residing in specific state |

## Sample output record

| Field |  Value |
| --- | --- |
| State | MA |
| Num_Persons_count | 1196292 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
