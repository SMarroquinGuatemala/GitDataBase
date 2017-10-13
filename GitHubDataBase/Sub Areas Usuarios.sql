	USE DbRecursosHumanos
	GO
	DECLARE @PUsuario VARCHAR(50)='SANDIEGO\DMARROQUIN', @PArea CHAR(2)

	SELECT  SubAreaPresupuesto, B.Descripcion 
	FROM TblSecUsuariosAreas A
	INNER JOIN DBO.VwSubAreasDelPresupuesto B ON B.SubArea=A.SubAreaPresupuesto
	WHERE IDUsuario =	(	SELECT IDUsuario 
							FROM TblSecUsuarios
							WHERE Usuario =@PUsuario)
	AND B.SubArea = ISNULL(@PArea, B.SubArea)
							
	