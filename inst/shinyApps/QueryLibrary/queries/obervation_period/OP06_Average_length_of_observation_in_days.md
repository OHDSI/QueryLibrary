<!---
Group:observation period
Name:OP06 Average length of observation, in days.
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP06: Average length of observation, in days.

## Description
Count average number of observation days.

## Query
```sql
SELECT avg( observation_period_end_date - observation_period_start_date ) AS num_days
FROM observation_period;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| num_days |  Average length of observation, in days |

## Sample output record

|  Field |  Value |
| --- | --- |
| num_days |  966 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
