# Persona 

Nombre: Mariana

Nombre y situacion:
Mariana, 25 años, repartidora de delivery. Utiliza diariamente una Honda CB 150 del anio 2021 como herramienta de trabajo.

Objetivo:
Mantener su motocicleta en buenas condiciones para poder trabajar sin interrupciones y saber qué mantenimiento debe realizar.

Dificultad:
No lleva un registro de los mantenimientos, no conoce los intervalos correctos y suele llevar la motocicleta al taller solamente cuando nota una falla.

Necesidad:
Necesita saber de manera sencilla qué mantenimiento corresponde hacer y cuándo debe realizarlo, además de conservar un historial de lo que ya hizo.


# App Map

Inicio -> Mi vehiculo -> Mantenimientos

[Inicio] Próximo mantenimiento

[Mivehículo] Datos del vehículo, Kilometraje actual

[Mantenimientos] Registrar mantenimiento, Historial


# Flujo principal (clase 1)

Inicio:
El usuario abre la aplicación.

Flujo:
    - Abrir aplicación
    - Ver mi vehículo
    - Actualizar kilometraje
    - Ver próximo mantenimiento
    - Consultar mantenimiento pendiente

Resultado:
El usuario sabe qué mantenimiento necesita realizar y a qué kilometraje corresponde.


# Flujo 2 - clase 5 (jerarquia y layout)

Pantalla: Inicio - Proximo mantenimiento

Mariana abre la app despues de actualizar el kilometraje en Mi vehiculo.

Flujo:
    - Abrir la app (pestaña Inicio)
    - Ver arriba los datos de su moto y el km actual
    - Revisar la lista de mantenimientos
    - Identificar cuales estan vencidos (rojo), proximos (naranja) o al dia (verde)
    - Si quiere datos nuevos, toca el boton de actualizar

Resultado:
Entiende de un vistazo que mantenimiento le urge y cuantos km le faltan, sin leer toda la lista linea por linea.