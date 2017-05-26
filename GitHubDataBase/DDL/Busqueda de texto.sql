	use master
	go

	select a.Name  --, b.Text
	from sysobjects a 
	INNER JOIN  syscomments b ON a.Id = b.Id
	WHERE text like '%TblPromedioCorteFrenteSemana%'
	group by a.Name
	order by a.Name


