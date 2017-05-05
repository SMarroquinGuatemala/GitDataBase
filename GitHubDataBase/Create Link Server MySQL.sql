Exec master.dbo.sp_addlinkedserver
@server=N'localhost',
@srvproduct=N'MySQL',
@provider=N'MSDASQL',
@datasrc=N'MySQL'

use master
go
--Exec master.dbo.sp_addlinkedserverlogin
execute sp_addlinkedsrvlogin
@locallogin=NULL,
@rmtuser=N'root',
@rmtsrvname=N'localhost'


select * from openquery(MYSQL,'select  titel, interpret, jahr, id from  cdcol.cds')


insert openquery(MYSQL,'select  titel, interpret, jahr, id from  cdcol.cds') VALUES ('Lo mejor del rock en español', 'DIDECA', 1, 16);  
