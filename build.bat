@echo off
REM Build script for OpenSCAD designs
REM Generates STL files and PNG images for all .scad files

setlocal EnableDelayedExpansion

REM Configuration
set BUILD_DIR=build
set IMG_WIDTH=800
set IMG_HEIGHT=600

REM Camera settings for views (translate_x,y,z, rot_x,y,z, distance)
REM Using --autocenter and --viewall to automatically fit entire model
REM Front view: 55 elevation, 45 azimuth
set CAMERA_FRONT=0,0,0,55,0,45,0
REM Rear view: 55 elevation, 225 azimuth (opposite side)
set CAMERA_REAR=0,0,0,55,0,225,0

REM Find OpenSCAD
set OPENSCAD=
where openscad >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set OPENSCAD=openscad
) else (
    REM Check common installation paths
    if exist "C:\Program Files\OpenSCAD\openscad.exe" (
        set "OPENSCAD=C:\Program Files\OpenSCAD\openscad.exe"
    ) else if exist "C:\Program Files (x86)\OpenSCAD\openscad.exe" (
        set "OPENSCAD=C:\Program Files (x86)\OpenSCAD\openscad.exe"
    ) else (
        echo [ERROR] OpenSCAD not found. Please install OpenSCAD and ensure it's in your PATH.
        exit /b 1
    )
)

echo [INFO] Using OpenSCAD: %OPENSCAD%

REM Create or clean build directory
if exist "%BUILD_DIR%" (
    echo [INFO] Cleaning build directory...
    rd /s /q "%BUILD_DIR%"
)
echo [INFO] Creating build directory...
mkdir "%BUILD_DIR%"

REM Process all .scad files
set COUNT=0
for /r %%f in (*.scad) do (
    REM Skip files in lib, include, or build directories
    echo %%f | findstr /i /c:"\lib\" /c:"\include\" /c:"\%BUILD_DIR%\" >nul
    if errorlevel 1 (
        call :process_file "%%f"
        set /a COUNT+=1
    )
)

if %COUNT% EQU 0 (
    echo [WARN] No .scad files found in the current directory.
    exit /b 0
)

echo.
echo [INFO] Build complete! Processed %COUNT% file(s).
echo [INFO] Output directory: %BUILD_DIR%\
echo.
echo [INFO] Generated files:
dir /b "%BUILD_DIR%"

exit /b 0

REM Function to process a single SCAD file
:process_file
set "SCAD_FILE=%~1"
set "BASE_NAME=%~n1"
set "STL_FILE=%BUILD_DIR%\%BASE_NAME%.stl"
set "FRONT_IMG=%BUILD_DIR%\%BASE_NAME%_front.png"
set "REAR_IMG=%BUILD_DIR%\%BASE_NAME%_rear.png"

echo [INFO] Processing: %SCAD_FILE%

echo [INFO] Generating STL: %STL_FILE%
"%OPENSCAD%" -o "%STL_FILE%" "%SCAD_FILE%"
if errorlevel 1 (
    echo [ERROR] Failed to generate STL for %SCAD_FILE%
    exit /b 1
)

echo [INFO] Generating front view: %FRONT_IMG%
"%OPENSCAD%" -o "%FRONT_IMG%" --autocenter --viewall --camera=%CAMERA_FRONT% --imgsize=%IMG_WIDTH%,%IMG_HEIGHT% --colorscheme="Tomorrow Night" "%SCAD_FILE%"
if errorlevel 1 (
    echo [ERROR] Failed to generate front image for %SCAD_FILE%
    exit /b 1
)

echo [INFO] Generating rear view: %REAR_IMG%
"%OPENSCAD%" -o "%REAR_IMG%" --autocenter --viewall --camera=%CAMERA_REAR% --imgsize=%IMG_WIDTH%,%IMG_HEIGHT% --colorscheme="Tomorrow Night" "%SCAD_FILE%"
if errorlevel 1 (
    echo [ERROR] Failed to generate rear image for %SCAD_FILE%
    exit /b 1
)

exit /b 0
