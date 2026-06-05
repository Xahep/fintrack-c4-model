## Diagramas

### Introducción a los diagramas en el modelo C4

Los diagramas de arquitectura de software son una herramienta fundamental en la ingeniería de software moderna. Permiten visualizar la estructura, las relaciones y el comportamiento de un sistema de manera que el código fuente por sí solo no puede transmitir. En la industria, los diagramas facilitan la comunicación entre equipos técnicos y no técnicos, documentan decisiones de diseño, identifican riesgos de integración y sirven como guía para la evolución del sistema.

El modelo C4 (Contexto, Contenedores, Componentes y Código), creado por Simon Brown, propone un enfoque jerárquico y progresivo para la documentación de arquitectura. En lugar de un solo diagrama monolítico, el C4 ofrece cuatro niveles de abstracción que permiten al lector acercarse o alejarse según sus necesidades: desde una vista panorámica del ecosistema (contexto) hasta los detalles de implementación de un componente específico (código).

FinTrack utiliza Structurizr como herramienta de modelado, lo que permite mantener los diagramas y la documentación sincronizados con el código a través de un DSL (Domain Specific Language). A continuación se presentan los diagramas C4 implementados para FinTrack en sus distintos niveles de abstracción.

### Diagrama de Landscape

El diagrama de landscape (paisaje del sistema) es el nivel más amplio del modelo C4. Muestra el ecosistema completo de sistemas de software, tanto internos como externos, y las relaciones entre ellos. A diferencia del diagrama de contexto, que se centra en un solo sistema, el landscape ofrece una visión panorámica que incluye las interconexiones entre sistemas externos, revelando dependencias indirectas y flujos de información que atraviesan múltiples fronteras.

En FinTrack, el diagrama de landscape incluye no solo a FinTrack como sistema central y sus relaciones con los sistemas externos, sino también las relaciones entre esos sistemas externos. Por ejemplo, muestra cómo Bancolombia Open Banking API reporta información financiera a la DIAN, una conexión que existe independientemente de FinTrack pero que es relevante para entender el contexto financiero colombiano en el que opera la aplicación.

![](embed:Landscape)

### Diagrama de Contexto

El diagrama de contexto es el primer nivel del modelo C4 y ofrece una vista de alto nivel del sistema. Muestra el sistema de software en el centro (como una caja negra), los usuarios que lo utilizan y los sistemas externos con los que interactúa. Este diagrama responde a la pregunta fundamental: ¿qué hace el sistema y con quién se comunica?

En FinTrack, el diagrama de contexto muestra:

* **El usuario final** como la persona que accede a la aplicación para gestionar sus finanzas personales.
* **El usuario de sistema** como la persona encargada de monitorear la salud operativa de la plataforma.
* **Sistemas externos**: Keycloak (autenticación OIDC), Firebase (notificaciones push), Google Cloud Vision API (OCR), Amazon SES (correo electrónico), Bancolombia Open Banking API (sincronización bancaria), y AWS CloudWatch (monitoreo).
* **Sistemas externos adicionales**: La DIAN (como destino de reportes financieros desde Bancolombia) y el Sistema de Educación Financiera (como plataforma de contenido educativo accesible por el usuario).

FinTrack se presenta como una caja negra: en este nivel no importa cómo está construido internamente, sino qué servicio ofrece y con qué sistemas se comunica para hacerlo.

![](embed:SystemContext)

### Diagrama de Contenedores

El diagrama de contenedores es el segundo nivel del modelo C4. Descompone el sistema de software en sus contenedores de alto nivel: aplicaciones, bases de datos, sistemas de archivos, etc. Cada contenedor es una unidad ejecutable o almacenable que representa un despliegue independiente. Este diagrama responde a la pregunta: ¿de qué partes está hecho el sistema y cómo se comunican entre sí?

En FinTrack, el diagrama de contenedores muestra:

* **Web (PWA Angular)**: Aplicación web progresiva para navegadores de escritorio y móvil. Proporciona la interfaz principal para el registro de transacciones, gestión de presupuestos, consulta de planes y visualización de reportes.
* **Mobile (Flutter)**: Aplicación móvil nativa para Android e iOS con funcionalidades adicionales como captura de facturas con la cámara y registro por voz.
* **Backend (NestJS)**: API REST que provee todas las funcionalidades del sistema. Escrito en TypeScript con el framework NestJS, sigue una arquitectura modular.
* **Base de datos (PostgreSQL 15)**: Almacena información de usuarios, transacciones, categorías, presupuestos, planes de ahorro y deudas.
* **Almacenamiento de Activos (Amazon S3)**: Guarda imágenes de facturas, garantías y reportes financieros generados por el sistema.
* **Whisper AI (Docker)**: Servicio de inteligencia artificial que transcribe audio a texto para el registro de transacciones por voz.

Las relaciones entre contenedores muestran cómo el usuario accede a los frontends (web y móvil), cómo estos se comunican con el backend mediante HTTP/JSON, y cómo el backend interactúa con la base de datos, el almacenamiento y los servicios externos.

![](embed:Containers)

### Diagrama de Componentes

El diagrama de componentes es el tercer nivel del modelo C4. Descompone cada contenedor en sus componentes internos, mostrando la estructura arquitectónica dentro de un contenedor específico. Los componentes son unidades de funcionalidad bien definidas que colaboran entre sí para proporcionar el comportamiento del contenedor.

En FinTrack, se han definido dos diagramas de componentes, uno para cada contenedor principal que requiere descomposición interna.

#### Diagrama de Componentes Backend

El backend de FinTrack sigue una arquitectura de monolito modular construida con NestJS. Se compone de los siguientes elementos:

**Módulos de negocio**: Cada uno representa un contexto delimitado con sus propias rutas, servicios y lógica de dominio.

* **API Gateway**: Punto de entrada único que enruta cada petición al módulo correspondiente.
* **Módulo de Autenticación**: Gestiona el flujo OIDC y valida tokens JWT.
* **Módulo de Transacciones**: CRUD de registros financieros.
* **Módulo de Presupuestos**: Creación y monitoreo de presupuestos por categoría.
* **Módulo de Plan de Ahorro**: Análisis de flujo de caja y propuestas de ahorro personalizadas.
* **Módulo de Plan de Deudas**: Cálculo de estrategias óptimas de pago (avalancha y bola de nieve).
* **Módulo de Notificaciones**: Reglas de notificación personalizadas y envío push.
* **Módulo OCR**: Reconocimiento óptico de caracteres en imágenes de facturas.
* **Módulo de Voz**: Transcripción de audio a texto para registro por voz.
* **Módulo de Reportes**: Generación de reportes financieros en PDF y Excel.
* **Módulo de Integración Bancaria**: Sincronización con Bancolombia Open Banking API.
* **Módulo de Archivos**: Gestión del ciclo de vida de archivos en S3.
* **Módulo de Logging**: Centralización de logs y métricas para monitoreo.
* **Módulo de Reglas Financieras**: Motor de reglas condicionales del sistema.

**Adaptadores de infraestructura (puertos)**: Cada adaptador implementa un puerto que abstrae un servicio externo, siguiendo el patrón de puertos y adaptadores (Hexagonal Architecture). Esto permite cambiar cualquier proveedor externo sin modificar la lógica de negocio.

* **Adaptador de Autenticación**: Abstrae Keycloak.
* **Adaptador de Notificaciones**: Abstrae Firebase FCM.
* **Adaptador OCR**: Abstrae Google Cloud Vision API.
* **Adaptador de Transcripción**: Abstrae Whisper AI.
* **Adaptador de Correo**: Abstrae Amazon SES.
* **Adaptador Bancario**: Abstrae Bancolombia Open Banking API.
* **Adaptador de Archivos**: Abstrae Amazon S3.
* **Adaptador de Monitoreo**: Abstrae AWS CloudWatch.
* **Adaptador de Base de Datos**: Abstrae PostgreSQL.

![](embed:Components)

#### Diagrama de Componentes Aplicación Web

La aplicación web de FinTrack es una Progressive Web App construida con Angular. Se compone de los siguientes módulos y servicios:

* **App Shell**: Estructura principal con navegación lateral y enrutamiento entre módulos funcionales. Es el marco que contiene todos los demás módulos.
* **Autenticación**: Interfaz de inicio de sesión, registro y recuperación de contraseña mediante flujo OIDC.
* **Dashboard**: Resumen financiero con indicadores clave y gráficos de evolución de gastos.
* **Transacciones**: Listado, filtrado, creación y edición de transacciones financieras.
* **Presupuestos**: Creación y monitoreo visual de presupuestos por categoría con alertas de consumo.
* **Planes de Ahorro**: Visualización de planes de ahorro con metas, proyecciones y progreso.
* **Planes de Deuda**: Comparativa de estrategias de pago con simulación de plazos e intereses.
* **Reportes**: Solicitud, visualización y descarga de reportes financieros en PDF y Excel.
* **Cliente API**: Capa de comunicación HTTP con interceptores JWT, manejo de errores y transformación de respuestas.
* **Estado Global (Signals)**: Gestión del estado de la aplicación con Signals de Angular: sesión, catálogos y datos cacheados.
* **Biblioteca UI**: Componentes reutilizables: tablas, gráficos financieros, formularios, modales y esqueletos de carga.
* **Bus de Eventos**: Canal pub-sub que centraliza la comunicación por eventos entre módulos.
* **Service Worker**: Service worker de Angular PWA para modo offline, precarga de recursos y notificaciones push.

Las relaciones entre componentes muestran cómo el App Shell navega a cada módulo funcional, cómo los módulos publican y se suscriben al bus de eventos, y cómo el Cliente API se comunica con el backend y Keycloak.

![](embed:WebComponents)

### Diagramas de Despliegue

El diagrama de despliegue es un diagrama suplementario del modelo C4 (junto con el System Landscape diagram y el Dynamic diagram). No forma parte de la jerarquía principal de 4 niveles (Contexto → Contenedores → Componentes → Código), sino que complementa la documentación mostrando cómo las instancias de los contenedores y sistemas de software se asignan a la infraestructura dentro de un entorno de despliegue determinado (producción, staging, desarrollo, etc.). Responde a la pregunta: ¿cómo y dónde se ejecuta el sistema?

El modelo C4 trata los diagramas de despliegue como una vista que puede variar según el entorno y según la arquitectura de infraestructura elegida. Para FinTrack, se han modelado cuatro escenarios de despliegue distintos, cada uno representando una aproximación arquitectónica diferente.

#### Diagrama de Despliegue Cloud

El despliegue en la nube representa la arquitectura de producción objetivo de FinTrack, utilizando servicios administrados de AWS:

* **CloudFront**: CDN global con WAF y terminación SSL/TLS. Sirve la SPA Angular y actúa como puerta de entrada para el tráfico API.
* **Application Load Balancer (ALB)**: Balanceador de carga con terminación TLS que distribuye el tráfico hacia el backend.
* **ECS Fargate**: Orquestación de contenedores sin servidor con auto scaling (mín. 2, máx. 6 instancias). Aquí se ejecutan el backend NestJS y Whisper AI (con GPU NVIDIA T4).
* **RDS PostgreSQL**: Base de datos administrada con configuración Multi-AZ para alta disponibilidad (db.t3.medium).
* **S3**: Almacenamiento de objetos con cifrado AES-256 para activos y reportes.

Esta arquitectura ofrece alta disponibilidad, escalabilidad elástica y mínimo mantenimiento operativo al delegar la administración de la infraestructura a AWS.

![](embed:CloudDeployment)

#### Diagrama de Despliegue Microservicios

El despliegue de microservicios representa una evolución arquitectónica donde el monolito modular se descompone en servicios independientes, cada uno con su propia base de datos y desplegado de forma autónoma:

* **CloudFront**: CDN global como punto de entrada único.
* **API Gateway (Kong)**: Enrutamiento, rate limiting y autenticación centralizada. Enruta cada petición al microservicio correspondiente mediante gRPC.
* **Auth Service**: Gestiona autenticación OIDC. Base de datos PostgreSQL propia.
* **Core Financial Service**: Transacciones, presupuestos, ahorro, deudas y reglas financieras. Base de datos PostgreSQL propia.
* **Notification Service**: Notificaciones push y reglas de notificación.
* **Media Service**: OCR y transcripción de voz.
* **Reporting & Banking Service**: Reportes financieros e integración bancaria.
* **File Service**: Gestión de archivos. Almacena en S3.
* **S3**: Almacenamiento centralizado para archivos y reportes.

Cada microservicio se despliega en su propio nodo de cómputo con su propia base de datos, siguiendo el patrón de base de datos por servicio (database-per-service). Esto maximiza el desacoplamiento pero introduce complejidad en la coordinación y consistencia entre servicios.

![](embed:MicroservicesDeployment)

#### Diagrama de Despliegue Monolito

El despliegue monolito representa el escenario más simple: todos los componentes del sistema se ejecutan en un mismo servidor físico o virtual. Es el enfoque ideal para desarrollo local, pruebas o despliegues de bajo presupuesto:

* **Dispositivo del Usuario**: Navegador web o aplicación móvil que se conecta al servidor.
* **Servidor Monolito (localhost)**:
  * **Servidor de Aplicaciones**: Node.js / NestJS + Whisper AI.
  * **Servidor de Base de Datos**: PostgreSQL 15.

Este despliegue sacrifica escalabilidad y alta disponibilidad, pero gana en simplicidad operativa y reducción de costos. Es útil para desarrollo, demostraciones y equipos pequeños.

![](embed:MonolithDeployment)

#### Diagrama de Despliegue MVC

El despliegue MVC (Modelo-Vista-Controlador) representa una aproximación clásica de tres capas donde cada capa se despliega en un servidor independiente:

* **Servidor Vista (server1)**: Servidor web Nginx que sirve la aplicación Angular PWA.
* **Servidor Controlador (server2)**: Servidor de aplicaciones Node.js / NestJS que ejecuta la lógica de negocio del backend y Whisper AI.
* **Servidor Modelo (server3)**: Servidor de base de datos PostgreSQL 15.

Esta topología ofrece una separación física de responsabilidades siguiendo el patrón MVC clásico, con cada capa en su propio servidor. Es un punto medio entre la simplicidad del monolito y la complejidad de la nube.

![](embed:MVCDeployment)
