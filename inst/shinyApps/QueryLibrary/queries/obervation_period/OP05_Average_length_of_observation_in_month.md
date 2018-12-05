<!---
Group:observation period
Name:OP05 Average length of observation, in month.
Author:Patrick Ryan
CDM Version: 5.0
-->

# OP05: Average length of observation, in month.

## Description
Count average length of observation period in month.

## Query
```sql
SELECT avg(
datediff(month, observation_period_start_date , observation_period_end_date ) ) AS num_months
FROM observation_period;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| num_months |  Average length of observation, in month |

## Sample output record

|  Field |  Value |
| --- | --- |
| num_months |  30 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
