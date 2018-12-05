<!---
Group:condition occurrence combinations
Name:COC07 Patients with condition in conjunction with a procedure some number of days prior to or after initial condition.
Author:Patrick Ryan
CDM Version: 5.0
-->

# COC07: Patients with condition in conjunction with a procedure some number of days prior to or after initial condition.

## Description
Aplastic Anemia AND Occurrence of at least one diagnostic procedure code for bone marrow aspiration or biopsy within 60 days prior to the diagnostic code.
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_name | OMOP Aplastic Anemia 1 | Yes |   |
| list of procedure_concept_id | 2002382, 2002403, 2108452, 2108453, 2212660, 2212662, 3045142 , 3048879, 36359239, 37586183 |   | Bone marrow aspiration or biopsy |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  


```sql
SELECT DISTINCT    condition.person_id,
                procedure_date,
                condition_era_start_date
FROM
    procedure_occurrence proc
        JOIN    condition_era condition
                    ON condition.person_id = proc.person_id
        JOIN    
                (
                SELECT DISTINCT    descendant_concept_id
                FROM    relationship
                        JOIN    concept_relationship rel USING( relationship_id )
                        JOIN    concept concept1
                                    ON    concept1.concept_id = concept_id_1
                        JOIN    concept_ancestor
                                    ON    ancestor_concept_id = concept_id_2
                WHERE    relationship_name = 'HOI contains SNOMED (OMOP)'
                AND        concept1.concept_name = 'OMOP Aplastic Anemia 1'
                AND        sysdate BETWEEN rel.valid_start_date and rel.valid_end_date
                ) 
                    ON descendant_concept_id = condition_concept_id
WHERE
    proc.procedure_concept_id IN ( 2002382, 2002403, 2108452, 2108453, 2212660, 2212662, 3045142, 3048879, 36359239, 37586183 )
AND procedure_date BETWEEN condition_era_start_date - 60 AND condition_era_start_date;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| condition_concept_id | A foreign key that refers to a standard condition concept identifier in the vocabulary. |
| person_id |   |
| procedure_date |   |
| condition_era_start_date |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| person_id |   |
| procedure_date |   |
| condition_era_start_date |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
