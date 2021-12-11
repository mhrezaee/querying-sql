USE DemoDb
GO

-- Simple Transaction with multiple operations treated  as a single operation

BEGIN TRANSACTION 

	UPDATE 
		Sales
	SET
		EmployeeId = (SELECT ManagerId FROM Employees AS e WHERE e.Id = EmployeeId)
	WHERE EmployeeId = 2

	DELETE
		Employees 
	WHERE 
		Id = 2

COMMIT TRANSACTION

GO

-- Simple Tran With Roleback

BEGIN TRANSACTION
	UPDATE 
		Sales
	SET
		EmployeeId = (SELECT ManagerId FROM Employees AS e WHERE e.Id = EmployeeId)
	WHERE EmployeeId = 1

	DELETE
		Employees 
	WHERE 
		Id = 1
	IF @@ROWCOUNT != 0
		ROLLBACK TRANSACTION
	ELSE
		COMMIT TRANSACTION
GO

--Naming and marking Trans
BEGIN TRANSACTION DeleteEmployeeTran
	WITH MARK 'Deleting Employees And Reassigning Sales'

	UPDATE 
		Sales
	SET
		EmployeeId = (SELECT ManagerId FROM Employees AS e WHERE e.Id = EmployeeId)
	WHERE EmployeeId = 3

	DELETE
		Employees 
	WHERE 
		Id = 3

COMMIT TRANSACTION DeleteEmployeeTran
GO

--Distributed Transactions Across multiple Servers

BEGIN DISTRIBUTED TRANSACTION
	UPDATE
		dbo.Products
	SET
		Price *= .01
	WHERE 
		DisContinuedFlag = 1
	
	UPDATE 
		RemoteServer.DemoDb.Products
	SET
		Price *= .01
	WHERE 
		DisContinuedFlag = 1

COMMIT TRANSACTION