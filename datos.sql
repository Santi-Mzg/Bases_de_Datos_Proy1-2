# Carga de datos de prueba.
USE parquimetros;

INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(42399712, "Santiago", "Maszong", "Mitre 123", "2914050336", 107);
INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(35691765, "Fabio", "Ortiz", "Moreno 42", "2914158309", 135);
INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(39309755, "Mariana", "Farias", "San Martin 745", "2915261236", 84);
INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(40290622, "Santiago", "Perez", "Brasil 512", "2914049985", 129);
INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(29900543, "Ignacio", "Torres", "Vieytes", "2915161447", 102);
INSERT INTO conductores (dni, nombre, apellido, direccion, telefono, registro) VALUES(43599713, "Sofia", "Martinez", "Caronti 122", "2914949225", 90);

INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("abc123", "Audi", "A4", "gris", 42399712);
INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("lyz865", "Audi", "R8", "azul", 35691765);
INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("def234", "Fiat", "Palio", "gris", 39309755);
INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("zxy987", "Volkswagen", "Gol", "rojo", 40290622);
INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("gys583", "BMW", "M3", "gris", 29900543);
INSERT INTO automoviles (patente, marca, modelo, color, dni) VALUES("blc225", "Peugeot", "206", "negro", 43599713);


INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("comun", 0.00);
INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("oro", 0.15);
INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("comun1", 0.00);
INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("platino", 0.30);
INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("platino1", 0.20);
INSERT INTO tipos_tarjeta (tipo, descuento) VALUES("comun2", 0.00);

INSERT INTO tarjetas (saldo, tipo, patente) VALUES(100.00,"comun","abc123");
INSERT INTO tarjetas (saldo, tipo, patente) VALUES(599.50,"oro","lyz865");
INSERT INTO tarjetas (id_tarjeta, saldo, tipo, patente) VALUES(9, 58.99,"comun1","def234");
INSERT INTO tarjetas (saldo, tipo, patente) VALUES(125.25,"platino","zxy987");
INSERT INTO tarjetas (id_tarjeta, saldo, tipo, patente) VALUES(25, 860.00,"platino1","gys583");
INSERT INTO tarjetas (id_tarjeta, saldo, tipo, patente) VALUES(58, 321.95,"comun2","blc225");

INSERT INTO recargas (id_tarjeta, fecha, hora, saldo_anterior, saldo_posterior) VALUES(9, "2022-09-19", "17:30", 58.99, 158.99);
INSERT INTO recargas (id_tarjeta, fecha, hora, saldo_anterior, saldo_posterior) VALUES(25, "2022-09-19", "17:30", 860.00, 999.99);
INSERT INTO recargas (id_tarjeta, fecha, hora, saldo_anterior, saldo_posterior) VALUES(58, "2022-09-19", "17:30", 321.95, 500.00);

INSERT INTO inspectores(legajo, dni, nombre, apellido, password) VALUES(205, 43670988, "Martin", "Barco", "mBbjkPyiB7Dk6rWyS6Qp76nJ2UgM4B8R");
INSERT INTO inspectores(legajo, dni, nombre, apellido, password) VALUES(789, 25123498, "Ruben", "Zeballos", "aYmwAVhGpbVkuDaNvcFfFtmUQRwQTWur");
INSERT INTO inspectores(legajo, dni, nombre, apellido, password) VALUES(456, 33342369, "Maria", "Piero", "kiic3LhvpdHWFUtMN4TpTpueyh8GYDuE");
INSERT INTO inspectores(legajo, dni, nombre, apellido, password) VALUES(123, 39852741, "Valentin", "Gonzalez", "6vDaXQGVna6jLuPM2LBnpw6rwDXnSaFm");

INSERT INTO ubicaciones(calle, altura, tarifa) VALUES("Cordoba", 45, 250.50);
INSERT INTO ubicaciones(calle, altura, tarifa) VALUES("Vieytes", 113, 500.00);
INSERT INTO ubicaciones(calle, altura, tarifa) VALUES("Casanova", 743, 120.50);
INSERT INTO ubicaciones(calle, altura, tarifa) VALUES("Estomba", 425, 200.00);

INSERT INTO parquimetros(id_parq, numero, calle, altura) VALUES(21, 1, "Cordoba", 45);
INSERT INTO parquimetros(id_parq, numero, calle, altura) VALUES(1, 2, "Vieytes", 113);
INSERT INTO parquimetros(id_parq, numero, calle, altura) VALUES(34, 3, "Casanova", 743);
INSERT INTO parquimetros(id_parq, numero, calle, altura) VALUES(35, 4, "Estomba", 425);


# Carga de relaciones. -------------------------------------------------------------------------------------------------------


INSERT INTO estacionamientos(id_tarjeta, id_parq, fecha_ent, hora_ent, fecha_sal, hora_sal) VALUES(9, 21, "2023-09-10-", "08:00", "2023-09-11", "09:00");
INSERT INTO estacionamientos(id_tarjeta, id_parq, fecha_ent, hora_ent, fecha_sal, hora_sal) VALUES(25, 1, "2023-09-11", "08:00", NULL, NULL);
INSERT INTO estacionamientos(id_tarjeta, id_parq, fecha_ent, hora_ent, fecha_sal, hora_sal) VALUES(58, 34, "2023-09-16","08:00", NULL, NULL);

INSERT INTO accede(legajo, id_parq, fecha, hora) VALUES(205, 21, "2023-09-10", "08:30");
INSERT INTO accede(legajo, id_parq, fecha, hora) VALUES(789, 1, "2023-09-11", "08:30");
INSERT INTO accede(legajo, id_parq, fecha, hora) VALUES(456, 34, "2023-09-12", "09:00");
INSERT INTO accede(legajo, id_parq, fecha, hora) VALUES(123, 35, "2023-09-13", "09:30");

INSERT INTO asociado_con(id_asociado_con, legajo, calle, altura, dia, turno) VALUES(1, 205, "Cordoba", 45, "Lu", "M");
INSERT INTO asociado_con(id_asociado_con, legajo, calle, altura, dia, turno) VALUES(2, 789, "Vieytes", 113, "Ma", "T");
INSERT INTO asociado_con(id_asociado_con, legajo, calle, altura, dia, turno) VALUES(3, 456, "Casanova", 743, "Ju", "M");
INSERT INTO asociado_con(id_asociado_con, legajo, calle, altura, dia, turno) VALUES(4, 123, "Estomba", 425, "Lu", "T");


INSERT INTO multa(numero, fecha, hora, patente, id_asociado_con) VALUES(24, "2023-09-16", "12:30", "abc123", 1);
INSERT INTO multa(numero, fecha, hora, patente, id_asociado_con) VALUES(25, "2023-09-11", "18:30", "blc225", 3);