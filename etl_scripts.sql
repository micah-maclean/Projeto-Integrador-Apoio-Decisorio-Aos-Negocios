-- Script ETL (Extract, Transform, Load) para popular o Data Warehouse AdventureWorksDW

-- Simulação de dados de origem (OLTP) para as tabelas de dimensão e fato
-- Em um cenário real, estes dados seriam extraídos de um banco de dados transacional

-- Inserção de dados de exemplo na DimDate
INSERT INTO DimDate (DateKey, FullDate, CalendarYear, CalendarMonth, DayOfMonth, DayOfWeek, DayName, MonthName, Quarter, YearMonth)
VALUES
(20230101, '2023-01-01', 2023, 1, 1, 1, 'Domingo', 'Janeiro', 1, '2023-01'),
(20230102, '2023-01-02', 2023, 1, 2, 2, 'Segunda', 'Janeiro', 1, '2023-01'),
(20230201, '2023-02-01', 2023, 2, 1, 4, 'Quarta', 'Fevereiro', 1, '2023-02'),
(20230301, '2023-03-01', 2023, 3, 1, 4, 'Quarta', 'Março', 1, '2023-03'),
(20240101, '2024-01-01', 2024, 1, 1, 2, 'Segunda', 'Janeiro', 1, '2024-01');

-- Inserção de dados de exemplo na DimProduct
INSERT INTO DimProduct (ProductKey, ProductAlternateKey, ProductName, ProductCategory, ProductSubcategory, StandardCost, ListPrice)
VALUES
(1, 'BK-M68B-42', 'Mountain Bike', 'Bikes', 'Mountain Bikes', 500.00, 1000.00),
(2, 'HL-U509-R', 'Road Helmet', 'Accessories', 'Helmets', 30.00, 60.00),
(3, 'FR-R92B-58', 'Road Bike', 'Bikes', 'Road Bikes', 700.00, 1400.00);

-- Inserção de dados de exemplo na DimCustomer
INSERT INTO DimCustomer (CustomerKey, CustomerAlternateKey, FirstName, MiddleName, LastName, FullName, BirthDate, MaritalStatus, Gender, EmailAddress, AnnualIncome, TotalChildren, Education, Occupation, AddressLine1, City, StateProvinceName, CountryRegionName)
VALUES
(100, 'AW000100', 'João', NULL, 'Silva', 'João Silva', '1980-05-10', 'M', 'M', 'joao.silva@email.com', 60000.00, 2, 'Graduado', 'Engenheiro', 'Rua A, 123', 'São Paulo', 'São Paulo', 'Brasil'),
(101, 'AW000101', 'Maria', NULL, 'Souza', 'Maria Souza', '1992-11-20', 'S', 'F', 'maria.souza@email.com', 45000.00, 0, 'Pós-Graduado', 'Analista', 'Av. B, 456', 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil'),
(102, 'AW000102', 'Pedro', NULL, 'Santos', 'Pedro Santos', '1975-03-15', 'M', 'M', 'pedro.santos@email.com', 80000.00, 3, 'Mestrado', 'Gerente', 'Rua C, 789', 'Belo Horizonte', 'Minas Gerais', 'Brasil');

-- Inserção de dados de exemplo na DimSalesTerritory
INSERT INTO DimSalesTerritory (SalesTerritoryKey, SalesTerritoryAlternateKey, SalesTerritoryRegion, SalesTerritoryCountry, SalesTerritoryGroup)
VALUES
(1, 1, 'Southwest', 'United States', 'North America'),
(2, 2, 'Northeast', 'United States', 'North America'),
(3, 3, 'Central', 'Canada', 'North America');

-- Simulação da tabela de staging (stg_vendas_limpas) baseada no exemplo do documento da 1ª entrega
-- Em um cenário real, esta VIEW seria criada a partir dos dados OLTP e passaria por um processo de limpeza e transformação
CREATE VIEW stg_vendas_limpas AS
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
    (1000.00 * 1) - 0.00 AS LineTotal,
    500.00 AS ProductStandardCost
UNION ALL
SELECT
    1 AS SalesOrderID,
    2 AS SalesOrderDetailID,
    2 AS ProductID,
    100 AS CustomerID,
    20230101 AS OrderDateKey_Source,
    '2023-01-01' AS OrderDate_Source,
    1 AS OrderQty,
    60.00 AS UnitPrice,
    0.00 AS UnitPriceDiscount,
    (60.00 * 1) - 0.00 AS LineTotal,
    30.00 AS ProductStandardCost
UNION ALL
SELECT
    2 AS SalesOrderID,
    1 AS SalesOrderDetailID,
    3 AS ProductID,
    101 AS CustomerID,
    20230201 AS OrderDateKey_Source,
    '2023-02-01' AS OrderDate_Source,
    2 AS OrderQty,
    1400.00 AS UnitPrice,
    0.00 AS UnitPriceDiscount,
    (1400.00 * 2) - 0.00 AS LineTotal,
    700.00 AS ProductStandardCost
UNION ALL
SELECT
    3 AS SalesOrderID,
    1 AS SalesOrderDetailID,
    1 AS ProductID,
    102 AS CustomerID,
    20230301 AS OrderDateKey_Source,
    '2023-03-01' AS OrderDate_Source,
    1 AS OrderQty,
    1000.00 AS UnitPrice,
    0.00 AS UnitPriceDiscount,
    (1000.00 * 1) - 0.00 AS LineTotal,
    500.00 AS ProductStandardCost
UNION ALL
SELECT
    4 AS SalesOrderID,
    1 AS SalesOrderDetailID,
    1 AS ProductID,
    100 AS CustomerID,
    20240101 AS OrderDateKey_Source,
    '2024-01-01' AS OrderDate_Source,
    1 AS OrderQty,
    1000.00 AS UnitPrice,
    0.00 AS UnitPriceDiscount,
    (1000.00 * 1) - 0.00 AS LineTotal,
    500.00 AS ProductStandardCost;

-- Carga (L) na tabela FactInternetSales
-- Realiza o lookup das chaves das dimensões e insere os dados transformados
INSERT INTO FactInternetSales (
    ProductKey,
    OrderDateKey,
    CustomerKey,
    SalesTerritoryKey, -- Assumindo um SalesTerritoryKey padrão para simplificação
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
    dp.ProductKey,
    dd.DateKey,
    dc.CustomerKey,
    dst.SalesTerritoryKey, -- Usando um SalesTerritoryKey fixo para simplificação
    CAST(svl.SalesOrderID AS VARCHAR(20)),
    svl.SalesOrderDetailID,
    svl.OrderQty,
    svl.UnitPrice,
    svl.LineTotal AS ExtendedAmount,
    svl.UnitPriceDiscount AS DiscountAmount,
    svl.ProductStandardCost,
    (svl.ProductStandardCost * svl.OrderQty) AS TotalProductCost,
    svl.LineTotal AS SalesAmount,
    svl.LineTotal * 0.05 AS TaxAmt, -- Exemplo de cálculo de imposto (5%)
    svl.LineTotal * 0.02 AS Freight, -- Exemplo de cálculo de frete (2%)
    CAST(svl.OrderDate_Source AS DATE),
    DATEADD(day, 7, CAST(svl.OrderDate_Source AS DATE)) AS DueDate, -- Exemplo: 7 dias após o pedido
    DATEADD(day, 3, CAST(svl.OrderDate_Source AS DATE)) AS ShipDate -- Exemplo: 3 dias após o pedido
FROM stg_vendas_limpas svl
JOIN DimProduct dp ON svl.ProductID = dp.ProductKey
JOIN DimDate dd ON svl.OrderDateKey_Source = dd.DateKey
JOIN DimCustomer dc ON svl.CustomerID = dc.CustomerKey
JOIN DimSalesTerritory dst ON dst.SalesTerritoryKey = 1; -- Assumindo um SalesTerritoryKey padrão para simplificação
