<!---
Group:condition era
Name:CE09 Counts of condition record
Author:Patrick Ryan
CDM Version: 5.3
-->

# CE09: Counts of condition record

## Description
This query is used to count conditions (condition_concept_id) across all condition era records. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id. If the input is omitted, all possible values are summarized.

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT ce.condition_concept_id, c.concept_name, COUNT(*) AS records_count
  FROM @cdm.condition_era ce
  JOIN @vocab.concept c
    ON c.concept_id = ce.condition_concept_id
 WHERE ce.condition_concept_id
    IN /* top five condition concepts */
       ( 256723, 372906, 440377, 441202, 435371 )
 GROUP BY ce.condition_concept_id, c.concept_name
 ORDER BY records_count DESC;
```
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of condition_concept_id | 256723, 372906, 440377, 441202, 435371 | No |   |

## Output

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| count |   |

## Example output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| condition_concept_id |   |
| count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
