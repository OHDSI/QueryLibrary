<!---
Group:drug exposure
Name:DEX22 How many poeple take a drug in a given class?
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX22: How many poeple take a drug in a given class?

## Description
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| ancestor_concept_id | 4324992 |  Yes | Antithrombins |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue. S

```sql
SELECT count(distinct d.person_id) as person_count FROM @vocab.concept_ancestor ca, @vocab.drug_exposure d 
WHERE
d.drug_concept_id = ca.descendant_concept_id
and ca.ancestor_concept_id = 4324992
group by ca.ancestor_concept_id ;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| person_count | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |

## Sample output record

|  Field |  Description |
| --- | --- |
| person_count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
