	USE DbRecursosHumanos
	GO

		DECLARE
		@PEmpresa    CHAR(2)='01',
		@VAño  INT=2017,
		@VMes  INT='04',
		@PPlanilla CHAR(3)=NULL,
		@PPeriodosDePago       NVARCHAR(MAX)='1220,1221,2078,3158,3160,3161,3162,3163,4168,4169,4170,4171,4172,7043,7044,8004',
		@PCCN4 CHAR(2)=NULL,
		@PAfectaIGSS  TINYINT =NULL

		DECLARE @VFechaInicial DATETIME
		DECLARE @VFechaFinal DATETIME

		DECLARE @VCorrelativosDePlanillasIGSSMesAño TABLE
		(
			TipoDePlanilla CHAR(2),
			CorrelativoDePlanilla INT,
			FechaFinal DATETIME
		)

		DECLARE @VCorrelativosDePlanillas TABLE
		(
			Empresa CHAR(2),
			TipoDePlanilla CHAR(2),
			TipoDePago CHAR(1),
			CorrelativoPlanilla INT
		)

		DECLARE @VPeriodosDePago TABLE
		(
			Empresa CHAR(2),
			TipoDePlanilla CHAR(2),
			TipoDePago CHAR(1),
			CorrelativoDePago INT,
			FechaFinal DATETIME
		)

		DECLARE @TblInfoCuentaContable TABLE
		(
			CuentaContableN1    char(1),
			CuentaContableN2    char(1),
			CuentaContableN3    char(2),
			CuentaContableN4    char(2),
			CuentaContableN5    char(2),
			ValorNormalesYMensuales DECIMAL(18,2),
			ValorCorte DECIMAL(18,2),
			ValorAlce DECIMAL(18,2),
			Planilla VARCHAR(50),	
			TipoDePlanilla CHAR(2)
		)

		 
		INSERT @VCorrelativosDePlanillasIGSSMesAño 
		EXECUTE UpSPeriodosDePlanillaIGSSAñoMes @VAño,@VMes,@PEmpresa 

		INSERT @VCorrelativosDePlanillas(Empresa,TipoDePlanilla,TipoDePago,CorrelativoPlanilla)
		SELECT DISTINCT  A.Empresa,A.TipoDePlanilla, A.TipoDePago, A.CorrelativoPlanilla 
            FROM TblPeriodosDePago A
            INNER JOIN @VCorrelativosDePlanillasIGSSMesAño B ON	B .CorrelativoDePlanilla =A.CorrelativoPlanilla 
                                                                    AND B.TipoDePlanilla =A.TipoDePlanilla 
                                                                    AND 'N'=A.TipoDePago 
                                                                    AND @PEmpresa =A.Empresa   
		WHERE 1=1 
		   AND A.Empresa = @PEmpresa 
		   AND EXISTS(	SELECT 1 
						FROM DBO.FnSplit(ISNULL(@PPeriodosDePago,A.CorrelativoPlanilla) ,',') B 
						WHERE ISNULL(B.Valor,A.CorrelativoPlanilla) =A.CorrelativoPlanilla)
		   AND A.TipoDePago IN ('N')
		
		INSERT @VPeriodosDePago(Empresa, TipoDePlanilla, TipoDePago, CorrelativoDePago,FechaFinal)
		SELECT Empresa, TipoDePlanilla, TipoDePago, CorrelativoDePago, FechaFinal 
		FROM TblPeriodosDePago A (NOLOCK)
		WHERE EXISTS(	SELECT 1 
						FROM @VCorrelativosDePlanillas B 
						WHERE B.Empresa =A.Empresa 
							AND B.TipoDePago =A.TipoDePago 
							AND B.TipoDePlanilla=A.TipoDePlanilla 
							AND B.CorrelativoPlanilla =A.CorrelativoPlanilla)
			AND  A.Empresa =@PEmpresa
			AND A.TipoDePago IN ('N')  
		
       
		INSERT @VPeriodosDePago(Empresa, TipoDePlanilla, TipoDePago, CorrelativoDePago,FechaFinal)
		SELECT Empresa, TipoDePlanilla,'V' TipoDePago, CorrelativoDePago,FechaFinal FROM @VPeriodosDePago

		SELECT @VFechaInicial=MIN (FechaFinal), @VFechaFinal =max(FechaFinal) FROM @VPeriodosDePago

		SELECT   A.CuentaContableN1, A.CuentaContableN2,A.CuentaContableN3, a.CuentaContableN4,A.CuentaContableN5,SUM(Valor)Valor,b.TipoDePlanilla, a.Planilla + '-'+b.Nombre
		FROM TblDetalleMovimientoContableDiario A (NOLOCK)
		INNER JOIN TblPlanillas  B ON    B.Empresa =A.Empresa AND B.Planilla =A.Planilla
		WHERE A.Corporacion ='SD'
		AND A.Empresa  =ISNULL(@PEmpresa,A.Empresa)
		AND A.Planilla  =ISNULL(@PPlanilla, A.Planilla)
		AND A.FechaPoliza>=@VFechaInicial AND A.FechaPoliza <=@VFechaFinal
		AND A.Movimiento IN ('44','43')
		AND A.CuentaContableN4 = ISNULL(@PCCN4, A.CuentaContableN4)
		AND A.NumeroRegistro>0
		AND EXISTS(SELECT 1 FROM TblRetribuciones XX WHERE XX.Retribucion =A.Retribucion AND XX.Empresa =A.Empresa AND XX.Empresa =@PEmpresa AND XX.AfectaIGSS = ISNULL(@PAfectaIGSS,XX.AfectaIGSS))
		AND  EXISTS (	SELECT 1 
						FROM @VPeriodosDePago AA 
						WHERE AA.Empresa =A.Empresa 
							AND AA.TipoDePlanilla =B.TipoDePlanilla 
							AND AA.TipoDePago =A.TipoDePago 
							AND AA.CorrelativoDePago =SUBSTRING(A.NumeroDocumento,CHARINDEX('/',A.NumeroDocumento)+1,4)* 1 
					)
		GROUP BY  A.CuentaContableN1, A.CuentaContableN2,A.CuentaContableN3, a.CuentaContableN4,A.CuentaContableN5,B.TipoDePlanilla, a.Planilla,b.Nombre