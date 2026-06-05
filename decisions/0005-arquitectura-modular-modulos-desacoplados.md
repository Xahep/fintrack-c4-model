# Arquitectura Modular con Módulos Desacoplados

Date: 2026-06-03

## Status

Accepted

## Context

Durante la reunión ATAM, el **Arquitecto de software** identificó la necesidad de que el sistema evolucione sin requerir reestructuraciones mayores. Este atributo de calidad se definió de la siguiente manera:

- **Atributo de calidad:** Adaptabilidad
- **Refinamiento:** Capacidad de incorporar nuevos módulos financieros
- **Requerimiento que lo hizo evidente:** El sistema debe permitir agregar un nuevo módulo financiero (ej: inversiones, criptomonedas) sin modificar los módulos existentes.
- **Prioridad:** Media

**Escenario de evaluación (ATAM):**

| Elemento | Descripción |
|---|---|
| **Fuente de estímulo** | Stakeholder de negocio |
| **Estímulo** | Solicita agregar un módulo de gestión de inversiones en Bolsa |
| **Artefacto** | Backend NestJS (API Gateway + módulos existentes) |
| **Respuesta** | Se crea un nuevo módulo que se registra en el API Gateway y usa el Adaptador de Base de Datos existente; ningún módulo existente se modifica |
| **Medida de la respuesta** | El nuevo módulo se integra sin modificar más del 5% del código existente, y está operativo en menos de 5 días-hombre |

## Decision

El backend se estructura como un monolito modular donde cada módulo es un contexto delimitado independiente con su propio conjunto de rutas, servicios y pruebas. El API Gateway enruta las peticiones al módulo correspondiente sin que los módulos existentes necesiten conocer al nuevo.

## Consequences

- Positiva: Bajo acoplamiento entre módulos; se pueden desarrollar y probar de forma independiente.
- Positiva: Escalamiento del equipo de desarrollo al poder asignar módulos completos a diferentes desarrolladores.
- Negativa: Puede haber duplicación de lógica si dos módulos requieren funcionalidades similares.
- Negativa: Sin una gobernanza adecuada, los módulos pueden terminar acoplados entre sí con el tiempo.
