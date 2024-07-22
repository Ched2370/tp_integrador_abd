DELIMITER //
USE ferreteria;
CREATE FUNCTION calcular_antiguedad(p_codigoVend INT) 
RETURNS VARCHAR(255)
BEGIN
  DECLARE fecha_ingreso DATE;
  DECLARE antiguedad INT;
  DECLARE apellido VARCHAR(255);
  DECLARE nombre VARCHAR(255);
  DECLARE resultado VARCHAR(255);

  SELECT v.fechaContrato, v.apellidoVend, v.nombreVend INTO fecha_ingreso, apellido, nombre
  FROM vendedor v
  WHERE v.codigoVend = p_codigoVend;

  SET antiguedad = TIMESTAMPDIFF(YEAR, fecha_ingreso, CURDATE());
  SET resultado = CONCAT(nombre, ' ', apellido, ', antigüedad: ', antiguedad, ' años');

  RETURN resultado;
END//
DELIMITER ;

-- Crear procedimientos que inserte nueva factura junto con sus detalles
DROP PROCEDURE IF EXISTS agregar_factura;
DELIMITER //

CREATE PROCEDURE agregar_factura(IN p_cedulaCli VARCHAR(150), IN p_codigoVend INT)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SELECT 'Error al agregar factura';
    ROLLBACK;
  END;

  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  START TRANSACTION;

  INSERT INTO factura(cedulaCli, codigoVend, fechaElaboracion)
  VALUES (p_cedulaCli, p_codigoVend, CURRENT_DATE());

  SELECT 'nueva factura agregada';
  COMMIT;
END//

DELIMITER ;

-- Crear trigger para actualizar el stock
DROP TRIGGER IF EXISTS actualizar_stock_update;
DROP TRIGGER IF EXISTS actualizar_stock_insert;
DELIMITER //

CREATE TRIGGER actualizar_stock_update
AFTER UPDATE ON detalle
FOR EACH ROW
BEGIN
  UPDATE articulo
  SET stock = stock - NEW.cantidad
  WHERE articulo.codigo = NEW.codigo;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER actualizar_stock_insert
AFTER INSERT ON detalle
FOR EACH ROW
BEGIN
  UPDATE articulo
  SET stock = stock - NEW.cantidad
  WHERE articulo.codigo = NEW.codigo;
END//

DELIMITER ;

-- Crear vista resumen_factura
CREATE VIEW IF NOT EXISTS resumen_facturas AS
SELECT f.nroFactura, f.fechaElaboracion, a.descripcion, d.cantidad, a.precio * d.cantidad AS subTotal
FROM factura f
JOIN detalle d ON f.nroFactura = d.nroFactura
JOIN articulo a ON d.codigo = a.codigo
ORDER BY f.nroFactura;



