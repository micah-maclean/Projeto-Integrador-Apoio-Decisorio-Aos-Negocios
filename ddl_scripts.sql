-- Script DDL para criação das tabelas do Data Warehouse AdventureWorksDW

-- Tabela de Dimensão: DimDate
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY, -- Chave primária, ex: YYYYMMDD
    FullDate DATE NOT NULL,
    CalendarYear INT NOT NULL,
    CalendarMonth INT NOT NULL,
    DayOfMonth INT NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName VARCHAR(10) NOT NULL,
    MonthName VARCHAR(10) NOT NULL,
    Quarter INT NOT NULL,
    YearMonth VARCHAR(7) NOT NULL -- Ex: YYYY-MM
);

-- Tabela de Dimensão: DimProduct
CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    ProductAlternateKey VARCHAR(25) UNIQUE NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    ProductCategory VARCHAR(50) NOT NULL,
    ProductSubcategory VARCHAR(50) NOT NULL,
    StandardCost DECIMAL(10, 2),
    ListPrice DECIMAL(10, 2)
);

-- Tabela de Dimensão: DimCustomer
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
);

-- Tabela de Dimensão: DimSalesTerritory
CREATE TABLE DimSalesTerritory (
    SalesTerritoryKey INT PRIMARY KEY,
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
);
