<!---
Group:payer plan
Name:PP02 Patient distribution by plan type
Author:Patrick Ryan
CDM Version: 5.0
-->

# PP02: Patient distribution by plan type

## Description
## Query
```sql
select
  t.plan_source_value,
  t.pat_cnt as num_patients,
  100.00*t.pat_cnt/ (sum(t.pat_cnt) over()) perc_of_total_count
from (
  select p.plan_source_value, count(1) as pat_cnt
  from payer_plan_period p
  group by p.plan_source_value
) t
order by t.plan_source_value;
```

## Input

None

## Output

|  Field |  Description |
| --- | --- |
| plan_source_value | The source code for the person's coverage plan as it appears in the source data. |
| num_patients | Number of patients |
| perc_of_total_count | Total count |

## Sample output record

|  Field |  Value |
| --- | --- |
| plan_source_value | Preferred Provider Organization |
| num_patients | 148348803 |
| perc_of_total_count | 68.632428630338134 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
