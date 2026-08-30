#Requires -Version 5.1
[CmdletBinding()]
param()

Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::SetCompatibleTextRenderingDefault($false)

$script:ToolName = 'Frost SS Tool'
$script:Version = '2.2.0'
$script:Findings = [System.Collections.Generic.List[object]]::new()
$script:ScannedFiles = 0
$script:ScannedProcesses = 0
$script:CompletedScans = [System.Collections.Generic.List[string]]::new()
$script:ActionButtons = [System.Collections.Generic.List[System.Windows.Forms.Button]]::new()

$clientCatalogText = @'
06dWare
198Macros
22qq
3arthh4ck
4E
5C
Abstract
Achilles
Agalar
AimWhere
Alien
AllahWare
anamvmnt
Ananta
Andy
Ape
Apollo
Ares
Argon
Arsenic
Arsenic2
Artemis
Aspirah
Astera
Asteria
AsteriaRip
Astralis
AstraWare
Astro.dev
Atlas
Atomic
Atrium
Aurora
Backdoored
Balenciaga
Bape
BBCWare
BeefSense
BerryBobus
PerryPhobos
PGz
PhoboxNotGay
PigHack
BetaX
BigG
BigRat
BlackAndWhite
Reaper
BladeCore
BleachHack
Blessed
BloomWare
BossWare
BoyKisser
WhiskerZ
Boze
Bubby
Byte
Byte Utility
C.U.M Fusion
Caizm
Cake
Calamity
Calcium
Calypso
Candy
CarrotHack
CatLean
Catmi
Catmi Rewrite
CatsWare
ChucKHack
Claudius
Click
ClickCrystals
Coffee
Cookie
Cosmos
CousinWare
Cr33pyWare
Cranberry
CrossSince
Crystal
Cue
CurryMod
Cursa
Curse
Cute
CW Hack
CwHack
CX
Cyemer
Cymer
Dent
DestroySquad
Devu
Doki
Doomsday
DotGod.cc
Swift
Dqrkis
DrugHack
Echo
Elementars.com
FrogWare
Mercury
Elysian
Epitaph
Epsilon
Epsilon+
Europa
Evangelion
EvliEye
Evo
ExosWare
FabricHax
FamilyFunPack
FDP
Glass
LiquidBounce+ Reborn
LiquidCat
SkidBounce
FencingF+2
Ferox
Fira
Fire
FireWork
FiveGuys
Flawless
Floppa
Fog
Forever
ForgeHax
Francium
Freemanatee
FrostBurn
FutureX
Galactie
GameSense
SpiderSense
Gardenia
Garuff
Gate
GateClient 1.19.2
GeraldHack
GhostBleach
GishCode
Gladiator
Glow
Grandline
GrassWare.win
Grim
Grim Cracked
GumTune
Gypsyy
Hanabi
HayBale
HemHacks
Hiassi.su
Realth
HitlerHax
HockeyWare
Huzuni
Huzuni+2
HydraWare+
Hydrogen
Hypnotic
Ikea
IlyVoo
PJ Shitty Bypass
Incoming
Infinity2
InfinityLoop
InvincibilityHack
Jackey
Jex
JigokuSense
Jobless
JorgitoHack
Juice
KAMI
Zispanos
Kami++
Kami5
Kamiblue
Kana
Kappa
Karma
KettleHack
Kevin
Kiwi
Koks
Konas
Korppu
KrLoader
Krypton
Kura
Kura NextGen
Lambda
Lantern
Lattia
LavaHack
LBounce
Leave
Legacy
LeuxBackdoor
LiquidBounce
LiquidShadow
LiquidX
ListedHack
LiveSense
LmaoBox
Lover
Lucid Argoon
Lucky
LumaHack
Lumina
Luminaclient
Luminex
LV
Lynx
MacHack
MackMod
Magic
Marlowww
McDonald
MCP
MedusaWare
Medved
MelodySky
Melon
MelonHack+
Mera Private
Meteor
Meteor+
MetteroV2
Minced
Mint
Mint2
Mirai
Misericordia
Mist
Moloch.su
Momentum
Monke
Moonlight
Meadows
Moonlight3
Mousse
Myau
Nami
NanoSense
NClient
Neko+
Neptunium
New Virgin
Nexus
Nicotine
NightX
NineHack
Noat Wurst+2
Wurst+2
NobleSix
NoobHack
Norules
Notorious
Nova
NovaClient V1
Novoware
NovowareAPI
NoWeakAttack
Noxx
NullPoint
NutGod.CC
Nyrex
Oak
Old Virgin
OmegaHack
OyVey Rewrite
Silence
Uop.cc
Zori
OmegaHack Rewrite
Raven B++
OnePop
Onigiri
Onyx
Orchard
Orion
Osiris
Osmium
Outrage
OyVey+
Ozark
Past
PastiqueV2
PepsiMod
Phantom
Pika
Piston
Platinium
Platinum
Plutora
Pocket
PollosHook
Postman++
Prestige
PubDLC
Pugware
Pulse
Quantrum
Quantum
Qubit
Radium
Raion
RavenWeave
Razmorozka
Rebirth Alpha
Rebirth Nextgen
reDACTED
Reflection
Remnant
RenoSense
RenoSenseTwo
RerHack.club
Resilience
Reznya
Rich
Rocan
RoseGold
Ruby
Ruhama
SafePoint.club
SafePoint+2
Satellite
Scrim
Scrims
Selene
Seppuku
SerenityCE
SexHack
ShafferHack
ShellSock
SHGR
Shoreline
Shoreline NEW
ShrimpHack
Silk
Skidd.ed
Skilled
Skligga
Skliggahack
Slack
Smok
SMPHack
Sn0w
Sol
Sorus
Splash
ST TriggerBot
Stay
Sudo
Sumo
Sunshine
Surge
Wing
Sushi
Sydney
Syracuse
System
Tarasande
TeddyWare
Temple
Tensor
THSense
ThunderHack
ThunderHack Recode
TipTap
Tokyo
Tomato
Toxic.club
TransWare
TriggerLib
Trinity
Trinity+
TrollGod.cc
Trollhack
TurcoHack.cc
Turok
Urmomia
UZI
Vape
Vapid
Velaris
Vengeance
Vertex
ConfigLib
VeteranHack
Virgin
Volt
Vox
vril
Vrpos
VydraHack
W1seHack
Water
Wazo
Skid
WingClient
Winter
Wiz
Wurst
Wurst+1
Wurst+3
Xdolf
Xenon
Xenon V2
Xenophyre
Xiu
Xulu
Xulu+
Xyla
Zelith
Zenith
Zenith Macros
Zeon
ZeroHack
ZeroTwo
Zinc
Zodiac
Zoomies
ZSpaceHack
Zyklon
Aristois
Impact Client
Inertia Client
RusherHack
Future Client
Mathax
Raven Client
'@

$genericClientText = @'
4E
5C
Ape
Apollo
Ares
Argon
Artemis
Atlas
Atomic
Aurora
Backdoored
Balenciaga
Bape
BetaX
BigG
BigRat
Blessed
Boze
Bubby
Byte
Cake
Calcium
Calypso
Candy
Click
Coffee
Cookie
Cosmos
Cranberry
Crystal
Cue
Cursa
Curse
Cute
CX
Dent
Doki
Doomsday
Echo
Epsilon
Europa
Evo
Fira
Fire
FireWork
Flawless
Floppa
Fog
Forever
Glow
Grim
Hydrogen
Hypnotic
Ikea
Incoming
Jackey
Jex
Jobless
Juice
Kana
Kappa
Karma
Kevin
Kiwi
Koks
Krypton
Leave
Legacy
Lover
Lucky
Lumina
LV
Lynx
Magic
McDonald
MCP
Medved
Melon
Mint
Mist
Momentum
Monke
Moonlight
Nami
Nexus
Nicotine
Nova
Oak
Past
Phantom
Pika
Piston
Platinum
Pocket
Prestige
Pulse
Quantum
Qubit
Radium
Reflection
Remnant
Rich
Ruby
Satellite
Scrim
Scrims
Selene
Silk
Skilled
Slack
Smok
Sol
Splash
Stay
Sudo
Sumo
Sunshine
Surge
Sushi
Sydney
Syracuse
System
Temple
Tensor
Tokyo
Tomato
Trinity
UZI
Vape
Vapid
Volt
Vox
Water
Winter
Wiz
Xenon
Xiu
Xyla
Zenith
Zinc
Zodiac
'@

$genericNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($name in @($genericClientText -split "`r?`n")) {
    if (-not [string]::IsNullOrWhiteSpace($name)) { [void]$genericNames.Add($name.Trim()) }
}

$uniqueNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$script:ClientSignatures = [System.Collections.Generic.List[object]]::new()
$script:SignatureByKey = [System.Collections.Generic.Dictionary[string,object]]::new([StringComparer]::OrdinalIgnoreCase)
$alternativeBodies = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($name in @($clientCatalogText -split "`r?`n")) {
    $cleanName = $name.Trim()
    if ([string]::IsNullOrWhiteSpace($cleanName) -or -not $uniqueNames.Add($cleanName)) { continue }
    $tokens = @([regex]::Matches($cleanName, '[A-Za-z0-9]+') | ForEach-Object { [regex]::Escape($_.Value) })
    if ($tokens.Count -eq 0) { continue }
    $body = $tokens -join '[^a-z0-9]{0,4}'
    $risk = if ($genericNames.Contains($cleanName)) { 'Medium' } else { 'High' }
    $key = [regex]::Replace($cleanName.ToLowerInvariant(), '[^a-z0-9]', '')
    $signature = [pscustomobject]@{
        Name = $cleanName
        Risk = $risk
        Key = $key
    }
    $script:ClientSignatures.Add($signature)
    if (-not $script:SignatureByKey.ContainsKey($key)) { $script:SignatureByKey.Add($key, $signature) }
    [void]$alternativeBodies.Add($body)
}
$orderedAlternatives = @($alternativeBodies | Sort-Object Length -Descending)
$catalogPattern = '(^|[^a-z0-9])(?<client>' + ($orderedAlternatives -join '|') + ')(?=$|[^a-z0-9])'
$catalogOptions = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::CultureInvariant -bor [System.Text.RegularExpressions.RegexOptions]::Compiled
$script:ClientRegex = [regex]::new($catalogPattern, $catalogOptions)

$script:HeuristicIndicators = [ordered]@{
    'Auto Clicker term' = '(?i)auto[ _.-]?click(er)?'
    'Aim Assist term'   = '(?i)aim[ _.-]?assist'
    'Reach term'        = '(?i)(^|[^a-z0-9])reach[ _.-]?(mod|hack|client)([^a-z0-9]|$)'
    'Velocity term'     = '(?i)(^|[^a-z0-9])velocity[ _.-]?(mod|hack|client)([^a-z0-9]|$)'
    'Injector term'     = '(?i)(^|[^a-z0-9])(injector|dll[ _.-]?inject)([^a-z0-9]|$)'
    'Ghost client term' = '(?i)ghost[ _.-]?client'
}

function Get-UiColor {
    param([string]$Hex)
    return [System.Drawing.ColorTranslator]::FromHtml($Hex)
}

$script:Colors = @{
    Background = Get-UiColor '#050505'
    Surface    = Get-UiColor '#0A0A0A'
    Panel      = Get-UiColor '#121212'
    Border     = Get-UiColor '#303030'
    Cyan       = Get-UiColor '#FFFFFF'
    Blue       = Get-UiColor '#F4F4F5'
    Text       = Get-UiColor '#F7F7F7'
    Muted      = Get-UiColor '#A1A1AA'
    Green      = Get-UiColor '#7EE787'
    Yellow     = Get-UiColor '#F2CC60'
    Red        = Get-UiColor '#FF6B6B'
}

function Get-IndicatorMatches {
    param([AllowNull()][string]$Text)

    $results = [System.Collections.Generic.List[object]]::new()
    if ([string]::IsNullOrWhiteSpace($Text)) { return @($results) }

    $seenClients = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $catalogHits = 0
    foreach ($catalogMatch in $script:ClientRegex.Matches($Text)) {
        $catalogHits++
        if ($catalogHits -gt 5000) { break }
        $key = [regex]::Replace($catalogMatch.Groups['client'].Value.ToLowerInvariant(), '[^a-z0-9]', '')
        if ($script:SignatureByKey.ContainsKey($key)) {
            $signature = $script:SignatureByKey[$key]
            if ($seenClients.Add($signature.Name)) {
                $results.Add([pscustomobject]@{ Name = $signature.Name; Risk = $signature.Risk })
            }
        }
    }
    foreach ($entry in $script:HeuristicIndicators.GetEnumerator()) {
        if ($Text -match $entry.Value) {
            $results.Add([pscustomobject]@{ Name = $entry.Key; Risk = 'Medium' })
        }
    }
    return @($results)
}

function Get-SafeHash {
    param([AllowNull()][string]$Path)
    try {
        if (-not [string]::IsNullOrWhiteSpace($Path) -and (Test-Path -LiteralPath $Path -PathType Leaf)) {
            return (Get-FileHash -LiteralPath $Path -Algorithm SHA256 -ErrorAction Stop).Hash
        }
    } catch {}
    return ''
}

function Update-Counters {
    $script:FindingValue.Text = [string]$script:Findings.Count
    $script:FileValue.Text = [string]$script:ScannedFiles
    $script:ProcessValue.Text = [string]$script:ScannedProcesses
    $script:ResultCount.Text = ('{0} RESULT{1}' -f $script:Findings.Count, $(if ($script:Findings.Count -eq 1) { '' } else { 'S' }))
}

function Set-Status {
    param(
        [string]$Text,
        [string]$Color = 'Muted'
    )
    $script:StatusLabel.Text = $Text
    $script:StatusLabel.ForeColor = $script:Colors[$Color]
    [System.Windows.Forms.Application]::DoEvents()
}

function Add-Finding {
    param(
        [string]$Scan,
        [ValidateSet('Info', 'Medium', 'High')][string]$Risk,
        [string]$Indicator,
        [string]$Evidence,
        [AllowNull()][string]$Path,
        [AllowNull()][string]$Sha256,
        [string]$Notes
    )

    $finding = [pscustomobject][ordered]@{
        TimeUtc   = (Get-Date).ToUniversalTime().ToString('o')
        Risk      = $Risk
        Scan      = $Scan
        Indicator = $Indicator
        Evidence  = $Evidence
        Path      = $Path
        SHA256    = $Sha256
        Notes     = $Notes
    }
    $script:Findings.Add($finding)

    $rowIndex = $script:ResultGrid.Rows.Add($Risk, $Indicator, $Scan, $Evidence, $Path)
    $row = $script:ResultGrid.Rows[$rowIndex]
    switch ($Risk) {
        'High'   { $row.Cells[0].Style.ForeColor = $script:Colors.Red }
        'Medium' { $row.Cells[0].Style.ForeColor = $script:Colors.Yellow }
        default  { $row.Cells[0].Style.ForeColor = $script:Colors.Cyan }
    }
    $row.Cells[0].Style.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 9)
    $row.Tag = $finding
    $activeFilter = $script:SearchBox.Text.Trim()
    if (-not [string]::IsNullOrWhiteSpace($activeFilter)) {
        $filterText = @($finding.Risk, $finding.Indicator, $finding.Scan, $finding.Evidence, $finding.Path, $finding.Notes) -join ' '
        $row.Visible = ($filterText.IndexOf($activeFilter, [StringComparison]::OrdinalIgnoreCase) -ge 0)
    }
    Update-Counters
    [System.Windows.Forms.Application]::DoEvents()
}

function Clear-Results {
    $script:Findings.Clear()
    $script:CompletedScans.Clear()
    $script:ScannedFiles = 0
    $script:ScannedProcesses = 0
    $script:ResultGrid.Rows.Clear()
    Update-Counters
    Set-Status 'Ready. Choose a scan module.' 'Muted'
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

    $wanted = @('fabric.mod.json', 'quilt.mod.json', 'META-INF/mods.toml', 'META-INF/neoforge.mods.toml', 'META-INF/MANIFEST.MF')
    $parts = [System.Collections.Generic.List[string]]::new()
    $archive = $null
    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
        foreach ($entry in $archive.Entries) {
            $normalized = $entry.FullName.Replace('\', '/')
            if ($wanted -contains $normalized -and $entry.Length -le 1048576) {
                $stream = $entry.Open()
                $reader = [System.IO.StreamReader]::new($stream)
                try { $parts.Add($reader.ReadToEnd()) }
                finally {
                    $reader.Dispose()
                    $stream.Dispose()
                }
            }
        }
    } catch {
        return ''
    } finally {
        if ($null -ne $archive) { $archive.Dispose() }
    }
    return ($parts -join [Environment]::NewLine)
}

function Scan-Processes {
    Set-Status 'Inspecting running processes...' 'Cyan'
    $before = $script:Findings.Count
    try {
        $processes = @(Get-CimInstance Win32_Process -ErrorAction Stop)
        foreach ($process in $processes) {
            $script:ScannedProcesses++
            $text = @($process.Name, $process.ExecutablePath, $process.CommandLine) -join ' '
            foreach ($match in @(Get-IndicatorMatches -Text $text)) {
                $path = [string]$process.ExecutablePath
                Add-Finding -Scan 'Running processes' -Risk $match.Risk -Indicator $match.Name -Evidence ('Process: ' + $process.Name + ' | PID ' + $process.ProcessId) -Path $path -Sha256 (Get-SafeHash -Path $path) -Notes 'Matched process metadata. Review manually.'
            }
            if (($script:ScannedProcesses % 20) -eq 0) {
                Update-Counters
                [System.Windows.Forms.Application]::DoEvents()
            }
        }
    } catch {
        Add-Finding -Scan 'Running processes' -Risk 'Info' -Indicator 'Process scan unavailable' -Evidence $_.Exception.Message -Path '' -Sha256 '' -Notes 'Administrator rights are optional but may reveal more paths.'
    }
    Complete-Scan 'Running processes'
    return ($script:Findings.Count - $before)
}

function Scan-ModFiles {
    param([switch]$DefaultOnly)

    $name = if ($DefaultOnly) { 'Default Minecraft mods' } else { 'All Minecraft instances' }
    Set-Status ('Inspecting ' + $name.ToLowerInvariant() + '...') 'Cyan'
    $before = $script:Findings.Count
    $roots = @(Get-MinecraftRoots)

    if ($DefaultOnly -and $env:APPDATA) {
        $defaultRoot = Join-Path $env:APPDATA '.minecraft'
        $roots = @($roots | Where-Object { $_ -ieq $defaultRoot })
    }

    $directories = @(Get-ModDirectories -Roots $roots -DefaultOnly:$DefaultOnly)
    foreach ($directory in $directories) {
        $files = @(Get-ChildItem -LiteralPath $directory -File -Filter '*.jar' -ErrorAction SilentlyContinue)
        foreach ($file in $files) {
            $script:ScannedFiles++
            $nameMatches = @(Get-IndicatorMatches -Text $file.Name)
            $metadataMatches = @(Get-IndicatorMatches -Text (Read-JarMetadata -Path $file.FullName))
            $matches = @($nameMatches + $metadataMatches | Sort-Object Name -Unique)

            foreach ($match in $matches) {
                $source = if (@($nameMatches | Where-Object { $_.Name -eq $match.Name }).Count -gt 0) { 'Filename match' } else { 'Safe JAR metadata match' }
                Add-Finding -Scan $name -Risk $match.Risk -Indicator $match.Name -Evidence $source -Path $file.FullName -Sha256 (Get-SafeHash -Path $file.FullName) -Notes 'Indicator only; verify manually before taking action.'
            }
            if (($script:ScannedFiles % 15) -eq 0) {
                Update-Counters
                [System.Windows.Forms.Application]::DoEvents()
            }
        }
    }
    Complete-Scan $name
    return ($script:Findings.Count - $before)
}

function Scan-SelectedModFolder {
    param([Parameter(Mandatory)][string]$FolderPath)

    Set-Status ('Scanning selected mod folder: ' + $FolderPath) 'Cyan'
    $before = $script:Findings.Count
    $files = @(Get-ChildItem -LiteralPath $FolderPath -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object { @('.jar', '.zip', '.dll', '.exe') -contains $_.Extension.ToLowerInvariant() } |
        Select-Object -First 10000)

    foreach ($file in $files) {
        $script:ScannedFiles++
        $nameMatches = @(Get-IndicatorMatches -Text ($file.Name + ' ' + $file.Directory.Name))
        $metadataMatches = @()
        if ($file.Extension -ieq '.jar') {
            $metadataMatches = @(Get-IndicatorMatches -Text (Read-JarMetadata -Path $file.FullName))
        }
        $matches = @($nameMatches + $metadataMatches | Sort-Object Name -Unique)
        foreach ($match in $matches) {
            $source = if (@($nameMatches | Where-Object { $_.Name -eq $match.Name }).Count -gt 0) { 'Filename or parent-folder match' } else { 'Safe JAR metadata match' }
            Add-Finding -Scan 'Selected mod folder' -Risk $match.Risk -Indicator $match.Name -Evidence $source -Path $file.FullName -Sha256 (Get-SafeHash -Path $file.FullName) -Notes 'The file was inspected without execution. Verify every finding manually.'
        }
        if (($script:ScannedFiles % 15) -eq 0) {
            Update-Counters
            [System.Windows.Forms.Application]::DoEvents()
        }
    }
    Complete-Scan 'Selected mod folder'
    return ($script:Findings.Count - $before)
}

function Scan-ClientFolders {
    Set-Status 'Inspecting Minecraft client folders and configuration names...' 'Cyan'
    $before = $script:Findings.Count
    $seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

    foreach ($root in @(Get-MinecraftRoots)) {
        $locations = [System.Collections.Generic.List[string]]::new()
        $locations.Add($root)
        foreach ($relative in @('config', 'configs', 'versions', 'mods')) {
            $candidate = Join-Path $root $relative
            if (Test-Path -LiteralPath $candidate -PathType Container) { $locations.Add($candidate) }
        }

        foreach ($location in $locations) {
            try {
                Get-ChildItem -LiteralPath $location -Force -ErrorAction SilentlyContinue |
                    Select-Object -First 2500 | ForEach-Object {
                        $script:ScannedFiles++
                        foreach ($match in @(Get-IndicatorMatches -Text $_.Name)) {
                            $key = $match.Name + '|' + $_.FullName
                            if ($seen.Add($key)) {
                                Add-Finding -Scan 'Client folders' -Risk $match.Risk -Indicator $match.Name -Evidence 'Minecraft folder or configuration name match' -Path $_.FullName -Sha256 $(if (-not $_.PSIsContainer) { Get-SafeHash -Path $_.FullName } else { '' }) -Notes 'Folder and file names are indicators only; review their purpose manually.'
                            }
                        }
                    }
            } catch {
                Add-Finding -Scan 'Client folders' -Risk 'Info' -Indicator 'Location unavailable' -Evidence $_.Exception.Message -Path $location -Sha256 '' -Notes 'No permissions were bypassed.'
            }
        }
    }
    Complete-Scan 'Client folders'
    return ($script:Findings.Count - $before)
}

function Scan-MinecraftLogs {
    Set-Status 'Inspecting recent Minecraft logs for client names...' 'Cyan'
    $before = $script:Findings.Count
    $cutoff = (Get-Date).AddDays(-30)
    $seenLogs = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

    foreach ($root in @(Get-MinecraftRoots)) {
        try {
            $logs = @(Get-ChildItem -LiteralPath $root -File -Recurse -Filter 'latest.log' -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTime -ge $cutoff -and $_.Length -le 15728640 } |
                Select-Object -First 80)
            foreach ($log in $logs) {
                if (-not $seenLogs.Add($log.FullName)) { continue }
                $script:ScannedFiles++
                try {
                    $text = [System.IO.File]::ReadAllText($log.FullName)
                    foreach ($match in @(Get-IndicatorMatches -Text $text)) {
                        Add-Finding -Scan 'Minecraft logs' -Risk $match.Risk -Indicator $match.Name -Evidence 'Client name found in a recent latest.log' -Path $log.FullName -Sha256 (Get-SafeHash -Path $log.FullName) -Notes 'Only the matching client name is reported; log contents stay local.'
                    }
                } catch {}
                [System.Windows.Forms.Application]::DoEvents()
            }
        } catch {
            Add-Finding -Scan 'Minecraft logs' -Risk 'Info' -Indicator 'Logs unavailable' -Evidence $_.Exception.Message -Path $root -Sha256 '' -Notes 'No permissions were bypassed.'
        }
    }
    Complete-Scan 'Minecraft logs'
    return ($script:Findings.Count - $before)
}

function Scan-RecentFiles {
    Set-Status 'Inspecting recent Downloads and Desktop filenames...' 'Cyan'
    $before = $script:Findings.Count
    $cutoff = (Get-Date).AddDays(-30)
    $downloads = Join-Path ([Environment]::GetFolderPath('UserProfile')) 'Downloads'
    $folders = @($downloads, [Environment]::GetFolderPath('Desktop'))
    $extensions = @('.jar', '.exe', '.dll', '.zip', '.rar', '.7z')

    foreach ($folder in $folders) {
        if (-not (Test-Path -LiteralPath $folder -PathType Container)) { continue }
        try {
            Get-ChildItem -LiteralPath $folder -File -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTime -ge $cutoff -and $extensions -contains $_.Extension.ToLowerInvariant() } |
                Select-Object -First 3000 | ForEach-Object {
                    $script:ScannedFiles++
                    foreach ($match in @(Get-IndicatorMatches -Text $_.Name)) {
                        Add-Finding -Scan 'Recent filenames' -Risk $match.Risk -Indicator $match.Name -Evidence 'Filename modified within 30 days' -Path $_.FullName -Sha256 (Get-SafeHash -Path $_.FullName) -Notes 'Only matching filenames are flagged.'
                    }
                    if (($script:ScannedFiles % 20) -eq 0) {
                        Update-Counters
                        [System.Windows.Forms.Application]::DoEvents()
                    }
                }
        } catch {
            Add-Finding -Scan 'Recent filenames' -Risk 'Info' -Indicator 'Folder unavailable' -Evidence $_.Exception.Message -Path $folder -Sha256 '' -Notes 'No permissions were bypassed.'
        }
    }
    Complete-Scan 'Recent filenames'
    return ($script:Findings.Count - $before)
}

function Scan-Prefetch {
    Set-Status 'Inspecting Windows Prefetch filenames...' 'Cyan'
    $before = $script:Findings.Count
    $prefetch = Join-Path $env:SystemRoot 'Prefetch'
    if (Test-Path -LiteralPath $prefetch -PathType Container) {
        try {
            foreach ($file in @(Get-ChildItem -LiteralPath $prefetch -File -Filter '*.pf' -ErrorAction Stop)) {
                foreach ($match in @(Get-IndicatorMatches -Text $file.Name)) {
                    Add-Finding -Scan 'Prefetch filenames' -Risk $match.Risk -Indicator $match.Name -Evidence 'Prefetch filename match' -Path $file.FullName -Sha256 '' -Notes 'May indicate execution; review manually.'
                }
            }
        } catch {
            Add-Finding -Scan 'Prefetch filenames' -Risk 'Info' -Indicator 'Prefetch unavailable' -Evidence $_.Exception.Message -Path $prefetch -Sha256 '' -Notes 'Administrator rights may be required.'
        }
    }
    Complete-Scan 'Prefetch filenames'
    return ($script:Findings.Count - $before)
}

function Verify-OneFile {
    $dialog = [System.Windows.Forms.OpenFileDialog]::new()
    $dialog.Title = 'Select a file to inspect safely'
    $dialog.Filter = 'Supported files|*.jar;*.exe;*.dll;*.zip;*.rar;*.7z|All files|*.*'
    if ($dialog.ShowDialog($script:MainForm) -ne [System.Windows.Forms.DialogResult]::OK) { return }

    Set-Status 'Verifying selected file...' 'Cyan'
    $path = $dialog.FileName
    $file = Get-Item -LiteralPath $path
    $script:ScannedFiles++
    $matches = @(Get-IndicatorMatches -Text $file.Name)
    if ($file.Extension -ieq '.jar') {
        $matches += @(Get-IndicatorMatches -Text (Read-JarMetadata -Path $file.FullName))
    }
    $matches = @($matches | Sort-Object Name -Unique)

    if ($matches.Count -eq 0) {
        Add-Finding -Scan 'Single-file verification' -Risk 'Info' -Indicator 'No known text indicator' -Evidence 'Hashed without execution' -Path $file.FullName -Sha256 (Get-SafeHash -Path $file.FullName) -Notes 'No match does not prove that a file is safe.'
    } else {
        foreach ($match in $matches) {
            Add-Finding -Scan 'Single-file verification' -Risk $match.Risk -Indicator $match.Name -Evidence 'Filename or safe JAR metadata match' -Path $file.FullName -Sha256 (Get-SafeHash -Path $file.FullName) -Notes 'Verify manually before taking action.'
        }
    }
    Complete-Scan 'Single-file verification'
}

function Invoke-UiScan {
    param(
        [string]$Name,
        [scriptblock]$Action
    )

    Clear-Results
    foreach ($button in $script:ActionButtons) { $button.Enabled = $false }
    $script:MainForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $script:Progress.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
    $script:Progress.MarqueeAnimationSpeed = 24
    $script:Progress.Visible = $true

    try {
        & $Action
        Update-Counters
        if ($script:Findings.Count -eq 0) {
            Set-Status ($Name + ' complete - no known indicators found.') 'Green'
        } else {
            Set-Status ($Name + ' complete - review ' + $script:Findings.Count + ' result(s).') 'Yellow'
        }
    } catch {
        Set-Status ('Scan stopped safely: ' + $_.Exception.Message) 'Red'
    } finally {
        $script:Progress.Visible = $false
        $script:Progress.Style = [System.Windows.Forms.ProgressBarStyle]::Blocks
        $script:MainForm.Cursor = [System.Windows.Forms.Cursors]::Default
        foreach ($button in $script:ActionButtons) { $button.Enabled = $true }
    }
}

function Export-Report {
    $desktop = [Environment]::GetFolderPath('Desktop')
    if ([string]::IsNullOrWhiteSpace($desktop)) { $desktop = $env:USERPROFILE }
    $folder = Join-Path $desktop 'Frost SS Tool Reports'
    New-Item -ItemType Directory -Path $folder -Force | Out-Null

    $stamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
    $jsonPath = Join-Path $folder ('Frost-SS-Report_' + $stamp + '.json')
    $htmlPath = Join-Path $folder ('Frost-SS-Report_' + $stamp + '.html')
    $report = [pscustomobject][ordered]@{
        Tool = $script:ToolName
        Version = $script:Version
        CreatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
        CompletedScans = @($script:CompletedScans)
        ClientSignatures = $script:ClientSignatures.Count
        ScannedFiles = $script:ScannedFiles
        ScannedProcesses = $script:ScannedProcesses
        Findings = @($script:Findings)
        Disclaimer = 'Indicators require manual review and are not automatic proof of cheating.'
    }
    $report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonPath -Encoding UTF8

    $rows = [System.Text.StringBuilder]::new()
    foreach ($finding in $script:Findings) {
        $riskColor = if ($finding.Risk -eq 'High') { '#FF657A' } elseif ($finding.Risk -eq 'Medium') { '#FFD166' } else { '#66DEFF' }
        $values = @($finding.Risk, $finding.Indicator, $finding.Scan, $finding.Evidence, $finding.Path, $finding.SHA256)
        $encoded = @($values | ForEach-Object { [System.Net.WebUtility]::HtmlEncode([string]$_) })
        [void]$rows.AppendLine('<tr><td style="color:' + $riskColor + ';font-weight:700">' + $encoded[0] + '</td><td>' + $encoded[1] + '</td><td>' + $encoded[2] + '</td><td>' + $encoded[3] + '</td><td class="path">' + $encoded[4] + '</td><td class="path">' + $encoded[5] + '</td></tr>')
    }
    if ($script:Findings.Count -eq 0) {
        [void]$rows.AppendLine('<tr><td colspan="6" class="clear">No known indicators were found.</td></tr>')
    }

    $html = @"
<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Frost SS Tool Report</title>
<style>body{margin:0;background:#050505;color:#f7f7f7;font-family:Segoe UI,Arial}.wrap{max-width:1400px;margin:auto;padding:32px}h1{color:#fff}.notice{background:#121212;border:1px solid #303030;border-radius:12px;padding:16px;margin:20px 0}table{width:100%;border-collapse:collapse;background:#0a0a0a}th,td{text-align:left;padding:12px;border-bottom:1px solid #303030}th{color:#fff}.path{font:12px Consolas;word-break:break-all}.clear{color:#7ee787;text-align:center;padding:30px}</style></head>
<body><main class="wrap"><h1>Frost SS Tool</h1><p>Local inspection report | Version $($script:Version) | $($script:ClientSignatures.Count) client signatures</p><div class="notice">Findings are indicators for manual review, not automatic proof of cheating. Nothing was uploaded by Frost SS Tool.</div><p>Items checked: $($script:ScannedFiles) &nbsp; Processes checked: $($script:ScannedProcesses) &nbsp; Findings: $($script:Findings.Count)</p><table><thead><tr><th>Risk</th><th>Indicator</th><th>Module</th><th>Evidence</th><th>Path</th><th>SHA-256</th></tr></thead><tbody>$($rows.ToString())</tbody></table></main></body></html>
"@
    [System.IO.File]::WriteAllText($htmlPath, $html, [System.Text.UTF8Encoding]::new($false))
    Start-Process explorer.exe $folder
    [System.Windows.Forms.MessageBox]::Show($script:MainForm, ("Report saved locally to:" + [Environment]::NewLine + $folder), 'Frost SS Tool', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
}

function New-NavButton {
    param(
        [string]$Text,
        [string]$Accent = 'Normal'
    )

    $button = [System.Windows.Forms.Button]::new()
    $button.Text = $Text
    $button.Width = 188
    $button.Height = 42
    $button.Margin = [System.Windows.Forms.Padding]::new(0, 0, 0, 8)
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderSize = 1
    $button.FlatAppearance.BorderColor = $script:Colors.Border
    $button.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 10)
    $button.ForeColor = if ($Accent -eq 'Primary') { $script:Colors.Background } else { $script:Colors.Text }
    $button.BackColor = if ($Accent -eq 'Primary') { $script:Colors.Blue } else { $script:Colors.Panel }
    $button.Tag = $Accent
    $button.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $button.Padding = [System.Windows.Forms.Padding]::new(14, 0, 0, 0)
    $button.Cursor = [System.Windows.Forms.Cursors]::Hand
    $button.Add_MouseEnter({
        if ($this.Enabled) {
            $this.BackColor = $script:Colors.Border
            $this.ForeColor = $script:Colors.Text
        }
    })
    $button.Add_MouseLeave({
        if ([string]$this.Tag -eq 'Primary') {
            $this.BackColor = $script:Colors.Blue
            $this.ForeColor = $script:Colors.Background
        } else {
            $this.BackColor = $script:Colors.Panel
            $this.ForeColor = $script:Colors.Text
        }
    })
    $script:ActionButtons.Add($button)
    return $button
}

function New-StatCard {
    param(
        [string]$Label,
        [ref]$ValueControl
    )

    $panel = [System.Windows.Forms.Panel]::new()
    $panel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $panel.Margin = [System.Windows.Forms.Padding]::new(0, 0, 12, 0)
    $panel.BackColor = $script:Colors.Panel
    $panel.Padding = [System.Windows.Forms.Padding]::new(17, 12, 17, 10)

    $value = [System.Windows.Forms.Label]::new()
    $value.Text = '0'
    $value.Dock = [System.Windows.Forms.DockStyle]::Top
    $value.Height = 39
    $value.ForeColor = $script:Colors.Cyan
    $value.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 22)
    $panel.Controls.Add($value)

    $caption = [System.Windows.Forms.Label]::new()
    $caption.Text = $Label.ToUpperInvariant()
    $caption.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $caption.Height = 22
    $caption.ForeColor = $script:Colors.Muted
    $caption.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 8)
    $panel.Controls.Add($caption)

    $ValueControl.Value = $value
    return $panel
}

$form = [System.Windows.Forms.Form]::new()
$script:MainForm = $form
$form.Text = 'Frost SS Tool'
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.Size = [System.Drawing.Size]::new(1180, 760)
$form.MinimumSize = [System.Drawing.Size]::new(980, 650)
$form.BackColor = $script:Colors.Background
$form.ForeColor = $script:Colors.Text
$form.Font = [System.Drawing.Font]::new('Segoe UI', 9)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.MaximizeBox = $true

$header = [System.Windows.Forms.Panel]::new()
$header.Dock = [System.Windows.Forms.DockStyle]::Top
$header.Height = 76
$header.BackColor = $script:Colors.Surface
$header.Padding = [System.Windows.Forms.Padding]::new(24, 10, 24, 8)
$form.Controls.Add($header)

$brand = [System.Windows.Forms.Label]::new()
$brand.Text = 'FROST SS TOOL'
$brand.AutoSize = $true
$brand.Location = [System.Drawing.Point]::new(24, 13)
$brand.ForeColor = $script:Colors.Text
$brand.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 20)
$header.Controls.Add($brand)

$versionLabel = [System.Windows.Forms.Label]::new()
$versionLabel.Text = ('READ-ONLY MINECRAFT INSPECTION  •  v' + $script:Version + '  •  ' + $script:ClientSignatures.Count + ' CLIENT SIGNATURES')
$versionLabel.AutoSize = $true
$versionLabel.Location = [System.Drawing.Point]::new(27, 47)
$versionLabel.ForeColor = $script:Colors.Muted
$versionLabel.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 8)
$header.Controls.Add($versionLabel)

$liveBadge = [System.Windows.Forms.Label]::new()
$liveBadge.Text = '●  LOCAL ONLY'
$liveBadge.AutoSize = $true
$liveBadge.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$liveBadge.Location = [System.Drawing.Point]::new(1015, 27)
$liveBadge.ForeColor = $script:Colors.Green
$liveBadge.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 9)
$header.Controls.Add($liveBadge)
$header.Add_Resize({ $liveBadge.Left = $header.ClientSize.Width - $liveBadge.Width - 28 })

$sidebar = [System.Windows.Forms.Panel]::new()
$sidebar.Dock = [System.Windows.Forms.DockStyle]::Left
$sidebar.Width = 220
$sidebar.BackColor = $script:Colors.Surface
$sidebar.Padding = [System.Windows.Forms.Padding]::new(16, 22, 16, 16)
$form.Controls.Add($sidebar)

$logo = [System.Windows.Forms.Label]::new()
$logo.Text = 'F'
$logo.Width = 54
$logo.Height = 54
$logo.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$logo.BackColor = $script:Colors.Cyan
$logo.ForeColor = $script:Colors.Background
$logo.Font = [System.Drawing.Font]::new('Segoe UI Black', 25)
$logo.Margin = [System.Windows.Forms.Padding]::new(0, 0, 0, 18)
$sidebar.Controls.Add($logo)

$nav = [System.Windows.Forms.FlowLayoutPanel]::new()
$nav.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
$nav.WrapContents = $false
$nav.AutoScroll = $true
$nav.Location = [System.Drawing.Point]::new(16, 94)
$nav.Size = [System.Drawing.Size]::new(194, 570)
$nav.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$sidebar.Controls.Add($nav)

$folderPickerButton = New-NavButton 'Scan mod folder' 'Primary'
$quickButton = New-NavButton 'Quick scan'
$fullButton = New-NavButton 'Full safe scan'
$modsButton = New-NavButton 'Minecraft files'
$foldersButton = New-NavButton 'Client folders'
$logsButton = New-NavButton 'Minecraft logs'
$processButton = New-NavButton 'Running processes'
$recentButton = New-NavButton 'Recent files'
$prefetchButton = New-NavButton 'Prefetch traces'
$fileButton = New-NavButton 'Verify one file'
$exportButton = New-NavButton 'Export report'
$clearButton = New-NavButton 'Clear results'
@($folderPickerButton, $quickButton, $fullButton, $modsButton, $foldersButton, $logsButton, $processButton, $recentButton, $prefetchButton, $fileButton, $exportButton, $clearButton) | ForEach-Object { [void]$nav.Controls.Add($_) }

$content = [System.Windows.Forms.Panel]::new()
$content.Dock = [System.Windows.Forms.DockStyle]::Fill
$content.BackColor = $script:Colors.Background
$content.Padding = [System.Windows.Forms.Padding]::new(24, 22, 24, 18)
$form.Controls.Add($content)
$content.BringToFront()

$stats = [System.Windows.Forms.TableLayoutPanel]::new()
$stats.Dock = [System.Windows.Forms.DockStyle]::Top
$stats.Height = 91
$stats.ColumnCount = 4
$stats.RowCount = 1
$stats.BackColor = $script:Colors.Background
[void]$stats.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new([System.Windows.Forms.SizeType]::Percent, 25))
[void]$stats.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new([System.Windows.Forms.SizeType]::Percent, 25))
[void]$stats.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new([System.Windows.Forms.SizeType]::Percent, 25))
[void]$stats.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new([System.Windows.Forms.SizeType]::Percent, 25))
$content.Controls.Add($stats)

$findingRef = $null
$fileRef = $null
$processRef = $null
$signatureRef = $null
$stats.Controls.Add((New-StatCard 'Findings' ([ref]$findingRef)), 0, 0)
$stats.Controls.Add((New-StatCard 'Items checked' ([ref]$fileRef)), 1, 0)
$stats.Controls.Add((New-StatCard 'Processes checked' ([ref]$processRef)), 2, 0)
$stats.Controls.Add((New-StatCard 'Client signatures' ([ref]$signatureRef)), 3, 0)
$script:FindingValue = $findingRef
$script:FileValue = $fileRef
$script:ProcessValue = $processRef
$signatureRef.Text = [string]$script:ClientSignatures.Count

$notice = [System.Windows.Forms.Panel]::new()
$notice.Dock = [System.Windows.Forms.DockStyle]::Top
$notice.Height = 52
$notice.Margin = [System.Windows.Forms.Padding]::new(0, 12, 0, 12)
$notice.BackColor = Get-UiColor '#111111'
$notice.Padding = [System.Windows.Forms.Padding]::new(14, 10, 14, 8)
$content.Controls.Add($notice)
$notice.BringToFront()

$noticeText = [System.Windows.Forms.Label]::new()
$noticeText.Text = "PRIVACY  •  Scan only with the computer owner's permission. Results stay on this PC and require manual review."
$noticeText.Dock = [System.Windows.Forms.DockStyle]::Fill
$noticeText.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$noticeText.ForeColor = $script:Colors.Cyan
$noticeText.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 9)
$notice.Controls.Add($noticeText)

$resultHeader = [System.Windows.Forms.Panel]::new()
$resultHeader.Dock = [System.Windows.Forms.DockStyle]::Top
$resultHeader.Height = 48
$resultHeader.Padding = [System.Windows.Forms.Padding]::new(0, 10, 0, 4)
$content.Controls.Add($resultHeader)
$resultHeader.BringToFront()

$resultTitle = [System.Windows.Forms.Label]::new()
$resultTitle.Text = 'Inspection results'
$resultTitle.AutoSize = $true
$resultTitle.Location = [System.Drawing.Point]::new(0, 11)
$resultTitle.ForeColor = $script:Colors.Text
$resultTitle.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 14)
$resultHeader.Controls.Add($resultTitle)

$filterLabel = [System.Windows.Forms.Label]::new()
$filterLabel.Text = 'FILTER'
$filterLabel.AutoSize = $true
$filterLabel.ForeColor = $script:Colors.Muted
$filterLabel.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 8)
$resultHeader.Controls.Add($filterLabel)

$searchBox = [System.Windows.Forms.TextBox]::new()
$script:SearchBox = $searchBox
$searchBox.Width = 220
$searchBox.Height = 28
$searchBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$searchBox.BackColor = $script:Colors.Surface
$searchBox.ForeColor = $script:Colors.Text
$searchBox.Font = [System.Drawing.Font]::new('Segoe UI', 9)
$searchBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$resultHeader.Controls.Add($searchBox)

$resultCount = [System.Windows.Forms.Label]::new()
$script:ResultCount = $resultCount
$resultCount.Text = '0 RESULTS'
$resultCount.AutoSize = $true
$resultCount.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$resultCount.ForeColor = $script:Colors.Muted
$resultCount.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 8)
$resultHeader.Controls.Add($resultCount)
$resultHeader.Add_Resize({
    $searchBox.Left = $resultHeader.ClientSize.Width - $searchBox.Width - 4
    $searchBox.Top = 9
    $filterLabel.Left = $searchBox.Left - $filterLabel.Width - 10
    $filterLabel.Top = 16
    $resultCount.Left = $filterLabel.Left - $resultCount.Width - 18
    $resultCount.Top = 16
})

$bottom = [System.Windows.Forms.Panel]::new()
$bottom.Dock = [System.Windows.Forms.DockStyle]::Bottom
$bottom.Height = 48
$bottom.Padding = [System.Windows.Forms.Padding]::new(0, 10, 0, 0)
$content.Controls.Add($bottom)

$statusLabel = [System.Windows.Forms.Label]::new()
$script:StatusLabel = $statusLabel
$statusLabel.Text = 'Ready. Choose a scan module.'
$statusLabel.Dock = [System.Windows.Forms.DockStyle]::Fill
$statusLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLabel.ForeColor = $script:Colors.Muted
$statusLabel.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 9)
$bottom.Controls.Add($statusLabel)

$progress = [System.Windows.Forms.ProgressBar]::new()
$script:Progress = $progress
$progress.Dock = [System.Windows.Forms.DockStyle]::Right
$progress.Width = 190
$progress.Style = [System.Windows.Forms.ProgressBarStyle]::Blocks
$progress.Visible = $false
$bottom.Controls.Add($progress)
$progress.BringToFront()

$grid = [System.Windows.Forms.DataGridView]::new()
$script:ResultGrid = $grid
$grid.Dock = [System.Windows.Forms.DockStyle]::Fill
$grid.BackgroundColor = $script:Colors.Surface
$grid.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$grid.GridColor = $script:Colors.Border
$grid.EnableHeadersVisualStyles = $false
$grid.ColumnHeadersDefaultCellStyle.BackColor = $script:Colors.Panel
$grid.ColumnHeadersDefaultCellStyle.ForeColor = $script:Colors.Cyan
$grid.ColumnHeadersDefaultCellStyle.Font = [System.Drawing.Font]::new('Segoe UI Semibold', 9)
$grid.ColumnHeadersDefaultCellStyle.SelectionBackColor = $script:Colors.Panel
$grid.ColumnHeadersHeight = 40
$grid.RowHeadersVisible = $false
$grid.RowTemplate.Height = 38
$grid.DefaultCellStyle.BackColor = $script:Colors.Surface
$grid.DefaultCellStyle.ForeColor = $script:Colors.Text
$grid.DefaultCellStyle.SelectionBackColor = $script:Colors.Border
$grid.DefaultCellStyle.SelectionForeColor = $script:Colors.Text
$grid.DefaultCellStyle.Font = [System.Drawing.Font]::new('Segoe UI', 9)
$grid.AlternatingRowsDefaultCellStyle.BackColor = Get-UiColor '#0F0F0F'
$grid.ReadOnly = $true
$grid.AllowUserToAddRows = $false
$grid.AllowUserToDeleteRows = $false
$grid.AllowUserToResizeRows = $false
$grid.MultiSelect = $false
$grid.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$grid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
[void]$grid.Columns.Add('Risk', 'RISK')
[void]$grid.Columns.Add('Indicator', 'INDICATOR')
[void]$grid.Columns.Add('Module', 'MODULE')
[void]$grid.Columns.Add('Evidence', 'EVIDENCE')
[void]$grid.Columns.Add('Path', 'PATH')
$grid.Columns[0].FillWeight = 50
$grid.Columns[1].FillWeight = 95
$grid.Columns[2].FillWeight = 90
$grid.Columns[3].FillWeight = 130
$grid.Columns[4].FillWeight = 190
$content.Controls.Add($grid)
$grid.BringToFront()

$searchBox.Add_TextChanged({
    $query = $searchBox.Text.Trim()
    $grid.ClearSelection()
    foreach ($row in $grid.Rows) {
        if ([string]::IsNullOrWhiteSpace($query)) {
            $row.Visible = $true
            continue
        }
        $finding = $row.Tag
        $text = if ($null -ne $finding) { @($finding.Risk, $finding.Indicator, $finding.Scan, $finding.Evidence, $finding.Path, $finding.Notes) -join ' ' } else { '' }
        $row.Visible = ($text.IndexOf($query, [StringComparison]::OrdinalIgnoreCase) -ge 0)
    }
})

$folderPickerButton.Add_Click({
    $dialog = [System.Windows.Forms.FolderBrowserDialog]::new()
    $dialog.Description = 'Select the Minecraft mods folder to inspect'
    $dialog.ShowNewFolderButton = $false
    if ($dialog.ShowDialog($script:MainForm) -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFolder = $dialog.SelectedPath
        Invoke-UiScan 'Selected mod folder scan' { [void](Scan-SelectedModFolder -FolderPath $selectedFolder) }
    }
})
$quickButton.Add_Click({
    Invoke-UiScan 'Quick scan' {
        [void](Scan-Processes)
        [void](Scan-ModFiles -DefaultOnly)
        [void](Scan-ClientFolders)
    }
})
$fullButton.Add_Click({
    Invoke-UiScan 'Full safe scan' {
        [void](Scan-Processes)
        [void](Scan-ModFiles)
        [void](Scan-ClientFolders)
        [void](Scan-MinecraftLogs)
        [void](Scan-RecentFiles)
        [void](Scan-Prefetch)
    }
})
$modsButton.Add_Click({ Invoke-UiScan 'Minecraft files scan' { [void](Scan-ModFiles) } })
$foldersButton.Add_Click({ Invoke-UiScan 'Client folders scan' { [void](Scan-ClientFolders) } })
$logsButton.Add_Click({ Invoke-UiScan 'Minecraft logs scan' { [void](Scan-MinecraftLogs) } })
$processButton.Add_Click({ Invoke-UiScan 'Process scan' { [void](Scan-Processes) } })
$recentButton.Add_Click({ Invoke-UiScan 'Recent files scan' { [void](Scan-RecentFiles) } })
$prefetchButton.Add_Click({ Invoke-UiScan 'Prefetch scan' { [void](Scan-Prefetch) } })
$fileButton.Add_Click({
    Clear-Results
    Verify-OneFile
    if ($script:CompletedScans.Contains('Single-file verification')) {
        if ($script:Findings.Count -eq 1 -and $script:Findings[0].Risk -eq 'Info') {
            Set-Status 'File checked - no known text indicator found.' 'Green'
        } else {
            Set-Status 'File checked - review the result.' 'Yellow'
        }
    }
})
$exportButton.Add_Click({
    try { Export-Report }
    catch { [System.Windows.Forms.MessageBox]::Show($script:MainForm, $_.Exception.Message, 'Export failed', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null }
})
$clearButton.Add_Click({ Clear-Results })

$grid.Add_CellDoubleClick({
    param($sender, $eventArgs)
    if ($eventArgs.RowIndex -lt 0) { return }
    $finding = $sender.Rows[$eventArgs.RowIndex].Tag
    if ($null -ne $finding -and -not [string]::IsNullOrWhiteSpace([string]$finding.Path)) {
        $target = [string]$finding.Path
        if (Test-Path -LiteralPath $target -PathType Leaf) {
            Start-Process explorer.exe ('/select,"' + $target + '"')
        } elseif (Test-Path -LiteralPath $target -PathType Container) {
            Start-Process explorer.exe $target
        }
    }
})

Update-Counters
[void]$form.ShowDialog()
