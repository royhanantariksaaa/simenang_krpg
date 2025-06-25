# Flutter Training Flow Test Runner
# This script runs the complete Flutter integration tests for training flow

Write-Host "🚀 Flutter Training Flow Test Runner" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Parse command line arguments
param(
    [switch]$Setup,
    [switch]$CoachOnly,
    [switch]$AthleteOnly,
    [switch]$Verbose,
    [string]$Device = "",
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Flutter Training Flow Test Runner

Usage: .\run_flutter_tests.ps1 [options]

Options:
  -Setup          Setup test data on backend before running tests
  -CoachOnly      Run only coach flow tests
  -AthleteOnly    Run only athlete flow tests
  -Verbose        Enable verbose logging
  -Device <id>    Specify device to run tests on (e.g., chrome, emulator-5554)
  -Help           Show this help message

Examples:
  .\run_flutter_tests.ps1 -Setup
  .\run_flutter_tests.ps1 -Device chrome -Verbose
  .\run_flutter_tests.ps1 -CoachOnly -Setup
  
Prerequisites:
  1. Backend server running on localhost:8000
  2. Test data seeded (use -Setup flag)
  3. Flutter device/emulator available
"@
    exit 0
}

# Step 1: Check environment
Write-Host "🔍 Checking environment..." -ForegroundColor Yellow

# Check Flutter installation
try {
    $flutterVersion = flutter --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter not found"
    }
    Write-Host "   ✓ Flutter SDK available" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Flutter not found. Please install Flutter SDK." -ForegroundColor Red
    exit 1
}

# Check backend server
Write-Host "   🔍 Checking backend server..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/health" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "   ✓ Backend server is running" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Backend server not accessible. Please start with: php artisan serve" -ForegroundColor Red
    exit 1
}

# Check Flutter devices
$devices = flutter devices 2>&1
if ($devices -like "*No devices found*") {
    Write-Host "   ❌ No Flutter devices found. Please start an emulator or connect a device." -ForegroundColor Red
    exit 1
}
Write-Host "   ✓ Flutter devices available" -ForegroundColor Green

Write-Host ""

# Step 2: Setup test data if requested
if ($Setup) {
    Write-Host "🌱 Setting up test data..." -ForegroundColor Yellow
    
    # Navigate to backend directory
    $backendPath = "..\..\..\Web\KRPG\KRPG_Website"
    if (Test-Path $backendPath) {
        Push-Location $backendPath
        try {
            php artisan db:seed --class=TrainingFlowTestSeeder
            if ($LASTEXITCODE -ne 0) {
                throw "Seeder failed"
            }
            Write-Host "   ✓ Test data seeded successfully" -ForegroundColor Green
        } catch {
            Write-Host "   ❌ Failed to seed test data: $_" -ForegroundColor Red
            Pop-Location
            exit 1
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "   ❌ Backend directory not found at: $backendPath" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
}

# Step 3: Get dependencies
Write-Host "📦 Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ Failed to get dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "   ✓ Dependencies updated" -ForegroundColor Green
Write-Host ""

# Step 4: Build test arguments
$testArgs = @("test", "integration_test/training_flow_integration_test.dart")

if ($Device -ne "") {
    $testArgs += @("-d", $Device)
}

if ($Verbose) {
    $testArgs += "--verbose"
}

if ($CoachOnly) {
    $testArgs += @("--name", "Complete Coach Training Flow")
} elseif ($AthleteOnly) {
    $testArgs += @("--name", "Complete Athlete Training Flow")
}

# Step 5: Run tests
Write-Host "🧪 Running Flutter integration tests..." -ForegroundColor Yellow
Write-Host "Command: flutter $($testArgs -join ' ')" -ForegroundColor Gray
Write-Host ""

# Start the test
flutter @testArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 Flutter Integration Tests Completed Successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Test Summary:" -ForegroundColor Cyan
    
    if ($CoachOnly) {
        Write-Host "  ✅ Coach Training Flow" -ForegroundColor White
    } elseif ($AthleteOnly) {
        Write-Host "  ✅ Athlete Training Flow" -ForegroundColor White
    } else {
        Write-Host "  ✅ Complete Coach Training Flow" -ForegroundColor White
        Write-Host "  ✅ Complete Athlete Training Flow" -ForegroundColor White
        Write-Host "  ✅ Concurrent Coach & Athlete Flow" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "🔗 Test Accounts:" -ForegroundColor Cyan
    Write-Host "  Coach: test.coach@krpg.com (password: password123)" -ForegroundColor White
    Write-Host "  Athletes: test.athlete1@krpg.com to test.athlete5@krpg.com (password: password123)" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Flutter Integration Tests Failed!" -ForegroundColor Red
    Write-Host "Check the error messages above for details." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 