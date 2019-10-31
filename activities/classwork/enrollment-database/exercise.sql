/*
 SECTION: Group exercises
 DESCRIPTION: Write a valid SQL query to solve each problem.
 */


-- A) Get all the unique department names.
SELECT DISTINCT department FROM course;
-- B) Get the top 10 female students (first_name, last_name, age, gpa) with the best GPA scores and order by age (asc).
SELECT
	first_name AS "first name",
	last_name  AS "last name",
	age  AS "Age",
	gpa AS "GPA"
FROM
	student
WHERE
	gender = 'female'
ORDER BY
	gpa DESC,
	age ASC,
	first_name ASC,
	last_name ASC
LIMIT 10
;
-- C) Count the number of male/female students that are at least 25 years old.
SELECT
	gender,
	count(gender) AS "Count"
FROM
	student
WHERE
	age >= 25
GROUP BY gender
;
-- D) Get the number of male/female students that were accepted
SELECT
    s.gender AS "Student Gender",
    count(s.gender)
FROM
	student s INNER JOIN enrollment e ON s.id = e.student_id
WHERE
    e.approved = 1
GROUP BY
    s.gender
;
-- E) Get the min, average, and max GPA of the accepted male students that are less than 20 years old.
SELECT
    MIN(s.gpa),
    MAX(s.gpa),
    AVG(s.gpa)
FROM
    student s INNER JOIN enrollment e ON s.id = e.student_id
WHERE
    e.approved = 1
    AND s.gender = 'male' AND s.age<= 20
;

SELECT DISTINCT
    *
FROM
    (
        SELECT
            gender,
            MIN(student.gpa),
            MAX(student.gpa),
            AVG(student.gpa)
        FROM student INNER JOIN enrollment e on student.id = e.student_id
        WHERE e.approved = 1 AND student.age<= 20
        GROUP BY gender
        ) gender_aggregate
WHERE gender_aggregate.gender = 'male'

-- F) Get the number of enrollments to courses that take longer than 2 years to finalize.
SELECT
	count(*)
FROM
    course c INNER JOIN enrollment e on c.id = e.course_id
WHERE
 c.years > 2 AND e.approved = 1  ;


-- G) Get the number of male/female student that will take a course from the 'Statistics' department.
SELECT
    gender,
    *
FROM
    student s
    INNER JOIN enrollment e on s.id = e.student_id
    INNER JOIN course c on e.course_id = c.id
WHERE
    lower(c.department) LIKE 'stati%'
GROUP BY gender
;


/*
 SECTION: Individual exercises
 DESCRIPTION: Write a valid SQL query to solve each problem.
 */

-- A) Count the number of courses per department
SELECT
    count(name),
    department
FROM course GROUP BY department
;
-- B) How many male/female students were accepted?
SELECT
    gender,
    count(s.id)
FROM
    student s INNER JOIN enrollment e ON s.id = e.student_id
WHERE
      e.approved = 1
GROUP BY
         gender
;
-- C) How many students were accepted per course?
SELECT
    count(*),
    name
FROM
    student s
    INNER JOIN enrollment e on s.id = e.student_id
    INNER JOIN course c on e.course_id = c.id
WHERE e.approved = 1
GROUP BY name



-- D) What's the average age and gpa per course?
SELECT
    AVG(s.age),
    AVG(s.gpa),
    name
FROM
    student s
    INNER JOIN enrollment e on s.id = e.student_id
    INNER JOIN course c on e.course_id = c.id
GROUP BY name



-- E) Get the average number of years the enrolled (approved) female student will study.
SELECT
    AVG(c.years)
FROM
    student s
    INNER JOIN enrollment e on s.id = e.student_id
    INNER JOIN course c on e.course_id = c.id
WHERE e.approved = 1 AND s.gender = 'female'
GROUP BY gender
