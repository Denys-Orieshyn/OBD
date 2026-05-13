# Лабораторна робота №6
## Міграції схем за допомогою Flyway
---
### Роботу виконав
Студент групи ІО-46
Орєшин Д.І.
### Роботу перевірив
Русінов В.В.
---
## Мета роботи
### Використати Flyway для керування схемами та дослідити, як Flyway може аналізувати та змінювати схему вашої бази даних.
### Зрозуміти конвенцію іменування Flyway-скриптів, застосування міграцій, генерування та застосування змін схеми.
### Написати кілька версійних SQL-міграцій для вашої схеми та застосувати їх через Flyway.
### Перевірити результати змін за допомогою SQL-запитів і задокументувати їх.
### Навчитися коректно використовувати контролювання версій міграцій у Git  (скрипти зберігаються у проекті, а не змінюються після застосування).

---
## Результати

### Спочатку було ініціалізовано середовище Java/Maven-проєкту та налаштовано плагін Flyway
### для керування міграціями нашої існуючої бази даних PostgreSQL, розробленої після перших п`яти лаб
![](./images/structure.png)

### Для коректної роботи Flyway було створено та налаштовано необхідну архітектуру файлів і каталогів:

### pom.xml — основний файл конфігурації Maven, який містить підключені залежності (драйвер PostgreSQL) та параметри плагіна Flyway
### (рядок підключення до бази даних, логін та пароль).

### src/main/resources/db/migration/ — спеціальна директорія, визначена стандартами Flyway. У ній зберігаються всі версійні SQL-скрипти
### Плагін автоматично сканує цю папку під час запуску команди міграції.

## 1. Додавання нової таблиці

## Створено таблицю `task_attachments`
## Для реалізації бізнес-вимоги прикріплювати файли (наприклад, скріншоти багів або ТЗ) до конкретних завдань.

```sql
CREATE TABLE task_attachments (
    attachment_id SERIAL PRIMARY KEY,
    task_id INTEGER NOT NULL REFERENCES tasks(task_id) ON DELETE CASCADE,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Наповнюємо нову таблицю тестовими даними для існуючих завдань
INSERT INTO task_attachments (task_id, file_path) VALUES
    (1, '/uploads/screenshots/login_bug.png'),
    (1, '/uploads/logs/error_trace.txt'),
    (2, '/uploads/designs/home_page_v1.fig');
```
![](./images/migration_1.png)

# До:
![](./images/DO_1.png)

# Після:

![](./images/after_1.png)

## 2. Оновлення таблиці

## У таблицю `tasks` додано стовпець `estimated_hours` Для можливості оцінювати трудозатрати на виконання завдань (Time Tracking).

```sql
-- 1. Додаємо нову колонку
ALTER TABLE tasks
    ADD COLUMN estimated_hours INTEGER DEFAULT 0 CHECK (estimated_hours >= 0);

-- 2. Оновлюємо існуючі записи, задаючи їм реалістичні оцінки часу
UPDATE tasks SET estimated_hours = 4 WHERE task_id = 1;
UPDATE tasks SET estimated_hours = 16 WHERE task_id = 2;
UPDATE tasks SET estimated_hours = 8 WHERE task_id = 3;

-- 3. Додаємо коментар до колонки для системної документації
COMMENT ON COLUMN tasks.estimated_hours IS 'Оцінка часу на виконання завдання в годинах';
```
![](./images/migration_2.png)

# До:
![](./images/DO_2.png)

# Після:

![](./images/after_2.png)

## 3. Видалення стовпця та заміна логіки

### Для Оптимізації бази даних у зв'язку з перенесенням описів проєктів до зовнішньої корпоративної бази знань (Wiki/Notion).
### З таблиці `projects` видалено текстовий стовпець `description`, натомість додано стовпець `wiki_url` та заповнено посиланнями для існуючих проєктів.

```sql
-- 1. Видаляємо старе текстове поле з описом
ALTER TABLE projects
DROP COLUMN description;

-- 2. Замість нього додаємо поле для посилання на зовнішню документацію (Wiki/Notion)
ALTER TABLE projects
    ADD COLUMN wiki_url VARCHAR(255);

-- 3. Заповнюємо нове поле для існуючих проєктів
UPDATE projects SET wiki_url = 'https://wiki.company.com/projects/1' WHERE project_id = 1;
UPDATE projects SET wiki_url = 'https://wiki.company.com/projects/2' WHERE project_id = 2;
UPDATE projects SET wiki_url = 'https://wiki.company.com/projects/3' WHERE project_id = 3;
```
![](./images/migration_3.png)

# До:
![](./images/DO_3.png)

# Після:

![](./images/after_3.png)

# Висновки
Під час роботи було успішно проведено серію міграцій для нормалізованої схеми бази даних Task Management System.
Використання Flyway дозволило поетапно розширити функціонал системи: реалізувати підтримку вкладень,
впровадити систему оцінки трудозатрат та провести рефакторинг атрибутів проєктів. Отримані результати підтвердили,
що використання засобів автоматизації міграцій гарантує точну відповідність структури бази даних актуальному стану коду
та забезпечує повну відтворюваність змін у будь-якому середовищі розробки.
