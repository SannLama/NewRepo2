-- ============================================================
-- Módulo 4 — Consultas SQL de negocio
-- Base de datos: Ventas_Tech_DB (creada en el Módulo 3)
-- Motor: SQL Server
-- ============================================================

USE Ventas_Tech_DB;

-- ============================================================
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, por mes.
-- ============================================================
SELECT
    MONTH(fecha_venta)              AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*)                        AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- ============================================================
-- Consulta 2 — Ranking de productos (Top 5 por facturación)
-- Unidades vendidas y total generado por cada id_producto.
-- ============================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad)                   AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- ============================================================
-- Consulta 3 — Clientes recurrentes (más de un pedido)
-- Cantidad de pedidos y total gastado por cliente.
-- HAVING filtra los grupos: solo los que tienen más de 1 pedido.
-- ============================================================
SELECT
    id_cliente,
    COUNT(*)                        AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- ============================================================
-- Consulta 4 — Productos por encima / por debajo del promedio
-- CASE WHEN etiqueta cada producto comparándolo contra el
-- promedio de los TOTALES por producto (no el promedio de filas).
-- WITH arma primero la tabla de totales por producto.
-- ============================================================
WITH totales_por_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_por_producto)
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM totales_por_producto
ORDER BY total_facturado DESC;

-- ============================================================
-- HALLAZGOS
-- ============================================================
-- 1. El producto 1 concentra $3.600 de los $6.444 facturados,
--    casi el 56% del total: un solo producto hace más de la mitad.
-- 2. Los 5 clientes hicieron exactamente 2 pedidos cada uno,
--    o sea el 100% son recurrentes: no hay clientes de una sola compra.
-- 3. Solo 2 de los 6 productos (el 1 y el 3) superan el promedio
--    de facturación por producto ($1.074); la facturación está
--    muy concentrada en pocos productos.
-- ============================================================
