[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$RepositoryRoot = [System.IO.Path]::GetFullPath($RepositoryRoot)
$allowedLedgerStatuses = @('Proposed', 'Under Review', 'Accepted', 'Rejected', 'Deferred', 'Implemented')

function Test-SkillFrontmatter {
    param([string]$Path)

    $content = Get-Content -LiteralPath $Path -Raw
    $match = [regex]::Match($content, '\A---\r?\n(?<frontmatter>.*?)\r?\n---\r?\n', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $match.Success) {
        throw "Skill frontmatter is missing or malformed: $Path"
    }

    $frontmatter = $match.Groups['frontmatter'].Value
    foreach ($field in @('name', 'description')) {
        if ($frontmatter -notmatch "(?m)^${field}:\s*.+$") {
            throw "Skill frontmatter is missing '$field': $Path"
        }
    }
}

function Test-MarkdownLinks {
    param([string]$Path)

    $content = Get-Content -LiteralPath $Path -Raw
    $matches = [regex]::Matches($content, '\[[^\]]+\]\((?<target>[^)#]+)(?:#[^)]+)?\)')
    foreach ($match in $matches) {
        $target = $match.Groups['target'].Value.Trim()
        if ([string]::IsNullOrWhiteSpace($target) -or $target -match '^[a-z][a-z0-9+.-]*:' -or $target.StartsWith('/')) {
            continue
        }

        $resolved = Join-Path (Split-Path -Parent $Path) $target
        if (-not (Test-Path -LiteralPath $resolved)) {
            throw "Markdown link target does not exist: $Path -> $target"
        }
    }
}

$skills = Get-ChildItem -LiteralPath $RepositoryRoot -Recurse -File -Filter 'SKILL.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }
if ($skills.Count -eq 0) {
    throw "No SKILL.md files found under $RepositoryRoot"
}

foreach ($skill in $skills) {
    Test-SkillFrontmatter -Path $skill.FullName
}

$markdownFiles = Get-ChildItem -LiteralPath $RepositoryRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }
foreach ($markdownFile in $markdownFiles) {
    Test-MarkdownLinks -Path $markdownFile.FullName
}

$ledger = Join-Path $RepositoryRoot 'improvement-ledger.md'
if (-not (Test-Path -LiteralPath $ledger)) {
    throw "Improvement ledger is missing: $ledger"
}

$ledgerStatuses = Select-String -LiteralPath $ledger -Pattern '^\s*- \*\*Status:\*\*\s*(?<status>.+?)\s*$' |
    ForEach-Object { $_.Matches[0].Groups['status'].Value }
foreach ($status in $ledgerStatuses) {
    if ($status -notin $allowedLedgerStatuses) {
        throw "Invalid improvement-ledger status '$status'. Allowed values: $($allowedLedgerStatuses -join ', ')"
    }
}

$templateValidator = Join-Path $RepositoryRoot 'scripts/Test-StandardsTemplates.ps1'
& $templateValidator
if (-not $?) {
    throw 'Template validation failed.'
}

Write-Host "Validated Skills, Markdown links, ledger statuses, and .NET templates."
