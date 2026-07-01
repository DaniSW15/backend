# Backend API - Prueba Técnica

Esta es la API del backend desarrollada con **Ruby on Rails 8.1** en modo API.

## Requisitos

- **Ruby**: 3.4.9 (definido en `.ruby-version`)
- **PostgreSQL**: Instalado y corriendo localmente.

## Configuración y Ejecución (Local)

1. **Instalar dependencias**:

   ```bash
   bundle install
   ```

2. **Configurar variables de entorno**:
   Copia el archivo de ejemplo y edita las credenciales de tu base de datos:

   ```bash
   cp .env.example .env
   ```

3. **Preparar la Base de Datos**:
   Crea, migra y alimenta la base de datos de desarrollo:

   ```bash
   bin/rails db:prepare
   ```

4. **Iniciar el servidor**:
   Levanta la API en el puerto `3000` (http://localhost:3000):
   ```bash
   bin/rails server
   ```

## Endpoints de la API (`/api/v1`)

- **Autenticación (`auth/`)**:
  - `POST /auth/register` - Registrar usuario.
  - `POST /auth/login` - Iniciar sesión (invalida sesiones activas previas).
  - `DELETE /auth/logout` - Cerrar sesión activa.
  - `PATCH /auth/update_password` - Modificar contraseña.
  - `POST /auth/forgot_password` - Restablecer contraseña con Email y RFC.

- **Colaboradores (`employees/`)**:
  - `GET /employees` - Listar colaboradores.
  - `POST /employees` - Crear colaborador.
  - `PUT/PATCH /employees/:id` - Actualizar colaborador.
  - `DELETE /employees/:id` - Eliminar colaborador.
  - `GET /employees/states` - Listar estados de la República Mexicana.

- **Usuarios (`users/`)**:
  - `GET /users` - Listar sub-usuarios creados por el administrador actual.
  - `POST /users` - Registrar sub-usuario.
  - `PUT/PATCH /users/:id` - Editar datos de usuario/sub-usuario.
  - `DELETE /users/:id` - Eliminar sub-usuario.
  - `GET /users/me` - Obtener información del usuario autenticado.

- **Algoritmos (`palindrome/`)**:
  - `POST /palindrome/check` - Recibe `words: []` y detecta cuáles son palíndromas. Requiere autenticación.

- **Servicios (`posts/`)**:
  - `GET /posts` - Listar publicaciones desde JSONPlaceholder.
  - `POST /posts` - Crear publicación en JSONPlaceholder.
  - `PUT/PATCH /posts/:id` - Actualizar publicación.
  - `DELETE /posts/:id` - Eliminar publicación.

## Base de Datos (UML y Creación)

Cumpliendo con los requisitos de la evaluación, se incluyen los siguientes archivos en la carpeta `db/`:

- [**Diagrama UML de Clases**](file:///Users/danisw.dev/Desktop/prueba-tecnica/backend/db/uml_diagram.md): Contiene la descripción de las relaciones y un diagrama interactivo en formato Mermaid.
- [**Script SQL de Creación**](file:///Users/danisw.dev/Desktop/prueba-tecnica/backend/db/schema.sql): Script completo en SQL de creación de la base de datos (tablas, relaciones, índices y triggers de PostgreSQL).
