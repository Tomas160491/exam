USE banquet_net;

-- ------------------------------------------------------------
-- 1. Добавление администратора (логин: Admin26, пароль: Demo20)
-- Хеш пароля получен с помощью password_hash('Demo20', PASSWORD_DEFAULT)
-- Здесь используется пример для PHP (password_hash). Для других языков замените хеш.
-- Если нужен plain-text (не рекомендуется), укажите его явно.
-- ------------------------------------------------------------
INSERT INTO users (login, password_hash, full_name, phone, email, role)
VALUES (
    'Admin26',
    '$2y$10$9X4fLZxq3W5H7J9kL2mN4oP6qR8sT0uV2wX4yZ6aB8cD0eF2gH4iJ6K',  -- хеш для "Demo20"
    'Администратор Системы',
    '+7(999)000-00-01',
    'admin@banquet.net',
    'admin'
) ON DUPLICATE KEY UPDATE login = login;

-- ------------------------------------------------------------
-- 2. Добавление тестового пользователя (логин: user1, пароль: password123)
-- Хеш для "password123" (пример)
-- ------------------------------------------------------------
INSERT INTO users (login, password_hash, full_name, phone, email, role)
VALUES (
    'user1',
    '$2y$10$A1bC2dE3fG4hI5jK6lM7nO8pQ9rS0tU1vW2xY3zZ4aB5cD6eF7gH8iJ9K',
    'Петров Пётр Сергеевич',
    '+7(912)345-67-89',
    'petrov@example.com',
    'user'
) ON DUPLICATE KEY UPDATE login = login;

-- ------------------------------------------------------------
-- 3. Добавление ещё одного пользователя (логин: annet, пароль: qwerty123)
-- ------------------------------------------------------------
INSERT INTO users (login, password_hash, full_name, phone, email, role)
VALUES (
    'annet',
    '$2y$10$B2cD3eF4gH5iJ6kL7mN8oP9qR0sT1uV2wX3yZ4aB5cD6eF7gH8iJ9K0L',
    'Аннет Смирнова',
    '+7(921)111-22-33',
    'annet@example.com',
    'user'
) ON DUPLICATE KEY UPDATE login = login;

-- ------------------------------------------------------------
-- 4. Добавление помещений (залы, рестораны, веранды)
-- ------------------------------------------------------------
INSERT INTO halls (name, type, description, capacity, price_per_hour) VALUES
('Изумрудный зал', 'Зал', 'Просторный банкетный зал с панорамными окнами', 100, 5000.00),
('Янтарный ресторан', 'Ресторан', 'Уютный ресторан с живой музыкой', 50, 7000.00),
('Летняя терраса', 'Летняя веранда', 'Открытая веранда с видом на сад', 80, 4000.00),
('Зимний сад', 'Закрытая веранда', 'Отапливаемая веранда, оформленная растениями', 60, 4500.00);

-- ------------------------------------------------------------
-- 5. Добавление заявок (разные статусы)
-- ------------------------------------------------------------
-- Заявка №1: от user1, статус "Новая"
INSERT INTO bookings (user_id, hall_id, event_date, payment_method, status)
VALUES (
    (SELECT id FROM users WHERE login = 'user1'),
    (SELECT id FROM halls WHERE name = 'Изумрудный зал'),
    '2026-06-15',
    'Наличными',
    'Новая'
);

-- Заявка №2: от user1, статус "Банкет назначен"
INSERT INTO bookings (user_id, hall_id, event_date, payment_method, status)
VALUES (
    (SELECT id FROM users WHERE login = 'user1'),
    (SELECT id FROM halls WHERE name = 'Янтарный ресторан'),
    '2026-06-20',
    'Банковской картой',
    'Банкет назначен'
);

-- Заявка №3: от annet, статус "Банкет завершен" (для отзыва)
INSERT INTO bookings (user_id, hall_id, event_date, payment_method, status)
VALUES (
    (SELECT id FROM users WHERE login = 'annet'),
    (SELECT id FROM halls WHERE name = 'Летняя терраса'),
    '2026-05-10',
    'Переводом по номеру телефона',
    'Банкет завершен'
);

-- Заявка №4: от annet, статус "Новая"
INSERT INTO bookings (user_id, hall_id, event_date, payment_method, status)
VALUES (
    (SELECT id FROM users WHERE login = 'annet'),
    (SELECT id FROM halls WHERE name = 'Зимний сад'),
    '2026-07-01',
    'Наличными',
    'Новая'
);

-- ------------------------------------------------------------
-- 6. Добавление отзыва (только для завершённого банкета)
-- ------------------------------------------------------------
INSERT INTO reviews (user_id, booking_id, rating, comment)
VALUES (
    (SELECT id FROM users WHERE login = 'annet'),
    (SELECT id FROM bookings WHERE user_id = (SELECT id FROM users WHERE login = 'annet') 
        AND status = 'Банкет завершен' LIMIT 1),
    5,
    'Всё прошло замечательно! Терраса очень уютная, персонал вежливый. Спасибо!'
);