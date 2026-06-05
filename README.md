# FinTrack — Modelo C4 con Structurizr

Este repositorio contiene la documentación arquitectónica de **FinTrack**, un sistema de gestión de finanzas personales, modelado utilizando el **modelo C4** a través de la herramienta **Structurizr**.

El proyecto fue desarrollado como parte de un trabajo académico para aprender y aplicar el modelo C4 en la documentación de arquitectura de software. Incluye diagramas de contexto, contenedores, componentes, despliegue y paisaje del sistema, todos definidos mediante un DSL (Domain Specific Language) y complementados con documentación en markdown, decisiones arquitectónicas (ADRs) y diagramas PlantUML.

## Estructura del proyecto

```
├── workspace.dsl                    # Modelo C4 completo en DSL
├── workspace.json                   # Exportación del workspace
├── docs/                            # Documentación del proyecto en markdown
│   ├── 01-presentacion.md
│   ├── 02-directrices.md
│   ├── 03-diagramas.md
│   ├── 04-plantuml.md
│   └── 05-decisiones.md
└── decisions/                       # Architecture Decision Records (ADRs)
    ├── 0001-recuperacion-automatica-ante-fallos.md
    ├── 0002-biblioteca-componentes-ui-reutilizables.md
    └── ...
```

## Cómo ejecutar en local

Structurizr expone una imagen oficial de Docker que permite visualizar los diagramas y la documentación sin necesidad de instalar Java ni configurar un servidor. Solo necesitas Docker y seguir estos pasos.

### 1. Requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado en tu sistema.

### 2. Descargar la imagen

```bash
docker pull structurizr/structurizr
```

### 3. Opción A — Ejecutar un workspace individual

Si solo quieres visualizar este proyecto, usa el modo por defecto montando la raíz del repositorio como directorio de datos:

```bash
docker run -it --rm -p 8080:8080 -v /ruta/a/este/repositorio:/usr/local/structurizr structurizr/structurizr local
```

Por ejemplo, si clonaste el repo en `~/proyectos/fintrack`:

```bash
docker run -it --rm -p 8080:8080 -v ~/proyectos/fintrack:/usr/local/structurizr structurizr/structurizr local
```

> El flag `--rm` hace que el contenedor se elimine al detenerse. Es útil para usos esporádicos.

### 4. Opción B — Multi-workspace (recomendado)

Si trabajas con varios proyectos de Structurizr (por ejemplo, varios trabajos académicos o repositorios), el modo **multi-workspace** te permite mantener un solo contenedor persistente que sirva todos tus proyectos a la vez.

Para habilitarlo, crea un directorio raíz compartido y dentro de él una subcarpeta por cada proyecto. El nombre de cada subcarpeta debe cumplir con el formato `\d*-[a-zA-Z0-9_-]*`, es decir: un identificador numérico seguido opcionalmente de un nombre descriptivo.

Ejemplos de nombres válidos:

- `1`
- `01`
- `01-fintrack`
- `02-otro-proyecto`

La estructura quedaría así:

```
~/structurizr-workspaces/
├── 01-fintrack/
│   ├── workspace.dsl
│   ├── docs/
│   └── decisions/
└── 02-otro-proyecto/
    ├── workspace.dsl
    └── ...
```

Para iniciar el contenedor en modo multi-workspace, se pasa la variable de entorno `STRUCTURIZR_WORKSPACES=*` y se omite `--rm` para que el contenedor persista y puedas encenderlo y apagarlo sin perder nada:

```bash
docker run -it -d -p 8080:8080 -v ~/structurizr-workspaces:/usr/local/structurizr -e STRUCTURIZR_WORKSPACES=* --name structurizr structurizr/structurizr local
```

A partir de ahí, para detenerlo y volver a iniciarlo:

```bash
docker stop structurizr
docker start structurizr
```

> Al omitir `--rm` el contenedor no se elimina al detenerse. La opción `-d` lo ejecuta en segundo plano (detached). El flag `--name structurizr` asigna un nombre fijo al contenedor para manejarlo fácilmente.

### 5. Acceder a los diagramas

Abre tu navegador y ve a [http://localhost:8080](http://localhost:8080). Structurizr cargará el workspace y podrás navegar por todos los diagramas y la documentación desde la interfaz web.

## Autor

Realizado por **Xahep Julián Gómez Durán**, estudiante de Ingeniería de Sistemas de la Universidad Autónoma de Bucaramanga (UNAB), 2026.

## Recursos

- [Structurizr Local — Quickstart](https://docs.structurizr.com/local/quickstart): guía oficial para ejecutar Structurizr en local con Docker.
- [Structurizr DSL — Documentation](https://docs.structurizr.com/dsl): referencia del lenguaje DSL.
- [Structurizr Configuration — Multi-workspace mode](https://docs.structurizr.com/local/configuration#multi-workspace-mode): documentación sobre el modo multi-workspace.
- [C4 Model](https://c4model.com): sitio oficial del modelo C4 por Simon Brown.
