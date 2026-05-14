# 🚲 Projeto Integrador — Gestão de Bases de Dados Empresariais
**Apoio Decisório aos Negócios | AdventureWorks**

> Curso de Tecnologia em Banco de Dados — SENAC EAD 2026  
> Professor: Gustavo Calixto

---

## 👥 Integrantes do Grupo 01

| Nome |
|------|
| Antonio Carlos Lemos |
| Carlos Eduardo Matos dos Santos |
| Elton Tonello Albuquerque |
| Felipe Sasse Ulloa |
| Leno Guedes Goulart |
| Rodolpho Diego Silva Pereira |
| Micah Rodrigues Maclean |

---

## 📋 Resumo

Este projeto descreve o desenvolvimento de uma solução completa de apoio decisório para a **AdventureWorks** (indústria de bicicletas), com implementação de um **Modelo Dimensional (MD)** e processos de **ETL (Extract, Transform and Load)**.

O objetivo é converter dados transacionais (OLTP) em uma estrutura analítica **OLAP**, viabilizando a análise de KPIs relacionados a vendas por período, região e produto, por meio de um esquema estrela (*star schema*).

---

## 🎯 Objetivos

- Desenvolver um **Data Warehouse** estruturado em *star schema* com base no dataset AdventureWorksDW2022
- Implementar um pipeline de **ETL** com extração incremental, transformação e carga dos dados
- Disponibilizar **KPIs estratégicos** para suporte à tomada de decisão gerencial
- Entregar documentação técnica e scripts de banco de dados testados e validados

---

## 🏗️ Arquitetura da Solução

```
[Fontes OLTP]
     │
     ▼
  Extração (SQL incremental)
     │
     ▼
  Staging Area (stg_vendas_limpas)
     │
     ▼
  Transformação (SQL + Python/Pandas)
     │
     ▼
  Data Warehouse ─── FactInternetSales
                 └── DimDate
                 └── DimProduct
                 └── DimCustomer
                 └── DimSalesTerritory
```

**Fonte de dados:** [AdventureWorksDW2022](https://github.com/microsoft/sql-server-samples)  
**Tecnologias:** SQL Server · Python (Pandas) · SQL (DDL/DML)

---

## 🗂️ Modelo Dimensional

### Tabela de Fatos
| Tabela | Granularidade |
|--------|---------------|
| `FactInternetSales` | Item de linha por pedido de venda (produto × transação) |

### Dimensões

| Dimensão | Atributos-Chave | Hierarquia | Objetivo Decisório |
|----------|----------------|------------|-------------------|
| `DimDate` | DateKey, Year, Month, Day | Ano > Mês > Dia | Tendências temporais e sazonalidade |
| `DimProduct` | ProductKey, Category, Subcategory | Categoria > Subcategoria > Produto | Mix de produtos e retorno por item |
| `DimCustomer` | CustomerKey, City, StateProvince | País > Estado > Cidade | Perfil geográfico do consumidor |
| `DimSalesTerritory` | TerritoryKey, Region, Country | Grupo > País > Região | Performance por território |

---

## 📊 KPIs Implementados

| KPI | Cálculo | Finalidade |
|-----|---------|------------|
| **Faturamento Bruto** | `SUM(SalesAmount)` | Saúde financeira e volume de vendas |
| **Margem de Contribuição** | `SUM(SalesAmount - TotalProductCost)` | Rentabilidade por produto/região |
| **Ticket Médio** | `SUM(SalesAmount) / COUNT(DISTINCT CustomerKey)` | Potencial de consumo da base de clientes |
| **Crescimento YoY** | Comparação anual via `DimDate` | Análise de crescimento ano a ano |

---

## 🔍 Consultas Analíticas

### A. Faturamento Mensal por Categoria

```sql
SELECT
    d.CalendarYear      AS Ano,
    d.MonthNumberOfYear AS Mes,
    p.EnglishProductCategoryName AS Categoria,
    SUM(f.SalesAmount)  AS FaturamentoTotal
FROM FactInternetSales f
JOIN DimDate    d ON f.OrderDateKey = d.DateKey
JOIN DimProduct p ON f.ProductKey   = p.ProductKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear, p.EnglishProductCategoryName
ORDER BY Ano DESC, Mes ASC;
```

### B. Margem de Contribuição por Região

```sql
SELECT
    t.SalesTerritoryCountry AS Pais,
    t.SalesTerritoryRegion  AS Regiao,
    SUM(f.SalesAmount)                        AS Receita,
    SUM(f.SalesAmount - f.TotalProductCost)   AS MargemContribuicao
FROM FactInternetSales f
JOIN DimSalesTerritory t ON f.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryCountry, t.SalesTerritoryRegion
ORDER BY MargemContribuicao DESC;
```

### C. Ticket Médio por Cliente

```sql
SELECT
    COUNT(DISTINCT f.CustomerKey)                            AS TotalClientes,
    SUM(f.SalesAmount) / COUNT(DISTINCT f.CustomerKey)      AS TicketMedio
FROM FactInternetSales f;
```

---

## ⚙️ Processo de ETL

### 1. Extração (E)
Coleta incremental a partir das tabelas `SalesOrderHeader` e `SalesOrderDetail`, selecionando apenas registros novos ou alterados desde a última carga por meio de campos de data de modificação.

### 2. Transformação (T)

```sql
-- Staging: limpeza e padronização dos dados brutos
CREATE VIEW stg_vendas_limpas AS
SELECT
    SalesOrderID,
    COALESCE(UnitPrice, 0)                                              AS UnitPrice,
    OrderQty,
    (UnitPrice * OrderQty) - COALESCE(UnitPriceDiscount, 0)            AS LineTotal,
    CAST(OrderDate AS DATE)                                             AS OrderDate,
    ProductID,
    CustomerID
FROM Sales.SalesOrderDetail
WHERE UnitPrice > 0;
```

Operações realizadas: limpeza de nulos · padronização de datas e moedas · cálculo de colunas derivadas · mapeamento de *Surrogate Keys* (SCD)

### 3. Carga (L)

```sql
INSERT INTO FactInternetSales (ProductKey, CustomerKey, OrderDateKey, SalesTerritoryKey, SalesAmount)
SELECT
    p.ProductKey,
    c.CustomerKey,
    d.DateKey,
    t.SalesTerritoryKey,
    s.LineTotal
FROM stg_vendas_limpas s
JOIN DimProduct        p ON s.ProductID  = p.ProductID
JOIN DimCustomer       c ON s.CustomerID = c.CustomerID
JOIN DimDate           d ON s.OrderDate  = d.FullDateAlternateKey
JOIN DimSalesTerritory t ON s.TerritoryID = t.SalesTerritoryKey;
```

### 4. Validação e Monitoramento

```sql
SELECT
    (SELECT COUNT(*) FROM stg_vendas_limpas)                                        AS Registros_Staging,
    (SELECT COUNT(*) FROM FactInternetSales WHERE OrderDateKey = 20260322)          AS Registros_DW_Hoje;
```

---

## 📚 Referências

- KIMBALL, R.; ROSS, M. *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling*. 3. ed. Wiley, 2013.
- FREITAS, M. B. *Modelagem dimensional de um data warehouse para análise de dados acadêmicos*. Monografia — CEFET-MG, 2023.
- BRUZAROSCO, D. C.; CASTOLDI, A. V.; PACHECO, R. C. S. Criando data warehouse com o modelo dimensional. *Acta Scientiarum. Technology*, v. 26, n. 1, p. 71–80, 2004.
- MACHADO, V. H. Data warehouse e usabilidade do modelo dimensional estrela. *Prospectus*, v. 2, n. 1, 2024.
- Microsoft. *AdventureWorksDW2022 Database*. Disponível em: https://github.com/microsoft/sql-server-samples
