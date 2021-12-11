-- script employee table as drop and create to :)
USE [DemoDb]
GO
-- the IF line , 
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Employees]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Employees]
GO

CREATE TABLE [dbo].[Employees](
	[Id] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](75) NOT NULL,
	[Title] [nvarchar](100) NULL,
	[HireDate] [datetime] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[Salary] [decimal](19, 4) NOT NULL
) ON [PRIMARY]

GO

-- the IF line 
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Products]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Products]
GO


CREATE TABLE [dbo].[Products](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Price] [decimal](19, 4) NOT NULL
) ON [PRIMARY]

GO

-- the IF line
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Sales]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Sales]
GO

CREATE TABLE [dbo].[Sales](
	[Id] [uniqueidentifier] NOT NULL,
	[ProductId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[SaleDate] [date] NULL
) ON [PRIMARY]

GO
