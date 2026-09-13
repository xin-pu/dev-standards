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
