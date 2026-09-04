/*
 RaceDay - Part 1 Database Script
 SQL Server / SSMS
*/

IF DB_ID('RaceDayDB') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDayDB;
END;
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(120) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Users_Role CHECK (Role IN ('Organiser','Participant')),
    Phone NVARCHAR(20) NULL,
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSDATETIME()
);

CREATE TABLE Events (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId INT NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500) NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    DistanceKm DECIMAL(6,2) NOT NULL
        CONSTRAINT CK_Events_Distance CHECK (DistanceKm > 0),
    Status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Events_Status DEFAULT 'Upcoming'
        CONSTRAINT CK_Events_Status CHECK (Status IN ('Upcoming','Open','Closed','Completed','Cancelled')),
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Events_CreatedAt DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserId) REFERENCES Users(UserId)
);

CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(6,2) NOT NULL
        CONSTRAINT CK_Categories_Distance CHECK (DistanceKm > 0),
    EntryFee DECIMAL(10,2) NOT NULL
        CONSTRAINT CK_Categories_EntryFee CHECK (EntryFee >= 0),
    MaxParticipants INT NULL
        CONSTRAINT CK_Categories_MaxParticipants CHECK (MaxParticipants IS NULL OR MaxParticipants > 0),
    CONSTRAINT UQ_Categories_Event_Name UNIQUE (EventId, CategoryName),
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventId) REFERENCES Events(EventId) ON DELETE CASCADE
);

CREATE TABLE Enrolments (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL CONSTRAINT DF_Enrolments_Date DEFAULT SYSDATETIME(),
    Status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Enrolments_Status DEFAULT 'Confirmed'
        CONSTRAINT CK_Enrolments_Status CHECK (Status IN ('Pending','Confirmed','Cancelled')),
    RaceNumber INT NULL,
    CONSTRAINT UQ_Enrolments_Participant_Category UNIQUE (ParticipantId, CategoryId),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantId) REFERENCES Users(UserId),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);

CREATE TABLE Results (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL UNIQUE,
    FinishPosition INT NULL
        CONSTRAINT CK_Results_Position CHECK (FinishPosition IS NULL OR FinishPosition > 0),
    FinishTime TIME NULL,
    ResultStatus NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Results_Status DEFAULT 'Finished'
        CONSTRAINT CK_Results_Status CHECK (ResultStatus IN ('Finished','DNF','DNS','Disqualified')),
    RecordedAt DATETIME2 NOT NULL CONSTRAINT DF_Results_RecordedAt DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES Enrolments(EnrolmentId) ON DELETE CASCADE
);

CREATE TABLE EventWeather (
    WeatherId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    WeatherDate DATE NOT NULL,
    TemperatureC DECIMAL(5,2) NULL,
    WeatherCondition NVARCHAR(100) NULL,
    WindSpeedKmh DECIMAL(6,2) NULL,
    SourceName NVARCHAR(100) NULL,
    CONSTRAINT UQ_EventWeather_Event_Date UNIQUE (EventId, WeatherDate),
    CONSTRAINT FK_EventWeather_Event FOREIGN KEY (EventId) REFERENCES Events(EventId) ON DELETE CASCADE
);
GO

-- Seed users: 2 organisers and 2 participants
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role, Phone)
VALUES
('Thabo','Mokoena','thabo.organiser@raceday.co.za','HASH_DEMO_001','Organiser','0821112233'),
('Lerato','Naidoo','lerato.organiser@raceday.co.za','HASH_DEMO_002','Organiser','0832223344'),
('Sipho','Dlamini','sipho.participant@raceday.co.za','HASH_DEMO_003','Participant','0843334455'),
('Amahle','Nkosi','amahle.participant@raceday.co.za','HASH_DEMO_004','Participant','0854445566');

INSERT INTO Events
(OrganiserId, EventName, Description, EventDate, StartTime, Location, DistanceKm, Status)
VALUES
(1,'Johannesburg Spring Run','A road running event for the Johannesburg community.','2026-10-11','06:30','Johannesburg CBD',21.10,'Open'),
(1,'Soweto Community Walk','A community-focused walking event through Soweto.','2026-11-08','07:00','Soweto',10.00,'Open'),
(2,'Pretoria Cycle Challenge','A road cycling challenge for recreational and competitive cyclists.','2026-12-06','06:00','Pretoria',60.00,'Upcoming');

INSERT INTO Categories (EventId, CategoryName, DistanceKm, EntryFee, MaxParticipants)
VALUES
(1,'Half Marathon',21.10,250.00,1000),
(1,'10 km Run',10.00,150.00,1500),
(1,'5 km Fun Run',5.00,80.00,1000),
(2,'10 km Walk',10.00,100.00,1200),
(2,'5 km Family Walk',5.00,60.00,800),
(3,'60 km Road Cycle',60.00,350.00,1000),
(3,'30 km Social Cycle',30.00,220.00,700);

INSERT INTO Enrolments (ParticipantId, CategoryId, RaceNumber, Status)
VALUES
(3,1,101,'Confirmed'),
(3,4,202,'Confirmed'),
(4,2,102,'Confirmed'),
(4,7,304,'Confirmed');

INSERT INTO Results (EnrolmentId, FinishPosition, FinishTime, ResultStatus)
VALUES
(1,45,'01:58:32','Finished'),
(3,128,'00:59:44','Finished');

INSERT INTO EventWeather
(EventId, WeatherDate, TemperatureC, WeatherCondition, WindSpeedKmh, SourceName)
VALUES
(1,'2026-10-11',18.50,'Partly cloudy',12.00,'Demo Weather Feed'),
(2,'2026-11-08',21.00,'Sunny',9.00,'Demo Weather Feed'),
(3,'2026-12-06',20.00,'Clear',14.00,'Demo Weather Feed');
GO

-- Verification queries for SSMS demonstration
SELECT * FROM Users;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM Enrolments;
SELECT * FROM Results;
SELECT * FROM EventWeather;
GO
