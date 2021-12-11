-- copy from 4-Unique
USE [DemoDb]
GO
 
IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Employees]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Employees]
GO
CREATE TABLE [dbo].[Employees](
	[Id] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY, -- primary key added :)
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](75) NOT NULL,
	[Title] [nvarchar](100) NULL DEFAULT('New Hire'),
	[HireDate] [datetime] NOT NULL CONSTRAINT DF_HireDate DEFAULT(GETDATE()) CHECK(DATEDIFF(d,GETDATE(),HireDate) <= 0),
	[VacationHours] [smallint] NOT NULL DEFAULT (0),
	[Salary] [decimal](19, 4) NOT NULL,
	CONSTRAINT U_Employeee UNIQUE NONCLUSTERED(FirstName,LastName,HireDate)
) ON [PRIMARY]

GO

IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Products]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Products]
GO

CREATE TABLE [dbo].[Products](
	[Id] [int] NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](200) NOT NULL UNIQUE NONCLUSTERED,
	[Price] [decimal](19, 4) NOT NULL CONSTRAINT CHK_Price CHECK(Price > 0),
	[DisContinuedFlag] [bit] NOT NULL CONSTRAINT DF_DiscontinuedFlag DEFAULT(0),
	CONSTRAINT PK_ProductId PRIMARY KEY CLUSTERED(Id ASC) -- second way to creaete Primary key, it is exactly the table above.
) ON [PRIMARY]

GO

IF EXISTS ( SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[Sales]') AND OBJECTPROPERTY(id,N'IsUserTable') = 1)

DROP TABLE [dbo].[Sales]
GO
CREATE TABLE [dbo].[Sales](
	[Id] [uniqueidentifier] NOT NULL DEFAULT NEWID(),
	[ProductId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[SaleDate] [date] NULL CONSTRAINT DF_SaleDate DEFAULT (GETDATE()),
	CONSTRAINT CHK_QuantitySaleDate CHECK(Quantity > 0 AND DATEDIFF(d,GETDATE(),SaleDate) <= 0),
	CONSTRAINT PK_SaleId PRIMARY KEY CLUSTERED(Id ASC)  -- these 2 line :D  
		WITH (IGNORE_DUP_KEY = OFF) -- for ignoring adding duplicates,
		-- for adding other options use comma (,)
) ON [PRIMARY]
SELECT NEWID()
GO

