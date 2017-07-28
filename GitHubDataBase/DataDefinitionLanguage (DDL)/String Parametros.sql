	
	USE DbRecursosHumanos
	GO
	
	DECLARE  @TableName VARCHAR(256)='TblPeriodosDePago'
	
	SELECT  B.name +' as string,','@P'+B.name ,CASE WHEN B.column_id=1 THEN 'WHERE ' ELSE 'AND ' END+   B.name+ '= ISNULL( @P'+B.name+',' +B.name+')' FROM SYS.index_columns A
	INNER JOIN SYS.columns  B ON B.object_id =A.object_id AND B.column_id =A.column_id
	WHERE A.object_id=OBJECT_ID(@TableName)
	AND EXISTS(SELECT 1 FROM sys.key_constraints BB WHERE BB.parent_object_id =A.object_id AND BB.type ='PK')
	AND EXISTS(SELECT 1 FROM SYS.indexes BBB WHERE BBB.index_id =A.index_id AND BBB.type =1 AND  BBB.object_id=OBJECT_ID(@TableName))
	ORDER BY  B.column_id
	
	
	--SELECT Col.Column_Name from 
	--INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
	--INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
	--WHERE 
	--Col.Constraint_Name = Tab.Constraint_Name
	--AND Col.Table_Name = Tab.Table_Name
	--AND Constraint_Type = 'PRIMARY KEY'
	--AND Col.Table_Name = 'TblPeriodosDePago'

