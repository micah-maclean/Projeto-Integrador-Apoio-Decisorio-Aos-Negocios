-- Script ETL (Extract, Transform, Load) para popular o Data Warehouse AdventureWorksDW
-- Este script usa os dados de origem carregados a partir de data.sql

USE adventureWorksDW;

-- Limpar as dimensões para recarregar com dados reais
TRUNCATE TABLE DimDate;
TRUNCATE TABLE DimProduct;
TRUNCATE TABLE DimCustomer;
TRUNCATE TABLE DimSalesTerritory;

-- Inserção de dados reais na DimDate a partir das datas de origem
INSERT INTO DimDate (DateKey, FullDate, CalendarYear, CalendarMonth, DayOfMonth, DayOfWeek, DayName, MonthName, Quarter, YearMonth)
SELECT DISTINCT
    DATE_FORMAT(soh.OrderDate, '%Y%m%d') AS DateKey,
    DATE(soh.OrderDate) AS FullDate,
    YEAR(soh.OrderDate) AS CalendarYear,
    MONTH(soh.OrderDate) AS CalendarMonth,
    DAY(soh.OrderDate) AS DayOfMonth,
    DAYOFWEEK(soh.OrderDate) AS DayOfWeek,
    DAYNAME(soh.OrderDate) AS DayName,
    MONTHNAME(soh.OrderDate) AS MonthName,
    QUARTER(soh.OrderDate) AS Quarter,
    DATE_FORMAT(soh.OrderDate, '%Y-%m') AS YearMonth
FROM db.`SalesLT.SalesOrderHeader` soh;

-- Inserção de dados reais na DimProduct a partir da origem
INSERT IGNORE INTO DimProduct (ProductKey, ProductAlternateKey, ProductName, ProductCategory, ProductSubcategory, StandardCost, ListPrice)
SELECT DISTINCT
    p.ProductID AS ProductKey,
    p.ProductNumber AS ProductAlternateKey,
    p.Name AS ProductName,
    'Produto' AS ProductCategory,
    'Sem Categoria' AS ProductSubcategory,
    COALESCE(p.StandardCost, 0) AS StandardCost,
    COALESCE(p.ListPrice, 0) AS ListPrice
FROM db.`SalesLT.Product` p;

-- Inserção de dados reais na DimCustomer a partir da origem
INSERT IGNORE INTO DimCustomer (CustomerKey, CustomerAlternateKey, FirstName, MiddleName, LastName, FullName, BirthDate, MaritalStatus, Gender, EmailAddress, AnnualIncome, TotalChildren, Education, Occupation, AddressLine1, City, StateProvinceName, CountryRegionName)
SELECT DISTINCT
    c.CustomerID AS CustomerKey,
    CAST(c.CustomerID AS CHAR(20)) AS CustomerAlternateKey,
    c.FirstName,
    c.MiddleName,
    c.LastName,
    CONCAT(COALESCE(c.FirstName, ''), ' ', COALESCE(c.LastName, '')) AS FullName,
    NULL AS BirthDate,
    'U' AS MaritalStatus,
    'M' AS Gender,
    c.EmailAddress,
    0.00 AS AnnualIncome,
    0 AS TotalChildren,
    'Desconhecido' AS Education,
    'Cliente' AS Occupation,
    '' AS AddressLine1,
    '' AS City,
    '' AS StateProvinceName,
    '' AS CountryRegionName
FROM db.`SalesLT.Customer` c
WHERE c.CustomerID IN (SELECT DISTINCT CustomerID FROM db.`SalesLT.SalesOrderHeader`);

-- Inserção de dados na DimSalesTerritory
INSERT INTO DimSalesTerritory (SalesTerritoryKey, SalesTerritoryAlternateKey, SalesTerritoryRegion, SalesTerritoryCountry, SalesTerritoryGroup)
VALUES
(1, 1, 'Southwest', 'United States', 'North America'),
(2, 2, 'Northeast', 'United States', 'North America'),
(3, 3, 'Central', 'Canada', 'North America');

-- Cria a view de staging a partir das tabelas de origem carregadas em data.sql
DROP VIEW IF EXISTS stg_vendas_limpas;
CREATE VIEW stg_vendas_limpas AS
SELECT
    sod.SalesOrderID,
    sod.SalesOrderDetailID,
    sod.ProductID,
    soh.CustomerID,
    DATE_FORMAT(soh.OrderDate, '%Y%m%d') AS OrderDateKey_Source,
    DATE(soh.OrderDate) AS OrderDate_Source,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    (sod.UnitPrice * sod.OrderQty) - sod.UnitPriceDiscount AS LineTotal,
    p.StandardCost AS ProductStandardCost
FROM db.`SalesLT.SalesOrderDetail` sod
JOIN db.`SalesLT.SalesOrderHeader` soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN db.`SalesLT.Product` p ON sod.ProductID = p.ProductID;

-- Limpar FactInternetSales e recarregar
TRUNCATE TABLE FactInternetSales;

-- Carga (L) na tabela FactInternetSales
INSERT INTO FactInternetSales (
    ProductKey,
    OrderDateKey,
    CustomerKey,
    SalesTerritoryKey,
    SalesOrderNumber,
    SalesOrderLineNumber,
    OrderQuantity,
    UnitPrice,
    ExtendedAmount,
    DiscountAmount,
    ProductStandardCost,
    TotalProductCost,
    SalesAmount,
    TaxAmt,
    Freight,
    OrderDate,
    DueDate,
    ShipDate
)
SELECT
    COALESCE(dp.ProductKey, -1) AS ProductKey,
    COALESCE(dd.DateKey, '00000000') AS DateKey,
    COALESCE(dc.CustomerKey, -1) AS CustomerKey,
    COALESCE(dst.SalesTerritoryKey, 1) AS SalesTerritoryKey,
    CAST(svl.SalesOrderID AS CHAR(20)),
    svl.SalesOrderDetailID,
    svl.OrderQty,
    svl.UnitPrice,
    svl.LineTotal AS ExtendedAmount,
    svl.UnitPriceDiscount AS DiscountAmount,
    svl.ProductStandardCost,
    (svl.ProductStandardCost * svl.OrderQty) AS TotalProductCost,
    svl.LineTotal AS SalesAmount,
    svl.LineTotal * 0.05 AS TaxAmt,
    svl.LineTotal * 0.02 AS Freight,
    CAST(svl.OrderDate_Source AS DATE),
    DATE_ADD(CAST(svl.OrderDate_Source AS DATE), INTERVAL 7 DAY) AS DueDate,
    DATE_ADD(CAST(svl.OrderDate_Source AS DATE), INTERVAL 3 DAY) AS ShipDate
FROM stg_vendas_limpas svl
LEFT JOIN DimProduct dp ON svl.ProductID = dp.ProductKey
LEFT JOIN DimDate dd ON svl.OrderDateKey_Source = dd.DateKey
LEFT JOIN DimCustomer dc ON svl.CustomerID = dc.CustomerKey
LEFT JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = 1;

