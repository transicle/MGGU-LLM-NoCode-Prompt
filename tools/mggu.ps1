function info($msg) { Write-Host "  › $msg" -ForegroundColor Cyan }
function err($msg)  { Write-Host "  ✗ $msg" -ForegroundColor Red; exit 1 }

$url = "https://raw.githubusercontent.com/transicle/MGGU-LLM-NoCode-Prompt/refs/heads/main/SKILL.md"
$workspace = $PWD

Write-Host "`nInstalling Copilot skill`n" -ForegroundColor White

info "Getting skill from repo..."
$content = Invoke-RestMethod -Uri $url

$skillName = ($content -split "`n" | Select-String -Pattern '^name:\s*(.+)' |
    Select-Object -First 1).Matches[0].Groups[1].Value.Trim()

if (-not $skillName) { err "Could not find 'name:' in skill frontmatter." }

$target = Join-Path $workspace ".github\skills\$skillName\SKILL.md"
if (Test-Path $target) { err "Skill '$skillName' already exists." }

info "Saving as a new Copilot skill..."
New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
Set-Content -Path $target -Value $content -NoNewline

Write-Host "`nDone! " -ForegroundColor Green -NoNewline
Write-Host "New Copilot skill " -NoNewline
Write-Host $skillName -ForegroundColor Cyan -NoNewline
Write-Host " installed.`n"
