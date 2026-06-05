workspace "FinTrack" "Sistema de gestión de finanzas personales: registro de gastos e ingresos, planes de ahorro, presupuestos y notificaciones inteligentes." {

    model {

        # =====================================================================
        # PERSONAS
        # =====================================================================
        user = person "Usuario" "Persona que registra sus gastos e ingresos, gestiona presupuestos, consulta planes de ahorro y recibe notificaciones financieras personalizadas."

        sistemaUser = person "Usuario de Sistema" "Persona encargada de monitorear el rendimiento, la salud operativa y las alertas del sistema FinTrack."

        # =====================================================================
        # SISTEMAS EXTERNOS
        # =====================================================================
        firebase = softwareSystem "Firebase" "Plataforma de Google usada para el envío de notificaciones push (FCM) a los dispositivos de los usuarios." "External"

        keycloak = softwareSystem "Keycloak" "Sistema de gestión de identidad y acceso (IAM). Responsable de la autenticación y autorización mediante el protocolo OIDC." "External"

        googleVision = softwareSystem "Google Cloud Vision API" "Servicio externo de Google para reconocimiento óptico de caracteres (OCR). Analiza imágenes de facturas y extrae campos de texto estructurado." "External"

        awsSES = softwareSystem "Amazon SES" "Servicio para el envio de correo electrónico." "External"

        bancolombiaAPI = softwareSystem "Bancolombia Open Banking API" "API oficial de Bancolombia que permite consultar saldos y movimientos bancarios del usuario para sincronización automática de transacciones." "External"

        dian = softwareSystem "DIAN" "Sistema del gobierno colombiano para gestión tributaria." "External"

        finEdSystem = softwareSystem "Sistema de Educación Financiera" "Plataforma de contenido educativo para la gestión de finanzas personales." "External"

        cloudwatch = softwareSystem "AWS CloudWatch" "Servicio de monitoreo y observabilidad de AWS. Recibe logs, métricas y trazas del backend para supervisión operativa y configuración de alarmas." "External"

        # =====================================================================
        # SISTEMA PRINCIPAL: FinTrack
        # =====================================================================
        fintrack = softwareSystem "FinTrack" "Aplicación de finanzas personales que permite registrar gastos e ingresos (manual, por foto o por voz), generar planes de ahorro y pago de deudas, crear presupuestos y recibir notificaciones inteligentes." {

            # -----------------------------------------------------------------
            # CONTENEDORES
            # -----------------------------------------------------------------
            pwa = container "Web" "Aplicación web progresiva orientada a navegadores de escritorio y móvil. Permite el registro de transacciones, gestión de presupuestos, consulta de planes y visualización de reportes." "Javascript y Angular" "WebApp" {

                appShell = component "App Shell" "Estructura principal con navegación lateral y enrutamiento entre módulos funcionales." "Angular Component"

                webAuth = component "Autenticación" "Interfaz de inicio de sesión, registro y recuperación de contraseña mediante flujo OIDC." "Angular Module"

                dashboardModule = component "Dashboard" "Resumen financiero con indicadores clave y gráficos de evolución de gastos." "Angular Module"

                webTransactions = component "Transacciones" "Listado, filtrado, creación y edición de transacciones financieras." "Angular Module"

                webBudgets = component "Presupuestos" "Creación y monitoreo visual de presupuestos por categoría con alertas de consumo." "Angular Module"

                webSavings = component "Planes de Ahorro" "Visualización de planes de ahorro con metas, proyecciones y progreso." "Angular Module"

                webDebts = component "Planes de Deuda" "Comparativa de estrategias de pago con simulación de plazos e intereses." "Angular Module"

                reportModule = component "Reportes" "Solicitud, visualización y descarga de reportes financieros en PDF y Excel." "Angular Module"

                apiClient = component "Cliente API" "Capa de comunicación HTTP con interceptores JWT, manejo de errores y transformación de respuestas." "Angular Service"

                stateStore = component "Estado Global" "Gestión del estado de la aplicación con Signals: sesión, catálogos y datos cacheados." "Angular Service"

                uiLibrary = component "Biblioteca UI" "Componentes reutilizables: tablas, gráficos financieros, formularios, modales y esqueletos de carga." "Angular Component"

                eventBus = component "Bus de Eventos" "Canal pub-sub que centraliza la comunicación por eventos entre módulos." "Angular Service" "EventBus"

                serviceWorker = component "Service Worker" "Service worker de Angular PWA para modo offline, precarga de recursos y notificaciones push." "Angular Service Worker"
            }

            mobileApp = container "Mobile" "Aplicación móvil nativa para Android e iOS. Ofrece funcionalidades adicionales como captura de facturas con la cámara del dispositivo y registro por voz." "Flutter" "MobileApp"

            api = container "Backend" "Provee funcionalidades del sistema mediante JSON/HTTP API" "Typescript y NestJS" {

                apiGateway = component "API Gateway" "Punto de entrada único para todas las solicitudes de los frontends. Recibe y enruta cada petición al módulo correspondiente del backend." "NestJS Module"

                authModule = component "Módulo de Autenticación" "Gestiona el flujo de autenticación y autorización mediante OIDC. Valida tokens JWT en cada petición entrante." "NestJS Module"

                transactionModule = component "Módulo de Transacciones" "Permite crear, editar, eliminar y consultar registros." "NestJS Module"

                budgetModule = component "Módulo de Presupuestos" "Permite crear presupuestos por categoría y período. Monitorea el consumo en tiempo real y dispara alertas cuando se acerca o supera el límite." "NestJS Module"

                savingsModule = component "Módulo de Plan de Ahorro" "Analiza el flujo de ingresos y gastos del usuario para calcular y proponer planes de ahorro personalizados con metas y plazos." "NestJS Module"

                debtModule = component "Módulo de Plan de Deudas" "Calcula estrategias óptimas de pago de deudas (método avalancha y bola de nieve) basándose en los compromisos financieros registrados por el usuario." "NestJS Module"

                notificationModule = component "Módulo de Notificaciones" "Gestiona las reglas de notificación personalizadas según los hábitos de gasto del usuario. Programa y envía notificaciones push a través de FCM." "NestJS Module"

                ocrModule = component "Módulo OCR" "Recibe imágenes generadas por el usuario y extrae los datos de una transacción estructurada." "NestJS Module"

                voiceModule = component "Módulo de Voz" "Recibe audios y extrae los datos en una transacción estructurada." "NestJS Module"

                reportingModule = component "Módulo de Reportes" "Genera reportes financieros periódicos (PDF/Excel) con resúmenes de gastos, tendencias y proyecciones." "NestJS Module"

                bankingModule = component "Módulo de Integración Bancaria" "Recibe movimientos bancarios y extrae los datos en una transacción estructurada." "NestJS Module"

                fileModule = component "Módulo de Archivos" "Centraliza la subida, descarga y gestión del ciclo de vida de archivos en AWS S3." "NestJS Module"

                loggingModule = component "Módulo de Logging" "Intercepta y centraliza los logs de aplicación, errores y métricas de rendimiento para monitoreo y alertas operativas." "NestJS Module"

                financialRulesModule = component "Módulo de Reglas Financieras" "Motor de reglas que centraliza la lógica condicional del sistema." "NestJS Module"

                # -----------------------------------------------------------------
                # ADAPTADORES (Puertos de infraestructura)
                # -----------------------------------------------------------------
                authenticationAdapter = component "Adaptador de Autenticación" "Puerto de autenticación que abstrae la comunicación con el proveedor IAM. Permite cambiar de proveedor (Keycloak, Auth0, etc.) sin afectar la lógica de negocio del módulo." "NestJS Service" "Adapter"

                notificationAdapter = component "Adaptador de Notificaciones" "Puerto de notificaciones push que abstrae el servicio FCM. Desacopla el envío de notificaciones del proveedor concreto." "NestJS Service" "Adapter"

                ocrAdapter = component "Adaptador OCR" "Puerto de OCR que abstrae Google Cloud Vision API. Aísla la integración del servicio de reconocimiento óptico del módulo de negocio." "NestJS Service" "Adapter"

                transcriptionAdapter = component "Adaptador de Transcripción" "Puerto de transcripción que abstrae Whisper AI. Desacopla el módulo de voz del motor de transcripción específico." "NestJS Service" "Adapter"

                emailAdapter = component "Adaptador de Correo" "Puerto de envío de correos que abstrae Amazon SES. Permite cambiar de proveedor de email sin modificar la lógica de negocio del módulo de reportes." "NestJS Service" "Adapter"

                bankingAdapter = component "Adaptador Bancario" "Puerto de integración bancaria que abstrae la API de Bancolombia. Aísla al dominio de los cambios en la API externa." "NestJS Service" "Adapter"

                fileStorageAdapter = component "Adaptador de Archivos" "Puerto de almacenamiento que abstrae Amazon S3. Permite cambiar de proveedor de almacenamiento sin afectar a los módulos que gestionan archivos." "NestJS Service" "Adapter"

                monitoringAdapter = component "Adaptador de Monitoreo" "Puerto de observabilidad que abstrae AWS CloudWatch. Desacopla el logging y las métricas de la plataforma de monitoreo concreta." "NestJS Service" "Adapter"

                databaseAdapter = component "Adaptador de Base de Datos" "Puerto de persistencia que abstrae el acceso a la base de datos. Centraliza las operaciones de lectura y escritura, permitiendo cambiar de motor de BD (PostgreSQL, MySQL, etc.) sin afectar la lógica de negocio de los módulos." "NestJS Service" "Adapter"
            }

            db = container "Base de datos" "Información de usuarios, transacciones, categorías, presupuestos, planes de ahorro, etc" "PostgreSQL 15" "Database"

            s3 = container "Almacenamiento de Activos" "Imagenes de facturas o garantias subidas por el usuario y reportes financieros generados por el sistema." "Amazon S3" "FileStorage"

            whisper = container "Whisper" "Transcribe audio a texto para el registro de transacciones por voz." "Whisper AI / Docker" "AIService"

        }

        # =====================================================================
        # RELACIONES — NIVEL CONTEXTO
        # =====================================================================
        user -> fintrack "Accede a"
        fintrack -> firebase "Envía notificaciones push usando" "HTTPS / FCM"
        fintrack -> keycloak "Autentica y autoriza usando" "HTTPS / OIDC"
        fintrack -> googleVision "Extrae datos de facturas usando" "HTTPS / REST"
        fintrack -> awsSES "Envía reportes financieros usando" "HTTPS / REST"
        fintrack -> bancolombiaAPI "Sincroniza movimientos bancarios usando" "HTTPS / REST"

        bancolombiaAPI -> dian "Reporta información financiera a" "HTTPS / REST"
        user -> finEdSystem "Accede a" "HTTPS"
        fintrack -> cloudwatch "Envía logs y métricas operativas usando" "HTTPS / AWS SDK"
        sistemaUser -> cloudwatch "Monitorea el rendimiento y estado del sistema en"

        # =====================================================================
        # RELACIONES — NIVEL CONTENEDORES
        # =====================================================================
        user -> pwa "Accede desde el navegador web a" "HTTPS"
        user -> mobileApp "Accede desde un dispositivo móvil a" "Android / iOS"
        pwa -> api "Hace solicitudes REST a" "HTTPS / JSON"
        mobileApp -> api "Hace solicitudes REST a" "HTTPS / JSON"
        api -> db "Lee de y escribe a" "TCP / SQL"
        api -> s3 "Carga y descarga archivos" "HTTPS / AWS SDK"
        api -> whisper "Envía audio para transcripción" "HTTPS / REST"
        api -> firebase "Hace solicitud API a" "HTTPS / FCM"
        api -> keycloak "Hace solicitud API a" "HTTPS / OIDC"
        api -> googleVision "Hace solicitud API a" "HTTPS / REST"
        api -> awsSES "Hace solicitud API a" "HTTPS / REST"
        api -> cloudwatch "Hace solicitud API a" "HTTPS / AWS SDK"
        api -> bancolombiaAPI "Hace solicitud API a" "HTTPS / REST"

        # =====================================================================
        # RELACIONES — NIVEL COMPONENTES (BACKEND)
        # =====================================================================
        pwa -> apiGateway "Solicita funcionalidades del sistema a" "HTTPS / REST"
        mobileApp -> apiGateway "Solicita funcionalidades del sistema a" "HTTPS / REST"

        apiGateway -> authModule "Enruta peticiones de autenticación a" "HTTPS / REST"
        apiGateway -> transactionModule "Enruta peticiones de transacciones a" "HTTPS / REST"
        apiGateway -> budgetModule "Enruta peticiones de presupuestos a" "HTTPS / REST"
        apiGateway -> savingsModule "Enruta peticiones de planes de ahorro a" "HTTPS / REST"
        apiGateway -> debtModule "Enruta peticiones de planes de deuda a" "HTTPS / REST"
        apiGateway -> reportingModule "Enruta peticiones de reportes a" "HTTPS / REST"
        apiGateway -> ocrModule "Enruta peticiones de OCR a" "HTTPS / Multipart"
        apiGateway -> voiceModule "Enruta peticiones de voz a" "HTTPS / Multipart"

        authModule -> authenticationAdapter "Delega autenticación a" "Internal"
        authenticationAdapter -> keycloak "Hace solicitud API a" "HTTPS / OIDC"
        transactionModule -> databaseAdapter "Delega persistencia a" "Internal"
        budgetModule -> databaseAdapter "Delega persistencia a" "Internal"
        savingsModule -> databaseAdapter "Delega persistencia a" "Internal"
        debtModule -> databaseAdapter "Delega persistencia a" "Internal"
        databaseAdapter -> db "Lee desde y escribe a" "TCP / SQL"
        notificationModule -> notificationAdapter "Delega notificaciones a" "Internal"
        notificationAdapter -> firebase "Envía notificaciones push vía FCM" "HTTPS / FCM"
        ocrModule -> ocrAdapter "Delega OCR a" "Internal"
        ocrAdapter -> googleVision "Hace solicitud API a" "HTTPS / REST"
        ocrModule -> fileModule "Dirige la imagen a" "Internal"
        ocrModule -> transactionModule "Envia datos estructurados a" "Internal"
        voiceModule -> transcriptionAdapter "Delega transcripción a" "Internal"
        transcriptionAdapter -> whisper "Hace solicitud API a" "HTTPS / REST"
        voiceModule -> transactionModule "Envia datos estructurados a" "Internal"
        reportingModule -> emailAdapter "Delega envío de correos a" "Internal"
        emailAdapter -> awsSES "Hace solicitud API a" "HTTPS / REST"
        reportingModule -> fileModule "Dirige el reporte a" "Internal"

        bankingModule -> bankingAdapter "Delega integración bancaria a" "Internal"
        bankingAdapter -> bancolombiaAPI "Hace solicitud API a" "HTTPS / REST"

        bankingModule -> transactionModule "Envia datos estructurados a" "Internal"
        fileModule -> fileStorageAdapter "Delega almacenamiento a" "Internal"
        fileStorageAdapter -> s3 "Sube, descarga y elimina archivos" "HTTPS / AWS SDK"
        loggingModule -> monitoringAdapter "Delega monitoreo a" "Internal"
        monitoringAdapter -> cloudwatch "Hace solicitud API a" "HTTPS / AWS SDK"

        financialRulesModule -> databaseAdapter "Delega persistencia a" "Internal"
        financialRulesModule -> notificationModule "Dispara notificaciones mediante" "Internal"

        # =====================================================================
        # RELACIONES — NIVEL COMPONENTES WEB
        # =====================================================================
        appShell -> webAuth "Navega al módulo de" "Angular Router"
        appShell -> dashboardModule "Navega al módulo de" "Angular Router"
        appShell -> webTransactions "Navega al módulo de" "Angular Router"
        appShell -> webBudgets "Navega al módulo de" "Angular Router"
        appShell -> webSavings "Navega al módulo de" "Angular Router"
        appShell -> webDebts "Navega al módulo de" "Angular Router"
        appShell -> reportModule "Navega al módulo de" "Angular Router"

        apiClient -> apiGateway "Hace solicitudes HTTP a" "HTTPS / REST"
        apiClient -> keycloak "Inicia flujo de autenticación OIDC con" "HTTPS / OIDC"

        # -----------------------------------------------------------------
        # BUS DE EVENTOS — Comunicación reactiva entre módulos web
        # -----------------------------------------------------------------
        # Emisores
        webAuth -> eventBus "Publica eventos de autenticación a"
        dashboardModule -> eventBus "Publica eventos de dashboard a"
        webTransactions -> eventBus "Publica eventos de transacciones a"
        webBudgets -> eventBus "Publica eventos de presupuestos a"
        webSavings -> eventBus "Publica eventos de ahorro a"
        webDebts -> eventBus "Publica eventos de deuda a"
        reportModule -> eventBus "Publica eventos de reportes a"

        # Suscriptores
        eventBus -> apiClient "Despacha eventos de datos a"
        eventBus -> stateStore "Despacha eventos de estado a"
        eventBus -> uiLibrary "Despacha eventos de UI a"

        firebase -> serviceWorker "Envía notificaciones push a" "FCM / Push API"



        # =====================================================================
        # DESPLIEGUE — MONOLITO (Nuevo)
        # =====================================================================
        monolithEnv = deploymentEnvironment "Monolito" {

            localUserDevice = deploymentNode "Dispositivo del Usuario" "" "Navegador web o dispositivo móvil" {
                localBrowser = deploymentNode "Navegador Web" "" "Chrome, Firefox, Safari, Edge" {
                    containerInstance pwa
                }
                localMobile = deploymentNode "App Móvil" "" "Android 10+ / iOS 14+" {
                    containerInstance mobileApp
                }
            }

            monolithServer = deploymentNode "Servidor Monolito" "localhost" "Windows, Linux o Mac" {
                monoAppServer = deploymentNode "Servidor de Aplicaciones" "" "Node.js / NestJS + Whisper" {
                    containerInstance api
                    containerInstance whisper
                }

                monoDbServer = deploymentNode "Servidor de Base de Datos" "" "PostgreSQL 15" {
                    containerInstance db
                }
            }

        }

        # =====================================================================
        # DESPLIEGUE — CLOUD (Nuevo)
        # =====================================================================
        cloudEnv = deploymentEnvironment "Cloud" {

            cloudUserDev = deploymentNode "Dispositivo del Usuario" "" "Navegador web o dispositivo móvil" {
                cloudBrowser = deploymentNode "Navegador Web" "" "Chrome, Firefox, Safari, Edge" {
                    containerInstance pwa
                }
                cloudMobile = deploymentNode "App Móvil" "" "Android 10+ / iOS 14+" {
                    containerInstance mobileApp
                }
            }

            awsCloud = deploymentNode "Amazon Web Services" "" "Región us-east-1" {
                tags "Amazon Web Services - Cloud"

                cdn = deploymentNode "CloudFront" "" "CDN global - WAF y SSL/TLS" {
                    tags "Amazon Web Services - CloudFront"
                }

                alb = deploymentNode "ALB" "" "Application Load Balancer - Terminación TLS" {
                    tags "Amazon Web Services - Elastic Load Balancing"
                }

                compute = deploymentNode "ECS Fargate" "" "Auto Scaling (mín. 2, máx. 6)" {
                    tags "Amazon Web Services - ECS"

                    backend = deploymentNode "Backend NestJS" "" "2 vCPU / 4 GB RAM" {
                        containerInstance api
                    }

                    whisperSvc = deploymentNode "Whisper AI" "" "GPU NVIDIA T4" {
                        containerInstance whisper
                    }
                }

                rds = deploymentNode "RDS PostgreSQL" "" "Multi-AZ - db.t3.medium" {
                    tags "Amazon Web Services - RDS"
                    containerInstance db
                }

                storage = deploymentNode "S3" "" "Cifrado AES-256" {
                    tags "Amazon Web Services - S3"
                    containerInstance s3
                }
            }

            cloudBrowser -> cdn "Descarga SPA" "HTTPS"
            cloudBrowser -> alb "Consume API" "HTTPS / JSON"
            cloudMobile -> alb "Consume API" "HTTPS / JSON"
            cdn -> alb "Reenvía tráfico de API" "HTTPS"
            alb -> compute "Distribuye tráfico hacia" "HTTPS"

        }

        # =====================================================================
        # DESPLIEGUE — ARQUITECTURA MICROSERVICIOS (Nuevo)
        # =====================================================================
        archMicroEnv = deploymentEnvironment "Arquitectura Microservicios" {

            gAuth = deploymentGroup "Auth"
            gCore = deploymentGroup "Core Financial"
            gNotify = deploymentGroup "Notifications"
            gMedia = deploymentGroup "Media"
            gReport = deploymentGroup "Reporting"
            gFiles = deploymentGroup "Files"

            svcUserDevice = deploymentNode "Dispositivo del Usuario" "" "Navegador web o dispositivo móvil" {
                svcBrowser = deploymentNode "Navegador Web" "" "Chrome, Firefox, Safari, Edge" {
                    containerInstance pwa "gAuth,gCore,gNotify,gMedia,gReport,gFiles"
                }
                svcMobile = deploymentNode "App Móvil" "" "Android 10+ / iOS 14+" {
                    containerInstance mobileApp "gAuth,gCore,gNotify,gMedia,gReport,gFiles"
                }
            }

            microCdn = deploymentNode "CloudFront" "" "CDN global - WAF y SSL/TLS" {
                tags "Amazon Web Services - CloudFront"
            }

            microGw = deploymentNode "API Gateway" "" "Kong - Enrutamiento, rate limiting, autenticación" {
                tags "Amazon Web Services - Elastic Load Balancing"
            }

            # 1. Auth Service
            msAuthNode = deploymentNode "Auth Service" "ms-auth" "Windows, Linux o Mac" {
                tags "Amazon Web Services - EC2"
                msAuthApp = deploymentNode "Node.js" "" {
                    containerInstance api gAuth {
                        description "Autenticación OIDC"
                    }
                }
                msAuthDb = deploymentNode "PostgreSQL" "" {
                    tags "Amazon Web Services - RDS"
                    containerInstance db gAuth
                }
            }

            # 2. Core Financial Service (transactions, budgets, savings, debts, rules)
            msCoreNode = deploymentNode "Core Financial Service" "ms-core" "Windows, Linux o Mac" {
                tags "Amazon Web Services - EC2"
                msCoreApp = deploymentNode "Node.js" "" {
                    containerInstance api gCore {
                        description "Transacciones, Presupuestos, Ahorro, Deudas, Reglas"
                    }
                }
                msCoreDb = deploymentNode "PostgreSQL" "" {
                    tags "Amazon Web Services - RDS"
                    containerInstance db gCore
                }
            }

            # 3. Notification Service
            msNotifyNode = deploymentNode "Notification Service" "ms-notify" "Windows, Linux o Mac" {
                tags "Amazon Web Services - EC2"
                msNotifyApp = deploymentNode "Node.js" "" {
                    containerInstance api gNotify {
                        description "Notificaciones push y reglas"
                    }
                }
            }

            # 4. Media Service (OCR, Voice)
            msMediaNode = deploymentNode "Media Service" "ms-media" "Windows, Linux o Mac" {
                tags "Amazon Web Services - EC2"
                msMediaApp = deploymentNode "Node.js" "" {
                    containerInstance api gMedia {
                        description "OCR y transcripción de voz"
                    }
                }
            }

            # 5. Reporting & Banking Service
            msReportNode = deploymentNode "Reporting & Banking Service" "ms-report" "Windows, Linux o Mac" {
                tags "Amazon Web Services - EC2"
                msReportApp = deploymentNode "Node.js" "" {
                    containerInstance api gReport {
                        description "Reportes e integración bancaria"
                    }
                }
            }

            # 6. File Service
            msFileNode = deploymentNode "File Service" "ms-file" "Windows, Linux o Mac" {
                tags "Amazon Web Services - EC2"
                msFileApp = deploymentNode "Node.js" "" {
                    containerInstance api gFiles {
                        description "Gestión de archivos"
                    }
                }
            }

            microStorage = deploymentNode "S3" "" "Cifrado AES-256" {
                tags "Amazon Web Services - S3"
                containerInstance s3
            }

            # Relaciones de infraestructura
            svcUserDevice -> microCdn "Descarga SPA" "HTTPS"
            svcUserDevice -> microGw "Consume API" "HTTPS / JSON"
            microCdn -> microGw "Reenvía tráfico" "HTTPS"

            # Enrutamiento API Gateway a cada servicio
            microGw -> msAuthApp "Enruta autenticación a" "HTTPS / gRPC"
            microGw -> msCoreApp "Enruta operaciones financieras a" "HTTPS / gRPC"
            microGw -> msNotifyApp "Enruta notificaciones a" "HTTPS / gRPC"
            microGw -> msMediaApp "Enruta contenido multimedia a" "HTTPS / gRPC"
            microGw -> msReportApp "Enruta reportes y banca a" "HTTPS / gRPC"
            microGw -> msFileApp "Enruta archivos a" "HTTPS / gRPC"

            # Persistencia por servicio
            msFileApp -> microStorage "Almacena archivos en" "HTTPS / AWS SDK"
            msReportApp -> microStorage "Almacena reportes en" "HTTPS / AWS SDK"
        }

        # =====================================================================
        # DESPLIEGUE — MVC (Nuevo)
        # =====================================================================
        mvcEnv = deploymentEnvironment "MVC" {

            mvcUserDev = deploymentNode "Dispositivo del Usuario" "" "Navegador web o dispositivo móvil" {
                mvcBrowser = deploymentNode "Navegador Web" "" "Chrome, Firefox, Safari, Edge" {
                    containerInstance pwa
                }
                mvcMobile = deploymentNode "App Móvil" "" "Android 10+ / iOS 14+" {
                    containerInstance mobileApp
                }
            }

            mvcView = deploymentNode "Servidor Vista" "server1" "Windows, Linux o Mac" {
                webServer = deploymentNode "Servidor Web" "" "Nginx"
            }

            mvcController = deploymentNode "Servidor Controlador" "server2" "Windows, Linux o Mac" {
                mvcAppServer = deploymentNode "Servidor de Aplicaciones" "" "Node.js / NestJS" {
                    containerInstance api
                    containerInstance whisper
                }
            }

            mvcModel = deploymentNode "Servidor Modelo" "server3" "Windows, Linux o Mac" {
                mvcDbServer = deploymentNode "Servidor de Base de Datos" "" "PostgreSQL 15" {
                    containerInstance db
                }
            }
        }

    }

    # =========================================================================
    # DOCUMENTACIÓN Y DECISIONES
    # =========================================================================
    !docs docs
    !adrs decisions

    # =========================================================================
    # VISTAS
    # =========================================================================
    views {

        properties {
            "plantuml.url" "https://plantuml.com/plantuml"
            "plantuml.format" "svg"
        }

        # 1. Diagrama de Contexto
        systemContext fintrack "SystemContext" {
            include *
            include sistemaUser
            title "FinTrack — Diagrama de Contexto del Sistema"
            description "Muestra FinTrack como sistema central, el usuario que lo utiliza y todos los sistemas externos del ecosistema: autenticación (Keycloak), notificaciones push (Firebase), OCR (Google Cloud Vision), correos transaccionales (Amazon SES), integración bancaria (Bancolombia Open Banking API), monitoreo (AWS CloudWatch), entidad gubernamental (DIAN) y educación financiera."
        }

        # 2. Diagrama de Contenedores
        container fintrack "Containers" {
            include *
            title "FinTrack — Diagrama de Contenedores"
            description "Muestra los contenedores que componen FinTrack: frontends (Web PWA Angular y Mobile Flutter), backend API (NestJS), base de datos, almacenamiento y servicios de soporte."
        }

        # 3. Diagrama de Componentes (Backend API)
        component api "Components" {
            include *
            title "FinTrack — Diagrama de Componentes (Backend API)"
            description "Muestra los módulos internos del monolito modular NestJS y sus dependencias hacia sistemas y contenedores externos."
        }

        # 4. Diagrama de Componentes (Web PWA)
        component pwa "WebComponents" {
            include *
            title "FinTrack — Diagrama de Componentes (Web)"
            description "Muestra los módulos internos de la aplicación web Angular, sus interacciones internas y dependencias externas con el backend, Keycloak y Firebase."
        }

        # 5. Diagrama de Paisaje del Sistema (Landscape)
        systemLandscape "Landscape" {
            include *
            title "FinTrack — Diagrama de Paisaje del Sistema (Ecosistema Completo)"
            description "Visión amplia del ecosistema FinTrack que incluye todos los sistemas internos y externos, más las relaciones entre sistemas externos (ej: Bancolombia reporta a DIAN). A diferencia del diagrama de contexto, aquí se muestran los sistemas de soporte técnico (OCR, correos, almacenamiento) y las interconexiones del entorno financiero colombiano."
        }

        # 6. Diagrama de Despliegue — Monolito
        deployment fintrack "Monolito" "MonolithDeployment" {
            include *
            title "FinTrack — Diagrama de Despliegue (Monolito)"
            description "Muestra la topología de infraestructura del despliegue monolítico: todos los componentes del sistema (frontend, backend, base de datos) se ejecutan en un mismo servidor, simplificando la administración y reduciendo costos."
        }

        # 7. Diagrama de Despliegue — Cloud
        deployment fintrack "Cloud" "CloudDeployment" {
            include *
            title "FinTrack — Diagrama de Despliegue (Cloud)"
            description "Muestra la topología de infraestructura en la nube usando servicios AWS: CloudFront como CDN, ALB para balanceo, ECS Fargate para el backend, RDS para la base de datos y S3 para almacenamiento de activos."
        }

        # 8. Diagrama de Despliegue — Arquitectura Microservicios
        deployment fintrack "Arquitectura Microservicios" "MicroservicesDeployment" {
            include *
            title "FinTrack — Diagrama de Despliegue (Arquitectura Microservicios)"
            description "Muestra la topología de infraestructura del despliegue basado en microservicios: cada módulo del backend se despliega como un servicio independiente con su propia base de datos, orquestados por un API Gateway (Kong) y servidos a través de CloudFront."
        }

        # 9. Diagrama de Despliegue — MVC
        deployment fintrack "MVC" "MVCDeployment" {
            include *
            title "FinTrack — Diagrama de Despliegue (MVC)"
            description "Muestra la topología de infraestructura del despliegue en estilo MVC: Servidor Vista (frontend web), Servidor Controlador (backend API) y Servidor Modelo (base de datos), cada uno en su propia capa física."
        }

        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json

        # =====================================================================
        # ESTILOS
        # =====================================================================
        styles {

            element "Element" {
                background #ffffff
                strokeWidth 10
                border solid
                fontSize 24
                shape RoundedBox
            }

            element "Person" {
                shape Person
                stroke #1E7A44
                color #1E7A44
                fontSize 22
            }

            element "Software System" {
                shape RoundedBox
                stroke #1168BD
                color #1168BD
            }

            element "External" {
                shape RoundedBox
                stroke #6B6B6B
                color #6B6B6B
            }

            element "Container" {
                shape RoundedBox
                stroke #438DD5
                color #438DD5
            }

            element "Component" {
                shape Component
                stroke #85BBF0
                color #333333
                fontSize 24
            }

            element "Adapter" {
                shape RoundedBox
                background #E67E22
                color #ffffff
                stroke #E67E22
                fontSize 24
            }

            element "EventBus" {
                shape Pipe
                background #8E44AD
                color #ffffff
                stroke #8E44AD
                fontSize 24
            }

            element "Database" {
                shape Cylinder
                stroke #1168BD
                color #1168BD
            }

            element "WebApp" {
                shape WebBrowser
                stroke #438DD5
                color #438DD5
            }

            element "MobileApp" {
                shape MobileDeviceLandscape
                stroke #438DD5
                color #438DD5
            }

            element "FileStorage" {
                shape Bucket
                stroke #6B6B6B
                color #6B6B6B
            }

            element "AIService" {
                shape Robot
                stroke #6C3483
                color #6C3483
            }

            element "Deployment Node" {
                shape Box
                background #FAFAFA
                stroke #333333
                strokeWidth 4
                fontSize 18
                border solid
            }

            relationship "Relationship" {
                thickness 4
            }

            relationship "Internal" {
                dashed true
                color #888888
                thickness 4
            }

            relationship "Internal / Event" {
                dashed true
                color #888888
                thickness 4
            }
        }
    }

    # =========================================================================
    # PLUGINS
    # =========================================================================
    !plugin com.structurizr.dsl.plugin.documentation.PlantUML
}
