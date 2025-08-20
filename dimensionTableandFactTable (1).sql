CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourStrong@Password1';

drop table red_bus;
drop TABLE DimRoute;
drop TABLE DimPassenger;
drop TABLE DimPayment;
drop TABLE DimBus;
DROP TABLE FactBooking;

CREATE TABLE red_bus (
    First_Name       VARCHAR(100),
    Last_Name        VARCHAR(100),
    Age              VARCHAR(10),
    City_From        VARCHAR(100),
    [City_To]        VARCHAR(100),
    Bus_Type         VARCHAR(50),
    Seat_Type        VARCHAR(50),
    Booking_Type     VARCHAR(50),
    Payment_Method   VARCHAR(50),
    Ticket_Fare      VARCHAR(20)
);

select * from red_bus;


-- DimRoute table
CREATE TABLE DimRoute (
    RouteID     INT NOT NULL,
    City_From   VARCHAR(100),
    City_To     VARCHAR(100),
    CONSTRAINT PK_DimRoute PRIMARY KEY NONCLUSTERED (RouteID) NOT ENFORCED
);


-- DimBus table
CREATE TABLE DimBus (
    BusID       INT  NOT NULL,
    Bus_Type    VARCHAR(50),
    Seat_Type   VARCHAR(50),
    CONSTRAINT PK_DimBus PRIMARY KEY NONCLUSTERED (BusID) NOT ENFORCED
);


-- DimPayment table
CREATE TABLE DimPayment (
    PaymentID       INT NOT NULL,
    Payment_Method  VARCHAR(50),
    Booking_Type    VARCHAR(50),
    Ticket_Fare     INT,
    CONSTRAINT PK_DimPayment PRIMARY KEY NONCLUSTERED (PaymentID) NOT ENFORCED
);

CREATE TABLE  DimPassenger (
    Passenger_ID INT NOT NULL,  -- Surrogate Key
    First_Name NVARCHAR(50),
    Last_Name NVARCHAR(50),
    Age INT,
    CONSTRAINT PK_DimPass PRIMARY KEY NONCLUSTERED (Passenger_ID) NOT ENFORCED
);


CREATE TABLE FactBooking (
    BookingID    INT  NOT NULL,  -- no IDENTITY
    PassengerID  INT,
    RouteID      INT,
    BusID        INT,
    PaymentID    INT,
    CONSTRAINT PK_fact PRIMARY KEY NONCLUSTERED (BookingID) NOT ENFORCED
);


select * from FactBooking;
select * from DimBus;
select * from DimPassenger;
select * from DimRoute;
select * from DimPayment;


SELECT COUNT(*) AS Distinct_Passenger_Count
FROM (
    SELECT DISTINCT First_Name, Last_Name, Age
    FROM DimPassenger
) AS DistinctPassengers;


--  1. Top 5 Passengers with Most Bookings

SELECT TOP 5 p.First_Name + ' ' + p.Last_Name AS PassengerName, COUNT(*) AS TotalBookings
FROM FactBooking f
JOIN DimPassenger p ON f.PassengerID = p.Passenger_ID
GROUP BY p.First_Name, p.Last_Name
ORDER BY TotalBookings DESC;


-- 2. Total Revenue Generated from All Bookings

SELECT SUM(pm.Ticket_Fare) AS TotalRevenue
FROM FactBooking f
JOIN DimPayment pm ON f.PaymentID = pm.PaymentID;

--  3. Number of Bookings per City Route
SELECT r.City_From, r.City_To, COUNT(*) AS TotalBookings
FROM FactBooking f
JOIN DimRoute r ON f.RouteID = r.RouteID
GROUP BY r.City_From, r.City_To
ORDER BY TotalBookings DESC;

-- 4. Most Preferred Bus Type
SELECT TOP 1 b.Bus_Type, COUNT(*) AS TotalBookings
FROM FactBooking f
JOIN DimBus b ON f.BusID = b.BusID
GROUP BY b.Bus_Type
ORDER BY TotalBookings DESC;


-- 5. Average Age of Passengers by Route
SELECT r.City_From, r.City_To, AVG(p.Age) AS AvgAge
FROM FactBooking f
JOIN DimPassenger p ON f.PassengerID = p.Passenger_ID
JOIN DimRoute r ON f.RouteID = r.RouteID
GROUP BY r.City_From, r.City_To;


-- 6. Count of Payment Methods Used

SELECT Payment_Method, COUNT(*) AS UsageCount
FROM FactBooking f
JOIN DimPayment pm ON f.PaymentID = pm.PaymentID
GROUP BY Payment_Method
ORDER BY UsageCount DESC;


-- 7. Booking Count by Seat Type

SELECT b.Seat_Type, COUNT(*) AS TotalBookings
FROM FactBooking f
JOIN DimBus b ON f.BusID = b.BusID
GROUP BY b.Seat_Type
ORDER BY TotalBookings DESC;


-- 8. Total Bookings by Age Group

SELECT 
    CASE 
        WHEN p.Age BETWEEN 0 AND 17 THEN 'Under 18'
        WHEN p.Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN p.Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN p.Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS AgeGroup,
    COUNT(*) AS TotalBookings
FROM FactBooking f
JOIN DimPassenger p ON f.PassengerID = p.Passenger_ID
GROUP BY 
    CASE 
        WHEN p.Age BETWEEN 0 AND 17 THEN 'Under 18'
        WHEN p.Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN p.Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN p.Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END
ORDER BY TotalBookings DESC;


-- 9. Route Generating Highest Revenue

SELECT TOP 1 r.City_From, r.City_To, SUM(pm.Ticket_Fare) AS TotalRevenue
FROM FactBooking f
JOIN DimRoute r ON f.RouteID = r.RouteID
JOIN DimPayment pm ON f.PaymentID = pm.PaymentID
GROUP BY r.City_From, r.City_To
ORDER BY TotalRevenue DESC;


-- 10. Payment Methods Used by Seniors (>60)

SELECT pay.Payment_Method, COUNT(*) AS CountUsed
FROM FactBooking f
JOIN DimPassenger p ON f.PassengerID = p.Passenger_ID
JOIN DimPayment pay ON f.PaymentID = pay.PaymentID
WHERE p.Age > 60
GROUP BY pay.Payment_Method;
