# KRPG API Endpoints Reference

## Overview
This document provides a comprehensive reference of all API endpoints used by the KRPG Flutter application, including request/response formats and authentication requirements.

## Base Configuration
- **Base URL**: `http://10.0.2.2:8000/api` (Android Emulator)
- **Authentication**: Bearer Token (Sanctum)
- **Response Format**: Standardized Laravel API response

## Response Format
All API responses follow this structure:
```json
{
  "status": boolean,      // true for success, false for failure
  "message": string,      // Human-readable message
  "data": mixed           // Response payload (varies by endpoint)
}
```

---

## Authentication Endpoints

### 1. Login
- **Endpoint**: `POST /login`
- **Authentication**: None
- **Request Body**:
  ```json
  {
    "login": "string",     // Username or email
    "password": "string"
  }
  ```
- **Response**:
  ```json
  {
    "status": true,
    "message": "Login berhasil",
    "data": {
      "role": "coach|athlete|leader|admin",
      "token": "6|abc123..."
    }
  }
  ```

### 2. Register
- **Endpoint**: `POST /register`
- **Authentication**: None
- **Request Body**:
  ```json
  {
    "username": "string",
    "email": "string",
    "password": "string",
    "role": "coach|athlete|leader|admin"
  }
  ```
- **Response**:
  ```json
  {
    "status": true,
    "message": "Registration successful",
    "data": {
      "account": { ... },
      "profile": { ... }
    }
  }
  ```

### 3. Check Token
- **Endpoint**: `GET /check-token`
- **Authentication**: Bearer Token
- **Response**:
  ```json
  {
    "status": true,
    "message": "Token is valid",
    "data": {
      "role": "coach|athlete|leader|admin",
      "token": "6|abc123..."
    }
  }
  ```

### 4. Logout
- **Endpoint**: `POST /logout`
- **Authentication**: Bearer Token
- **Response**:
  ```json
  {
    "status": true,
    "message": "Logged out successfully",
    "data": null
  }
  ```

---

## Dashboard & Home

### 5. Home Dashboard
- **Endpoint**: `GET /home`
- **Authentication**: Bearer Token
- **Response**:
  ```json
  {
    "status": true,
    "message": "Dashboard data retrieved",
    "data": {
      "total_trainings": 15,
      "total_competitions": 8,
      "total_classrooms": 5,
      "total_athletes": 25,
      "recent_activities": [
        {
          "title": "Training Session Started",
          "description": "Coach started training session #123",
          "time": "2 hours ago"
        }
      ],
      "upcoming_trainings": [
        {
          "id": 1,
          "title": "Morning Training",
          "datetime": "2025-06-25 07:00:00",
          "status": "scheduled"
        }
      ]
    }
  }
  ```

---

## Profile Management

### 6. Get Profile Details
- **Endpoint**: `GET /profile`
- **Authentication**: Bearer Token
- **Response**:
  ```json
  {
    "status": true,
    "message": "Profile retrieved",
    "data": {
      "id_account": 1,
      "email": "coach@example.com",
      "username": "coach1",
      "role": "coach",
      "profile": {
        "id_profile": 1,
        "name": "John Doe",
        "birth_date": "1990-01-01",
        "gender": "M",
        "phone": "+628123456789",
        "address": "Jl. Example No. 123",
        "profile_picture": "https://example.com/avatar.jpg"
      }
    }
  }
  ```

### 7. Update Profile
- **Endpoint**: `PUT /profile`
- **Authentication**: Bearer Token
- **Request Body**:
  ```json
  {
    "name": "string",
    "phone_number": "string",
    "address": "string",
    "birth_date": "YYYY-MM-DD",
    "gender": "M|F"
  }
  ```

### 8. Upload Profile Picture
- **Endpoint**: `POST /profile/picture`
- **Authentication**: Bearer Token
- **Request**: Multipart form data
- **Response**:
  ```json
  {
    "status": true,
    "message": "Profile picture uploaded",
    "data": {
      "profile_picture": "https://example.com/new-avatar.jpg"
    }
  }
  ```

---

## Training Management

### 9. Get Trainings List
- **Endpoint**: `GET /training`
- **Authentication**: Bearer Token
- **Query Parameters**:
  - `search`: Search term
  - `status`: scheduled|ongoing|completed|cancelled
  - `phase`: Training phase ID
  - `page`: Page number
  - `limit`: Items per page
- **Response**:
  ```json
  {
    "status": true,
    "message": "Trainings retrieved",
    "data": {
      "data": [
        {
          "id_training": 1,
          "title": "Morning Training",
          "description": "Basic swimming techniques",
          "datetime": "2025-06-25 07:00:00",
          "start_time": "07:00:00",
          "end_time": "09:00:00",
          "status": "scheduled",
          "max_participants": 20,
          "current_participants": 15,
          "location": {
            "id_location": 1,
            "location_name": "Swimming Pool A",
            "address": "Jl. Pool No. 1"
          },
          "training_phase": {
            "id_training_phase": 1,
            "phase_name": "Basic Level",
            "description": "Fundamental swimming skills"
          }
        }
      ],
      "current_page": 1,
      "last_page": 5,
      "per_page": 10,
      "total": 50
    }
  }
  ```

### 10. Get Training Details
- **Endpoint**: `GET /training/{id}`
- **Authentication**: Bearer Token
- **Response**: Same as training item in list + additional details

### 11. Check Training Can Start
- **Endpoint**: `GET /training/{id}/can-start`
- **Authentication**: Bearer Token (Coach only)
- **Response**:
  ```json
  {
    "status": true,
    "message": "Training can be started",
    "data": {
      "can_start": true,
      "reason": "All conditions met",
      "participants_count": 15
    }
  }
  ```

### 12. Start Training
- **Endpoint**: `POST /training/{id}/start`
- **Authentication**: Bearer Token (Coach only)
- **Response**:
  ```json
  {
    "status": true,
    "message": "Training started successfully",
    "data": {
      "training_session": {
        "id_training_session": 1,
        "id_training": 1,
        "schedule_date": "2025-06-25",
        "start_time": "07:00:00",
        "status": "recording"
      }
    }
  }
  ```

### 13. Get Training Athletes
- **Endpoint**: `GET /training/{id}/athletes`
- **Authentication**: Bearer Token (Coach only)
- **Response**:
  ```json
  {
    "status": true,
    "message": "Athletes retrieved",
    "data": [
      {
        "id_profile": 1,
        "name": "Athlete Name",
        "status": "registered",
        "attendance_status": "present"
      }
    ]
  }
  ```

---

## Training Sessions

### 14. Mark Attendance
- **Endpoint**: `POST /training/sessions/{id}/attendance`
- **Authentication**: Bearer Token
- **Request Body**:
  ```json
  {
    "profile_id": 1,
    "status": "1|2|3",  // 1=Absent, 2=Present, 3=Late
    "note": "string"
  }
  ```

### 15. End Attendance
- **Endpoint**: `POST /training/sessions/{id}/end-attendance`
- **Authentication**: Bearer Token (Coach only)

### 16. Record Statistics
- **Endpoint**: `POST /training/sessions/{id}/statistics`
- **Authentication**: Bearer Token (Coach only)
- **Request Body**:
  ```json
  {
    "profile_id": 1,
    "stroke": "freestyle",
    "duration": "00:30:00",
    "distance": "1000m",
    "energy_system": "aerobic",
    "note": "Good performance"
  }
  ```

### 17. Get Statistics
- **Endpoint**: `GET /training/sessions/{id}/statistics`
- **Authentication**: Bearer Token

### 18. End Session
- **Endpoint**: `POST /training/sessions/{id}/end`
- **Authentication**: Bearer Token (Coach only)

---

## Competition Management

### 19. Get Competitions List
- **Endpoint**: `GET /competitions`
- **Authentication**: Bearer Token
- **Query Parameters**:
  - `search`: Search term
  - `status`: coming_soon|ongoing|finished|cancelled
  - `level`: local|regional|national|international
  - `page`: Page number
  - `limit`: Items per page
- **Response**:
  ```json
  {
    "status": true,
    "message": "Competitions retrieved",
    "data": {
      "data": [
        {
          "id_competition": 1,
          "competition_name": "Regional Championship",
          "competition_date": "2025-07-15",
          "start_time": "08:00:00",
          "end_time": "17:00:00",
          "competition_location": "Swimming Complex",
          "competition_level": "regional",
          "description": "Annual regional swimming championship",
          "status": "coming_soon",
          "max_participants": 100,
          "current_participants": 75,
          "start_register_time": "2025-06-01 00:00:00",
          "end_register_time": "2025-07-10 23:59:59"
        }
      ],
      "current_page": 1,
      "last_page": 3,
      "per_page": 10,
      "total": 25
    }
  }
  ```

### 20. Get Competition Stats
- **Endpoint**: `GET /competitions/stats`
- **Authentication**: Bearer Token
- **Response**:
  ```json
  {
    "status": true,
    "message": "Competition stats retrieved",
    "data": {
      "total_competitions": 25,
      "upcoming_competitions": 8,
      "ongoing_competitions": 2,
      "completed_competitions": 15
    }
  }
  ```

### 21. Get My Competitions
- **Endpoint**: `GET /competitions/my-competitions`
- **Authentication**: Bearer Token
- **Response**: List of competitions where user is registered

### 22. Get Competition Details
- **Endpoint**: `GET /competitions/{id}`
- **Authentication**: Bearer Token
- **Response**: Detailed competition information

### 23. Get Pending Approvals (Coach/Leader)
- **Endpoint**: `GET /competitions/pending-approvals`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Response**: List of pending competition registrations

### 24. Update Delegation Status
- **Endpoint**: `PUT /competitions/registrations/{registrationId}/status`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Request Body**:
  ```json
  {
    "status": "approved|rejected|withdrawn"
  }
  ```

### 25. Upload Certificate
- **Endpoint**: `POST /competitions/registrations/{registrationId}/certificate`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Request**: Multipart form data

### 26. Mark Result Done
- **Endpoint**: `PUT /competitions/registrations/{registrationId}/result`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Request Body**:
  ```json
  {
    "position": 1,
    "time_result": "00:01:30.45",
    "points": 100.0,
    "result_status": "completed",
    "result_type": "final",
    "category": "Men 100m Freestyle"
  }
  ```

---

## Classroom Management

### 27. Get Classrooms List
- **Endpoint**: `GET /classrooms`
- **Authentication**: Bearer Token
- **Query Parameters**:
  - `search`: Search term
  - `status`: active|inactive|full
  - `page`: Page number
  - `limit`: Items per page
- **Response**:
  ```json
  {
    "status": true,
    "message": "Classrooms retrieved",
    "data": {
      "data": [
        {
          "id_classrooms": 1,
          "classroom_name": "Advanced Class A",
          "description": "Advanced swimming techniques",
          "max_students": 15,
          "current_students": 12,
          "status": "active",
          "coach": {
            "id_account": 1,
            "name": "Coach Name",
            "email": "coach@example.com"
          }
        }
      ],
      "current_page": 1,
      "last_page": 2,
      "per_page": 10,
      "total": 15
    }
  }
  ```

### 28. Get Classroom Stats
- **Endpoint**: `GET /classrooms/stats`
- **Authentication**: Bearer Token
- **Response**:
  ```json
  {
    "status": true,
    "message": "Classroom stats retrieved",
    "data": {
      "total_classrooms": 15,
      "active_classrooms": 12,
      "full_classrooms": 3,
      "total_students": 180
    }
  }
  ```

### 29. Get My Classrooms
- **Endpoint**: `GET /classrooms/my-classrooms`
- **Authentication**: Bearer Token
- **Response**: List of classrooms where user is enrolled/teaching

### 30. Get Classroom Details
- **Endpoint**: `GET /classrooms/{id}`
- **Authentication**: Bearer Token
- **Response**: Detailed classroom information

### 31. Get Classroom Students
- **Endpoint**: `GET /classrooms/{id}/students`
- **Authentication**: Bearer Token
- **Response**: List of students in the classroom

### 32. Upload Student Invoice
- **Endpoint**: `POST /classrooms/students/{studentId}/invoice`
- **Authentication**: Bearer Token
- **Request**: Multipart form data

---

## Athletes Management

### 33. Get Athletes List (Coach/Leader)
- **Endpoint**: `GET /athletes`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Query Parameters**:
  - `search`: Search term
  - `classroom_id`: Filter by classroom
  - `page`: Page number
  - `limit`: Items per page
- **Response**:
  ```json
  {
    "status": true,
    "message": "Athletes retrieved",
    "data": {
      "data": [
        {
          "id_profile": 1,
          "name": "Athlete Name",
          "email": "athlete@example.com",
          "birth_date": "2005-01-01",
          "gender": "M",
          "phone": "+628123456789",
          "classroom": {
            "id_classrooms": 1,
            "classroom_name": "Advanced Class A"
          },
          "health_data": {
            "height": 170.0,
            "weight": 65.0,
            "blood_type": "O+"
          }
        }
      ],
      "current_page": 1,
      "last_page": 5,
      "per_page": 10,
      "total": 50
    }
  }
  ```

### 34. Get Athlete Stats (Coach/Leader)
- **Endpoint**: `GET /athletes/stats`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Response**:
  ```json
  {
    "status": true,
    "message": "Athlete stats retrieved",
    "data": {
      "total_athletes": 50,
      "active_athletes": 45,
      "male_athletes": 30,
      "female_athletes": 20
    }
  }
  ```

### 35. Get Athlete Details
- **Endpoint**: `GET /athletes/{athlete}`
- **Authentication**: Bearer Token
- **Response**: Detailed athlete information

### 36. Get Athlete Training History
- **Endpoint**: `GET /athletes/{athlete}/training-history`
- **Authentication**: Bearer Token
- **Response**: List of training sessions attended by athlete

### 37. Get Athlete Competition History
- **Endpoint**: `GET /athletes/{athlete}/competition-history`
- **Authentication**: Bearer Token
- **Response**: List of competitions participated by athlete

### 38. Upload Athlete Invoice
- **Endpoint**: `POST /athletes/{athleteId}/invoice`
- **Authentication**: Bearer Token
- **Request**: Multipart form data

### 39. Upload Competition Certificate (Coach/Leader)
- **Endpoint**: `POST /athletes/certificates`
- **Authentication**: Bearer Token (Coach/Leader only)
- **Request**: Multipart form data

---

## Membership & Payments

### 40. Get Membership Status
- **Endpoint**: `GET /membership/status`
- **Authentication**: Bearer Token (Athlete only)
- **Response**:
  ```json
  {
    "status": true,
    "message": "Membership status retrieved",
    "data": {
      "is_active": true,
      "expiry_date": "2025-12-31",
      "membership_type": "premium",
      "payment_status": "paid"
    }
  }
  ```

### 41. Upload Payment Evidence
- **Endpoint**: `POST /membership/upload-payment`
- **Authentication**: Bearer Token (Athlete only)
- **Request**: Multipart form data

### 42. Get Payment History
- **Endpoint**: `GET /membership/payment-history`
- **Authentication**: Bearer Token (Athlete only)
- **Response**:
  ```json
  {
    "status": true,
    "message": "Payment history retrieved",
    "data": [
      {
        "id_invoice": 1,
        "invoice_number": "INV-2025-001",
        "invoice_date": "2025-01-01",
        "due_date": "2025-01-31",
        "total_amount": 500000,
        "paid_amount": 500000,
        "status": "paid",
        "payment_method": "transfer",
        "payment_date": "2025-01-15 10:30:00"
      }
    ]
  }
  ```

---

## Error Responses

### Standard Error Format
```json
{
  "status": false,
  "message": "Error description",
  "data": null
}
```

### Common HTTP Status Codes
- `200`: Success
- `400`: Bad Request (validation errors)
- `401`: Unauthorized (invalid/missing token)
- `403`: Forbidden (insufficient permissions)
- `404`: Not Found
- `422`: Validation Error
- `500`: Internal Server Error

### Validation Error Response
```json
{
  "status": false,
  "message": "Validation failed",
  "data": {
    "errors": {
      "email": ["The email field is required."],
      "password": ["The password must be at least 6 characters."]
    }
  }
}
```

---

## Authentication Flow

1. **Login**: `POST /login` → Get token
2. **Store Token**: Save token locally
3. **API Calls**: Include `Authorization: Bearer {token}` header
4. **Token Validation**: Call `GET /check-token` on app startup
5. **Logout**: `POST /logout` → Clear local token

## Role-Based Access

- **Athlete**: Can access training, competitions, profile, membership
- **Coach**: Can access all athlete features + training management, classroom management
- **Leader**: Can access all coach features + competition management
- **Admin**: Full access to all features

## Pagination

Most list endpoints support pagination with these query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10)

Response includes pagination metadata:
```json
{
  "current_page": 1,
  "last_page": 5,
  "per_page": 10,
  "total": 50
}
```

## Search & Filtering

Many endpoints support search and filtering:
- `search`: Text search across relevant fields
- `status`: Filter by status (varies by endpoint)
- `date_from`/`date_to`: Date range filtering
- Role-specific filters (e.g., `classroom_id` for athletes) 