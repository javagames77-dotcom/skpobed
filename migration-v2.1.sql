-- ================================================
-- INSKILL ONLINE v2.1 - MIGRATION
-- Добавление многопользовательской системы
-- ================================================

-- 1. ДОБАВЛЯЕМ СВЯЗЬ MANY-TO-MANY: ТРЕНЕР ↔ КЛУБЫ
CREATE TABLE trainer_clubs (
    id SERIAL PRIMARY KEY,
    trainer_id INTEGER REFERENCES users(id),
    club_id INTEGER REFERENCES clubs(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(trainer_id, club_id)
);

CREATE INDEX idx_trainer_clubs_trainer ON trainer_clubs(trainer_id);
CREATE INDEX idx_trainer_clubs_club ON trainer_clubs(club_id);

-- 2. ДОБАВЛЯЕМ СВЯЗЬ MANY-TO-many: ТРЕНЕР ↔ ГРУППЫ
CREATE TABLE trainer_groups (
    id SERIAL PRIMARY KEY,
    trainer_id INTEGER REFERENCES users(id),
    group_id INTEGER REFERENCES groups(id),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(trainer_id, group_id)
);

CREATE INDEX idx_trainer_groups_trainer ON trainer_groups(trainer_id);
CREATE INDEX idx_trainer_groups_group ON trainer_groups(group_id);

-- 3. ОБНОВЛЯЕМ РОЛИ (добавляем superadmin, director)
-- Обновляем CHECK constraint в users
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check;
ALTER TABLE users ADD CONSTRAINT users_role_check 
    CHECK (role IN ('superadmin', 'director', 'trainer', 'parent'));

-- 4. ДОБАВЛЯЕМ ПОЛЕ director_id В CLUBS
ALTER TABLE clubs ADD COLUMN IF NOT EXISTS director_id INTEGER REFERENCES users(id);
CREATE INDEX IF NOT EXISTS idx_clubs_director ON clubs(director_id);

-- 5. ФУНКЦИЯ ДЛЯ ПРОВЕРКИ: ЕСТЬ ЛИ СПОРТСМЕНЫ В ГРУППЕ
CREATE OR REPLACE FUNCTION group_has_children(group_id_param INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM children 
        WHERE group_id = group_id_param 
        AND is_active = TRUE
    );
END;
$$ LANGUAGE plpgsql;

-- 6. СОЗДАНИЕ СУПЕРАДМИНА (первый пользователь)
-- Запустите это ОДИН РАЗ вручную, заменив пароль:
/*
INSERT INTO users (email, password_hash, role, first_name, last_name, is_active)
VALUES (
    'admin@inskill.online',
    'YOUR_HASHED_PASSWORD_HERE',  -- Хэш через Auth API register
    'superadmin',
    'Super',
    'Admin',
    TRUE
) RETURNING id, email, role;
*/

-- 7. ПРИМЕР: МИГРАЦИЯ СУЩЕСТВУЮЩИХ ДАННЫХ
-- Переносим существующие связи тренер→клуб в trainer_clubs
INSERT INTO trainer_clubs (trainer_id, club_id, is_active)
SELECT DISTINCT u.id, u.club_id, TRUE
FROM users u
WHERE u.role = 'trainer' 
AND u.club_id IS NOT NULL
AND u.is_active = TRUE
ON CONFLICT (trainer_id, club_id) DO NOTHING;

-- Переносим существующие связи тренер→группа в trainer_groups
INSERT INTO trainer_groups (trainer_id, group_id, is_active)
SELECT DISTINCT g.trainer_id, g.id, TRUE
FROM groups g
WHERE g.trainer_id IS NOT NULL
AND g.is_active = TRUE
ON CONFLICT (trainer_id, group_id) DO NOTHING;

-- 8. ПРЕДСТАВЛЕНИЕ: ВСЕ КЛУБЫ ТРЕНЕРА
CREATE OR REPLACE VIEW trainer_clubs_view AS
SELECT 
    tc.trainer_id,
    c.id as club_id,
    c.name as club_name,
    c.address,
    c.director_id,
    u.first_name || ' ' || u.last_name as director_name
FROM trainer_clubs tc
JOIN clubs c ON c.id = tc.club_id
LEFT JOIN users u ON u.id = c.director_id
WHERE tc.is_active = TRUE
AND c.is_active = TRUE;

-- 9. ПРЕДСТАВЛЕНИЕ: ВСЕ ГРУППЫ ТРЕНЕРА
CREATE OR REPLACE VIEW trainer_groups_view AS
SELECT 
    tg.trainer_id,
    g.id as group_id,
    g.name as group_name,
    g.club_id,
    c.name as club_name,
    (SELECT COUNT(*) FROM children ch 
     WHERE ch.group_id = g.id AND ch.is_active = TRUE) as children_count
FROM trainer_groups tg
JOIN groups g ON g.id = tg.group_id
LEFT JOIN clubs c ON c.id = g.club_id
WHERE tg.is_active = TRUE
AND g.is_active = TRUE;

-- 10. ФУНКЦИЯ: ПОЛУЧИТЬ ВСЕХ СПОРТСМЕНОВ ДИРЕКТОРА
CREATE OR REPLACE FUNCTION get_director_children(director_id_param INTEGER)
RETURNS TABLE (
    id INTEGER,
    first_name VARCHAR,
    last_name VARCHAR,
    birth_date DATE,
    photo_url TEXT,
    group_id INTEGER,
    group_name VARCHAR,
    club_id INTEGER,
    club_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ch.id,
        ch.first_name,
        ch.last_name,
        ch.birth_date,
        ch.photo_url,
        ch.group_id,
        g.name as group_name,
        c.id as club_id,
        c.name as club_name
    FROM children ch
    LEFT JOIN groups g ON g.id = ch.group_id
    LEFT JOIN clubs c ON c.id = g.club_id
    WHERE c.director_id = director_id_param
    AND ch.is_active = TRUE
    AND g.is_active = TRUE
    AND c.is_active = TRUE
    ORDER BY ch.last_name, ch.first_name;
END;
$$ LANGUAGE plpgsql;

-- 11. ФУНКЦИЯ: ПОЛУЧИТЬ ВСЕХ СПОРТСМЕНОВ ТРЕНЕРА
CREATE OR REPLACE FUNCTION get_trainer_children(trainer_id_param INTEGER)
RETURNS TABLE (
    id INTEGER,
    first_name VARCHAR,
    last_name VARCHAR,
    birth_date DATE,
    photo_url TEXT,
    group_id INTEGER,
    group_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ch.id,
        ch.first_name,
        ch.last_name,
        ch.birth_date,
        ch.photo_url,
        ch.group_id,
        g.name as group_name
    FROM children ch
    JOIN groups g ON g.id = ch.group_id
    JOIN trainer_groups tg ON tg.group_id = g.id
    WHERE tg.trainer_id = trainer_id_param
    AND tg.is_active = TRUE
    AND ch.is_active = TRUE
    AND g.is_active = TRUE
    ORDER BY ch.last_name, ch.first_name;
END;
$$ LANGUAGE plpgsql;

-- ================================================
-- ИТОГО ДОБАВЛЕНО:
-- • 2 таблицы (trainer_clubs, trainer_groups)
-- • 4 индекса
-- • 2 представления (views)
-- • 3 функции (проверка группы, списки спортсменов)
-- • Обновлен CHECK constraint для ролей
-- ================================================
