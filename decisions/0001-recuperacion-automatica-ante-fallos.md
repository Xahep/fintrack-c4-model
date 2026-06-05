# Recuperación Automática ante Fallos

Date: 2026-06-03

## Status

Accepted

## Context

Durante la reunión ATAM, el **Usuario final** identificó la necesidad de que el sistema permanezca operativo incluso ante fallos del backend. Este atributo de calidad se definió de la siguiente manera:

- **Atributo de calidad:** Disponibilidad
- **Refinamiento:** Tiempo de recuperación ante fallos
- **Requerimiento que lo hizo evidente:** En caso de una caída del backend, el sistema debe recuperarse automáticamente en menos de 3 minutos mediante health checks.
- **Prioridad:** Alta

**Escenario de evaluación (ATAM):**

| Elemento | Descripción |
|---|---|
| **Fuente de estímulo** | Un fallo inesperado en el backend (corte de red, error del contenedor, agotamiento de memoria) |
| **Estímulo** | El backend NestJS deja de responder a las peticiones HTTP |
| **Artefacto** | ECS Fargate + Backend NestJS en contenedor |
| **Respuesta** | ECS Fargate detecta la caída mediante health checks, detiene el contenedor fallido y lanza uno nuevo automáticamente |
| **Medida de la respuesta** | El sistema se recupera en menos de 3 minutos (180 segundos) desde la detección del fallo |

## Decision

Se implementa un mecanismo de health checks periódicos en el backend NestJS que ECS Fargate utiliza para determinar el estado del contenedor. Si el health check falla, Fargate reemplaza automáticamente la tarea fallida por una nueva sin intervención manual.

## Consequences

- Positiva: Recuperación automática sin intervención humana, alineado con el requisito de < 3 minutos.
- Positiva: La configuración de health checks es estándar en ECS Fargate y no requiere infraestructura adicional.
- Negativa: Durante la ventana de recuperación (hasta 3 minutos), los usuarios experimentarán interrupción del servicio.
- Negativa: Las peticiones en curso al momento del fallo se pierden y deben ser reintentadas por el cliente.
