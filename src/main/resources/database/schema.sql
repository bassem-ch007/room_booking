-- Créer la base de données
CREATE DATABASE IF NOT EXISTS roombooking;
USE roombooking;

-- ===== TABLES =====

-- Users
CREATE TABLE users (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       role ENUM('USER', 'ADMIN') DEFAULT 'USER',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Room Types
CREATE TABLE room_types (
                            id INT PRIMARY KEY,
                            name VARCHAR(50) NOT NULL
);

INSERT INTO room_types VALUES
                           (1, 'BANQUET_HALL'),
                           (2, 'EVENT_HALL'),
                           (3, 'WEDDING_HALL');

-- Rooms
CREATE TABLE rooms (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       room_type_id INT NOT NULL,
                       name VARCHAR(100) NOT NULL,
                       capacity INT NOT NULL,
                       size DOUBLE NOT NULL,
                       location VARCHAR(255) NOT NULL,
                       pricing DECIMAL(10, 2) NOT NULL,
                       image_path VARCHAR(255),
                       availability_status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

-- Reservations
CREATE TABLE reservations (
                              id BIGINT PRIMARY KEY AUTO_INCREMENT,
                              user_id BIGINT NOT NULL,
                              room_id BIGINT NOT NULL,
                              start_date_time DATETIME NOT NULL,
                              end_date_time DATETIME NOT NULL,
                              status ENUM('PENDING', 'APPROVED', 'CANCELLED', 'CLIENT_CANCELLED') DEFAULT 'PENDING',
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                              FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- ===== INDICES =====
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_rooms_type ON rooms(room_type_id);
CREATE INDEX idx_reservations_user ON reservations(user_id);
CREATE INDEX idx_reservations_room ON reservations(room_id);
CREATE INDEX idx_reservations_status ON reservations(status);