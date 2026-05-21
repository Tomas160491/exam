-- ------------------------------------------------------------
-- База данных для портала "Банкетам.Нет"
-- Специальность: 09.02.07 Информационные системы и программирование
-- Вариант №4, модуль №1
-- ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS banquet_net
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE banquet_net;

-- ------------------------------------------------------------
-- Таблица пользователей (клиенты и администратор)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,                -- латиница+цифры, мин. 6 символов
    password_hash VARCHAR(255) NOT NULL,              -- хеш пароля (мин. 8 символов)
    full_name VARCHAR(150) NOT NULL,                  -- ФИО
    phone VARCHAR(20) NOT NULL,                       -- контактный телефон
    email VARCHAR(120) NOT NULL,                      -- e-mail
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user', -- роль
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_login (login)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Таблица помещений (залы, рестораны, веранды)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS halls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,                       -- название помещения
    type ENUM('Зал', 'Ресторан', 'Летняя веранда', 'Закрытая веранда') NOT NULL,
    description TEXT,                                 -- описание
    capacity INT,                                     -- вместимость (чел.)
    price_per_hour DECIMAL(10,2),                    -- цена за час (опционально)
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Таблица заявок на бронирование (banket = банкет)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    hall_id INT NOT NULL,
    event_date DATE NOT NULL,                          -- дата начала банкета
    payment_method ENUM('Наличными', 'Банковской картой', 'Переводом по номеру телефона') NOT NULL,
    status ENUM('Новая', 'Банкет назначен', 'Банкет завершен') NOT NULL DEFAULT 'Новая',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hall_id) REFERENCES halls(id) ON DELETE RESTRICT,
    
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_date (event_date)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Таблица отзывов (только после статуса "Банкет завершен")
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    booking_id INT NOT NULL,                           -- ссылка на конкретную заявку
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_booking_review (booking_id)      -- на одну заявку – один отзыв
) ENGINE=InnoDB;