# Navegación Consistente y Experiencia Predictiva

Date: 2026-06-03

## Status

Proposed

## Context

Durante la reunión ATAM, el **Usuario final** identificó que la complejidad financiera no debe traducirse en complejidad de uso. Este atributo de calidad se definió de la siguiente manera:

- **Atributo de calidad:** Facilidad de aprendizaje
- **Refinamiento:** Curva de aprendizaje reducida para nuevo usuario
- **Requerimiento que lo hizo evidente:** Un usuario nuevo debe poder completar su primera transacción sin asistencia externa.
- **Prioridad:** Media

**Escenario de evaluación (ATAM):**

| Elemento | Descripción |
|---|---|
| **Fuente de estímulo** | Nuevo usuario final |
| **Estímulo** | Accede a FinTrack por primera vez y quiere registrar un gasto |
| **Artefacto** | Web PWA (App Shell, Dashboard, Transacciones) |
| **Respuesta** | El sistema presenta una navegación consistente, etiquetas claras y un flujo guiado para completar la acción |
| **Medida de la respuesta** | El usuario completa el registro de su primera transacción en menos de 2 minutos sin necesidad de ayuda externa ni tutorial |

## Decision

Se implementa un patrón de navegación consistente con App Shell como estructura principal, enrutamiento claro por módulos y un flujo de registro de transacciones que sigue una secuencia lógica predecible. Los labels, iconos y mensajes de error utilizan un lenguaje no técnico orientado al usuario final.

## Consequences

- Positiva: Reducción de la curva de aprendizaje, lo que aumenta la adopción por parte de nuevos usuarios.
- Positiva: Menor necesidad de documentación y soporte al usuario.
- Negativa: La simplicidad puede limitar la potencia de funcionalidades avanzadas para usuarios experimentados.
- Negativa: Requiere un diseño UX/UI cuidadoso para mantener la consistencia en todos los flujos.
