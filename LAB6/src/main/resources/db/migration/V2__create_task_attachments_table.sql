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
