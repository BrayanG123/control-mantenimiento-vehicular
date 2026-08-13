# Brief v0.1 — Primera hipótesis

> **Tema de prueba:** control de mantenimiento de vehículos
> **Estado:** borrador / foto inicial
> **No es un documento definitivo.** Es una captura del reto que vamos a investigar, discutir y corregir.

---

## Escena de partida (ejemplo)

El auto empieza a hacer un ruido raro al frenar. El dueño intenta recordar: *¿cuándo cambié las pastillas? ¿hace cuántos kilómetros fue el último aceite?*
Busca en la cabeza, en fotos del celular, en un cuaderno viejo de la guantera... y no encuentra nada claro.

---

## 1. Problema
**¿Qué dificultad queremos comprender?**

Cuando una persona es responsable del mantenimiento de uno o más vehículos, se vuelve difícil:
- saber **qué se le hizo al vehículo y cuándo** (aceite, llantas, frenos, filtros, etc.)
- saber **con cuántos kilómetros** se hizo cada mantenimiento
- calcular **cuándo toca el próximo mantenimiento** (por fecha o por kilometraje)
- tener un **historial confiable** para decisiones (venta del auto, garantías, taller nuevo)

**Hipótesis del dolor:** el problema no es solo "recordar una fecha", sino **no tener un registro centralizado y confiable** que permita anticiparse a la falla en lugar de reaccionar cuando ya ocurrió (o cuando el taller "descubre" algo vencido).

---

## 2. Usuario
**¿Quién vive esta dificultad?**

**Dueño de vehículo particular** (auto, camioneta, moto) que:
- maneja el mantenimiento por su cuenta, sin un asistente o flota que se lo gestione
- a veces lleva el auto a distintos talleres (no siempre el mismo)
- quiere evitar sorpresas costosas por mantenimiento atrasado

> Recorte v0.1: dueño individual de 1 a 3 vehículos personales, no flotas empresariales ni talleres como usuarios.

---

## 3. Contexto
**¿Dónde y cuándo ocurre?**

- En el **taller**, al momento de pagar y recibir la factura/detalle del servicio
- **Antes de un viaje largo**, cuando se revisa si "está todo al día"
- Cuando aparece una **señal de alerta**: ruido, luz del tablero, sensación rara al manejar
- **Meses después**, cuando ya no se recuerda si el cambio de aceite tocaba a los 5,000 o 10,000 km
- Con herramientas improvisadas: notas del celular, papeles del taller, memoria, calcomanía en el parabrisas

El contexto es **físico + intermitente + disperso**: los eventos de mantenimiento ocurren cada cierto tiempo, en lugares distintos, y no hay un solo lugar donde quede todo registrado.

---

## 4. Tarea
**¿Qué intenta hacer el usuario?**

En concreto, intenta:
1. **Registrar** un mantenimiento realizado (tipo: aceite, llantas, frenos, filtros, etc.) con fecha y kilometraje
2. **Actualizar el kilometraje** actual del vehículo
3. **Ver cuándo toca el próximo mantenimiento** (por km recorridos o por tiempo transcurrido)
4. **Consultar el historial completo** de un vehículo cuando lo necesita

La meta no es "llevar una bitácora perfecta"; es **saber en qué estado está el vehículo y anticiparse antes de que algo falle o venza**.

---

## 5. Idea inicial
**¿Qué solución imaginamos por ahora?**

Una experiencia simple (móvil o web ligera) donde el usuario:
- registra su(s) vehículo(s) (ej. "Toyota Corolla 2018")
- carga un mantenimiento con tipo, fecha, kilometraje y (opcional) costo/taller
- ve un resumen claro: **"Cambio de aceite: próximo a los 45,000 km (te faltan 1,200 km)"**
- recibe algún tipo de aviso cuando un mantenimiento está por vencer o vencido

**Asumimos (provisional):** si el sistema muestra de forma clara "qué toca y cuándo", baja la ansiedad de "se me pudo haber pasado algo" y se reducen los mantenimientos atrasados.

> Se puede pivotear si descubrimos que el dolor real es otro (elegir taller de confianza, presupuestar el gasto, comparar precios, etc.).

---

## 6. Alcance
**¿Qué parte pequeña abordamos primero?**

Solo esto:

- **1 vehículo** por usuario (multi-vehículo puede esperar)
- **tipos de mantenimiento básicos** ya definidos (aceite, llantas, frenos)
- **cálculo de próximo mantenimiento por kilometraje** (fecha queda para después)
- **flujo mínimo:** registrar vehículo → cargar mantenimiento → ver próximo mantenimiento → ver historial

Fuera de alcance en v0.1:
- múltiples vehículos / flotas
- recordatorios automáticos (push, email, SMS)
- integración con talleres o cotización de servicios
- registro de gastos/costos detallado por mantenimiento
- mantenimiento predictivo basado en uso real (sensor, OBD, etc.)

---

## Notas de trabajo

- Versión: **v0.1** — tema de prueba para discutir y corregir
- Preguntas abiertas para la siguiente iteración:
  - ¿Duele más **olvidar que algo vencía**, **no saber cuándo toca**, o **no tener el historial a la mano**?
  - ¿El intervalo de mantenimiento se calcula mejor por **kilometraje**, por **tiempo**, o por **ambos** (lo que ocurra primero)?
  - ¿El "éxito" es no llegar tarde a un mantenimiento… o simplemente tener la info a mano cuando alguien pregunta ("¿cuándo cambiaste el aceite?")?
- Ejemplo a usar en pruebas: cambio de aceite a los 40,000 km (intervalo cada 5,000 km) → calcular próximo → simular que el auto ya lleva 43,800 km
- Siguiente paso sugerido: validar con 2–3 dueños de vehículo (cómo llevan el mantenimiento hoy) y ajustar problema/usuario