# RaceDay API Endpoint Plan

## Purpose
This document defines the planned REST API for RaceDay before implementation in Part 2. Role enforcement is performed at API level.

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/auth/register` | Create a participant account | Public | firstName, lastName, email, password, phone | 201 Created with user profile |
| POST | `/api/auth/login` | Authenticate a user | Public | email, password | 200 OK with JWT/token and role |
| GET | `/api/users/me` | Get the authenticated user's profile | Participant / Organiser | None | 200 OK with profile |
| PUT | `/api/users/me` | Update the authenticated user's profile | Participant / Organiser | firstName, lastName, phone | 200 OK with updated profile |
| GET | `/api/events` | Browse upcoming/open events | Public | None | 200 OK with event list |
| GET | `/api/events/{eventId}` | View event details | Public | None | 200 OK with event and categories |
| POST | `/api/events` | Create an event | Organiser | eventName, description, eventDate, startTime, location, distanceKm, status | 201 Created |
| PUT | `/api/events/{eventId}` | Edit an event owned by organiser | Organiser | Event fields to update | 200 OK |
| DELETE | `/api/events/{eventId}` | Delete an event owned by organiser | Organiser | None | 204 No Content |
| GET | `/api/events/mine` | View events created by current organiser | Organiser | None | 200 OK with event list |
| GET | `/api/events/{eventId}/categories` | List categories for an event | Public | None | 200 OK with category list |
| POST | `/api/events/{eventId}/categories` | Add a category to an event | Organiser | categoryName, distanceKm, entryFee, maxParticipants | 201 Created |
| PUT | `/api/categories/{categoryId}` | Edit an event category | Organiser | categoryName, distanceKm, entryFee, maxParticipants | 200 OK |
| DELETE | `/api/categories/{categoryId}` | Delete an event category | Organiser | None | 204 No Content |
| POST | `/api/enrolments` | Enter an event by selecting a category | Participant | categoryId | 201 Created with enrolment |
| GET | `/api/enrolments/me` | View participant's own enrolments | Participant | None | 200 OK with enrolment list |
| GET | `/api/events/{eventId}/enrolments` | View all enrolments for an event | Organiser | None | 200 OK with enrolment list |
| GET | `/api/enrolments/{enrolmentId}` | View one enrolment | Participant (own) / Organiser (managed event) | None | 200 OK |
| DELETE | `/api/enrolments/{enrolmentId}` | Cancel an enrolment | Participant (own) | None | 204 No Content |
| POST | `/api/results` | Capture a participant result | Organiser | enrolmentId, finishPosition, finishTime, resultStatus | 201 Created |
| PUT | `/api/results/{resultId}` | Update a participant result | Organiser | finishPosition, finishTime, resultStatus | 200 OK |
| GET | `/api/results/me` | View personal result history | Participant | None | 200 OK with results |
| GET | `/api/events/{eventId}/results` | View results for an event | Organiser | None | 200 OK with results |
| GET | `/api/results/{resultId}` | View a specific result | Participant (own) / Organiser | None | 200 OK |
| GET | `/api/events/{eventId}/weather` | Retrieve event weather information | Public | None | 200 OK with weather data |
| GET | `/api/events/{eventId}/route` | Retrieve route information prepared for the event | Public | None | 200 OK with route details |

## Role Rules

### Public
Unauthenticated users can browse event information and categories and can register/login.

### Participant
Participants can:
- manage their own profile;
- browse events;
- enrol in an event category;
- view/cancel their own enrolments;
- view their own results.

A participant must not create, edit, or delete events/categories or capture another participant's results.

### Organiser
Organisers can:
- manage their own events;
- manage categories belonging to their events;
- view enrolments for their events;
- capture and update results for participants in their events.

An organiser must not modify another organiser's events.

## API Design Notes

- Authentication is planned around JWT bearer authentication in Part 2.
- IDs are represented as integers in the database and route parameters.
- Successful creation returns HTTP 201.
- Successful updates return HTTP 200.
- Successful deletion returns HTTP 204.
- Invalid requests return HTTP 400.
- Unauthenticated requests to protected endpoints return HTTP 401.
- Authenticated users without permission return HTTP 403.
- Missing resources return HTTP 404.
- Server/database failures return HTTP 500.
