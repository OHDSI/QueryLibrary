<!---
Group:condition era
Name:CE10 Counts of persons with conditions
Author:Patrick Ryan
CDM Version: 5.3
-->

# CE10: Counts of persons with conditions

## Description
This query is used to count the persons with any number of eras of a certain condition (condition_concept_id). The input to the query is a value (or a comma-separated list of values) of a condition_concept_id. If the input is omitted, all possible values are summarized.

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
SELECT ce.condition_concept_id, c.concept_name, COUNT(DISTINCT person_id) AS num_people
  FROM @cdm.condition_era ce
  JOIN @vocab.concept c
    ON c.concept_id = ce.condition_concept_id
 WHERE ce.condition_concept_id
    IN /* top five condition concepts by number of people */
        ( 256723, 372906, 440377, 441202, 435371 )
 GROUP BY ce.condition_concept_id, c.concept_name
 ORDER BY num_people DESC;
```
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of condition_concept_id |  256723, 372906, 440377, 441202, 435371 | No |   |

## Output

|  Field |  Description |
| --- | --- |
| concept_name | An unambiguous, meaningful and descriptive name for the concept |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| num_people |   |

## Example output record

|  Field |  Description |
| --- | --- |
| concept_name |   |
| condition_concept_id |   |
| num_people |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
