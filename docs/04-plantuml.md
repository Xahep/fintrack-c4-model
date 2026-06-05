## Diagramas PlantUML

### ¿Qué es PlantUML?

PlantUML es una herramienta de código abierto que permite crear diagramas UML a partir de texto plano usando un lenguaje de marcado sencillo e intuitivo. En el contexto de la arquitectura de software, PlantUML es especialmente valioso porque permite mantener los diagramas versionados junto con el código fuente, facilitando la revisión, la colaboración y la actualización continua de la documentación técnica. Al estar basado en texto, los diagramas de PlantUML se benefician de todas las herramientas del ecosistema de desarrollo: diff, merge, revisión de pull requests y automatización en pipelines de CI/CD.

A diferencia de los diagramas generados por Structurizr (que se derivan directamente del modelo C4 definido en el DSL), los diagramas de PlantUML que se presentan a continuación fueron elaborados de forma independiente para complementar la documentación con perspectivas adicionales sobre la arquitectura del sistema. Mientras que Structurizr se enfoca en mantener la fidelidad entre el modelo y los diagramas, PlantUML ofrece flexibilidad para crear diagramas ad-hoc que exploran aspectos específicos de la arquitectura.

### Diagrama de Componente en PlantUML

El siguiente diagrama de componentes elaborado en PlantUML presenta una vista simplificada de la arquitectura de FinTrack organizada en tres capas clásicas: presentación, negocio y datos. Aunque no sigue exactamente la misma descomposición que los diagramas de componentes de Structurizr (que son más granulares y fieles al modelo C4), este diagrama ofrece una visión complementaria útil para entender la separación de responsabilidades a un nivel arquitectónico más tradicional.

El diagrama utiliza el estilo UML2 con interfaces (bolas y sockets) para representar los contratos entre capas:

* **Capa de Presentación**: Representada por la aplicación móvil (UI), que se comunica con la capa de negocio a través de una interfaz de cálculo y estrategias.
* **Capa de Negocio**: Compuesta por el Gestor Financiero (Core) que orquesta las operaciones principales, y el Motor de Metodologías (Engine) que implementa los algoritmos financieros (cálculo de ahorro, estrategias de pago de deudas, etc.). La comunicación entre estos dos componentes sigue el patrón de interfaz registro y consulta.
* **Capa de Datos**: El Repositorio de Datos (DB) provee persistencia a través de una interfaz de persistencia que el Motor de Metodologías consume.

```plantuml
@startuml
skinparam componentStyle uml2

package "Capa de Presentación" {
    [App Movil (UI)] <<component>> as UI
}

package "Capa de Negocio" {
    component "Gestor Financiero" as Core {
        portin " " as P1
    }

    component "Motor de Metodologías" as Engine {
        portin " " as P2
    }
}

package "Capa de Datos" {
    component "Repositorio de Datos" as DB {
        portin " " as P3
    }
}

' Definición de Interfaces (Bolas y Sockets)
interface "Registro y Consulta" as IData
interface "Cálculos y Estrategias" as ILogic
interface "Persistencia" as IPersist

' Conexiones de Interfaz
UI --( ILogic
ILogic - Core

Core --( IData
IData - Engine

Engine --( IPersist
IPersist - DB

@enduml
```

### Diagrama Wireframe

Los diagramas wireframe son una herramienta fundamental en el diseño de experiencia de usuario (UX). Representan la estructura esquelética de una interfaz sin los detalles visuales (colores, tipografía, imágenes), permitiendo enfocarse en la disposición de los elementos, la jerarquía de la información y los flujos de navegación. En el contexto de FinTrack, los wireframes ayudan a validar que la aplicación sea intuitiva y que los usuarios puedan completar sus tareas financieras sin fricción.

A continuación se presentan las pantallas principales de FinTrack modeladas como wireframes en PlantUML Salt:

#### Inicio de Sesión

Pantalla de entrada a la aplicación con formulario de email y contraseña, enlace para recuperación de contraseña y opción de registro para nuevos usuarios.

```plantuml
@startsalt
{+
Bienvenido a FinApp


Email: | "usuario@correo.com   "
Contraseña: | "*******"
[  Iniciar Sesión  ]
.
[ Olvidé mi contraseña ] | [ Registrarse ]
}
@endsalt
```

#### Dashboard / Resumen Financiero

Pantalla principal que muestra el balance total, los ingresos y gastos del mes, gráficos de evolución financiera y los últimos movimientos registrados.

```plantuml
@startsalt
{+
{* Archivo | Perfil | Ayuda }
{/ Dashboard | Registro | Gestión | Config | Permisos }


{
Balance Total: | $ 5,430.00
Ingresos del Mes: | [ + $ 8,200.00 ]
Gastos del Mes: | [ - $ 2,770.00 ]
}


Evolución Financiera
[ <&bar-chart> Gráfico de Barras: Ingresos vs Gastos (Placeholder) ]
[ <&pie-chart> Gráfico de Pastel: Gastos por Categoría (Placeholder) ]


Últimos Movimientos
{#
Fecha | Descripción | Categoría | Monto
15-May-26 | Salario | Nómina | +$4000
14-May-26 | Supermercado | Comida | -$150
12-May-26 | Netflix | Suscripciones | -$15
}
}
@endsalt
```

#### Panel de Registro de Transacciones

Pantalla para registrar una nueva transacción financiera, con opciones rápidas inteligentes como registro por voz y captura de factura con la cámara.

```plantuml
@startsalt
{+
{* Archivo | Perfil | Ayuda }
{/ Dashboard | Registro | Gestión | Config | Permisos }


{
Tipo: | ^Gasto^
Monto: | "$ 0.00"
Cuenta: | ^Billetera Principal^
Categoría: | ^Comida^
Fecha: | "15/05/2026"
Notas: | "Almuerzo de trabajo"
}
[ <&data-transfer-upload> Guardar Registro ]


Opciones rápidas inteligentes:
[ <&microphone> Toca para hablar: "Gasté 15 en almuerzo" ]
[ <&camera-slr> Capturar foto del recibo ]
}
@endsalt
```

#### Cuentas y Categorías

Pantalla de gestión donde el usuario puede administrar sus cuentas (bancarias, efectivo, tarjetas) y categorías de gasto de forma jerárquica.

```plantuml
@startsalt
{+
{* Archivo | Perfil | Ayuda }
{/ Dashboard | Registro | Gestión | Config | Permisos }


{
Cuentas Activas | Categorías Creadas
{T
+ Cuentas Bancarias
++ Banco Nacional (Ahorros)
++ Tarjeta de Crédito Visa
+ Efectivo
++ Billetera Personal
++ Caja Menor Negocio
} | {T
+ Vivienda
++ Alquiler
++ Servicios Públicos
+ Alimentación
++ Supermercado
++ Restaurantes
}
[ <&plus> Nueva Cuenta ] | [ <&plus> Nueva Categoría ]
}
}
@endsalt
```

#### Configuración

Pantalla de preferencias donde el usuario configura la moneda principal, el idioma, el tema visual y las notificaciones.

```plantuml
@startsalt
{+
{* Archivo | Perfil | Ayuda }
{/ Dashboard | Registro | Gestión | Config | Permisos }


Preferencias Generales
Moneda Principal: | ^COP ($)^
Idioma de la App: | ^Español^
Tema Visual: | () Claro | () Oscuro | () Automático


Notificaciones
[X] Activar alertas de presupuesto excedido
[X] Recordatorio diario para registrar gastos
[ ] Recibir resumen semanal por correo


[ Guardar Cambios ]
}
@endsalt
```

#### Permisos y Colaboradores

Pantalla para compartir cuentas financieras con otros usuarios, asignar permisos específicos y gestionar colaboradores existentes.

```plantuml
@startsalt
{+
{* Archivo | Perfil | Ayuda }
{/ Dashboard | Registro | Gestión | Config | Permisos }


Compartir Cuenta
Seleccionar Cuenta: | ^Billetera Compartida^
Email del colaborador: | "familiar@correo.com"


Otorgar Permisos:
[X] Ver saldos y movimientos
[X] Agregar nuevos registros
[ ] Editar/Eliminar registros de otros
[ <&envelope-closed> Enviar Invitación ]


Usuarios con acceso actual
{#
Usuario | Cuenta Compartida | Permisos | Acción
esposa@mail.com | Billetera Compartida | Ver, Agregar | [ Revocar ]
socio@mail.com | Cuenta Negocio | Total | [ Editar ]
}
}
@endsalt
```
