



# PERSON_DAY_OF_BIRTH



## Description
PLAUSIBLE_VALUE_HIGH
get number of records and the proportion to total number of eligible records that exceed this threshold



## Example
```sql
SELECT 
	num_violated_rows, 
	CASE 
		WHEN denominator.num_rows = 0 THEN 0 
		ELSE 1.0*num_violated_rows/denominator.num_rows 
	END AS pct_violated_rows, 
  	denominator.num_rows AS num_denominator_rowsFROM
(
	SELECT 
		COUNT_BIG(violated_rows.violating_field) AS num_violated_rows
	FROM
	(
		/*violatedRowsBegin*/
		SELECT &#39;PERSON.DAY_OF_BIRTH&#39; AS violating_field, 
		cdmTable.*
    	FROM @cdmDatabaseSchema.PERSON cdmTable
    		
    		
      		WHERE cdmTable.DAY_OF_BIRTH &gt; 31
		
		/*violatedRowsEnd*/
	) violated_rows
) violated_row_count,
(
	SELECT 
		COUNT_BIG(*) AS num_rows
	FROM @cdmDatabaseSchema.PERSON cdmTable
		
  	WHERE DAY_OF_BIRTH IS NOT NULL
) denominator
```

