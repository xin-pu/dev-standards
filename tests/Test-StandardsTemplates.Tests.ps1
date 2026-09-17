$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot 'scripts/Test-StandardsTemplates.ps1'

if (-not (Test-Path -LiteralPath $validator)) {
    throw "Template validator is missing: $validator"
}

& $validator
if (-not $?) {
    throw 'Template validator failed.'
}

$temporaryRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("dev-standards-test-" + [guid]::NewGuid())
try {
    New-Item -ItemType Directory -Path $temporaryRoot | Out-Null
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'dotnet/templates') -Destination $temporaryRoot -Recurse
    $temporaryTemplates = Join-Path $temporaryRoot 'templates'
    $temporaryNugetConfig = Join-Path $temporaryTemplates 'nuget.config'
    $temporaryBuildProps = Join-Path $temporaryTemplates 'Directory.Build.props'
    $content = Get-Content -LiteralPath $temporaryNugetConfig -Raw
    $content = $content.Replace('<packageSource key="nuget.org">', '<packageSource key="missing-source">')
    Set-Content -LiteralPath $temporaryNugetConfig -Value $content -NoNewline

    try {
        & $validator -TemplatesRoot $temporaryTemplates
        throw 'Template validator accepted a mapping for an undeclared source.'
    }
    catch {
        if ($_.Exception.Message -notmatch 'missing-source') {
            throw "Template validator did not report the undeclared source. Output: $($_.Exception.Message)"
        }
    }

    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'dotnet/templates/nuget.config') -Destination $temporaryNugetConfig -Force
    $buildContent = Get-Content -LiteralPath $temporaryBuildProps -Raw
    $buildContent = $buildContent.Replace('<CompilerVisibleProperty Include="RootNamespace" />', '')
    Set-Content -LiteralPath $temporaryBuildProps -Value $buildContent -NoNewline

    $rejectedMissingRootNamespace = $false
    try {
        & $validator -TemplatesRoot $temporaryTemplates
    }
    catch {
        if ($_.Exception.Message -match 'RootNamespace') {
            $rejectedMissingRootNamespace = $true
        }
        else {
            throw "Template validator did not report the missing compiler-visible RootNamespace. Output: $($_.Exception.Message)"
        }
    }
    if (-not $rejectedMissingRootNamespace) {
        throw 'Template validator accepted a build template without RootNamespace compiler visibility.'
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryRoot) {
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}
