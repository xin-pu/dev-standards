$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot 'scripts/Test-StandardsRepository.ps1'

if (-not (Test-Path -LiteralPath $validator)) {
    throw "Repository validator is missing: $validator"
}

& $validator -RepositoryRoot $repositoryRoot
if (-not $?) {
    throw 'Repository validator failed.'
}

$temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("dev-standards-ledger-test-" + [guid]::NewGuid())
try {
    New-Item -ItemType Directory -Path $temporaryRoot | Out-Null
    Get-ChildItem -LiteralPath $repositoryRoot -Force |
        Where-Object { $_.Name -ne '.git' } |
        Copy-Item -Destination $temporaryRoot -Recurse -Force

    $temporaryLedger = Join-Path $temporaryRoot 'improvement-ledger.md'
    $content = Get-Content -LiteralPath $temporaryLedger -Raw
    $firstEntry = $content.IndexOf('### DS-2026-001', [System.StringComparison]::Ordinal)
    if ($firstEntry -lt 0) {
        throw 'Test fixture does not contain DS-2026-001.'
    }

    $prefix = $content.Substring(0, $firstEntry)
    $entryAndRemainder = $content.Substring($firstEntry)
    $entryAndRemainder = ([regex]::new('(?m)^- \*\*Decision rationale:\*\*.*\r?\n')).Replace($entryAndRemainder, '', 1)
    $content = $prefix + $entryAndRemainder
    Set-Content -LiteralPath $temporaryLedger -Value $content -NoNewline

    $validationFailed = $false
    try {
        & $validator -RepositoryRoot $temporaryRoot
    }
    catch {
        $validationFailed = $true
        if ($_.Exception.Message -notmatch 'Decision rationale') {
            throw "Repository validator did not identify the missing decision rationale. Output: $($_.Exception.Message)"
        }
    }

    if (-not $validationFailed) {
        throw 'Repository validator accepted an entry without a decision rationale.'
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryRoot) {
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}
