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


# Flujo 2 - registrar mantenimiento realizado

Inicio:
Mariana ya sabe que el aceite está vencido (resultado del Flujo 1). Fue al taller y vuelve a la app para dejarlo asentado.

Flujo:
    - Abrir Inicio y ver el aceite vencido
    - Tocar la tarjeta de cambio de aceite
    - Completar kilometraje y fecha del servicio
    - Guardar el mantenimiento
    - Volver a Inicio y comprobar que el aceite quedó al día

Resultado:
El servicio queda en el historial y el próximo aceite se recalcula. El pendiente ahora es otro (frenos).


# Flujo 3 - consultar historial

Inicio:
Mariana ya registró el aceite (resultado del Flujo 2). Ahora quiere revisar qué mantenimientos ya hizo y con qué datos quedaron guardados.

Flujo:
    - Abrir Inicio
    - Entrar al historial
    - Revisar la lista de servicios hechos
    - Abrir el detalle del cambio de aceite
    - Ver la fecha y el kilometraje del servicio

Resultado:
Consulta el pasado dentro de la app: aceite el 3 sep 2026 a los 12.500 km.
