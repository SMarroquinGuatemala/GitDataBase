
	use DbLaboratorio
	go

	select top (10) Fecha,  QQAzucarBlancaStdTotal--+isnull(AzucarBlancaStdA,0) AzucarBlanca 
	from TblProduccionDia
	order by QQAzucarBlancaStdTotal desc--+isnull(AzucarBlancaStdA,0) desc


	select  QQAzucarBlancaStdTotal+isnull(AzucarBlancaStdA,0) AzucarBlanca  ,QQAzucarBlancaStdTotal,AzucarBlancaStdA,QQAzucarBlancaStdTotal-AzucarBlancaStdA, *
	from TblProduccionDia
	order by fecha  desc
	