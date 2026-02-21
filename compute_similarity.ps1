# PowerShell script to compute cosine similarity matrix for NBA teams
# Uses only PowerShell built-in functions

function Get-DotProduct {
    param([double[]]$v1, [double[]]$v2)
    $sum = 0
    for ($i = 0; $i -lt $v1.Length; $i++) {
        $sum += $v1[$i] * $v2[$i]
    }
    return $sum
}

function Get-Magnitude {
    param([double[]]$v)
    $sum = 0
    foreach ($x in $v) {
        $sum += $x * $x
    }
    return [Math]::Sqrt($sum)
}

function Get-CosineSimilarity {
    param([double[]]$v1, [double[]]$v2)
    $dot = Get-DotProduct -v1 $v1 -v2 $v2
    $mag1 = Get-Magnitude -v $v1
    $mag2 = Get-Magnitude -v $v2
    if ($mag1 -eq 0 -or $mag2 -eq 0) {
        return 0.0
    }
    return $dot / ($mag1 * $mag2)
}

# Read CSV file
$csvPath = "C:\Users\maxim\Downloads\Basketball Stats (Source)(Normalized).csv"
$data = Import-Csv $csvPath

# Filter out "League Average" if it exists and extract teams and stats
# Note: Column name is "Tean" (typo) instead of "Team"
$teams = @()
$statsList = @()

foreach ($row in $data) {
    # Get team name from "Tean" column
    $teamName = $row.Tean
    
    if ($teamName -eq "League Average") {
        continue
    }
    $teams += $teamName
    $stats = @(
        [double]$row.'3PA', [double]$row.'2PA', [double]$row.ORB, 
        [double]$row.DRB, [double]$row.STL, [double]$row.TOV,
        [double]$row.AST, [double]$row.FTA, [double]$row.PF
    )
    $statsList += ,$stats
}

$n = $teams.Length
Write-Host "Computing similarity matrix for $n teams..." -ForegroundColor Cyan

# Compute similarity matrix
$similarityMatrix = @()
for ($i = 0; $i -lt $n; $i++) {
    $row = @()
    for ($j = 0; $j -lt $n; $j++) {
        $similarity = Get-CosineSimilarity -v1 $statsList[$i] -v2 $statsList[$j]
        $row += $similarity
    }
    $similarityMatrix += ,$row
    if (($i + 1) % 5 -eq 0) {
        Write-Host "  Processed $($i + 1)/$n teams..." -ForegroundColor Gray
    }
}

# Create output CSV
$outputPath = "C:\Users\maxim\Downloads\nba_team_similarity_matrix.csv"
$output = @()

# Header row
$header = "Team," + ($teams -join ",")
$output += $header

# Data rows
for ($i = 0; $i -lt $n; $i++) {
    $rowValues = @()
    for ($j = 0; $j -lt $n; $j++) {
        $rowValues += "{0:F6}" -f $similarityMatrix[$i][$j]
    }
    $row = $teams[$i] + "," + ($rowValues -join ",")
    $output += $row
}

# Write to file
$output | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "`nSuccess! Similarity matrix saved to:" -ForegroundColor Green
Write-Host $outputPath -ForegroundColor Yellow
Write-Host "`nMatrix dimensions: $n x $n" -ForegroundColor Cyan

# Display preview
Write-Host "`nPreview (first 5x5):" -ForegroundColor Cyan
Write-Host ("Team".PadRight(25) + " | " + ($teams[0..4] | ForEach-Object { $_.Substring(0, [Math]::Min(10, $_.Length)).PadRight(10) } | Join-String -Separator " | "))
Write-Host ("-" * 80)
for ($i = 0; $i -lt [Math]::Min(5, $n); $i++) {
    $teamName = $teams[$i].Substring(0, [Math]::Min(25, $teams[$i].Length)).PadRight(25)
    $values = ($similarityMatrix[$i][0..4] | ForEach-Object { ("{0:F4}" -f $_).PadRight(10) } | Join-String -Separator " | ")
    Write-Host "$teamName | $values"
}
