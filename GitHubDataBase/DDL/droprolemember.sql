USE [DbActivosFijosFotos]
GO
EXEC sp_droprolemember N'db_ddladmin', N'TiProgramador'
GO


USE [DbActivosFijosFotos]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datareader] TO [TiProgramador]
GO
USE [DbActivosFijosFotos]
GO
ALTER AUTHORIZATION ON SCHEMA::[db_datawriter] TO [TiProgramador]
GO
