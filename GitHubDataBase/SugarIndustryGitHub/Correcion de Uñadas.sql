
use DbBascula 
go 

SELECT  * 
FROM TblEnviosPorViaje 
--  UPDATE TblEnviosPorViaje SET totaldeUNADAS =1 
WHERE NotaDePeso =824286  
AND Envio =651321  

USE DbBascula
GO

--EXECUTE UpOficializarEnvios '04',824286


select * 
from DbLaboratorio.dbo.TblWCriteriosCorreSampler 
--update DbLaboratorio.dbo.TblWCriteriosCorreSampler set PesoNeto = '32.05' 
where Fecha = '12/04/2017' 
and finca = '504' 
and lote = '0103'