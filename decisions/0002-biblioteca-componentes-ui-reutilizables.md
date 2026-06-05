# Biblioteca de Componentes UI Reutilizables

Date: 2026-06-03

## Status

Proposed

## Context

Durante la reunión ATAM, el **Desarrollador** identificó la duplicación de esfuerzo al implementar los mismos patrones visuales en múltiples módulos del frontend. Este atributo de calidad se definió de la siguiente manera:

- **Atributo de calidad:** Reusabilidad
- **Refinamiento:** Componentes UI reutilizables
- **Requerimiento que lo hizo evidente:** La biblioteca UI debe proveer componentes genéricos reutilizables en al menos 3 módulos diferentes.
- **Prioridad:** Media

**Escenario de evaluación (ATAM):**

| Elemento | Descripción |
|---|---|
| **Fuente de estímulo** | Desarrollador frontend |
| **Estímulo** | Necesita implementar una nueva funcionalidad que requiere componentes de tabla, gráfico financiero y formulario |
| **Artefacto** | Biblioteca UI de FinTrack (uiLibrary) |
| **Respuesta** | El desarrollador importa los componentes desde la biblioteca sin necesidad de implementarlos desde cero |
| **Medida de la respuesta** | Los componentes se reutilizan en al menos 3 módulos distintos; un nuevo módulo puede integrarlos con menos de 10 líneas de configuración |

## Decision

Se crea una biblioteca de componentes Angular independiente (uiLibrary) que encapsula los elementos visuales compartidos: tablas, gráficos financieros, formularios, modales y esqueletos de carga. Los módulos funcionales importan estos componentes, evitando duplicación y garantizando consistencia visual.

## Consequences

- Positiva: Consistencia visual en toda la aplicación al usar los mismos componentes base.
- Positiva: Reducción del tiempo de desarrollo de nuevos módulos al poder reutilizar componentes existentes.
- Positiva: Mantenimiento centralizado: un cambio en un componente se propaga a todos los módulos que lo usan.
- Negativa: Curva de aprendizaje inicial para que los desarrolladores conozcan los componentes disponibles.
