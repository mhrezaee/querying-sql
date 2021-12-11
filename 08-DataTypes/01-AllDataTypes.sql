USE DemoDb
GO

IF OBJECT_ID('DataTypeTester', 'U') IS NOT NULL
	DROP TABLE DataTypeTeste
GO

CREATE TABLE DataTypeTester
(
	--Character DataTypes
	[char]				CHAR(3),
	[varchar]			VARCHAR(10),
	[varcharMAX]		VARCHAR(MAX),
	[text]				TEXT,

	-- unicode chracter datatypes
	[nchar]				NCHAR(3),
	[nvarchar]			NVARCHAR(10),
	[nvarcharMAX]		NVARCHAR(MAX),
	[ntext]				NTEXT,

	--binary datatyps
	[bit]				BIT,
	[binary]			BINARY(3),
	[varbinary]			VARBINARY(10),
	[varbinaryMAX]		VARBINARY(MAX),
	[image]				IMAGE,

	--Numeric Datatypes(exact)
	[tinyint]			TINYINT,
	[smallint]			SMALLINT,
	[int]				INT,
	[bigint]			BIGINT,
	[decimal]			DECIMAL(14,6),
	[numeric]			NUMERIC(14,6),
	[smallmoney]		SMALLMONEY,
	[money]				MONEY,

	--Numeric DataTypes (approx)
	[float]				FLOAT,
	[real]				REAL,

	--Date data types
	[datetime]			DATETIME,
	[datetime2]			DATETIME2,
	[smalldatetime]		SMALLDATETIME,
	[date]				DATE,
	[time]				TIME,
	[datetimeoffset]	DATETIMEOFFSET,
	[timestanp]			TIMESTAMP,

	--special data types
	[sql_varuant]		SQL_VARIANT,
	[uniqueidentifier]	UNIQUEIDENTIFIER,
	[xml]				XML,
	[hierarchyid]		HIERARCHYID,

	-- special data types
	[geometry]			GEOMETRY,
	[geography]			GEOGRAPHY
)
GO
INSERT INTO dbo.DataTypeTester
        ( char , varchar , varcharMAX , text , nchar , nvarchar , nvarcharMAX , ntext ,
          bit , binary , varbinary , varbinaryMAX , image , tinyint , smallint , int ,
          bigint , decimal , numeric , smallmoney , money , float , real , datetime , datetime2 ,
          smalldatetime , date , time , datetimeoffset , timestanp , sql_varuant , uniqueidentifier ,
          xml , hierarchyid , geometry , geography
        )
VALUES  (
		 --character data
		  'ABC' , -- char - char(3)
          'Varying' , -- varchar - varchar(10)
          'MAX of over 1billion chars (varying)' , -- varcharMAX - varchar(max)
          'up to 2 GB of data' , -- text - text

		  --unicode character data
          N'���' , -- nchar - nchar(3)
          N'���� ���' , -- nvarchar - nvarchar(10)
          N'� ���� ��ѐ' , -- nvarcharMAX - nvarchar(max)
          N'� ���� ���� ��ѐ' , -- ntext - ntext

		  --binar data
          0 , -- bit - bit
          CAST('ABC' AS BINARY) , -- binary - binary
          CAST('Varying' AS VARBINARY(10)) , -- varbinary - varbinary(10)
          CAST('max of 2GB varbinary(binarying)' AS VARBINARY(max)) , -- varbinaryMAX - varbinary(max)
          (SELECT * FROM OPENROWSET(BULK 'C:\path to an image.jpg', SINGLE_BLOB) i) , -- image - image

		  --numeric data
          255 , -- tinyint - tinyint
          32767 , -- smallint - smallint
          2147483647 , -- int - int
          9223372036854775807 , -- bigint - bigint
          99999999.9999 , -- decimal - decimal
          99999999.9999 , -- numeric - numeric
          214748.3647 , -- smallmoney - smallmoney
          922337203685477.5807 , -- money - money

		  -- numerc data approx
          1.79E+38 , -- float - float
          3.4E+38 , -- real - real

		  -- dateTime data
          GETDATE() , -- datetime - datetime
          SYSDATETIME() , -- datetime2 - datetime2
          CAST(GETDATE() AS SMALLDATETIME) , -- smalldatetime - smalldatetime
          CAST(GETDATE() AS DATE) , -- date - date
          CONVERT(VARCHAR(12), GETDATE(),14) , -- time - time
          TODATETIMEOFFSET(GETDATE(), '-05:00') , -- datetimeoffset - datetimeoffset
          NULL , -- timestanp - timestamp

		  -- special data
          GETDATE() , -- sql_varuant - sql_variant
          NEWID() , -- uniqueidentifier - uniqueidentifier
          '<XMLRoot>
				<person>
					<FirstName>Ahmad</FirstName>
					<LastName>Ahmadi</LastName>
				</person>
		   </XMLRoot>' , -- xml - xml
          NULL , -- hierarchyid - hierarchyid

		  --speical data
          geometry::STGeomFromText('LINESTRING(1 1, 5 1, 3 5, 1 1)', 0) , -- geometry - geometry
          NULL  -- geography - geography
        )
GO

SELECT * FROM DataTypeTester