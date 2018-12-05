<!---
Group:condition era
Name:CE09 Counts of condition record
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE09: Counts of condition record

## Description
This query is used to count conditions (condition_concept_id) across all condition era records. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id. If the input is omitted, all possible values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of condition_concept_id | 254761, 257011, 320128, 432867, 25297 | No |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT condition_concept_id, concept_name, count(*) records_count
  FROM condition_era
  JOIN concept ON concept_id = condition_concept_id
 WHERE condition_concept_id 
    IN /* top five condition concepts */
       ( 254761, 257011, 320128, 432867, 25297 )
 GROUP BY condition_concept_id, concept_name
 ORDER BY records_count DESC;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| count |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| condition_concept_id |   |
| count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
