
# Implementation Plan — Analysis & Visualisation

This document contains the expanded, capsule-style implementation plan for the Live Analysis Backbone, Session Review Experience, Advanced Analytics & Detection, and supporting tooling/QA. It is intended for multiple agents to work in parallel.

> NOTE: This file is derived from the project docs and the requested expansion. It enumerates tasks (capsules), subtasks, file targets, APIs, acceptance criteria, tests, run commands and parallelization recommendations.

---

## Assumptions

- UI downsample default: `125 Hz` (configurable). Keep the original `samplingRate` attached to raw events when available.
- HP filter cutoff: `0.5 Hz` for baseline removal.
- Ring buffer capacity: default ~10k samples (configurable by constructor).
- Use existing `drift` DB and `Riverpod` provider patterns. New services supply providers in `lib/src/providers/`.
- Chart libraries (Syncfusion) are gated behind feature flags if license control required.

---

## Summary mapping (requirements → tasks)

- Live Analysis Backbone (1.1–1.5) → Tasks 1–5
- Session Review Experience (2.1–2.5) → Tasks 6–10
- Advanced Analytics & Detection (3.1–3.4) → Tasks 11–14
- Tooling, Integration, QA (4.1–4.5) → Tasks 15–19

---

## Capsule Tasks (parallelizable)

### 1) Stabilise live data pipeline (Task 1)

Goal

- Reliable ingestion and processing of raw events into timestamped ring buffers; isolate-based processing (downsample, HP filter), R-peak pre-detection, artefact flagging; expose streams via providers.

Files to create/edit

- `lib/src/services/processing/ring_buffer.dart`
- `lib/src/services/processing/ecg_pipeline.dart`
- `lib/src/services/processing/processor_isolate.dart`
- `lib/src/services/processing/filters.dart`
- `lib/src/services/processing/artifact_detector.dart`
- `lib/src/services/processing/persistence_sink.dart` (optional for test harness)
- `lib/src/providers/data_providers.dart` (add processed stream providers)
- `lib/src/services/ble/polar_ble_service.dart` (ingest hooks)

Subtasks

1. Design a typed ring buffer with `push`, `readNewest`, `length`, and `clear`.
2. Add ingestion adaptor in `polar_ble_service` to forward raw events to the pipeline.
3. Implement `ProcessorIsolate` entry that: normalizes values, applies HP filter (0.5 Hz), downsamples to UI rate (default 125 Hz), performs lightweight R-peak pre-detection, and detects artefacts (clipping / flatline / high-slope).
4. Expose Riverpod providers: `processedEcgStreamProvider`, `rPeaksProvider`, `artefactFlagsProvider`.
5. Add an in-memory persistence sink for tests.

Acceptance criteria

- Latency from raw ingestion to processed chunk available < 100 ms for typical chunk sizes.
- Artefact flags are emitted for injected synthetic signals.
- Unit tests: ring buffer, filter, artifact detector pass.

Tests

- `test/processing/ring_buffer_test.dart`
- `test/processing/processor_isolate_test.dart`

Example run commands (PowerShell):

```powershell
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test test/processing/ring_buffer_test.dart
```

Parallelization notes

- Agent A: ring buffer + tests
- Agent B: processor isolate + filters
- Agent C: provider wiring + `polar_ble_service` hooks
- Agent D: persistence sink + tests

---

### 2) CustomPainter ECG strip (Task 2)

Goal

- High-performance `CustomPainter` ECG strip with 8s window, gain controls, soft clipping, R-peak + artefact overlays, offscreen redraw using `ui.Picture` or similar.

Files

- `lib/src/features/live/widgets/ecg_strip.dart`
- `lib/src/features/live/ecg_view.dart`

Subtasks

1. Build widget skeleton and `EcgStripController` (pause, resume, setGain).
2. Implement double-buffer / offscreen drawing; only redraw the new right-edge region.
3. Add soft-clipping (smooth limiter) and draw overlays (R-peaks as dots, artefact regions as bands).
4. Add widget tests and golden images.

Acceptance

- Smooth scrolling at 60 fps with 125Hz downsample on development device (manual smoke test).
- Golden tests for multiple gains pass.

Tests

- `test/widgets/ecg_strip_widget_test.dart`
- `test/goldens/ecg_strip_gain1.png` (baseline)

Run:

```powershell
flutter test test/widgets/ecg_strip_widget_test.dart
```

Parallelization

- Agent A: widget skeleton + controller
- Agent B: painting engine (offscreen buffer)
- Agent C: overlays + golden tests

---

### 3) Live tachogram chart (Syncfusion) (Task 3)

Goal

- 120s sliding tachogram line chart, using `ChartSeriesController.updateDataSource()` for live updates and exposing brush-to-zoom viewport events.

Files

- `lib/src/features/live/widgets/tachogram.dart`
- `lib/src/features/common/viewport_provider.dart`

Subtasks

1. Implement `TachogramDataSource` that buffers RR pairs and calls `updateDataSource`.
2. Hook chart brushing/selection to emit `ViewportEvent(startMs, endMs)` via provider.
3. Add integration test with fake RR stream.

Acceptance

- Chart updates smoothly without flicker; brush emits viewport events consumed by another widget.

Tests

- `test/integration/tachogram_integration_test.dart`

Run:

```powershell
flutter test test/integration/tachogram_integration_test.dart
```

Notes

- If Syncfusion licensing is an issue in CI, provide an `fl_chart` fallback behind a feature flag.

Parallelization

- Agent A: data source + provider
- Agent B: chart widget + brushing

---

### 4) HR dashboard tile & alerts (Task 4)

Goal

- Tile showing current BPM, 60s sparkline and zone gauge; generate alerts (zone changes, contact loss); persist events.

Files

- `lib/src/features/live/widgets/hr_tile.dart`
- `lib/src/services/alerts_service.dart`
- `lib/src/services/analysis/heart_rate_zones.dart`
- `lib/src/data/repositories/drift_annotation_repository.dart` (extend)

Subtasks

1. Implement zone logic and transition detection.
2. Build HR tile UI with sparkline and gauge (Syncfusion or simple custom gauge).
3. Alert service: show toasts and persist annotation to DB.

Acceptance

- Zone transition produces persistent event and immediate toast UI.
- Unit tests for zone logic.

Tests

- `test/services/heart_rate_zone_test.dart`

Run:

```powershell
flutter test test/services/heart_rate_zone_test.dart
```

Parallelization

- Agent A: zone logic + tests
- Agent B: widget + UI tests
- Agent C: alert persistence

---

### 5) Live Poincaré trail prototype (Task 5)

Goal

- Rolling scatter of 200 RR pairs, point decay, SD1/SD2 computed in isolate.

Files

- `lib/src/services/processing/poincare_service.dart`
- `lib/src/features/live/widgets/poincare_trail.dart`

Subtasks

1. Implement Poincaré isolate computing (x,y) pairs and SD1/SD2.
2. Draw points with age-based alpha decay.
3. Add telemetry (render latency, point counts).

Acceptance

- SD1/SD2 results match formula for test sequences; UI shows decaying points.

Tests

- `test/services/poincare_service_test.dart`

Run:

```powershell
flutter test test/services/poincare_service_test.dart
```

Parallelization

- Agent A: compute isolate & unit tests
- Agent B: widget & perf telemetry

---

### 6) Session overview scaffold (Task 6)

Goal

- Screen with synced HR trend, RR tachogram, artefact heatmap and event timeline using a shared viewport provider.

Files

- `lib/src/features/session/session_overview.dart`
- `lib/src/features/session/artefact_heatmap.dart`
- `lib/src/features/session/event_timeline.dart`

Subtasks

1. Build scaffold & layout.
2. Hook charts to shared `ViewportProvider`.
3. Render artefact heatmap and event timeline reading from annotation repository.

Acceptance

- Selecting a range on timeline updates other charts' visible range.

Tests

- `test/widgets/session_overview_test.dart`

Run:

```powershell
flutter test test/widgets/session_overview_test.dart
```

Parallelization

- Chart components, timeline and heatmap can be implemented in parallel once provider exists.

---

### 7) Segment brushing -> ECG replay (Task 7)

Goal

- Brushing a time range triggers replayed ECG from storage and highlights selection across charts.

Files

- `lib/src/features/session/segment_brush.dart`
- `lib/src/data/repositories/drift_sample_repository.dart` (add `streamEcgForInterval`)
- Reuse `lib/src/features/live/widgets/ecg_strip.dart` controller for playback

Subtasks

1. Implement `getEcgBatches(sessionId, startMs, endMs)` or `streamEcgForInterval`.
2. Brush component calls repository and streams data to `EcgStripController.playbackFromStream`.

Acceptance

- Brush selection triggers DB query and ECG playback aligns with timeline range.

Tests

- `test/repositories/drift_sample_repository_test.dart`

Run:

```powershell
flutter test test/repositories/drift_sample_repository_test.dart
```

Parallelization

- Repo implementer vs UI implementer.

---

### 8) HRV window metrics service (Task 8)

Goal

- Sliding-window HRV metrics (RMSSD, SDNN, pNN50) with percentiles and caching for UI consumption.

Files

- `lib/src/services/analysis/hrv_service.dart`
- `lib/src/domain/models/hrv_metrics.dart`

Subtasks

1. Implement sliding-window and incremental calculations.
2. Provide JSON-serializable `HrvWindowResult` DTO.
3. Cache results for reuse in UI.

Acceptance

- Metrics match reference implementation on synthetic RR sequences.

Tests

- `test/services/hrv_service_test.dart`

Run:

```powershell
flutter test test/services/hrv_service_test.dart
```

Parallelization

- Service & UI modules independent.

---

### 9) Poincaré analysis suite (Task 9)

Goal

- Global and segment-level Poincaré analysis with SD1/SD2 ellipse overlay using cleaned RR.

Files

- `lib/src/services/processing/rr_cleaner.dart`
- `lib/src/services/analysis/poincare_analysis.dart`
- `lib/src/features/session/poincare_analysis.dart`

Subtasks

1. Implement RR cleaning (ectopy removal, interpolation where needed).
2. Use Poincaré isolate for metrics and scatter points.
3. Add UI to drill-down segment & overlay ellipse.

Acceptance

- Difference between cleaned and raw is visible; ellipse parameters correct.

Tests

- `test/services/rr_cleaner_test.dart`

Run:

```powershell
flutter test test/services/rr_cleaner_test.dart
```

Parallelization

- Cleaning algorithms vs UI implementer.

---

### 10) Distribution insights & export hooks (Task 10)

Goal

- RR/HR histograms with density overlay and snapshot export to CSV/EDF.

Files

- `lib/src/features/session/distributions.dart`
- `lib/src/services/export/csv_export_service.dart` (extend)

Subtasks

1. Build histogram component and binning logic.
2. Add export hook producing CSV snapshot with metadata.

Acceptance

- Histogram binning correct; CSV contains expected headers and metadata.

Tests

- `test/services/csv_export_service_test.dart`

Run:

```powershell
flutter test test/services/csv_export_service_test.dart
```

Parallelization

- UI vs export logic parallel.

---

### 11) Frequency-domain pipeline (fftea) (Task 11)

Goal

- Compute LF/HF spectrum and timeline using `fftea` in isolates; add Lomb-Scargle later.

Files

- `lib/src/services/analysis/frequency_service.dart`

Subtasks

1. Integrate `fftea` to compute PSD from resampled RR signal.
2. Run computations in isolate and return `SpectralSnapshot` objects.

Acceptance

- FFT peaks for synthetic signals at expected frequencies.

Tests

- `test/services/frequency_service_test.dart`

Run:

```powershell
flutter pub add fftea
flutter test test/services/frequency_service_test.dart
```

Parallelization

- Library integration vs UI charting.

---

### 12) Episodic detector & persistence (Task 12)

Goal

- Detect brady/tachy/pause/high-variance episodes, persist annotations and surface them on timeline.

Files

- `lib/src/services/analysis/episodic_detector.dart`
- `lib/src/data/repositories/drift_annotation_repository.dart`

Subtasks

1. Implement detector with config thresholds and minimum durations.
2. Persist annotations and ensure retrieval API.
3. Surface annotations in `event_timeline.dart`.

Acceptance

- Detector flags episodes on synthetic test data.

Tests

- `test/services/episodic_detector_test.dart`

Run:

```powershell
flutter test test/services/episodic_detector_test.dart
```

Parallelization

- Detector vs persistence vs UI.

---

### 13) Heuristic sleep sketch (Task 13)

Goal

- Heuristic-based sleep-like segmentation from HR/RR; visualization as hypnogram-style bars.

Files

- `lib/src/services/analysis/sleep_sketch_service.dart`
- `lib/src/features/session/sleep_sketch.dart`

Subtasks

1. Implement configurable heuristics (low HR + stable high HRV → sleep markers).
2. Add UI visualization and configuration controls.

Acceptance

- Configurable thresholds; unit tests on synthetic labeled data.

Tests

- `test/services/sleep_sketch_test.dart`

Run:

```powershell
flutter test test/services/sleep_sketch_test.dart
```

Parallelization

- Algorithm tuning vs UI.

---

### 14) Finalise artefact classification (Task 14)

Goal

- Robust classifier producing amplitude clipping / flatline / slope labels, map to quality bars and toasts, persist batch-level quality.

Files

- `lib/src/services/processing/artifact_classifier.dart`
- `lib/src/features/common/quality_bar.dart`
- `lib/src/data/repositories/drift_*_repository.dart` (extend to store quality)

Subtasks

1. Implement classifier with unit-testable thresholds.
2. Map output to UI quality bar and toasts.
3. Persist quality metadata per `ecg_sample_batch`.

Acceptance

- Classifier shows good precision/recall on test vectors.

Tests

- `test/services/artifact_classifier_test.dart`

Run:

```powershell
flutter test test/services/artifact_classifier_test.dart
```

Parallelization

- Classifier vs UI vs DB mapping.

---

### 15) Formalise analysis interfaces & domain models (Task 15)

Goal

- Shared interfaces so live and offline consumers can ask repositories for cleaned/timestamped series.

Files

- `lib/src/domain/interfaces/analysis_interfaces.dart`
- `lib/src/domain/models/*.dart`

Subtasks

1. Define interfaces and DTOs (EcgProvider, RrProvider, HrvProvider).
2. Update repository implementations to conform.
3. Add type-checking and unit tests.

Acceptance

- Interfaces compile and are used by services.

Run:

```powershell
flutter test
```

Parallelization

- Spec authors vs implementers.

---

### 16) Chart deps behind feature flags & demo page (Task 16)

Goal

- Gate chart libs behind feature flags; provide demo page for rapid UI iteration.

Files

- `lib/src/config/feature_flags.dart`
- `lib/src/features/demo/demo_charts.dart`
- `pubspec.yaml` (conditional addition optional)

Subtasks

1. Implement flags and conditional import patterns.
2. Create demo page showing each chart widget.
3. Document licensing steps.

Acceptance

- App builds with charts disabled; demo page runs when enabled.

Run:

```powershell
flutter run -d <device>
```

Parallelization

- UI vs infra.

---

### 17) Isolate orchestration & golden tests (Task 17)

Goal

- Test harness for isolates and golden tests for key visual widgets; CI baseline for regression detection.

Files

- `test/utils/isolate_test_harness.dart`
- `test/goldens/*` images
- CI workflow update file (e.g., `.github/workflows/ci.yml`)

Subtasks

1. Build harness to run isolates deterministically for unit tests.
2. Add golden tests per widget; store baseline images.
3. Update CI to run tests and compare goldens.

Acceptance

- Golden tests pass locally and in CI.

Run:

```powershell
flutter test
```

Parallelization

- QA engineers to configure CI; developers to add goldens.

---

### 18) Extend export & persistence flows (Task 18)

Goal

- Store processed metrics alongside raw streams and extend compression utils.

Files

- `lib/src/data/models/compression_utils.dart`
- `lib/src/data/repositories/drift_*_repository.dart`

Subtasks

1. Modify compression utilities to include metric metadata in batch blobs.
2. Add columns to `ecg_sample_batches` (JSON metrics) and run codegen.
3. Update repositories and tests.

Acceptance

- Metrics are stored and queryable; migrations documented.

Run:

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
flutter test test/data/repository_persistence_test.dart
```

Parallelization

- DB work must be coordinated; codegen can be done by a single agent.

---

### 19) Update docs & developer walkthrough (Task 19)

Goal

- Keep `docs/analysis_architecture.md` and `docs/data_analysis_and_visualisation.md` in sync; add a developer walkthrough and quickstart instructions.

Files

- `docs/analysis_architecture.md` (update)
- `docs/data_analysis_and_visualisation.md` (update)
- `docs/implementation_plan_analysis_and_visualisation.md` (this file)

Subtasks

1. Add quickstart commands and how-to-run tests & goldens.
2. Document common pitfalls (samplingRate missing, timestamps, memory usage).

Acceptance

- Docs updated and accessible in repo.

Run:

```powershell
# Quickstart
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

Parallelization

- Technical writer vs devs.

---

## DTOs & Example APIs (copyable)

`ProcessedChunk` DTO example

```dart
class ProcessedChunk {
  final String sessionId;
  final int startTimestampMs; // epoch ms
  final int samplingRate; // Hz after downsample
  final Float32List samples;
  final List<int> rPeakIndices; // indices relative to samples
  final List<ArtefactFlag> artefacts;
}
```

`ArtefactFlag` example

```dart
enum ArtefactType { clipping, flatline, highSlope }
class ArtefactFlag { final ArtefactType type; final int startMs; final int endMs; final String? meta; }
```

Interface example (analysis provider)

```dart
abstract class EcgProvider {
  Stream<ProcessedChunk> processedEcg(String sessionId);
}

abstract class RrProvider {
  Stream<RrSample> rrSeries(String sessionId);
}
```

---

## Edge cases & test checklist

- Missing `samplingRate` → reconstruct with fallback (500Hz). Validate timestamps are epoch ms.
- Timestamp unit inconsistency (s vs ms) → normalize to ms and sanity-check range.
- Buffer overflow → drop-oldest / back-pressure strategy and expose `bufferOverflow` event.
- Null or corrupt batch → persist `raw_event` for debugging and skip processing.
- Long sessions → stream results to DB in batches to avoid memory blow-up.

---

## Quality gates (per task)

1. Build: `flutter pub get` / `build_runner` — PASS
2. Lint & analyze: `flutter analyze` — PASS
3. Unit tests: `flutter test` (task-specific) — PASS
4. Smoke test: run app or widget sample — PASS

Suggested CI steps (`.github/workflows/ci.yml`):

- `flutter pub get`
- `flutter pub run build_runner build --delete-conflicting-outputs`
- `flutter test`
- (Optional) Golden test management branch for `--update-goldens`

---

## Sprint & work distribution recommendations

- Sprint 1 (2 weeks): Tasks 1–4 — Pipeline + ECG painter + Tachogram + HR tile
- Sprint 2 (2–3 weeks): Tasks 5–10 — Poincaré, Session viewer, HRV service, distributions
- Sprint 3 (2–3 weeks): Tasks 11–19 — Frequency domain, detectors, exports, QA

Agent assignment suggestions (8 agents)

- Agent 1 — Pipeline (#1)
- Agent 2 — ECG painter (#2)
- Agent 3 — Tachogram & session scaffold (#3, #6)
- Agent 4 — HR tile & alerts (#4)
- Agent 5 — Poincaré & HRV (#5, #8, #9)
- Agent 6 — Frequency & detector (#11, #12)
- Agent 7 — Export & persistence (#10, #18)
- Agent 8 — QA & docs (#16, #17, #19)

---

## Minimal next actions (pick one)

- Implement Task #1 (add `ring_buffer.dart`, `processor_isolate.dart`, test harness). I can start this now.
- Or produce `ProcessedChunk` model + provider stubs so UI teams can begin integration.

---

## Contact & notes

- Keep `drift` generated files (`*.g.dart`) untouched — modify sources and run `build_runner`.
- When adding new tables, update `lib/src/data/models/data_mappers.dart` with mapping extensions.
- For heavy compute (filters, R-peak), prefer isolates to avoid jank.


*End of implementation plan.*
