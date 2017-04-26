
	use DbBascula 
	go 
	--Actualizacion de envios
	SELECT  * 
	FROM TblEnviosPorViaje 
	--  UPDATE TblEnviosPorViaje SET totaldeUNADAS =80 
	WHERE NotaDePeso =825285  
	AND Envio in(653094,653095,653096)  

	--Oficializacion de envios
	USE DbBascula
	GO
	EXECUTE UpOficializarEnvios '04',825285

	--Verificacion de pesos criterios core sample
	DECLARE @PFecha DATETIME ='17/04/2017'
	select b.Finca,b.Lote,sum(b.pesoneto)
	from dbbascula.dbo.tblviajes a 
	inner join dbbascula.dbo.tblenviosporviaje b on a.NotaDePeso = b.NotaDePeso
	where a.Fecha = @PFecha
	and exists(
	select 1
	from DbLaboratorio.dbo.TblWCriteriosCorreSampler aa
	where fecha = @PFecha
	and b.Finca = aa.Finca
	and b.Lote = aa.Lote
	)
	group by b.Finca,b.Lote
	order by b.finca,b.Lote

	-- Modificaciones de los criterios del core sample
	GO
	DECLARE @PFecha DATETIME ='17/04/2017'
	select * 
	from DbLaboratorio.dbo.TblWCriteriosCorreSampler
	-- UPDATE DbLaboratorio.dbo.TblWCriteriosCorreSampler SET  PESONETO=54.73 
	where fecha = @PFecha
	--AND Lote ='0205'
	order by finca

	--  Oficializacion de los datos de campo
	GO
	DECLARE @PFecha DATETIME ='17/04/2017'

	USE DbLaboratorio
	EXECUTE  UpOficializarCampo '04',  @PFecha, @PFecha


