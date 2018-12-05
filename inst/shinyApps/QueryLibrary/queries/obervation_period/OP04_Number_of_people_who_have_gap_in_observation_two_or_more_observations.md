<!---
Group:observation period
Name:OP04 Number of people who have gap in observation (two or more observations)
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP04: Number of people who have gap in observation (two or more observations)

## Description
Count number of people who have two or more observations.

## Query
```sql
SELECT count( person_id ) AS num_persons
FROM -- more than one observatio period
( SELECT person_id
FROM @cdm.observation_period GROUP BY person_id
HAVING COUNT( person_id ) > 1 );
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| num_persons |  Number of patients who have two or more observations |

## Sample output record

|  Field |  Value |
| --- | --- |
| num_persons |  18650793 |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
