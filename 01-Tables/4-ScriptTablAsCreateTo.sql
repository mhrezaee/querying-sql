USE [DemoDb]
GO

SET ANSI_NULLS ON
GO
-- begin code added by me for proofing ansi standard null ON and OFF
IF NULL = NULL
	PRINT 'yes ... null = null'
ELSE
	PRINT 'no ... null <> null'
	-- end code added by me

SET QUOTED_IDENTIFIER ON
GO
-- added code by me to proof Quoted Identifier On And Off
CREATE TABLE "SELECT"
(
	Id	INT  NOT NULL
)
-- end of code added by me
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
) ON [PRIMARY] -- Database Properties -> FileGroups :)

GO