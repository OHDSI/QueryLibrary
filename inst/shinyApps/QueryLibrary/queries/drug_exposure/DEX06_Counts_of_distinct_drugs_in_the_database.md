<!---
Group:drug exposure
Name:DEX06 Counts of distinct drugs in the database
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX06: Counts of distinct drugs in the database

## Description
| This query is used to determine the number of distinct drugs (drug_concept_id). See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values.

## Input None.

## Query
The following is a sample run of the query.  

```sql
SELECT 
count(distinct drug_concept_id) as number_drugs 
FROM 
drug_exposure JOIN concept 
ON concept_id = drug_concept_id 
WHERE 
lower(domain_id)='drug' and vocabulary_id='RxNorm' and standard_concept='S'; 
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| number_drugs | The count of distinct drug concepts. |

## Sample output record

|  Field |  Description |
| --- | --- | 
| number_drugs | 10889 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
