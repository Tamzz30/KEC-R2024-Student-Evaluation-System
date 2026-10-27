CREATE DATABASE IF NOT EXISTS kec_academic
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kec_academic;

CREATE TABLE IF NOT EXISTS students (
    roll_no VARCHAR(12) PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    department VARCHAR(20) NOT NULL,
    current_semester TINYINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_student_semester
        CHECK (current_semester BETWEEN 1 AND 8)
);

CREATE TABLE IF NOT EXISTS courses (
    course_code VARCHAR(20) PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    credits TINYINT UNSIGNED NOT NULL,
    course_type ENUM('THEORY','PRACTICAL','EMBEDDED') NOT NULL,
    CONSTRAINT chk_course_credits
        CHECK (credits BETWEEN 1 AND 10)
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    roll_no VARCHAR(12) NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    semester TINYINT UNSIGNED NOT NULL,
    classes_held INT UNSIGNED NOT NULL DEFAULT 0,
    classes_attended INT UNSIGNED NOT NULL DEFAULT 0,
    medical_condonation_approved BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE KEY uq_enrollment (roll_no, course_code, semester),
    UNIQUE KEY uq_enrollment_marks (roll_no, course_code),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (roll_no) REFERENCES students(roll_no)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_code) REFERENCES courses(course_code)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_enrollment_semester
        CHECK (semester BETWEEN 1 AND 8),
    CONSTRAINT chk_attendance
        CHECK (classes_attended <= classes_held)
);

CREATE TABLE IF NOT EXISTS assessment_marks (
    roll_no VARCHAR(12) NOT NULL,
    course_code VARCHAR(20) NOT NULL,
    cia1 TINYINT UNSIGNED NULL,
    cia2 TINYINT UNSIGNED NULL,
    coursework TINYINT UNSIGNED NULL,
    ese_marks TINYINT UNSIGNED NULL,
    ese_absent BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (roll_no, course_code),
    CONSTRAINT fk_marks_enrollment
        FOREIGN KEY (roll_no, course_code)
        REFERENCES enrollments(roll_no, course_code)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_cia1 CHECK (cia1 IS NULL OR cia1 <= 100),
    CONSTRAINT chk_cia2 CHECK (cia2 IS NULL OR cia2 <= 100),
    CONSTRAINT chk_coursework CHECK (coursework IS NULL OR coursework <= 100),
    CONSTRAINT chk_ese CHECK (ese_marks IS NULL OR ese_marks <= 100),
    CONSTRAINT chk_absent_marks CHECK (NOT ese_absent OR ese_marks IS NULL)
);
