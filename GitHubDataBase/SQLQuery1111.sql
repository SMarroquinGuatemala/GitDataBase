
	USE DbRecursosHumanos
	GO

	SELECT  Retribucion, Nombre, 'Ingresos' Descripcion 
	FROM TBLRETRIBUCIONES
	WHERE Empresa ='01'
	UNION ALL 
	SELECT   Retencion, Nombre, 'Deducciones' Descripcion
	FROM TblRetenciones
	WHERE Empresa ='01'