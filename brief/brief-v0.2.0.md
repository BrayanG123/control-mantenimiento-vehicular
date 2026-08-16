# Brief v0.2.0

## Problema revisado
>
> Los dueños particulares de vehículos enfrentan dos problemas distintos pero igualmente costosos: **olvidar** el mantenimiento que saben que deben hacer y **desconocer** el mantenimiento que no saben que existe. El primero (Carlos) sabe que debe cambiar el aceite periódicamente pero no recuerda cuándo fue la última vez ni a qué kilometraje va su auto. El segundo (Mariana) ni siquiera sabe que la cadena de su motocicleta requiere lubricación regular, y solo descubre el problema cuando ya es una reparación costosa. En ambos casos, la ausencia de un registro centralizado y confiable se agrava porque el usuario carece de información técnica accesible: no conoce los intervalos correctos para su vehículo, no recibe comprobantes detallados del taller y no tiene una fuente confiable que le diga *qué* hacer y *cuándo*. Como dice Carlos: *"Yo sé que le cambié el aceite hace poco, pero no te puedo decir si fueron 3 meses o 6 meses, y menos a qué kilometraje está el auto ahora."* El problema real, entonces, no es solo de memoria sino de **información**: el dueño no tiene ni los datos de su propio historial ni el conocimiento de qué necesidades tiene su vehículo.

## Usuario y contexto
>
> **Usuarios:** dos perfiles tipificados. El **"olvidadizo informado"** (como Carlos, 35 años, dueño de un auto que usa diariamente para trabajar) sabe que el mantenimiento es necesario pero pierde el registro de cuándo lo hizo y a qué kilometraje. El **"desconocedor reactivos"** (como Mariana, 25 años, dueña de una moto que usa para entregas diarias) no sabe qué mantenimiento preventivo requiere su vehículo y actúa solo cuando aparece la falla. Ambos son dueños particulares de 1 vehículo, no flotas ni talleres.
> **Contexto:** el mantenimiento vehicular es una actividad intermitente y dispersa: ocurre cada varios miles de kilómetros, en talleres distintos, sin un lugar físico donde se acumule la información. Se agrava porque los talleres no siempre entregan comprobantes detallados (solo el total de la factura), y el usuario no cuenta con una fuente que le traduzca los intervalos técnicos del manual a información comprensible y personalizada.

## Evidencia
>
> * **Intervalos incorrectos:** Carlos cree que el cambio de aceite de su Toyota Corolla 2019 corresponde cada 10,000 km, cuando en realidad su vehículo lo requiere cada 5,000 km. Sobreestimar el intervalo significa que su auto recorre el doble de kilometraje sin servicio adecuado.
> * **Falta de comprobantes detallados:** el taller donde Carlos lleva su auto no siempre entrega un recibo que especifique qué servicio se realizó y a qué kilometraje, solo el monto total. Esto imposibilita reconstruir el historial a posteriori.
> * **Reparación costosa por prevención faltante:** Mariana tuvo que gastar aproximadamente Bs 350 en reparar la cadena y piñón de su moto por no haberla lubricado a tiempo. El lubricante que habría prevenido el daño cuesta Bs 20, es decir, pagó **17 veces más** por la reparación que por la prevención.
> * **Actuación reactiva:** Mariana nunca lleva un registro de mantenimiento y depende de que la moto *"le avise"* cuando algo falla. Su frase: *"Cuando la moto empezó a hacer un ruido feo, recién supe que algo estaba mal. No sabía que la cadena se tenía que lubricar cada tanto."*

## Insight
>
> El verdadero dolor no es "olvidar una fecha" sino que **el dueño no tiene ni la información ni el conocimiento para anticiparse a la falla**. Hay dos frentes simultáneos: recordar lo que ya sabes (Carlos olvida el kilometraje del último cambio) y descubrir lo que no sabías que debías hacer (Mariana desconoce que la cadena necesita lubricación). Esto implica que una herramienta que solo *registre* el mantenimiento es insuficiente: si el usuario no sabe qué debe hacer, no tendrá nada que registrar hasta que sea tarde. La solución necesita no solo almacenar datos históricos sino **calcular y comunicar proactivamente** qué mantenimiento toca y cuándo, traduciendo intervalos técnicos genéricos a alertas personalizadas por vehículo.

## Hipótesis revisada
>
> **Creemos que** los dueños particulares de vehículos **necesitan** una herramienta móvil que registre el mantenimiento realizado y calcule automáticamente cuándo toca el próximo servicio, **porque** el problema no es solo recordar una fecha sino no tener la información técnica ni el historial organizado para anticiparse a una falla. Sin una fuente que traduzca los intervalos del vehículo a acciones concretas, el dueño termina actuando de forma reactiva — esperando a que algo falle — o basándose en memoria y estimaciones incorrectas, lo que genera gastos evitables y desgaste prematuro del vehículo.

## Alcance inicial
>
> * Soporte para **1 vehículo** registrado por usuario.
> * Tipos básicos de mantenimiento: aceite, llantas, frenos y filtros.
> * Cálculo de próximo mantenimiento basado en **kilometraje** (intervalos predefinidos por tipo).
> * Flujo principal: registrar mantenimiento realizado, actualizar kilometraje actual, ver próximo mantenimiento pendiente, consultar historial.
> * App móvil sencilla, sin IA, orientada al registro y la consulta.

## Fuera del alcance
>
> * Soporte multi-vehículo (más de un vehículo por usuario).
> * Notificaciones push o recordatorios automáticos por tiempo.
> * Integración con talleres o sistemas de facturación.
> * Registro de gastos o presupuestos.
> * Mantenimiento predictivo basado en datos de uso avanzados.

## Preguntas abiertas
>
> * ¿El usuario conoce los intervalos de kilometraje recomendados para cada tipo de mantenimiento de su vehículo, o espera que la app se los proporcione?
> * ¿El cálculo del próximo mantenimiento debe basarse en kilometraje, en tiempo, o en ambos? ¿Cuál es más relevante para el usuario según su uso?
> * ¿Una app dedicada ofrece suficiente valor frente a una nota simple en el celular, considerando que el usuario actual no tiene hábito de registro?
> * ¿La información de intervalos debe provenir de datos del usuario (manual del vehículo) o puede la app sugerir intervalos genéricos por tipo y modelo?
> * ¿Qué peso tiene el desconocimiento (no saber qué hacer) frente al olvido (saber pero no recordar) en la decisión de usar la app? ¿Se prioriza educar o recordar?
