<!---
Group:drug exposure
Name:DEX10 Other drugs (conmeds) patients exposed to a certain drug take over some time period
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX10: Other drugs (conmeds) patients exposed to a certain drug take over some time period

## Description
This query is used to establish the medication (conmeds) taken by patients who also are exposed to a certain drug in a given time period. The query returns the number of patients taking the drug at least once. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id and the time period. See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values.
## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| list of drug concept ids | 1336825, 19047763 | Yes | Bortezomib, Thalidomide 50 mg capsules |
| from_date | 01-jan-2008 | Yes |   |
| to_date | 31-dec-2009 | Yes |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.

```sql
SELECT concept_name, COUNT(1) as persons
FROM (
--Other drugs people are taking
  SELECT DISTINCT cohort.person_id, drug.drug_concept_id
  FROM (
  --person with specific drug in time frame
  SELECT DISTINCT person_id, drug_concept_id, from_date, to_date
  FROM @cdm.drug_exposure
  JOIN (
  --date range
  SELECT '01-jan-2008' AS from_date , '31-dec-2009' AS to_date )
  ON drug_exposure_start_date BETWEEN from_date AND to_date
  WHERE drug_concept_id IN /*bortezomib, Thalidomide 50 mg capsules */  (1336825, 19047763)
  ) cohort
  JOIN @cdm.drug_exposure drug
  ON drug.person_id = cohort.person_id
  AND drug.drug_concept_id != cohort.drug_concept_id
  AND drug.drug_exposure_start_date BETWEEN from_date AND to_date
  WHERE drug.drug_concept_id != 0 /* unmapped drug */
  )
JOIN @vocab.concept ON concept_id = drug_concept_id
GROUP By concept_name ORDER BY persons DESC;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_name | An unambiguous, meaningful and descriptive name for the conmeds. |
| persons | count of patients taking the drug at least once |


## Sample output record

| Field |  Value |
| --- | --- |
| drug_name | Dexamethasone 4 MG Oral Tablet |
| persons | 190 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
