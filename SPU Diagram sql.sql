CREATE TABLE `Student` (
  `StudentID` int PRIMARY KEY,
  `FirstName` varchar(255),
  `LastName` varchar(255),
  `Email` varchar(255),
  `Major` varchar(255),
  `Year` varchar(255)
);

CREATE TABLE `Department` (
  `DepartmentID` int PRIMARY KEY,
  `DepartmentName` varchar(255),
  `OfficeLocation` varchar(255)
);

CREATE TABLE `Instructor` (
  `InstructorID` int PRIMARY KEY,
  `FirstName` varchar(255),
  `LastName` varchar(255),
  `Email` varchar(255),
  `DepartmentID` int
);

CREATE TABLE `Course` (
  `CourseID` int PRIMARY KEY,
  `Title` varchar(255),
  `Credits` int,
  `DepartmentID` int
);

CREATE TABLE `Enrollment` (
  `EnrollmentID` int PRIMARY KEY,
  `StudentID` int,
  `CourseID` int,
  `Semester` varchar(255),
  `Grade` varchar(255)
);

CREATE TABLE `TeachingAssignment` (
  `AssignmentID` int PRIMARY KEY,
  `InstructorID` int,
  `CourseID` int,
  `Semester` varchar(255)
);

ALTER TABLE `Enrollment` ADD FOREIGN KEY (`StudentID`) REFERENCES `Student` (`StudentID`);

ALTER TABLE `Enrollment` ADD FOREIGN KEY (`CourseID`) REFERENCES `Course` (`CourseID`);

ALTER TABLE `Course` ADD FOREIGN KEY (`DepartmentID`) REFERENCES `Department` (`DepartmentID`);

ALTER TABLE `Instructor` ADD FOREIGN KEY (`DepartmentID`) REFERENCES `Department` (`DepartmentID`);

ALTER TABLE `TeachingAssignment` ADD FOREIGN KEY (`InstructorID`) REFERENCES `Instructor` (`InstructorID`);

ALTER TABLE `TeachingAssignment` ADD FOREIGN KEY (`CourseID`) REFERENCES `Course` (`CourseID`);
