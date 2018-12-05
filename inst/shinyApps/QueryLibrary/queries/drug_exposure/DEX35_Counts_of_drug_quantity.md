<!---
Group:drug exposure
Name:DEX35 Counts of drug quantity
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX35: Counts of drug quantity

## Description
This query is used to count the drug quantity (quantity) across all drug exposure records. The input to the query is a value (or a comma-separated list of values) of a quantity. If the input is omitted, all possible values are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| quantity (list of numbers) | 10,20 | Yes |  

## Query
The following is a sample run of the query. 

```sql
SELECT count(1) as drug_quantity_count, d.quantity
FROM drug_exposure d 
WHERE d.quantity in (10, 20) 
GROUP BY d.quantity ;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- | 
| drug_quantity_count |   |
| quantity | The quantity of drug as recorded in the original prescription or dispensing record. |

## Sample output record

|  Field |  Description |
| --- | --- | 
| drug_quantity_count |   |
| quantity |   |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
