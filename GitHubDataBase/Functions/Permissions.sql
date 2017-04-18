 SELECT 
	B.name Usuario, B.create_date FechaCreacion, B.modify_date,A.permission_name NombrePermiso, 
	A.state Estado,A.state_desc EstadoDescripcion,
	C.name Objecto  ,
	C.type Tipo, C.type_desc TipoDescripcion                    
	FROM SYS.database_permissions A         
	INNER JOIN sys.database_principals B ON B.principal_id =A.grantee_principal_id         
	INNER JOIN SYS.objects C ON C.object_id =A.major_id         
	WHERE B.type ='S'
	AND NOT A.state ='D'