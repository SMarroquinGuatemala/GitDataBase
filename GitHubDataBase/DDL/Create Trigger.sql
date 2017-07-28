	
	create trigger [dbo].[TrgUPolizaCatorcenalSemanal] on TblPolizaCatorcenalSemanal for update as
		begin
			update a
			set UsuarioModificacion =  suser_sname(),
			ComputadoraModificacion = host_name(),
			AplicacionModificacion = app_name(),
			FechaModificacion = getdate()
			from TblPolizaCatorcenalSemanal a 
			INNER JOIN inserted i ON A.Empresa =I.Empresa  
			AND A.TipoDePlanilla =I.TipoDePlanilla AND  A.TipoDePago =I.TipoDePago 
			AND A.CorrelativoPlanilla=I.CorrelativoPlanilla AND A.CorrelativoDePago =I.CorrelativoDePago 
			AND A.FechaPolizaSemanal=I.FechaPolizaSemanal AND A.FechaPolizaCatorcenal=I.FechaPolizaCatorcenal
			
		end