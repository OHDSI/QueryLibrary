<!---
Group:drug exposure
Name:DEX03 Distribution of age, stratified by drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# DEX03: Distribution of age, stratified by drug

## Description
| This query is used to provide summary statistics for the age across all drug exposure records stratified by drug (drug_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The age value is defined by the earliest exposure. The input to the query is a value (or a comma-separated list of values) of a drug_concept_id. See  [vocabulary queries](http://vocabqueries.omop.org/drug-queries) for obtaining valid drug_concept_id values. If the input is omitted, age is summarized for all existing drug_concept_id values.

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| drug_concept_id | 40165254, 40165258 | Yes | Crestor 20 and 40 mg tablets |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue.

```sql

SELECT concept_name AS drug_name,
	drug_concept_id,
	COUNT(*) AS patient_count,
	MIN(age) AS min,
	PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY age) AS percentile_25,
	ROUND(CAST(AVG(age) AS NUMERIC),2) AS mean,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY age) AS median,
	PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY age) AS percentile_75,
	MAX(age) AS max,
	ROUND(CAST(STDDEV(age) AS NUMERIC),1) AS STDEV
FROM /*person, first drug exposure date*/ (
	SELECT drug_concept_id,
		de.person_id,
		MIN(EXTRACT(YEAR FROM drug_exposure_start_date)) - year_of_birth AS age
	FROM five_three_plus.drug_exposure de
	INNER JOIN five_three_plus.person p ON de.person_id = p.person_id
	WHERE drug_concept_id IN /*crestor 20 and 40 mg tablets */ (40165254, 40165258)
	GROUP BY drug_concept_id,
		de.person_id,
		year_of_birth
	) EV
INNER JOIN five_three_plus.concept ON concept_id = drug_concept_id
WHERE domain_id = 'Drug'
	AND standard_concept = 'S'
GROUP BY concept_name,
	drug_concept_id;
```

## Output

## Output field list

|  Field |  Description |
| --- | --- |
| drug_name | An unambiguous, meaningful and descriptive name for the concept. |
| drug_concept_id | A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept. |
| patient_count | The count of patients taking the drug |
| min | The age of the youngest patient taking the drug |
| percentile_25 | The 25th age percentile |
| mean | The mean or average age of the patients taking the drug |
| median | The median age of the patients taking the drug |
| percentile_75 | The 75th age percentile |
| max  | The age of the oldest patient taking the drug |
| stddev | The standard deviation of the age distribution |


## Sample output record

|  Field |  Content |
| --- | --- |
| drug_name | Rosuvastatin calcium 20 MG Oral Tablet [Crestor] |
| drug_concept_id | 40165254 |
| patient_count | 30321 |
| min | 11 |
| percentile_25 | 49 |
| mean | 53.87 |
| median | 55 |
| percentile_75 | 60 |
| max | 93 |
| stddev | 8.8 |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
