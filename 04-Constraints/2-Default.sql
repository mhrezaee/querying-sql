-- copy from 1-nulls
USE [DemoDb]
GO

-- th IF line is added by me , 
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
	[VacationHours] [smallint] NOT NULL DEFAULT (0), -- sql server name this constraint automtically, this line added by me :)
	[Salary] [decimal](19, 4) NOT NULL
) ON [PRIMARY]

GO

-- th IF line is added by me , 
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Products]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Products]
GO

-- create products table with null / not null and default constraint 
CREATE TABLE [dbo].[Products](
	[Id] [int] NOT NULL IDENTITY(1,1), -- identity added by me
	[Name] [nvarchar](200) NOT NULL,
	[Price] [decimal](19, 4) NOT NULL,
	[DisContinuedFlag] [bit] NOT NULL CONSTRAINT DF_DiscontinuedFlag DEFAULT(0) -- added by me
) ON [PRIMARY]

GO

-- th IF line is added by me ,
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Sales]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Sales]
GO
-- create sales table with null / not null and default constarintsw
CREATE TABLE [dbo].[Sales](
	[Id] [uniqueidentifier] NOT NULL DEFAULT NEWID(), -- added by me
	[ProductId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[SaleDate] [date] NULL CONSTRAINT DF_SaleDate DEFAULT (GETDATE())
) ON [PRIMARY]

GO
SELECT NEWID()
-- chon ye View behesh set shode nemizare run she in , view ro delete kon :D
-- sepas jadvale Sales ro edit top 200 kon va 3 meghdare vasat ro 1 meghdar dehi kon va hit execute kon (Ctrl + R) ta mghadire default ro khdoesh meghdar dehi kone ;)