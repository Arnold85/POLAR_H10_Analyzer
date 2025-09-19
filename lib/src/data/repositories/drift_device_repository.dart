import 'package:drift/drift.dart';
import '../../domain/models/polar_device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/local/app_database.dart' as db;
import '../models/data_mappers.dart';

/// Concrete implementation of DeviceRepository using Drift database
class DriftDeviceRepository implements DeviceRepository {
  final db.AppDatabase _database;

  const DriftDeviceRepository(this._database);

  @override
  Future<List<PolarDevice>> getDevices() async {
    final entities = await _database.select(_database.polarDevices).get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<PolarDevice?> getDevice(String deviceId) async {
    final entity = await (_database.select(_database.polarDevices)
          ..where((device) => device.deviceId.equals(deviceId)))
        .getSingleOrNull();
    
    return entity?.toDomainModel();
  }

  @override
  Future<void> saveDevice(PolarDevice device) async {
    await _database.into(_database.polarDevices).insertOnConflictUpdate(
      device.toCompanion(),
    );
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await (_database.delete(_database.polarDevices)
          ..where((device) => device.deviceId.equals(deviceId)))
        .go();
  }

  @override
  Future<void> updateConnectionStatus(
    String deviceId,
    DeviceConnectionStatus status,
  ) async {
    await (_database.update(_database.polarDevices)
          ..where((device) => device.deviceId.equals(deviceId)))
        .write(db.PolarDevicesCompanion(
      connectionStatus: Value(status.name),
      lastSeen: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> updateSignalQuality(String deviceId, int quality) async {
    await (_database.update(_database.polarDevices)
          ..where((device) => device.deviceId.equals(deviceId)))
        .write(db.PolarDevicesCompanion(
      signalQuality: Value(quality),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> updateElectrodeStatus(
    String deviceId,
    ElectrodeStatus status,
  ) async {
    await (_database.update(_database.polarDevices)
          ..where((device) => device.deviceId.equals(deviceId)))
        .write(db.PolarDevicesCompanion(
      electrodeStatus: Value(status.name),
      updatedAt: Value(DateTime.now()),
    ));
  }
}

// Mapping extension for `db.PolarDevice` moved to `data_mappers.dart`.