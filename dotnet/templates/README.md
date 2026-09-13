# .NET Template Adoption

Copy the template files to the solution root before adding project-specific
entries. Put package versions in `Directory.Packages.props`, add nullable and
other build-wide properties to `Directory.Build.props`, and keep IDE format
preferences in `.editorconfig`.

The template enables build-time namespace validation. Set each project's
`RootNamespace` explicitly when it must differ from the project name, then keep
each non-generated C# file's namespace equal to that root plus its physical
project-relative folder path.

To add a private feed, declare its source under `packageSources`, then add a
mapping with exactly the same `key` under `packageSourceMapping`. Configure
credentials outside this repository. Run the repository validator after every
source-mapping change:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-StandardsTemplates.ps1
```
