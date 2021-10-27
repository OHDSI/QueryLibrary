<!---
Group:condition occurrence combinations
Name:COC10 Lenght of condition as function of treatment
Author:Patrick Ryan
CDM Version: 5.3
-->

# COC10: Lenght of condition as function of treatment

## Description

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue  

```sql
SELECT treatment,
	count(*),
	min(condition_days) AS min,
	max(condition_days) AS max,
	avg(condition_days) AS avg_condition_days
FROM (
	SELECT CASE
			WHEN surgery = 1
				THEN 'surgery'
			WHEN drug = 1
				AND pt = 1
				THEN 'PT Rx'
			WHEN drug = 1
				THEN 'Rx Only'
			ELSE 'No Treatment'
			END AS treatment,
		condition_days
	FROM (
		SELECT person_id,
			diag_date,
			max(drug) AS drug,
			max(surgery) AS surgery,
			max(pt) AS PT,
			max(condition_days) AS condition_days
		FROM /* back pain and treatments over following 60 days */ (
			SELECT era.person_id,
				condition_era_start_date AS diag_date,
				datediff(day, condition_era_start_date, condition_era_end_date) AS condition_days,
				ISNULL(drug, 0) AS drug,
				ISNULL(surgery, 0) AS surgery,
				ISNULL(pt, 0) AS pt
			FROM @cdm.condition_era era
			INNER JOIN /* SNOMed codes for back pain */ (
				 SELECT DISTINCT ca.descendant_concept_id
            FROM @vocab.concept_ancestor ca JOIN
            ( SELECT cr.concept_id_2 AS target_concept_id
                FROM @vocab.concept_relationship cr
                JOIN @vocab.concept c1 ON cr.concept_id_1 = c1.concept_id
                JOIN @vocab.concept c2 ON cr.concept_id_2 = c2.concept_id
                WHERE cr.relationship_id = 'Maps to'
                AND c1.concept_code like '724%'
                AND c2.standard_concept = 'S'
                AND c1.vocabulary_id = 'ICD9CM'
                AND c2.vocabulary_id = 'SNOMED'
                AND cr.invalid_reason is null
            ) t ON ca.ancestor_concept_id = t.target_concept_id            
    				) conditions ON descendant_concept_id = condition_concept_id
			LEFT JOIN (
				SELECT person_id,
					procedure_date,
					1 AS surgery
				FROM @cdm.procedure_occurrence pr
				INNER JOIN @vocab.concept ON concept_id = procedure_concept_id
				WHERE vocabulary_id = 'CPT4'
					AND concept_code IN ('22851', '20936', '22612', '22523', '22630', '22614*', '22842', '22632', '20930', '22524', '27130', '22525')
				) surgery ON surgery.person_id = era.person_id
				AND surgery.procedure_date >= condition_era_start_date
				AND surgery.procedure_date <= DATEADD(day, 60, condition_era_start_date)
			LEFT JOIN (
				SELECT person_id,
					procedure_date AS drug_date,
					1 AS drug
				FROM @cdm.procedure_occurrence pr
				INNER JOIN @vocab.concept ON concept_id = procedure_concept_id
				WHERE vocabulary_id = 'CPT4'
					AND concept_code IN ('20610', '20552', '207096', '20553', '20550', '20605', '20551', '20600', '23350')

				UNION

				SELECT person_id,
					drug_era_start_date,
					1
				FROM @cdm.drug_era
				WHERE drug_concept_id IN (1125315, 778711, 1115008, 1177480, 1112807, 1506270)
				) drug ON drug.person_id = era.person_id
				AND drug.drug_date >= condition_era_start_date
				AND drug.drug_date <= DATEADD(day, 60, condition_era_start_date)
			LEFT JOIN (
				SELECT person_id,
					procedure_date AS pt_date,
					1 AS pt
				FROM @cdm.procedure_occurrence pr
				INNER JOIN @vocab.concept ON concept_id = procedure_concept_id
				WHERE vocabulary_id = 'CPT4'
					AND concept_code IN ('97001', '97140', '97002')

				UNION

				SELECT person_id,
					procedure_date AS pt_date,
					1 AS pt
				FROM @cdm.procedure_occurrence pr
				INNER JOIN @vocab.concept ON concept_id = procedure_concept_id
				WHERE vocabulary_id = 'HCPCS'
					AND concept_code = 'G0283'
				) pt ON pt.person_id = era.person_id
				AND pt.pt_date >= condition_era_start_date
				AND pt.pt_date <= DATEADD(day, 60, condition_era_start_date)
			) EV
		WHERE diag_date > DATEFROMPARTS(2011, 01, 01)
		GROUP BY person_id,
			diag_date
		) AE
	) CE
GROUP BY treatment
ORDER BY treatment;
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| concept_code | '22851','20936','22612','22523','22630','22614','22842' , '22632', '20930','22524','27130','22525' | Yes |   |
| concept_code | '20610','20552','207096','20553','20550','20605' | Yes |   |
| drug_concept_id | 1125315, 778711, 115008, 1177480, 1112807, 1506270 | Yes |   |
| concept_code | '97001', '97140', '97002' | Yes |   |
| concept_code | G0283 | Yes |   |

## Output

|  Field |  Description |
| --- | --- |
| treatment | The type of treatment |
| count | The number of treatments of that type |
| min | The minimum duration of the condition |
| max | The maximum duration of the condition |
| avg_condition_days | The average duration of the condition |

## Example output record

|  Field |  Description |
| --- | --- |
| treatment |   |
| count |   |
| min |   |
| max |   |
| avg_condition_days |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
