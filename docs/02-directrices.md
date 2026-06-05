## Directrices del Negocio

Las siguientes directrices de negocio se han identificado a partir del análisis del modelo y las relaciones definidas en el DSL de FinTrack. Estas directrices representan los principios y restricciones que gobiernan el diseño y la evolución del sistema.

### Autenticación y autorización seguras

El sistema delega toda la gestión de identidad y acceso a Keycloak mediante el protocolo estándar OIDC (OpenID Connect). Ningún módulo de FinTrack maneja contraseñas o sesiones directamente. Esto garantiza que la autenticación sea robusta, auditablé y cumpla con estándares de seguridad empresarial. El frontend inicia el flujo OIDC directamente con Keycloak, y el backend valida los tokens JWT en cada petición entrante.

### Captura inteligente de transacciones

FinTrack ofrece tres mecanismos de registro para adaptarse al contexto del usuario:

1. **Registro manual**: A través de formularios estructurados en la aplicación web o móvil.
2. **Captura por foto (OCR)**: El usuario fotografía una factura o recibo, y el sistema utiliza Google Cloud Vision API para extraer los campos de texto estructurado (monto, fecha, comercio, etc.) y crear automáticamente la transacción.
3. **Registro por voz**: El usuario dicta la transacción, y el sistema utiliza Whisper AI para transcribir el audio a texto y extraer los datos estructurados.

### Integración bancaria automatizada

A través de la API de Bancolombia Open Banking, FinTrack puede sincronizar automáticamente los saldos y movimientos bancarios del usuario. Esto reduce la fricción del registro manual y permite que el sistema tenga una visión más precisa y actualizada de la situación financiera del usuario. La integración está encapsulada detrás de un adaptador para poder cambiar de proveedor bancario sin afectar la lógica de negocio.

### Notificaciones push inteligentes

FinTrack utiliza Firebase Cloud Messaging (FCM) para enviar notificaciones push a los dispositivos de los usuarios. Las notificaciones no son genéricas: se activan según reglas personalizadas definidas por el módulo de notificaciones, que analiza los hábitos de gasto del usuario para determinar el momento y el contenido más relevantes.

### Reportes financieros exportables

El sistema genera reportes financieros periódicos en formato PDF y Excel, que incluyen resúmenes de gastos, tendencias y proyecciones. Estos reportes se envían por correo electrónico a través de Amazon SES y se almacenan en Amazon S3 para consulta y descarga posterior desde la aplicación.

### Monitoreo operativo y alertas automáticas

Todos los logs, métricas y trazas del backend se envían a AWS CloudWatch, que proporciona capacidades de monitoreo en tiempo real, dashboards operativos y configuración de alarmas automáticas. Un usuario de sistema (sistemaUser) es responsable de monitorear la salud operativa de la plataforma a través de CloudWatch.

### Arquitectura modular con adaptadores

El backend sigue una arquitectura de monolito modular donde cada módulo de negocio es un contexto delimitado independiente. La comunicación con servicios externos (Keycloak, Firebase, Google Cloud Vision, Amazon SES, Bancolombia, AWS CloudWatch, Whisper AI, S3, base de datos) se realiza exclusivamente a través de adaptadores que implementan puertos de infraestructura. Esto permite cambiar cualquier proveedor externo sin modificar la lógica de negocio de los módulos.

### Experiencia de usuario consistente y offline

La aplicación web es una Progressive Web App (PWA) construida con Angular que incluye un Service Worker para soporte offline, precarga de recursos y recepción de notificaciones push. La interfaz utiliza una biblioteca de componentes UI reutilizables que garantiza consistencia visual en todos los módulos funcionales.

### Cumplimiento fiscal y reportes gubernamentales

A través de la integración con Bancolombia, y dado que Bancolombia reporta información financiera a la DIAN (Dirección de Impuestos y Aduanas Nacionales de Colombia), FinTrack opera dentro del marco regulatorio colombiano. La arquitectura considera que la información financiera fluye desde las entidades bancarias hacia el gobierno, y FinTrack actúa como un intermediario que presenta la información al usuario de manera comprensible.
