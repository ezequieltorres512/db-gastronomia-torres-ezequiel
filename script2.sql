USE db_gestion_gastronomica;

-- Vistas

-- Detalle de ventas
CREATE OR REPLACE VIEW vw_ventas_detalle AS
SELECT 
    p.id_pedido,
    c.nombre AS cliente,
    e.nombre AS atendido_por,
    t.monto,
    t.metodo,
    p.fecha_pedido
FROM pedido p
JOIN cliente c ON p.id_cliente_fk = c.id_cliente
JOIN empleado e ON p.id_emp_fk = e.id_emp
JOIN transaccion t ON p.id_pedido = t.id_pedido_fk;

-- Alerta de stock crítico (menos de 5 unidades)
CREATE OR REPLACE VIEW vw_stock_critico AS
SELECT cod_insumo, nombre_insumo, stock_actual, unidad_medida
FROM insumo
WHERE stock_actual < 5;

-- Ranking de productos más vendidos
CREATE OR REPLACE VIEW vw_ranking_productos AS
SELECT 
    pr.nombre AS producto,
    cat.nombre AS categoria,
    SUM(dp.cantidad) AS total_vendido
FROM detalle_pedido dp
JOIN producto pr ON dp.cod_prod_fk = pr.cod_prod
JOIN categoria cat ON pr.id_cat_fk = cat.id_cat
GROUP BY pr.nombre, cat.nombre
ORDER BY total_vendido DESC;


-- Funciones

DELIMITER //

-- Función para calcular el total de un pedido
CREATE FUNCTION fn_calcular_total_pedido(p_id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(cantidad * precio_unit) INTO total
    FROM detalle_pedido
    WHERE id_pedido_fk = p_id_pedido;
    RETURN IFNULL(total, 0);
END //

-- Función para obtener stock de un insumo
CREATE FUNCTION fn_obtener_stock_insumo(p_cod_insumo INT) 
RETURNS DECIMAL(10,3)
DETERMINISTIC
BEGIN
    DECLARE v_stock DECIMAL(10,3);
    SELECT stock_actual INTO v_stock
    FROM insumo
    WHERE cod_insumo = p_cod_insumo;
    RETURN IFNULL(v_stock, 0);
END //

DELIMITER ;

-- Stored Procedures

DELIMITER //

-- SP para registrar compra y actualizar stock
CREATE PROCEDURE sp_registrar_item_compra(
    IN p_id_compra INT,
    IN p_cod_insumo INT,
    IN p_cantidad DECIMAL(10,3),
    IN p_precio DECIMAL(10,2)
)
BEGIN
    INSERT INTO detalle_compra (id_compra_fk, cod_insumo_fk, cantidad_comprada, precio_unitario_compra)
    VALUES (p_id_compra, p_cod_insumo, p_cantidad, p_precio);
    
    UPDATE insumo 
    SET stock_actual = stock_actual + p_cantidad
    WHERE cod_insumo = p_cod_insumo;
END //

-- SP para ordenar productos dinámicamente
CREATE PROCEDURE sp_ordenar_productos(
    IN p_campo_orden VARCHAR(20),
    IN p_tipo_orden VARCHAR(4)
)
BEGIN
    SET @query = CONCAT('SELECT * FROM producto ORDER BY ', p_campo_orden, ' ', p_tipo_orden);
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


-- =============================================
-- 4. TRIGGERS (Corregidos según tu script)
-- =============================================

-- Tabla necesaria para el trigger de auditoría
-- (Aseguramos que los nombres coincidan con el trigger)
CREATE TABLE IF NOT EXISTS log_precios (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    cod_prod_fk INT,
    precio_viejo DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    usuario VARCHAR(50),
    fecha_cambio DATETIME
);

DELIMITER //

-- Trigger

-- Auditoría de cambios de precio
CREATE TRIGGER tr_auditoria_precio_producto
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO log_precios (cod_prod_fk, precio_viejo, precio_nuevo, usuario, fecha_cambio)
        VALUES (OLD.cod_prod, OLD.precio, NEW.precio, USER(), NOW());
    END IF;
END //

-- Validación de stock / cantidad
CREATE TRIGGER tr_validar_stock_pedido
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La cantidad del producto debe ser mayor a cero';
    END IF;
END //

DELIMITER ;