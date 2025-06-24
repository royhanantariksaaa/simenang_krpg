# 🏊‍♂️ Training Start Validation System

## 🔍 **How Training Start Validation Works**

The KRPG mobile app has a comprehensive validation system that determines whether a training can be started. Here's how it works:

### **Frontend Flow (Flutter)**

1. **User Action**: Coach clicks "Start Session" button in `TrainingDetailScreen`
2. **Validation Check**: Calls `controller.canStartTraining(trainingId)`
3. **API Request**: Sends GET request to `/api/training/{id}/can-start`
4. **Response Handling**: Checks `canStart['can_start']` boolean
5. **UI Feedback**: Shows success/error messages based on validation result

### **Backend Validation (Laravel)**

The `canStart()` method in `APITrainingController` performs multiple checks:

#### **1. Authentication & Authorization**
```php
// Validate user is coach and get profile
[$user, $coachProfile] = $this->getAuthUserWithProfile();
$this->validateAuthAndRole(['coach'], 'Only coaches can start training');

// Check if coach is registered for this training
$isCoachRegistered = RegisteredParticipantTraining::where('id_training', $training->id_training)
    ->where('id_coach', $coachProfile->id_profile)
    ->where('id_profile', $coachProfile->id_profile)
    ->where('delete_YN', 'N')
    ->exists();
```

**Checks:**
- ✅ User must be authenticated
- ✅ User must have 'coach' role
- ✅ Coach must be registered for this specific training
- ✅ Registration must not be deleted (`delete_YN = 'N'`)

#### **2. Time Window Validation**
```php
// Check time window (15 minutes before to 30 minutes after)
$now = Carbon::now('Asia/Jakarta');
$trainingTime = Carbon::parse($datetimeStr, 'Asia/Jakarta');
$timeDiff = $now->diffInMinutes($trainingTime, false);
$canStart = $timeDiff >= -15 && $timeDiff <= 30;
```

**Time Rules:**
- ✅ **15 minutes before** training time: Can start
- ✅ **Up to 30 minutes after** training time: Can start
- ❌ **Outside this window**: Cannot start

**Example:**
- Training scheduled for 14:00
- Can start from 13:45 to 14:30
- Before 13:45 or after 14:30: Cannot start

#### **3. Active Session Check**
```php
// Check for existing active session
$activeSession = TrainingSession::where('id_training', $training->id_training)
    ->whereIn('status', ['attendance', 'recording'])
    ->first();

$canStart = $canStart && !$activeSession;
```

**Session Status Check:**
- ❌ **If active session exists** with status 'attendance' or 'recording': Cannot start
- ✅ **If no active session**: Can start
- ✅ **If only completed/cancelled sessions**: Can start

### **Response Data Structure**

The API returns detailed information about why a training can/cannot start:

```json
{
  "success": true,
  "data": {
    "can_start": true/false,
    "time_until_start": -5, // minutes (negative = past, positive = future)
    "has_active_session": true/false,
    "active_session": { /* session data if exists */ }
  }
}
```

### **Frontend Implementation**

```dart
void _startTrainingSession() async {
  try {
    final controller = context.read<TrainingController>();
    
    // Check if training can be started
    final canStart = await controller.canStartTraining(widget.training.idTraining);
    
    if (canStart != null && canStart['can_start'] == true) {
      // Start the training
      final result = await controller.startTraining(widget.training.idTraining);
      
      if (result != null) {
        // Success - navigate to session screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Training session started successfully!')),
        );
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Training cannot be started at this time')),
      );
    }
  } catch (e) {
    // Handle errors
  }
}
```

## 🚫 **Reasons Why Training Cannot Start**

### **1. Authorization Issues**
- ❌ User not authenticated
- ❌ User is not a coach
- ❌ Coach not registered for this training
- ❌ Coach registration is deleted

### **2. Time Window Issues**
- ❌ Too early (more than 15 minutes before)
- ❌ Too late (more than 30 minutes after)
- ❌ Training time not properly configured

### **3. Session Conflicts**
- ❌ Active session already exists
- ❌ Session in 'attendance' status
- ❌ Session in 'recording' status

### **4. Technical Issues**
- ❌ Database connection problems
- ❌ API server errors
- ❌ Network connectivity issues

## ✅ **When Training Can Start**

### **Perfect Conditions:**
- ✅ Coach is authenticated and authorized
- ✅ Coach is registered for the training
- ✅ Current time is within 15 minutes before to 30 minutes after training time
- ✅ No active session exists for this training
- ✅ All system services are operational

### **Example Scenarios:**

**Scenario 1: Normal Start**
- Training: 14:00
- Current time: 13:50
- Coach: Registered and authorized
- Active sessions: None
- **Result: ✅ Can start**

**Scenario 2: Late Start**
- Training: 14:00
- Current time: 14:15
- Coach: Registered and authorized
- Active sessions: None
- **Result: ✅ Can start (within 30-minute window)**

**Scenario 3: Too Early**
- Training: 14:00
- Current time: 13:30
- Coach: Registered and authorized
- Active sessions: None
- **Result: ❌ Cannot start (too early)**

**Scenario 4: Active Session**
- Training: 14:00
- Current time: 14:10
- Coach: Registered and authorized
- Active sessions: One in 'attendance' status
- **Result: ❌ Cannot start (active session exists)**

## 🔧 **Configuration Options**

### **Time Window Settings**
The time window can be adjusted in the backend:
- **Before training**: 15 minutes (configurable)
- **After training**: 30 minutes (configurable)

### **Session Status Types**
- `attendance`: Session is in attendance phase
- `recording`: Session is in statistics recording phase
- `completed`: Session is finished
- `cancelled`: Session was cancelled

## 🎯 **User Experience**

### **For Coaches:**
- Clear feedback on why training cannot start
- Real-time validation before attempting to start
- Automatic time window enforcement
- Prevention of duplicate sessions

### **For Athletes:**
- Consistent training start times
- No confusion about session status
- Reliable attendance tracking
- Proper session lifecycle management

This validation system ensures that training sessions are started properly, at the right time, by authorized coaches, without conflicts, providing a smooth and reliable experience for the KRPG swimming club. 