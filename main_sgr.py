import pyodbc


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
    """Conexión a MySQL con pyodbc. Toda la manipulación de datos se hace con procedimientos almacenados."""

    def __init__(self, servidor="localhost", usuario="usuario_sgr", contraseña="pass_sgr_2024",
                 base_datos="sgr", puerto="3306", driver=None):
        self.servidor = servidor
        self.usuario = usuario
        self.contraseña = contraseña
        self.base_datos = base_datos
        self.puerto = puerto
        self.driver = driver or self.buscar_driver()
        self.conexion = None

    @staticmethod
    def buscar_driver():
        """Busca el driver MySQL ODBC Unicode instalado (9.0, 8.x, ...)."""
        for nombre in pyodbc.drivers():
            if "MySQL ODBC" in nombre and "Unicode" in nombre:
                return nombre
        return "MySQL ODBC 9.0 Unicode Driver"

    def string_conexion(self):
        return (f"Driver={{{self.driver}}};Server={self.servidor};Database={self.base_datos};"
                f"PORT={self.puerto};user={self.usuario};password={self.contraseña};")

    def conectar(self):
        try:
            self.conexion = pyodbc.connect(self.string_conexion())
            print(f"✓ Conectado a '{self.base_datos}' ({self.driver})")
            return True
        except Exception as e:
            print(f"✗ Error: {e}")
            return False

    def desconectar(self):
        if self.conexion:
            self.conexion.close()
        print("✓ Desconectado")

    def llamar_sp(self, nombre, parametros=None):
        """Ejecuta {CALL nombre(?, ?, ...)} y devuelve (columnas, filas)."""
        parametros = parametros or []
        marcas = ", ".join(["?"] * len(parametros))
        cursor = self.conexion.cursor()
        try:
            cursor.execute("{CALL " + nombre + " (" + marcas + ")}", parametros)
            columnas, filas = [], []
            if cursor.description:
                columnas = [c[0] for c in cursor.description]
                filas = cursor.fetchall()
            # MySQL devuelve un resultado extra de estado después de cada CALL; hay que consumirlo
            while cursor.nextset():
                pass
            self.conexion.commit()
            return columnas, filas
        except Exception as e:
            self.conexion.rollback()
            print(f"✗ Error: {e}")
            return [], []
        finally:
            cursor.close()


# ------------------------------------------------------------------------------
# Configuración de los menús. Por cada tabla:
#   campos  -> parámetros del procedimiento sp_<tabla>_insertar / _actualizar, en orden
#              (columna, texto a mostrar, tipo)   tipo: str | int | float
#   mostrar -> columnas que se muestran al listar
# ------------------------------------------------------------------------------
MENUS = [
    ("Categorías de Platos", "categorias_platos",
     [("nombre", "Nombre", str), ("descripcion", "Descripción", str), ("estado", "Estado (activo/inactivo)", str)],
     ["id", "nombre", "descripcion", "estado"]),
    ("Ingredientes", "ingredientes",
     [("nombre", "Nombre", str), ("descripcion", "Descripción", str), ("unidadMedida", "Unidad (kg, L, unidad)", str),
      ("precioUnitario", "Precio unitario", float), ("estado", "Estado (activo/inactivo)", str)],
     ["id", "nombre", "unidadMedida", "precioUnitario", "estado"]),
    ("Platos", "platos",
     [("nombre", "Nombre", str), ("descripcion", "Descripción", str), ("categoriaId", "ID de categoría", int),
      ("precio", "Precio", float), ("tiempo_preparacion", "Tiempo de preparación (min)", int),
      ("estado", "Estado (disponible/no_disponible)", str)],
     ["id", "nombre", "categoriaId", "precio", "estado"]),
    ("Ingredientes por Plato", "platos_ingredientes",
     [("platoId", "ID de plato", int), ("ingredienteId", "ID de ingrediente", int), ("cantidad", "Cantidad", float),
      ("unidadMedida", "Unidad", str)],
     ["id", "platoId", "ingredienteId", "cantidad", "unidadMedida"]),
    ("Empleados", "empleados",
     [("nombre", "Nombre", str), ("apellido", "Apellido", str), ("email", "Email", str), ("telefono", "Teléfono", str),
      ("puesto", "Puesto", str), ("salario", "Salario", float), ("fechaContratacion", "Fecha contratación (AAAA-MM-DD)", str),
      ("estado", "Estado (activo/inactivo)", str)],
     ["id", "nombre", "apellido", "puesto", "estado"]),
    ("Mesas", "mesas",
     [("numero_mesa", "Número de mesa", int), ("capacidad", "Capacidad", int), ("ubicacion", "Ubicación", str),
      ("estado", "Estado (disponible/ocupada/reservada/mantenimiento)", str)],
     ["id", "numero_mesa", "capacidad", "ubicacion", "estado"]),
    ("Clientes", "clientes",
     [("nombre", "Nombre", str), ("apellido", "Apellido", str), ("email", "Email", str), ("telefono", "Teléfono", str),
      ("direccion", "Dirección", str), ("ciudad", "Ciudad", str), ("tipoCliente", "Tipo (regular/vip/ocasional)", str)],
     ["id", "nombre", "apellido", "ciudad", "tipoCliente"]),
    ("Reservas", "reservas",
     [("mesaId", "ID de mesa", int), ("clienteId", "ID de cliente", int), ("empleadoId", "ID de empleado", int),
      ("fecha_reserva", "Fecha (AAAA-MM-DD)", str), ("hora_reserva", "Hora (HH:MM)", str),
      ("numero_personas", "Número de personas", int), ("notas", "Notas", str),
      ("estado", "Estado (confirmada/cancelada/completada)", str)],
     ["id", "mesaId", "clienteId", "fecha_reserva", "hora_reserva", "estado"]),
    ("Órdenes", "ordenes",
     [("mesaId", "ID de mesa", int), ("clienteId", "ID de cliente", int), ("empleadoId", "ID de empleado", int),
      ("numero_orden", "Número de orden", int), ("hora_orden", "Hora (HH:MM)", str),
      ("estado", "Estado (pendiente/en_preparacion/lista/entregada/cancelada)", str), ("notas", "Notas", str)],
     ["id", "numero_orden", "mesaId", "total", "estado"]),
    ("Detalles de Órdenes", "detalles_ordenes",
     [("ordenId", "ID de orden", int), ("platoId", "ID de plato", int), ("cantidad", "Cantidad", int),
      ("precio_unitario", "Precio unitario (vacío = precio del plato)", float), ("notas_plato", "Notas", str),
      ("estado", "Estado (pendiente/en_preparacion/listo/entregado)", str)],
     ["id", "ordenId", "platoId", "cantidad", "precio_unitario", "subtotal"]),
    ("Inventario", "inventario",
     [("ingredienteId", "ID de ingrediente", int), ("proveedorId", "ID de proveedor", int),
      ("cantidad_actual", "Cantidad actual", float), ("cantidad_minima", "Cantidad mínima", float),
      ("cantidad_maxima", "Cantidad máxima", float), ("fecha_ultima_compra", "Última compra (AAAA-MM-DD)", str),
      ("costo_total", "Costo total", float), ("estado", "Estado (optimo/bajo/critico)", str)],
     ["id", "ingredienteId", "cantidad_actual", "cantidad_minima", "estado"]),
    ("Proveedores", "proveedores",
     [("nombre", "Nombre", str), ("contacto", "Contacto", str), ("email", "Email", str), ("telefono", "Teléfono", str),
      ("direccion", "Dirección", str), ("ciudad", "Ciudad", str), ("estado", "Estado (activo/inactivo)", str)],
     ["id", "nombre", "contacto", "telefono", "estado"]),
    ("Pagos", "pagos",
     [("ordenId", "ID de orden", int), ("monto", "Monto", float),
      ("metodo_pago", "Método (efectivo/tarjeta/transferencia/otro)", str),
      ("referencia_transaccion", "Referencia", str), ("estado", "Estado (pendiente/completado/rechazado)", str),
      ("notas", "Notas", str)],
     ["id", "ordenId", "monto", "metodo_pago", "estado"]),
]


def pedir_valores(campos):
    """Pide cada campo. Vacío = None (en insertar usa el valor por defecto, en actualizar no cambia)."""
    valores = []
    for _, etiqueta, tipo in campos:
        texto = input(f"  {etiqueta}: ").strip()
        valores.append(tipo(texto) if texto else None)
    return valores


def imprimir_filas(columnas, filas, mostrar):
    if not filas:
        print("  No hay registros")
        return
    indices = [columnas.index(c) for c in mostrar]
    print(f"\nTotal: {len(filas)}\n")
    print("  " + " | ".join(mostrar))
    for fila in filas:
        print("  " + " | ".join(str(fila[i]) for i in indices))


def menu_tabla(db, titulo, tabla, campos, mostrar):
    while True:
        print(f"\n--- {titulo.upper()} ---")
        print("  1. Ver todos")
        print("  2. Buscar por ID")
        print("  3. Agregar")
        print("  4. Actualizar")
        print("  5. Eliminar")
        print("  6. Volver")
        opcion = input("Opción: ").strip()

        try:
            if opcion == "1":
                columnas, filas = db.llamar_sp(f"sp_{tabla}_listar")
                imprimir_filas(columnas, filas, mostrar)

            elif opcion == "2":
                id_valor = int(input("ID: ").strip())
                columnas, filas = db.llamar_sp(f"sp_{tabla}_buscar", [id_valor])
                if filas:
                    for columna, valor in zip(columnas, filas[0]):
                        print(f"  {columna}: {valor}")
                else:
                    print("  No existe")

            elif opcion == "3":
                print("(deja vacío para usar el valor por defecto)")
                columnas, filas = db.llamar_sp(f"sp_{tabla}_insertar", pedir_valores(campos))
                if filas:
                    print(f"✓ Insertado en {tabla} con ID: {filas[0][0]}")

            elif opcion == "4":
                id_valor = int(input("ID a actualizar: ").strip())
                print("(deja vacío lo que NO quieras cambiar)")
                columnas, filas = db.llamar_sp(f"sp_{tabla}_actualizar", [id_valor] + pedir_valores(campos))
                print("✓ Actualizado" if filas else "  No existe")

            elif opcion == "5":
                id_valor = int(input("ID a eliminar: ").strip())
                columnas, filas = db.llamar_sp(f"sp_{tabla}_eliminar", [id_valor])
                print("✓ Eliminado" if filas and filas[0][0] else "  No existe")

            elif opcion == "6":
                break

        except ValueError:
            print("✗ Valor inválido")


def menu_reportes(db):
    print("\n--- REPORTES (sp_reporte_conteos) ---\n")
    columnas, filas = db.llamar_sp("sp_reporte_conteos")
    for tabla, cantidad in filas:
        print(f"  {tabla}: {cantidad}")


def mostrar_menu_principal():
    print("\n" + "="*60)
    print("SISTEMA DE GESTIÓN DE RESTAURANTES (SGR)")
    print("="*60 + "\n")
    for numero, menu in enumerate(MENUS, start=1):
        print(f"  {numero}. Gestionar {menu[0]}")
    print(f"  {len(MENUS) + 1}. Ver Reportes")
    print("  0. Salir")
    print("\n" + "="*60)


def main():
    db = ConexionSGR()

    if not db.conectar():
        print("\nNo se pudo conectar a la base de datos.")
        return

    try:
        while True:
            mostrar_menu_principal()
            opcion = input("Opción: ").strip()

            if opcion == "0":
                print("\n¡Hasta luego!")
                break
            elif opcion == str(len(MENUS) + 1):
                menu_reportes(db)
            elif opcion.isdigit() and 1 <= int(opcion) <= len(MENUS):
                menu_tabla(db, *MENUS[int(opcion) - 1])
            else:
                print("✗ Opción inválida")

    finally:
        db.desconectar()


if __name__ == "__main__":
    main()
