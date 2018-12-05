<!---
Group:drug exposure
Name:DEX02 Counts of persons taking a drug, by age, gender, and year of exposure
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX02: Counts of persons taking a drug, by age, gender, and year of exposure

## Description
| This query is used to count the persons with exposure to a certain drug (drug_concept_id), grouped by age, gender, and year of exposure. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values. If the input is omitted, all drugs in the data table are summarized.

## Input

|  Parameter |  Example |  Mandatory |  Notes | 
| --- | --- | --- | --- |
| list of drug_concept_id | 40165254, 40165258 | No | Crestor 20 and 40 mg tablets | 

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue. s

```sql
select drug.concept_name, 
    EXTRACT( YEAR FROM drug_exposure_start_date ) as year_of_exposure,
    EXTRACT( YEAR FROM drug_exposure_start_date ) - year_of_birth as age , 
    gender.concept_name as gender,
    count(1) as num_persons
From
drug_exposure JOINperson USING( person_id ) 
join concept drug ON drug.concept_id = drug_concept_id 
JOINconcept gender ON gender.concept_id = gender_concept_id
where drug_concept_id IN ( 40165254, 40165258 ) 
GROUP by drug.concept_name, gender.concept_name, EXTRACT( YEAR FROM drug_exposure_start_date ),
EXTRACT( YEAR FROM drug_exposure_start_date ) - year_of_birth 
ORDER BY concept_name, year_of_exposure, age, gender
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
|  concept_name | An unambiguous, meaningful and descriptive name for the concept. |
|  year_of_exposure |   |
|  age | The age of the person at the time of exposure |
|  gender | The gender of the person. |
|  num_persons | The patient count |

## Sample output record

|  Field |  Content |
| --- | --- | 
| concept_name |  Rosuvastatin calcium 40 MG Oral Tablet [Crestor] |
| year_of_exposure |  2010 |
| age |  69 |
| gender |  Male |
| num_persons |  15 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
