# Monitoreo Proactivo con Alertas Automáticas

Date: 2026-06-03

## Status

Accepted

## Context

Durante la reunión ATAM, el **Usuario de sistema** identificó la necesidad de detectar y responder a degradaciones del servicio antes de que afecten a los usuarios finales. Este atributo de calidad se definió de la siguiente manera:

- **Atributo de calidad:** Disponibilidad
- **Refinamiento:** Monitoreo proactivo de la salud del sistema
- **Requerimiento que lo hizo evidente:** CloudWatch debe enviar una notificación en menos de 2 minutos cuando la tasa de error HTTP 5xx supere el 1% del tráfico total.
- **Prioridad:** Media

**Escenario de evaluación (ATAM):**

| Elemento | Descripción |
|---|---|
| **Fuente de estímulo** | Pico de tráfico o error interno en el backend |
| **Estímulo** | La tasa de errores HTTP 5xx supera el 1% del tráfico total en la API |
| **Artefacto** | AWS CloudWatch + Backend NestJS (Adaptador de Monitoreo) |
| **Respuesta** | CloudWatch dispara una alarma que notifica al usuario de sistema (operador) vía correo electrónico o dashboard |
| **Medida de la respuesta** | La notificación se envía en menos de 2 minutos desde que se supera el umbral del 1% de errores 5xx |

## Decision

Se configura una alarma en AWS CloudWatch que monitorea la métrica de errores HTTP 5xx del ALB. Cuando la tasa supera el 1% del tráfico total en una ventana de 1 minuto, se dispara una notificación vía SNS hacia el equipo de operaciones. El Adaptador de Monitoreo centraliza el envío de métricas desde el backend.

## Consequences

- Positiva: Detección temprana de problemas de estabilidad en producción.
- Positiva: Respuesta automatizada que reduce el tiempo de diagnóstico.
- Negativa: Dependencia de AWS CloudWatch; migrar a otro proveedor de monitoreo requiere reconfigurar las alarmas.
- Negativa: Los falsos positivos (por ejemplo, picos momentáneos) pueden generar alertas innecesarias si no se ajusta bien la ventana de evaluación.
