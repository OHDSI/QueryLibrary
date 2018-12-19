<!---
Group:condition occurrence
Name:CO21 Distribution of age, stratified by condition
Author:Patrick Ryan
CDM Version: 5.0
-->

# CO21: Distribution of age, stratified by condition

## Description
This query is used to provide summary statistics for the age across all condition occurrence records stratified by condition (condition_concept_id): the mean, the standard deviation, the minimum, the 25th percentile, the median, the 75th percentile, the maximum and the number of missing values. The age value is defined by the earliest condition occurrence. The input to the query is a value (or a comma-separated list of values) of a condition_concept_id.

Oracle specific query.

## Query
```sql
SELECT concept_name AS condition
     , condition_concept_id
     , count(*) AS condition_occurrences
     , min( age ) over () AS min_age
     , max( age ) over () AS max_age
     , round( avg( age ), 2 ) AS avg_age
     , round( STDEV( age ) over (), 1 ) AS STDEV_age
     , PERCENTILE_DISC(0.25) WITHIN GROUP( ORDER BY age ) over ()
                                     AS percentile_25
     , PERCENTILE_DISC(0.5)  WITHIN GROUP (ORDER BY age ) over ()
                                     AS median_age
     , PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY age ) over ()
                                     AS percentile_75
  FROM -- condition occurrences with age at time of condition
     ( SELECT condition_concept_id
            , YEAR(condition_start_date ) AS age -- year_of_birth
         FROM @cdm.condition_occurrence
         JOIN @cdm.person USING( person_id )
        WHERE condition_concept_id
           IN -- all SNOMED codes for diabetes
            ( 192691, 193323, 194700, 195771, 200687, 201254,
         201530, 201531, 201820, 201826 , 318712, 373999,
         377821, 4008576, 4009780, 4024659, 4030061,
         4034960, 4034962, 4047906 , 40480000, 4048202,
         40482883, 40488810, 4058243, 4062685, 4062686,
         4062687, 4063042, 4063043 , 4079850, 4096041,
         4096042, 4096668, 4096670, 4096671, 4099214,
         4099215, 4099217, 4099334 , 4099651, 4099652,
         4099653, 4099741, 4102018, 4129378, 4129516,
         4129519, 4130162, 4130164 , 4130166, 4136889,
         4137214, 4140808, 4143529, 4143689, 4143857,
         4144583, 4145827, 4151281 , 4151282, 4152858,
         4155634, 4166381, 4178452, 4178790, 4192852,
         4193704, 4196141, 4198296 , 4200873, 4200875,
         4202383, 4212631, 4221344, 4222222, 4222410,
         4222547, 4222553, 4222687 , 4222834, 4223303,
         4223444, 4224254, 4224709, 4224723, 4225013,
         4225055, 4225656, 4226245 , 4227210, 4228102,
         4228112, 4230254, 4231917, 4235410, 4237068,
         4240589, 4245270, 4252384, 4263902, 4295011,
         4304377, 4312138, 4321756, 4322638, 4325113,
         4326434, 4327944, 435216 , 439770, 443012,
         443412, 443592
            )
     )
  JOIN @vocab.concept ON concept_id = condition_concept_id
GROUP BY concept_name, condition_concept_id, age
ORDER BY condition_occurrences DESC
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
| condition_concept_id list | 192691, 193323, 194700, 195771, 200687, 201254, 201530, 201531, 201820, 201826 , 318712, 373999, 377821, 4008576, 4009780, 4024659, 4030061, 4034960, 4034962, 4047906 , 40480000, 4048202, 40482883, 40488810, 4058243, 4062685, 4062686, 4062687, 4063042, 4063043 , 4079850, 4096041, 4096042, 4096668, 4096670, 4096671, 4099214, 4099215, 4099217, 4099334 , 4099651, 4099652, 4099653, 4099741, 4102018, 4129378, 4129516, 4129519, 4130162, 4130164 , 4130166, 4136889, 4137214, 4140808, 4143529, 4143689, 4143857, 4144583, 4145827, 4151281 , 4151282, 4152858, 4155634, 4166381, 4178452, 4178790, 4192852, 4193704, 4196141, 4198296 , 4200873, 4200875, 4202383, 4212631, 4221344, 4222222, 4222410, 4222547, 4222553, 4222687 , 4222834, 4223303, 4223444, 4224254, 4224709, 4224723, 4225013, 4225055, 4225656, 4226245 , 4227210, 4228102, 4228112, 4230254, 4231917, 4235410, 4237068, 4240589, 4245270, 4252384, 4263902, 4295011, 4304377, 4312138, 4321756, 4322638, 4325113, 4326434, 4327944, 435216 , 439770, 443012, 443412, 443592 | Yes | SNOMED condition concept identifiers for dia |

## Output

|  Field |  Description |
| --- | --- |
| condition | Name of the condition |
| condition_concept_id | Condition concept identifier |
| min_age | Minimum age of the people with condition |
| max_age | Maximum age of the people with condition |
| avg_age | Average age of the people with condition |
| STDEV_age | Standard deviation of the people  with condition |
| percentile_25 | Age 25th percentile of the people with condition |
| median_age | Median age  of the people with condition |
| percentile_75 | Age 75th percentile of the people with condition |

## Sample output record

|  Field |  Description |
| --- | --- |
| condition | Type 1 diabetes mellitus |
| condition_concept_id | 201826 |
| min_age | 2006 |
| max_age | 2017 |
| avg_age | 2014 |
| STDEV_age | 3.6 |
| percentile_25 | 2009 |
| median_age | 2013 |
| percentile_75 | 2015 |


## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
