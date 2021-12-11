USE DemoDb

GO

IF OBJECT_ID('iProductNotification', 'TR') IS NOT NULL
	DROP TRIGGER iProductNotification
GO

CREATE TRIGGER iProductNotification ON Products
	FOR INSERT
AS

	DECLARE @ProductInformation NVARCHAR(255);

	SELECT
		@ProductInformation = 'New Product ' + Name + 'is now avalable for ' + CAST(Price AS NVARCHAR(20)) + '!'
	FROM
		Inserted;

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'notifications',
		@recipients = 'se.hadirezaee@gmail.com',
		@body = @ProductInformation,
		@subject = 'New Product Notification';
GO