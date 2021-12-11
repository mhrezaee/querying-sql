USE DemoDb
GO

INSERT dbo.Employees SELECT 1,'John',NULL,'Shepard','sales person','1/1/2010',20,300000.00
INSERT dbo.Employees SELECT 1,'Jane',NULL,'Shepard','sales person','1/1/2010',30,400000.00


INSERT Products SELECT 1,'Shirt',12.99
INSERT Products SELECT 2,'Shorts',14.99
INSERT Products SELECT 3,'Pants',19.99
INSERT Products SELECT 4,'Hats',9.99


INSERT dbo.Sales SELECT NEWID(),1,1,4,'2/1/2012'
INSERT dbo.Sales SELECT NEWID(),2,1,1,'3/1/2012'
INSERT dbo.Sales SELECT NEWID(),3,1,2,'2/1/2012'
INSERT dbo.Sales SELECT NEWID(),2,2,2,'4/1/2012'
INSERT dbo.Sales SELECT NEWID(),3,2,1,'3/1/2012'
INSERT dbo.Sales SELECT NEWID(),4,2,2,'1/1/2012'


-- create 1000 random sale records

DECLARE @counter INT
SET @counter = 1

WHILE @counter <= 1000
	BEGIN
		INSERT dbo.Sales
		        SELECT
					NEWID(),
					(ABS(CHECKSUM(NEWID())) % 4) + 1,
					(ABS(CHECKSUM(NEWID())) % 2) + 1,
					(ABS(CHECKSUM(NEWID())) % 9) + 1,
					DATEADD(DAY,ABS(CHECKSUM(NEWID()) % 3650),'2002-4-1')
		SET @counter += 1
		END


-- description : execute each 
 SELECT NEWID()

 SELECT CHECKSUM(NEWID())

 SELECT ABS(CHECKSUM(NEWID()))

 SELECT ABS(CHECKSUM(NEWID())) % 4

 SELECT DATEADD(DAY,ABS(CHECKSUM(NEWID()) % 3650),'1/1/2002')

-- after executing query
SELECT COUNT(*) FROM dbo.Sales