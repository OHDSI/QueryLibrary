<!---
Group:drug exposure
Name:DEX16 Adherence/compliance - what is adherence rate for given drug?
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX16: Adherence/compliance - what is adherence rate for given drug?

## Description
Define adherence as sum of days supply divided by length of treatment period.

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- | 
| drug_concept_id | 996416 | Yes | Finasteride | 

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  S

```sql
SELECT concept_name, 
count(*) AS number_of_eras , 
avg( treatment_length ) AS average_treatment_length_count , 
avg(adherence) avgerage_adherence_count 
FROM
    ( SELECT person_id, concept_name, drug_era_start_date , sum( days_supply ), treatment_length , 
      sum( days_supply ) / treatment_length AS adherence , min( has_null_days_supply ) AS null_day_supply 
      FROM /* drug era and individual drug encounters making up the era */ 
        ( SELECT person_id, ingredient_concept_id , drug_era_start_date, drug_era_end_date , 
          drug_era_end_date - drug_era_start_date AS treatment_length , drug_exposure_start_date , days_supply , 
          DECODE( NVL( days_supply, 0 ), 0, 0, 1 ) has_null_days_supply 
          FROM /*drug era of people taking finasteride */ 
            ( SELECT person_id, drug_concept_id as ingredient_concept_id , drug_era_start_date, drug_era_end_date 
                FROM drug_era 
                --WHERE drug_concept_id = 996416 /* Finasteride */ 
                ) 
                JOIN /* drug exposures making up the era */ 
                ( SELECT person_id, days_supply, drug_exposure_start_date 
                    FROM drug_exposure 
                    JOIN concept_ancestor ON descendant_concept_id = drug_concept_id 
                    JOIN concept ON concept_id = ancestor_concept_id 
                    WHERE LOWER(concept_class_id) = 'ingredient' 
                    AND sysdate BETWEEN valid_start_date AND valid_end_date 
                    AND ancestor_concept_id = 996416 
                    /*Finasteride*/ ) USING( person_id ) 
            WHERE drug_exposure_start_date BETWEEN drug_era_start_date AND drug_era_end_date ) 
        JOIN concept ON concept_id = ingredient_concept_id 
    GROUP BY person_id, concept_name, drug_era_start_date, treatment_length ) 
WHERE treatment_length > 100 and null_day_supply > 0 
GROUP BY concept_name;
```

## Output


## Output field list

|  Field |  Description |
| --- | --- | 
| concept_name | An unambiguous, meaningful and descriptive name for the concept. |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| concept_class | The category or class of the concept along both the hierarchical tree as well as different domains within a vocabulary. Examples are "Clinical Drug", "Ingredient", "Clinical Finding" etc. |
| treatment_length |   |
| person_id | A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship. |
| drug_era_start_date | The start date for the drug era constructed from the individual instances of drug exposures. It is the start date of the very first chronologically recorded instance of utilization of a drug. |
| drug_exposure_start_date | The start date for the current instance of drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a drug administration procedure was recorded. |
| days_supply | The number of days of supply of the medication as recorded in the original prescription or dispensing record. |
| drug_era_end_date | The end date for the drug era constructed from the individual instance of drug exposures. It is the end date of the final continuously recorded instance of utilization of a drug. |
| ingredient_concept_id |   |
| ancestor_concept_id | A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship. |


## Sample output record

|  Field |  Description |
| --- | --- | 
| concept_name |   |
| drug_concept_id |   |
| concept_class |   |
| treatment_length |   |
| person_id |   |
| drug_era_start_date |   |
| drug_exposure_start_date |   |
| days_supply |   |
| drug_era_end_date |   |
| ingredient_concept_id |   |
| ancestor_concept_id |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
