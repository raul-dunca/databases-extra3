CREATE TABLE CakeTypes
(
CTid int Primary key,
CTName varchar(50),
CTDesc varchar(50)
)


CREATE TABLE Chefs
(
CEid int Primary key,
CEName varchar(50),
CEGender varchar(50),
CEDOB DATE
)


CREATE TABLE Cakes
(
Cid int PRimary key,
CName varchar(50),
CShape varchar(50),
CWeight int,
CPrice int,
CType int references CakeTypes(CTid)

)


CREATE TABLE Specialize
(
Cid int references Cakes(Cid),
CEid int References Chefs(CEid),
Primary key(Cid,CEid)
)

CREATE TABLE Orders
(
Oid int ,
Cid int References Cakes(Cid),
Primary key(Oid,Cid),
NrofPieces int
)

--2)

CREATE OR ALTER PROCEDURE AddOrder(@Oid int, @Cid int,@P int)
AS
	IF EXISTS (SELECT * FROM Orders WHERE Oid=@Oid and Cid=@Cid)
		BEGIN 
				UPDATE Orders
				SET NrofPieces=@P
				WHERE Oid=@Oid and Cid=@Cid
		END
	ELSE
	
		BEGIN
			
			IF EXISTS (SELECT * FROM Cakes WHERE Cid=@Cid) 
				BEGIN
					INSERT INTO Orders(Oid,Cid,NrofPieces)
					VALUES(@Oid,@Cid,@P)
				END
			ELSE
				BEGIN 
					RAISERROR('Cakes ID not in Cake Table ',11,1)
				END
		END

GO

EXEC AddOrder 3,1,2

--4)
Create OR ALTER FUNCTION AllCakesChefs()
RETURNS TABLE
AS
 RETURN
 SELECT CEName
 FROM Chefs
 WHERE CEid IN(
 SELECT S.CEid FROM Cakes C JOIN Specialize S ON C.Cid=S.Cid
 JOIN Chefs CE ON Ce.CEid=S.CEid
 GROUP BY S.CEid
 HAVING COUNT(S.Cid)=(SELECT COUNT(Cid) FROM Cakes)
 )
GO




SELECT *
FROM AllCakesChefs()

INSERT INTO CakeTypes(CTid,CTName,CTDesc)
VALUES(2,'CarrtoCake','carrot')

INSERT INTO Cakes(Cid,CName,CPrice,CShape,CType,CWeight)
VALUES(3,'CarotoPopyto',250,'round',2,11)

INSERT INTO Chefs(CEid,CEName,CEGender,CEDOB)
VALUES(3,'Tundy','female','05-02-2001')

INSERT INTO Specialize(Cid,CEid)
VALUES(3,1)
SELECT * FROM Cakes
SELECT * FROM Chefs
SELECT * FROM Specialize


SELECT * FROM CakeTypes
SELECT * FROM Cakes
SELECT * FROM Orders

EXEC AddOrder 1 ,1 ,220