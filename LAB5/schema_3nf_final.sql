/* ====================================================================
   У звіті (LAB5.md) продемонстровано покроковий процес трансформації
   старої схеми за допомогою команд ALTER TABLE.

   Цей SQL-файл містить фінальні DDL-інструкції (CREATE TABLE)
   для розгортання бази даних з нуля вже у Третій нормальній формі (3NF),
   як вимагається в умові лабораторної роботи.
   ==================================================================== */

/* === 1. ОЧИЩЕННЯ БД (DROP) === */
DROP TABLE IF EXISTS task_tags;
DROP TABLE IF EXISTS project_members;
DROP TABLE IF EXISTS "comments";
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS project_roles;
DROP TABLE IF EXISTS priorities;
DROP TABLE IF EXISTS statuses;

/* === 2. СТВОРЕННЯ ТАБЛИЦЬ (DDL - 3NF) === */

-- Довідник статусів
CREATE TABLE statuses (
    status_id SERIAL PRIMARY KEY,
    name VARCHAR(32) UNIQUE NOT NULL
);

-- Довідник пріоритетів
CREATE TABLE priorities (
    priority_id SERIAL PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
);

-- Довідник ролей учасників проєкту
CREATE TABLE project_roles (
    role_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Користувачі
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(32) NOT NULL CHECK (role IN ('admin', 'user')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE NOT NULL
);

-- Теги
CREATE TABLE tags (
    tag_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Проєкти
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status_id INTEGER NOT NULL REFERENCES statuses(status_id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline TIMESTAMP,
    manager_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT
);

-- Завдання
CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    priority_id INTEGER NOT NULL REFERENCES priorities(priority_id) ON DELETE RESTRICT,
    status_id INTEGER NOT NULL REFERENCES statuses(status_id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline TIMESTAMP,
    project_id INTEGER NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    assignee_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT
);

-- Коментарі
CREATE TABLE "comments" (
    comment_id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    task_id INTEGER NOT NULL REFERENCES tasks(task_id) ON DELETE CASCADE
);

/* === АСОЦІАТИВНІ ТАБЛИЦІ (M:N) === */

-- Команда проєкту (Композитний ключ)
CREATE TABLE project_members (
    project_id INTEGER NOT NULL REFERENCES projects(project_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_id INTEGER NOT NULL REFERENCES project_roles(role_id) ON DELETE RESTRICT,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (project_id, user_id)
);

-- Зв'язок завдань і тегів (Композитний ключ)
CREATE TABLE task_tags (
    task_id INTEGER NOT NULL REFERENCES tasks(task_id) ON DELETE CASCADE,
    tag_id INTEGER NOT NULL REFERENCES tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, tag_id)
);