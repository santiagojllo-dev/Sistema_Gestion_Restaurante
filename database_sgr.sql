-- Sistema de Gestión de Restaurantes (SGR)
-- Base de datos vacía lista para llenar

CREATE DATABASE IF NOT EXISTS sgr;
USE sgr;

-- Tabla 1: CATEGORIAS_PLATOS
-- Organiza los platos por tipo (entrada, plato principal, postre, etc.)
CREATE TABLE IF NOT EXISTS categorias_platos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 2: INGREDIENTES
-- Almacena todos los ingredientes que usa el restaurante
CREATE TABLE IF NOT EXISTS ingredientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    unidadMedida VARCHAR(50) NOT NULL,
    precioUnitario DECIMAL(10, 2) NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 3: PLATOS
-- Catálogo de platos disponibles en el restaurante
CREATE TABLE IF NOT EXISTS platos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    categoriaId INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    tiempo_preparacion INT DEFAULT 15,
    estado ENUM('disponible', 'no_disponible') DEFAULT 'disponible',
    fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoriaId) REFERENCES categorias_platos(id) ON DELETE CASCADE
);

-- Tabla 4: EMPLEADOS
-- Personal del restaurante
CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    puesto VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2),
    fechaContratacion DATE,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 5: MESAS
-- Mesas disponibles en el restaurante
CREATE TABLE IF NOT EXISTS mesas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_mesa INT NOT NULL UNIQUE,
    capacidad INT NOT NULL,
    ubicacion VARCHAR(100),
    estado ENUM('disponible', 'ocupada', 'reservada', 'mantenimiento') DEFAULT 'disponible',
    fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 6: CLIENTES
-- Datos de clientes del restaurante
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    tipoCliente ENUM('regular', 'vip', 'ocasional') DEFAULT 'ocasional',
    fechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 7: RESERVAS
-- Gestión de reservas de mesas
CREATE TABLE IF NOT EXISTS reservas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mesaId INT NOT NULL,
    clienteId INT NOT NULL,
    empleadoId INT,
    fecha_reserva DATE NOT NULL,
    hora_reserva TIME NOT NULL,
    numero_personas INT NOT NULL,
    notas VARCHAR(255),
    estado ENUM('confirmada', 'cancelada', 'completada') DEFAULT 'confirmada',
    fechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mesaId) REFERENCES mesas(id) ON DELETE CASCADE,
    FOREIGN KEY (clienteId) REFERENCES clientes(id) ON DELETE CASCADE,
    FOREIGN KEY (empleadoId) REFERENCES empleados(id) ON DELETE SET NULL
);

-- Tabla 8: ORDENES
-- Órdenes/pedidos de clientes
CREATE TABLE IF NOT EXISTS ordenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mesaId INT NOT NULL,
    clienteId INT,
    empleadoId INT NOT NULL,
    numero_orden INT UNIQUE NOT NULL,
    fecha_orden DATETIME DEFAULT CURRENT_TIMESTAMP,
    hora_orden TIME,
    total DECIMAL(10, 2) DEFAULT 0,
    estado ENUM('pendiente', 'en_preparacion', 'lista', 'entregada', 'cancelada') DEFAULT 'pendiente',
    notas VARCHAR(255),
    FOREIGN KEY (mesaId) REFERENCES mesas(id) ON DELETE CASCADE,
    FOREIGN KEY (clienteId) REFERENCES clientes(id) ON DELETE SET NULL,
    FOREIGN KEY (empleadoId) REFERENCES empleados(id) ON DELETE RESTRICT
);

-- Tabla 9: DETALLES_ORDENES
-- Detalles de cada plato en una orden
CREATE TABLE IF NOT EXISTS detalles_ordenes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ordenId INT NOT NULL,
    platoId INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    notas_plato VARCHAR(255),
    estado ENUM('pendiente', 'en_preparacion', 'listo', 'entregado') DEFAULT 'pendiente',
    FOREIGN KEY (ordenId) REFERENCES ordenes(id) ON DELETE CASCADE,
    FOREIGN KEY (platoId) REFERENCES platos(id) ON DELETE RESTRICT
);

-- Tabla 10: PROVEEDORES
-- Proveedores de ingredientes
CREATE TABLE IF NOT EXISTS proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    contacto VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 11: INVENTARIO
-- Control de stock de ingredientes
CREATE TABLE IF NOT EXISTS inventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ingredienteId INT NOT NULL,
    proveedorId INT,
    cantidad_actual DECIMAL(10, 2) NOT NULL,
    cantidad_minima DECIMAL(10, 2),
    cantidad_maxima DECIMAL(10, 2),
    fecha_ultima_compra DATE,
    costo_total DECIMAL(10, 2),
    estado ENUM('optimo', 'bajo', 'critico') DEFAULT 'optimo',
    FOREIGN KEY (ingredienteId) REFERENCES ingredientes(id) ON DELETE CASCADE,
    FOREIGN KEY (proveedorId) REFERENCES proveedores(id) ON DELETE SET NULL
);

-- Tabla 12: PAGOS
-- Registro de pagos de órdenes
CREATE TABLE IF NOT EXISTS pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ordenId INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'otro') DEFAULT 'efectivo',
    referencia_transaccion VARCHAR(100),
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente', 'completado', 'rechazado') DEFAULT 'completado',
    notas VARCHAR(255),
    FOREIGN KEY (ordenId) REFERENCES ordenes(id) ON DELETE CASCADE
);

-- Crear usuario para la aplicación Python
CREATE USER IF NOT EXISTS 'usuario_sgr'@'localhost' IDENTIFIED BY 'pass_sgr_2024';
GRANT SELECT, INSERT, UPDATE, DELETE ON sgr.* TO 'usuario_sgr'@'localhost';
FLUSH PRIVILEGES;
