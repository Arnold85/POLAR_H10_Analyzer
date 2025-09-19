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