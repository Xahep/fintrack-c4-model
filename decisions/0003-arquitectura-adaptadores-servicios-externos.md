# Arquitectura de Adaptadores para Servicios Externos

Date: 2026-06-03

## Status

Accepted

## Context

Durante la reunión ATAM, el **Desarrollador** identificó el acoplamiento directo entre el módulo OCR y Google Cloud Vision como un riesgo de vendor lock-in. Este atributo de calidad se definió de la siguiente manera:

- **Atributo de calidad:** Intercambialidad
- **Refinamiento:** Servicio de OCR intercambiable
- **Requerimiento que lo hizo evidente:** El módulo de OCR debe permitir cambiar de Google Cloud Vision a otro proveedor modificando solo la implementación del servicio, sin afectar al controlador.
- **Prioridad:** Media

**Escenario de evaluación (ATAM):**

| Elemento | Descripción |
|---|---|
| **Fuente de estímulo** | Desarrollador backend |
| **Estímulo** | Se decide migrar de Google Cloud Vision a AWS Textract por costos o precisión |
| **Artefacto** | Adaptador OCR (ocrAdapter) |
| **Respuesta** | Se crea una nueva implementación del adaptador que usa AWS Textract; el módulo OCR y el resto del sistema no requieren cambios |
| **Medida de la respuesta** | El cambio de proveedor se completa modificando únicamente el adaptador (1 archivo), sin tocar el módulo OCR ni el controlador. Tiempo de migración menor a 2 días-hombre |

## Decision

Se aplica el patrón Puerto-Adaptador (Hexagonal) en cada punto de integración externa. El módulo OCR depende de una interfaz (puerto) y el adaptador concreto implementa esa interfaz. Cambiar de proveedor solo implica crear un nuevo adaptador que implemente la misma interfaz.

## Consequences

- Positiva: Bajo impacto al cambiar de proveedor externo; solo se modifica el adaptador.
- Positiva: Aislamiento del dominio de negocio frente a cambios en servicios externos.
- Positiva: Facilita las pruebas unitarias al poder mockear la interfaz del puerto.
- Negativa: Mayor cantidad de clases/interfaces que mantener (cada servicio externo requiere su adaptador).
- Negativa: Es necesario definir contratos (interfaces) robustos desde el inicio para evitar refactorizaciones.
