	USE DbLaboratorio
	GO
	
	SET NOCOUNT ON
	DECLARE @VTable VARCHAR(500)='[TblSulfito]'
	DECLARE @MaxRowIDColumns	INT =0
	DECLARE @VColumns AS TABLE
	(
	Name VARCHAR(MAX),
	RowID INT,
	TypeID INT
	)
	
	DECLARE @MaxRowIDKeys		INT =0
	DECLARE @VKeys AS TABLE
	(
	Name VARCHAR(MAX),
	RowID INT,
	TypeID INT
	)
	
	DECLARE @MaxRowIDParameters		INT =0
	
	DECLARE @SColumns VARCHAR(MAX)=''
	DECLARE @SKeys VARCHAR(MAX)=''
	DECLARE @SParameters VARCHAR(MAX)=''
	
	
	
	
	INSERT @VColumns(Name,RowID, TypeID)
	SELECT name, ROW_NUMBER()OVER (ORDER BY column_id ), system_type_id
	FROM SYS.columns
	WHERE object_id =OBJECT_ID(@VTable,N'U')
	AND NOT name LIKE '%CREACION%' AND NOT name LIKE '%MODIFICACION%'
	AND NOT name IN(	SELECT  C.name 
							FROM sysindexkeys A
							INNER JOIN SYS.tables B ON B.object_id=A.id
							INNER JOIN SYS.columns C  ON C.column_id=A.colid AND C.object_id =B.object_id
							WHERE B.object_id =OBJECT_ID(@VTable,N'U')
							AND A.indid =1)
	
	SELECT @MaxRowIDColumns= MAX(RowID) FROM @VColumns
	
	INSERT @VKeys(Name, RowID, TypeID)
	SELECT  c.name,ROW_NUMBER()OVER (ORDER BY column_id ), system_type_id
	FROM sysindexkeys A
	INNER JOIN SYS.tables B ON B.object_id=A.id
	INNER JOIN SYS.columns C  ON C.column_id=A.colid AND C.object_id =B.object_id
	WHERE B.object_id =OBJECT_ID(@VTable,N'U')
	AND A.indid =1
	SELECT @MaxRowIDKeys= MAX(RowID) FROM @VKeys
	
	SELECT @SColumns= COALESCE(@SColumns+name,'')+'=@P'+name+CHAR(13) + CASE WHEN @MaxRowIDColumns=RowID THEN '' ELSE  ',' END 
	FROM @VColumns
	
	SELECT @SKeys= COALESCE(@SKeys+name ,'')+'=@P'+name +CHAR(13)+ CASE WHEN @MaxRowIDKeys=RowID THEN  '' ELSE  'AND ' END 
	FROM @VKeys
	
	--SELECT  *
	--FROM SYS.columns a
	--INNER JOIN SYS.types B ON B.system_type_id =A.system_type_id
	--WHERE object_id =OBJECT_ID(@VTable,N'U')
	--AND NOT a.name LIKE '%CREACION%' AND NOT a.name LIKE '%MODIFICACION%' 
	--ORDER BY A.column_id
	
	SELECT @MaxRowIDParameters= COUNT(1)	
	FROM SYS.columns a
	INNER JOIN SYS.types B ON B.system_type_id =A.system_type_id
	INNER JOIN vwSYSTiposdedatos C ON C.system_type_id =B.system_type_id
	WHERE object_id =OBJECT_ID(@VTable,N'U')
	AND NOT a.name LIKE '%CREACION%' AND NOT a.name LIKE '%MODIFICACION%' 
	
	SELECT @SParameters = COALESCE(@SParameters,'')+ '@P'+a.name +' '+b.name + 
	CASE WHEN NOT C.type IN (3,4) THEN  ''ELSE  '('+ 
					CASE WHEN  C.type =4 THEN CAST(A.precision AS VARCHAR)+','+ CAST(A.SCALE AS VARCHAR) ELSE CAST(A.max_length AS VARCHAR)  END
	+')' END+CHAR(13) + CASE WHEN @MaxRowIDParameters = ROW_NUMBER()OVER (ORDER BY column_id ) THEN '' ELSE   ',' END
	FROM SYS.columns a
	INNER JOIN SYS.types B ON B.system_type_id =A.system_type_id
	INNER JOIN SQLSDFCA5.DbRecursosHumanos.dbo.vwSYSTiposdedatos C ON C.system_type_id =B.system_type_id
	WHERE object_id =OBJECT_ID(@VTable,N'U')
	AND NOT a.name LIKE '%CREACION%' AND NOT a.name LIKE '%MODIFICACION%' 
	ORDER BY A.column_id
		
	--SELECT @SParameters = COALESCE(@SParameters,'')+ '@'+a.name +' '+b.name + CASE WHEN B.collation_name IS NULL AND (B.precision=0 OR B.scale=0) THEN ',' ELSE '('+ CASE WHEN B.precision=0 AND  B.scale=0 THEN  CAST( a.max_length AS VARCHAR) ELSE CAST( a.precision AS VARCHAR)+','+CAST( a.scale AS VARCHAR)  END  +'),' END
	--FROM SYS.columns a
	--INNER JOIN SYS.types B ON B.system_type_id =A.system_type_id
	--WHERE object_id =OBJECT_ID(@VTable,N'U')
	--AND NOT a.name LIKE '%CREACION%' AND NOT a.name LIKE '%MODIFICACION%' 
	--ORDER BY A.column_id

	
	
	PRINT 'DECLARE '
	PRINT @SParameters
	PRINT  'UPDATE ' +@VTable+' SET  '+ @SColumns + +'WHERE '+ @SKeys


