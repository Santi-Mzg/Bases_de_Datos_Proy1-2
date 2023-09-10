 # Creacion de la base de datos.
 CREATE DATABASE parquimetros;

 # Seleccion de la base de datos. 
 USE parquimetros;

 # Creacion de tablas para entidades.
 CREATE TABLE Conductores (
    dni SMALLINT unsigned NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(40) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    registro SMALLINT unsigned NOT NULL,
 
    CONSTRAINT pk_Conductores
    PRIMARY KEY (dni)
 ) ENGINE=InnoDB;

 CREATE TABLE Automoviles (
    patente CHAR(6) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    color VARCHAR(40) NOT NULL,
    dni SMALLINT unsigned NOT NULL,

    CONSTRAINT pk_Automoviles
    PRIMARY KEY (patente),

    CONSTRAINT pk_Automoviles_Conductor
    FOREIGN KEY (dni) REFERENCES Conductores (dni)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;



 CREATE TABLE Tipos_tarjeta (
    tipo VARCHAR(20) NOT NULL,
    descuento NUMERIC(3,2) CHECK (descuento >= 0 AND descuento <= 1) NOT NULL,

    CONSTRAINT pk_Tipos_tarjeta
    PRIMARY KEY (tipo)
 ) ENGINE=InnoDB;

CREATE TABLE Tarjetas (
    id_tarjeta INT unsigned NOT NULL AUTO_INCREMENT,
    saldo NUMERIC(5,2) NOT NULL,
    tipo Tipos_tarjeta NOT NULL,
    patente CHAR(6) NOT NULL,

    CONSTRAINT pk_Tarjetas
    PRIMARY KEY (id_tarjeta),

    CONSTRAINT pk_Tarjetas_patente
    FOREIGN KEY (patente) REFERENCES Automoviles (patente) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;

CREATE TABLE Recargas (
    id_tarjeta INT unsigned NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    saldo_anterior NUMERIC(5,2) NOT NULL,
    saldo_posterior NUMERIC(5,2) NOT NULL,

    CONSTRAINT pk_Recargas
    PRIMARY KEY (id_tarjeta, fecha, hora),

    CONSTRAINT pk_Recargas_id_tarjeta
    FOREIGN KEY (id_tarjeta) REFERENCES Tarjetas (id_tarjeta)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;

CREATE TABLE Inspectores (
    legajo INT unsigned NOT NULL AUTO_INCREMENT,
    dni INT unsigned NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    password CHAR(32) NOT NULL,

    CONSTRAINT pk_Inspectores
    PRIMARY KEY (legajo)
 ) ENGINE=InnoDB;

CREATE TABLE Ubicaciones (
    calle VARCHAR(20) NOT NULL,
    altura INT unsigned NOT NULL,
    tarifa NUMERIC(5,2) NOT NULL,

    CONSTRAINT pk_Ubicaciones
    PRIMARY KEY (calle, altura)
 ) ENGINE=InnoDB;

CREATE TABLE Parquimetros (
    id_parq INT unsigned NOT NULL AUTO_INCREMENT,
    numero INT unsigned NOT NULL,
    calle VARCHAR(20) NOT NULL,
    altura INT unsigned NOT NULL,

    CONSTRAINT pk_Parquimetros
    PRIMARY KEY (id_parq),

    CONSTRAINT pk_Parquimetros_calle
    FOREIGN KEY (calle) REFERENCES Ubicaciones (calle)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_Parquimetros_altura
    FOREIGN KEY (altura) REFERENCES Ubicaciones (altura)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;

 # Creacion de tablas para relaciones.

CREATE TABLE Estacionamientos (
    id_tarjeta INT unsigned NOT NULL AUTO_INCREMENT,
    id_parq INT unsigned NOT NULL AUTO_INCREMENT,
    fecha_ent DATE NOT NULL,
    hora_ent TIME NOT NULL,
    fecha_sal DATE NOT NULL,
    hora_sal TIME NOT NULL,

    CONSTRAINT pk_Estacionamientos
    PRIMARY KEY (id_parq, fecha_ent, hora_ent),

    CONSTRAINT pk_Estacionamientos_id_tarjeta
    FOREIGN KEY (id_tarjeta) REFERENCES Tarjetas (id_tarjeta)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_Estacionamientos_id_parq
    FOREIGN KEY (id_parq) REFERENCES Parquimetros (id_parq)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;

CREATE TABLE Accede (
    legajo INT unsigned NOT NULL AUTO_INCREMENT,
    id_parq INT unsigned NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,

    CONSTRAINT pk_Accede
    PRIMARY KEY (id_parq, fecha, hora),

    CONSTRAINT pk_Accede_legajo
    FOREIGN KEY (legajo) REFERENCES Inspectores (legajo)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_Accede_id_parq
    FOREIGN KEY (id_parq) REFERENCES Parquimetros (id_parq)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;

 CREATE TABLE Asociado_con (
    id_asociado_con INT unsigned NOT NULL AUTO_INCREMENT,
    legajo INT unsigned NOT NULL AUTO_INCREMENT,
    calle VARCHAR(20) NOT NULL,
    altura INT unsigned NOT NULL,
    dia VARCHAR(7) NOT NULL,
    turno CHAR(1) NOT NULL,

    CONSTRAINT pk_Asociado_con
    PRIMARY KEY (id_asociado_con),

    CONSTRAINT pk_Asociado_con_legajo
    FOREIGN KEY (legajo) REFERENCES Inspectores (legajo)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_Asociado_con_calle
    FOREIGN KEY (calle) REFERENCES Ubicaciones (calle)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_Asociado_con_altura
    FOREIGN KEY (altura) REFERENCES Ubicaciones (altura)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;

 CREATE TABLE Multas (
    numero INT unsigned NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    patente CHAR(6) NOT NULL,
    id_asociado_con INT unsigned NOT NULL AUTO_INCREMENT,

    CONSTRAINT pk_Multas
    PRIMARY KEY (numero),

    CONSTRAINT pk_Multas_patente
    FOREIGN KEY (patente) REFERENCES Automoviles (patente)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_Multas_id_asociado_con
    FOREIGN KEY (id_asociado_con) REFERENCES Asociado_con (id_asociado_con)
        ON DELETE RESTRICT ON UPDATE CASCADE,
 ) ENGINE=InnoDB;