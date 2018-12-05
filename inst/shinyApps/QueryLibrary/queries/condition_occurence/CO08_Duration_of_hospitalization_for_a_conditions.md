<!---
Group:condition occurrence
Name:CO08 Duration of hospitalization for a conditions
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO08 :Duration of hospitalization for a conditions

## Description
Returns the the average length in days of all hospitalizations where a certain condition was reported

## Query
```sql
SELECT
  avg(hosp_no_days) AS average_hosp_duration_count
FROM (
  SELECT DISTINCT
    hosp_no_days,
    person_id,
    from_visit.visit_occurrence_id
  FROM (
    SELECT
      visit_occurrence_id, condition_start_date, condition_end_date, person_id
    FROM condition_occurrence
    WHERE
      condition_concept_id = 31967 AND
      visit_occurrence_id IS NOT NULL
  ) AS from_cond
  JOIN (
    SELECT
      DATEDIFF(DAY, visit_start_date, visit_end_date) + 1 AS hosp_no_days,
      visit_start_date,
      visit_occurrence_id,
      place_of_service_concept_id
    FROM visit_occurrence v
    JOIN care_site c on v.care_site_id=c.care_site_id
    WHERE place_of_service_concept_id = 8717
  ) AS from_visit
    ON from_cond.visit_occurrence_id = from_visit.visit_occurrence_id );
```



## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id | 31967 | Yes | Condition concept identifier for 'Nausea' |

## Output

|  Field |  Description |
| --- | --- |
| average_hosp_duration_count | Average length in days of all hospitalization where a certain condition was reported. +1 was added for partial days (e.g. 1.5 days were counted as 2 days). |

## Sample output record

| Field |  Description |
| --- | --- |
| average_hosp_duration_count | 7 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
