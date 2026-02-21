# PowerShell script to compute NBA team similarity matrix
# This script will check for Python and install dependencies if needed

Write-Host "NBA Team Similarity Calculator" -ForegroundColor Cyan
Write-Host "=" * 50

# Check for Python
$pythonCmd = $null
$pythonPaths = @("python", "python3", "py")

foreach ($cmd in $pythonPaths) {
    try {
        $result = Get-Command $cmd -ErrorAction Stop
        $pythonCmd = $cmd
        Write-Host "Found Python: $($result.Source)" -ForegroundColor Green
        break
    } catch {
        continue
    }
}

if (-not $pythonCmd) {
    Write-Host "Python not found. Please install Python from https://www.python.org/downloads/" -ForegroundColor Red
    Write-Host "After installing Python, run this script again." -ForegroundColor Yellow
    exit 1
}

# Check if required packages are installed
Write-Host "`nChecking for required packages..." -ForegroundColor Cyan
$checkPandas = & $pythonCmd -c "import pandas" 2>&1
$checkNumpy = & $pythonCmd -c "import numpy" 2>&1

if ($checkPandas -or $checkNumpy) {
    Write-Host "Installing required packages (pandas, numpy)..." -ForegroundColor Yellow
    & $pythonCmd -m pip install pandas numpy --quiet
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to install packages. Please run manually: pip install pandas numpy" -ForegroundColor Red
        exit 1
    }
    Write-Host "Packages installed successfully!" -ForegroundColor Green
} else {
    Write-Host "All required packages are installed." -ForegroundColor Green
}

# Run the similarity computation
Write-Host "`nComputing similarity matrix..." -ForegroundColor Cyan
& $pythonCmd compute_similarity_simple.py

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSuccess! Check the output file: Downloads\nba_team_similarity_matrix.csv" -ForegroundColor Green
} else {
    Write-Host "`nError running the script. Please check the error messages above." -ForegroundColor Red
}
