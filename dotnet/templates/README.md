# .NET Template Adoption

Copy the template files to the solution root before adding project-specific
entries. Put package versions in `Directory.Packages.props`, add nullable and
other build-wide properties to `Directory.Build.props`, and keep IDE format
preferences in `.editorconfig`.

To add a private feed, declare its source under `packageSources`, then add a
mapping with exactly the same `key` under `packageSourceMapping`. Configure
credentials outside this repository. Run the repository validator after every
source-mapping change:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-StandardsTemplates.ps1
```
