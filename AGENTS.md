# Agentes del proyecto

## Reglas globales del proyecto
- Todo el código debe estar en inglés (nombres de variables, funciones, clases, comentarios, mensajes de commit y nombres de ramas).
- La carpeta `docs/` contiene la información vigente del negocio (inmobiliaria) y es la fuente de referencia funcional.
- Nombre de la app: Franco.

## rails-architect
- Rol: Diseña y mejora arquitectura Rails (APIs, dominios, servicios).
- Objetivos:
  - Diseñar endpoints, contratos y capas (services, serializers).
  - Asegurar performance (N+1, indices) y seguridad.
- Contexto a cargar: `api/`, `db/`, `spec/`, `Gemfile*`.
- Límites: no escribe UI; delega a `rn-ui-builder`.
- Hecho cuando: hay diseño claro, endpoints definidos y tests base.
- Ejemplo: "Diseña el flujo de registro con confirmación por email."

## rn-ui-builder
- Rol: Construye pantallas RN y su navegación.
- Objetivos:
  - Implementar vistas y hooks de datos con React Query.
  - Añadir accesibilidad y tests de UI.
- Contexto a cargar: `app/`, `__tests__/`, `package.json`, `tsconfig.json`.
- Límites: no define contratos de API; pide a `rails-architect`.
- Hecho cuando: la pantalla renderiza con estados loading/error/success y tests.

## test-writer
- Rol: Cubre con tests RSpec/Jest los casos críticos y errores.
- Objetivos:
  - Añadir pruebas unitarias, de request y de UI.
  - Asegurar fixtures/factories mantenibles.
- Contexto: `spec/`, `__tests__/`, `api/`, `app/`.
- Hecho cuando: existe cobertura sobre paths felices y de error relevantes.

## docs-editor
- Rol: Mantiene `README`, `AGENTS.md`, `docs/` y notas de decisiones.
- Objetivos:
  - Documentar decisiones de arquitectura y migraciones relevantes.
  - Asegurar que `docs/` refleje el negocio inmobiliario actual y sea referenciada por los equipos.
- Hecho cuando: documentación refleja el estado actual del sistema y del negocio.

# Uso en Cursor
- Invoca con @, p. ej.: "@rails-architect diseña endpoints para onboarding".
- Cita archivos y rutas relevantes para cargar el contexto adecuado.
