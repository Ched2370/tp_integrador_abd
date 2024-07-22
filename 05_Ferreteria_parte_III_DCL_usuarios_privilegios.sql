DROP USER IF EXISTS adminF@localhost;
DROP USER IF EXISTS vendedorF@localhost;

CREATE USER IF NOT EXISTS adminF@localhost IDENTIFIED BY '54321';
CREATE USER IF NOT EXISTS vendedorF@localhost IDENTIFIED BY '12345';

-- asignacion de privilegios para adnministrador
GRANT SELECT, INSERT, UPDATE, DELETE ON ferreteria.* TO adminF@localhost;
GRANT EXECUTE ON FUNCTION calcular_antiguedad TO adminF@localhost;
FLUSH PRIVILEGES;

-- asignacion de privilegios para vendedores
GRANT SELECT ON ferreteria.articulo TO vendedorF@localhost;
GRANT SELECT ON ferreteria.vendedor TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.factura TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.detalle TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.cliente TO vendedorF@localhost;
GRANT SELECT, INSERT, UPDATE ON ferreteria.telefono TO vendedorF@localhost;
GRANT EXECUTE ON PROCEDURE agregar_factura TO vendedorF@localhost;
FLUSH PRIVILEGES;

SHOW GRANTS FOR adminF@localhost;
SHOW GRANTS FOR vendedorF@localhost;


