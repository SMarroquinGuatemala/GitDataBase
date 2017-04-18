
	DECLARE crsrPlanillasList CURSOR FOR
	SELECT  ReportesGruposID, Nombre,ReportesTipoDeGrupoID, FROM TblReportesGruposSistemas 
	WHERE ReporteID =1
		FOR READ ONLY
			OPEN crsrPlanillasList
				FETCH NEXT FROM  crsrPlanillasList INTO  @VReportesGruposID,@VNombre,@ReportesTipoDeGrupoID
					WHILE(@@FETCH_STATUS=0)
					BEGIN
						FETCH NEXT FROM  crsrPlanillasList INTO  @VReportesGruposID,@VNombre,@ReportesTipoDeGrupoID
					END
				
			CLOSE crsrPlanillasList
			DEALLOCATE crsrPlanillasList
	