sp_configure 'show advanced options',1;
GO
RECONFIGURE
GO

sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE
GO

-- create a new mail profile for notifications
EXECUTE msdb.dbo.sysmail_add_profile_sp
		@profile_name = 'Notifications',
		@description = 'profile for sending outgoing notifiications using Gmail'

-- set the new profile as the default
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
		@profile_name = 'notifications',
		@principal_name = 'public',
		@is_default = 1;
GO

-- create an account for the notifications
EXECUTE msdb.dbo.sysmail_add_account_sp
		@account_name = 'Gmail',
		@description = 'account for outgoing notifications',
		@email_address ='mymail@gmail.com',
		@display_name='Some! Triggers',
		@mailserver_name='smtp.gmail.com',
		@port =587,
		@enable_ssl =1,
		@username='mymail@gmail.com',
		@password='notrealemypassLOL:D'
GO

-- add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
		@profile_name = 'notifications',
		@account_name = 'Gmail',
		@sequence_number = 1
GO

/*

 -- remove email account

EXECUTE msdb.dbo.sysmail_delete_profileaccount_sp @profile_name = 'notifications', @account_name ='Gmail'
EXECUTE msdb.dbo.sysmail_delete_principalprofile_sp @principal_name = 'public', @profile_name = 'notifications'
EXECUTE msdb.dbo.sysmail_delete_account_sp @account_name ='Gamil'
EXECUTE msdb.dbo.sysmail_delete_profile_sp @profile_name ='notifications'

*/