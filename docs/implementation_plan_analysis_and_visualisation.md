
# Implementation Plan — Analysis & Visualisation

This document contains the restructured implementation plan optimized for **exactly 3 agents** working in parallel. Each development phase provides clear, encapsulated tasks with minimal cross-dependencies, allowing agents to work independently while building the Live Analysis Backbone, Session Review Experience, and Advanced Analytics.

> **3-Agent Strategy**: Each phase assigns one major responsibility per agent (Backend/Data, UI/Widgets, Analysis/Processing) with clear interfaces and handoff points.

---

## Assumptions

- UI downsample default: `125 Hz` (configurable). Keep the original `samplingRate` attached to raw events when available.
- HP filter cutoff: `0.5 Hz` for baseline removal.
- Ring buffer capacity: default ~10k samples (configurable by constructor).
- Use existing `drift` DB and `Riverpod` provider patterns. New services supply providers in `lib/src/providers/`.
- Chart libraries (Syncfusion) are gated behind feature flags if license control required.

---

## 3-Agent Development Phases

**Phase 1: Live Data Foundation** (2 weeks)

- Agent A (Backend): Data pipeline, ring buffers, isolate processing
- Agent B (UI): ECG strip widget, live dashboard tiles  
- Agent C (Analysis): Signal processing, filters, R-peak detection

**Phase 2: Session Analysis** (2-3 weeks)

- Agent A (Backend): Session storage, replay APIs, export services
- Agent B (UI): Session overview, charts, brushing interactions
- Agent C (Analysis): HRV metrics, Poincaré analysis, artifact detection

**Phase 3: Advanced Features** (2-3 weeks)

- Agent A (Backend): Persistence optimization, annotation storage
- Agent B (UI): Distribution charts, sleep visualization, demo pages
- Agent C (Analysis): Frequency domain, episode detection, AI integration

---

## Phase 1: Live Data Foundation (2 weeks)

### Agent A (Backend): Live Data Pipeline

**Goal**: Establish reliable data ingestion, buffering, and provider infrastructure for live streaming.

**Scope**: Raw event processing, ring buffers, Riverpod providers, persistence hooks
**Not in scope**: UI components, analysis algorithms, chart libraries

#### Files to create/edit

- `lib/src/services/processing/ring_buffer.dart` — Generic ring buffer for high-frequency data
- `lib/src/services/processing/ecg_pipeline.dart` — Main pipeline orchestrator
- `lib/src/providers/processing_providers.dart` — Riverpod providers for processed streams
- `lib/src/services/ble/polar_ble_service.dart` — Add pipeline integration hooks
- `lib/src/services/processing/persistence_sink.dart` — Test harness and debug logging

#### Tasks

1. **Ring Buffer Implementation** — Create typed `RingBuffer<T>` with thread-safe operations, configurable capacity, and overflow handling
2. **Pipeline Orchestrator** — Build `EcgPipeline` class that coordinates data flow from BLE → processing → UI providers
3. **Provider Integration** — Expose `StreamProvider`s for: raw ECG chunks, processed data, and processing status
4. **BLE Integration Hooks** — Add pipeline ingestion calls to existing `polar_ble_service.dart`
5. **Test Infrastructure** — Create in-memory sink for unit tests and debug logging

**Interface Contract** (for other agents):

```dart
// Expose these providers for UI consumption
final processedEcgProvider = StreamProvider<ProcessedChunk>(...)
final processingStatusProvider = StateProvider<ProcessingStatus>(...)
```

#### Handoff Criteria

- Pipeline providers are exposed and consumable by UI widgets
- Ring buffer handles 10k+ samples without memory leaks
- Raw BLE events flow through to `ProcessedChunk` DTOs
- Unit tests pass for buffer operations and provider state

**Tests**: `test/processing/ring_buffer_test.dart`, `test/providers/processing_providers_test.dart`

---

### Agent B (UI): Live Dashboard Widgets

**Goal**: Build high-performance live visualization widgets for ECG and HR data.

**Scope**: CustomPainter ECG strip, HR tile with sparklines, basic live charts
**Not in scope**: Data processing, analysis algorithms, session management

#### Files to create/edit

- `lib/src/features/live/widgets/ecg_strip.dart` — CustomPainter ECG strip with gain controls
- `lib/src/features/live/widgets/hr_tile.dart` — HR dashboard tile with zones and sparklines
- `lib/src/features/live/live_dashboard.dart` — Main live view layout
- `lib/src/features/live/controllers/ecg_strip_controller.dart` — Strip control logic

#### Tasks

1. **ECG Strip Widget** — CustomPainter-based scrolling strip (8s window), gain controls, soft clipping
2. **HR Dashboard Tile** — Current BPM display, 60s sparkline, zone gauge visualization
3. **Live Dashboard Layout** — Organize widgets with responsive layout, connection status
4. **Widget Controllers** — Pause/resume, gain adjustment, window size controls
5. **Golden Tests** — Visual regression tests for key rendering states

**Interface Contract** (consume from Agent A):

```dart
// Consume these providers from Agent A
ref.watch(processedEcgProvider) // for ECG strip
ref.watch(processingStatusProvider) // for connection status
```

#### Handoff Criteria

- ECG strip renders smoothly at 60fps with test data
- Widgets respond to provider state changes
- Golden tests establish visual baselines
- Controllers provide programmatic widget control

**Tests**: `test/widgets/ecg_strip_test.dart`, `test/goldens/ecg_strip_gain1.png`

---

### Agent C (Analysis): Signal Processing Core

**Goal**: Implement core signal processing algorithms that run in isolates.

**Scope**: Filters, R-peak detection, artifact classification, basic HRV metrics
**Not in scope**: UI integration, data persistence, advanced analytics

#### Files to create/edit

- `lib/src/services/processing/processor_isolate.dart` — Main processing isolate entry point
- `lib/src/services/processing/filters.dart` — HP filter, downsampling, signal conditioning
- `lib/src/services/processing/artifact_detector.dart` — Amplitude/flatline/slope detection
- `lib/src/services/processing/rpeak_detector.dart` — Basic R-peak detection algorithm

#### Tasks

1. **Processing Isolate** — Isolate entry point that receives raw chunks and returns processed data
2. **Signal Filters** — HP filter (0.5Hz), downsample to 125Hz, normalization
3. **Artifact Detection** — Classify clipping, flatline, high-slope artifacts
4. **R-Peak Detection** — Lightweight algorithm for real-time peak detection
5. **Performance Optimization** — Ensure <100ms latency for typical chunk sizes

**Interface Contract** (provide to Agent A):

```dart
// Agent A will call this isolate function
ProcessedChunk processEcgChunk(RawEcgChunk input) {
  // Your processing implementation
}
```

#### Handoff Criteria

- Isolate processes test signals with correct output
- Filters remove baseline wander and downsample correctly
- Artifact detection flags synthetic test cases
- Processing latency <100ms for 1000-sample chunks

**Tests**: `test/processing/filters_test.dart`, `test/processing/rpeak_detector_test.dart`

---

## Phase 2: Session Analysis (2-3 weeks)

### Agent A (Backend): Session Management & Storage

**Goal**: Build session storage, replay APIs, and export functionality.

**Scope**: Session CRUD, ECG replay queries, CSV/EDF export, annotation storage
**Not in scope**: UI components, analysis algorithms, chart rendering

#### Files to create/edit (Agent A - Phase 2)

- `lib/src/data/repositories/drift_session_repository.dart` — Extend for replay queries
- `lib/src/services/export/csv_export_service.dart` — Extend for processed data export
- `lib/src/data/repositories/drift_annotation_repository.dart` — Store events/annotations
- `lib/src/services/session/session_service.dart` — Session lifecycle management

#### Tasks (Agent A - Phase 2)

1. **Session Replay API** — `streamEcgForInterval(sessionId, startMs, endMs)` for time-range queries
2. **Annotation Storage** — Store/retrieve events, quality metrics, user annotations
3. **Export Extensions** — Add processed metrics to CSV/EDF exports
4. **Session Service** — Manage session lifecycle, metadata, status tracking
5. **Background Optimization** — Batch storage service for long sessions

**Interface Contract** (for other agents):

```dart
// Provide these APIs for UI consumption
abstract class SessionRepository {
  Stream<EcgSample> streamEcgForInterval(String sessionId, int startMs, int endMs);
  Future<List<Annotation>> getAnnotations(String sessionId);
}
```

#### Handoff Criteria (Agent A - Phase 2)

- Replay queries return time-aligned ECG data
- Annotations are stored and retrievable
- Export includes processed metrics and metadata
- Session service manages state correctly

**Tests**: `test/repositories/session_repository_test.dart`, `test/services/export_service_test.dart`

---

### Agent B (UI): Session Review Interface

**Goal**: Build comprehensive session analysis UI with synchronized charts.

**Scope**: Session overview, chart synchronization, brushing interactions, timeline
**Not in scope**: Data processing, export logic, advanced analysis algorithms

#### Files to create/edit (Agent B - Phase 2)

- `lib/src/features/session/session_overview.dart` — Main session analysis screen
- `lib/src/features/session/widgets/synchronized_charts.dart` — Multi-chart synchronization
- `lib/src/features/session/widgets/timeline_brush.dart` — Time range selection
- `lib/src/features/common/viewport_provider.dart` — Shared viewport state

#### Tasks (Agent B - Phase 2)

1. **Session Overview Screen** — Layout with HR trend, RR tachogram, event timeline
2. **Chart Synchronization** — Shared viewport provider for pan/zoom across charts
3. **Timeline Brushing** — Select time ranges, trigger ECG replay
4. **Event Timeline** — Display annotations, quality events, user markers
5. **Responsive Layout** — Tablet/phone adaptive layouts

**Interface Contract** (consume from Agent A):

```dart
// Consume these APIs from Agent A
ref.watch(sessionRepositoryProvider).streamEcgForInterval(...)
ref.watch(annotationRepositoryProvider).getAnnotations(...)
```

#### Handoff Criteria (Agent B - Phase 2)

- Charts synchronize pan/zoom across multiple views
- Brushing triggers ECG replay from storage
- Timeline displays persisted annotations
- Responsive layout works on different screen sizes

**Tests**: `test/widgets/session_overview_test.dart`, `test/widgets/synchronized_charts_test.dart`

---

### Agent C (Analysis): HRV & Advanced Metrics

**Goal**: Implement HRV analysis, Poincaré plots, and quality assessment.

**Scope**: HRV metrics, Poincaré analysis, RR cleaning, quality classification
**Not in scope**: UI components, data storage, export formatting

#### Files to create/edit (Agent C - Phase 2)

- `lib/src/services/analysis/hrv_service.dart` — Sliding window HRV metrics
- `lib/src/services/analysis/poincare_service.dart` — Poincaré plot computation
- `lib/src/services/processing/rr_cleaner.dart` — RR interval cleaning
- `lib/src/services/analysis/quality_assessor.dart` — Signal quality scoring

#### Tasks (Agent C - Phase 2)

1. **HRV Metrics Service** — RMSSD, SDNN, pNN50 with sliding windows
2. **Poincaré Analysis** — SD1/SD2 computation, scatter plot data
3. **RR Cleaning** — Ectopy removal, interpolation, outlier detection
4. **Quality Assessment** — Signal quality scoring per time segment
5. **Performance Optimization** — Cache results, efficient windowing

**Interface Contract** (provide to Agent B):

```dart
// Provide these services for UI consumption
abstract class HrvService {
  Stream<HrvMetrics> slidingWindowMetrics(List<int> rrIntervals);
}
abstract class PoincareService {
  PoincareResult computePoincare(List<int> rrIntervals);
}
```

#### Handoff Criteria (Agent C - Phase 2)

- HRV metrics match reference implementations
- Poincaré computation produces correct SD1/SD2
- RR cleaning improves signal quality metrics
- Services handle edge cases (short recordings, artifacts)

**Tests**: `test/services/hrv_service_test.dart`, `test/services/poincare_service_test.dart`

---

## Phase 3: Advanced Features (2-3 weeks)

### Agent A (Backend): Optimization & Integration

**Goal**: Performance optimization, advanced persistence, and system integration.

**Scope**: DB optimization, compression, batch processing, CI/CD setup
**Not in scope**: UI features, analysis algorithms, user-facing functionality

#### Files to create/edit (Agent A - Phase 3)

- `lib/src/data/models/compression_utils.dart` — Extend compression for metrics
- `lib/src/services/background/batch_storage_service.dart` — Optimize long sessions
- `.github/workflows/ci.yml` — CI pipeline with golden tests
- `lib/src/config/feature_flags.dart` — Feature flag system

#### Tasks (Agent A - Phase 3)

1. **Compression Optimization** — Store processed metrics in compressed batches
2. **Batch Storage Service** — Background optimization for long recordings
3. **CI/CD Pipeline** — Automated testing, golden test management
4. **Feature Flags** — Gate experimental features, chart libraries
5. **Performance Monitoring** — Add telemetry for processing latency

#### Handoff Criteria (Agent A - Phase 3)

- Compression reduces storage by >50% for typical sessions
- Background service handles multi-hour recordings
- CI pipeline runs tests and manages golden baselines
- Feature flags control experimental features

**Tests**: `test/data/compression_test.dart`, `test/services/batch_storage_test.dart`

---

### Agent B (UI): Advanced Visualizations

**Goal**: Specialized analysis views and user experience enhancements.

**Scope**: Distribution charts, sleep visualization, demo pages, accessibility
**Not in scope**: Backend optimization, analysis algorithms, data processing

#### Files to create/edit (Agent B - Phase 3)

- `lib/src/features/session/distributions.dart` — RR/HR histograms
- `lib/src/features/session/sleep_sketch.dart` — Sleep-like visualization
- `lib/src/features/demo/demo_charts.dart` — Chart library showcase
- `lib/src/features/common/accessibility_features.dart` — A11y improvements

#### Tasks (Agent B - Phase 3)

1. **Distribution Charts** — RR/HR histograms with density overlays
2. **Sleep Visualization** — Hypnogram-style sleep phase display
3. **Demo Page** — Interactive showcase of all chart types
4. **Accessibility** — Screen reader support, keyboard navigation
5. **UI Polish** — Animations, loading states, error handling

**Interface Contract** (consume from Agent C):

```dart
// Consume these analysis services
ref.watch(sleepAnalysisProvider) // from Agent C
ref.watch(distributionAnalysisProvider) // from Agent C
```

#### Handoff Criteria (Agent B - Phase 3)

- Distribution charts render correctly for various data ranges
- Sleep visualization shows meaningful patterns
- Demo page showcases all implemented features
- Accessibility testing passes automated checks

**Tests**: `test/widgets/distributions_test.dart`, `test/a11y/accessibility_test.dart`

---

### Agent C (Analysis): AI & Advanced Detection

**Goal**: Frequency domain analysis, episode detection, and AI integration foundations.

**Scope**: FFT analysis, episode detection, sleep heuristics, AI interfaces
**Not in scope**: UI components, data storage, chart rendering

#### Files to create/edit (Agent C - Phase 3)

- `lib/src/services/analysis/frequency_service.dart` — FFT-based spectral analysis
- `lib/src/services/analysis/episode_detector.dart` — Brady/tachy/pause detection
- `lib/src/services/analysis/sleep_analysis.dart` — Heuristic sleep detection
- `lib/src/domain/interfaces/ai_interfaces.dart` — Future AI integration points

#### Tasks (Agent C - Phase 3)

1. **Frequency Analysis** — LF/HF spectrum using fftea, spectral timeline
2. **Episode Detection** — Detect brady/tachy/pause episodes with configurable thresholds
3. **Sleep Analysis** — Heuristic sleep-wake detection from HR/HRV patterns
4. **AI Interface Layer** — Abstract interfaces for future TensorFlow Lite integration
5. **Validation Framework** — Compare results with reference datasets

**Interface Contract** (provide to Agent B):

```dart
// Provide these advanced analysis services
abstract class FrequencyService {
  Stream<SpectralResult> computeSpectrum(List<int> rrIntervals);
}
abstract class EpisodeDetector {
  List<Episode> detectEpisodes(List<HeartRateSample> samples);
}
```

#### Handoff Criteria (Agent C - Phase 3)

- FFT analysis produces correct spectral peaks for test signals
- Episode detector flags synthetic test cases correctly
- Sleep analysis identifies sleep-like patterns
- AI interfaces are ready for future model integration

**Tests**: `test/services/frequency_service_test.dart`, `test/services/episode_detector_test.dart`

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

## 3-Agent Work Distribution Summary

### Agent A (Backend/Data Specialist)

**Focus**: Data flow, persistence, APIs, system integration

- **Phase 1**: Ring buffers, pipeline orchestration, provider setup
- **Phase 2**: Session storage, replay APIs, export services
- **Phase 3**: Performance optimization, CI/CD, feature flags

### Agent B (UI/Frontend Specialist)

**Focus**: Widgets, user experience, visual components

- **Phase 1**: ECG strip widget, HR dashboard, live visualizations
- **Phase 2**: Session overview, chart synchronization, interactions
- **Phase 3**: Advanced charts, accessibility, UI polish

### Agent C (Analysis/Processing Specialist)

**Focus**: Signal processing, algorithms, analytics

- **Phase 1**: Filters, R-peak detection, artifact classification
- **Phase 2**: HRV metrics, Poincaré analysis, quality assessment
- **Phase 3**: Frequency analysis, episode detection, AI foundations

### Cross-Phase Dependencies

#### Phase 1 → Phase 2

- Agent A provides: Stream providers, data pipeline APIs
- Agent B provides: Widget controllers, live dashboard patterns
- Agent C provides: Processing isolates, signal processing APIs

#### Phase 2 → Phase 3

- Agent A provides: Session storage, annotation APIs
- Agent B provides: Chart synchronization, interaction patterns
- Agent C provides: HRV services, quality metrics

### Handoff Protocols

1. **Interface-First Development**: Define contracts before implementation
2. **Mock-Driven Testing**: Use mocks/stubs until dependencies are ready
3. **Integration Points**: Weekly sync to align interfaces and test integration
4. **Documentation**: Each agent documents their public APIs in code comments

---

## Immediate Next Actions (Phase 1 Kickoff)

### Day 1: Interface Definition (All Agents)

1. **Define shared DTOs**: `ProcessedChunk`, `ProcessingStatus`, `RawEcgChunk`
2. **Agree on provider contracts**: What each agent will expose/consume
3. **Set up test data**: Synthetic ECG signals for independent testing

### Day 1-2: Agent A Backend Foundation

1. Create `RingBuffer<T>` with unit tests
2. Set up provider skeleton in `lib/src/providers/processing_providers.dart`
3. Add pipeline hooks to existing `polar_ble_service.dart`

### Day 1-2: Agent B UI Components

1. Create ECG strip widget skeleton with mock data
2. Set up golden test infrastructure
3. Build HR tile layout with placeholder providers

### Day 1-2: Agent C Processing Core

1. Implement basic HP filter in pure Dart
2. Create isolate entry point with mock processing
3. Add R-peak detection algorithm skeleton

### Week 1 Integration Checkpoint

- All agents demo their components with mock/test data
- Verify provider contracts work end-to-end
- Adjust interfaces based on integration testing

---

## Contact & notes

- Keep `drift` generated files (`*.g.dart`) untouched — modify sources and run `build_runner`.
- When adding new tables, update `lib/src/data/models/data_mappers.dart` with mapping extensions.
- For heavy compute (filters, R-peak), prefer isolates to avoid jank.


*End of implementation plan.*
