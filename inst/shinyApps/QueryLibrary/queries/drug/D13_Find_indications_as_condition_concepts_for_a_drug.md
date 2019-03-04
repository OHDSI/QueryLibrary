<!---
Group:drug
Name:D13 Find indications as condition concepts for a drug
Author:Patrick Ryan
CDM Version: 5.0
-->

# D13: Find indications as condition concepts for a drug

## Description
This query accepts a mapped drug code instead of a standard drug concept ID as the input. The result set from the returns detailed of indications associated with the drug.

## Query
```sql
SELECT
  rn.relationship_name as type_of_indication,
  c.concept_id as indication_concept_id,
  c.concept_name as indication_concept_name,
  c.vocabulary_id as indication_vocabulary_id,
  vn.vocabulary_name as indication_vocabulary_name
FROM
  @vocab.concept c,
  @vocab.vocabulary vn,
  @vocab.relationship rn,
  ( -- collect all indications from the drugs, ingredients and pharmaceutical preps and the type of relationship
    SELECT DISTINCT
      r.relationship_id rid,
      r.concept_id_2 cid
    FROM @vocab.concept c
    INNER JOIN ( -- collect onesie clinical and branded drug if query is ingredient
      SELECT onesie.cid concept_id
      FROM (
        SELECT
          a.descendant_concept_id cid,
          count(*) cnt
        FROM @vocab.concept_ancestor a
        INNER JOIN (
          SELECT c.concept_id
          FROM
            @vocab.concept c,
            @vocab.concept_ancestor a
          WHERE
            a.ancestor_concept_id=19005968 AND
            a.descendant_concept_id=c.concept_id AND
            c.vocabulary_id='RxNorm'
        ) cd on cd.concept_id=a.descendant_concept_id
        INNER JOIN @vocab.concept c on c.concept_id=a.ancestor_concept_id
        WHERE c.concept_level=2
        GROUP BY a.descendant_concept_id
      ) onesie
      where onesie.cnt=1
      UNION -- collect ingredient if query is clinical and branded drug
      SELECT c.concept_id
      FROM
        @vocab.concept c,
        @vocab.concept_ancestor a
      WHERE
        a.descendant_concept_id=19005968 AND
        a.ancestor_concept_id=c.concept_id AND
        c.vocabulary_id='RxNorm'
      UNION -- collect pharmaceutical preparation equivalent to which NDFRT has reltionship
      SELECT c.concept_id
      FROM
        @vocab.concept c,
        @vocab.concept_ancestor a
      WHERE
        a.descendant_concept_id=19005968 AND
        a.ancestor_concept_id=c.concept_id AND
        lower(c.concept_class)='pharmaceutical preparations'
      UNION -- collect itself
      SELECT 19005968
    ) drug ON drug.concept_id=c.concept_id
    INNER JOIN @vocab.concept_relationship r on c.concept_id=r.concept_id_1 -- allow only indication relationships
    WHERE
      -- v4: r.relationship_id IN (21,23,155,156,126,127,240,241)
      r.relationship_id IN (
         'May treat',
         'May prevent',
         'May be treated by',
         'CI by',
         'Has FDA-appr ind',
         'Has off-label ind',
         'Is FDA-appr ind of',
         'Is off-label ind of')
  ) ind
  INNER JOIN @vocab.concept_relationship r ON r.concept_id_1=ind.cid
  WHERE
    r.concept_id_2=c.concept_id AND
    -- r.relationship_id in (247, 248) AND
    r.relationship_id in (
       'Ind/CI - SNOMED',
       'SNOMED - ind/CI') AND
    ind.rid=rn.relationship_id AND
    vn.vocabulary_id=c.vocabulary_id AND
    (getdate() >= c.valid_start_date) AND (getdate() <= c.valid_end_date);
```

## Input

|  Parameter |  Example |  Mandatory |  Notes |
| --- | --- | --- | --- |
|   Drug Concept ID |   19005968 |  Yes | Drugs concepts from RxNorm with a concept class of 'Branded Drug' |
|  As of date |  Sysdate |  No | Valid record as of specific date. Current date – sysdate is a default |

## Output

|  Field |  Description |
| --- | --- |
|  Type_of_Indication |  Type of indication, indicating one of the following:
- FDA approved/off-label indication
- Treatment/prevention indication
 |
|  Indication_Concept_ID |  Concept ID of the therapeutic class |
|  Indication_Concept_Name |  Name of the Indication concept |
|  Indication_Vocabulary_ID |  Vocabulary the indication is derived from, expressed as vocabulary ID |
|  Indication_Vocabulary_Name |  Name of the vocabulary the indication is derived from |

## Sample output record

|  Field |  Value |
| --- | --- |
|  Type_of_Indication |  Has FDA-approved drug indication (FDB) |
|  Indication_Concept_ID |  27674 |
|  Indication_Concept_Name |  N&V - Nausea and vomiting |
|  Indication_Vocabulary_ID |  1 |
|  Indication_Vocabulary_Name |  SNOMED-CT |



## Documentation
https://github.com/OHDSI/CommonDataModel/wiki/
