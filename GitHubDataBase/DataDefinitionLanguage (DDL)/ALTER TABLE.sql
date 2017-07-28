	USE DbMantenimiento
	GO
	
	ALTER TABLE dbo.TblEstados ADD
	FechaCreacion datetime NULL default getdate(),
	UsuarioCreacion varchar(40) NULL default suser_sname(),
	ComputadoraCreacion varchar(40) NULL default host_name(),
	AplicacionCreacion varchar(50) NULL default app_name(),
	FechaModificacion datetime NULL,
	UsuarioModificacion varchar(40) NULL,
	ComputadoraModificacion varchar(40) NULL,
	AplicacionModificacion varchar(50) NULL