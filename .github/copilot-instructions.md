## Repository: polar_h10_analyzer — AI coding assistant guidance

This file gives concise, actionable instructions for an AI coding agent (Copilot or similar) to be immediately productive in this Flutter/Dart codebase.

Goals

- Help the agent understand the app structure and primary responsibilities (data persistence, analysis, UI wiring).
- Provide exact build/test commands and code patterns that recur in this repo.
- Call out non-standard conventions and important integration points (Drift database, compressed ECG batches, background batch storage, local TF Lite usage).

Quick facts

- Flutter app using Dart SDK ^3.9.2. See `pubspec.yaml` for dependencies (notably `drift`, `drift_dev`, `sqlite3_flutter_libs`, `flutter_riverpod`, `go_router`, `tflite_flutter`).
- Local DB: `drift` with generated files under `lib/src/data/datasources/local/` (`app_database.dart`, `app_database.g.dart`, `database_tables.dart`).
- Domain models live under `lib/src/domain/models/` and are mapped to DB entities in `lib/src/data/models/data_mappers.dart`.

Major components and data flow (big picture)

- UI & routing: `lib/main.dart`, `lib/src/app.dart`, and `lib/src/routing/` (uses `go_router`).
- State & DI: `flutter_riverpod` providers in `lib/src/providers/` (look at `data_providers.dart`). Providers supply repositories and DB instances to features.
- Persistence layer: `lib/src/data/datasources/local/app_database.dart` defines tables and drift database; `database_tables.dart` contains table definitions. Generated drift artifacts live alongside (e.g. `app_database.g.dart`).
- Mapping: `lib/src/data/models/data_mappers.dart` converts between drift DB entities and domain models. Example: `EcgSampleBatchEntityMapper` uses `decompressVoltageData` and `decompressRPeakIndices` (helpers are in `compression_utils.dart`).
- Repositories: `lib/src/data/repositories/` contains `drift_*_repository.dart` implementations that interact with the drift DB and return domain models.
- Services: background batching and export code under `lib/src/services/` (e.g., `background/batch_storage_service.dart`, `export/csv_export_service.dart`). These integrate with DB and the file system.

Notable code patterns & conventions

- Drift entity ↔ domain model mapping is centralized in `data_mappers.dart` via extension methods. When adding a new table, add two extension mappers: domain→Companion and Entity→domain.
- Compressed binary blobs: ECG batches store packed data; use `lib/src/data/models/compression_utils.dart` helpers to (de)compress. Search for `decompressVoltageData` and `decompressRPeakIndices` when working on ECG batch logic.
- JSON fields: some DB columns store JSON (e.g., `tags`, `rrIntervals`, `analysis.data`, `qualityMetrics`). Use `jsonEncode`/`jsonDecode` consistently. If a field is nullable, check for `!= null` before decoding.
- Enum storage: enums are stored using `enumValue.name` (string). On read, use `firstWhere(..., orElse: () => ...)` to map back to enum safely (see examples in `data_mappers.dart`).
- Time fields: `DateTime` is stored directly in some tables. When updating records, repositories set `updatedAt: Value(DateTime.now())` in companions.

Build, run & test commands (Windows / PowerShell)

- Install deps & generate code:
  - `flutter pub get`
  - `flutter pub run build_runner build --delete-conflicting-outputs`
  - If drift codegen required: `flutter pub run build_runner build --delete-conflicting-outputs`
- Run app on current device/emulator: `flutter run`
- Run tests: `flutter test` (unit & widget tests are under `test/`)

Developer workflows & gotchas

- Drift generated files: changes to table definitions (`database_tables.dart`) require `build_runner` to regenerate `app_database.g.dart`. Failing to regenerate will cause type/analysis errors.
- Native sqlite libs: `sqlite3_flutter_libs` is included. For platform builds make sure native tooling (Android NDK, Xcode) is available when building for those platforms.
- TF Lite models: `tflite_flutter` is a runtime dependency for local inference; model files may be stored as assets (search `assets/` and `pubspec.yaml` if adding models). Unit tests should mock model interactions where possible.
- Background services: `lib/src/services/background/` interacts with DB directly — be cautious about threading and isolate boundaries. Prefer repository interfaces when possible.

Integration points & external dependencies

- Drift DB: `lib/src/data/datasources/local/app_database.dart` — central integration. Repositories import it as `as db` (e.g., `import '../datasources/local/app_database.dart' as db;`).
- Providers: `lib/src/providers/data_providers.dart` constructs and exposes DB/repo providers that features depend on.
- Exports & file I/O: `lib/src/services/export/` writes CSV/PDF. Use `path_provider` and platform-safe file APIs.
- HTTP & external LLM: `http` package is present for cloud LLM calls; search `lib/src/domain/interfaces/ai_interfaces.dart` for planned AI integration points.

Examples to reference

- Mapping ECG batch (decompression): `lib/src/data/models/data_mappers.dart`, extension `EcgSampleBatchEntityMapper` (uses `decompressVoltageData` and `decompressRPeakIndices`).
- Repository patterns: `lib/src/data/repositories/drift_sample_repository.dart` and `drift_session_repository.dart` show query patterns and conversion using mappers.

Editing rules for AI agents

- Preserve human-written comments and extension method contracts in `data_mappers.dart` when editing mapping logic.
- When adding tables/columns: update `database_tables.dart`, run codegen, then add domain model and mapping extensions in `data_mappers.dart`.
- Avoid changing generated files (`*.g.dart`, `.drift.g.part`) manually — instead modify sources and run `build_runner`.

Edge cases to consider for edits and tests

- Nullability: many JSON columns are nullable — guard `jsonDecode` with `!= null` checks.
- Large ECG blobs: decompress/computation may be CPU-heavy — prefer streaming or isolates for heavy processing.
- Enum mismatches: mapping back enums uses `firstWhere(..., orElse: ...)` — keep safe fallbacks to avoid crashes on unknown strings.

Where to look first when debugging

1. `lib/src/providers/data_providers.dart` — ensures DB & repositories are wired correctly.
2. `lib/src/data/datasources/local/app_database.dart` and `database_tables.dart` — DB schema and table definitions.
3. `lib/src/data/models/data_mappers.dart` — model conversion, JSON and compression helpers usage.
4. `lib/src/data/repositories/*` — actual DB queries & data flow used by features.

If you change behavior, also update or add tests under `test/`. There are existing unit tests in `test/domain/` and `test/` — use `flutter test` to run them.

Questions for the maintainer (if uncertain)

- Where are TF Lite model assets stored (if used) and how should tests mock them?
- Are there CI steps (e.g., codegen) that must run pre-merge? If so, include them in this file.

If this guidance looks good, I can refine specific sections (CI steps, more examples, or merge existing agent docs) — tell me which area to expand.
