# Data Model & Persistence Layer

This document describes the comprehensive data model and persistence layer implementation for the Polar H10 Analyzer application.

## Overview

The data layer follows clean architecture principles with a clear separation between domain models, repository interfaces, and concrete implementations. It provides:

- **Domain Models**: Core business entities with JSON serialization
- **Database Layer**: Drift-based SQLite database with optimized schema
- **Repository Pattern**: Clean abstraction for data access
- **Background Services**: Data buffering and batch processing
- **Export Pipeline**: Multi-format data export (CSV, EDF, PDF)

## Architecture

```
├── domain/
│   ├── models/           # Core business entities
│   └── repositories/     # Repository interfaces
├── data/
│   ├── datasources/local/ # Database implementation
│   ├── models/           # Data mappers and DTOs
│   └── repositories/     # Repository implementations
├── services/
│   ├── background/       # Background processing services
│   └── export/          # Export functionality
└── providers/           # Dependency injection setup
```

## Domain Models

### Core Entities

1. **PolarDevice** - Represents a Polar H10 device
   - Device identification and status
   - Connection and electrode status
   - Battery level and signal quality

2. **MeasurementSession** - Recording session management
   - Session lifecycle (preparing → recording → completed)
   - Session metadata (type, tags, notes)
   - Duration calculation

3. **EcgSample** - Individual ECG data points
   - High-frequency voltage measurements
   - R-peak detection markers
   - Quality indicators

4. **EcgSampleBatch** - Efficient bulk ECG storage
   - Compressed voltage data
   - Batch processing support
   - Quality metrics aggregation

5. **HeartRateSample** - Heart rate measurements
   - BPM values and RR intervals
   - Contact detection status
   - Multiple data sources (ECG, optical)

6. **HrvSample** - Heart Rate Variability analysis
   - Time-domain metrics (RMSSD, SDNN, pNN50)
   - Calculated over time windows
   - Stress indicators

7. **AnalysisResult** - Analysis outcomes
   - Statistical, HRV, and frequency domain metrics
   - AI-generated insights
   - Algorithm versioning and confidence levels

## Database Schema

### Tables

- **polar_devices** - Device registry
- **measurement_sessions** - Session management
- **ecg_samples** - Individual ECG data points
- **ecg_sample_batches** - Compressed ECG batches
- **heart_rate_samples** - HR measurements
- **hrv_samples** - HRV calculations
- **analysis_results** - Analysis outcomes
- **export_history** - Export tracking

<!-- EventChannel payloads documented below -->

## EventChannel payloads (PolarBridge plugin)

The native `polar_bridge` plugin (Android Kotlin) emits runtime events over a Flutter `EventChannel`. These are the canonical, JSON-serializable payloads the data layer should consume and persist. The runtime code in `lib/src/services/ble/polar_ble_service.dart` contains the consumer logic; this section documents the event shapes and recommended mappings into the database.

Event types (observed/currently emitted):

- `blePower`
  - Fields: `powered` (bool)
  - Interpretation: Bluetooth adapter state. Persist into a lightweight device status or session metadata table when relevant.

- `scanResult`
  - Fields: `deviceId` (String), `name` (String), `rssi` (int)
  - Interpretation: transient scan events. Store only when the user adds a device, or persist a short-term "discovery history" with timestamp.

- `connection`
  - Fields: `deviceId` (String), `state` (String: `connecting`|`connected`|`disconnected`), `name` (String, optional)
  - Interpretation: Map to `PolarDevice` connection status and `measurement_sessions` lifecycle events (start on `connected`/recording, end on `disconnected`). Persist as `connection_events` if you need an audit trail.

- `feature`
  - Fields: `deviceId` (String), `feature` (String) — e.g., `FEATURE_HR`, `FEATURE_POLAR_ONLINE_STREAMING`
  - Interpretation: Device-reported capabilities. Use to decide which streams to request. Persist capabilities per device in `polar_devices` (JSON or normalized table).

- `streamSettings`
  - Fields: `deviceId` (String), `settings` (Map)
  - Typical `settings` map keys: `raw` (Stringified sensor setting), optional `samplingRate` (int)
  - Interpretation: Represents sensor configuration for requested stream (ECG). Persist `samplingRate` and raw settings in `ecg_sample_batches` metadata or a dedicated `stream_settings` table.

- `ecg`
  - Fields: `deviceId` (String), `samples` (List of either numbers or maps), `ts` (long/int epoch ms), optional `samplingRate` (int), optional `startTimeStamp` (long/int epoch ms)
  - Sample element shapes observed:
    - primitive numeric: sample represents a voltage value (native units)
    - map: `{ "voltage": <num>, "timeStamp": <epoch ms?>, "rPeak": <bool?> }` or variations (`value`, `volt`, `microvolts`, `timestamp`, `ts`)
  - Interpretation & mapping rules (recommended):
    - samplingRate: if provided, treat as Hz (samples per second). Store as `sampling_rate` (int) on the batch record.
    - startTimeStamp / ts: plugin may emit `startTimeStamp` (preferred) or a `ts` field which historically represented end-of-batch timestamp. Prefer `startTimeStamp` when present; otherwise follow the plugin's convention (read `ts` as either start or end depending on plugin version) — the Dart consumer has conservative fallbacks and reconstructs per-sample timestamps when necessary.
    - Per-sample timestamps: if a sample includes `timeStamp`/`timestamp`/`ts`, use that value (epoch ms). If missing, reconstruct using `startTimeStamp + index * (1000 / samplingRate)`.
    - Voltage units: the native plugin attempts to expose microvolt or voltage-like fields. Confirm whether the values are raw ADC counts or microvolts; the mapping code currently assumes numeric values are directly usable (sanitized and clamped). If needed, add scale metadata to `ecg_sample_batches`.
    - R-peaks: if sample objects include `rPeak`/`isR`, map those indices to `r_peak_indices` (store as compressed JSON array in `ecg_sample_batches` or normalized relation).
    - Storage strategy: store bulk ECG as compressed batches (see existing `ecg_sample_batches`), save `sampling_rate`, `start_timestamp`, `end_timestamp`, compressed voltage data (16-bit or 32-bit), `r_peak_indices`, and optional `raw_event` JSON for debugging.

- `hr`
  - Fields: `deviceId` (String), `hr` (int), `rrs` (List<int> RR intervals in ms), `ts` (long/int epoch ms)
  - Interpretation: Persist as `heart_rate_samples` with `timestamp`, `heart_rate`, `rr_intervals` (JSON), `source` (chest strap). RR intervals expected in milliseconds.

- `battery` / `batteryCharging`
  - Fields: `deviceId` (String), `level` (int) or `status` (String)
  - Interpretation: Persist to `polar_devices` table or `device_status_history` for battery trend tracking.

- `dis` (Device Information Service)
  - Fields: `deviceId` (String), `uuid` (String), `value` (String)
  - Interpretation: Map to `polar_devices` metadata (firmware versions, manufacturer name, system id, etc.).

- `unhandledCallback`
  - Fields: `method` (String), `args` (List<String>)
  - Interpretation: Debug-only events to capture unexpected SDK callbacks. Persist to a `raw_events_log` table when debugging edge cases; do not use for normal processing.

- `error`
  - Fields: `code` (String), `message` (String)
  - Interpretation: Surface to UI and logging. Some errors may be transient (e.g., `ERROR_ALREADY_IN_STATE` when starting ECG while already streaming); treat them as warnings where appropriate.

Edge cases & guidance

- Missing `samplingRate`: Reconstruct per-sample timestamps using a conservative fallback sampling rate (500 Hz) — the Dart consumer already does this. For critical analysis, prefer to obtain samplingRate from `streamSettings` or extend native reflection to find nested fields.
- Inconsistent timestamp units: Assume epoch milliseconds across events. If you find epoch seconds, convert appropriately. Add validation checks when ingesting (timestamps in far future/past should be sanity-checked).
- Large ECG blobs: compress voltages before writing to DB (already implemented in repository). When reading, decompress and avoid large in-memory allocations during UI rendering by streaming / downsampling.
- Duplicate start requests: the native plugin can emit an `ecg_stream` error (`ERROR_ALREADY_IN_STATE`). Implement defensive checks: store per-device streaming state and skip duplicate start attempts, or treat that specific error as non-fatal.

Recommended DB schema additions / changes

- `ecg_sample_batches` table (recommended columns):
  - `id` (pk)
  - `session_id` (fk)
  - `device_id` (String)
  - `start_timestamp` (int, epoch ms)
  - `end_timestamp` (int, epoch ms)
  - `sampling_rate` (int)
  - `compressed_voltage_blob` (blob)
  - `r_peak_indices` (JSON / text)
  - `sample_count` (int)
  - `quality_metrics` (JSON)
  - `raw_event` (JSON) // optional debug backup

- `heart_rate_samples` table (recommended columns): ensure `rr_intervals` column accepts JSON arrays of milliseconds and that `timestamp` is indexed for fast queries.

Ingest pipeline notes

- The ingest path should:
  1. Validate event shape and types.
  2. Normalize timestamps to epoch ms and sampling_rate to an int.
  3. Reconstruct per-sample timestamps if necessary but store only `start_timestamp` + sampling metadata in the DB; per-sample timestamps can be derived when decompressing for analysis.
  4. Compress voltages (16-bit or 32-bit depending on range) before writing to `compressed_voltage_blob`.
  5. Emit a lightweight DB write for heart rate samples (low-latency) and batch write for ECG samples.

Where to look in code

- Consumer: `lib/src/services/ble/polar_ble_service.dart` (event parsing & reconstruction)
- Native probe/plugin: `packages/polar_bridge/android/src/main/kotlin/com/example/polar_bridge/PolarBridgePlugin.kt`
- Repositories: `lib/src/data/repositories/drift_sample_repository.dart` and related drift mappers in `lib/src/data/models/data_mappers.dart`.

Best practices

- Always keep a `raw_event` JSON backup for the first few integration runs so you can inspect real device payloads in the DB; remove or rotate after confidence is reached.
- Add schema fields incrementally and run `build_runner`/drift migrations as part of CI.


### Optimization Features

- **Indexing** - Optimized queries on timestamps and session IDs
- **Data Compression** - Voltage data stored as 16-bit integers
- **Batch Processing** - Efficient bulk operations
- **Automatic Cleanup** - Configurable data retention policies

## Repository Pattern

### Interface Design

All repositories implement clean interfaces defined in the domain layer:

```dart
abstract class SessionRepository {
  Future<List<MeasurementSession>> getSessions();
  Future<MeasurementSession?> getSession(String sessionId);
  Future<String> createSession(MeasurementSession session);
  // ... other operations
}
```

### Concrete Implementations

- **DriftDeviceRepository** - Device management
- **DriftSessionRepository** - Session operations
- **DriftSampleRepository** - Sample data handling
- **DriftAnalysisRepository** - Analysis results

## Background Services

### Data Buffering Service

Handles real-time data streaming with:
- Configurable buffer sizes (default: 1000 samples)
- Automatic flush intervals (default: 30 seconds)
- Buffer overflow protection
- Status monitoring and alerts

### Batch Storage Service

Optimizes data storage with:
- Periodic data optimization (default: 6 hours)
- ECG sample batching and compression
- Old data cleanup policies
- Storage statistics tracking

## Export Pipeline

### CSV Export
- Complete session metadata
- Raw ECG and heart rate data
- HRV calculations
- Analysis results with JSON data

### EDF Export
- Industry-standard ECG format
- Compatible with medical software
- Proper signal scaling and metadata
- Configurable sampling parameters

### PDF Reports
- Comprehensive session summaries
- Statistical analysis charts
- AI insights and recommendations
- Professional formatting

## Usage Examples

### Basic Session Management

```dart
// Get data service
final dataService = ref.read(dataServiceProvider);

// Create and start session
final session = MeasurementSession(
  sessionId: uuid.v4(),
  deviceId: 'POLAR_H10_001',
  startTime: DateTime.now(),
  status: SessionStatus.recording,
  type: SessionType.exercise,
);

await dataService.sessionRepository.createSession(session);
```

### Real-time Data Streaming

```dart
// Add ECG samples to buffer
final sample = EcgSample(
  sessionId: sessionId,
  timestamp: DateTime.now(),
  voltage: ecgVoltage,
  sequenceNumber: sampleCount++,
  isRPeak: rPeakDetected,
);

dataService.bufferingService.addEcgSample(sample);
```

### Data Export

```dart
// Export session data
final exportService = ref.read(exportServiceProvider);

// Multi-format export
final result = await exportService.exportSessionAllFormats(sessionId);

if (result.allSuccessful) {
  print('Exported ${result.allFiles.length} files');
} else {
  print('Errors: ${result.errors}');
}
```

## Performance Considerations

### Database Optimization
- Uses SQLite with proper indexing
- Implements data compression for ECG samples
- Supports batch operations for bulk inserts
- Includes automatic vacuum and optimization

### Memory Management
- Configurable buffer sizes
- Automatic buffer flushing
- Lazy loading for large datasets
- Efficient data streaming

### Background Processing
- Non-blocking data operations
- Configurable processing intervals
- Error handling and retry logic
- Progress monitoring

## Configuration

### Buffer Settings
```dart
final bufferingService = DataBufferingService(
  sampleRepository,
  maxBufferSize: 2000,        // Samples before auto-flush
  flushInterval: Duration(seconds: 15), // Auto-flush interval
);
```

### Storage Optimization
```dart
final batchStorageService = BatchStorageService(
  sampleRepository,
  sessionRepository,
  optimizationInterval: Duration(hours: 3), // Optimization frequency
);
```

### Export Options
```dart
final exportOptions = ExportOptions(
  includeEcgData: true,
  includeHeartRateData: true,
  includeHrvData: true,
  startTime: sessionStart,
  endTime: sessionEnd,
  maxSamples: 10000,
);
```

## Testing

The implementation includes comprehensive unit tests:

- **Domain Model Tests** - JSON serialization, equality, validation
- **Repository Tests** - CRUD operations, error handling
- **Service Tests** - Export functionality, background processing
- **Integration Tests** - End-to-end workflows

Run tests with:
```bash
flutter test
```

## Dependencies

### Core Dependencies
- `drift` - Database ORM
- `sqlite3_flutter_libs` - SQLite support
- `path_provider` - File system access
- `flutter_riverpod` - Dependency injection

### Export Dependencies
- `csv` - CSV file generation
- `pdf` - PDF report creation
- `json_annotation` - JSON serialization

### Development Dependencies
- `drift_dev` - Code generation
- `build_runner` - Build automation
- `json_serializable` - JSON code generation

## Future Enhancements

- Cloud synchronization support
- Real-time analytics
- Machine learning integration
- Advanced signal processing
- Multi-device session support

## Documentation

For detailed API documentation, see the inline code documentation. Each class and method includes comprehensive dartdoc comments explaining usage, parameters, and return values.

## Current project status (snapshot)

- Database scaffolding: Drift table definitions and generated artifacts exist under `lib/src/data/datasources/local/` (verify `app_database.g.dart`).

- Repositories & providers: Repository implementations and Riverpod providers are wired in `lib/src/data/repositories/` and `lib/src/providers/data_providers.dart`.

- Testability: A test-only `AppDatabase.forTesting(QueryExecutor)` constructor was added to make it easy to run database-backed unit tests using an in-memory `NativeDatabase`.

- Export & Services: CSV export and background batch storage services are scaffolded; EDF/PDF features may need finalization and additional tests.

- Remaining work: Add CI codegen step, confirm `path_provider` and native sqlite libs configuration for platform builds, and add repository-level unit tests that use the in-memory DB constructor.
