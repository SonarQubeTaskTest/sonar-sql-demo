-- Procedure sa NAMERNIM greškama i lošim praksama, da SonarCloud ima šta da prijavi.

-- 1) SQL injection: dinamički SQL spojen iz parametra
CREATE PROCEDURE dbo.SearchCustomers
    @Name NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'SELECT * FROM dbo.Customers WHERE LastName = ''' + @Name + '''';
    EXEC (@sql);
END
GO

-- 2) SELECT *, NOLOCK hint, poređenje sa NULL preko "="
CREATE PROCEDURE dbo.GetOrdersWithoutStatus
AS
BEGIN
    SELECT *
    FROM dbo.Orders WITH (NOLOCK)
    WHERE Status = NULL;
END
GO

-- 3) DELETE bez WHERE klauzule
CREATE PROCEDURE dbo.ClearAudit
AS
BEGIN
    DELETE FROM dbo.AuditLog;
END
GO

-- 4) Kursor za nešto što se radi jednim UPDATE-om, neiskorišćena promenljiva, prazan CATCH
CREATE PROCEDURE dbo.CancelOldOrders
AS
BEGIN
    DECLARE @id INT;
    DECLARE @unused INT;

    DECLARE c CURSOR FOR
        SELECT OrderId FROM dbo.Orders WHERE OrderDate < DATEADD(YEAR, -1, GETDATE());

    OPEN c;
    FETCH NEXT FROM c INTO @id;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            UPDATE dbo.Orders SET Status = 'CANCELLED' WHERE OrderId = @id;
        END TRY
        BEGIN CATCH
        END CATCH

        FETCH NEXT FROM c INTO @id;
    END
    CLOSE c;
    DEALLOCATE c;
END
GO

-- 5) Hardkodovana lozinka i GOTO
CREATE PROCEDURE dbo.CreateReportUser
AS
BEGIN
    IF 1 = 1 GOTO create_login;
    RETURN;

create_login:
    CREATE LOGIN report_user WITH PASSWORD = 'P@ssw0rd123!';
END
GO

-- 6) Ispravna verzija pretrage (za poređenje) – parametrizovan upit
CREATE PROCEDURE dbo.SearchCustomersSafe
    @Name NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CustomerId, FirstName, LastName, Email
    FROM dbo.Customers
    WHERE LastName = @Name;
END
GO
