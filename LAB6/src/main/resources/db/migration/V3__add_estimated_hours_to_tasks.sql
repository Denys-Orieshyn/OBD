-- 1. Додаємо нову колонку
ALTER TABLE tasks
    ADD COLUMN estimated_hours INTEGER DEFAULT 0 CHECK (estimated_hours >= 0);

-- 2. Оновлюємо існуючі записи, задаючи їм реалістичні оцінки часу
UPDATE tasks SET estimated_hours = 4 WHERE task_id = 1;
UPDATE tasks SET estimated_hours = 16 WHERE task_id = 2;
UPDATE tasks SET estimated_hours = 8 WHERE task_id = 3;

-- 3. Додаємо коментар до колонки для системної документації
COMMENT ON COLUMN tasks.estimated_hours IS 'Оцінка часу на виконання завдання в годинах';