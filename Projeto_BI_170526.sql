CREATE DATABASE projeto_bi;
USE projeto_bi;

-- ==================== DIMENSÕES ====================

-- Dimensão Tempo
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    CalendarYear INT NOT NULL,
    CalendarMonth INT NOT NULL,
    DayOfMonth INT NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName VARCHAR(10) NOT NULL,
    MonthName VARCHAR(10) NOT NULL,
    Quarter INT NOT NULL,
    YearMonth VARCHAR(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dimensão Produto
CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    ProductAlternateKey VARCHAR(25) UNIQUE NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    ProductCategory VARCHAR(50) NOT NULL,
    ProductSubcategory VARCHAR(50) NOT NULL,
    StandardCost DECIMAL(10, 2),
    ListPrice DECIMAL(10, 2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dimensão Cliente
CREATE TABLE DimCustomer (
    CustomerKey INT PRIMARY KEY,
    CustomerAlternateKey VARCHAR(15) UNIQUE NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    FullName VARCHAR(150) NOT NULL,
    BirthDate DATE,
    MaritalStatus CHAR(1),
    Gender CHAR(1),
    EmailAddress VARCHAR(50),
    AnnualIncome DECIMAL(10, 2),
    TotalChildren INT,
    Education VARCHAR(50),
    Occupation VARCHAR(50),
    AddressLine1 VARCHAR(100),
    City VARCHAR(30),
    StateProvinceName VARCHAR(50),
    CountryRegionName VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dimensão Território
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT PRIMARY KEY,
    SalesTerritoryAlternateKey INT UNIQUE NOT NULL,
    SalesTerritoryRegion VARCHAR(50) NOT NULL,
    SalesTerritoryCountry VARCHAR(50) NOT NULL,
    SalesTerritoryGroup VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==================== TABELA FATO ====================

CREATE TABLE FactInternetSales (
    ProductKey INT NOT NULL,
    OrderDateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    SalesTerritoryKey INT NOT NULL,
    SalesOrderNumber VARCHAR(20) NOT NULL,
    SalesOrderLineNumber INT NOT NULL,
    OrderQuantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    ExtendedAmount DECIMAL(10, 2) NOT NULL,
    DiscountAmount DECIMAL(10, 2) NOT NULL,
    ProductStandardCost DECIMAL(10, 2) NOT NULL,
    TotalProductCost DECIMAL(10, 2) NOT NULL,
    SalesAmount DECIMAL(10, 2) NOT NULL,
    TaxAmt DECIMAL(10, 2) NOT NULL,
    Freight DECIMAL(10, 2) NOT NULL,
    OrderDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ShipDate DATE NOT NULL,
    
    PRIMARY KEY (SalesOrderNumber, SalesOrderLineNumber),
    FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey),
    FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    FOREIGN KEY (SalesTerritoryKey) REFERENCES DimSalesTerritory(SalesTerritoryKey)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==================== DADOS DE EXEMPLO ====================

-- DimDate
INSERT INTO DimDate (DateKey, FullDate, CalendarYear, CalendarMonth, DayOfMonth, DayOfWeek, DayName, MonthName, Quarter, YearMonth)
VALUES
(20230101, '2023-01-01', 2023, 1, 1, 1, 'Domingo', 'Janeiro', 1, '2023-01'),
(20230102, '2023-01-02', 2023, 1, 2, 2, 'Segunda', 'Janeiro', 1, '2023-01'),
(20230201, '2023-02-01', 2023, 2, 1, 4, 'Quarta', 'Fevereiro', 1, '2023-02'),
(20230301, '2023-03-01', 2023, 3, 1, 4, 'Quarta', 'Março', 1, '2023-03'),
(20240101, '2024-01-01', 2024, 1, 1, 2, 'Segunda', 'Janeiro', 1, '2024-01');

-- DimProduct
INSERT INTO DimProduct (ProductKey, ProductAlternateKey, ProductName, ProductCategory, ProductSubcategory, StandardCost, ListPrice)
VALUES
(1, 'BK-M68B-42', 'Mountain Bike', 'Bikes', 'Mountain Bikes', 500.00, 1000.00),
(2, 'HL-U509-R', 'Road Helmet', 'Accessories', 'Helmets', 30.00, 60.00),
(3, 'FR-R92B-58', 'Road Bike', 'Bikes', 'Road Bikes', 700.00, 1400.00);

-- DimCustomer
INSERT INTO DimCustomer (CustomerKey, CustomerAlternateKey, FirstName, MiddleName, LastName, FullName, BirthDate, MaritalStatus, Gender, EmailAddress, AnnualIncome, TotalChildren, Education, Occupation, AddressLine1, City, StateProvinceName, CountryRegionName)
VALUES
(100, 'AW000100', 'João', NULL, 'Silva', 'João Silva', '1980-05-10', 'M', 'M', 'joao.silva@email.com', 60000.00, 2, 'Graduado', 'Engenheiro', 'Rua A, 123', 'São Paulo', 'São Paulo', 'Brasil'),
(101, 'AW000101', 'Maria', NULL, 'Souza', 'Maria Souza', '1992-11-20', 'S', 'F', 'maria.souza@email.com', 45000.00, 0, 'Pós-Graduado', 'Analista', 'Av. B, 456', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil'),
(102, 'AW000102', 'Pedro', NULL, 'Santos', 'Pedro Santos', '1975-03-15', 'M', 'M', 'pedro.santos@email.com', 80000.00, 3, 'Mestrado', 'Gerente', 'Rua C, 789', 'Belo Horizonte', 'Minas Gerais', 'Brasil');

-- DimSalesTerritory
INSERT INTO DimSalesTerritory (SalesTerritoryKey, SalesTerritoryAlternateKey, SalesTerritoryRegion, SalesTerritoryCountry, SalesTerritoryGroup)
VALUES
(1, 1, 'Southwest', 'United States', 'North America'),
(2, 2, 'Northeast', 'United States', 'North America'),
(3, 3, 'Central', 'Canada', 'North America');

-- ==================== STAGING (VIEW) ====================

CREATE OR REPLACE VIEW stg_vendas_limpas AS
SELECT
    1 AS SalesOrderID,
    1 AS SalesOrderDetailID,
    1 AS ProductID,
    100 AS CustomerID,
    20230101 AS OrderDateKey_Source,
    '2023-01-01' AS OrderDate_Source,
    1 AS OrderQty,
    1000.00 AS UnitPrice,
    0.00 AS UnitPriceDiscount,
    (1000.00 * 1) AS LineTotal,
    500.00 AS ProductStandardCost
UNION ALL
SELECT 1, 2, 2, 100, 20230101, '2023-01-01', 1, 60.00, 0.00, 60.00, 30.00
UNION ALL
SELECT 2, 1, 3, 101, 20230201, '2023-02-01', 2, 1400.00, 0.00, 2800.00, 700.00
UNION ALL
SELECT 3, 1, 1, 102, 20230301, '2023-03-01', 1, 1000.00, 0.00, 1000.00, 500.00
UNION ALL
SELECT 4, 1, 1, 100, 20240101, '2024-01-01', 1, 1000.00, 0.00, 1000.00, 500.00;

-- ==================== CARGA NA TABELA FATO ====================

INSERT INTO FactInternetSales (
    ProductKey, OrderDateKey, CustomerKey, SalesTerritoryKey,
    SalesOrderNumber, SalesOrderLineNumber, OrderQuantity,
    UnitPrice, ExtendedAmount, DiscountAmount,
    ProductStandardCost, TotalProductCost, SalesAmount,
    TaxAmt, Freight, OrderDate, DueDate, ShipDate
)
SELECT
    dp.ProductKey,
    dd.DateKey,
    dc.CustomerKey,
    1 AS SalesTerritoryKey,                    -- Valor fixo por enquanto
    CAST(svl.SalesOrderID AS CHAR(20)),
    svl.SalesOrderDetailID,
    svl.OrderQty,
    svl.UnitPrice,
    svl.LineTotal AS ExtendedAmount,
    svl.UnitPriceDiscount AS DiscountAmount,
    svl.ProductStandardCost,
    (svl.ProductStandardCost * svl.OrderQty) AS TotalProductCost,
    svl.LineTotal AS SalesAmount,
    svl.LineTotal * 0.05 AS TaxAmt,           -- 5% de imposto
    svl.LineTotal * 0.02 AS Freight,          -- 2% de frete
    CAST(svl.OrderDate_Source AS DATE),
    DATE_ADD(CAST(svl.OrderDate_Source AS DATE), INTERVAL 7 DAY) AS DueDate,
    DATE_ADD(CAST(svl.OrderDate_Source AS DATE), INTERVAL 3 DAY) AS ShipDate
FROM stg_vendas_limpas svl
JOIN DimProduct dp ON svl.ProductID = dp.ProductKey
JOIN DimDate dd ON svl.OrderDateKey_Source = dd.DateKey
JOIN DimCustomer dc ON svl.CustomerID = dc.CustomerKey;

-- ==================== VERIFICAÇÃO ====================

SELECT 'DimDate' AS Tabela, COUNT(*) AS Registros FROM DimDate
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM DimProduct
UNION ALL
SELECT 'DimCustomer', COUNT(*) FROM DimCustomer
UNION ALL
SELECT 'DimSalesTerritory', COUNT(*) FROM DimSalesTerritory
UNION ALL
SELECT 'FactInternetSales', COUNT(*) FROM FactInternetSales
UNION ALL
SELECT 'stg_vendas_limpas (View)', COUNT(*) FROM stg_vendas_limpas;

-- Ver dados da fato
SELECT * FROM FactInternetSales LIMIT 10;



