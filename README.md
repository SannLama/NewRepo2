# RetailPro · Ventas_Tech_DB

Proyecto integrador del curso de **Data Analytics de Coderhouse** (comisión 91035).
Caso de negocio: **RetailPro / TechStore**, una distribuidora de tecnología con datos de ventas, clientes y productos que nadie había analizado de forma sistemática. El objetivo es llevar esos datos desde una base relacional hasta un dashboard ejecutivo en Power BI.

## Herramientas

| Etapa | Herramienta |
|---|---|
| Base de datos y consultas | SQL Server Express + SQL Server Management Studio (SSMS) |
| Limpieza (ETL) y modelo | Power BI Desktop (Power Query, lenguaje M y DAX) |
| Control de versiones | Git + GitHub |

> Los scripts están escritos en **T-SQL (SQL Server)**: usan `TOP`, `MONTH()` y el tipo `BIT`. En PostgreSQL hay que adaptarlos (`LIMIT`, `EXTRACT(MONTH FROM ...)`, `BOOLEAN`).

## Contenido del repositorio

| Archivo | Módulo | Qué hace |
|---|---|---|
| `ventas_tech_db.sql` | M3 | Crea las 4 tablas (`categorias`, `clientes`, `productos`, `ventas`) con PK, FK y `NOT NULL`, y carga los datos iniciales. Es repetible: empieza con `DROP TABLE IF EXISTS` en orden inverso. |
| `m4_consultas_negocio.sql` | M4 | 4 consultas de negocio sobre `ventas`: resumen mensual, top 5 de productos, clientes recurrentes y productos por encima/debajo del promedio (`WITH` + `CASE WHEN`). |
| `m5_consultas_joins.sql` | M5 | Vista enriquecida con `INNER JOIN`, clientes y productos sin ventas con `LEFT JOIN`, y consolidado con `UNION ALL`. |
| `Pipeline_ETL_LaMattina_Santiago.pbix` | M6 | Pipeline ETL en Power Query: limpieza de duplicados y nulos, tipado, nomenclatura `Dim_` / `Fact_` y merge. |
| `LaMattina_Santiago_Checkpoint2.pbix` | M8 | Modelo en estrella con 4 relaciones 1:N, tabla calendario `Dim_Fechas` y 5 medidas DAX en `_Medidas`. |

## Cómo ejecutar los scripts SQL

1. Abrí SSMS y conectate a tu instancia (por ejemplo `localhost\SQLEXPRESS`, con autenticación de Windows). Si aparece un error de certificado, tildá **"Certificado de servidor de confianza"** en la ventana de conexión.
2. Creá la base **una sola vez**:
   ```sql
   CREATE DATABASE Ventas_Tech_DB;
   ```
3. Ejecutá los archivos **en este orden** con `F5`:
   1. `ventas_tech_db.sql`: crea y carga las tablas. Las consultas de M4 y M5 dependen de estos datos.
   2. `m4_consultas_negocio.sql`
   3. `m5_consultas_joins.sql`
4. Cada archivo empieza con `USE Ventas_Tech_DB;`, así que no hace falta elegir la base a mano.

## Sobre los datos

- **Dos fuentes distintas.** Los scripts SQL usan `Ventas_Tech_DB`: 10 ventas de prueba, todas de marzo de 2024. Los `.pbix` usan `Pipeline_ETL_Dataset.xlsx`, provisto por el curso: 50 ventas entre 2023 y 2024, con duplicados y nulos a propósito para practicar limpieza. Por eso los números de SQL y de Power BI no coinciden.
- **Ruta del Excel.** Los `.pbix` leen el Excel desde `C:\Users\<usuario>\Downloads\Pipeline_ETL_Dataset.xlsx`. Si lo abrís en otra computadora, actualizá la ruta en *Inicio → Transformar datos → Configuración de origen de datos*.
- Los datos son ficticios y no contienen información personal real.

## Autor

Santiago La Mattina · Data Analytics, Coderhouse (2026)
