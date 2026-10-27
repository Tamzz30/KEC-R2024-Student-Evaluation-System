USE kec_academic;

START TRANSACTION;

-- 1. Add 30 sample students across departments.
INSERT IGNORE INTO students
(roll_no, student_name, department, current_semester)
VALUES
('25ITR201','ADITHYA R','IT',3),
('25ITR202','AKSHAY K','IT',3),
('25ITR203','ANANYA S','CSE',3),
('25ITR204','ARJUN M','CSE',3),
('25ITR205','ASHWINI P','IT',3),
('25ITR206','BHARATH R','ECE',3),
('25ITR207','CHANDRU S','EEE',3),
('25ITR208','DHARANI V','IT',3),
('25ITR209','DIVYA M','CSE',3),
('25ITR210','GOKUL K','IT',3),
('25ITR211','HARISH N','ECE',3),
('25ITR212','JANANI R','IT',3),
('25ITR213','KARTHIK S','EEE',3),
('25ITR214','KEERTHANA P','CSE',3),
('25ITR215','KISHORE V','IT',3),
('25ITR216','MADHUMITHA S','ECE',3),
('25ITR217','MANOJ K','IT',3),
('25ITR218','MONISHA R','CSE',3),
('25ITR219','NAVEEN P','EEE',3),
('25ITR220','NITHYA S','IT',3),
('25ITR221','PRAVEEN M','CSE',3),
('25ITR222','PRIYA V','IT',3),
('25ITR223','RAHUL S','ECE',3),
('25ITR224','RESHMA K','IT',3),
('25ITR225','SANTHOSH R','EEE',3),
('25ITR226','SATHYA P','CSE',3),
('25ITR227','SHREYA M','IT',3),
('25ITR228','SURYA K','IT',3),
('25ITR229','VIGNESH R','ECE',3),
('25ITR230','YUVAN S','CSE',3);

-- 2. Add sample semester-3 courses.
-- Existing course records are preserved by INSERT IGNORE.
INSERT IGNORE INTO courses
(course_code, title, credits, course_type)
VALUES
('25ITR31','Data Structures',4,'THEORY'),
('25ITR32','Database Management Systems',4,'THEORY'),
('25ITR33','Object Oriented Programming Lab',2,'PRACTICAL'),
('25ITR34','Operating Systems',3,'THEORY'),
('25ITR35','Professional Skills Lab',2,'PRACTICAL');

-- 3. Enroll each of the 30 sample students in the five courses.
-- Attendance is varied to make reports useful for testing.
INSERT INTO enrollments
(roll_no, course_code, semester, classes_held,
 classes_attended, medical_condonation_approved)
SELECT
    s.roll_no,
    c.course_code,
    3,
    40,
    24 + MOD(CAST(SUBSTRING(s.roll_no, 6) AS UNSIGNED) + c.credits, 17),
    0
FROM students s
CROSS JOIN courses c
WHERE CAST(SUBSTRING(s.roll_no, 6) AS UNSIGNED) BETWEEN 201 AND 230
  AND c.course_code IN ('25ITR31','25ITR32','25ITR33','25ITR34','25ITR35')
  AND NOT EXISTS (
      SELECT 1
      FROM enrollments e
      WHERE e.roll_no = s.roll_no
        AND e.course_code = c.course_code
        AND e.semester = 3
  );

-- 4. Add sample CIA, coursework and ESE marks.
-- Marks are synthetic test data, not real student results.
INSERT INTO assessment_marks
(roll_no, course_code, cia1, cia2, coursework, ese_marks, ese_absent)
SELECT
    e.roll_no,
    e.course_code,
    MOD(CAST(SUBSTRING(e.roll_no, 6) AS UNSIGNED) * 7 + c.credits * 3, 41) + 60,
    MOD(CAST(SUBSTRING(e.roll_no, 6) AS UNSIGNED) * 11 + c.credits, 36) + 65,
    MOD(CAST(SUBSTRING(e.roll_no, 6) AS UNSIGNED) * 13 + c.credits, 31) + 70,
    MOD(CAST(SUBSTRING(e.roll_no, 6) AS UNSIGNED) * 17 + c.credits, 41) + 60,
    0
FROM enrollments e
JOIN courses c ON c.course_code = e.course_code
WHERE CAST(SUBSTRING(e.roll_no, 6) AS UNSIGNED) BETWEEN 201 AND 230
  AND e.semester = 3
  AND e.course_code IN ('25ITR31','25ITR32','25ITR33','25ITR34','25ITR35')
ON DUPLICATE KEY UPDATE
    cia1 = VALUES(cia1),
    cia2 = VALUES(cia2),
    coursework = VALUES(coursework),
    ese_marks = VALUES(ese_marks),
    ese_absent = VALUES(ese_absent);

COMMIT;

-- 5. Verify the inserted data.
SELECT department, COUNT(*) AS student_count
FROM students
WHERE CAST(SUBSTRING(roll_no, 6) AS UNSIGNED) BETWEEN 201 AND 230
GROUP BY department
ORDER BY department;

SELECT COUNT(*) AS sample_students
FROM students
WHERE CAST(SUBSTRING(roll_no, 6) AS UNSIGNED) BETWEEN 201 AND 230;

SELECT COUNT(*) AS sample_enrollments
FROM enrollments
WHERE CAST(SUBSTRING(roll_no, 6) AS UNSIGNED) BETWEEN 201 AND 230
  AND semester = 3;

SELECT COUNT(*) AS sample_mark_records
FROM assessment_marks
WHERE CAST(SUBSTRING(roll_no, 6) AS UNSIGNED) BETWEEN 201 AND 230;
