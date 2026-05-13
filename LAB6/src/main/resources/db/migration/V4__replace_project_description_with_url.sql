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