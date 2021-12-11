-- copy from 1-nulls
USE [DemoDb]
GO

-- the IF line, 
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Employees]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Employees]
GO
-- create employee table with null / not null and default constraints
CREATE TABLE [dbo].[Employees](
	[Id] [int] NOT NULL IDENTITY(1,1), -- identity added by me
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](75) NOT NULL,
	[Title] [nvarchar](100) NULL DEFAULT('New Hire'),
	[HireDate] [datetime] NOT NULL CONSTRAINT DF_HireDate DEFAULT(GETDATE()), -- this line added :)
	[VacationHours] [smallint] NOT NULL DEFAULT (0), -- sql server name this constraint automtically :)
	[Salary] [decimal](19, 4) NOT NULL
) ON [PRIMARY]

GO

-- the IF line, 
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Products]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Products]
GO

-- create products table with null / not null and default constraint 
CREATE TABLE [dbo].[Products](
	[Id] [int] NOT NULL IDENTITY(1,1), -- identity added
	[Name] [nvarchar](200) NOT NULL,
	[Price] [decimal](19, 4) NOT NULL,
	[DisContinuedFlag] [bit] NOT NULL CONSTRAINT DF_DiscontinuedFlag DEFAULT(0) -- this line is added
) ON [PRIMARY]

GO

-- th IF line is added by me ,
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Sales]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Sales]
GO
-- create sales table with null / not null and default constarintsw
CREATE TABLE [dbo].[Sales](
	[Id] [uniqueidentifier] NOT NULL DEFAULT NEWID(), -- this line added
	[ProductId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[SaleDate] [date] NULL CONSTRAINT DF_SaleDate DEFAULT (GETDATE())
) ON [PRIMARY]

GO
SELECT NEWID()
--because one View is set to this, it will not created , please delete the view first :D
-- the right click on Sales table and click on edit top 200 rows, and make 3 data inside it to 1 and hit execute then (Ctrl + R) to see the default value added by default ;)