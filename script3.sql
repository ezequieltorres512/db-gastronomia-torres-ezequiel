USE db_gestion_gastronomica;

-- Categorías
INSERT INTO categoria (nombre) VALUES 
    ('Cafetería'), 
    ('Pastelería'), 
    ('Bebidas Frías'), 
    ('Sándwiches'), 
    ('Infusiones');

-- Clientes
INSERT INTO cliente (nombre, telefono, email, direccion) VALUES 
    ('Juan Perez', '11223344', 'juan@email.com', 'Av. Corrientes 123'),
    ('Maria Lopez', '11556677', 'maria@email.com', 'Calle Falsa 456'),
    ('Roberto Sanchez', '11889900', 'rober@email.com', 'Belgrano 789'),
    ('Elena Gomez', '11447722', 'elena@email.com', 'Santa Fe 2020'),
    ('Marcos Paz', '11332211', 'marcos@email.com', 'Rivadavia 500');

-- 3. Proveedor
INSERT INTO proveedor (nombre, contacto, estado) VALUES 
    ('Distribuidora El Grano', '11445566', 'premium'),
    ('Lácteos La Serenísima', '11229988', 'activo'),
    ('Panificadora del Sol', '11337722', 'activo'),
    ('Bebidas Express', '11990011', 'activo'),
    ('Mercado Central', '11665544', 'inactivo');

-- Empleados
INSERT INTO empleado (nombre, rol) VALUES 
    ('Carlos Gomez', 'Mozo'),
    ('Ana Ruiz', 'Barista'),
    ('Jorge Sosa', 'Mozo'),
    ('Marta Fernandez', 'Pastelera'),
    ('Gustavo Torres', 'Cajero');

-- Mesas
INSERT INTO mesa (numero, estado) VALUES 
    (1, 'Disponible'), 
    (2, 'Ocupada'), 
    (3, 'Ocupada'), 
    (4, 'Disponible'), 
    (5, 'Mantenimiento'), 

-- Insumos
INSERT INTO insumo (cod_insumo, nombre_insumo, tipo_stock, unidad_medida, stock_actual) VALUES 
    (101, 'Café en grano', 'Materia Prima', 'kg', 15),
    (102, 'Leche entera', 'Materia Prima', 'L', 20),
    (103, 'Azúcar', 'Materia Prima', 'kg', 10),
    (104, 'Harina 0000', 'Materia Prima', 'kg', 40),
    (105, 'Manteca', 'Materia Prima', 'kg', 2.5);
    
-- Productos
INSERT INTO producto (cod_prod, nombre, precio, id_cat_fk) VALUES 
    (1, 'Espresso', 2200, 1),
    (2, 'Capuccino', 2800, 1),
    (3, 'Croissant', 1500, 2),
    (4, 'Tostado JyQ', 4500, 4),
    (5, 'Licuado Frutilla', 3500, 3);

-- Recetas
INSERT INTO comp_producto (cod_prod_fk, cod_insumo_fk, cantidad_necesaria) VALUES 
    (1, 101, 0.018), 
    (2, 101, 0.018), 
    (2, 102, 0.200), 
    (3, 104, 0.050), 
    (3, 105, 0.030);

-- Encabezado Compra
INSERT INTO compra (id_prov_fk, fecha_compra, monto_total) VALUES 
    (1, '2023-12-01', 50000),
    (2, '2023-12-05', 12000);

-- Detalle Compra
INSERT INTO detalle_compra (id_compra_fk, cod_insumo_fk, cantidad_comprada, precio_unitario_compra) VALUES 
    (1, 101, 10, 5000),
    (2, 102, 20, 600);

-- Pedido
INSERT INTO pedido (estado, fecha_pedido, id_emp_fk, id_mesa_fk, id_cliente_fk) VALUES 
    ('Cerrado', '2023-12-10', 1, 1, 1),
    ('Cerrado', '2023-12-10', 3, 2, 2),
    ('Abierto', NOW(), 1, 3, 3);

-- Detalle de Pedido
INSERT INTO detalle_pedido (id_pedido_fk, cod_prod_fk, cantidad, precio_unit) VALUES 
    (1, 1, 2, 2200), 
    (1, 3, 1, 1500), 
    (2, 4, 1, 4500);

-- Transacción
INSERT INTO transaccion (id_pedido_fk, fecha, monto, metodo) VALUES 
    (1, '2023-12-10', 5900, 'Efectivo'),
    (2, '2023-12-10', 4500, 'Tarjeta');