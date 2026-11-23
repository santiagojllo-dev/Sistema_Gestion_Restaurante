-- Sistema de Gestión de Restaurantes (SGR)
-- DATOS DE PRUEBA (para la demostración)
-- Ejecutar DESPUÉS de database_sgr.sql y procedimientos_sgr.sql
-- Todo se inserta usando los procedimientos almacenados. NULL = usar el valor por defecto.

USE sgr;

-- Categorías: (nombre, descripcion, estado)
CALL sp_categorias_platos_insertar('Entradas', 'Platos para empezar', NULL);
CALL sp_categorias_platos_insertar('Platos fuertes', 'Platos principales', NULL);
CALL sp_categorias_platos_insertar('Postres', 'Dulces y postres', NULL);
CALL sp_categorias_platos_insertar('Bebidas', 'Jugos, gaseosas y cafés', NULL);

-- Ingredientes: (nombre, descripcion, unidadMedida, precioUnitario, estado)
CALL sp_ingredientes_insertar('Carne de res', 'Corte para asar', 'kg', 32000, NULL);
CALL sp_ingredientes_insertar('Papa criolla', NULL, 'kg', 4500, NULL);
CALL sp_ingredientes_insertar('Arroz', NULL, 'kg', 4000, NULL);
CALL sp_ingredientes_insertar('Maracuyá', 'Fruta para jugo', 'kg', 6000, NULL);
CALL sp_ingredientes_insertar('Leche', NULL, 'L', 4200, NULL);

-- Platos: (nombre, descripcion, categoriaId, precio, tiempo_preparacion, estado)
CALL sp_platos_insertar('Empanadas x3', 'Empanadas de carne con ají', 1, 9000, 10, NULL);
CALL sp_platos_insertar('Bandeja paisa', 'Plato típico antioqueño', 2, 32000, 25, NULL);
CALL sp_platos_insertar('Carne asada', 'Con papa criolla y arroz', 2, 35000, 30, NULL);
CALL sp_platos_insertar('Arroz con leche', NULL, 3, 8000, 5, NULL);
CALL sp_platos_insertar('Jugo de maracuyá', 'En agua o en leche', 4, 6000, 5, NULL);

-- Ingredientes por plato: (platoId, ingredienteId, cantidad, unidadMedida)
CALL sp_platos_ingredientes_insertar(3, 1, 0.30, 'kg');
CALL sp_platos_ingredientes_insertar(3, 2, 0.20, 'kg');
CALL sp_platos_ingredientes_insertar(3, 3, 0.15, 'kg');
CALL sp_platos_ingredientes_insertar(4, 3, 0.10, 'kg');
CALL sp_platos_ingredientes_insertar(4, 5, 0.25, 'L');
CALL sp_platos_ingredientes_insertar(5, 4, 0.20, 'kg');

-- Empleados: (nombre, apellido, email, telefono, puesto, salario, fechaContratacion, estado)
CALL sp_empleados_insertar('Laura', 'Gómez', 'laura@sgr.com', '3001112233', 'Mesera', 1500000, '2025-02-01', NULL);
CALL sp_empleados_insertar('Carlos', 'Ruiz', 'carlos@sgr.com', '3002223344', 'Chef', 2800000, '2024-08-15', NULL);
CALL sp_empleados_insertar('Andrés', 'Mejía', 'andres@sgr.com', '3003334455', 'Cajero', 1600000, '2025-05-10', NULL);

-- Mesas: (numero_mesa, capacidad, ubicacion, estado)
CALL sp_mesas_insertar(1, 2, 'Ventana', NULL);
CALL sp_mesas_insertar(2, 4, 'Salón principal', NULL);
CALL sp_mesas_insertar(3, 6, 'Terraza', NULL);
CALL sp_mesas_insertar(4, 4, 'Salón principal', 'mantenimiento');

-- Clientes: (nombre, apellido, email, telefono, direccion, ciudad, tipoCliente)
CALL sp_clientes_insertar('María', 'López', 'maria@correo.com', '3104445566', 'Cra 45 #10-20', 'Medellín', 'vip');
CALL sp_clientes_insertar('Juan', 'Pérez', NULL, '3115556677', NULL, 'Medellín', 'regular');
CALL sp_clientes_insertar('Sofía', 'Restrepo', 'sofia@correo.com', NULL, NULL, 'Envigado', NULL);

-- Reservas: (mesaId, clienteId, empleadoId, fecha_reserva, hora_reserva, numero_personas, notas, estado)
CALL sp_reservas_insertar(3, 1, 1, '2026-12-05', '19:30', 5, 'Cumpleaños', NULL);
CALL sp_reservas_insertar(1, 3, NULL, '2026-12-06', '13:00', 2, NULL, NULL);

-- Proveedores: (nombre, contacto, email, telefono, direccion, ciudad, estado)
CALL sp_proveedores_insertar('Carnes del Valle', 'Pedro Torres', 'ventas@carnesvalle.com', '6044001122', 'Cl 30 #50-10', 'Medellín', NULL);
CALL sp_proveedores_insertar('Fruver La Central', 'Ana Ríos', 'pedidos@lacentral.com', '6044003344', 'Central Mayorista', 'Itagüí', NULL);

-- Inventario: (ingredienteId, proveedorId, cantidad_actual, cantidad_minima, cantidad_maxima, fecha_ultima_compra, costo_total, estado)
CALL sp_inventario_insertar(1, 1, 20, 5, 40, '2026-11-20', 640000, NULL);
CALL sp_inventario_insertar(2, 2, 3, 5, 30, '2026-11-18', 13500, 'bajo');
CALL sp_inventario_insertar(3, 2, 25, 10, 50, '2026-11-15', 100000, NULL);
CALL sp_inventario_insertar(4, 2, 1, 4, 20, '2026-11-10', 6000, 'critico');

-- Órdenes: (mesaId, clienteId, empleadoId, numero_orden, hora_orden, estado, notas)
CALL sp_ordenes_insertar(2, 2, 1, 1001, NULL, 'entregada', NULL);
CALL sp_ordenes_insertar(1, NULL, 1, 1002, NULL, NULL, 'Sin cebolla');

-- Detalles: (ordenId, platoId, cantidad, precio_unitario, notas_plato, estado)
-- precio_unitario NULL -> toma el precio del plato; el total de la orden se recalcula solo.
CALL sp_detalles_ordenes_insertar(1, 2, 2, NULL, NULL, 'entregado');
CALL sp_detalles_ordenes_insertar(1, 5, 2, NULL, 'Uno en leche', 'entregado');
CALL sp_detalles_ordenes_insertar(2, 1, 1, NULL, NULL, NULL);
CALL sp_detalles_ordenes_insertar(2, 3, 1, NULL, NULL, NULL);

-- Pagos: (ordenId, monto, metodo_pago, referencia_transaccion, estado, notas)
CALL sp_pagos_insertar(1, 76000, 'tarjeta', 'VOUCHER-0001', NULL, NULL);

-- Verificación rápida
CALL sp_ordenes_listar();
CALL sp_reporte_conteos();
