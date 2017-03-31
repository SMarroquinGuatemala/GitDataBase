
	use DbMateriales
	go

	select  * from TblSolicitudesDeMateriales
	where SerieOT ='89'
	order by FechaCreacion desc