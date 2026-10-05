import subprocess
import sys
from datetime import datetime, timedelta

try:
    import mysql.connector
except ImportError:
    print("Instalando mysql-connector-python...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "mysql-connector-python", "-q"])
    import mysql.connector


class CategoriaPlato:
    def __init__(self, id=None, nombre="", descripcion="", estado="activo"):
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.estado = estado

    def __repr__(self):
        return f"CategoriaPlato(id={self.id}, nombre='{self.nombre}')"


class Ingrediente:
    def __init__(self, id=None, nombre="", descripcion="", unidadMedida="",
                 precioUnitario=0.0, estado="activo"):
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.unidadMedida = unidadMedida
        self.precioUnitario = precioUnitario
        self.estado = estado

    def __repr__(self):
        return f"Ingrediente(id={self.id}, nombre='{self.nombre}')"


class Plato:
    def __init__(self, id=None, nombre="", descripcion="", categoriaId=None,
                 precio=0.0, tiempo_preparacion=15, estado="disponible"):
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.categoriaId = categoriaId
        self.precio = precio
        self.tiempo_preparacion = tiempo_preparacion
        self.estado = estado

    def __repr__(self):
        return f"Plato(id={self.id}, nombre='{self.nombre}', precio=${self.precio})"


class Empleado:
    def __init__(self, id=None, nombre="", apellido="", email="", telefono="",
                 puesto="", salario=0.0, estado="activo"):
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.email = email
        self.telefono = telefono
        self.puesto = puesto
        self.salario = salario
        self.estado = estado

    def __repr__(self):
        return f"Empleado(id={self.id}, nombre='{self.nombre} {self.apellido}', puesto='{self.puesto}')"


class Mesa:
    def __init__(self, id=None, numero_mesa=0, capacidad=0, ubicacion="", estado="disponible"):
        self.id = id
        self.numero_mesa = numero_mesa
        self.capacidad = capacidad
        self.ubicacion = ubicacion
        self.estado = estado

    def __repr__(self):
        return f"Mesa(numero={self.numero_mesa}, capacidad={self.capacidad}, estado='{self.estado}')"


class Cliente:
    def __init__(self, id=None, nombre="", apellido="", email="", telefono="",
                 direccion="", ciudad="", tipoCliente="ocasional"):
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.email = email
        self.telefono = telefono
        self.direccion = direccion
        self.ciudad = ciudad
        self.tipoCliente = tipoCliente

    def __repr__(self):
        return f"Cliente(id={self.id}, nombre='{self.nombre} {self.apellido}', tipo='{self.tipoCliente}')"


class Reserva:
    def __init__(self, id=None, mesaId=None, clienteId=None, empleadoId=None,
                 fecha_reserva=None, hora_reserva=None, numero_personas=0, notas="", estado="confirmada"):
        self.id = id
        self.mesaId = mesaId
        self.clienteId = clienteId
        self.empleadoId = empleadoId
        self.fecha_reserva = fecha_reserva
        self.hora_reserva = hora_reserva
        self.numero_personas = numero_personas
        self.notas = notas
        self.estado = estado

    def __repr__(self):
        return f"Reserva(id={self.id}, mesa={self.mesaId}, fecha={self.fecha_reserva}, estado='{self.estado}')"


class Orden:
    def __init__(self, id=None, mesaId=None, clienteId=None, empleadoId=None,
                 numero_orden=None, total=0.0, estado="pendiente"):
        self.id = id
        self.mesaId = mesaId
        self.clienteId = clienteId
        self.empleadoId = empleadoId
        self.numero_orden = numero_orden
        self.total = total
        self.estado = estado

    def __repr__(self):
        return f"Orden(numero={self.numero_orden}, mesa={self.mesaId}, total=${self.total}, estado='{self.estado}')"


class DetalleOrden:
    def __init__(self, id=None, ordenId=None, platoId=None, cantidad=0,
                 precio_unitario=0.0, subtotal=0.0, notas_plato=""):
        self.id = id
        self.ordenId = ordenId
        self.platoId = platoId
        self.cantidad = cantidad
        self.precio_unitario = precio_unitario
        self.subtotal = subtotal
        self.notas_plato = notas_plato

    def __repr__(self):
        return f"DetalleOrden(orden={self.ordenId}, plato={self.platoId}, cantidad={self.cantidad})"


class Proveedor:
    def __init__(self, id=None, nombre="", contacto="", email="", telefono="",
                 direccion="", ciudad="", estado="activo"):
        self.id = id
        self.nombre = nombre
        self.contacto = contacto
        self.email = email
        self.telefono = telefono
        self.direccion = direccion
        self.ciudad = ciudad
        self.estado = estado

    def __repr__(self):
        return f"Proveedor(id={self.id}, nombre='{self.nombre}')"


class Inventario:
    def __init__(self, id=None, ingredienteId=None, proveedorId=None, cantidad_actual=0.0,
                 cantidad_minima=0.0, cantidad_maxima=0.0, estado="optimo"):
        self.id = id
        self.ingredienteId = ingredienteId
        self.proveedorId = proveedorId
        self.cantidad_actual = cantidad_actual
        self.cantidad_minima = cantidad_minima
        self.cantidad_maxima = cantidad_maxima
        self.estado = estado

    def __repr__(self):
        return f"Inventario(ingrediente={self.ingredienteId}, cantidad={self.cantidad_actual}, estado='{self.estado}')"


class Pago:
    def __init__(self, id=None, ordenId=None, monto=0.0, metodo_pago="efectivo",
                 fecha_pago=None, estado="completado"):
        self.id = id
        self.ordenId = ordenId
        self.monto = monto
        self.metodo_pago = metodo_pago
        self.fecha_pago = fecha_pago
        self.estado = estado

    def __repr__(self):
        return f"Pago(orden={self.ordenId}, monto=${self.monto}, metodo='{self.metodo_pago}')"


class ConexionSGR:
    def __init__(self, servidor="localhost", usuario="usuario_sgr", contraseña="pass_sgr_2024", base_datos="sgr"):
        self.servidor = servidor
        self.usuario = usuario
        self.contraseña = contraseña
        self.base_datos = base_datos
        self.conexion = None
        self.cursor = None

    def conectar(self):
        try:
            self.conexion = mysql.connector.connect(
                host=self.servidor,
                user=self.usuario,
                password=self.contraseña,
                database=self.base_datos
            )
            self.cursor = self.conexion.cursor()
            print(f"✓ Conectado a '{self.base_datos}'")
            return True
        except Exception as e:
            print(f"✗ Error: {e}")
            return False

    def desconectar(self):
        if self.cursor:
            self.cursor.close()
        if self.conexion:
            self.conexion.close()
        print("✓ Desconectado")

    def ejecutar_query(self, query, params=None):
        try:
            if params:
                self.cursor.execute(query, params)
            else:
                self.cursor.execute(query)
            self.conexion.commit()
            return True
        except Exception as e:
            self.conexion.rollback()
            print(f"Error: {e}")
            return False

    def obtener_todos(self, tabla):
        try:
            self.cursor.execute(f"SELECT * FROM {tabla}")
            return self.cursor.fetchall()
        except Exception as e:
            print(f"Error: {e}")
            return []

    def obtener_por_id(self, tabla, id_valor):
        try:
            self.cursor.execute(f"SELECT * FROM {tabla} WHERE id = %s", (id_valor,))
            return self.cursor.fetchone()
        except Exception as e:
            print(f"Error: {e}")
            return None

    def insertar(self, tabla, datos):
        columnas = ", ".join(datos.keys())
        placeholders = ", ".join(["%s"] * len(datos))
        query = f"INSERT INTO {tabla} ({columnas}) VALUES ({placeholders})"
        try:
            self.cursor.execute(query, tuple(datos.values()))
            self.conexion.commit()
            id_insertado = self.cursor.lastrowid
            print(f"✓ Insertado en {tabla} con ID: {id_insertado}")
            return id_insertado
        except Exception as e:
            self.conexion.rollback()
            print(f"Error al insertar: {e}")
            return None

    def actualizar(self, tabla, id_valor, datos):
        actualizaciones = ", ".join([f"{k} = %s" for k in datos.keys()])
        query = f"UPDATE {tabla} SET {actualizaciones} WHERE id = %s"
        valores = tuple(list(datos.values()) + [id_valor])
        try:
            self.cursor.execute(query, valores)
            self.conexion.commit()
            print(f"✓ Actualizado en {tabla}")
            return True
        except Exception as e:
            self.conexion.rollback()
            print(f"Error: {e}")
            return False

    def eliminar(self, tabla, id_valor):
        try:
            self.cursor.execute(f"DELETE FROM {tabla} WHERE id = %s", (id_valor,))
            self.conexion.commit()
            print(f"✓ Eliminado de {tabla}")
            return True
        except Exception as e:
            self.conexion.rollback()
            print(f"Error: {e}")
            return False

    def contar_registros(self, tabla):
        try:
            self.cursor.execute(f"SELECT COUNT(*) FROM {tabla}")
            resultado = self.cursor.fetchone()
            return resultado[0] if resultado else 0
        except Exception as e:
            print(f"Error: {e}")
            return 0


def mostrar_menu_principal():
    print("\n" + "="*60)
    print("SISTEMA DE GESTIÓN DE RESTAURANTES (SGR)")
    print("="*60)
    print("\n  1. Gestionar Categorías de Platos")
    print("  2. Gestionar Ingredientes")
    print("  3. Gestionar Platos")
    print("  4. Gestionar Empleados")
    print("  5. Gestionar Mesas")
    print("  6. Gestionar Clientes")
    print("  7. Gestionar Reservas")
    print("  8. Gestionar Órdenes")
    print("  9. Gestionar Inventario")
    print("  10. Gestionar Proveedores")
    print("  11. Gestionar Pagos")
    print("  12. Ver Reportes")
    print("  0. Salir")
    print("\n" + "="*60)


def menu_categorias(db):
    while True:
        print("\n--- CATEGORÍAS DE PLATOS ---")
        print("  1. Ver todas")
        print("  2. Agregar nueva")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("categorias_platos")
            if registros:
                print(f"\nTotal: {len(registros)} categorías\n")
                for reg in registros:
                    print(f"  [{reg[0]}] {reg[1]} - {reg[2]}")
            else:
                print("  No hay categorías")

        elif opcion == "2":
            nombre = input("Nombre: ").strip()
            descripcion = input("Descripción: ").strip()
            datos = {"nombre": nombre, "descripcion": descripcion}
            db.insertar("categorias_platos", datos)

        elif opcion == "3":
            break


def menu_ingredientes(db):
    while True:
        print("\n--- INGREDIENTES ---")
        print("  1. Ver todos")
        print("  2. Agregar nuevo")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("ingredientes")
            if registros:
                print(f"\nTotal: {len(registros)} ingredientes\n")
                for reg in registros:
                    print(f"  [{reg[0]}] {reg[1]} - ${reg[4]} por {reg[3]}")
            else:
                print("  No hay ingredientes")

        elif opcion == "2":
            nombre = input("Nombre: ").strip()
            descripcion = input("Descripción: ").strip()
            unidad = input("Unidad de medida (kg, L, unidad, etc): ").strip()
            try:
                precio = float(input("Precio unitario: ").strip())
                datos = {"nombre": nombre, "descripcion": descripcion,
                        "unidadMedida": unidad, "precioUnitario": precio}
                db.insertar("ingredientes", datos)
            except ValueError:
                print("✗ Precio inválido")

        elif opcion == "3":
            break


def menu_platos(db):
    while True:
        print("\n--- PLATOS ---")
        print("  1. Ver todos")
        print("  2. Agregar nuevo")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("platos")
            if registros:
                print(f"\nTotal: {len(registros)} platos\n")
                for reg in registros:
                    print(f"  [{reg[0]}] {reg[1]} - ${reg[4]} - {reg[7]}")
            else:
                print("  No hay platos")

        elif opcion == "2":
            nombre = input("Nombre del plato: ").strip()
            descripcion = input("Descripción: ").strip()
            try:
                categoriaId = int(input("ID de categoría: ").strip())
                precio = float(input("Precio: ").strip())
                tiempo = int(input("Tiempo de preparación (minutos): ").strip())
                datos = {"nombre": nombre, "descripcion": descripcion,
                        "categoriaId": categoriaId, "precio": precio,
                        "tiempo_preparacion": tiempo}
                db.insertar("platos", datos)
            except ValueError:
                print("✗ Valores inválidos")

        elif opcion == "3":
            break


def menu_empleados(db):
    while True:
        print("\n--- EMPLEADOS ---")
        print("  1. Ver todos")
        print("  2. Agregar nuevo")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("empleados")
            if registros:
                print(f"\nTotal: {len(registros)} empleados\n")
                for reg in registros:
                    print(f"  [{reg[0]}] {reg[1]} {reg[2]} - {reg[5]}")
            else:
                print("  No hay empleados")

        elif opcion == "2":
            nombre = input("Nombre: ").strip()
            apellido = input("Apellido: ").strip()
            email = input("Email: ").strip()
            telefono = input("Teléfono: ").strip()
            puesto = input("Puesto: ").strip()
            try:
                salario = float(input("Salario: ").strip())
                datos = {"nombre": nombre, "apellido": apellido, "email": email,
                        "telefono": telefono, "puesto": puesto, "salario": salario}
                db.insertar("empleados", datos)
            except ValueError:
                print("✗ Salario inválido")

        elif opcion == "3":
            break


def menu_mesas(db):
    while True:
        print("\n--- MESAS ---")
        print("  1. Ver todas")
        print("  2. Agregar nueva")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("mesas")
            if registros:
                print(f"\nTotal: {len(registros)} mesas\n")
                for reg in registros:
                    print(f"  Mesa #{reg[1]} - Capacidad: {reg[2]} - {reg[4]}")
            else:
                print("  No hay mesas")

        elif opcion == "2":
            try:
                numero = int(input("Número de mesa: ").strip())
                capacidad = int(input("Capacidad: ").strip())
                ubicacion = input("Ubicación: ").strip()
                datos = {"numero_mesa": numero, "capacidad": capacidad, "ubicacion": ubicacion}
                db.insertar("mesas", datos)
            except ValueError:
                print("✗ Valores inválidos")

        elif opcion == "3":
            break


def menu_clientes(db):
    while True:
        print("\n--- CLIENTES ---")
        print("  1. Ver todos")
        print("  2. Agregar nuevo")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("clientes")
            if registros:
                print(f"\nTotal: {len(registros)} clientes\n")
                for reg in registros:
                    print(f"  [{reg[0]}] {reg[1]} {reg[2]} - {reg[7]}")
            else:
                print("  No hay clientes")

        elif opcion == "2":
            nombre = input("Nombre: ").strip()
            apellido = input("Apellido: ").strip()
            email = input("Email: ").strip()
            telefono = input("Teléfono: ").strip()
            datos = {"nombre": nombre, "apellido": apellido, "email": email, "telefono": telefono}
            db.insertar("clientes", datos)

        elif opcion == "3":
            break


def menu_reservas(db):
    while True:
        print("\n--- RESERVAS ---")
        print("  1. Ver todas")
        print("  2. Agregar nueva")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("reservas")
            if registros:
                print(f"\nTotal: {len(registros)} reservas\n")
                for reg in registros:
                    print(f"  Mesa #{reg[1]} - {reg[4]} {reg[5]} - {reg[9]}")
            else:
                print("  No hay reservas")

        elif opcion == "2":
            try:
                mesaId = int(input("ID de mesa: ").strip())
                clienteId = int(input("ID de cliente: ").strip())
                empleadoId = int(input("ID de empleado (opcional, 0 para omitir): ").strip())
                fecha = input("Fecha (YYYY-MM-DD): ").strip()
                hora = input("Hora (HH:MM): ").strip()
                personas = int(input("Número de personas: ").strip())

                empleadoId = empleadoId if empleadoId > 0 else None
                datos = {"mesaId": mesaId, "clienteId": clienteId, "empleadoId": empleadoId,
                        "fecha_reserva": fecha, "hora_reserva": hora, "numero_personas": personas}
                db.insertar("reservas", datos)
            except ValueError:
                print("✗ Valores inválidos")

        elif opcion == "3":
            break


def menu_ordenes(db):
    while True:
        print("\n--- ÓRDENES ---")
        print("  1. Ver todas")
        print("  2. Crear nueva")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("ordenes")
            if registros:
                print(f"\nTotal: {len(registros)} órdenes\n")
                for reg in registros:
                    print(f"  Orden #{reg[5]} - Mesa {reg[1]} - ${reg[7]} - {reg[9]}")
            else:
                print("  No hay órdenes")

        elif opcion == "2":
            try:
                mesaId = int(input("ID de mesa: ").strip())
                empleadoId = int(input("ID de empleado: ").strip())
                numero_orden = int(input("Número de orden: ").strip())
                clienteId = int(input("ID de cliente (opcional, 0 para omitir): ").strip())

                clienteId = clienteId if clienteId > 0 else None
                datos = {"mesaId": mesaId, "clienteId": clienteId, "empleadoId": empleadoId,
                        "numero_orden": numero_orden}
                db.insertar("ordenes", datos)
            except ValueError:
                print("✗ Valores inválidos")

        elif opcion == "3":
            break


def menu_inventario(db):
    while True:
        print("\n--- INVENTARIO ---")
        print("  1. Ver stock")
        print("  2. Agregar ingrediente")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("inventario")
            if registros:
                print(f"\nTotal: {len(registros)} ingredientes en stock\n")
                for reg in registros:
                    print(f"  Ingrediente #{reg[1]} - Stock: {reg[3]} - {reg[8]}")
            else:
                print("  No hay inventario")

        elif opcion == "2":
            try:
                ingredienteId = int(input("ID de ingrediente: ").strip())
                cantidad = float(input("Cantidad: ").strip())
                datos = {"ingredienteId": ingredienteId, "cantidad_actual": cantidad}
                db.insertar("inventario", datos)
            except ValueError:
                print("✗ Valores inválidos")

        elif opcion == "3":
            break


def menu_proveedores(db):
    while True:
        print("\n--- PROVEEDORES ---")
        print("  1. Ver todos")
        print("  2. Agregar nuevo")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("proveedores")
            if registros:
                print(f"\nTotal: {len(registros)} proveedores\n")
                for reg in registros:
                    print(f"  [{reg[0]}] {reg[1]} - {reg[4]}")
            else:
                print("  No hay proveedores")

        elif opcion == "2":
            nombre = input("Nombre: ").strip()
            contacto = input("Contacto: ").strip()
            email = input("Email: ").strip()
            telefono = input("Teléfono: ").strip()
            datos = {"nombre": nombre, "contacto": contacto, "email": email, "telefono": telefono}
            db.insertar("proveedores", datos)

        elif opcion == "3":
            break


def menu_pagos(db):
    while True:
        print("\n--- PAGOS ---")
        print("  1. Ver todos")
        print("  2. Registrar pago")
        print("  3. Volver")
        opcion = input("Opción: ").strip()

        if opcion == "1":
            registros = db.obtener_todos("pagos")
            if registros:
                print(f"\nTotal: {len(registros)} pagos\n")
                for reg in registros:
                    print(f"  Orden #{reg[1]} - ${reg[2]} - {reg[3]} - {reg[6]}")
            else:
                print("  No hay pagos")

        elif opcion == "2":
            try:
                ordenId = int(input("ID de orden: ").strip())
                monto = float(input("Monto: ").strip())
                print("\nMétodos: 1.Efectivo 2.Tarjeta 3.Transferencia 4.Otro")
                metodos = {1: "efectivo", 2: "tarjeta", 3: "transferencia", 4: "otro"}
                metodo_num = int(input("Seleccionar método: ").strip())
                metodo = metodos.get(metodo_num, "efectivo")

                datos = {"ordenId": ordenId, "monto": monto, "metodo_pago": metodo}
                db.insertar("pagos", datos)
            except ValueError:
                print("✗ Valores inválidos")

        elif opcion == "3":
            break


def menu_reportes(db):
    print("\n--- REPORTES ---")
    print(f"\nCategorías: {db.contar_registros('categorias_platos')}")
    print(f"Ingredientes: {db.contar_registros('ingredientes')}")
    print(f"Platos: {db.contar_registros('platos')}")
    print(f"Empleados: {db.contar_registros('empleados')}")
    print(f"Mesas: {db.contar_registros('mesas')}")
    print(f"Clientes: {db.contar_registros('clientes')}")
    print(f"Reservas: {db.contar_registros('reservas')}")
    print(f"Órdenes: {db.contar_registros('ordenes')}")
    print(f"Detalles de órdenes: {db.contar_registros('detalles_ordenes')}")
    print(f"Proveedores: {db.contar_registros('proveedores')}")
    print(f"Inventario: {db.contar_registros('inventario')}")
    print(f"Pagos: {db.contar_registros('pagos')}")


def main():
    db = ConexionSGR()

    if not db.conectar():
        print("\nNo se pudo conectar a la base de datos.")
        return

    try:
        while True:
            mostrar_menu_principal()
            opcion = input("Opción: ").strip()

            if opcion == "1":
                menu_categorias(db)
            elif opcion == "2":
                menu_ingredientes(db)
            elif opcion == "3":
                menu_platos(db)
            elif opcion == "4":
                menu_empleados(db)
            elif opcion == "5":
                menu_mesas(db)
            elif opcion == "6":
                menu_clientes(db)
            elif opcion == "7":
                menu_reservas(db)
            elif opcion == "8":
                menu_ordenes(db)
            elif opcion == "9":
                menu_inventario(db)
            elif opcion == "10":
                menu_proveedores(db)
            elif opcion == "11":
                menu_pagos(db)
            elif opcion == "12":
                menu_reportes(db)
            elif opcion == "0":
                print("\n¡Hasta luego!")
                break
            else:
                print("✗ Opción inválida")

    finally:
        db.desconectar()


if __name__ == "__main__":
    main()
