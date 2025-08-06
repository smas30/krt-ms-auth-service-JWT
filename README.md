# 🔐 Servicio de Autenticacion JWT - Tests con Karate

Este proyecto contiene las pruebas automatizadas para el servicio de autenticacion JWT utilizando el framework Karate.

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Tecnologías](#-tecnologías)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Configuración](#-configuración)
- [Ejecución de Tests](#-ejecución-de-tests)
- [Features Disponibles](#-features-disponibles)
- [Reportes](#-reportes)
- [Troubleshooting](#-troubleshooting)

## 🎯 Descripcion

Proyecto de pruebas automatizadas para el servicio de autenticación JWT que incluye:
- **Login Token**: Validación de autenticación y generación de token JWT
- **Refresh Token**: Renovación de tokens JWT existentes
- **Validacion de Schemas**: Verificación de estructura de respuestas JSON
- **Reportes Automatizados**: Generación de reportes HTML y Karate

## 🛠️ Tecnologias

- **Java 17**
- **Maven 3.x**
- **Karate Framework 1.5.0**
- **JUnit 5**
- **Cucumber Reports**

## Estructura del Proyecto

```
krt-ms-auth-service-JWT/
├── src/
│   └── test/
│       └── java/
│           ├── api/                            # Features y Runner
│           ├── JsonRequest/                    # Archivos JSON de requests
│           ├── Schema/                         # Schemas de validación
│           ├── util/                           # Utilidades Java
│           └── karate-config.js               # Configuración de Karate
├── target/
│   ├── karate-reports/                        # Reportes de Karate
│   └── cucumber-reports/                      # Reportes de Cucumber
└── pom.xml                                    # Configuración de Maven
```

## Configuración

### Prerrequisitos

- Java 17 o superior
- Maven 3.6 o superior
- Acceso al servicio de autenticación

### Instalacion

1. **Clonar el repositorio:**
```bash
git clone <repository-url>
cd krt-ms-auth-service-JWT
```

2. **Compilar el proyecto:**
```bash
mvn clean compile test-compile
```
## 🚀 Ejecución de Tests

### Comando Principal para ejecutar todos los endpoint
```bash
mvn clean compile test-compile exec:java
```
### Desde IDE
1. Abrir `src/test/java/api/ParallelRunner.java`
2. Hacer clic derecho en el método `main`
3. Seleccionar "Run 'ParallelRunner.main()'"

### Comandos Rapidos
```bash
# Solo compilar
mvn test-compile

# Solo ejecutar
mvn exec:java

# Con debug
mvn exec:java -Dkarate.debug=true
```

## 📈 Reportes

- **Karate:** `target/karate-reports/karate-summary.html`
- **Cucumber:** `target/cucumber-reports/overview-features.html`
- **JSON:** `target/api.*.json`

Incluye tiempo de ejecución, features ejecutados y estadísticas detalladas.


##  Troubleshooting

### Problemas Comunes
- **Error 500:** Verificar token en request
- **Token Null:** Revisar estructura de respuesta
- **Error Compilación:** Ejecutar `mvn clean compile test-compile`
- **Threads Warnings:** Normales, no afectan funcionalidad

### Debug
```bash
mvn exec:java -Dkarate.debug=true
```

---

**Desarrollado con Karate Framework** 