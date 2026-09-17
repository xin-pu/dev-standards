$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot 'project-adoption/templates/scripts/Test-ProjectDocuments.ps1'

if (-not (Test-Path -LiteralPath $validator)) {
    throw "Project-document validator is missing: $validator"
}

$temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("project-documents-test-" + [guid]::NewGuid())
try {
    New-Item -ItemType Directory -Path $temporaryRoot | Out-Null
    Copy-Item -Path (Join-Path $repositoryRoot 'project-adoption/templates/*') -Destination $temporaryRoot -Recurse

    $standardsReference = Join-Path $temporaryRoot 'docs/standards-reference.md'
    $referenceContent = Get-Content -LiteralPath $standardsReference -Raw
    $referenceContent = $referenceContent.Replace('REPLACE_WITH_COMMIT_SHA', '0123456789abcdef')
    $referenceContent = $referenceContent.Replace('YYYY-MM-DD', '2026-09-17')
    Set-Content -LiteralPath $standardsReference -Value $referenceContent -NoNewline

    & $validator -RepositoryRoot $temporaryRoot
    if (-not $?) {
        throw 'Project-document validator failed for a complete adopted template.'
    }

    Remove-Item -LiteralPath $standardsReference -Force
    $rejectedMissingStandardsReference = $false
    try {
        & $validator -RepositoryRoot $temporaryRoot
    }
    catch {
        if ($_.Exception.Message -match 'standards-reference\.md') {
            $rejectedMissingStandardsReference = $true
        }
        else {
            throw "Project-document validator did not report the missing standards reference. Output: $($_.Exception.Message)"
        }
    }
    if (-not $rejectedMissingStandardsReference) {
        throw 'Project-document validator accepted a project without standards-reference.md.'
    }

    $standardsReferenceContent = $referenceContent
    Set-Content -LiteralPath $standardsReference -Value $standardsReferenceContent -NoNewline
    $projectLedger = Join-Path $temporaryRoot 'docs/ledger/project-improvements.md'
    Set-Content -LiteralPath $projectLedger -Value "### PL-2026-001 - Missing status`n`n- **Recorded on:** 2026-09-17" -NoNewline
    $rejectedMissingLedgerStatus = $false
    try {
        & $validator -RepositoryRoot $temporaryRoot
    }
    catch {
        if ($_.Exception.Message -match 'Project ledger entry.*Status') {
            $rejectedMissingLedgerStatus = $true
        }
        else {
            throw "Project-document validator did not report the missing ledger status. Output: $($_.Exception.Message)"
        }
    }
    if (-not $rejectedMissingLedgerStatus) {
        throw 'Project-document validator accepted a project ledger entry without Status.'
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryRoot) {
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}
