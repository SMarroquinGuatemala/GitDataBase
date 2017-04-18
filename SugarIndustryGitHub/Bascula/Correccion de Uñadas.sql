	use DbBascula go 
	UPDATE TblEnviosPorViaje 
	SET totaldeUNADAS =1 
	where NotaDePeso =810477 
	AND Envio =645619 
	
	EXECUTE UpOficializarEnvios '04',810477