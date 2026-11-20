CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

CREATE TABLE IF NOT EXISTS student_performance (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    roll_no VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    maths INT NOT NULL,
    physics INT NOT NULL,
    chemistry INT NOT NULL,
    english INT NOT NULL,
    computer_science INT NOT NULL,
    total_classes INT NOT NULL,
    classes_attended INT NOT NULL,
    CONSTRAINT chk_marks CHECK (
        maths BETWEEN 0 AND 100 AND physics BETWEEN 0 AND 100
        AND chemistry BETWEEN 0 AND 100 AND english BETWEEN 0 AND 100
        AND computer_science BETWEEN 0 AND 100
    ),
    CONSTRAINT chk_attendance CHECK (
        total_classes > 0 AND classes_attended BETWEEN 0 AND total_classes
    )
);

INSERT INTO student_performance
(roll_no, name, maths, physics, chemistry, english, computer_science, total_classes, classes_attended)
VALUES
('STU001', 'Arjun Reddy', 92, 88, 95, 90, 97, 120, 114),
('STU002', 'Sravani Devi', 78, 82, 75, 80, 85, 120, 105),
('STU003', 'Kiran Kumar', 65, 58, 62, 70, 68, 120, 96),
('STU004', 'Divya Teja', 45, 52, 48, 60, 55, 120, 92),
('STU005', 'Mahesh Babu', 38, 55, 60, 65, 58, 120, 100),
('STU006', 'Lakshmi Priya', 85, 90, 88, 92, 94, 120, 78),
('STU007', 'Rohit Varma', 72, 68, 74, 66, 80, 120, 110),
('STU008', 'Anitha Rao', 55, 42, 47, 58, 61, 120, 91),
('STU009', 'Ganesh', 84, 79, 86, 81, 90, 120, 108),
('STU010', 'Harsha Vardhan', 30, 35, 42, 48, 40, 120, 70)
ON DUPLICATE KEY UPDATE roll_no = VALUES(roll_no);

CREATE OR REPLACE VIEW student_report AS
SELECT roll_no, name,
       maths + physics + chemistry + english + computer_science AS total,
       ROUND((maths + physics + chemistry + english + computer_science) / 5.0, 2) AS average,
       CASE
         WHEN (maths + physics + chemistry + english + computer_science) / 5.0 >= 90 THEN 'A+'
         WHEN (maths + physics + chemistry + english + computer_science) / 5.0 >= 80 THEN 'A'
         WHEN (maths + physics + chemistry + english + computer_science) / 5.0 >= 70 THEN 'B'
         WHEN (maths + physics + chemistry + english + computer_science) / 5.0 >= 60 THEN 'C'
         WHEN (maths + physics + chemistry + english + computer_science) / 5.0 >= 50 THEN 'D'
         WHEN (maths + physics + chemistry + english + computer_science) / 5.0 >= 40 THEN 'E'
         ELSE 'F'
       END AS grade,
       ROUND(classes_attended * 100.0 / total_classes, 2) AS attendance_pct,
       CASE WHEN classes_attended * 100.0 / total_classes >= 75
            THEN 'Eligible' ELSE 'Not Eligible' END AS eligibility,
       CASE WHEN maths >= 40 AND physics >= 40 AND chemistry >= 40
                  AND english >= 40 AND computer_science >= 40
                  AND classes_attended * 100.0 / total_classes >= 75
            THEN 'PASS' ELSE 'FAIL' END AS final_result
FROM student_performance;

-- Useful queries
SELECT * FROM student_performance;
SELECT * FROM student_report ORDER BY roll_no;
SELECT * FROM student_report WHERE final_result = 'PASS' ORDER BY total DESC;
SELECT roll_no, name, attendance_pct FROM student_report WHERE attendance_pct < 75;
SELECT COUNT(*) AS total_students,
       SUM(final_result = 'PASS') AS passed,
       SUM(final_result = 'FAIL') AS failed,
       ROUND(AVG(average), 2) AS class_average
FROM student_report;
