# Sistema de Gestión de Restaurantes (SGR)

Aplicación de consola en **Python** conectada a una base de datos **MySQL** (SGBD libre) para administrar un restaurante: menú (categorías, platos, ingredientes), empleados, mesas, clientes, reservas, órdenes con sus detalles, inventario, proveedores y pagos.

Toda la manipulación de datos se hace con **procedimientos almacenados**: Python no escribe SQL, solo ejecuta `{CALL sp_...}`.

> Este es el repositorio **"hasta conexiones"**. La versión mejorada (estructura por capas + API REST con Flask) está en el repositorio `Sistema_Gestion_Restaurante_API`.

## Herramientas

| Herramienta | Uso |
|---|---|
| MySQL / MariaDB (XAMPP) | SGBD libre |
| Python 3 | Lenguaje |
| pyodbc + MySQL ODBC Unicode Driver | Conexión Python ↔ MySQL |
| VS Code | IDE libre |

## Archivos

```
database_sgr.sql        # 1. Crea la BD "sgr", las 13 tablas y el usuario de la app
procedimientos_sgr.sql  # 2. Crea los 67 procedimientos almacenados
datos_prueba.sql        # 3. Datos de ejemplo (insertados con los procedimientos)
main_sgr.py             # Aplicación de consola
requirements.txt        # Dependencias de Python
```

## Instalación

1. Instalar el **MySQL Connector/ODBC** (driver "MySQL ODBC ... Unicode Driver", 64 bits). El programa detecta solo la versión instalada.
2. Iniciar MySQL desde el panel de XAMPP.
3. En phpMyAdmin (`http://localhost/phpmyadmin`) → pestaña **SQL**, ejecutar en este orden:
   1. `database_sgr.sql`
   2. `procedimientos_sgr.sql`
   3. `datos_prueba.sql` (opcional)
4. Instalar dependencias y ejecutar:

```powershell
py -m pip install -r requirements.txt
py main_sgr.py
```

Credenciales por defecto (definidas en `database_sgr.sql` y en `ConexionSGR` de `main_sgr.py`): usuario `usuario_sgr`, contraseña `pass_sgr_2024`. Si las cambias en el SQL, cámbialas también en `main_sgr.py`.

## Procedimientos almacenados

Por cada una de las 13 tablas hay 5 procedimientos (13 × 5 = 65):

| Procedimiento | Qué hace |
|---|---|
| `sp_<tabla>_listar()` | Devuelve todos los registros |
| `sp_<tabla>_buscar(id)` | Devuelve un registro |
| `sp_<tabla>_insertar(campos...)` | Inserta y devuelve el registro creado. Un `NULL` usa el valor por defecto |
| `sp_<tabla>_actualizar(id, campos...)` | Cambia solo los campos que llegan con valor (`NULL` = no cambiar) |
| `sp_<tabla>_eliminar(id)` | Elimina y devuelve cuántas filas borró |

Y 2 con lógica de negocio:

- `sp_ordenes_recalcular_total(ordenId)`: `ordenes.total` = suma de los subtotales de sus detalles. Lo llaman los procedimientos de `detalles_ordenes`, que además calculan `subtotal = cantidad × precio_unitario` (si no se envía precio, toma el del plato).
- `sp_reporte_conteos()`: cantidad de registros por tabla.

Ejemplo en MySQL:

```sql
CALL sp_platos_insertar('Sancocho', 'Con arroz y aguacate', 2, 28000, NULL, NULL);
CALL sp_platos_actualizar(6, NULL, NULL, NULL, 29500, NULL, NULL);  -- solo cambia el precio
CALL sp_detalles_ordenes_insertar(2, 6, 1, NULL, NULL, NULL);       -- recalcula el total de la orden 2
CALL sp_reporte_conteos();
```

## Uso

Menú principal: una opción por tabla (1–13), `14` reportes, `0` salir. Cada tabla tiene **Ver todos, Buscar por ID, Agregar, Actualizar y Eliminar**.

## Tablas

1. **categorias_platos**: agrupa los platos por tipo
2. **ingredientes**: materia prima
3. **platos**: catálogo del menú
4. **platos_ingredientes**: qué ingredientes lleva cada plato
5. **empleados**: personal
6. **mesas**: mesas del local
7. **clientes**
8. **reservas**: reservas de mesas
9. **ordenes**: pedidos
10. **detalles_ordenes**: platos de cada pedido
11. **proveedores**
12. **inventario**: stock de ingredientes
13. **pagos**

## Solución de problemas

- **"Data source name not found"**: falta el driver MySQL ODBC (paso 1).
- **"Access denied for user 'usuario_sgr'"**: no se ejecutó `database_sgr.sql`, o las credenciales no coinciden.
- **"PROCEDURE sgr.sp_... does not exist"**: no se ejecutó `procedimientos_sgr.sql`.
- **"Connection refused"**: MySQL no está iniciado en XAMPP.

## Licencia

Proyecto educativo.
