# Carga de datos de prueba.
USE parquimetros;

INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(42399712, "Santiago", "Maszong", "Mitre 123", "2914050336", 107);

INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("abc123", "Audi", "A4", "gris", 42399712);

INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("comun", 0.00);

INSERT INTO tarjetas (saldo, tipo, patente) VALUES(100,"comun","abc123");