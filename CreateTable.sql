CREATE TABLE persona (
    ID_persona INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    CI VARCHAR(50) NOT NULL UNIQUE,
    FechaNacimiento DATE NOT NULL,
    Telefono VARCHAR(50),
    Email VARCHAR(100),
    Direccion VARCHAR(200),
--sin estado en persona
);

CREATE TABLE membresia (
    ID_membresia INT IDENTITY(1,1) PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,       -- Ej: Mensual, Trimestral, Premium
    Descripcion VARCHAR(200),
    DiasDuracion INT NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
);

CREATE TABLE socio (
    ID_socio INT IDENTITY(1,1) PRIMARY KEY,
    ID_persona INT NOT NULL,
    FechaRegistro DATE DEFAULT GETDATE(),
    Estado varchar(100), --por variedad de casos no usar BIT
    ID_membresia INT NULL,
    FOREIGN KEY (ID_persona) REFERENCES persona(ID_persona),
    FOREIGN KEY (ID_membresia) REFERENCES membresia(ID_membresia)
);

CREATE TABLE empleado (
    ID_empleado INT IDENTITY(1,1) PRIMARY KEY,
    ID_persona INT NOT NULL,
    Tipo VARCHAR(50) NOT NULL,  -- Ej: Coach, Recepcionista
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    Estado varchar(100),
    FOREIGN KEY (ID_persona) REFERENCES persona(ID_persona)
);

CREATE TABLE clase (
    ID_clase INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Horario VARCHAR(100) NOT NULL,
    ID_coach INT NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_coach) REFERENCES empleado(ID_empleado)
);

CREATE TABLE pago (
    ID_pago INT IDENTITY(1,1) PRIMARY KEY,
    ID_membresia INT NULL,
    ID_clase INT NULL,
    ID_socio INT NOT NULL,
    FechaPago DATE DEFAULT GETDATE(),
    Unidades INT DEFAULT 1,   -- cantidad de clases o periodos
    FechaInicio DATE,
    FechaFin DATE,
    Total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_membresia) REFERENCES membresia(ID_membresia),
    FOREIGN KEY (ID_clase) REFERENCES clase(ID_clase),
    FOREIGN KEY (ID_socio) REFERENCES socio(ID_socio)
);

CREATE TABLE inventario (
    ID_objeto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Tipo VARCHAR(100),
    Marca VARCHAR(100),
    Cantidad INT DEFAULT 1,
    Estado VARCHAR(50) DEFAULT 'Bueno'
);

CREATE TABLE proveedor (
    ID_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Telefono VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE gastos (
    ID_gasto INT IDENTITY(1,1) PRIMARY KEY,
    ID_proveedor INT NOT NULL,
    ID_objeto INT NULL, --no necesariamente objeto puede ser servicio asi que puede ser nulo
    FechaGasto DATE DEFAULT GETDATE(),
    Descripcion VARCHAR(200),
    Total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_proveedor) REFERENCES proveedor(ID_proveedor),
    FOREIGN KEY (ID_objeto) REFERENCES inventario(ID_objeto)
);
