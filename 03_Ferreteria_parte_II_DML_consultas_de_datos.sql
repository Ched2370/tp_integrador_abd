USE ferreteria;

-- Consulta JOIN LEFT
SELECT v.apellidoVend, v.nombreVend, f.nombreFam, f.parentesco
FROM vendedor v
LEFT JOIN  familiar f ON v.codigoVend = f.codigoVend;

-- Consulta JOIN RIGHT
SELECT  f.fechaElaboracion, c.apellidoCli, c.nombreCli, v.apellidoVend, v.nombreVend, a.descripcion, d.cantidad
FROM factura f
RIGHT JOIN  cliente c ON f.cedulaCli = c.cedulaCli
RIGHT JOIN  vendedor v ON f.codigoVend = v.codigoVend
RIGHT JOIN  detalle d ON f.nroFactura = d.nroFactura 
RIGHT JOIN  articulo a ON d.codigo = a.codigo;

-- Consulta INNER JOIN
SELECT f.nroFactura, f.fechaElaboracion, c.apellidoCli, c.nombreCli, v.apellidoVend, v.nombreVend 
FROM factura f
INNER JOIN cliente c ON f.cedulaCli = c.cedulaCli
INNER JOIN vendedor v ON f.codigoVend = v.codigoVend;

-- Subtotal de cada factura
SELECT f.nroFactura, f.fechaElaboracion, a.descripcion, d.cantidad, a.precio * d.cantidad AS objetivoVentas
FROM factura f
JOIN detalle d ON f.nroFactura = d.nroFactura
JOIN articulo a ON d.codigo = a.codigo