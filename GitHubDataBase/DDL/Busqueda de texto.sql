	use master
	go

	select a.Name  --, b.Text
	from sysobjects a, syscomments b
	where a.Id = b.Id
	and text like '%TblPromedioCorteFrenteSemana%'
	group by a.Name
	order by a.Name
