-- ============================================
-- Script DDL para criação das tabelas do Data Warehouse AdventureWorksDW
-- ============================================

-- Tabela de Dimensão: DimDate
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY, -- Chave substituta no formato YYYYMMDD
    FullDate DATE NOT NULL,
    CalendarYear INT NOT NULL CHECK (CalendarYear >= 1900),
    CalendarMonth INT NOT NULL CHECK (CalendarMonth BETWEEN 1 AND 12),
    DayOfMonth INT NOT NULL CHECK (DayOfMonth BETWEEN 1 AND 31),
    DayOfWeek INT NOT NULL CHECK (DayOfWeek BETWEEN 1 AND 7),
    DayName VARCHAR(15) NOT NULL,
    MonthName VARCHAR(15) NOT NULL,
    Quarter INT NOT NULL CHECK (Quarter BETWEEN 1 AND 4),
    YearMonth CHAR(7) NOT NULL -- Ex: YYYY-MM
);

-- Tabela de Dimensão: DimProduct
CREATE TABLE DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductAlternateKey VARCHAR(25) UNIQUE NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    ProductCategory VARCHAR(50) NOT NULL,
    ProductSubcategory VARCHAR(50) NOT NULL,
    StandardCost DECIMAL(18, 2) CHECK (StandardCost >= 0),
    ListPrice DECIMAL(18, 2) CHECK (ListPrice >= 0)
);

-- Tabela de Dimensão: DimCustomer
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerAlternateKey VARCHAR(15) UNIQUE NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    FullName AS (FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName) PERSISTED,
    BirthDate DATE,
    MaritalStatus CHAR(1) CHECK (MaritalStatus IN ('S','M')),
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    EmailAddress VARCHAR(100),
    AnnualIncome DECIMAL(18, 2) CHECK (AnnualIncome >= 0),
    TotalChildren INT CHECK (TotalChildren >= 0),
    Education VARCHAR(50),
    Occupation VARCHAR(50),
    AddressLine1 VARCHAR(100),
    City VARCHAR(50),
    StateProvinceName VARCHAR(50),
    CountryRegionName VARCHAR(50)
);

-- Tabela de Dimensão: DimSalesTerritory
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT IDENTITY(1,1) PRIMARY KEY,
    SalesTerritoryAlternateKey INT UNIQUE NOT NULL,
    SalesTerritoryRegion VARCHAR(50) NOT NULL,
    SalesTerritoryCountry VARCHAR(50) NOT NULL,
    SalesTerritoryGroup VARCHAR(50) NOT NULL
);

-- Tabela de Fato: FactInternetSales
CREATE TABLE FactInternetSales (
    ProductKey INT NOT NULL,
    OrderDateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    SalesTerritoryKey INT NOT NULL,
    SalesOrderNumber VARCHAR(20) NOT NULL,
    SalesOrderLineNumber INT NOT NULL,
    OrderQuantity INT NOT NULL CHECK (OrderQuantity > 0),
    UnitPrice DECIMAL(18, 2) NOT NULL CHECK (UnitPrice >= 0),
    ExtendedAmount DECIMAL(18, 2) NOT NULL CHECK (ExtendedAmount >= 0),
    DiscountAmount DECIMAL(18, 2) NOT NULL CHECK (DiscountAmount >= 0),
    ProductStandardCost DECIMAL(18, 2) NOT NULL CHECK (ProductStandardCost >= 0),
    TotalProductCost DECIMAL(18, 2) NOT NULL CHECK (TotalProductCost >= 0),
    SalesAmount DECIMAL(18, 2) NOT NULL CHECK (SalesAmount >= 0),
    TaxAmt DECIMAL(18, 2) NOT NULL CHECK (TaxAmt >= 0),
    Freight DECIMAL(18, 2) NOT NULL CHECK (Freight >= 0),
    OrderDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ShipDate DATE NOT NULL,
    
    PRIMARY KEY (SalesOrderNumber, SalesOrderLineNumber),
    FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey),
    FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    FOREIGN KEY (SalesTerritoryKey) REFERENCES DimSalesTerritory(SalesTerritoryKey)
);

-- Índices adicionais para otimizar consultas analíticas
CREATE INDEX IX_FactInternetSales_ProductKey ON FactInternetSales(ProductKey);
CREATE INDEX IX_FactInternetSales_CustomerKey ON FactInternetSales(CustomerKey);
CREATE INDEX IX_FactInternetSales_OrderDateKey ON FactInternetSales(OrderDateKey);
