# Projeto-Integrador-Apoio-Decisorio-Aos-Negocios
Curso: Tecnologia em Banco de Dados (5º Semestre) – SENAC

Grupo 01: Antonio Carlos Lemos, Carlos Eduardo Matos dos Santos, Elton Tonello Albuquerque, Felipe Sasse Ulloa, Leno Guedes Goulart, Rodolpho Diego Silva Pereira e Micah Rodrigues Maclean.

1. Visão Geral da Solução
Dando continuidade à primeira etapa, este projeto implementa uma solução de apoio decisório (Business Intelligence - BI) para a empresa AdventureWorks. O objetivo principal é transformar dados transacionais (Online Transaction Processing - OLTP) em uma estrutura analítica (Online Analytical Processing - OLAP) utilizando um Modelo Dimensional em Esquema Estrela (Star Schema). Esta abordagem permite análises mais eficientes e a geração de insights estratégicos para a tomada de decisões.

2. Definição das Tecnologias
Para a implementação desta segunda etapa do projeto, foram utilizadas as seguintes tecnologias e ferramentas:

•	SGBD: SQL Server (utilizado para a criação do Data Warehouse e a execução dos scripts de ETL e OLAP).
•	Linguagem: SQL (empregada para a definição da estrutura do banco de dados - DDL, para a carga e manipulação de dados - DML, e para a elaboração de consultas analíticas OLAP).
•	Integração de Dados: O processo de ETL (Extract, Transform, Load) foi simulado através de scripts SQL e a utilização de uma View de Staging, garantindo a extração, transformação e carga dos dados de forma controlada.
•	Controle de Versão: GitHub, utilizado para a colaboração entre os membros do grupo e para a publicação e gestão dos códigos-fonte do projeto.

3. Detalhamento Técnico
3.1 Modelo Dimensional (Star Schema)
A estrutura do Data Warehouse foi concebida com base no Esquema Estrela, que é otimizado para consultas analíticas. As tabelas que compõem este modelo são:

Tabela	Tipo	Descrição
FactInternetSales	Fato	Centraliza as métricas de vendas, com granularidade no item de linha do pedido.
DimDate	Dimensão	Dimensão de tempo para análises de sazonalidade e tendências.
DimProduct	Dimensão	Atributos detalhados dos produtos, incluindo categorias e subcategorias.
DimCustomer	Dimensão	Dados demográficos e geográficos dos clientes.
DimSalesTerritory	Dimensão	Organização regional e grupos de vendas.
3.2 Processo de ETL (Extração, Transformação e Carga)
O fluxo de dados para o Data Warehouse seguiu uma lógica de extração incremental e limpeza em uma camada de staging, conforme detalhado abaixo:

•	Extração: Realizada através da coleta simulada de dados de pedidos de venda da base transacional.
•	Transformação: Implementada por meio da VIEW stg_vendas_limpas, responsável por tratar valores nulos, padronizar formatos de datas e calcular o faturamento líquido, preparando os dados para a carga.
•	Carga: Inserção final dos dados transformados na tabela de fatos (FactInternetSales), estabelecendo o vínculo das chaves substitutas (Surrogate Keys) com as respectivas tabelas de dimensão.

4. Operações OLAP (Análises Estratégicas)
Para validar o modelo dimensional e fornecer suporte à decisão, foram implementadas as seguintes consultas analíticas, que permitem extrair insights estratégicos:

•	Faturamento Mensal por Categoria: Permite identificar tendências temporais de vendas e sazonalidade por categoria de produto, auxiliando no planejamento de estoque e campanhas de marketing.
•	Margem de Contribuição por Região: Analisa a rentabilidade real dos produtos ou serviços por território de vendas, fornecendo informações cruciais para a otimização de estratégias comerciais regionais.
•	Ticket Médio por Perfil de Cliente: Segmenta o valor médio gasto pelos clientes com base em seu nível de escolaridade e ocupação, possibilitando a criação de campanhas de marketing direcionadas e a personalização de ofertas.

5. Estrutura do Repositório
Para facilitar a navegação e o entendimento do projeto, os arquivos estão organizados da seguinte forma no repositório:

•	ddl_scripts.sql: Contém os scripts SQL para a criação das tabelas do Data Warehouse (Data Definition Language - DDL).
•	etl_scripts.sql: Inclui os scripts SQL responsáveis pela carga e transformação dos dados (Data Manipulation Language - DML), que compõem o processo de ETL.
•	olap_queries.sql: Apresenta as consultas analíticas SQL desenvolvidas para a validação do modelo e para as operações OLAP.
•	/evidencias: Pasta dedicada a armazenar os prints dos resultados das consultas OLAP, servindo como comprovação das análises realizadas.
