USE [DbRecursosHumanos]
GO
/****** Object:  StoredProcedure [dbo].[UpImportarMOdeCampo]    Script Date: 04/04/2017 08:47:04 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
declare 
@PEmpresa char(2)='01', @PTipoDePlanilla char(2)='01', @PCorrelativoDePago int=1124, @lSemana tinyint=1, 
@PPlanilla char(3)='09',@PFechaInicial datetime='22/03/2017', @PFechaFinal datetime='28/03/2017'

	DECLARE @PNumeroDeEmpleado char(7)='49424'
begin

   set nocount on

   declare @VContador int,  @lCont smallint
   declare @VClaveDeLabor char(4), @VCentroDeCosto char(7), @VRegistro int, @VValidado int
   declare @VFecha datetime, @VNumeroDeLabor int, @VNumeroDeDocumento int, @VIdMaquina char(7), @VEmpresa char(2), @VNumeroDeEmpleado char(7)
   declare @VCorrelativoDePago int, @VPlanilla char(3), @VSemana tinyint, @VSemanaOperativa tinyint, @VIndicadorDePago char(1), @VHorasOrdinarias decimal(10,2)
   declare @VHorasExtrasSimples decimal(10,2), @VHorasDobles decimal(10,2), @VHorasSabado decimal(10,2),  @VTrato char(3), @VCantidad decimal(10,2), @VResponsableAsignado char(2)
   declare @VHorasOrd decimal(10,2), @VHorasExt decimal(10,2), @VHorasDob decimal(10,2), @VHorasSab decimal(10,2), @VCant decimal(10,2)
   declare @VHorasOrdAcum decimal(10,2), @VHorasExtAcum decimal(10,2), @VHorasDobAcum decimal(10,2), @VHorasSabAcum decimal(10,2), @VCantAcum decimal(10,2)
   declare @VHoras decimal(10,2), @VArea decimal(10,2), @VTotalHoras decimal(10,2), @VTotalArea decimal(10,2)
   declare @lCN4 char(2),@lCN5 char(2)			--Agregado por Edgar Cetin el dia 18/09/2007
   declare @VEmpleadoMensaje char(7), @VFechaMensaje datetime, @VTratoMensaje char(3), @VCentroDeCostoMensaje char(7), @VClaveDeLaborMensaje char(7),@VExisteCount int,@VNumeroDeDocumentoMensaje int      --Agregado por Edgar Cetin el dia 27/02/2008

   declare @VTblMovimientosLaboresVarias table
   (
   NumeroDeRegistro int identity (1,1) not null,
   Empresa char (2) not null ,
   NumeroDeEmpleado char (7) not null ,
   CorrelativoDePago int not null ,
   Planilla char (3) not null ,
   Semana tinyint not null default (0),
   SemanaOperativa tinyint not null default (0),
   Fecha datetime not null ,
   IndicadorDePago char (1) not null ,
   TipoDeTurno char (1) not null default ' ',
   OrdenDeTrabajo int not null  default (0),
   Dias tinyint not null default (0),
   HorasOrdinarias decimal(5, 2) not null default (0),
   HorasExtrasSimples decimal(5, 2) not null default (0),
   HorasDobles decimal(5, 2) not null default (0),
   HorasSabado decimal(5, 2) not null default (0),   Trato char (3) not null default ('000'),
   TarifaTrato decimal(15, 7) not null default (0),
   Cantidad decimal(10, 2) not null default (0),
   Area decimal(10, 2) not null default (0),
   ValorHorasOrdinarias decimal(15, 7) not null default (0),
   ValorHorasExtrasSimples decimal(15, 7) not null default (0),
   ValorHorasDobles decimal(15, 7) not null default (0),
   ValorHorasSabado decimal(15, 7) not null default (0),
   ValorTrato decimal(15, 7) not null default (0),
   ValorTotal decimal(15, 7) not null default (0),
   ResponsableAsignado char (2) not null ,
   CentroDeCosto char (7) not null ,
   ClaveDeLabor char (4) not null ,
   CuentaContableN1 char (1) not null default ('0'),
   CuentaContableN2 char (1) not null default ('0'),
   CuentaContableN3 char (2) not null default ('00'),
   CuentaContableN4 char (2) null default ('00'),
   CuentaContableN5 char (2) not null default ('00'),
   NumeroDeCierre bigint not null default (0),
   CargoAutomatico tinyint not null default (0),
   Localizacion char (2) not null default ('01'),
   NumeroDeDocumento int null,
		Validado tinyint null
   )
   
      
   declare @VTblLaboresAgricolasMaquinaria table
   (
   Registro int identity(1,1) not null,
   ClaveDeLabor char(4) not null,
   CentroDeCosto char (7) not null ,
   Horas decimal(10, 2) not null ,
   Area decimal(10, 2) not null ,
   HorasOrdinarias decimal(5, 2) not null default (0),
   HorasExtrasSimples decimal(5, 2) not null default (0),
   HorasDobles decimal(5, 2) not null default (0),
   HorasSabado decimal(5, 2) not null default (0),
   Cantidad decimal(10, 2) not null default (0)
   )
   
  



   --insert into @VTblMovimientosLaboresVarias(Empresa , NumeroDeEmpleado, CorrelativoDePago, Planilla, Semana,SemanaOperativa,Fecha,
   --IndicadorDePago, TipoDeTurno,OrdenDeTrabajo,Dias,   HorasOrdinarias, HorasExtrasSimples,
   --HorasDobles,HorasSabado, Trato, TarifaTrato,Cantidad,Area,ValorHorasOrdinarias, ValorHorasExtrasSimples,
   --ValorHorasDobles, ValorHorasSabado, ValorTrato, ValorTotal, ResponsableAsignado,
   --CentroDeCosto ,ClaveDeLabor ,CuentaContableN1,CuentaContableN2,CuentaContableN3,CuentaContableN4,
   --CuentaContableN5,NumeroDeCierre,CargoAutomatico,Localizacion, NumeroDeDocumento)
   --select Empresa , NumeroDeEmpleado, CorrelativoDePago, Planilla, Semana,SemanaOperativa,Fecha,
   --IndicadorDePago, TipoDeTurno,OrdenDeTrabajo,Dias,   HorasOrdinarias, HorasExtrasSimples,
   --HorasDobles,HorasSabado, Trato, TarifaTrato,Cantidad,Area,ValorHorasOrdinarias, ValorHorasExtrasSimples,
   --ValorHorasDobles, ValorHorasSabado, ValorTrato, ValorTotal, ResponsableAsignado,
   --CentroDeCosto ,ClaveDeLabor ,CuentaContableN1,CuentaContableN2,CuentaContableN3,CuentaContableN4,
   --CuentaContableN5,NumeroDeCierre,CargoAutomatico,Localizacion, NumeroDeDocumento
   --from DbRecursosHumanos..TblMovimientosLaboresVarias
   --where empresa=@PEmpresa
   -- and  correlativoDePago=@PCorrelativoDePago
   -- and  Planilla=@PPlanilla
   -- and  NumeroDeDocumento>0


   select @lCont = count(*) from DbRecursosHumanos..TblMovimientosLaboresVarias
   where Empresa = @PEmpresa
     and CorrelativoDePago = @PCorrelativoDePago
     and Planilla = @PPlanilla
     and NumeroDeDocumento > 0
   --  and Semana=@lSemana		--Agregado por Edgar Cetin el dia 09/01/2007,  para verificar que haya informacion en la semana en proceso
 

   
--Mano de Obra

	insert into @VTblMovimientosLaboresVarias(Empresa, NumeroDeEmpleado, CorrelativoDePago, Planilla, Semana, SemanaOperativa, Fecha, IndicadorDePago, 
		HorasOrdinarias, HorasExtrasSimples, HorasDobles, HorasSabado, Trato, Cantidad, Area, ResponsableAsignado, CentroDeCosto, ClaveDeLabor, NumeroDeDocumento, Validado)
	select b.Empresa, b.NumeroDeEmpleado, b.CorrelativoDePago, b.Planilla, b.Semana, b.SemanaOperativa, a.Fecha, b.IndicadorDePago, 
		b.HorasOrdinarias, b.HorasExtrasSimples, b.HorasDobles, b.HorasSabado, b.Trato, b.Cantidad, b.Area, b.ResponsableAsignado, b.CentroDeCosto, a.ClaveDeLabor, b.NumeroDeDocumento, a.Validado
	from DbCampo..TblLaboresAgricolas a, DbCampo..TblLaboresAgricolasManoDeObra b
	where a.NumeroDeLabor = b.NumeroDeLabor
     --and a.Validado = 1
	  and a.Fecha >= @PFechaInicial
	  and a.Fecha <= @PFechaFinal
	  and b.Empresa = @PEmpresa
	  and b.CorrelativoDePago = @PCorrelativoDePago
	  and b.Planilla = @PPlanilla
	  and b.NumeroDeEmpleado =@PNumeroDeEmpleado
 

--Mano de Obra - Maquinaria
	declare CurMaquinaria insensitive cursor for
		select a.Fecha, a.ClaveDeLabor, b.NumeroDeLabor, b.NumeroDeDocumento, b.IdMaquina, b.Empresa, b.NumeroDeEmpleado, b.CorrelativoDePago, b.Planilla, b.Semana, b.SemanaOperativa, b.IndicadorDePago, 
			b.HorasOrdinarias, b.HorasExtrasSimples, b.HorasDobles, b.HorasSabado, b.Trato, b.Cantidad, b.ResponsableAsignado, a.Validado
		from DbCampo..TblLaboresAgricolas a, DbCampo..TblLaboresAgricolasMaquinariaPersonal b
		where a.NumeroDeLabor = b.NumeroDeLabor
      --and a.Validado = 1
		and a.Fecha >= @PFechaInicial
		and a.Fecha <= @PFechaFinal
		and b.Empresa = @PEmpresa
		and b.CorrelativoDePago = @PCorrelativoDePago
		and b.Planilla = @PPlanilla
		and b.NumeroDeEmpleado =@PNumeroDeEmpleado
	for read only

	open CurMaquinaria
	fetch next from CurMaquinaria into @VFecha, @VClaveDeLabor, @VNumeroDeLabor, @VNumeroDeDocumento, @VIdMaquina, @VEmpresa, @VNumeroDeEmpleado, @VCorrelativoDePago, @VPlanilla,
		 @VSemana, @VSemanaOperativa, @VIndicadorDePago, @VHorasOrdinarias, @VHorasExtrasSimples, @VHorasDobles, @VHorasSabado, @VTrato, @VCantidad, @VResponsableAsignado, @VValidado
	while(@@fetch_status=0)
		BEGIN
		
			delete @VTblLaboresAgricolasMaquinaria

			insert into @VTblLaboresAgricolasMaquinaria (ClaveDeLabor, CentroDeCosto, Horas, Area)
			select a.ClaveDeLabor, b.CentroDeCosto, sum(b.Horas), sum(b.Area)
			from DbCampo..TblLaboresAgricolas A
			INNER JOIN DbCampo..TblLaboresAgricolasMaquinaria b ON a.NumeroDeLabor = b.NumeroDeLabor
			WHERE b.NumeroDeDocumento = @VNumeroDeDocumento
			and b.IdMaquina = @VIdMaquina
--			and b.Horas > 0
			
			group by a.ClaveDeLabor, b.CentroDeCosto

			

			select @VTotalHoras = sum(Horas), @VTotalArea = sum(Area), @VContador = count(*)
			from @VTblLaboresAgricolasMaquinaria

		

			declare CurLabores insensitive cursor for
				select Registro, ClaveDeLabor, CentroDeCosto, Horas, Area
				from @VTblLaboresAgricolasMaquinaria
			for read only

			open CurLabores
			fetch next from CurLabores into @VRegistro, @VClaveDeLabor, @VCentroDeCosto, @VHoras, @VArea
			while(@@fetch_status=0)
				begin
					select @VContador = count(*)
					from @VTblMovimientosLaboresVarias
					where Fecha = @VFecha
					and ClaveDeLabor = @VClaveDeLabor
					and CentroDeCosto = @VCentroDeCosto
					and Area = @VArea

					if @VContador > 0
					select @VArea = 0
					select @VTotalHoras , @VHorasDobles VHorasDobles
					if @VTotalHoras > 0   
					BEGIN
						update  @VTblLaboresAgricolasMaquinaria
								set HorasOrdinarias = @VHorasOrdinarias * (@VHoras / @VTotalHoras),
									HorasExtrasSimples = @VHorasExtrasSimples  * (@VHoras / @VTotalHoras),
									HorasDobles = @VHorasDobles  * (@VHoras / @VTotalHoras),
									HorasSabado = @VHorasSabado  * (@VHoras / @VTotalHoras),									
									Cantidad = @VCantidad  * (@VHoras / @VTotalHoras),
									Area = @VArea
						where Registro = @VRegistro
					END
					IF ISNULL(@VHorasOrdinarias,0)+ISNULL(@VHorasExtrasSimples,0)+ISNULL(@VHorasDobles,0)>0 AND @VTotalHoras =0
					BEGIN
						update  @VTblLaboresAgricolasMaquinaria
								set HorasOrdinarias = @VHorasOrdinarias,
									HorasDobles = @VHorasDobles  
						where Registro = @VRegistro
					END

					fetch next from CurLabores into @VRegistro, @VClaveDeLabor, @VCentroDeCosto, @VHoras, @VArea
				end
			close CurLabores
			deallocate CurLabores

			SELECT 1, * FROM @VTblLaboresAgricolasMaquinaria

			select @VHorasOrd = sum(HorasOrdinarias), @VHorasExt = sum(HorasExtrasSimples), @VHorasDob = sum(HorasDobles), @VHorasSab = sum(HorasSabado), @VCant = sum(Cantidad)
			from @VTblLaboresAgricolasMaquinaria

			if @VHorasOrd <> @VHorasOrdinarias
					update  @VTblLaboresAgricolasMaquinaria
							set HorasOrdinarias = HorasOrdinarias + @VHorasOrdinarias - @VHorasOrd
					where Registro = (select max(Registro)
														from @VTblLaboresAgricolasMaquinaria
														where HorasOrdinarias = (select max(HorasOrdinarias)
																												from @VTblLaboresAgricolasMaquinaria))
																			
			if @VHorasExt <> @VHorasOrdinarias
					update  @VTblLaboresAgricolasMaquinaria
							set HorasExtrasSimples = HorasExtrasSimples + @VHorasExtrasSimples - @VHorasExt
					where Registro = (select max(Registro)
														from @VTblLaboresAgricolasMaquinaria
														where HorasExtrasSimples = (select max(HorasExtrasSimples)
																													from @VTblLaboresAgricolasMaquinaria))
			
		

			if @VHorasDob <> @VHorasOrdinarias
					update  @VTblLaboresAgricolasMaquinaria
							set HorasDobles = HorasDobles + @VHorasDobles - @VHorasDob
					where Registro = (select max(Registro)
														from @VTblLaboresAgricolasMaquinaria
														where HorasDobles = (select max(HorasDobles)
																									from @VTblLaboresAgricolasMaquinaria))

			if @VHorasSab <> @VHorasOrdinarias
					update  @VTblLaboresAgricolasMaquinaria
							set HorasSabado = HorasSabado + @VHorasSabado - @VHorasSab
					where Registro = (select max(Registro)
														from @VTblLaboresAgricolasMaquinaria
														where HorasSabado = (select max(HorasSabado)
																									from @VTblLaboresAgricolasMaquinaria))

			if @VCant <> @VCantidad
					update  @VTblLaboresAgricolasMaquinaria
							set Cantidad = Cantidad + @VCantidad - @VCant
					where Registro = (select max(Registro)
															from @VTblLaboresAgricolasMaquinaria
															where Cantidad = (select max(Cantidad)
																			from @VTblLaboresAgricolasMaquinaria))


			declare CurLabores insensitive cursor for
				select ClaveDeLabor, CentroDeCosto, HorasOrdinarias, HorasExtrasSimples, HorasDobles, HorasSabado, Cantidad, Area
				from @VTblLaboresAgricolasMaquinaria
			for read only

			open CurLabores
			fetch next from CurLabores into @VClaveDeLabor, @VCentroDeCosto, @VHorasOrdinarias, @VHorasExtrasSimples, @VHorasDobles, @VHorasSabado, @VCantidad, @VArea
			while(@@fetch_status=0)
				begin
             

--23/04/2007 jmelendez se agregó esta linea para que las hectareas trabajadas por la maquinaria no pasen al sistema de planillas debido a que estas estan en los movimientos de la maquinaria
               select @VArea = 0
--23/04/2007 jmelendez se agregó esta linea para que las hectareas trabajadas por la maquinaria no pasen al sistema de planillas debido a que estas estan en los movimientos de la maquinaria

               select @VContador = count(*) from @VTblMovimientosLaboresVarias
               where Empresa = @VEmpresa
                 and NumeroDeEmpleado = @VNumeroDeEmpleado
                 and Fecha = @VFecha
                 and Trato = @VTrato
                 and CentroDeCosto = @VCentroDeCosto
                 and ClaveDeLabor = @VClaveDeLabor

               if @VContador = 0
                  insert into @VTblMovimientosLaboresVarias
                  (Empresa, NumeroDeEmpleado, CorrelativoDePago, Planilla, Semana, SemanaOperativa, Fecha, IndicadorDePago, 
                   HorasOrdinarias, HorasExtrasSimples, HorasDobles, HorasSabado, Trato, Cantidad, Area, ResponsableAsignado, CentroDeCosto, ClaveDeLabor, NumeroDeDocumento, Validado)
                  values 
                  (@VEmpresa, @VNumeroDeEmpleado, @VCorrelativoDePago, @VPlanilla, @VSemana, @VSemanaOperativa, @VFecha, @VIndicadorDePago, 
                   @VHorasOrdinarias, @VHorasExtrasSimples, @VHorasDobles, @VHorasSabado, @VTrato, @VCantidad, @VArea, @VResponsableAsignado, @VCentroDeCosto, @VClaveDeLabor, @VNumeroDeDocumento, @VValidado)                                                        
               else
                  update @VTblMovimientosLaboresVarias
                  set HorasOrdinarias = HorasOrdinarias + @VHorasOrdinarias,
                      HorasExtrasSimples = HorasExtrasSimples + @VHorasExtrasSimples,
                      HorasDobles = HorasDobles + @VHorasDobles,
                      HorasSabado = HorasSabado + @VHorasSabado,
                      Cantidad =Cantidad+  @VCantidad,
                      Area = Area + @VArea
                  where Empresa = @VEmpresa
                    and NumeroDeEmpleado = @VNumeroDeEmpleado
                    and Fecha = @VFecha
                    and Trato = @VTrato
                    and CentroDeCosto = @VCentroDeCosto
                    and ClaveDeLabor = @VClaveDeLabor

					fetch next from CurLabores into @VClaveDeLabor, @VCentroDeCosto, @VHorasOrdinarias, @VHorasExtrasSimples, @VHorasDobles, @VHorasSabado, @VCantidad, @VArea
				end
			close CurLabores
			deallocate CurLabores

			fetch next from CurMaquinaria into @VFecha, @VClaveDeLabor, @VNumeroDeLabor, @VNumeroDeDocumento, @VIdMaquina, @VEmpresa, @VNumeroDeEmpleado, @VCorrelativoDePago, @VPlanilla,
				 @VSemana, @VSemanaOperativa, @VIndicadorDePago, @VHorasOrdinarias, @VHorasExtrasSimples, @VHorasDobles, @VHorasSabado, @VTrato, @VCantidad, @VResponsableAsignado, @VValidado
		end
	close CurMaquinaria
	deallocate CurMaquinaria

	select @VContador  = count(*)
	from @VTblMovimientosLaboresVarias 	
	where Validado = 0
	
	
	

   declare @lNumeroDeRegistro int, @lClaveDeLabor char(4), @lCentroDeCosto char(7)
   declare @lCN1 char(1), @lCN2 char(1), @lCN3 char(2), @lExito2 tinyint, @lMensaje2 varchar(100)

   declare curFinal insensitive cursor for
	select NumeroDeRegistro, ClaveDeLabor, CentroDeCosto from @VTblMovimientosLaboresVarias

   open curFinal
   fetch next from curFinal into @lNumeroDeRegistro, @lClaveDeLabor, @lCentroDeCosto
   while @@fetch_status = 0
   begin
   
     

     --Agregado por Edgar Cetin el dia 18/09/2007
     --Validacion cuando el exito es 100 
     --*/*//*/*/*/*/*/*/**/*//*/**/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**//*/*/*/*/*/**/*/*/*/*/*/*/*

    --*/*/*/*/*/*/*/*/*/*//*/*/*/*/*/*/*/*/*/**/*/*/*//*/*/*/*/*/*/*/*/*/**/*/*/*/*/*/*/*/*/*/*/*/**/*/*/*/*/*

     --Asi estaba anteriormente y se modifico de la forma arriba descrita
     --Modificado por Edgar Cetin el dia 18/09/2007
     --/////////////////////////////////////////////////////////////////////////////////////	
   
      /*if @lExito = 0 and @lExito2 = 0
         update @VTblMovimientosLaboresVarias
         set CuentaContableN1 = @lCN1, CuentaContableN2 = @lCN2, CuentaContableN3 = @lCN3,
             CuentaContableN4 = '55',  CuentaContableN5 = Empresa
         where NumeroDeRegistro = @lNumeroDeRegistro
      else
         select @lExito = 5*/

     --/////////////////////////////////////////////////////////////////////////////////////
   
   fetch next from curFinal into @lNumeroDeRegistro, @lClaveDeLabor, @lCentroDeCosto
   end
   close curFinal deallocate curFinal

   -- Validar que el empleado no tenga datos duplicados
   -- Agregado por Edgar Cetin el dia 27/02/2008
   --*/*/*/*/**/*/*/*/*/***/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/*/*/*/*/*/**/***/*/*/*
  
      declare @VTblExiste table
      (
         empresa           char(2),
         empleado          char(7),
         fecha             datetime,
         OrdenDeTrabajo    int,
         trato             char(3),
         centrodecosto     char(7),
         clavedelabor      char(4),
         NumeroDeDocumento int
      )    

      insert into @VTblExiste(empresa,empleado,fecha,OrdenDeTrabajo,trato,centrodecosto,clavedelabor)
      select empresa,numerodeempleado,fecha,ordendetrabajo,trato,centrodecosto,clavedelabor
      from @VTblMovimientosLaboresVarias
      group by empresa,numerodeempleado,fecha,ordendetrabajo,trato,centrodecosto,clavedelabor
      having count(*)>1 

      select @VExisteCount=count(*) from @VTblMovimientosLaboresVarias a, DbRecursosHumanos..TblMovimientosLaboresVarias b
      where a.empresa=b.empresa
      and   a.numerodeempleado=b.numerodeempleado
      and   a.fecha=b.fecha
      and   a.ordendetrabajo=b.ordendetrabajo
      and   a.trato=b.trato
      and   a.centrodecosto=b.centrodecosto
      and   a.clavedelabor=b.clavedelabor
   
   if @VExisteCount>0     
     begin
        insert into @VTblExiste(empresa,empleado,fecha,OrdenDeTrabajo,trato,centrodecosto,clavedelabor,NumeroDeDocumento)
        select a.Empresa, a.NumeroDeEmpleado,a.Fecha,a.OrdenDeTrabajo,a.Trato,a.CentroDeCosto,a.ClaveDeLabor,a.NumeroDeDocumento
        from @VTblMovimientosLaboresVarias a, DbRecursosHumanos..TblMovimientosLaboresVarias b
        where a.empresa=b.empresa
        and   a.numerodeempleado=b.numerodeempleado
        and   a.fecha=b.fecha
        and   a.ordendetrabajo=b.ordendetrabajo
        and   a.trato=b.trato
        and   a.centrodecosto=b.centrodecosto
        and   a.clavedelabor=b.clavedelabor
     end

     select @VExisteCount=0

      select @VExisteCount=count(*) from @VTblExiste
      if @VExisteCount>0
       begin

           select @VEmpleadoMensaje=Empleado, @VFechaMensaje=Fecha, @VTratoMensaje=Trato, @VCentroDeCostoMensaje=CentroDeCosto, @VClaveDeLaborMensaje=ClaveDeLabor,@VNumeroDeDocumentoMensaje=NumeroDeDocumento
           from @VTblExiste

         

       end  

   --*/*/*/*/**/*/*/*/*/***/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/*/*/*/*/*/**/***/*/*/*      

  
   --insert into DbRecursosHumanos..TblMovimientosLaboresVarias
   --(Empresa, NumeroDeEmpleado,CorrelativoDePago,Planilla,Semana,SemanaOperativa,Fecha,IndicadorDePago,TipoDeTurno,
   -- OrdenDeTrabajo,Dias,HorasOrdinarias,HorasExtrasSimples,HorasDobles,HorasSabado,Trato,TarifaTrato,Cantidad,Area,
   -- ValorHorasOrdinarias,ValorHorasExtrasSimples,ValorHorasDobles,ValorHorasSabado,ValorTrato,ValorTotal,
   -- ResponsableAsignado,CentroDeCosto,ClaveDeLabor,CuentaContableN1,CuentaContableN2,CuentaContableN3,CuentaContableN4,
   -- CuentaContableN5,NumeroDeCierre,CargoAutomatico,Localizacion,NumeroDeDocumento)
	select Empresa, NumeroDeEmpleado,CorrelativoDePago,Planilla,Semana,SemanaOperativa,Fecha,IndicadorDePago,TipoDeTurno,
    OrdenDeTrabajo,Dias,HorasOrdinarias,HorasExtrasSimples,HorasDobles,HorasSabado,Trato,TarifaTrato,Cantidad,Area,
    ValorHorasOrdinarias,ValorHorasExtrasSimples,ValorHorasDobles,ValorHorasSabado,ValorTrato,ValorTotal,
    ResponsableAsignado,CentroDeCosto,ClaveDeLabor,CuentaContableN1,CuentaContableN2,CuentaContableN3,CuentaContableN4,
    CuentaContableN5,NumeroDeCierre,CargoAutomatico,Localizacion,NumeroDeDocumento from @VTblMovimientosLaboresVarias
--	WHERE IndicadorDePago='D'
--	AND NumeroDeEmpleado ='49424'
	order by NumeroDeEmpleado, Fecha
	
	
  
		
end








