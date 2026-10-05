# Sistema de Gestión de Restaurantes (SGR)

Sistema completo en Python y MySQL para gestionar restaurantes: menú, empleados, órdenes, clientes, reservas, inventario y más.

## Requisitos

- Python 3.7+
- MySQL (XAMPP o instalación standalone)
- XAMPP (para desarrollo)

## Instalación Rápida

### 1. Configurar Base de Datos

**IMPORTANTE:** Antes de ejecutar el SQL:
1. Abre `database_sgr.sql` en un editor de texto
2. Busca la línea: `CREATE USER 'usuario_sgr'@'localhost' IDENTIFIED BY 'pass_sgr_2024';`
3. Cambia `usuario_sgr` y `pass_sgr_2024` por tus credenciales deseadas
4. **Guarda los cambios**

Ahora:
1. Abre **phpMyAdmin** (`http://localhost/phpmyadmin`)
2. Ve a la pestaña **SQL**
3. Copia todo el contenido de `database_sgr.sql`
4. Pégalo en phpMyAdmin y haz clic en **Enviar**

Esto crea:
- BD `sgr`
- 13 tablas relacionadas
- Usuario con tus credenciales personalizadas

### 2. Configurar Credenciales en main_sgr.py

Si usaste credenciales diferentes en el SQL, actualiza `main_sgr.py`:

Busca la línea:
```python
def __init__(self, servidor="localhost", usuario="root", contraseña="", base_datos="sgr"):
```

Cambia `usuario="root"` y `contraseña=""` con tus credenciales.

### 3. Ejecutar la Aplicación

```powershell
python main_sgr.py
```

El script:
- Instala automáticamente `mysql-connector-python` si no lo tienes
- Se conecta a la BD con tus credenciales
- Abre el menú interactivo

## Características

✓ **13 Tablas optimizadas:**
- Categorías, Platos, Platos_Ingredientes, Ingredientes
- Empleados, Mesas, Clientes
- Órdenes, Detalles de órdenes
- Reservas, Inventario
- Proveedores, Pagos

✓ **Operaciones CRUD completas**
✓ **Relaciones entre tablas**
✓ **Menú interactivo intuitivo**
✓ **Manejo de errores robusto**

## Uso

Al ejecutar `python main_sgr.py`, verás:

```
SISTEMA DE GESTIÓN DE RESTAURANTES (SGR)
============================================================

  1. Gestionar Categorías de Platos
  2. Gestionar Ingredientes
  3. Gestionar Platos
  4. Gestionar Empleados
  5. Gestionar Mesas
  6. Gestionar Clientes
  7. Gestionar Reservas
  8. Gestionar Órdenes
  9. Gestionar Inventario
  10. Gestionar Proveedores
  11. Gestionar Pagos
  12. Ver Reportes
  0. Salir
```

Elige una opción y sigue las instrucciones.

## Estructura de Archivos

```
SGR/
├── database_sgr.sql      # Script SQL para crear la BD
├── main_sgr.py           # Aplicación Python
└── README.md             # Este archivo
```

## Tablas de la Base de Datos

1. **categorias_platos** - Agrupa los platos por tipo
2. **ingredientes** - Materia prima del restaurante
3. **platos** - Catálogo de platos disponibles
4. **platos_ingredientes** - Relación entre platos e ingredientes
5. **empleados** - Personal del restaurante
6. **mesas** - Mesas disponibles
7. **clientes** - Datos de clientes
8. **reservas** - Reservas de mesas
9. **ordenes** - Órdenes/pedidos
10. **detalles_ordenes** - Detalle de platos por orden
11. **proveedores** - Abastecedores
12. **inventario** - Control de stock
13. **pagos** - Registro de pagos

## ⚠️ Seguridad - Credenciales

**Nunca** subas credenciales reales a GitHub. 

Para este proyecto:
1. **Desarrollo local:** Personaliza las credenciales en `database_sgr.sql`
2. **Producción:** Usa variables de entorno o gestores de secretos
3. **GitHub:** El repo contiene solo placeholders, no credenciales reales

Recuerda:
- No hardcodees contraseñas en el código
- No comitees archivos `.env` o con secretos
- Cambia las credenciales antes de usar en producción

## Requisitos de Base de Datos

El script crea automáticamente:

```sql
CREATE DATABASE sgr;
CREATE USER 'usuario_sgr'@'localhost' IDENTIFIED BY 'pass_sgr_2024';
GRANT SELECT, INSERT, UPDATE, DELETE ON sgr.* TO 'usuario_sgr'@'localhost';
```

## Solución de Problemas

### Error: "Access denied for user 'usuario_sgr'"
- Verifica que ejecutaste `database_sgr.sql` en phpMyAdmin
- Asegúrate de que el usuario fue creado con la contraseña correcta

### Error: "No se encuentra mysql.connector"
- El script lo instala automáticamente
- Si falla, ejecuta: `pip install mysql-connector-python`

### Error: "Connection refused"
- Verifica que MySQL (XAMPP) está ejecutándose
- Verifica que estás en `localhost`

## Licencia

Proyecto educativo

## Contacto

Para preguntas o reportar problemas, contacta al equipo de desarrollo.
