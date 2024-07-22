
<img style="width: 300px" src="https://github.com/user-attachments/assets/274b2640-f048-42e2-990b-da3aa1cc9cdc" alt="vscode">
<img style="width: 300px" src="https://github.com/user-attachments/assets/7cf54751-a2ec-401a-a138-523b3ffcb608" alt="mysql">






## Ferretería

### Profesores

- Mariela Roxana  Sáez
- Mauricio Ezequiel Funes Massolo
### Colaborador

- Ibañez Mario

### Diagramas

![Pasted image 20240722013843](https://github.com/user-attachments/assets/eed3f913-d384-4e9a-aa67-83e33840874e)

![Pasted image 20240722012716](https://github.com/user-attachments/assets/09769384-a736-45cc-b5de-13bccb0d3b77)

---
### Archivos utilizados

Se ordenaron según los ejercicios dados y se ejecutan en el orden correspondiente. 
Se comprimieron en archivo zip para su descarga, desde el repositorio de GitHub [Link](https://github.com/Ched2370/tp_integrador_abd.git).

![Pasted image 20240722013248](https://github.com/user-attachments/assets/18980084-3c36-43ee-85cf-050c8788bd01)

---

### Estructura de la base de dato (DDL y DML)

Fueron agregados por default un total de:

1. **articulo**: 69
2. **clientes**: 30
3. **detalles**: 712
4. **facturas**: 143
5. **familiares**: 29
6. **teléfonos**: 38
7. **vendedores**: 12

![Pasted image 20240722022606](https://github.com/user-attachments/assets/0aab0bf4-77b9-4e9e-b684-82cb2d795536)

---
### Validaciones y roles

Aparte del rol de DBA. Se crearon los roles de *administrador* y *vendedor*.

![Pasted image 20240722030148](https://github.com/user-attachments/assets/3d3b78d7-5d5d-46a9-8e9c-358458ee9d06)

![Pasted image 20240722025608](https://github.com/user-attachments/assets/81fa4b16-d77c-45cc-a66d-32f83f4aa90e) ![Pasted image 20240722030309](https://github.com/user-attachments/assets/d63e7f29-2740-49b3-a7c8-c5b69a17ae7b)

##### administrador

```sql
CREATE USER IF NOT EXISTS adminF@localhost IDENTIFIED BY '54321';

GRANT SELECT, INSERT, UPDATE, DELETE ON ferreteria.* TO adminF@localhost;
GRANT EXECUTE ON FUNCTION calcular_antiguedad TO adminF@localhost;
FLUSH PRIVILEGES;

```

##### vendedor

```sql
CREATE USER IF NOT EXISTS vendedorF@localhost IDENTIFIED BY '12345';

GRANT SELECT ON ferreteria.articulo TO vendedorF@localhost;
GRANT SELECT ON ferreteria.vendedor TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.factura TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.detalle TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.cliente TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.telefono TO vendedorF@localhost;
GRANT EXECUTE ON PROCEDURE agregar_factura TO vendedorF@localhost;
FLUSH PRIVILEGES;
```
---

### Detalles

##### Al crear la tabla vendedor

En la *relaciones* de la tabla *vendedor*, `codigoVend` genera redundancia con la *clave primaria* y `cedularReco` no es necesaria en la tabla vendedor, al menos, que sea necesario indicar el referente del cliente. Por lo que, se debería crear un mismo vendedor por cada cliente asignado. 
Sin embargo, la relación entre *cliente-vendedor* es de (*cliente*) **N:1** (*vendedor*), por lo que se puede rescatar al *vendedor referente* por medio del *cliente*.

![Pasted image 20240722020537](https://github.com/user-attachments/assets/bb4ee3ce-ef6c-4d1d-acee-07cd92dfed21)

```sql
/*
Tabla Vendedor
Atributos:
códigoVend (INT, clave primaria, autoincremental),
nombreVend (VARCHAR),
apellidoVend (VARCHAR),
sexoVend (CHAR),
telefonoVend (VARCHAR),
fechaContrato (DATE)

Relaciones:
codigoVend referencia a Vendedor (codigoVend), <- no utilizado por redundancia
cedulaReco referencia a Cliente (cedulaCli). <- no utilizado, (Cliente) N:1 (Vendedor)

*/

CREATE TABLE IF NOT EXISTS vendedor(
  codigoVend INT(11) PRIMARY KEY AUTO_INCREMENT,
  nombreVend VARCHAR(100),
  apellidoVend VARCHAR(100),
  sexoVend CHAR(1),
  telefonoVend VARCHAR(30),
  fechaContrato DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

---

##### Al crear la tabla detalle

En la consigna se indica un *atributo* ==objetivoVenta== de *tipo DECIMAL*, lo que no se indica que es lo que se debe almacenar en este, ya que los *subtotales* se sacan por medio de consultas realizada en el ejercicio 3 de la segunda parte del trabajo, por lo que se decidió agregarlo.

![Pasted image 20240722022053](https://github.com/user-attachments/assets/a561b18e-17f9-4f45-9bc2-f884d49d5d3a)

```sql
/*
Tabla Detalle
Atributos:
nroFactura (INT, clave primaria, clave foránea),
codigo (INT, clave primaria, clave foránea),
cantidad (INT).
objetivoVentas (DECIMAL). <-- no utilizado, se calcula desde subtotales

Relaciones:
nroFactura referencia a Factura (nroFactura),
codigo referencia a Articulo (codigo).
*/
CREATE TABLE IF NOT EXISTS detalle(
  nroFactura INT(11),
  codigo INT(11),
  cantidad INT(11),
  PRIMARY KEY (nroFactura, codigo),
  FOREIGN KEY (nroFactura) REFERENCES Factura(nroFactura) ON DELETE CASCADE,
  FOREIGN KEY (codigo) REFERENCES Articulo(codigo) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```
