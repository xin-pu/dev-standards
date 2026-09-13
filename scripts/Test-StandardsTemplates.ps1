[CmdletBinding()]
param(
    [string]$TemplatesRoot
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($TemplatesRoot)) {
    $TemplatesRoot = Join-Path $repositoryRoot 'dotnet/templates'
}

$templatesRoot = [System.IO.Path]::GetFullPath($TemplatesRoot)
$nugetConfig = Join-Path $templatesRoot 'nuget.config'
$packagesProps = Join-Path $templatesRoot 'Directory.Packages.props'
$buildProps = Join-Path $templatesRoot 'Directory.Build.props'

foreach ($path in @($nugetConfig, $packagesProps, $buildProps)) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Required template is missing: $path"
    }

    try {
        [xml](Get-Content -LiteralPath $path -Raw) | Out-Null
    }
    catch {
        throw "Template XML is invalid: $path. $($_.Exception.Message)"
    }
}

[xml]$config = Get-Content -LiteralPath $nugetConfig -Raw
$sourceKeys = @($config.configuration.packageSources.add | ForEach-Object { $_.key })
$mappingKeys = @($config.configuration.packageSourceMapping.packageSource | ForEach-Object { $_.key })
$missingKeys = @($mappingKeys | Where-Object { $_ -notin $sourceKeys })

if ($missingKeys.Count -gt 0) {
    throw "NuGet source mapping keys are not configured sources: $($missingKeys -join ', ')"
}

Write-Host "Validated .NET templates and NuGet source mappings."
