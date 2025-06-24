# KRPG API Models Reference

This document provides a comprehensive reference of all models used by the KRPG Laravel API and their implementation status in the Flutter application.

## Table of Contents
1. [Authentication & User Management](#authentication--user-management)
2. [Training System](#training-system)
3. [Competition System](#competition-system)
4. [Classroom System](#classroom-system)
5. [Financial System](#financial-system)
6. [Health & Location](#health--location)
7. [Implementation Status](#implementation-status)

---

## Authentication & User Management

### Account Model
**Laravel Model:** `App\Models\Account`  
**Flutter Model:** `lib/models/user_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_account | int | Primary key | Yes |
| email | string | User email for login | Yes |
| password | string | Encrypted password | Yes |
| role | enum | user/athlete/coach/leader/admin | Yes |
| status | enum | active/inactive/suspended | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |
| create_date | datetime | Account creation date | Yes |
| update_date | datetime | Last update date | No |

### ProfileManagement Model
**Laravel Model:** `App\Models\ProfileManagement`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_profile | int | Primary key | Yes |
| id_account | int | Foreign key to Account | Yes |
| name | string | Full name | Yes |
| birth_date | date | Date of birth | Yes |
| gender | enum | M/F | Yes |
| phone | string | Phone number | No |
| address | text | Full address | No |
| profile_picture | string | URL to profile image | No |
| id_classrooms | int | Foreign key to Classrooms | No |
| status | enum | active/inactive | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

---

## Training System

### Trainings Model
**Laravel Model:** `App\Models\Trainings`  
**Flutter Model:** `lib/models/training_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_training | int | Primary key | Yes |
| title | string | Training title | Yes |
| description | text | Training description | No |
| datetime | datetime | Training date and time | Yes |
| start_time | time | Start time | Yes |
| end_time | time | End time | Yes |
| id_location | int | Foreign key to Location | No |
| id_training_phase | int | Foreign key to TrainingPhase | No |
| max_participants | int | Maximum participants | No |
| status | enum | scheduled/ongoing/completed/cancelled | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### TrainingSession Model
**Laravel Model:** `App\Models\TrainingSession`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_training_session | int | Primary key | Yes |
| id_training | int | Foreign key to Trainings | Yes |
| schedule_date | date | Session date | Yes |
| start_time | time | Session start time | Yes |
| end_time | time | Session end time | Yes |
| started_at | datetime | Actual start time | No |
| ended_at | datetime | Actual end time | No |
| status | enum | attendance/recording/completed | Yes |
| create_date | datetime | Creation date | Yes |
| create_id | int | Created by user ID | Yes |

### Attendances Model
**Laravel Model:** `App\Models\Attendances`  
**Flutter Model:** `lib/models/attendance_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_attendance | int | Primary key | Yes |
| id_training_session | int | Foreign key to TrainingSession | Yes |
| id_profile | int | Foreign key to ProfileManagement | Yes |
| status | char | 1=Absent, 2=Present, 3=Late | Yes |
| date_time | datetime | Attendance timestamp | Yes |
| note | text | Additional notes | No |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### StatisticTrainings Model
**Laravel Model:** `App\Models\StatisticTrainings`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_statistic | int | Primary key | Yes |
| id_attendance | int | Foreign key to Attendances | Yes |
| id_profile | int | Foreign key to ProfileManagement | Yes |
| stroke | string | Swimming stroke type | Yes |
| duration | string | Training duration | No |
| distance | string | Distance covered | No |
| energy_system | enum | Energy system type | Yes |
| note | text | Additional notes | No |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### TrainingPhase Model
**Laravel Model:** `App\Models\TrainingPhase`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_training_phase | int | Primary key | Yes |
| phase_name | string | Phase name | Yes |
| description | text | Phase description | No |
| duration_weeks | int | Duration in weeks | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### RegisteredParticipantTraining Model
**Laravel Model:** `App\Models\RegisteredParticipantTraining`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_registered | int | Primary key | Yes |
| id_training | int | Foreign key to Trainings | Yes |
| id_profile | int | Foreign key to ProfileManagement (athlete) | Yes |
| id_coach | int | Foreign key to ProfileManagement (coach) | Yes |
| id_classroom | int | Foreign key to Classrooms | No |
| registration_date | datetime | Registration timestamp | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

---

## Competition System

### Competition Model
**Laravel Model:** `App\Models\Competition`  
**Flutter Model:** `lib/models/competition_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_competition | int | Primary key | Yes |
| competition_name | string | Competition name | Yes |
| competition_date | date | Competition date | Yes |
| start_time | time | Start time | Yes |
| end_time | time | End time | Yes |
| competition_location | string | Location/venue | Yes |
| competition_level | enum | local/regional/national/international | Yes |
| description | text | Competition description | No |
| start_register_time | datetime | Registration open | Yes |
| end_register_time | datetime | Registration close | Yes |
| max_participants | int | Maximum participants | No |
| status | enum | coming_soon/ongoing/finished/cancelled | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### RegisteredCompetitionParticipant Model
**Laravel Model:** `App\Models\RegisteredCompetitionParticipant`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_registered_participant_competition | int | Primary key | Yes |
| id_competition | int | Foreign key to Competition | Yes |
| id_profile | int | Foreign key to ProfileManagement | Yes |
| status | enum | pending/approved/rejected/withdrawn | Yes |
| note | text | Registration notes | No |
| create_date | datetime | Registration date | Yes |
| create_id | int | Created by user ID | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### CompetitionResult Model
**Laravel Model:** `App\Models\CompetitionResult`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_result | int | Primary key | Yes |
| id_registered_participant_competition | int | Foreign key | Yes |
| position | int | Final position | No |
| time_result | string | Time result | No |
| points | decimal | Points earned | No |
| result_status | enum | DNS/DNF/DQ/completed | Yes |
| result_type | enum | preliminary/final | Yes |
| category | string | Competition category | No |
| notes | text | Additional notes | No |
| create_date | datetime | Result entry date | Yes |
| create_id | int | Created by user ID | Yes |

### CompetitionCertificate Model
**Laravel Model:** `App\Models\CompetitionCertificate`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_certificate | int | Primary key | Yes |
| id_registered_participant_competition | int | Foreign key | Yes |
| certificate_type | enum | participation/achievement/winner | Yes |
| certificate_path | string | URL to certificate file | Yes |
| notes | text | Additional notes | No |
| upload_date | datetime | Upload timestamp | Yes |
| uploaded_by | int | Uploader profile ID | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

---

## Classroom System

### Classrooms Model
**Laravel Model:** `App\Models\Classrooms`  
**Flutter Model:** `lib/models/classroom_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_classrooms | int | Primary key | Yes |
| classroom_name | string | Classroom name | Yes |
| description | text | Classroom description | No |
| id_coach | int | Foreign key to Account (coach) | Yes |
| max_students | int | Maximum students | No |
| current_students | int | Current student count | Yes |
| status | enum | active/inactive/full | Yes |
| create_date | datetime | Creation date | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

---

## Financial System

### Invoice Model
**Laravel Model:** `App\Models\Invoice`  
**Flutter Model:** `lib/models/invoice_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_invoice | int | Primary key | Yes |
| id_account | int | Foreign key to Account | Yes |
| invoice_number | string | Unique invoice number | Yes |
| invoice_date | date | Invoice date | Yes |
| due_date | date | Payment due date | Yes |
| total_amount | decimal | Total amount | Yes |
| paid_amount | decimal | Amount paid | Yes |
| status | enum | unpaid/paid/partial/overdue | Yes |
| payment_method | enum | cash/transfer/card | No |
| payment_date | datetime | Payment timestamp | No |
| notes | text | Additional notes | No |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

---

## Health & Location

### HealthDatas Model
**Laravel Model:** `App\Models\HealthDatas`  
**Flutter Model:** `lib/models/health_data_model.dart` ✅

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_health_data | int | Primary key | Yes |
| id_profile | int | Foreign key to ProfileManagement | Yes |
| height | decimal | Height in cm | Yes |
| weight | decimal | Weight in kg | Yes |
| blood_type | string | Blood type | No |
| medical_conditions | text | Medical conditions | No |
| allergies | text | Known allergies | No |
| emergency_contact | string | Emergency contact info | Yes |
| measurement_date | date | Measurement date | Yes |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

### Location Model
**Laravel Model:** `App\Models\Location`  
**Flutter Model:** `To be created` ❌

| Field | Type | Description | Required |
|-------|------|-------------|----------|
| id_location | int | Primary key | Yes |
| location_name | string | Location name | Yes |
| address | text | Full address | Yes |
| latitude | decimal | GPS latitude | No |
| longitude | decimal | GPS longitude | No |
| description | text | Location description | No |
| delete_YN | char | Soft delete flag (Y/N) | Yes |

---

## Implementation Status

### ✅ Already Implemented (8 models)
1. **user_model.dart** - Basic user authentication
2. **athlete_model.dart** - Athlete-specific user extension
3. **coach_model.dart** - Coach-specific user extension
4. **training_model.dart** - Training information
5. **competition_model.dart** - Competition information
6. **classroom_model.dart** - Classroom management
7. **invoice_model.dart** - Payment and invoicing
8. **attendance_model.dart** - Training attendance
9. **health_data_model.dart** - Athlete health information

### ❌ To Be Implemented (9 models)
1. **profile_management_model.dart** - Extended user profile
2. **training_session_model.dart** - Individual training sessions
3. **training_statistics_model.dart** - Training performance data
4. **training_phase_model.dart** - Training phases
5. **registered_participant_training_model.dart** - Training registrations
6. **registered_competition_participant_model.dart** - Competition registrations
7. **competition_result_model.dart** - Competition results
8. **competition_certificate_model.dart** - Competition certificates
9. **location_model.dart** - Location information

---

## API Endpoints Using These Models

### Authentication
- `POST /api/login` - Uses Account
- `POST /api/register` - Uses Account, ProfileManagement
- `GET /api/profile` - Uses Account, ProfileManagement

### Training
- `GET /api/training` - Uses Trainings, Location, TrainingPhase
- `POST /api/training/{id}/start` - Uses TrainingSession
- `POST /api/sessions/{id}/attendance` - Uses Attendances
- `POST /api/sessions/{id}/statistics` - Uses StatisticTrainings

### Competition
- `GET /api/competitions` - Uses Competition
- `POST /api/competitions/{id}/register` - Uses RegisteredCompetitionParticipant
- `POST /api/registrations/{id}/certificate` - Uses CompetitionCertificate
- `PUT /api/registrations/{id}/result` - Uses CompetitionResult

### Classroom
- `GET /api/classrooms` - Uses Classrooms
- `GET /api/classrooms/{id}/students` - Uses ProfileManagement

### Financial
- `GET /api/membership/status` - Uses Invoice
- `POST /api/membership/upload-payment` - Uses Invoice

---

## Notes for Implementation

1. **Soft Delete**: All models use `delete_YN` field where 'Y' means deleted, 'N' means active
2. **Timestamps**: Most models include `create_date` and some have `update_date`
3. **Foreign Keys**: Pay attention to relationships between models
4. **Enums**: Many fields use specific enum values that should be validated
5. **Status Fields**: Most models have status fields that control visibility and behavior

This reference should be updated as new models are implemented or API changes are made. 