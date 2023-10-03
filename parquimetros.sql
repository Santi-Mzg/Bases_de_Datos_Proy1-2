 # Creacion de la base de datos.
 CREATE DATABASE parquimetros;

 # Seleccion de la base de datos. 
 USE parquimetros;

 # Creacion de tablas para entidades.
 CREATE TABLE conductores (
    dni BIGINT unsigned NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(40) NOT NULL,
    telefono VARCHAR(20),
    registro SMALLINT unsigned NOT NULL,
 
    CONSTRAINT pk_conductores
    PRIMARY KEY (dni)
 ) ENGINE=InnoDB;

 CREATE TABLE automoviles (
    patente CHAR(6) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    color VARCHAR(40) NOT NULL,
    dni BIGINT unsigned NOT NULL,

    CONSTRAINT pk_automoviles
    PRIMARY KEY (patente),

    CONSTRAINT pk_automoviles_conductor
    FOREIGN KEY (dni) REFERENCES conductores (dni)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

 CREATE TABLE tipos_tarjeta (
    tipo VARCHAR(20) NOT NULL,
    descuento NUMERIC(3,2) unsigned CHECK (descuento >= 0 AND descuento <= 1) NOT NULL,

    CONSTRAINT pk_tipos_tarjeta
    PRIMARY KEY (tipo)
 ) ENGINE=InnoDB;

CREATE TABLE tarjetas (
    id_tarjeta INT unsigned NOT NULL AUTO_INCREMENT,
    saldo NUMERIC(5,2) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    patente CHAR(6) NOT NULL,

    CONSTRAINT pk_tarjetas
    PRIMARY KEY (id_tarjeta),

    CONSTRAINT pk_tarjetas_tipo
    FOREIGN KEY (tipo) REFERENCES tipos_tarjeta (tipo) 
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_tarjetas_patente
    FOREIGN KEY (patente) REFERENCES automoviles (patente) 
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

CREATE TABLE recargas (
    id_tarjeta INT unsigned NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    saldo_anterior NUMERIC(5,2) NOT NULL,
    saldo_posterior NUMERIC(5,2) NOT NULL,

    CONSTRAINT pk_recargas
    PRIMARY KEY (id_tarjeta, fecha, hora),

    CONSTRAINT pk_recargas_id_tarjeta
    FOREIGN KEY (id_tarjeta) REFERENCES tarjetas (id_tarjeta)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

CREATE TABLE inspectores (
    legajo INT unsigned NOT NULL AUTO_INCREMENT,
    dni INT unsigned NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    password CHAR(32) NOT NULL,

    CONSTRAINT pk_inspectores
    PRIMARY KEY (legajo)
 ) ENGINE=InnoDB;

CREATE TABLE ubicaciones (
    calle VARCHAR(20) NOT NULL,
    altura INT unsigned NOT NULL,
    tarifa NUMERIC(5,2) unsigned NOT NULL,

    CONSTRAINT pk_ubicaciones
    PRIMARY KEY (calle, altura)
 ) ENGINE=InnoDB;

CREATE TABLE parquimetros (
    id_parq INT unsigned NOT NULL AUTO_INCREMENT,
    numero INT unsigned NOT NULL,
    calle VARCHAR(20) NOT NULL,
    altura INT unsigned NOT NULL,

    CONSTRAINT pk_parquimetros
    PRIMARY KEY (id_parq),

    CONSTRAINT pk_parquimetros_calle_altura
    FOREIGN KEY (calle, altura) REFERENCES ubicaciones (calle, altura)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

 # Creacion de tablas para relaciones.

CREATE TABLE estacionamientos (
    id_tarjeta INT unsigned NOT NULL,
    id_parq INT unsigned NOT NULL,
    fecha_ent DATE NOT NULL,
    hora_ent TIME NOT NULL,
    fecha_sal DATE,
    hora_sal TIME,

    CONSTRAINT pk_estacionamientos
    PRIMARY KEY (id_parq, fecha_ent, hora_ent),

    CONSTRAINT pk_estacionamientos_id_tarjeta
    FOREIGN KEY (id_tarjeta) REFERENCES tarjetas (id_tarjeta)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_estacionamientos_id_parq
    FOREIGN KEY (id_parq) REFERENCES parquimetros (id_parq)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

CREATE TABLE accede (
    legajo INT unsigned NOT NULL,
    id_parq INT unsigned NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,

    CONSTRAINT pk_accede
    PRIMARY KEY (id_parq, fecha, hora),

    CONSTRAINT pk_accede_legajo
    FOREIGN KEY (legajo) REFERENCES inspectores (legajo)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_accede_id_parq
    FOREIGN KEY (id_parq) REFERENCES parquimetros (id_parq)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

 CREATE TABLE asociado_con (
    id_asociado_con INT unsigned NOT NULL AUTO_INCREMENT,
    legajo INT unsigned NOT NULL,
    calle VARCHAR(20) NOT NULL,
    altura INT unsigned NOT NULL,
    dia ENUM('do','lu','ma','mi','ju','vi','sa') NOT NULL,
    turno ENUM('m', 't') NOT NULL,

    CONSTRAINT pk_asociado_con
    PRIMARY KEY (id_asociado_con),

    CONSTRAINT pk_asociado_con_legajo
    FOREIGN KEY (legajo) REFERENCES inspectores (legajo)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_asociado_con_calle_altura
    FOREIGN KEY (calle, altura) REFERENCES ubicaciones (calle, altura)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

 CREATE TABLE multa (
    numero INT unsigned NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    patente CHAR(6) NOT NULL,
    id_asociado_con INT unsigned NOT NULL,

    CONSTRAINT pk_multas
    PRIMARY KEY (numero),

    CONSTRAINT pk_multas_patente
    FOREIGN KEY (patente) REFERENCES automoviles (patente)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_multas_id_asociado_con
    FOREIGN KEY (id_asociado_con) REFERENCES asociado_con (id_asociado_con)
        ON DELETE RESTRICT ON UPDATE CASCADE
 ) ENGINE=InnoDB;

 #-------------------------------------------------------------------------
 # Creacion de vista estacionados 
    CREATE VIEW estacionados AS 
    SELECT u.calle, u.altura, t.patente, e.fecha_ent, e.hora_ent FROM (((ubicaciones as u JOIN parquimetros as p ON u.calle = p.calle and u.altura = p.altura) 
        JOIN estacionamientos as e ON p.id_parq = e.id_parq)
        JOIN tarjetas as t ON e.id_tarjeta = t.id_tarjeta)
    WHERE (e.fecha_ent IS NOT NULL and e.hora_ent IS NOT NULL) and (e.fecha_sal IS NULL and e.hora_sal IS NULL);

 #-------------------------------------------------------------------------
 # Creacion de usuarios y otorgamiento de privilegios

    CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
    GRANT ALL PRIVILEGES ON parquimetros.* TO 'admin'@'localhost' WITH GRANT OPTION;
    GRANT CREATE USER ON *.* TO 'admin'@'localhost';
 
    CREATE USER 'venta'@'%' IDENTIFIED BY 'venta';
    GRANT INSERT(saldo, tipo, patente), UPDATE (saldo), SELECT(id_tarjeta) ON parquimetros.tarjetas TO 'venta'@'%';
    GRANT SELECT ON parquimetros.tipos_tarjeta TO 'venta'@'%';

    CREATE USER 'inspector'@'%' IDENTIFIED BY 'inspector';
    GRANT SELECT ON parquimetros.parquimetros, parquimetros.estacionados, parquimetros.asociado_con TO 'inspector'@'%';
    GRANT SELECT(legajo, password) ON parquimetros.inspectores TO 'inspector'@'%'; 
    GRANT SELECT(patente) ON parquimetros.automoviles TO 'inspector'@'%'; 
    GRANT INSERT ON parquimetros.multa, parquimetros.accede TO 'inspector'@'%';

    flush privileges;
    