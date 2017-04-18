	use DbRecursosHumanos
	go

	DECLARE @Names VARCHAR(8000) 
	SELECT @Names = COALESCE(@Names + ', ', '') + ColumnName 
	FROM  TableName
