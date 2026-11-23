-- Sistema de Gestión de Restaurantes (SGR)
-- PROCEDIMIENTOS ALMACENADOS
-- Ejecutar DESPUÉS de database_sgr.sql
--
-- Por cada tabla hay 5 procedimientos:
--   sp_<tabla>_listar()                 -> todos los registros
--   sp_<tabla>_buscar(id)               -> un registro por id
--   sp_<tabla>_insertar(campos...)      -> inserta y devuelve el registro creado
--   sp_<tabla>_actualizar(id, campos...) -> actualiza solo los campos enviados (NULL = no cambiar)
--   sp_<tabla>_eliminar(id)             -> elimina y devuelve cuántas filas borró
-- Además: sp_ordenes_recalcular_total(ordenId) y sp_reporte_conteos()

USE sgr;

DELIMITER //

-- ============================================================
-- CATEGORIAS_PLATOS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_categorias_platos_listar //
CREATE PROCEDURE sp_categorias_platos_listar()
BEGIN
    SELECT * FROM categorias_platos ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_categorias_platos_buscar //
CREATE PROCEDURE sp_categorias_platos_buscar(IN p_id INT)
BEGIN
    SELECT * FROM categorias_platos WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_categorias_platos_insertar //
CREATE PROCEDURE sp_categorias_platos_insertar(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO categorias_platos (nombre, descripcion, estado)
    VALUES (
        p_nombre,
        p_descripcion,
        COALESCE(p_estado, 'activo')
    );
    SELECT * FROM categorias_platos WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_categorias_platos_actualizar //
CREATE PROCEDURE sp_categorias_platos_actualizar(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE categorias_platos SET
        nombre = COALESCE(p_nombre, nombre),
        descripcion = COALESCE(p_descripcion, descripcion),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM categorias_platos WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_categorias_platos_eliminar //
CREATE PROCEDURE sp_categorias_platos_eliminar(IN p_id INT)
BEGIN
    DELETE FROM categorias_platos WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- INGREDIENTES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_ingredientes_listar //
CREATE PROCEDURE sp_ingredientes_listar()
BEGIN
    SELECT * FROM ingredientes ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_ingredientes_buscar //
CREATE PROCEDURE sp_ingredientes_buscar(IN p_id INT)
BEGIN
    SELECT * FROM ingredientes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_ingredientes_insertar //
CREATE PROCEDURE sp_ingredientes_insertar(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_unidadMedida VARCHAR(50),
    IN p_precioUnitario DECIMAL(10,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO ingredientes (nombre, descripcion, unidadMedida, precioUnitario, estado)
    VALUES (
        p_nombre,
        p_descripcion,
        p_unidadMedida,
        p_precioUnitario,
        COALESCE(p_estado, 'activo')
    );
    SELECT * FROM ingredientes WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_ingredientes_actualizar //
CREATE PROCEDURE sp_ingredientes_actualizar(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_unidadMedida VARCHAR(50),
    IN p_precioUnitario DECIMAL(10,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE ingredientes SET
        nombre = COALESCE(p_nombre, nombre),
        descripcion = COALESCE(p_descripcion, descripcion),
        unidadMedida = COALESCE(p_unidadMedida, unidadMedida),
        precioUnitario = COALESCE(p_precioUnitario, precioUnitario),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM ingredientes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_ingredientes_eliminar //
CREATE PROCEDURE sp_ingredientes_eliminar(IN p_id INT)
BEGIN
    DELETE FROM ingredientes WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- PLATOS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_platos_listar //
CREATE PROCEDURE sp_platos_listar()
BEGIN
    SELECT * FROM platos ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_platos_buscar //
CREATE PROCEDURE sp_platos_buscar(IN p_id INT)
BEGIN
    SELECT * FROM platos WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_platos_insertar //
CREATE PROCEDURE sp_platos_insertar(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_categoriaId INT,
    IN p_precio DECIMAL(10,2),
    IN p_tiempo_preparacion INT,
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO platos (nombre, descripcion, categoriaId, precio, tiempo_preparacion, estado)
    VALUES (
        p_nombre,
        p_descripcion,
        p_categoriaId,
        p_precio,
        COALESCE(p_tiempo_preparacion, 15),
        COALESCE(p_estado, 'disponible')
    );
    SELECT * FROM platos WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_platos_actualizar //
CREATE PROCEDURE sp_platos_actualizar(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_categoriaId INT,
    IN p_precio DECIMAL(10,2),
    IN p_tiempo_preparacion INT,
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE platos SET
        nombre = COALESCE(p_nombre, nombre),
        descripcion = COALESCE(p_descripcion, descripcion),
        categoriaId = COALESCE(p_categoriaId, categoriaId),
        precio = COALESCE(p_precio, precio),
        tiempo_preparacion = COALESCE(p_tiempo_preparacion, tiempo_preparacion),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM platos WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_platos_eliminar //
CREATE PROCEDURE sp_platos_eliminar(IN p_id INT)
BEGIN
    DELETE FROM platos WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- PLATOS_INGREDIENTES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_platos_ingredientes_listar //
CREATE PROCEDURE sp_platos_ingredientes_listar()
BEGIN
    SELECT * FROM platos_ingredientes ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_platos_ingredientes_buscar //
CREATE PROCEDURE sp_platos_ingredientes_buscar(IN p_id INT)
BEGIN
    SELECT * FROM platos_ingredientes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_platos_ingredientes_insertar //
CREATE PROCEDURE sp_platos_ingredientes_insertar(
    IN p_platoId INT,
    IN p_ingredienteId INT,
    IN p_cantidad DECIMAL(10,2),
    IN p_unidadMedida VARCHAR(50)
)
BEGIN
    INSERT INTO platos_ingredientes (platoId, ingredienteId, cantidad, unidadMedida)
    VALUES (
        p_platoId,
        p_ingredienteId,
        p_cantidad,
        p_unidadMedida
    );
    SELECT * FROM platos_ingredientes WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_platos_ingredientes_actualizar //
CREATE PROCEDURE sp_platos_ingredientes_actualizar(
    IN p_id INT,
    IN p_platoId INT,
    IN p_ingredienteId INT,
    IN p_cantidad DECIMAL(10,2),
    IN p_unidadMedida VARCHAR(50)
)
BEGIN
    UPDATE platos_ingredientes SET
        platoId = COALESCE(p_platoId, platoId),
        ingredienteId = COALESCE(p_ingredienteId, ingredienteId),
        cantidad = COALESCE(p_cantidad, cantidad),
        unidadMedida = COALESCE(p_unidadMedida, unidadMedida)
    WHERE id = p_id;
    SELECT * FROM platos_ingredientes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_platos_ingredientes_eliminar //
CREATE PROCEDURE sp_platos_ingredientes_eliminar(IN p_id INT)
BEGIN
    DELETE FROM platos_ingredientes WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- EMPLEADOS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_empleados_listar //
CREATE PROCEDURE sp_empleados_listar()
BEGIN
    SELECT * FROM empleados ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_empleados_buscar //
CREATE PROCEDURE sp_empleados_buscar(IN p_id INT)
BEGIN
    SELECT * FROM empleados WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_empleados_insertar //
CREATE PROCEDURE sp_empleados_insertar(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_puesto VARCHAR(100),
    IN p_salario DECIMAL(10,2),
    IN p_fechaContratacion DATE,
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO empleados (nombre, apellido, email, telefono, puesto, salario, fechaContratacion, estado)
    VALUES (
        p_nombre,
        p_apellido,
        p_email,
        p_telefono,
        p_puesto,
        p_salario,
        p_fechaContratacion,
        COALESCE(p_estado, 'activo')
    );
    SELECT * FROM empleados WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_empleados_actualizar //
CREATE PROCEDURE sp_empleados_actualizar(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_puesto VARCHAR(100),
    IN p_salario DECIMAL(10,2),
    IN p_fechaContratacion DATE,
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE empleados SET
        nombre = COALESCE(p_nombre, nombre),
        apellido = COALESCE(p_apellido, apellido),
        email = COALESCE(p_email, email),
        telefono = COALESCE(p_telefono, telefono),
        puesto = COALESCE(p_puesto, puesto),
        salario = COALESCE(p_salario, salario),
        fechaContratacion = COALESCE(p_fechaContratacion, fechaContratacion),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM empleados WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_empleados_eliminar //
CREATE PROCEDURE sp_empleados_eliminar(IN p_id INT)
BEGIN
    DELETE FROM empleados WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- MESAS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_mesas_listar //
CREATE PROCEDURE sp_mesas_listar()
BEGIN
    SELECT * FROM mesas ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_mesas_buscar //
CREATE PROCEDURE sp_mesas_buscar(IN p_id INT)
BEGIN
    SELECT * FROM mesas WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_mesas_insertar //
CREATE PROCEDURE sp_mesas_insertar(
    IN p_numero_mesa INT,
    IN p_capacidad INT,
    IN p_ubicacion VARCHAR(100),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO mesas (numero_mesa, capacidad, ubicacion, estado)
    VALUES (
        p_numero_mesa,
        p_capacidad,
        p_ubicacion,
        COALESCE(p_estado, 'disponible')
    );
    SELECT * FROM mesas WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_mesas_actualizar //
CREATE PROCEDURE sp_mesas_actualizar(
    IN p_id INT,
    IN p_numero_mesa INT,
    IN p_capacidad INT,
    IN p_ubicacion VARCHAR(100),
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE mesas SET
        numero_mesa = COALESCE(p_numero_mesa, numero_mesa),
        capacidad = COALESCE(p_capacidad, capacidad),
        ubicacion = COALESCE(p_ubicacion, ubicacion),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM mesas WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_mesas_eliminar //
CREATE PROCEDURE sp_mesas_eliminar(IN p_id INT)
BEGIN
    DELETE FROM mesas WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- CLIENTES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_clientes_listar //
CREATE PROCEDURE sp_clientes_listar()
BEGIN
    SELECT * FROM clientes ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_clientes_buscar //
CREATE PROCEDURE sp_clientes_buscar(IN p_id INT)
BEGIN
    SELECT * FROM clientes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_clientes_insertar //
CREATE PROCEDURE sp_clientes_insertar(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_ciudad VARCHAR(100),
    IN p_tipoCliente VARCHAR(20)
)
BEGIN
    INSERT INTO clientes (nombre, apellido, email, telefono, direccion, ciudad, tipoCliente)
    VALUES (
        p_nombre,
        p_apellido,
        p_email,
        p_telefono,
        p_direccion,
        p_ciudad,
        COALESCE(p_tipoCliente, 'ocasional')
    );
    SELECT * FROM clientes WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_clientes_actualizar //
CREATE PROCEDURE sp_clientes_actualizar(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_ciudad VARCHAR(100),
    IN p_tipoCliente VARCHAR(20)
)
BEGIN
    UPDATE clientes SET
        nombre = COALESCE(p_nombre, nombre),
        apellido = COALESCE(p_apellido, apellido),
        email = COALESCE(p_email, email),
        telefono = COALESCE(p_telefono, telefono),
        direccion = COALESCE(p_direccion, direccion),
        ciudad = COALESCE(p_ciudad, ciudad),
        tipoCliente = COALESCE(p_tipoCliente, tipoCliente)
    WHERE id = p_id;
    SELECT * FROM clientes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_clientes_eliminar //
CREATE PROCEDURE sp_clientes_eliminar(IN p_id INT)
BEGIN
    DELETE FROM clientes WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- RESERVAS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_reservas_listar //
CREATE PROCEDURE sp_reservas_listar()
BEGIN
    SELECT * FROM reservas ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_reservas_buscar //
CREATE PROCEDURE sp_reservas_buscar(IN p_id INT)
BEGIN
    SELECT * FROM reservas WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_reservas_insertar //
CREATE PROCEDURE sp_reservas_insertar(
    IN p_mesaId INT,
    IN p_clienteId INT,
    IN p_empleadoId INT,
    IN p_fecha_reserva DATE,
    IN p_hora_reserva TIME,
    IN p_numero_personas INT,
    IN p_notas VARCHAR(255),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO reservas (mesaId, clienteId, empleadoId, fecha_reserva, hora_reserva, numero_personas, notas, estado)
    VALUES (
        p_mesaId,
        p_clienteId,
        p_empleadoId,
        p_fecha_reserva,
        p_hora_reserva,
        p_numero_personas,
        p_notas,
        COALESCE(p_estado, 'confirmada')
    );
    SELECT * FROM reservas WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_reservas_actualizar //
CREATE PROCEDURE sp_reservas_actualizar(
    IN p_id INT,
    IN p_mesaId INT,
    IN p_clienteId INT,
    IN p_empleadoId INT,
    IN p_fecha_reserva DATE,
    IN p_hora_reserva TIME,
    IN p_numero_personas INT,
    IN p_notas VARCHAR(255),
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE reservas SET
        mesaId = COALESCE(p_mesaId, mesaId),
        clienteId = COALESCE(p_clienteId, clienteId),
        empleadoId = COALESCE(p_empleadoId, empleadoId),
        fecha_reserva = COALESCE(p_fecha_reserva, fecha_reserva),
        hora_reserva = COALESCE(p_hora_reserva, hora_reserva),
        numero_personas = COALESCE(p_numero_personas, numero_personas),
        notas = COALESCE(p_notas, notas),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM reservas WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_reservas_eliminar //
CREATE PROCEDURE sp_reservas_eliminar(IN p_id INT)
BEGIN
    DELETE FROM reservas WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- ORDENES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_ordenes_listar //
CREATE PROCEDURE sp_ordenes_listar()
BEGIN
    SELECT * FROM ordenes ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_ordenes_buscar //
CREATE PROCEDURE sp_ordenes_buscar(IN p_id INT)
BEGIN
    SELECT * FROM ordenes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_ordenes_insertar //
CREATE PROCEDURE sp_ordenes_insertar(
    IN p_mesaId INT,
    IN p_clienteId INT,
    IN p_empleadoId INT,
    IN p_numero_orden INT,
    IN p_hora_orden TIME,
    IN p_estado VARCHAR(20),
    IN p_notas VARCHAR(255)
)
BEGIN
    INSERT INTO ordenes (mesaId, clienteId, empleadoId, numero_orden, hora_orden, estado, notas)
    VALUES (
        p_mesaId,
        p_clienteId,
        p_empleadoId,
        p_numero_orden,
        COALESCE(p_hora_orden, CURRENT_TIME()),
        COALESCE(p_estado, 'pendiente'),
        p_notas
    );
    SELECT * FROM ordenes WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_ordenes_actualizar //
CREATE PROCEDURE sp_ordenes_actualizar(
    IN p_id INT,
    IN p_mesaId INT,
    IN p_clienteId INT,
    IN p_empleadoId INT,
    IN p_numero_orden INT,
    IN p_hora_orden TIME,
    IN p_estado VARCHAR(20),
    IN p_notas VARCHAR(255)
)
BEGIN
    UPDATE ordenes SET
        mesaId = COALESCE(p_mesaId, mesaId),
        clienteId = COALESCE(p_clienteId, clienteId),
        empleadoId = COALESCE(p_empleadoId, empleadoId),
        numero_orden = COALESCE(p_numero_orden, numero_orden),
        hora_orden = COALESCE(p_hora_orden, hora_orden),
        estado = COALESCE(p_estado, estado),
        notas = COALESCE(p_notas, notas)
    WHERE id = p_id;
    SELECT * FROM ordenes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_ordenes_eliminar //
CREATE PROCEDURE sp_ordenes_eliminar(IN p_id INT)
BEGIN
    DELETE FROM ordenes WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- DETALLES_ORDENES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_detalles_ordenes_listar //
CREATE PROCEDURE sp_detalles_ordenes_listar()
BEGIN
    SELECT * FROM detalles_ordenes ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_detalles_ordenes_buscar //
CREATE PROCEDURE sp_detalles_ordenes_buscar(IN p_id INT)
BEGIN
    SELECT * FROM detalles_ordenes WHERE id = p_id;
END //

-- Recalcula ordenes.total = suma de los subtotales de sus detalles
DROP PROCEDURE IF EXISTS sp_ordenes_recalcular_total //
CREATE PROCEDURE sp_ordenes_recalcular_total(IN p_ordenId INT)
BEGIN
    UPDATE ordenes
    SET total = (SELECT COALESCE(SUM(subtotal), 0) FROM detalles_ordenes WHERE ordenId = p_ordenId)
    WHERE id = p_ordenId;
END //

-- Si no se envia precio_unitario se toma el precio actual del plato.
-- subtotal = cantidad * precio_unitario y se actualiza el total de la orden.
DROP PROCEDURE IF EXISTS sp_detalles_ordenes_insertar //
CREATE PROCEDURE sp_detalles_ordenes_insertar(
    IN p_ordenId INT,
    IN p_platoId INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_notas_plato VARCHAR(255),
    IN p_estado VARCHAR(20)
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_id INT;

    SET v_precio = COALESCE(p_precio_unitario, (SELECT precio FROM platos WHERE id = p_platoId));

    INSERT INTO detalles_ordenes (ordenId, platoId, cantidad, precio_unitario, subtotal, notas_plato, estado)
    VALUES (p_ordenId, p_platoId, p_cantidad, v_precio, p_cantidad * v_precio, p_notas_plato, COALESCE(p_estado, 'pendiente'));
    SET v_id = LAST_INSERT_ID();

    CALL sp_ordenes_recalcular_total(p_ordenId);
    SELECT * FROM detalles_ordenes WHERE id = v_id;
END //

DROP PROCEDURE IF EXISTS sp_detalles_ordenes_actualizar //
CREATE PROCEDURE sp_detalles_ordenes_actualizar(
    IN p_id INT,
    IN p_ordenId INT,
    IN p_platoId INT,
    IN p_cantidad INT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_notas_plato VARCHAR(255),
    IN p_estado VARCHAR(20)
)
BEGIN
    DECLARE v_orden_anterior INT;
    SELECT ordenId INTO v_orden_anterior FROM detalles_ordenes WHERE id = p_id;

    UPDATE detalles_ordenes SET
        ordenId = COALESCE(p_ordenId, ordenId),
        platoId = COALESCE(p_platoId, platoId),
        cantidad = COALESCE(p_cantidad, cantidad),
        precio_unitario = COALESCE(p_precio_unitario, precio_unitario),
        notas_plato = COALESCE(p_notas_plato, notas_plato),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    UPDATE detalles_ordenes SET subtotal = cantidad * precio_unitario WHERE id = p_id;

    CALL sp_ordenes_recalcular_total(v_orden_anterior);
    IF p_ordenId IS NOT NULL AND p_ordenId <> v_orden_anterior THEN
        CALL sp_ordenes_recalcular_total(p_ordenId);
    END IF;
    SELECT * FROM detalles_ordenes WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_detalles_ordenes_eliminar //
CREATE PROCEDURE sp_detalles_ordenes_eliminar(IN p_id INT)
BEGIN
    DECLARE v_orden INT;
    DECLARE v_filas INT;
    SELECT ordenId INTO v_orden FROM detalles_ordenes WHERE id = p_id;

    DELETE FROM detalles_ordenes WHERE id = p_id;
    SET v_filas = ROW_COUNT();

    IF v_orden IS NOT NULL THEN
        CALL sp_ordenes_recalcular_total(v_orden);
    END IF;
    SELECT v_filas AS filas_eliminadas;
END //

-- ============================================================
-- PROVEEDORES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_proveedores_listar //
CREATE PROCEDURE sp_proveedores_listar()
BEGIN
    SELECT * FROM proveedores ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_proveedores_buscar //
CREATE PROCEDURE sp_proveedores_buscar(IN p_id INT)
BEGIN
    SELECT * FROM proveedores WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_proveedores_insertar //
CREATE PROCEDURE sp_proveedores_insertar(
    IN p_nombre VARCHAR(100),
    IN p_contacto VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_ciudad VARCHAR(100),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO proveedores (nombre, contacto, email, telefono, direccion, ciudad, estado)
    VALUES (
        p_nombre,
        p_contacto,
        p_email,
        p_telefono,
        p_direccion,
        p_ciudad,
        COALESCE(p_estado, 'activo')
    );
    SELECT * FROM proveedores WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_proveedores_actualizar //
CREATE PROCEDURE sp_proveedores_actualizar(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_contacto VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_ciudad VARCHAR(100),
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE proveedores SET
        nombre = COALESCE(p_nombre, nombre),
        contacto = COALESCE(p_contacto, contacto),
        email = COALESCE(p_email, email),
        telefono = COALESCE(p_telefono, telefono),
        direccion = COALESCE(p_direccion, direccion),
        ciudad = COALESCE(p_ciudad, ciudad),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM proveedores WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_proveedores_eliminar //
CREATE PROCEDURE sp_proveedores_eliminar(IN p_id INT)
BEGIN
    DELETE FROM proveedores WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- INVENTARIO
-- ============================================================

DROP PROCEDURE IF EXISTS sp_inventario_listar //
CREATE PROCEDURE sp_inventario_listar()
BEGIN
    SELECT * FROM inventario ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_inventario_buscar //
CREATE PROCEDURE sp_inventario_buscar(IN p_id INT)
BEGIN
    SELECT * FROM inventario WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_inventario_insertar //
CREATE PROCEDURE sp_inventario_insertar(
    IN p_ingredienteId INT,
    IN p_proveedorId INT,
    IN p_cantidad_actual DECIMAL(10,2),
    IN p_cantidad_minima DECIMAL(10,2),
    IN p_cantidad_maxima DECIMAL(10,2),
    IN p_fecha_ultima_compra DATE,
    IN p_costo_total DECIMAL(10,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    INSERT INTO inventario (ingredienteId, proveedorId, cantidad_actual, cantidad_minima, cantidad_maxima, fecha_ultima_compra, costo_total, estado)
    VALUES (
        p_ingredienteId,
        p_proveedorId,
        p_cantidad_actual,
        p_cantidad_minima,
        p_cantidad_maxima,
        p_fecha_ultima_compra,
        p_costo_total,
        COALESCE(p_estado, 'optimo')
    );
    SELECT * FROM inventario WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_inventario_actualizar //
CREATE PROCEDURE sp_inventario_actualizar(
    IN p_id INT,
    IN p_ingredienteId INT,
    IN p_proveedorId INT,
    IN p_cantidad_actual DECIMAL(10,2),
    IN p_cantidad_minima DECIMAL(10,2),
    IN p_cantidad_maxima DECIMAL(10,2),
    IN p_fecha_ultima_compra DATE,
    IN p_costo_total DECIMAL(10,2),
    IN p_estado VARCHAR(20)
)
BEGIN
    UPDATE inventario SET
        ingredienteId = COALESCE(p_ingredienteId, ingredienteId),
        proveedorId = COALESCE(p_proveedorId, proveedorId),
        cantidad_actual = COALESCE(p_cantidad_actual, cantidad_actual),
        cantidad_minima = COALESCE(p_cantidad_minima, cantidad_minima),
        cantidad_maxima = COALESCE(p_cantidad_maxima, cantidad_maxima),
        fecha_ultima_compra = COALESCE(p_fecha_ultima_compra, fecha_ultima_compra),
        costo_total = COALESCE(p_costo_total, costo_total),
        estado = COALESCE(p_estado, estado)
    WHERE id = p_id;
    SELECT * FROM inventario WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_inventario_eliminar //
CREATE PROCEDURE sp_inventario_eliminar(IN p_id INT)
BEGIN
    DELETE FROM inventario WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- PAGOS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_pagos_listar //
CREATE PROCEDURE sp_pagos_listar()
BEGIN
    SELECT * FROM pagos ORDER BY id;
END //

DROP PROCEDURE IF EXISTS sp_pagos_buscar //
CREATE PROCEDURE sp_pagos_buscar(IN p_id INT)
BEGIN
    SELECT * FROM pagos WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_pagos_insertar //
CREATE PROCEDURE sp_pagos_insertar(
    IN p_ordenId INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo_pago VARCHAR(20),
    IN p_referencia_transaccion VARCHAR(100),
    IN p_estado VARCHAR(20),
    IN p_notas VARCHAR(255)
)
BEGIN
    INSERT INTO pagos (ordenId, monto, metodo_pago, referencia_transaccion, estado, notas)
    VALUES (
        p_ordenId,
        p_monto,
        COALESCE(p_metodo_pago, 'efectivo'),
        p_referencia_transaccion,
        COALESCE(p_estado, 'completado'),
        p_notas
    );
    SELECT * FROM pagos WHERE id = LAST_INSERT_ID();
END //

-- Solo cambia los campos que llegan con valor (NULL = no cambiar)
DROP PROCEDURE IF EXISTS sp_pagos_actualizar //
CREATE PROCEDURE sp_pagos_actualizar(
    IN p_id INT,
    IN p_ordenId INT,
    IN p_monto DECIMAL(10,2),
    IN p_metodo_pago VARCHAR(20),
    IN p_referencia_transaccion VARCHAR(100),
    IN p_estado VARCHAR(20),
    IN p_notas VARCHAR(255)
)
BEGIN
    UPDATE pagos SET
        ordenId = COALESCE(p_ordenId, ordenId),
        monto = COALESCE(p_monto, monto),
        metodo_pago = COALESCE(p_metodo_pago, metodo_pago),
        referencia_transaccion = COALESCE(p_referencia_transaccion, referencia_transaccion),
        estado = COALESCE(p_estado, estado),
        notas = COALESCE(p_notas, notas)
    WHERE id = p_id;
    SELECT * FROM pagos WHERE id = p_id;
END //

DROP PROCEDURE IF EXISTS sp_pagos_eliminar //
CREATE PROCEDURE sp_pagos_eliminar(IN p_id INT)
BEGIN
    DELETE FROM pagos WHERE id = p_id;
    SELECT ROW_COUNT() AS filas_eliminadas;
END //

-- ============================================================
-- REPORTES
-- ============================================================
DROP PROCEDURE IF EXISTS sp_reporte_conteos //
CREATE PROCEDURE sp_reporte_conteos()
BEGIN
    SELECT 'categorias_platos' AS tabla, COUNT(*) AS cantidad FROM categorias_platos
    UNION ALL SELECT 'ingredientes', COUNT(*) FROM ingredientes
    UNION ALL SELECT 'platos', COUNT(*) FROM platos
    UNION ALL SELECT 'platos_ingredientes', COUNT(*) FROM platos_ingredientes
    UNION ALL SELECT 'empleados', COUNT(*) FROM empleados
    UNION ALL SELECT 'mesas', COUNT(*) FROM mesas
    UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
    UNION ALL SELECT 'reservas', COUNT(*) FROM reservas
    UNION ALL SELECT 'ordenes', COUNT(*) FROM ordenes
    UNION ALL SELECT 'detalles_ordenes', COUNT(*) FROM detalles_ordenes
    UNION ALL SELECT 'proveedores', COUNT(*) FROM proveedores
    UNION ALL SELECT 'inventario', COUNT(*) FROM inventario
    UNION ALL SELECT 'pagos', COUNT(*) FROM pagos;
END //

DELIMITER ;

-- El usuario de la aplicación solo necesita poder ejecutar los procedimientos
GRANT EXECUTE ON sgr.* TO 'usuario_sgr'@'localhost';
FLUSH PRIVILEGES;
