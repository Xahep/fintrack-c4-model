## Decisiones de Arquitectura

### Método ATAM

Para la toma de decisiones arquitectónicas en FinTrack se utilizó el método **ATAM (Architecture Tradeoff Analysis Method)**, un enfoque estructurado y probado en la industria para evaluar decisiones de arquitectura de software en función de atributos de calidad. ATAM no solo documenta qué se decidió, sino que expone explícitamente las compensaciones (tradeoffs) entre diferentes fuerzas arquitectónicas como rendimiento, disponibilidad, seguridad, mantenibilidad y costo.

El proceso ATAM aplicado a FinTrack siguió los siguientes pasos:

| Paso | Descripción |
|---|---|
| **Presentar ATAM** | Introducción del método ATAM a los stakeholders, explicando los objetivos, la dinámica de las sesiones y los entregables esperados. |
| **Presentar las directrices de negocio** | Exposición de las motivaciones del negocio, los drivers arquitectónicos y las restricciones del proyecto. Se presentaron las directrices como las detalladas en la sección anterior de este documento. |
| **Presentar la arquitectura** | Exposición de la arquitectura propuesta de FinTrack: modelo C4, contenedores, componentes, adaptadores y decisiones de despliegue. |
| **Identificar las aproximaciones de arquitectura** | Identificación de los enfoques arquitectónicos adoptados: monolito modular con NestJS, patrón de puertos y adaptadores, PWA con Angular, despliegue cloud-native, etc. |
| **Crear el árbol de atributos** | Construcción de un árbol de atributos de calidad priorizados (disponibilidad, seguridad, mantenibilidad, rendimiento, usabilidad) con refinamientos y escenarios concretos para cada uno. |
| **Analizar las aproximaciones de arquitectura** | Evaluación de cada aproximación arquitectónica contra los atributos de calidad del árbol, identificando puntos de riesgo, sensibilidades y tradeoffs. |
| **Lluvia de ideas y priorización de escenarios** | Generación colaborativa de escenarios adicionales por parte de los stakeholders, seguida de una votación para priorizar los escenarios más críticos. |
| **Re-analizar las aproximaciones** | Reevaluación de las aproximaciones arquitectónicas a la luz de los escenarios priorizados, ajustando las decisiones según los nuevos hallazgos. |
| **Presentar los resultados** | Documentación y comunicación formal de las decisiones arquitectónicas, los riesgos identificados y las compensaciones aceptadas. |

### Decisiones Registradas (ADRs)

Como resultado del proceso ATAM, cada decisión arquitectónica fue registrada como un **ADR (Architecture Decision Record)** utilizando el formato estándar de Plantilla de Decisiones de Arquitectura de Structurizr. Cada ADR documenta:

* El contexto y la motivación detrás de la decisión.
* El atributo de calidad evaluado y su escenario ATAM asociado.
* La decisión tomada, incluyendo el enfoque arquitectónico seleccionado.
* Las consecuencias positivas y negativas (tradeoffs) de la decisión.

Las decisiones de arquitectura de FinTrack se encuentran en el directorio `decisions/` de este proyecto, y están integradas con Structurizr mediante la directiva `!adrs decisions` en el DSL. Esto permite visualizarlas directamente desde el panel de documentación de Structurizr, manteniendo las decisiones sincronizadas con el modelo arquitectónico.

Las seis decisiones registradas hasta la fecha son:

1. **Recuperación automática ante fallos** (0001) — Health checks en ECS Fargate para recuperación en menos de 3 minutos.
2. **Biblioteca de componentes UI reutilizables** (0002) — Biblioteca Angular de componentes compartidos para consistencia visual.
3. **Arquitectura de adaptadores para servicios externos** (0003) — Patrón de puertos y adaptadores para desacoplar infraestructura.
4. **Monitoreo proactivo y alertas automáticas** (0004) — Logging centralizado con AWS CloudWatch y alarmas automáticas.
5. **Arquitectura modular con módulos desacoplados** (0005) — Módulos como contextos delimitados independientes en el backend.
6. **Navegación consistente y experiencia predictiva** (0006) — App Shell con enrutamiento claro y flujos guiados.

Para más información sobre el formato de decisiones de arquitectura en Structurizr, puedes consultar la documentación oficial: [Structurizr — Architecture Decisions](https://docs.structurizr.com/server/decisions).
