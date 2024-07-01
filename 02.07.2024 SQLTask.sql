Create Database EducationDB
Use EducationDB

Create Table Academies(
Id Int Identity Primary Key,
Name Nvarchar (50)
)

Create Table Groups(
Id Int Identity Primary Key,
Name Nvarchar (50),
IsDeleted bit,
AcademyId Int Foreign Key References Academies(Id)
)

Create Table Students(
Id Int Identity Primary Key,
Name Nvarchar (50),
Surname Nvarchar (60),
Age Int,
Adulthood bit,
GroupId Int Foreign Key References Groups(Id)
)

Create Table DeletedStudents  (
Id Int Identity Primary Key,
Name Nvarchar (50),
Surname Nvarchar (60),
GroupId Int
)

Create Table DeletedGroups  (
Id Int Identity Primary Key,
Name Nvarchar (50),
AcademyId Int
)

Create View VW_GetAllInfoFrom_Academy 
As
Select * 
From Academies

Create View VW_GetAllInfoFrom_Group
As
Select * 
From Groups

Create View VW_GetAllInfoFrom_Student 
As
Select * 
From Students

Select * From VW_GetAllInfoFrom_Academy 
Select * From VW_GetAllInfoFrom_Student
Select * From VW_GetAllInfoFrom_Group


Create Procedure USP_Get_Group_By_Name @name Nvarchar (50)
As
Select * From VW_GetAllInfoFrom_Group
Where Name = @name

Exec USP_Get_Group_By_Name 'PB201'

Create Procedure USP_Get_Student_Greatter_Than @age Int
As
Select * From VW_GetAllInfoFrom_Student 
Where Age > @age

Exec USP_Get_Student_Greatter_Than 19

Create Procedure USP_Get_Student_Less_Than @age Int
As
Select * From VW_GetAllInfoFrom_Student 
Where Age < @age

Exec USP_Get_Student_Less_Than 19

Create Trigger Add_DeletedStudents on Students
After Delete
As
Begin
Insert Into DeletedStudents (Name, Surname, GroupId)
Select Name, Surname, GroupId
From deleted
End

Delete From Students 
Where Id = 4

--Create Trigger Make_True_Isdeleted on Groups
--Instead Of Delete
--As
--Begin
--Update Groups 
--Set IsDeleted = 1
--End

--DROP TRIGGER Make_True_Isdeleted; Sehvlik etmisdim, asagida duzeltdim.


CREATE TRIGGER Make_True_Isdeleted
ON Groups
INSTEAD OF DELETE
AS
BEGIN
UPDATE Groups
SET IsDeleted = 1
FROM Groups
INNER JOIN deleted ON Groups.Id = deleted.Id;
END;

Delete From Groups 
Where Id = 3

CREATE TRIGGER Make_TrueFalse_By_Age
ON Students
AFTER INSERT
AS
BEGIN
    UPDATE Students
    SET Adulthood = CASE WHEN INSERTED.Age >= 18 THEN 1 ELSE 0 END
    FROM Students
    INNER JOIN INSERTED ON Students.Id = INSERTED.Id;
END;


Create Trigger Change_True_False on Students
After Update
As
Begin
UPDATE Students
    SET Adulthood = CASE WHEN INSERTED.Age >= 18 THEN 1 ELSE 0 END
    FROM Students
    INNER JOIN INSERTED ON Students.Id = INSERTED.Id;
End

CREATE FUNCTION UF_GetStudentsById (@id INT)
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM Students
    WHERE GroupId = @id
)

SELECT *
FROM UF_GetStudentsById(1)

CREATE FUNCTION UF_GetGroupsById (@id INT)
RETURNS TABLE
AS
RETURN (
    SELECT *
    FROM Groups
    WHERE AcademyId = @id
)

Select * 
From UF_GetGroupsById (2)


Select * From Students
Select * From Groups
Select * From Academies
Select * From DeletedStudents

Insert Into Academies
Values ('CodeAcademy'),
('Master School')

Insert Into Groups
Values ('PB201',0,1),
('PB202',0,1),
('Masters',0,2),
('MasterNo1',0,2)

Insert Into Students
Values ('Ilaha','Hasanova',28,1,1),
('Aghalar','Aghalarli',29,1,1),
('Ali','Aliyev',17,0,2),
('Vali','Valiyev',20,1,2),
('Aygun','Hasanova',23,1,3),
('Ayten','Haciyeva',16,0,3),
('Zakir','Bayramli',25,1,4),
('Inci','Rzayeva',30,1,4)

