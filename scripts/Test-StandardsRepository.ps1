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
    Where-Object {
        $_.FullName -notmatch '[\\/]\.git[\\/]' -and
        $_.FullName -notmatch '[\\/]docs[\\/]superpowers[\\/]'
    }
foreach ($markdownFile in $markdownFiles) {
    Test-MarkdownLinks -Path $markdownFile.FullName
}

$ledger = Join-Path $RepositoryRoot 'improvement-ledger.md'
if (-not (Test-Path -LiteralPath $ledger)) {
    throw "Improvement ledger is missing: $ledger"
}

$ledgerContent = Get-Content -LiteralPath $ledger -Raw
$entries = [regex]::Matches($ledgerContent, '(?ms)^### (?<id>DS-\d{4}-\d{3})\b.*?(?=^### |\z)')
$entryIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$requiredFields = @('Status', 'Proposed on', 'Scope', 'Proposal', 'Evidence', 'Expected benefit', 'Costs and risks', 'Affected standards', 'Decision', 'Decision rationale', 'Implementation link', 'Review again')

foreach ($entry in $entries) {
    $entryId = $entry.Groups['id'].Value
    if (-not $entryIds.Add($entryId)) {
        throw "Duplicate improvement-ledger entry ID: $entryId"
    }

    foreach ($field in $requiredFields) {
        if ($entry.Value -notmatch "(?m)^- \*\*${field}:\*\*\s*.+$") {
            throw "Improvement-ledger entry $entryId is missing required field: $field"
        }
    }

    $statusMatch = [regex]::Match($entry.Value, '(?m)^- \*\*Status:\*\*\s*(?<status>.+?)\s*$')
    $status = $statusMatch.Groups['status'].Value
    if ($status -notin $allowedLedgerStatuses) {
        throw "Invalid improvement-ledger status '$status' in $entryId. Allowed values: $($allowedLedgerStatuses -join ', ')"
    }

    if ($status -in @('Accepted', 'Rejected', 'Deferred', 'Implemented')) {
        $decision = [regex]::Match($entry.Value, '(?m)^- \*\*Decision:\*\*\s*(?<value>.+?)\s*$').Groups['value'].Value
        $rationale = [regex]::Match($entry.Value, '(?m)^- \*\*Decision rationale:\*\*\s*(?<value>.+?)\s*$').Groups['value'].Value
        if ($decision -match '^Pending' -or $rationale -match '^Pending') {
            throw "Finalized improvement-ledger entry $entryId cannot retain a pending decision or rationale."
        }
    }

    if ($status -eq 'Implemented') {
        $implementation = [regex]::Match($entry.Value, '(?m)^- \*\*Implementation link:\*\*\s*(?<value>.+?)\s*$').Groups['value'].Value
        if ($implementation -match '^(Pending|Not applicable)') {
            throw "Implemented improvement-ledger entry $entryId must link to its implementation."
        }
    }
}

$templateValidator = Join-Path $RepositoryRoot 'scripts/Test-StandardsTemplates.ps1'
& $templateValidator
if (-not $?) {
    throw 'Template validation failed.'
}

Write-Host "Validated Skills, Markdown links, ledger statuses, and .NET templates."
