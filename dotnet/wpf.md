# .NET WPF Application Policy

## Required

- Keep view models free of file, directory, and network I/O. A view model calls
  an application service; it does not call `File`, `Directory`, filesystem
  `Path` operations, or infrastructure clients directly.
- Do not let the UI own flow orchestration or business rules. Execution order,
  persistence, and domain decisions live in a lower layer; the view and view
  model present and request, they do not decide.
- Expose dialogs, dispatchers, and other interactive effects as ports that a
  view model depends on through an interface. The WPF implementation of a port
  is registered at the composition root, not created inside a view model.
- Keep the composition root thin. `App` starts the application, builds the
  service graph, and assigns the root view model; it contains no business logic.
- Keep view models testable without a dispatcher or a window: unit-test state and
  commands against fake ports.
- Keep charts read-only and presentation-only. A chart renders values supplied by
  a view model or service; it does not recompute, repair, or judge them. A review
  tool must not let a chart imply a pass/fail decision.

## Preferred

- Use the MVVM folder layout: `Views/`, `ViewModels/`, `Models/`, `Services/`,
  `Converters/`, `Resources/`; only `App.xaml` and `App.xaml.cs` sit at the
  project root. Place `MainWindow` under `Views/`, pair each
  `Views/<Feature>View.xaml` with `ViewModels/<Feature>ViewModel.cs`, suffix
  reusable controls `Control`, and keep converters and resources inside their
  folders. New files land in one of the six folders; add feature subfolders only
  when a folder outgrows flat browsing.
- Use LiveCharts2 (`LiveChartsCore.SkiaSharpView.WPF`, 2.0.x, MIT) for data
  charts. Add it only when a chart is actually needed, pin it centrally, and
  review its transitive SkiaSharp native dependency as part of the package
  review. Do not mix a second charting library into the same project without a
  recorded reason.
- Add a guard test per layering rule (view models contain no `File.`/`Directory.`
  and no dialog namespace; the composition root registers only the owner
  extensions) so the boundary fails a build instead of relying on memory.
- Keep view models small and focused; move repeated presentation mapping into a
  plain, framework-neutral helper that both the UI and other tools can share.

## Observed: Pulse and OpenTest baselines

Pulse's WPF layer refactor moved orchestration and I/O out of view models,
removed DevExpress MVVM code generators from the runtime layer, and added
architecture guard tests for each boundary. OpenTest.Algorithms then built a WPF
result-explanation workbench whose first cut put file I/O and `OpenFileDialog`
directly in the view model, which motivated this standard.

## Review checklist

Confirm view models perform no I/O and reference no dialog namespace; execution
orchestration lives below the UI; interactive effects are ports; the composition
root only wires owners; files follow the six-folder layout; charts are read-only
and any charting package is pinned and license-reviewed; and a guard test covers
each boundary.
