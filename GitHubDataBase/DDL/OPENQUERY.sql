	select * from openquery(MYSQL,'show tables')

	select * from openquery(MYSQL,'select  * from  cds')

	INSERT OPENQUERY (MYSQL, 'SELECT titel, interpret, jahr, id FROM cds')   VALUES ('NewTitle','NewTitle',2017,69);  