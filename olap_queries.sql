-- Consultas OLAP para análise de dados no Data Warehouse AdventureWorksDW
USE adventureWorksDW;
-- 1. Análise de Faturamento Mensal por Categoria (Tendência Temporal)
-- Esta consulta permite identificar quais categorias de produtos estão impulsionando o faturamento em cada mês.
SELECT
    dd.CalendarYear AS Ano,
    dd.CalendarMonth AS Mes,
    dp.ProductCategory AS Categoria,
    SUM(fis.SalesAmount) AS FaturamentoTotal
FROM FactInternetSales fis
JOIN DimDate dd ON fis.OrderDateKey = dd.DateKey
JOIN DimProduct dp ON fis.ProductKey = dp.ProductKey
GROUP BY dd.CalendarYear, dd.CalendarMonth, dp.ProductCategory
ORDER BY Ano DESC, Mes ASC, Categoria;

-- 2. Identificação de Margem de Contribuição por Região (Geográfico)
-- Esta consulta calcula a rentabilidade real por território, permitindo identificar regiões onde o custo de venda ou descontos estão impactando o lucro.
SELECT
    dst.SalesTerritoryCountry AS Pais,
    dst.SalesTerritoryRegion AS Regiao,
    SUM(fis.SalesAmount) AS Receita,
    SUM(fis.SalesAmount - fis.TotalProductCost) AS MargemContribuicao
FROM FactInternetSales fis
JOIN DimSalesTerritory dst ON fis.SalesTerritoryKey = dst.SalesTerritoryKey
GROUP BY dst.SalesTerritoryCountry, dst.SalesTerritoryRegion
ORDER BY MargemContribuicao DESC;

-- 3. Ticket Médio por Perfil de Cliente
-- Esta consulta ajuda a entender o valor médio gasto pelos clientes.
SELECT
    dc.Education,
    dc.Occupation,
    COUNT(DISTINCT fis.CustomerKey) AS TotalClientes,
    SUM(fis.SalesAmount) AS ReceitaTotal,
    SUM(fis.SalesAmount) / COUNT(DISTINCT fis.CustomerKey) AS TicketMedio
FROM FactInternetSales fis
JOIN DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
GROUP BY dc.Education, dc.Occupation
ORDER BY TicketMedio DESC;

-- 4. Análise de Crescimento (YoY - Year over Year) - Exemplo Simplificado
-- Comparação do desempenho de vendas de um período em relação ao mesmo período do ano anterior.
-- Para uma análise YoY completa, seria necessário um conjunto de dados mais robusto e lógica de cálculo de períodos anteriores.
SELECT
    dd.CalendarYear AS Ano,
    SUM(fis.SalesAmount) AS FaturamentoAnual
FROM FactInternetSales fis
JOIN DimDate dd ON fis.OrderDateKey = dd.DateKey
GROUP BY dd.CalendarYear
ORDER BY Ano DESC;

-- Exemplo de consulta para verificar os dados carregados na FactInternetSales
SELECT *
FROM FactInternetSales
LIMIT 100;
