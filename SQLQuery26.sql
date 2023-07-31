--1. 

SELECT Building
FROM Departments
GROUP BY Building
HAVING SUM(Financing) > 100000;

--2.

SELECT Groups.Name
FROM Groups
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Groups.Year = 5
AND Departments.Name = 'Software Development'
AND Groups.Id IN (
  SELECT GroupsLectures.GroupId 
  FROM GroupsLectures
  JOIN Lectures ON GroupsLectures.LectureId = Lectures.Id 
  WHERE DATEPART(week, Lectures.Date) = 1
  GROUP BY GroupsLectures.GroupId
  HAVING COUNT(*) > 10
);

--3.

SELECT Groups.Name
FROM Groups
JOIN GroupsStudents ON Groups.Id = GroupsStudents.GroupId
JOIN Students ON GroupsStudents.StudentId = Students.Id
WHERE (SELECT AVG(Rating) FROM Students WHERE GroupsStudents.GroupId = Groups.Id) > (SELECT Rating FROM Groups WHERE Name = 'LAW401');

--4.

SELECT Teachers.Name, Teachers.Surname
FROM Teachers
WHERE ((SELECT AVG(Salary) FROM Teachers WHERE IsProfessor = 1) < Salary)
AND IsProfessor = 1;

--5.

SELECT Groups.Name
FROM Groups
JOIN GroupsCurators ON Groups.Id = GroupsCurators.GroupId
GROUP BY Groups.Name
HAVING COUNT(*) > 1;

--6.

SELECT g.Name
FROM Groups g
INNER JOIN (SELECT DepartmentId, MIN(Rating) AS MinRating
  FROM Groups
  INNER JOIN GroupsStudents ON Groups.Id = GroupsStudents.GroupId
  INNER JOIN Students ON GroupsStudents.StudentId = Students.Id
  WHERE Year = 5
  GROUP BY DepartmentId) minRatings ON g.DepartmentId = minRatings.DepartmentId
INNER JOIN (SELECT AVG(Rating) AS AvgRating, GroupId
  FROM GroupsStudents
  INNER JOIN Students ON GroupsStudents.StudentId = Students.Id
  GROUP BY GroupId) avgRatings ON g.Id = avgRatings.GroupId
WHERE avgRatings.AvgRating < minRatings.MinRating;

--7.

SELECT Faculties.Name
FROM Faculties
JOIN Departments ON Faculties.Id = Departments.FacultyId
GROUP BY Faculties.Name
HAVING SUM(Departments.Financing) > (
  SELECT SUM(Departments.Financing)
  FROM Departments
  JOIN Faculties ON Departments.FacultyId = Faculties.Id
  WHERE Faculties.Name = 'Faculty of Law and Politics'
);

--8.

SELECT TOP 1 Subjects.Name, Teachers.Name, Teachers.Surname
FROM Lectures
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
JOIN Teachers ON Lectures.TeacherId = Teachers.Id
GROUP BY Subjects.Name, Teachers.Name, Teachers.Surname
ORDER BY COUNT(*) DESC;

--9.

SELECT Subjects.Name
FROM Lectures
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
GROUP BY Subjects.Name
HAVING COUNT(*) = (
  SELECT TOP 1 COUNT(*) 
  FROM Lectures
  GROUP BY SubjectId
  ORDER BY COUNT(*) ASC
);

--10.

SELECT 
COUNT(DISTINCT Students.Id) AS [Кол-во студентов],
COUNT(DISTINCT Lectures.SubjectId) AS [Кол-во читаемых дисциплин]
FROM Departments 
JOIN Groups ON Departments.Id = Groups.DepartmentId
JOIN GroupsStudents ON Groups.Id = GroupsStudents.GroupId
JOIN Students ON GroupsStudents.StudentId = Students.Id
JOIN GroupsLectures ON Groups.Id = GroupsLectures.GroupId
JOIN Lectures ON GroupsLectures.LectureId = Lectures.Id
JOIN Subjects ON Lectures.SubjectId = Subjects.Id
WHERE Departments.Name = 'Department of Economics';