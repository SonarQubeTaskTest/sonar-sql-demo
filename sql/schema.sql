-- Šema za demo: mala prodavnica
CREATE TABLE dbo.Customers (
    CustomerId   INT IDENTITY(1,1) PRIMARY KEY,
    FirstName    NVARCHAR(50)  NOT NULL,
    LastName     NVARCHAR(50)  NOT NULL,
    Email        NVARCHAR(100) NOT NULL,
    CreatedAt    DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE dbo.Orders (
    OrderId      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId   INT NOT NULL REFERENCES dbo.Customers(CustomerId),
    OrderDate    DATETIME2 NOT NULL,
    Total        DECIMAL(10,2) NOT NULL,
    Status       VARCHAR(20) NOT NULL
);
GO

-- Tabela bez primarnog ključa (Sonar ovo može prijaviti)
CREATE TABLE dbo.AuditLog (
    Message      NVARCHAR(MAX),
    LoggedAt     DATETIME
);
GO
