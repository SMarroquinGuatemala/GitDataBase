	--DECLARE @VEmpleados AS  NumeroDeEmpleadoType
	USE DbRecursosHumanos
	GO

	--SELECT  HOST_NAME()

	DECLARE
	@PEmpresa char(2)= NULL
   ,@PNumeroDeEmpleado dbo.NumeroDeEmpleadoType 
   ,@PDepartamentoEmpresa char(3)= NULL
   ,@PPuesto char(3)= NULL
   ,@PResponsableAsignado char(2)= NULL
   ,@PPlanilla char(3)= NULL
   ,@PCaporal char(7)= NULL
   ,@PMonitor char(7)= NULL
   ,@PDiaIngreso INT = NULL
   ,@PMesIngreso INT = NULL
   ,@PAnioIngreso INT = NULL
   ,@PDiaFinalContrato INT = NULL
   ,@PMesFinalContrato INT = NULL
   ,@PAnioFinalContrato INT = NULL
   ,@PDiaEgreso INT = NULL
   ,@PMesEgreso INT = NULL
   ,@PAnioEgreso INT = NULL
   ,@PEstado tinyint  = 1      
   ,@PTipoDeClasificacion char(2)  = NULL   
   ,@PTipoDeContrato char(2)  = NULL   
   ,@PFormaDePago CHAR(2)  = NULL   
   ,@PAfiliacionIGSS VARCHAR(15)  = NULL   
   ,@PNombres VARCHAR(25)  = NULL   
   ,@PApellidos VARCHAR(25)  = NULL   
   ,@PNumeroRegistroCedula CHAR(8)  = NULL   
   ,@PDepartamentoCedula char(2)  = NULL   
   ,@PMunicipioCedula char(2)  = NULL   
   ,@PDPI VARCHAR(15)  = NULL   
   ,@PBanco CHAR(3)  = NULL   
   ,@PSexo CHAR(1)  = NULL   
   ,@PAhorroSolidarismo TINYINT  = NULL    
   ,@PLiquidacionEnProceso TINYINT  = NULL   
   ,@PSeguroVidaCortadores TINYINT  = NULL   
   ,@PTieneDPI TINYINT  = NULL   
   ,@PISO9000 TINYINT  = NULL
   ,@PPersonalSubContratado TINYINT = NULL   
   ,@PNivelOrganizacional INT = NULL
   ,@PArea CHAR(2) = NULL
   ,@PSubArea CHAR(2) = NULL

	
	INSERT @PNumeroDeEmpleado(NumeroDeEmpleado) VALUES ('41779')
		
	EXECUTE UPSPerfilDelEmpleadoV2	@PEmpresa, @PNumeroDeEmpleado, @PDepartamentoEmpresa
	,@PPuesto
	,@PResponsableAsignado
	,@PPlanilla
	,@PCaporal
	,@PMonitor
	,@PDiaIngreso
	,@PMesIngreso
	,@PAnioIngreso
	,@PDiaFinalContrato
	,@PMesFinalContrato
	,@PAnioFinalContrato
	,@PDiaEgreso
	,@PMesEgreso
	,@PAnioEgreso
	,@PEstado
	,@PTipoDeClasificacion
	,@PTipoDeContrato
	,@PFormaDePago
	,@PAfiliacionIGSS
	,@PNombres
	,@PApellidos
	,@PNumeroRegistroCedula
	,@PDepartamentoCedula
	,@PMunicipioCedula
	,@PDPI
	,@PBanco
	,@PSexo
	,@PAhorroSolidarismo
	,@PLiquidacionEnProceso
	,@PSeguroVidaCortadores
	,@PTieneDPI
	,@PISO9000
	,@PPersonalSubContratado
	,@PNivelOrganizacional
	,@PArea
	,@PSubArea
										 	