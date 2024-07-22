DROP DATABASE IF EXISTS ferreteria;
CREATE DATABASE IF NOT EXISTS ferreteria;
USE ferreteria;
/*
Tabla Vendedor
○ Atributos: 
códigoVend (INT, clave primaria, autoincremental), 
nombreVend (VARCHAR), 
apellidoVend (VARCHAR), 
sexoVend (CHAR), 
telefonoVend (VARCHAR), 
fechaContrato (DATE), 

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
/*
Tabla Cliente
Atributos: 
cedulaCli (VARCHAR, clave primaria), 
nombreCli (VARCHAR), 
apellidoCli (VARCHAR), 
limiteCredito (DECIMAL), 
calle (VARCHAR), 
nro (VARCHAR), 
ciudad (VARCHAR), 
codigoVend (INT, clave foránea), 
cedulaReco (VARCHAR, clave foránea).
*/
CREATE TABLE IF NOT EXISTS cliente(
  cedulaCli VARCHAR(150) PRIMARY KEY,
  nombreCli VARCHAR(50),
  apellidoCli VARCHAR(50),
  limiteCredito DECIMAL(10,2),
  calle VARCHAR(100),
  nro VARCHAR(100),
  ciudad VARCHAR(100),
  codigoVend INT(11),
  cedulaReco VARCHAR(150),
  FOREIGN KEY (codigoVend) REFERENCES Vendedor(codigoVend) ON DELETE CASCADE,
  FOREIGN KEY (cedulaReco) REFERENCES Cliente(cedulaCli) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/* ALTER TABLE vendedor
ADD CONSTRAINT fk_cedulaReco
FOREIGN KEY (cedulaReco) REFERENCES Cliente(cedulaCli) ON DELETE CASCADE; */

/*
Tabla Articulo
Atributos: 
codigo (INT, clave primaria, autoincremental), 
descripcion (VARCHAR), 
precio (DECIMAL), 
stock (INT).
*/
CREATE TABLE IF NOT EXISTS articulo(
  codigo INT(11) PRIMARY KEY AUTO_INCREMENT,
  descripcion VARCHAR(150),
  precio DECIMAL(10,2),
  stock INT(11)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*
Tabla Factura
○ Atributos: 
nroFactura (INT, clave primaria, autoincremental), 
fechaElaboracion (DATE), 
cedulaCli (VARCHAR, clave foránea), 
codigoVend (INT, clave foránea). ○

Relaciones: 
cedulaCli referencia a Cliente (cedulaCli), 
codigoVend referencia a Vendedor (codigoVend).
*/
CREATE TABLE IF NOT EXISTS factura(
  nroFactura INT(11) PRIMARY KEY AUTO_INCREMENT,
  fechaElaboracion DATE,
  cedulaCli VARCHAR(30),
  codigoVend INT(11),
  FOREIGN KEY (cedulaCli) REFERENCES Cliente(cedulaCli) ON DELETE CASCADE,
  FOREIGN KEY (codigoVend) REFERENCES Vendedor(codigoVend) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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

/*
Tabla Familiar
Atributos: 
codigoVend (INT, clave foránea), 
nombre (VARCHAR),
fechaNac (DATE), 
parentesco (VARCHAR), 
sexo (CHAR).

Relaciones: 
codigoVend referencia a Vendedor (codigoVend).
*/
CREATE TABLE IF NOT EXISTS familiar(
  codigoVend INT(11), 
  nombreFam VARCHAR(50),
  fechaNac DATE, 
  parentesco VARCHAR(100), 
  sexo CHAR,
  FOREIGN KEY (codigoVend) REFERENCES Vendedor(codigoVend) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*
Tabla Telefono
Atributos: 
cedulaCli (VARCHAR, clave foránea), 
telefono (VARCHAR)

Relaciones: 
cedulaCli referencia a Cliente (cedulaCli).
*/

CREATE TABLE IF NOT EXISTS telefono(
  cedulaCli VARCHAR(150),
  telefono VARCHAR(30),
  FOREIGN KEY (cedulaCli) REFERENCES Cliente(cedulaCli) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;





