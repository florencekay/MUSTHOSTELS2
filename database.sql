-- MUST Hostel Room Booking System - Database Schema
-- Created for Malawi University of Science and Technology

CREATE DATABASE IF NOT EXISTS must_hostel;
USE must_hostel;

-- Users table (Admin, Operator, Student)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reg_number VARCHAR(20) UNIQUE,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','operator','student') NOT NULL DEFAULT 'student',
    gender ENUM('male','female'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Halls/Hostels
CREATE TABLE IF NOT EXISTS halls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hall_name VARCHAR(50) NOT NULL,
    hall_type ENUM('male','female','male_senior') NOT NULL,
    total_capacity INT DEFAULT 0
);

-- Rooms
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hall_id INT NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    floor ENUM('ground','first','second') NOT NULL,
    capacity INT DEFAULT 2,
    occupied INT DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (hall_id) REFERENCES halls(id)
);

-- Extension wing blocks
CREATE TABLE IF NOT EXISTS extension_blocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    block_name VARCHAR(5) NOT NULL,
    gender ENUM('male','female') NOT NULL,
    total_rooms INT DEFAULT 20,
    occupied_rooms INT DEFAULT 0
);

-- Student Applications
CREATE TABLE IF NOT EXISTS applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    reg_number VARCHAR(20) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    year_of_study INT NOT NULL,
    gender ENUM('male','female') NOT NULL,
    email VARCHAR(100) NOT NULL,
    special_needs TEXT,
    status ENUM('pending','allocated','not_allocated','waitlisted') DEFAULT 'pending',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- Allocations
CREATE TABLE IF NOT EXISTS allocations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    student_id INT NOT NULL,
    reg_number VARCHAR(20) NOT NULL,
    room_id INT,
    extension_block_id INT,
    room_number VARCHAR(20),
    hall_or_block VARCHAR(50),
    floor_level VARCHAR(20),
    allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    allocated_by INT,
    is_manual BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (application_id) REFERENCES applications(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- Invoices
CREATE TABLE IF NOT EXISTS invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    student_id INT NOT NULL,
    invoice_number VARCHAR(30) UNIQUE NOT NULL,
    amount DECIMAL(10,2) DEFAULT 180000.00,
    currency VARCHAR(10) DEFAULT 'MWK',
    status ENUM('unpaid','paid','partial') DEFAULT 'unpaid',
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE,
    FOREIGN KEY (application_id) REFERENCES applications(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- Payments / Receipts
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    student_id INT NOT NULL,
    receipt_number VARCHAR(30) UNIQUE NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_method ENUM('bank','mobile_money','cash') DEFAULT 'mobile_money',
    transaction_id VARCHAR(100),
    payslip_path VARCHAR(255),
    verified_by INT,
    status ENUM('pending','verified','rejected') DEFAULT 'pending',
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id),
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- Inquiries
CREATE TABLE IF NOT EXISTS inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    reg_number VARCHAR(20) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    has_special_needs BOOLEAN DEFAULT FALSE,
    special_need_type VARCHAR(100),
    status ENUM('open','in_progress','resolved') DEFAULT 'open',
    response TEXT,
    responded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP NULL,
    FOREIGN KEY (student_id) REFERENCES users(id)
);

-- Email Logs
CREATE TABLE IF NOT EXISTS email_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_email VARCHAR(100),
    subject VARCHAR(200),
    type ENUM('invoice','receipt','allocation','rejection','inquiry_response'),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('sent','failed') DEFAULT 'sent'
);

-- ========================
-- SEED DATA
-- ========================

-- Default Admin
INSERT INTO users (reg_number, full_name, email, password, role) VALUES
('ADMIN001', 'System Administrator', 'admin@must.ac.mw', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('OPR001', 'Hostel Operator', 'operator@must.ac.mw', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'operator');
-- Default password: password

-- Halls 1-4 Male, 5-7 Female, 8 Male Senior
INSERT INTO halls (hall_name, hall_type, total_capacity) VALUES
('Hall 1', 'male', 60), ('Hall 2', 'male', 60), ('Hall 3', 'male', 60), ('Hall 4', 'male', 60),
('Hall 5', 'female', 60), ('Hall 6', 'female', 60), ('Hall 7', 'female', 60),
('Hall 8 (Senior)', 'male_senior', 60);

-- Extension Blocks A-K Male, L-N Female
INSERT INTO extension_blocks (block_name, gender, total_rooms) VALUES
('A','male',20),('B','male',20),('C','male',20),('D','male',20),('E','male',20),
('F','male',20),('G','male',20),('H','male',20),('I','male',20),('J','male',20),('K','male',20),
('L','female',20),('M','female',20),('N','female',20);

-- Generate rooms for each hall (ground/first/second, 20 rooms each floor)
DELIMITER $$
CREATE PROCEDURE GenerateRooms()
BEGIN
    DECLARE h INT DEFAULT 1;
    DECLARE f INT DEFAULT 1;
    DECLARE r INT DEFAULT 1;
    DECLARE floors VARCHAR(50);
    WHILE h <= 8 DO
        SET f = 1;
        WHILE f <= 3 DO
            SET r = 1;
            WHILE r <= 10 DO
                SET floors = CASE f WHEN 1 THEN 'ground' WHEN 2 THEN 'first' ELSE 'second' END;
                INSERT INTO rooms (hall_id, room_number, floor, capacity, occupied)
                VALUES (h, CONCAT('H', h, '-', floors, '-', LPAD(r,2,'0')), floors, 2, 0);
                SET r = r + 1;
            END WHILE;
            SET f = f + 1;
        END WHILE;
        SET h = h + 1;
    END WHILE;
END$$
DELIMITER ;
CALL GenerateRooms();
DROP PROCEDURE GenerateRooms;
