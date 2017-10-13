
	USE DbRecursosHumanos
	GO

	DECLARE @PUsuario AS VARCHAR(50)='SANDIEGO\DMARROQUIN'
	SELECT  DISTINCT A.Area, B.Descripcion FROM TblRelacionAreasSubAreas a
	INNER JOIN TblAreas B ON B.Area =A.Area
	WHERE  EXISTS(

	SELECT  1 
	FROM TblSecUsuariosAreas aa
		WHERE IDUsuario =(	SELECT IDUsuario 
							FROM TblSecUsuarios
							WHERE Usuario =@PUsuario)
		AND AA.SubAreaPresupuesto =A.SubArea)
	AND B.Activo =1