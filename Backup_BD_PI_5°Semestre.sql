CREATE DATABASE  IF NOT EXISTS `gestao_bases_dados_empresariais` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `gestao_bases_dados_empresariais`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: gestao_bases_dados_empresariais
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dimcustomer`
--

DROP TABLE IF EXISTS `dimcustomer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dimcustomer` (
  `CustomerKey` int NOT NULL,
  `CustomerAlternateKey` varchar(15) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `MiddleName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) NOT NULL,
  `FullName` varchar(150) NOT NULL,
  `BirthDate` date DEFAULT NULL,
  `MaritalStatus` char(1) DEFAULT NULL,
  `Gender` char(1) DEFAULT NULL,
  `EmailAddress` varchar(50) DEFAULT NULL,
  `AnnualIncome` decimal(10,2) DEFAULT NULL,
  `TotalChildren` int DEFAULT NULL,
  `Education` varchar(50) DEFAULT NULL,
  `Occupation` varchar(50) DEFAULT NULL,
  `AddressLine1` varchar(100) DEFAULT NULL,
  `City` varchar(30) DEFAULT NULL,
  `StateProvinceName` varchar(50) DEFAULT NULL,
  `CountryRegionName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CustomerKey`),
  UNIQUE KEY `CustomerAlternateKey` (`CustomerAlternateKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimcustomer`
--

LOCK TABLES `dimcustomer` WRITE;
/*!40000 ALTER TABLE `dimcustomer` DISABLE KEYS */;
INSERT INTO `dimcustomer` VALUES (100,'AW000100','João',NULL,'Silva','João Silva','1980-05-10','M','M','joao.silva@email.com',60000.00,2,'Graduado','Engenheiro','Rua A, 123','São Paulo','São Paulo','Brasil'),(101,'AW000101','Maria',NULL,'Souza','Maria Souza','1992-11-20','S','F','maria.souza@email.com',45000.00,0,'Pós-Graduado','Analista','Av. B, 456','Rio de Janeiro','Rio de Janeiro','Brasil'),(102,'AW000102','Pedro',NULL,'Santos','Pedro Santos','1975-03-15','M','M','pedro.santos@email.com',80000.00,3,'Mestrado','Gerente','Rua C, 789','Belo Horizonte','Minas Gerais','Brasil');
/*!40000 ALTER TABLE `dimcustomer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dimdate`
--

DROP TABLE IF EXISTS `dimdate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dimdate` (
  `DateKey` int NOT NULL,
  `FullDate` date NOT NULL,
  `CalendarYear` int NOT NULL,
  `CalendarMonth` int NOT NULL,
  `DayOfMonth` int NOT NULL,
  `DayOfWeek` int NOT NULL,
  `DayName` varchar(10) NOT NULL,
  `MonthName` varchar(10) NOT NULL,
  `Quarter` int NOT NULL,
  `YearMonth` varchar(7) NOT NULL,
  PRIMARY KEY (`DateKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimdate`
--

LOCK TABLES `dimdate` WRITE;
/*!40000 ALTER TABLE `dimdate` DISABLE KEYS */;
INSERT INTO `dimdate` VALUES (20230101,'2023-01-01',2023,1,1,1,'Domingo','Janeiro',1,'2023-01'),(20230102,'2023-01-02',2023,1,2,2,'Segunda','Janeiro',1,'2023-01'),(20230201,'2023-02-01',2023,2,1,4,'Quarta','Fevereiro',1,'2023-02'),(20230301,'2023-03-01',2023,3,1,4,'Quarta','Março',1,'2023-03'),(20240101,'2024-01-01',2024,1,1,2,'Segunda','Janeiro',1,'2024-01');
/*!40000 ALTER TABLE `dimdate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dimproduct`
--

DROP TABLE IF EXISTS `dimproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dimproduct` (
  `ProductKey` int NOT NULL,
  `ProductAlternateKey` varchar(25) NOT NULL,
  `ProductName` varchar(50) NOT NULL,
  `ProductCategory` varchar(50) NOT NULL,
  `ProductSubcategory` varchar(50) NOT NULL,
  `StandardCost` decimal(10,2) DEFAULT NULL,
  `ListPrice` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ProductKey`),
  UNIQUE KEY `ProductAlternateKey` (`ProductAlternateKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimproduct`
--

LOCK TABLES `dimproduct` WRITE;
/*!40000 ALTER TABLE `dimproduct` DISABLE KEYS */;
INSERT INTO `dimproduct` VALUES (1,'BK-M68B-42','Mountain Bike','Bikes','Mountain Bikes',500.00,1000.00),(2,'HL-U509-R','Road Helmet','Accessories','Helmets',30.00,60.00),(3,'FR-R92B-58','Road Bike','Bikes','Road Bikes',700.00,1400.00);
/*!40000 ALTER TABLE `dimproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dimsalesterritory`
--

DROP TABLE IF EXISTS `dimsalesterritory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dimsalesterritory` (
  `SalesTerritoryKey` int NOT NULL,
  `SalesTerritoryAlternateKey` int NOT NULL,
  `SalesTerritoryRegion` varchar(50) NOT NULL,
  `SalesTerritoryCountry` varchar(50) NOT NULL,
  `SalesTerritoryGroup` varchar(50) NOT NULL,
  PRIMARY KEY (`SalesTerritoryKey`),
  UNIQUE KEY `SalesTerritoryAlternateKey` (`SalesTerritoryAlternateKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimsalesterritory`
--

LOCK TABLES `dimsalesterritory` WRITE;
/*!40000 ALTER TABLE `dimsalesterritory` DISABLE KEYS */;
INSERT INTO `dimsalesterritory` VALUES (1,1,'Southwest','United States','North America'),(2,2,'Northeast','United States','North America'),(3,3,'Central','Canada','North America');
/*!40000 ALTER TABLE `dimsalesterritory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factinternetsales`
--

DROP TABLE IF EXISTS `factinternetsales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factinternetsales` (
  `ProductKey` int NOT NULL,
  `OrderDateKey` int NOT NULL,
  `CustomerKey` int NOT NULL,
  `SalesTerritoryKey` int NOT NULL,
  `SalesOrderNumber` varchar(20) NOT NULL,
  `SalesOrderLineNumber` int NOT NULL,
  `OrderQuantity` int NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  `ExtendedAmount` decimal(10,2) NOT NULL,
  `DiscountAmount` decimal(10,2) NOT NULL,
  `ProductStandardCost` decimal(10,2) NOT NULL,
  `TotalProductCost` decimal(10,2) NOT NULL,
  `SalesAmount` decimal(10,2) NOT NULL,
  `TaxAmt` decimal(10,2) NOT NULL,
  `Freight` decimal(10,2) NOT NULL,
  `OrderDate` date NOT NULL,
  `DueDate` date NOT NULL,
  `ShipDate` date NOT NULL,
  PRIMARY KEY (`SalesOrderNumber`,`SalesOrderLineNumber`),
  KEY `ProductKey` (`ProductKey`),
  KEY `OrderDateKey` (`OrderDateKey`),
  KEY `CustomerKey` (`CustomerKey`),
  KEY `SalesTerritoryKey` (`SalesTerritoryKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factinternetsales`
--

LOCK TABLES `factinternetsales` WRITE;
/*!40000 ALTER TABLE `factinternetsales` DISABLE KEYS */;
INSERT INTO `factinternetsales` VALUES (1,20230101,100,1,'1',1,1,1000.00,1000.00,0.00,500.00,500.00,1000.00,50.00,20.00,'2023-01-01','2023-01-08','2023-01-04'),(1,20240101,100,1,'4',1,1,1000.00,1000.00,0.00,500.00,500.00,1000.00,50.00,20.00,'2024-01-01','2024-01-08','2024-01-04'),(1,20230301,102,1,'3',1,1,1000.00,1000.00,0.00,500.00,500.00,1000.00,50.00,20.00,'2023-03-01','2023-03-08','2023-03-04'),(2,20230101,100,1,'1',2,1,60.00,60.00,0.00,30.00,30.00,60.00,3.00,1.20,'2023-01-01','2023-01-08','2023-01-04'),(3,20230201,101,1,'2',1,2,1400.00,2800.00,0.00,700.00,1400.00,2800.00,140.00,56.00,'2023-02-01','2023-02-08','2023-02-04');
/*!40000 ALTER TABLE `factinternetsales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `stg_vendas_limpas`
--

DROP TABLE IF EXISTS `stg_vendas_limpas`;
/*!50001 DROP VIEW IF EXISTS `stg_vendas_limpas`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `stg_vendas_limpas` AS SELECT 
 1 AS `SalesOrderID`,
 1 AS `SalesOrderDetailID`,
 1 AS `ProductID`,
 1 AS `CustomerID`,
 1 AS `OrderDateKey_Source`,
 1 AS `OrderDate_Source`,
 1 AS `OrderQty`,
 1 AS `UnitPrice`,
 1 AS `UnitPriceDiscount`,
 1 AS `LineTotal`,
 1 AS `ProductStandardCost`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'gestao_bases_dados_empresariais'
--

--
-- Final view structure for view `stg_vendas_limpas`
--

/*!50001 DROP VIEW IF EXISTS `stg_vendas_limpas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `stg_vendas_limpas` AS select 1 AS `SalesOrderID`,1 AS `SalesOrderDetailID`,1 AS `ProductID`,100 AS `CustomerID`,20230101 AS `OrderDateKey_Source`,'2023-01-01' AS `OrderDate_Source`,1 AS `OrderQty`,1000.00 AS `UnitPrice`,0.00 AS `UnitPriceDiscount`,((1000.00 * 1) - 0.00) AS `LineTotal`,500.00 AS `ProductStandardCost` union all select 1 AS `SalesOrderID`,2 AS `SalesOrderDetailID`,2 AS `ProductID`,100 AS `CustomerID`,20230101 AS `OrderDateKey_Source`,'2023-01-01' AS `OrderDate_Source`,1 AS `OrderQty`,60.00 AS `UnitPrice`,0.00 AS `UnitPriceDiscount`,((60.00 * 1) - 0.00) AS `LineTotal`,30.00 AS `ProductStandardCost` union all select 2 AS `SalesOrderID`,1 AS `SalesOrderDetailID`,3 AS `ProductID`,101 AS `CustomerID`,20230201 AS `OrderDateKey_Source`,'2023-02-01' AS `OrderDate_Source`,2 AS `OrderQty`,1400.00 AS `UnitPrice`,0.00 AS `UnitPriceDiscount`,((1400.00 * 2) - 0.00) AS `LineTotal`,700.00 AS `ProductStandardCost` union all select 3 AS `SalesOrderID`,1 AS `SalesOrderDetailID`,1 AS `ProductID`,102 AS `CustomerID`,20230301 AS `OrderDateKey_Source`,'2023-03-01' AS `OrderDate_Source`,1 AS `OrderQty`,1000.00 AS `UnitPrice`,0.00 AS `UnitPriceDiscount`,((1000.00 * 1) - 0.00) AS `LineTotal`,500.00 AS `ProductStandardCost` union all select 4 AS `SalesOrderID`,1 AS `SalesOrderDetailID`,1 AS `ProductID`,100 AS `CustomerID`,20240101 AS `OrderDateKey_Source`,'2024-01-01' AS `OrderDate_Source`,1 AS `OrderQty`,1000.00 AS `UnitPrice`,0.00 AS `UnitPriceDiscount`,((1000.00 * 1) - 0.00) AS `LineTotal`,500.00 AS `ProductStandardCost` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-17 17:26:32
