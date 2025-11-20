-- Creación de la BD
CREATE DATABASE IF NOT EXISTS db_gestion_gastronomica;

USE db_gestion_gastronomica;

-- Creacion de las Tablas

-- Tabla de Clientes
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(150) 
);

-- Tabla de Proveedores 
CREATE TABLE proveedor (
    id_prov INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    contacto VARCHAR(20) NOT NULL,
    estado ENUM('activo', 'inactivo', 'premium') NOT NULL DEFAULT 'activo'
);

-- Tabla de Categorias (Clasificacion del Menu)
CREATE TABLE categoria (
    id_cat INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla de Empleados
CREATE TABLE empleado (
    id_emp INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL 
);

-- Tabla de Mesas/Ubicaciones
CREATE TABLE mesa (
    id_mesa INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL UNIQUE, 
    estado VARCHAR(20) DEFAULT 'Disponible'
);

-- Tabla de Insumos (Materias Primas y Stock Real del Almacén)
CREATE TABLE insumo (
    cod_insumo INT PRIMARY KEY,
    nombre_insumo VARCHAR(100) NOT NULL UNIQUE,
    tipo_stock ENUM('Materia Prima', 'Producto Empaquetado', 'Suministro') NOT NULL, -- Tipo de Stock
    unidad_medida VARCHAR(10) NOT NULL, -- Ej: 'kg', 'gr', 'L', 'ml', 'unid'
    stock_actual DECIMAL(10, 3) NOT NULL
);

-- Tabla de Compras (Encabezado de la Factura de Compra)
CREATE TABLE compra (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_prov_fk INT NOT NULL,
    fecha_compra DATETIME NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_prov_fk) REFERENCES proveedor(id_prov)
);

-- Tabla de Detalle de Compra (Relaciona Compra con Insumos)
CREATE TABLE detalle_compra (
    id_det_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_compra_fk INT NOT NULL,
    cod_insumo_fk INT NOT NULL,
    cantidad_comprada DECIMAL(10, 3) NOT NULL,
    precio_unitario_compra DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_compra_fk) REFERENCES compra(id_compra),
    FOREIGN KEY (cod_insumo_fk) REFERENCES insumo(cod_insumo)
);

-- Tabla de Productos (Lo que se Vende en el Menu)
CREATE TABLE producto (
    cod_prod INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    id_cat_fk INT NOT NULL,
    FOREIGN KEY (id_cat_fk) REFERENCES categoria(id_cat)
);

-- Tabla de Composición/Receta (Define qué Insumos forman un Producto)
CREATE TABLE comp_producto (
    id_comp INT PRIMARY KEY AUTO_INCREMENT,
    cod_prod_fk INT NOT NULL,
    cod_insumo_fk INT NOT NULL,
    cantidad_necesaria DECIMAL(10, 3) NOT NULL,
    FOREIGN KEY (cod_prod_fk) REFERENCES producto(cod_prod),
    FOREIGN KEY (cod_insumo_fk) REFERENCES insumo(cod_insumo)
);

-- Tabla de Pedidos (Encabezado de la Orden)
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20) NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    id_emp_fk INT NOT NULL,
    id_mesa_fk INT, 
    id_cliente_fk INT,
    FOREIGN KEY (id_emp_fk) REFERENCES empleado(id_emp),
    FOREIGN KEY (id_mesa_fk) REFERENCES mesa(id_mesa),
    FOREIGN KEY (id_cliente_fk) REFERENCES cliente(id_cliente)

);

-- Tabla de Detalle del Pedido (Líneas de la Orden)
CREATE TABLE detalle_pedido (
    id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido_fk INT NOT NULL,
    cod_prod_fk INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido_fk) REFERENCES pedido(id_pedido),
    FOREIGN KEY (cod_prod_fk) REFERENCES producto(cod_prod)
);

-- Tabla de Transacciones (Pagos)
CREATE TABLE transaccion (
    id_trans INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido_fk INT NOT NULL UNIQUE, 
    fecha DATETIME NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    metodo VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_pedido_fk) REFERENCES pedido(id_pedido)
);