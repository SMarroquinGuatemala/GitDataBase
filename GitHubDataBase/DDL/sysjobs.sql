--https://msdn.microsoft.com/es-es/library/ms189817.aspx
	use msdb
	go

	--Jobs
	select  * from dbo.sysjobs

	--Steps
	select  * from dbo.sysjobsteps

	--schedules
	select * from dbo.sysjobschedules