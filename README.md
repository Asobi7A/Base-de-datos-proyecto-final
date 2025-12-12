# Proyecto_Final_BD
Sistema de Gestión de Gimnasio 

Este proyecto consiste en un sistema para la administración de un gimnasio, permitiendo gestionar socios, personas, membresías, clases, empleados, inventario y pagos.
La base de datos está implementada en SQL Server y el sistema utiliza Python para la interfaz y conexión.

Funcionalidades principales:
  
    Gestión de Personas y Socios:
    
      -Registro de personas con datos personales completos.
      -Conversión de una persona en socio.
      -Asignación opcional de una membresía al momento del registro.
      -Control de estado del socio.
      
    Membresías:
    
      -Creación y administración de distintos tipos de membresías.
      -Definición de duración en días.
      -Configuración de precios.
      
    Clases:
    
      -Registro de clases con horario, nombre y coach responsable.
      -Inscripción de socios a clases.
      -Manejo de una relación muchos-a-muchos entre socios y clases.
      
    Empleados:
    
      -Registro de empleados del gimnasio.
      -Tipos de empleado (coach, recepcionista, etc.).
      -Fechas de inicio y fin de contrato.
      -Control de estado.
      
    Pagos:
    
      -Registro de pagos de membresías.
      -Registro de pagos por clases mediante detalle.
      -Cálculo de totales.
      
    Inventario:
    
      -Registro de objetos del gimnasio.
      -Cantidad, tipo, marca y estado.
      -Vinculación opcional con proveedores.
      
    Gastos:
    
      -Registro de gastos generales.
      -Relación con proveedores.
      -Asociación opcional con inventario.

Tecnologías utilizadas:

    -SQL Server
    -SQL Server Management Studio(SSMS)
    -C#
Autores:

    -Willman Eduardo Miranda Rivero
    -Eito Ygei Matsui
