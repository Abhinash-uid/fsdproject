# Student Performance & Attendance Report

A Java web application based on the supplied project report. It uses Java 17, Jakarta Servlets, Apache Tomcat 10.1, MySQL and JDBC.

## Features
- Enter student roll number, name, five subject marks and attendance.
- Calculate total, average, grade and attendance percentage.
- Eligibility requires attendance of at least 75%.
- PASS requires every subject mark to be at least 40 AND attendance of at least 75%.
- MySQL persistence with add, view, search, update and delete operations (JDBC DAO).
- A separate console CRUD application is included.

## Requirements
- JDK 17+
- Maven 3.8+
- MySQL 8+
- Apache Tomcat 10.1+

## 1. Create the database
Run `database/student_db.sql` in MySQL Workbench. It creates `student_db`, the `student_performance` table, sample rows and a report view.

## 2. Configure database credentials
Set environment variables before starting Tomcat:

Windows PowerShell:
```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/student_db"
$env:DB_USER="root"
$env:DB_PASSWORD="your_mysql_password"
```

macOS/Linux:
```bash
export DB_URL="jdbc:mysql://localhost:3306/student_db"
export DB_USER="root"
export DB_PASSWORD="your_mysql_password"
```

Defaults are `jdbc:mysql://localhost:3306/student_db`, `root`, and an empty password. Prefer environment variables over committing credentials.

## 3. Build the web application
From this repository directory:
```bash
mvn clean package
```
This creates `target/student-performance.war`.

## 4. Deploy to Tomcat
Copy `target/student-performance.war` into Tomcat's `webapps/` directory, start Tomcat, then open:
`http://localhost:8080/student-performance/`

## 5. Run the console CRUD application
Compile/run through Maven:
```bash
mvn -q -DskipTests package
mvn -q exec:java -Dexec.mainClass="com.studentreport.cli.StudentApp"
```
The console app uses the same database environment variables.

## Project structure
```text
src/main/java/com/studentreport/model/Student.java
src/main/java/com/studentreport/servlet/StudentReportServlet.java
src/main/java/com/studentreport/dao/StudentDAO.java
src/main/java/com/studentreport/db/DBConnection.java
src/main/java/com/studentreport/cli/StudentApp.java
src/main/webapp/index.html
src/main/webapp/css/style.css
src/main/webapp/WEB-INF/web.xml
database/student_db.sql
```

## Grade scale
A+ >= 90, A >= 80, B >= 70, C >= 60, D >= 50, E >= 40, otherwise F. Grade is based on the average. PASS/FAIL is independently determined by the subject-wise 40-mark rule and 75% attendance rule.
