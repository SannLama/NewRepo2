-- ============================================================
-- Módulo 5 — Consultas con JOINs para el proyecto
-- Base de datos: Ventas_Tech_DB (creada en el Módulo 3)
-- Motor: SQL Server
-- ============================================================

USE Ventas_Tech_DB;

-- ============================================================
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: armar en una sola fila cada venta con el nombre del
-- cliente, su ciudad, el producto, la categoría y el total.
-- Es la fuente principal para Power BI: "ciudad" sirve para agrupar
-- y "categoria" para filtrar.
-- ============================================================
SELECT
    v.fecha_venta,
    c.nombre                        AS cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria            AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario  AS total_venta
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
-- Hallazgo: las 10 ventas cruzan sin perder filas. Computación es la categoría
-- más fuerte ($4.950 de $6.444) y Buenos Aires la ciudad que más factura ($2.640).

-- ============================================================
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes registrados que nunca compraron,
-- para que el área de CRM los contacte.
-- ============================================================
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: la consulta devuelve 0 registros: los 5 clientes registrados compraron
-- al menos una vez. CRM no necesita una campaña de reactivación por ahora.

-- ============================================================
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: identificar artículos del catálogo sin movimiento,
-- para que el área de producto decida si promocionarlos o darlos de baja.
-- ============================================================
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v        ON p.id_producto  = v.id_producto
WHERE v.id_venta IS NULL;
-- Hallazgo: la consulta devuelve 0 registros: los 6 productos del catálogo tuvieron
-- ventas. Producto no tiene artículos estancados para revisar en este período.

-- ============================================================
-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar la facturación de dos orígenes. Como el esquema
-- no tiene un canal de venta, el criterio es el período: semana 1
-- (05 al 09/03) contra semana 2 (10 al 15/03). La columna "canal"
-- no existe en las tablas: se crea como texto fijo en cada SELECT.
-- ============================================================
SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Semana 1' AS canal
    FROM ventas WHERE fecha_venta <  '2024-03-10'
    UNION ALL
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Semana 2' AS canal
    FROM ventas WHERE fecha_venta >= '2024-03-10'
) AS consolidado
GROUP BY canal;
-- Hallazgo: las dos semanas facturan casi lo mismo ($3.230 contra $3.214), pero la
-- semana 2 lo logra con 6 ventas en lugar de 4: más pedidos, de menor ticket.
