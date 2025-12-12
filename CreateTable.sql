
-- 1) PERSONA
CREATE TABLE persona (
    ID_persona INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    CI VARCHAR(50) NOT NULL UNIQUE,
    FechaNacimiento DATE NOT NULL,
    Telefono VARCHAR(50),
    Email VARCHAR(100),
    Direccion VARCHAR(200)
    -- sin estado en persona
);

-- 2) MEMBRESIA
CREATE TABLE membresia (
    ID_membresia INT IDENTITY(1,1) PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,       -- Ej: Mensual, Trimestral, Premium
    Descripcion VARCHAR(200),
    DiasDuracion INT NOT NULL,
    Precio DECIMAL(10,2) NOT NULL
);
-- 3) SOCIO

CREATE TABLE socio (
    ID_socio INT IDENTITY(1,1) PRIMARY KEY,
    ID_persona INT NOT NULL,
    FechaRegistro DATE DEFAULT GETDATE(),
    Estado VARCHAR(100),            -- por variedad de casos, no usar BIT
    ID_membresia INT NULL,          -- membresía actual del socio (opcional)
    FOREIGN KEY (ID_persona) REFERENCES persona(ID_persona),
    FOREIGN KEY (ID_membresia) REFERENCES membresia(ID_membresia)
);

-- 4) EMPLEADO

CREATE TABLE empleado (
    ID_empleado INT IDENTITY(1,1) PRIMARY KEY,
    ID_persona INT NOT NULL,
    Tipo VARCHAR(50) NOT NULL,      -- Ej: Coach, Recepcionista
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    Estado VARCHAR(100),
    FOREIGN KEY (ID_persona) REFERENCES persona(ID_persona)
);

-- 5) CLASE

CREATE TABLE clase (
    ID_clase INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Horario VARCHAR(100) NOT NULL,
    ID_coach INT NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_coach) REFERENCES empleado(ID_empleado)
);


-- 6) INVENTARIO

CREATE TABLE inventario (
    ID_objeto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Tipo VARCHAR(100),
    Marca VARCHAR(100),
    Cantidad INT DEFAULT 1,
    Estado VARCHAR(50) DEFAULT 'Bueno'
);


-- 7) PROVEEDOR

CREATE TABLE proveedor (
    ID_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Telefono VARCHAR(50),
    Email VARCHAR(100)
);



-- 8) GASTOS

CREATE TABLE gastos (
    ID_gasto INT IDENTITY(1,1) PRIMARY KEY,
    ID_proveedor INT NOT NULL,
    ID_objeto INT NULL,  -- puede ser servicio, así que puede ser NULL
    FechaGasto DATE DEFAULT GETDATE(),
    Descripcion VARCHAR(200),
    Total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ID_proveedor) REFERENCES proveedor(ID_proveedor),
    FOREIGN KEY (ID_objeto) REFERENCES inventario(ID_objeto)
);

-- 9) PAGO (cabecera)

CREATE TABLE pago (
    ID_pago INT IDENTITY(1,1) PRIMARY KEY,
    ID_socio INT NOT NULL,
    ID_membresia INT NULL,                  -- 0 o 1 membresía en el pago
    FechaPago DATE DEFAULT GETDATE(),
    Meses INT DEFAULT 1,                    -- duración de la membresía (si aplica)
    FechaInicio DATE,
    FechaFin DATE,
    Total DECIMAL(10,2) NOT NULL,           -- total general (membresía + clases)
    FOREIGN KEY (ID_socio) REFERENCES socio(ID_socio),
    FOREIGN KEY (ID_membresia) REFERENCES membresia(ID_membresia)
);


-- 10) PAGO_CLASE (detalle de clases por pago)

CREATE TABLE pago_clase (
    ID_pago_clase INT IDENTITY(1,1) PRIMARY KEY,
    ID_pago INT NOT NULL,
    ID_clase INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,            -- nº de clases/sesiones
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal AS (Cantidad * PrecioUnitario) PERSISTED,

    FOREIGN KEY (ID_pago) REFERENCES pago(ID_pago),
    FOREIGN KEY (ID_clase) REFERENCES clase(ID_clase)

    -- Opcional: evitar repetir la misma clase en el mismo pago:
    -- UNIQUE (ID_pago, ID_clase)
);

-- 11) CLASEINSCRITA (relación muchos-a-muchos socio <-> clase)

CREATE TABLE claseInscrita (
    ID_socio INT NOT NULL,
    ID_clase INT NOT NULL,
    FechaInscripcion DATE DEFAULT GETDATE(),
    Estado VARCHAR(50) DEFAULT 'Activa',
    PRIMARY KEY (ID_socio, ID_clase),
    FOREIGN KEY (ID_socio) REFERENCES socio(ID_socio),
    FOREIGN KEY (ID_clase) REFERENCES clase(ID_clase)
    -- intermediario de clase y socio
);
