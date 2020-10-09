	USE dbrecursoshumanos
	GO
	
	DECLARE @VTableName VARCHAR(100) ='TblRespuestasEncuesta'

	SELECT b.name 
	FROM sys.sql_expression_dependencies a
	inner join sys.objects b on b.object_id =a.referencing_id
	WHERE referencing_id = OBJECT_ID(@VTableName);

	SELECT b.name 
	FROM sys.sql_expression_dependencies a
	inner join sys.objects b on b.object_id =a.referencing_id
	WHERE referenced_id = OBJECT_ID(@VTableName); 
	


