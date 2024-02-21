



# VISIT_DETAIL_VISIT_DETAIL_END_DATE



## Description
PLAUSIBLE_VALUE_HIGH
get number of records and the proportion to total number of eligible records that exceed this threshold



## Query
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
		SELECT &#39;VISIT_DETAIL.VISIT_DETAIL_END_DATE&#39; AS violating_field, 
		cdmTable.*
    	FROM @cdmDatabaseSchema.VISIT_DETAIL cdmTable
    		
    		
      	WHERE cast(cdmTable.VISIT_DETAIL_END_DATE as date) &gt; cast(DATEADD(dd,1,GETDATE()) as date)
    	
		/*violatedRowsEnd*/
	) violated_rows
) violated_row_count,
(
	SELECT 
		COUNT_BIG(*) AS num_rows
	FROM @cdmDatabaseSchema.VISIT_DETAIL cdmTable
		
  	WHERE VISIT_DETAIL_END_DATE IS NOT NULL
) denominator
```

