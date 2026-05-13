-- lab4
-- Скільки завдань маємо в кожному статусі?
SELECT status, COUNT(*) AS total_tasks
FROM tasks
GROUP BY status;

-- Найближчий і найвіддаленіший дедлайни по кожному проєкту (MIN/MAX)
SELECT project_id, MIN(deadline) AS first_deadline, MAX(deadline) AS last_deadline
FROM tasks
GROUP BY project_id;

-- Знайти користувачів, які залишили більше 1 коментаря (HAVING)
SELECT user_id, COUNT(*) AS comments_count
FROM "comments"
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Показуємо кількість коментарів для кожного завдання
SELECT task_id, COUNT(comment_id) AS total_comments
FROM "comments"
GROUP BY task_id;

-- Вивести список: Назва завдання — Назва проєкту — Ім'я виконавця.
SELECT t.title AS task_name, p.name AS project_name, u.first_name || ' ' || u.last_name AS assignee_name
FROM tasks t
INNER JOIN projects p ON t.project_id = p.project_id
INNER JOIN users u ON t.assignee_id = u.user_id;

-- Cписок всіх співробітників і скільки на них висить завдань.
SELECT u.email, COUNT(t.task_id) AS tasks_assigned
FROM users u
LEFT JOIN tasks t ON u.user_id = t.assignee_id
GROUP BY u.email;

-- Які тегі не юзаються
SELECT tg.name AS tag_name
FROM task_tags tt
RIGHT JOIN tags tg ON tt.tag_id = tg.tag_id
WHERE tt.task_id IS NULL;


-- Аліса хоче подивитись всі задачі, які стосуються проєктів, якими вона керує.
SELECT title, priority, status
FROM tasks
WHERE project_id IN (
    SELECT project_id
    FROM projects
    WHERE manager_id = (SELECT user_id FROM users WHERE first_name = 'Alice')
);

-- Вивести завдання і поруч — загальну кількість завдань у цьому проєкті
SELECT
    t1.title,
    t1.project_id,
    (SELECT COUNT(*) FROM tasks t2 WHERE t2.project_id = t1.project_id) AS total_project_tasks
FROM tasks t1;

-- Знайти "перевантажених" працівників
SELECT assignee_id, COUNT(task_id) AS task_count
FROM tasks
GROUP BY assignee_id
HAVING COUNT(task_id) > (
    SELECT COUNT(*) * 1.0 / COUNT(DISTINCT assignee_id)
    FROM tasks
);