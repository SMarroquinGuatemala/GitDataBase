
	SELECT 'GRANT SELECT, INSERT,UPDATE, DELETE ON  TblUnidadesDeMedida TO ['+name+']' 
	FROM SYS.database_principals
	WHERE type ='g'
	AND name LIKE '%CAMPO%'
	
	