



# DEVICE_EXPOSURE_DEVICE_EXPOSURE_START_DATE



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
  	denominator.num_rows AS num_denominator_rows
```

