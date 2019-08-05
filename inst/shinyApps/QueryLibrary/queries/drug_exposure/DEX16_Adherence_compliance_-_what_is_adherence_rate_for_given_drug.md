<!---
Group:drug exposure
Name:DEX16 Adherence/compliance - what is adherence rate for given drug?
Author:Patrick Ryan
CDM Version: 5.3
-->

# DEX16: Adherence/compliance - what is adherence rate for given drug?

## Description
Define adherence as sum of days supply divided by length of treatment period.

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  S

```sql
WITH finasteride_users AS (
SELECT de.person_id, de.days_supply, de.drug_exposure_start_date, c.concept_name
  FROM @cdm.drug_exposure de
  JOIN @vocab.concept_ancestor ca
    ON ca.descendant_concept_id = de.drug_concept_id
  JOIN @vocab.concept c
    ON c.concept_id = ca.ancestor_concept_id
 WHERE LOWER(c.concept_class_id) = 'ingredient'
   AND ca.ancestor_concept_id = 996416
), era_data AS (
SELECT de.person_id,
       de.drug_concept_id AS ingredient_concept_id,
       fu.concept_name,
	   de.drug_era_start_date,
	   de.drug_era_end_date,
       DATEDIFF(d,de.drug_era_start_date,de.drug_era_end_date) AS treatment_length,
	   fu.drug_exposure_start_date,
	   fu.days_supply,
       SIGN(ISNULL(fu.days_supply,0)) has_days_supply
  FROM @cdm.drug_era de
  JOIN finasteride_users fu
    ON de.person_id = fu.person_id
   AND fu.drug_exposure_start_date >= de.drug_era_start_date
   AND fu.drug_exposure_start_date <= de.drug_era_end_date
 WHERE de.drug_concept_id = 996416
   AND SIGN(ISNULL(fu.days_supply,0)) > 0
   AND DATEDIFF(d,de.drug_era_start_date,de.drug_era_end_date) > 100   
)
SELECT concept_name,
       COUNT(*)              AS number_of_eras,
       AVG(treatment_length) AS average_treatment_length_count,
       AVG(adherence)        AS avgerage_adherence_count
  FROM (
SELECT person_id,
       concept_name,
	   drug_era_start_date,
	   SUM(days_supply) AS days_supply,
	   treatment_length,
       1.0*SUM(days_supply)/treatment_length AS adherence,
	   MIN(has_days_supply) AS has_days_supply	  
  FROM era_data
 GROUP BY person_id,concept_name,drug_era_start_date,treatment_length
       ) TMP
 GROUP BY concept_name;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| drug_concept_id | 996416 | Yes | Finasteride |

## Output

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

## Example output record

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
