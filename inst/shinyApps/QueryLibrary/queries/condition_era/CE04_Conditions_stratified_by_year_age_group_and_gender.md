<!---
Group:condition era
Name:CE04 Conditions, stratified by year, age group and gender
Author:Patrick Ryan
CDM Version: 5.0
-->

# CE04: Conditions, stratified by year, age group and gender

## Description
This query is used to count conditions (condition_concept_id) across all condition era records stratified by year, age group and gender (gender_concept_id). The age groups are calculated as 10 year age bands from the age of a person at the condition era start date. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id , year, age_group (10 year age band) and gender_concept_id. If the input is ommitted, all existing value combinations are summarized..

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id |   |   |   |
| gender_concept_id |   |   |   |
| gender_concept_id |   |   |   |
| age_group |   |   |   |

## Query
The following is a sample run of the query. The input parameters are highlighted in  blue

```sql
CREATE TEMP TABLE
    age_age_grp
(
    age INT,
    age_grp VARCHAR(100)
)
;
INSERT INTO
    age_age_grp
VALUES
(1, '0 to 9'),
(2, '0 to 9'),
(3, '0 to 9'),
(4, '0 to 9'),
(5, '0 to 9'),
(6, '0 to 9'),
(7, '0 to 9'),
(8, '0 to 9'),
(9, '0 to 9'),
(10, '10 to 19'),
(11, '10 to 19'),
(12, '10 to 19'),
(13, '10 to 19'),
(14, '10 to 19'),
(15, '10 to 19'),
(16, '10 to 19'),
(17, '10 to 19'),
(18, '10 to 19'),
(19, '10 to 19'),
(20, '20 to 29'),
(21, '20 to 29'),
(22, '20 to 29'),
(23, '20 to 29'),
(24, '20 to 29'),
(25, '20 to 29'),
(26, '20 to 29'),
(27, '20 to 29'),
(28, '20 to 29'),
(29, '20 to 29'),
(30, '30 to 39'),
(31, '30 to 39'),
(32, '30 to 39'),
(33, '30 to 39'),
(34, '30 to 39'),
(35, '30 to 39'),
(36, '30 to 39'),
(37, '30 to 39'),
(38, '30 to 39'),
(39, '30 to 39'),
(40, '40 to 49'),
(41, '40 to 49'),
(42, '40 to 49'),
(43, '40 to 49'),
(44, '40 to 49'),
(45, '40 to 49'),
(46, '40 to 49'),
(47, '40 to 49'),
(48, '40 to 49'),
(49, '40 to 49'),
(50, '50 to 59'),
(51, '50 to 59'),
(52, '50 to 59'),
(53, '50 to 59'),
(54, '50 to 59'),
(55, '50 to 59'),
(56, '50 to 59'),
(57, '50 to 59'),
(58, '50 to 59'),
(59, '50 to 59'),
(60, '60 to 69'),
(61, '60 to 69'),
(62, '60 to 69'),
(63, '60 to 69'),
(64, '60 to 69'),
(65, '60 to 69'),
(66, '60 to 69'),
(67, '60 to 69'),
(68, '60 to 69'),
(69, '60 to 69'),
(70, '70 to 79'),
(71, '70 to 79'),
(72, '70 to 79'),
(73, '70 to 79'),
(74, '70 to 79'),
(75, '70 to 79'),
(76, '70 to 79'),
(77, '70 to 79'),
(78, '70 to 79'),
(79, '70 to 79'),
(80, '80 to 89'),
(81, '80 to 89'),
(82, '80 to 89'),
(83, '80 to 89'),
(84, '80 to 89'),
(85, '80 to 89'),
(86, '80 to 89'),
(87, '80 to 89'),
(88, '80 to 89'),
(89, '80 to 89'),
(90, '90 to 99'),
(91, '90 to 99'),
(92, '90 to 99'),
(93, '90 to 99'),
(94, '90 to 99'),
(95, '90 to 99'),
(96, '90 to 99'),
(97, '90 to 99'),
(98, '90 to 99'),
(99, '90 to 99'),
(100, '100 to 109'),
(101, '100 to 109'),
(102, '100 to 109'),
(103, '100 to 109'),
(104, '100 to 109'),
(105, '100 to 109'),
(106, '100 to 109'),
(107, '100 to 109'),
(108, '100 to 109'),
(109, '100 to 109'),
(110, '110 to 119'),
(111, '110 to 119'),
(112, '110 to 119'),
(113, '110 to 119'),
(114, '110 to 119'),
(115, '110 to 119'),
(116, '110 to 119'),
(117, '110 to 119'),
(118, '110 to 119'),
(119, '110 to 119')
;
SELECT
    condition,
    year,
    age_grp,
    gender,
    count(*)
FROM
    (
    SELECT
        person.person_id ,
        cond_name.concept_name AS condition ,
        EXTRACT( YEAR FROM condition_era_start_date ) AS year ,
        gender.concept_name As GENDER ,
        EXTRACT( YEAR FROM condition_era_start_date ) - year_of_birth AS age ,
        age_grp
        FROM @cdm.condition_era condition
            JOIN @vocab.concept cond_name
                ON cond_name.concept_id = condition_concept_id
            JOIN @cdm.person person
                ON person.person_id = condition.person_id
            JOIN @vocab.concept gender
                ON gender.concept_id = 8507
            JOIN age_age_grp
                ON age = EXTRACT( YEAR FROM CONDITION_ERA_START_DATE ) - year_of_birth 
    )
GROUP BY
    condition,
    year,
    age_grp,
    gender
ORDER BY
    condition,
    year,
    age_grp,
    gender;
```



## Output

## Output field list

|  Field |  Description |
| --- | --- |
| condition |   |
| year |   |
| age_grp |   |
| gender |   |
| count |   |

## Sample output record

|  Field |  Description |
| --- | --- |
| condition |   |
| year |   |
| age_grp |   |
| gender |   |
| count |   |

## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
