	USE DbProductoTerminado
	GO
	sp_change_users_login @Action='Report';
	GO
	sp_change_users_login @Action='update_one', @UserNamePattern='Intranet', @LoginName='Intranet';
	GO