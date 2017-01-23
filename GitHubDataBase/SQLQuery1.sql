USE [DbRecursosHumanos]
GO

/****** Object:  View [dbo].[VWOrganizacionTerritorial]    Script Date: 20/01/2017 02:39:02 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

	CREATE VIEW [dbo].[VWOrganizacionTerritorial]
	AS
	SELECT  A.Departamento
	,A.Nombre DepartamentoNombre 
	,B.Municipio, B.Nombre MunicipioNombre
	,c.Comunidad Comunidad
	,c.Nombre ComunidadNombre
	FROM DbContabilidad.DBO.TblDepartamentos A
	LEFT JOIN DbContabilidad.DBO.TblMunicipiosPorDepartamento  B ON B.Departamento =A.Departamento
	LEFT JOIN DbContabilidad.DBO.TblComunidadesPorMunicipio C ON C.Departamento=B.Departamento AND C.Municipio =B.Municipio
	
	
GO

