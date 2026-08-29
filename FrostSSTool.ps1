#Requires -Version 5.1
[CmdletBinding()]
param()

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

$script:ToolName = 'Frost SS Tool'
$script:Version = '1.0.0'
$script:SessionId = [guid]::NewGuid().ToString('N').Substring(0, 12)
$script:StartedAt = Get-Date
$script:Findings = [System.Collections.Generic.List[object]]::new()
$script:ScannedFiles = 0
$script:ScannedProcesses = 0
$script:CompletedScans = [System.Collections.Generic.List[string]]::new()

$desktopPath = [Environment]::GetFolderPath('Desktop')
if ([string]::IsNullOrWhiteSpace($desktopPath)) {
    $desktopPath = Join-Path $env:USERPROFILE 'Desktop'
}
$script:ReportDirectory = Join-Path $desktopPath 'Frost SS Tool Reports'

$script:StrongIndicators = [ordered]@{
    'Meteor Client'   = '(?i)(^|[^a-z0-9])meteor([ _.-]?client)?([^a-z0-9]|$)'
    'LiquidBounce'    = '(?i)liquid[ _.-]?bounce'
    'Wurst Client'    = '(?i)(^|[^a-z0-9])wurst([ _.-]?client)?([^a-z0-9]|$)'
    'Aristois'        = '(?i)aristois'
    'Impact Client'   = '(?i)(^|[^a-z0-9])impact[ _.-]?client([^a-z0-9]|$)'
    'Inertia Client'  = '(?i)(^|[^a-z0-9])inertia([ _.-]?client)?([^a-z0-9]|$)'
    'BleachHack'      = '(?i)bleach[ _.-]?hack'
    'RusherHack'      = '(?i)rusher[ _.-]?hack'
    'Future Client'   = '(?i)future[ _.-]?client'
    'Mathax'          = '(?i)mathax'
    'ThunderHack'     = '(?i)thunder[ _.-]?hack'
    'Lambda Client'   = '(?i)lambda[ _.-]?client'
    'KAMI Blue'       = '(?i)kami[ _.-]?blue'
    'Vape Client'     = '(?i)(^|[^a-z0-9])vape([ _.-]?client)?([^a-z0-9]|$)'
    'Raven Client'    = '(?i)raven[ _.-]?(b\+?|client)'
}

$script:HeuristicIndicators = [ordered]@{
    'Auto Clicker term' = '(?i)auto[ _.-]?click(er)?'
    'Aim Assist term'   = '(?i)aim[ _.-]?assist'
    'Reach term'        = '(?i)(^|[^a-z0-9])reach[ _.-]?(mod|hack|client)([^a-z0-9]|$)'
    'Velocity term'     = '(?i)(^|[^a-z0-9])velocity[ _.-]?(mod|hack|client)([^a-z0-9]|$)'
    'Injector term'     = '(?i)(^|[^a-z0-9])(injector|dll[ _.-]?inject)([^a-z0-9]|$)'
    'Ghost client term' = '(?i)ghost[ _.-]?client'
}

function Show-Logo {
    Clear-Host
    $logo = @'
   ______                __     _____ _____   ______            __
  / ____/________  _____/ /_   / ___// ___/  /_  __/___  ____  / /
 / /_  / ___/ __ \/ ___/ __/   \__ \ \__ \    / / / __ \/ __ \/ /
/ __/ / /  / /_/ (__  ) /_    ___/ /___/ /   / / / /_/ / /_/ / /
/_/   /_/   \____/____/\__/   /____//____/   /_/  \____/\____/_/
'@
    Write-Host $logo -ForegroundColor Cyan
    Write-Host ('  CONSENT-BASED MINECRAFT CLIENT INSPECTION  |  v' + $script:Version) -ForegroundColor DarkCyan
    Write-Host '========================================================================' -ForegroundColor DarkCyan
    Write-Host ''
}

function Show-PrivacyNotice {
    Write-Host 'READ-ONLY PRIVACY NOTICE' -ForegroundColor Cyan
    Write-Host 'This tool only scans areas selected in the menu.' -ForegroundColor Gray
    Write-Host 'It does not delete files, upload reports, read passwords, browser history,' -ForegroundColor Gray
    Write-Host 'Discord data, chats, screenshots, documents, or clipboard contents.' -ForegroundColor Gray
    Write-Host 'Findings are indicators for manual review, never automatic proof of cheating.' -ForegroundColor Yellow
    Write-Host ''
    $consent = Read-Host 'Type I CONSENT to continue'
    if ($consent -cne 'I CONSENT') {
        Write-Host 'Consent was not provided. No scan was performed.' -ForegroundColor Yellow
        exit 0
    }
}

function Get-RiskColor {
    param([string]$Risk)
    switch ($Risk) {
        'High'   { return 'Red' }
        'Medium' { return 'Yellow' }
        'Low'    { return 'DarkYellow' }
        default  { return 'Cyan' }
    }
}

function Get-SafeHash {
    param([string]$Path)
    try {
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            return (Get-FileHash -LiteralPath $Path -Algorithm SHA256 -ErrorAction Stop).Hash
        }
    } catch {}
    return $null
}

function Get-IndicatorMatches {
    param([AllowNull()][string]$Text)

    $indicatorResults = [System.Collections.Generic.List[object]]::new()
    if ([string]::IsNullOrWhiteSpace($Text)) { return $indicatorResults }

    foreach ($entry in $script:StrongIndicators.GetEnumerator()) {
        if ($Text -match $entry.Value) {
            $indicatorResults.Add([pscustomobject]@{ Name = $entry.Key; Risk = 'High' })
        }
    }
    foreach ($entry in $script:HeuristicIndicators.GetEnumerator()) {
        if ($Text -match $entry.Value) {
            $indicatorResults.Add([pscustomobject]@{ Name = $entry.Key; Risk = 'Medium' })
        }
    }
    return $indicatorResults
}

function Add-Finding {
    param(
        [string]$Scan,
        [ValidateSet('Info', 'Low', 'Medium', 'High')][string]$Risk,
        [string]$Indicator,
        [string]$Evidence,
        [AllowNull()][string]$Path,
        [AllowNull()][string]$Sha256,
        [string]$Notes
    )

    $finding = [pscustomobject][ordered]@{
        TimeUtc   = (Get-Date).ToUniversalTime().ToString('o')
        Scan      = $Scan
        Risk      = $Risk
        Indicator = $Indicator
        Evidence  = $Evidence
        Path      = $Path
        SHA256    = $Sha256
        Notes     = $Notes
    }
    $script:Findings.Add($finding)

    $color = Get-RiskColor -Risk $Risk
    Write-Host ('[' + $Risk.ToUpperInvariant() + '] ' + $Indicator) -ForegroundColor $color
    if (-not [string]::IsNullOrWhiteSpace($Path)) {
        Write-Host ('       ' + $Path) -ForegroundColor DarkGray
    }
}

function Complete-Scan {
    param([string]$Name)
    if (-not $script:CompletedScans.Contains($Name)) {
        $script:CompletedScans.Add($Name)
    }
}

function Get-MinecraftRoots {
    $candidates = [System.Collections.Generic.List[string]]::new()
    if ($env:APPDATA) {
        $candidates.Add((Join-Path $env:APPDATA '.minecraft'))
        $candidates.Add((Join-Path $env:APPDATA 'PrismLauncher\instances'))
        $candidates.Add((Join-Path $env:APPDATA 'ModrinthApp\profiles'))
        $candidates.Add((Join-Path $env:APPDATA '.feather'))
        $candidates.Add((Join-Path $env:APPDATA '.lunarclient'))
    }
    if ($env:USERPROFILE) {
        $candidates.Add((Join-Path $env:USERPROFILE 'curseforge\minecraft\Instances'))
    }

    $unique = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            [void]$unique.Add($candidate)
        }
    }
    return @($unique)
}

function Get-ModDirectories {
    param(
        [string[]]$Roots,
        [switch]$DefaultOnly
    )

    $directories = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($root in $Roots) {
        $directMods = Join-Path $root 'mods'
        if (Test-Path -LiteralPath $directMods -PathType Container) {
            [void]$directories.Add($directMods)
        }
        if (-not $DefaultOnly) {
            try {
                Get-ChildItem -LiteralPath $root -Directory -Recurse -Filter 'mods' -ErrorAction SilentlyContinue |
                    Select-Object -First 200 | ForEach-Object { [void]$directories.Add($_.FullName) }
            } catch {}
        }
    }
    return @($directories)
}

function Read-JarMetadata {
    param([string]$Path)

    $metadataNames = @(
        'fabric.mod.json',
        'quilt.mod.json',
        'META-INF/mods.toml',
        'META-INF/neoforge.mods.toml',
        'META-INF/MANIFEST.MF'
    )
    $textParts = [System.Collections.Generic.List[string]]::new()
    $archive = $null
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
        foreach ($entry in $archive.Entries) {
            $normalized = $entry.FullName.Replace('\', '/')
            if ($metadataNames -contains $normalized -and $entry.Length -le 1048576) {
                $stream = $entry.Open()
                $reader = [System.IO.StreamReader]::new($stream)
                try {
                    $textParts.Add($reader.ReadToEnd())
                } finally {
                    $reader.Dispose()
                    $stream.Dispose()
                }
            }
        }
    } catch {
        return $null
    } finally {
        if ($null -ne $archive) { $archive.Dispose() }
    }
    return ($textParts -join "`n")
}

function Scan-ModFiles {
    param([switch]$DefaultOnly)

    $scanName = if ($DefaultOnly) { 'Quick Minecraft mods' } else { 'All Minecraft instances' }
    Write-Host ('Starting: ' + $scanName) -ForegroundColor Cyan
    $before = $script:Findings.Count
    $roots = @(Get-MinecraftRoots)
    if ($DefaultOnly -and $env:APPDATA) {
        $defaultRoot = Join-Path $env:APPDATA '.minecraft'
        $roots = @($roots | Where-Object { $_ -eq $defaultRoot })
    }

    $modDirectories = @(Get-ModDirectories -Roots $roots -DefaultOnly:$DefaultOnly)
    foreach ($directory in $modDirectories) {
        Write-Host ('Scanning ' + $directory) -ForegroundColor DarkCyan
        try {
            $files = @(Get-ChildItem -LiteralPath $directory -File -Filter '*.jar' -ErrorAction SilentlyContinue)
            foreach ($file in $files) {
                $script:ScannedFiles++
                $nameMatches = @(Get-IndicatorMatches -Text $file.Name)
                $metadata = Read-JarMetadata -Path $file.FullName
                $metadataMatches = @(Get-IndicatorMatches -Text $metadata)
                $allMatches = @($nameMatches + $metadataMatches | Sort-Object Name -Unique)

                if ($allMatches.Count -gt 0) {
                    $hash = Get-SafeHash -Path $file.FullName
                    foreach ($match in $allMatches) {
                        $source = if (@($nameMatches | Where-Object Name -eq $match.Name).Count -gt 0) {
                            'Filename matched a known indicator.'
                        } else {
                            'JAR metadata matched a known indicator.'
                        }
                        Add-Finding -Scan $scanName -Risk $match.Risk -Indicator $match.Name `
                            -Evidence 'Minecraft mod JAR' -Path $file.FullName -Sha256 $hash `
                            -Notes ($source + ' Verify manually before taking action.')
                    }
                }
            }
        } catch {
            Add-Finding -Scan $scanName -Risk 'Info' -Indicator 'Folder could not be scanned' `
                -Evidence $_.Exception.Message -Path $directory -Sha256 $null `
                -Notes 'Access may be restricted or the folder changed during the scan.'
        }
    }
    Complete-Scan -Name $scanName
    Write-Host ('Finished. New findings: ' + ($script:Findings.Count - $before)) -ForegroundColor Cyan
}

function Scan-RunningProcesses {
    Write-Host 'Starting: Running processes' -ForegroundColor Cyan
    $before = $script:Findings.Count
    try {
        $processes = @(Get-CimInstance Win32_Process -ErrorAction Stop)
        foreach ($process in $processes) {
            $script:ScannedProcesses++
            $safeText = @($process.Name, $process.ExecutablePath, $process.CommandLine) -join ' '
            $matches = @(Get-IndicatorMatches -Text $safeText)
            foreach ($match in $matches) {
                $path = [string]$process.ExecutablePath
                $hash = Get-SafeHash -Path $path
                Add-Finding -Scan 'Running processes' -Risk $match.Risk -Indicator $match.Name `
                    -Evidence ('Running process: ' + $process.Name + ' (PID ' + $process.ProcessId + ')') `
                    -Path $path -Sha256 $hash `
                    -Notes 'Matched process name, executable path, or command-line text. Sensitive command-line values are not stored.'
            }
        }
    } catch {
        Add-Finding -Scan 'Running processes' -Risk 'Info' -Indicator 'Process scan unavailable' `
            -Evidence $_.Exception.Message -Path $null -Sha256 $null `
            -Notes 'Try running PowerShell normally first; administrator rights are optional.'
    }
    Complete-Scan -Name 'Running processes'
    Write-Host ('Finished. New findings: ' + ($script:Findings.Count - $before)) -ForegroundColor Cyan
}

function Scan-RecentFiles {
    Write-Host 'Starting: Recent Downloads/Desktop filenames' -ForegroundColor Cyan
    Write-Host 'Only filenames and matching files are inspected. Other file contents are ignored.' -ForegroundColor DarkCyan
    $before = $script:Findings.Count
    $cutoff = (Get-Date).AddDays(-30)
    $downloadsFolder = Join-Path ([Environment]::GetFolderPath('UserProfile')) 'Downloads'
    $folders = @($downloadsFolder, [Environment]::GetFolderPath('Desktop'))
    $allowedExtensions = @('.jar', '.exe', '.dll', '.zip', '.rar', '.7z')

    foreach ($folder in $folders) {
        if (-not (Test-Path -LiteralPath $folder -PathType Container)) { continue }
        try {
            Get-ChildItem -LiteralPath $folder -File -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTime -ge $cutoff -and $allowedExtensions -contains $_.Extension.ToLowerInvariant() } |
                Select-Object -First 3000 | ForEach-Object {
                    $script:ScannedFiles++
                    $matches = @(Get-IndicatorMatches -Text $_.Name)
                    foreach ($match in $matches) {
                        Add-Finding -Scan 'Recent filenames' -Risk $match.Risk -Indicator $match.Name `
                            -Evidence 'Matching filename from the last 30 days' -Path $_.FullName `
                            -Sha256 (Get-SafeHash -Path $_.FullName) `
                            -Notes 'Only the filename triggered this finding. Verify the file manually.'
                    }
                }
        } catch {
            Add-Finding -Scan 'Recent filenames' -Risk 'Info' -Indicator 'Folder could not be scanned' `
                -Evidence $_.Exception.Message -Path $folder -Sha256 $null `
                -Notes 'No attempt was made to bypass file permissions.'
        }
    }
    Complete-Scan -Name 'Recent filenames'
    Write-Host ('Finished. New findings: ' + ($script:Findings.Count - $before)) -ForegroundColor Cyan
}

function Scan-Prefetch {
    Write-Host 'Starting: Windows Prefetch filenames' -ForegroundColor Cyan
    Write-Host 'This optional scan reads execution-trace filenames only.' -ForegroundColor DarkCyan
    $before = $script:Findings.Count
    $prefetch = Join-Path $env:SystemRoot 'Prefetch'
    if (Test-Path -LiteralPath $prefetch -PathType Container) {
        try {
            Get-ChildItem -LiteralPath $prefetch -File -Filter '*.pf' -ErrorAction Stop | ForEach-Object {
                $matches = @(Get-IndicatorMatches -Text $_.Name)
                foreach ($match in $matches) {
                    Add-Finding -Scan 'Prefetch filenames' -Risk $match.Risk -Indicator $match.Name `
                        -Evidence 'Windows Prefetch filename matched' -Path $_.FullName -Sha256 $null `
                        -Notes 'A Prefetch filename may indicate execution, but must be reviewed manually.'
                }
            }
        } catch {
            Add-Finding -Scan 'Prefetch filenames' -Risk 'Info' -Indicator 'Prefetch unavailable' `
                -Evidence $_.Exception.Message -Path $prefetch -Sha256 $null `
                -Notes 'Administrator access may be required. No permissions were bypassed.'
        }
    }
    Complete-Scan -Name 'Prefetch filenames'
    Write-Host ('Finished. New findings: ' + ($script:Findings.Count - $before)) -ForegroundColor Cyan
}

function Verify-SingleFile {
    Write-Host 'Single-file verification does not execute the selected file.' -ForegroundColor Cyan
    $path = (Read-Host 'Enter the full path to a JAR, EXE, DLL, ZIP, RAR, or 7Z file').Trim('"')
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Write-Host 'File not found.' -ForegroundColor Yellow
        return
    }

    $script:ScannedFiles++
    $file = Get-Item -LiteralPath $path
    $matches = @(Get-IndicatorMatches -Text $file.Name)
    if ($file.Extension -ieq '.jar') {
        $metadata = Read-JarMetadata -Path $file.FullName
        $matches += @(Get-IndicatorMatches -Text $metadata)
    }
    $matches = @($matches | Sort-Object Name -Unique)
    $hash = Get-SafeHash -Path $file.FullName

    if ($matches.Count -eq 0) {
        Add-Finding -Scan 'Single-file verification' -Risk 'Info' -Indicator 'No known text indicator' `
            -Evidence 'File was hashed and checked without execution' -Path $file.FullName -Sha256 $hash `
            -Notes 'No match does not prove that a file is safe.'
    } else {
        foreach ($match in $matches) {
            Add-Finding -Scan 'Single-file verification' -Risk $match.Risk -Indicator $match.Name `
                -Evidence 'Filename or safe JAR metadata match' -Path $file.FullName -Sha256 $hash `
                -Notes 'Verify manually before taking action.'
        }
    }
    Complete-Scan -Name 'Single-file verification'
}

function ConvertTo-HtmlEncoded {
    param([AllowNull()]$Value)
    if ($null -eq $Value) { return '' }
    return [System.Net.WebUtility]::HtmlEncode([string]$Value)
}

function Export-Report {
    New-Item -ItemType Directory -Path $script:ReportDirectory -Force | Out-Null
    $timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $baseName = 'Frost-SS-Report_' + $timestamp + '_' + $script:SessionId
    $jsonPath = Join-Path $script:ReportDirectory ($baseName + '.json')
    $htmlPath = Join-Path $script:ReportDirectory ($baseName + '.html')

    $summary = [pscustomobject][ordered]@{
        Tool              = $script:ToolName
        Version           = $script:Version
        SessionId         = $script:SessionId
        StartedAtUtc      = $script:StartedAt.ToUniversalTime().ToString('o')
        ExportedAtUtc     = (Get-Date).ToUniversalTime().ToString('o')
        ComputerName      = $env:COMPUTERNAME
        WindowsUser       = $env:USERNAME
        CompletedScans    = @($script:CompletedScans)
        ScannedFiles      = $script:ScannedFiles
        ScannedProcesses  = $script:ScannedProcesses
        FindingCount      = $script:Findings.Count
        Findings          = @($script:Findings)
        Disclaimer        = 'Indicators require manual review and are not automatic proof of cheating.'
    }
    $summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonPath -Encoding UTF8

    $rows = [System.Text.StringBuilder]::new()
    foreach ($finding in $script:Findings) {
        $riskClass = ([string]$finding.Risk).ToLowerInvariant()
        [void]$rows.AppendLine(('<tr><td><span class="risk ' + $riskClass + '">' + (ConvertTo-HtmlEncoded $finding.Risk) + '</span></td>' +
            '<td>' + (ConvertTo-HtmlEncoded $finding.Scan) + '</td>' +
            '<td>' + (ConvertTo-HtmlEncoded $finding.Indicator) + '</td>' +
            '<td>' + (ConvertTo-HtmlEncoded $finding.Evidence) + '</td>' +
            '<td class="path">' + (ConvertTo-HtmlEncoded $finding.Path) + '</td>' +
            '<td class="hash">' + (ConvertTo-HtmlEncoded $finding.SHA256) + '</td>' +
            '<td>' + (ConvertTo-HtmlEncoded $finding.Notes) + '</td></tr>'))
    }
    if ($script:Findings.Count -eq 0) {
        [void]$rows.AppendLine('<tr><td colspan="7" class="empty">No indicators were found in the selected scan areas.</td></tr>')
    }

    $completed = if ($script:CompletedScans.Count -gt 0) { $script:CompletedScans -join ', ' } else { 'None' }
    $html = @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Frost SS Tool Report</title>
<style>
:root{color-scheme:dark;--bg:#07111f;--panel:#0d1d30;--line:#1f3d5b;--cyan:#55d9ff;--text:#e8f5ff;--muted:#91a9bd}
*{box-sizing:border-box}body{margin:0;background:radial-gradient(circle at top,#123455 0,#07111f 45%);color:var(--text);font-family:Segoe UI,Arial,sans-serif}
.wrap{max-width:1500px;margin:0 auto;padding:32px}.brand{font-size:38px;font-weight:800;letter-spacing:.5px;color:var(--cyan)}
.sub{color:var(--muted);margin-top:5px}.notice{margin:22px 0;padding:15px 18px;border:1px solid #2d6388;background:#0c2238;border-radius:12px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin:20px 0}.card{background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px}.value{font-size:26px;font-weight:700;color:var(--cyan)}
.label{font-size:12px;text-transform:uppercase;color:var(--muted)}table{width:100%;border-collapse:collapse;background:var(--panel);border:1px solid var(--line)}th,td{text-align:left;padding:11px;border-bottom:1px solid var(--line);vertical-align:top}th{position:sticky;top:0;background:#102a43;color:var(--cyan)}
.risk{font-weight:700}.risk.high{color:#ff6b7a}.risk.medium{color:#ffd166}.risk.low{color:#f0b35a}.risk.info{color:#67dcff}.path,.hash{font-family:Consolas,monospace;font-size:12px;word-break:break-all}.empty{text-align:center;color:#7ee7b8;padding:30px}
</style>
</head>
<body><main class="wrap">
<div class="brand">Frost SS Tool</div>
<div class="sub">Consent-based Minecraft client inspection | Version $(ConvertTo-HtmlEncoded $script:Version) | Session $(ConvertTo-HtmlEncoded $script:SessionId)</div>
<div class="notice"><strong>Important:</strong> Findings are indicators for manual review, not automatic proof of cheating. This report was created locally and was not uploaded by Frost SS Tool.</div>
<section class="cards">
<div class="card"><div class="value">$($script:Findings.Count)</div><div class="label">Findings</div></div>
<div class="card"><div class="value">$($script:ScannedFiles)</div><div class="label">Files checked</div></div>
<div class="card"><div class="value">$($script:ScannedProcesses)</div><div class="label">Processes checked</div></div>
</section>
<p><strong>Completed scans:</strong> $(ConvertTo-HtmlEncoded $completed)</p>
<table><thead><tr><th>Risk</th><th>Scan</th><th>Indicator</th><th>Evidence</th><th>Path</th><th>SHA-256</th><th>Notes</th></tr></thead><tbody>
$($rows.ToString())
</tbody></table>
</main></body></html>
"@
    [System.IO.File]::WriteAllText($htmlPath, $html, [Text.UTF8Encoding]::new($false))

    Write-Host ''
    Write-Host 'Reports exported locally:' -ForegroundColor Green
    Write-Host ('HTML: ' + $htmlPath) -ForegroundColor Cyan
    Write-Host ('JSON: ' + $jsonPath) -ForegroundColor Cyan
    return [pscustomobject]@{ Html = $htmlPath; Json = $jsonPath }
}

function Run-QuickScan {
    Scan-RunningProcesses
    Scan-ModFiles -DefaultOnly
    Complete-Scan -Name 'Quick scan'
}

function Run-FullSafeScan {
    Scan-RunningProcesses
    Scan-ModFiles
    Scan-RecentFiles
    Scan-Prefetch
    Complete-Scan -Name 'Full safe scan'
}

function Show-Menu {
    Write-Host ''
    Write-Host 'SCAN MENU' -ForegroundColor Cyan
    Write-Host '  [1] Quick scan - processes + default .minecraft mods' -ForegroundColor White
    Write-Host '  [2] Minecraft files - all detected launcher instances' -ForegroundColor White
    Write-Host '  [3] Running processes' -ForegroundColor White
    Write-Host '  [4] Recent Downloads/Desktop filenames (last 30 days)' -ForegroundColor White
    Write-Host '  [5] Windows Prefetch filenames (optional)' -ForegroundColor White
    Write-Host '  [6] Full safe scan - options 2 through 5' -ForegroundColor White
    Write-Host '  [7] Verify one selected file' -ForegroundColor White
    Write-Host '  [8] Export local HTML + JSON report' -ForegroundColor White
    Write-Host '  [9] Open report folder' -ForegroundColor White
    Write-Host '  [0] Exit' -ForegroundColor White
    Write-Host ''
}

Show-Logo
Show-PrivacyNotice

while ($true) {
    Show-Menu
    $choice = Read-Host 'Choose an option'
    Write-Host ''
    try {
        switch ($choice.Trim()) {
            '1' { Run-QuickScan }
            '2' { Scan-ModFiles }
            '3' { Scan-RunningProcesses }
            '4' {
                $confirm = Read-Host 'Scan matching filenames in Downloads/Desktop? Type YES'
                if ($confirm -ceq 'YES') { Scan-RecentFiles } else { Write-Host 'Cancelled.' -ForegroundColor Yellow }
            }
            '5' {
                $confirm = Read-Host 'Read Windows Prefetch filenames? Type YES'
                if ($confirm -ceq 'YES') { Scan-Prefetch } else { Write-Host 'Cancelled.' -ForegroundColor Yellow }
            }
            '6' {
                $confirm = Read-Host 'Run all safe modules, including recent filenames and Prefetch? Type YES'
                if ($confirm -ceq 'YES') { Run-FullSafeScan } else { Write-Host 'Cancelled.' -ForegroundColor Yellow }
            }
            '7' { Verify-SingleFile }
            '8' { [void](Export-Report) }
            '9' {
                New-Item -ItemType Directory -Path $script:ReportDirectory -Force | Out-Null
                Start-Process explorer.exe $script:ReportDirectory
            }
            '0' {
                if ($script:CompletedScans.Count -gt 0) {
                    $export = Read-Host 'Export a report before closing? [Y/n]'
                    if ([string]::IsNullOrWhiteSpace($export) -or $export -match '^(?i)y$') {
                        [void](Export-Report)
                    }
                }
                Write-Host 'Frost SS Tool closed. No data was uploaded.' -ForegroundColor Cyan
                break
            }
            default { Write-Host 'Invalid menu option.' -ForegroundColor Yellow }
        }
    } catch {
        Write-Host ('The selected scan failed safely: ' + $_.Exception.Message) -ForegroundColor Red
        Write-Host 'No permissions were bypassed and no files were changed.' -ForegroundColor Yellow
    }

    if ($choice.Trim() -eq '0') { break }
}
