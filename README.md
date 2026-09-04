# RaceDay — Part 1: System Planning and Database

## 1. Project Overview

RaceDay is a full-stack event management platform designed for the South African road running, walking and cycling community.

The system allows event organisers to create and manage sporting events, categories, participant enrolments and results. Participants can create accounts, browse upcoming events, enter events, view their enrolments and track their personal performance history.

Part 1 focuses on planning the system before application code is written. It contains the ERD, API endpoint plan and SQL Server database script.

## 2. User Roles

### Organiser
An Organiser can:
- create, edit and delete events;
- manage categories for their events;
- view event enrolments;
- capture and update participant results.

### Participant
A Participant can:
- create an account and log in;
- manage their profile;
- browse events;
- select a category and enrol;
- view their own enrolments;
- view their own performance results.

Role-based access will be enforced at API level in Part 2 and reflected in the MVC interface in Part 3.

## 3. Part 1 Documents

The `/docs` folder contains:

- `RaceDay_ERD.png` — Entity Relationship Diagram.
- `RaceDay_API_Endpoint_Plan.md` — planned REST API endpoints.
- `RaceDay_Database.sql` — SQL Server schema and seed data.

## 4. Database Design

The database contains the following main entities:

- Users
- Events
- Categories
- Enrolments
- Results
- EventWeather

The Users table stores both Organisers and Participants. An Organiser creates Events. Each Event has Categories. Participants enter Categories through Enrolments, and completed enrolments can have Results. EventWeather stores weather information associated with an event/date.

## 5. Running the SQL Script

1. Open SQL Server Management Studio (SSMS).
2. Connect to a SQL Server instance.
3. Open `docs/RaceDay_Database.sql`.
4. Execute the complete script on a test/clean SQL Server environment.
5. The script creates `RaceDayDB`, creates all tables, inserts sample data and runs verification queries.
6. Confirm that all tables contain the expected sample records.

> The demonstration database uses placeholder password hashes because Part 1 is database planning and not the implementation of authentication. Real password hashing will be implemented in Part 2.

## 6. API Planning

The API plan is designed to closely guide the Part 2 C# REST API implementation. It includes authentication, profile management, events, categories, enrolments, results, weather and route information.

## 7. GitHub Actions / CI

The repository contains:

`.github/workflows/validate-docs.yml`

The workflow validates that the required `/docs` files exist and performs basic structural checks on the SQL and API plan.

### Successful CI/CD Build Screenshot

Insert your actual screenshot of the green GitHub Actions build here before submission.

`[INSERT SCREENSHOT HERE]`

## 8. Video Presentation

Unlisted YouTube video:

`[INSERT YOUR UNLISTED YOUTUBE LINK HERE]`

The video should demonstrate:
- the ERD and design decisions;
- the API endpoint plan;
- the SQL script;
- execution of the SQL script in SSMS;
- verification of the seeded records;
- explanation of the relationship between the ERD, API plan and database.

## 9. AI Use Disclosure

AI tools were used during the planning and development process for assistance with structuring ideas, reviewing requirements, generating draft documentation/code, and proofreading. The submitted work was reviewed and adapted by the student, who remains responsible for understanding, testing and explaining the final work.

## 10. Part 1 Commit Requirement

At least 20 meaningful commits should be made for Part 1. Each commit should represent genuine progress, such as adding or revising the ERD, API plan, SQL schema, sample data, README, workflow or validation.

Do not create artificial commits solely to increase the commit count.

## 11. Project Structure

```text
RaceDay/
├── docs/
│   ├── RaceDay_ERD.png
│   ├── RaceDay_API_Endpoint_Plan.md
│   └── RaceDay_Database.sql
├── .github/
│   └── workflows/
│       └── validate-docs.yml
└── README.md
```
