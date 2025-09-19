// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PolarDevicesTable extends PolarDevices
    with TableInfo<$PolarDevicesTable, PolarDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PolarDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firmwareVersionMeta = const VerificationMeta(
    'firmwareVersion',
  );
  @override
  late final GeneratedColumn<String> firmwareVersion = GeneratedColumn<String>(
    'firmware_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batteryLevelMeta = const VerificationMeta(
    'batteryLevel',
  );
  @override
  late final GeneratedColumn<int> batteryLevel = GeneratedColumn<int>(
    'battery_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _connectionStatusMeta = const VerificationMeta(
    'connectionStatus',
  );
  @override
  late final GeneratedColumn<String> connectionStatus = GeneratedColumn<String>(
    'connection_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signalQualityMeta = const VerificationMeta(
    'signalQuality',
  );
  @override
  late final GeneratedColumn<int> signalQuality = GeneratedColumn<int>(
    'signal_quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _electrodeStatusMeta = const VerificationMeta(
    'electrodeStatus',
  );
  @override
  late final GeneratedColumn<String> electrodeStatus = GeneratedColumn<String>(
    'electrode_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    name,
    firmwareVersion,
    batteryLevel,
    connectionStatus,
    signalQuality,
    electrodeStatus,
    lastSeen,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'polar_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<PolarDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('firmware_version')) {
      context.handle(
        _firmwareVersionMeta,
        firmwareVersion.isAcceptableOrUnknown(
          data['firmware_version']!,
          _firmwareVersionMeta,
        ),
      );
    }
    if (data.containsKey('battery_level')) {
      context.handle(
        _batteryLevelMeta,
        batteryLevel.isAcceptableOrUnknown(
          data['battery_level']!,
          _batteryLevelMeta,
        ),
      );
    }
    if (data.containsKey('connection_status')) {
      context.handle(
        _connectionStatusMeta,
        connectionStatus.isAcceptableOrUnknown(
          data['connection_status']!,
          _connectionStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectionStatusMeta);
    }
    if (data.containsKey('signal_quality')) {
      context.handle(
        _signalQualityMeta,
        signalQuality.isAcceptableOrUnknown(
          data['signal_quality']!,
          _signalQualityMeta,
        ),
      );
    }
    if (data.containsKey('electrode_status')) {
      context.handle(
        _electrodeStatusMeta,
        electrodeStatus.isAcceptableOrUnknown(
          data['electrode_status']!,
          _electrodeStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_electrodeStatusMeta);
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    } else if (isInserting) {
      context.missing(_lastSeenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  PolarDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PolarDevice(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      firmwareVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firmware_version'],
      ),
      batteryLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}battery_level'],
      ),
      connectionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connection_status'],
      )!,
      signalQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}signal_quality'],
      ),
      electrodeStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}electrode_status'],
      )!,
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PolarDevicesTable createAlias(String alias) {
    return $PolarDevicesTable(attachedDatabase, alias);
  }
}

class PolarDevice extends DataClass implements Insertable<PolarDevice> {
  final String deviceId;
  final String name;
  final String? firmwareVersion;
  final int? batteryLevel;
  final String connectionStatus;
  final int? signalQuality;
  final String electrodeStatus;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PolarDevice({
    required this.deviceId,
    required this.name,
    this.firmwareVersion,
    this.batteryLevel,
    required this.connectionStatus,
    this.signalQuality,
    required this.electrodeStatus,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || firmwareVersion != null) {
      map['firmware_version'] = Variable<String>(firmwareVersion);
    }
    if (!nullToAbsent || batteryLevel != null) {
      map['battery_level'] = Variable<int>(batteryLevel);
    }
    map['connection_status'] = Variable<String>(connectionStatus);
    if (!nullToAbsent || signalQuality != null) {
      map['signal_quality'] = Variable<int>(signalQuality);
    }
    map['electrode_status'] = Variable<String>(electrodeStatus);
    map['last_seen'] = Variable<DateTime>(lastSeen);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PolarDevicesCompanion toCompanion(bool nullToAbsent) {
    return PolarDevicesCompanion(
      deviceId: Value(deviceId),
      name: Value(name),
      firmwareVersion: firmwareVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(firmwareVersion),
      batteryLevel: batteryLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(batteryLevel),
      connectionStatus: Value(connectionStatus),
      signalQuality: signalQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(signalQuality),
      electrodeStatus: Value(electrodeStatus),
      lastSeen: Value(lastSeen),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PolarDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PolarDevice(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      firmwareVersion: serializer.fromJson<String?>(json['firmwareVersion']),
      batteryLevel: serializer.fromJson<int?>(json['batteryLevel']),
      connectionStatus: serializer.fromJson<String>(json['connectionStatus']),
      signalQuality: serializer.fromJson<int?>(json['signalQuality']),
      electrodeStatus: serializer.fromJson<String>(json['electrodeStatus']),
      lastSeen: serializer.fromJson<DateTime>(json['lastSeen']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'firmwareVersion': serializer.toJson<String?>(firmwareVersion),
      'batteryLevel': serializer.toJson<int?>(batteryLevel),
      'connectionStatus': serializer.toJson<String>(connectionStatus),
      'signalQuality': serializer.toJson<int?>(signalQuality),
      'electrodeStatus': serializer.toJson<String>(electrodeStatus),
      'lastSeen': serializer.toJson<DateTime>(lastSeen),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PolarDevice copyWith({
    String? deviceId,
    String? name,
    Value<String?> firmwareVersion = const Value.absent(),
    Value<int?> batteryLevel = const Value.absent(),
    String? connectionStatus,
    Value<int?> signalQuality = const Value.absent(),
    String? electrodeStatus,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PolarDevice(
    deviceId: deviceId ?? this.deviceId,
    name: name ?? this.name,
    firmwareVersion: firmwareVersion.present
        ? firmwareVersion.value
        : this.firmwareVersion,
    batteryLevel: batteryLevel.present ? batteryLevel.value : this.batteryLevel,
    connectionStatus: connectionStatus ?? this.connectionStatus,
    signalQuality: signalQuality.present
        ? signalQuality.value
        : this.signalQuality,
    electrodeStatus: electrodeStatus ?? this.electrodeStatus,
    lastSeen: lastSeen ?? this.lastSeen,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PolarDevice copyWithCompanion(PolarDevicesCompanion data) {
    return PolarDevice(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      firmwareVersion: data.firmwareVersion.present
          ? data.firmwareVersion.value
          : this.firmwareVersion,
      batteryLevel: data.batteryLevel.present
          ? data.batteryLevel.value
          : this.batteryLevel,
      connectionStatus: data.connectionStatus.present
          ? data.connectionStatus.value
          : this.connectionStatus,
      signalQuality: data.signalQuality.present
          ? data.signalQuality.value
          : this.signalQuality,
      electrodeStatus: data.electrodeStatus.present
          ? data.electrodeStatus.value
          : this.electrodeStatus,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PolarDevice(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('firmwareVersion: $firmwareVersion, ')
          ..write('batteryLevel: $batteryLevel, ')
          ..write('connectionStatus: $connectionStatus, ')
          ..write('signalQuality: $signalQuality, ')
          ..write('electrodeStatus: $electrodeStatus, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    deviceId,
    name,
    firmwareVersion,
    batteryLevel,
    connectionStatus,
    signalQuality,
    electrodeStatus,
    lastSeen,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PolarDevice &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.firmwareVersion == this.firmwareVersion &&
          other.batteryLevel == this.batteryLevel &&
          other.connectionStatus == this.connectionStatus &&
          other.signalQuality == this.signalQuality &&
          other.electrodeStatus == this.electrodeStatus &&
          other.lastSeen == this.lastSeen &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PolarDevicesCompanion extends UpdateCompanion<PolarDevice> {
  final Value<String> deviceId;
  final Value<String> name;
  final Value<String?> firmwareVersion;
  final Value<int?> batteryLevel;
  final Value<String> connectionStatus;
  final Value<int?> signalQuality;
  final Value<String> electrodeStatus;
  final Value<DateTime> lastSeen;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PolarDevicesCompanion({
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.firmwareVersion = const Value.absent(),
    this.batteryLevel = const Value.absent(),
    this.connectionStatus = const Value.absent(),
    this.signalQuality = const Value.absent(),
    this.electrodeStatus = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PolarDevicesCompanion.insert({
    required String deviceId,
    required String name,
    this.firmwareVersion = const Value.absent(),
    this.batteryLevel = const Value.absent(),
    required String connectionStatus,
    this.signalQuality = const Value.absent(),
    required String electrodeStatus,
    required DateTime lastSeen,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       name = Value(name),
       connectionStatus = Value(connectionStatus),
       electrodeStatus = Value(electrodeStatus),
       lastSeen = Value(lastSeen);
  static Insertable<PolarDevice> custom({
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? firmwareVersion,
    Expression<int>? batteryLevel,
    Expression<String>? connectionStatus,
    Expression<int>? signalQuality,
    Expression<String>? electrodeStatus,
    Expression<DateTime>? lastSeen,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (firmwareVersion != null) 'firmware_version': firmwareVersion,
      if (batteryLevel != null) 'battery_level': batteryLevel,
      if (connectionStatus != null) 'connection_status': connectionStatus,
      if (signalQuality != null) 'signal_quality': signalQuality,
      if (electrodeStatus != null) 'electrode_status': electrodeStatus,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PolarDevicesCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? name,
    Value<String?>? firmwareVersion,
    Value<int?>? batteryLevel,
    Value<String>? connectionStatus,
    Value<int?>? signalQuality,
    Value<String>? electrodeStatus,
    Value<DateTime>? lastSeen,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PolarDevicesCompanion(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      signalQuality: signalQuality ?? this.signalQuality,
      electrodeStatus: electrodeStatus ?? this.electrodeStatus,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (firmwareVersion.present) {
      map['firmware_version'] = Variable<String>(firmwareVersion.value);
    }
    if (batteryLevel.present) {
      map['battery_level'] = Variable<int>(batteryLevel.value);
    }
    if (connectionStatus.present) {
      map['connection_status'] = Variable<String>(connectionStatus.value);
    }
    if (signalQuality.present) {
      map['signal_quality'] = Variable<int>(signalQuality.value);
    }
    if (electrodeStatus.present) {
      map['electrode_status'] = Variable<String>(electrodeStatus.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PolarDevicesCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('firmwareVersion: $firmwareVersion, ')
          ..write('batteryLevel: $batteryLevel, ')
          ..write('connectionStatus: $connectionStatus, ')
          ..write('signalQuality: $signalQuality, ')
          ..write('electrodeStatus: $electrodeStatus, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementSessionsTable extends MeasurementSessions
    with TableInfo<$MeasurementSessionsTable, MeasurementSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    deviceId,
    startTime,
    endTime,
    status,
    type,
    tags,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  MeasurementSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementSession(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MeasurementSessionsTable createAlias(String alias) {
    return $MeasurementSessionsTable(attachedDatabase, alias);
  }
}

class MeasurementSession extends DataClass
    implements Insertable<MeasurementSession> {
  final String sessionId;
  final String deviceId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final String type;
  final String? tags;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MeasurementSession({
    required this.sessionId,
    required this.deviceId,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.type,
    this.tags,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['device_id'] = Variable<String>(deviceId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['status'] = Variable<String>(status);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MeasurementSessionsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementSessionsCompanion(
      sessionId: Value(sessionId),
      deviceId: Value(deviceId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      status: Value(status),
      type: Value(type),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MeasurementSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementSession(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      status: serializer.fromJson<String>(json['status']),
      type: serializer.fromJson<String>(json['type']),
      tags: serializer.fromJson<String?>(json['tags']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'deviceId': serializer.toJson<String>(deviceId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'status': serializer.toJson<String>(status),
      'type': serializer.toJson<String>(type),
      'tags': serializer.toJson<String?>(tags),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MeasurementSession copyWith({
    String? sessionId,
    String? deviceId,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    String? status,
    String? type,
    Value<String?> tags = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MeasurementSession(
    sessionId: sessionId ?? this.sessionId,
    deviceId: deviceId ?? this.deviceId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    status: status ?? this.status,
    type: type ?? this.type,
    tags: tags.present ? tags.value : this.tags,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MeasurementSession copyWithCompanion(MeasurementSessionsCompanion data) {
    return MeasurementSession(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      status: data.status.present ? data.status.value : this.status,
      type: data.type.present ? data.type.value : this.type,
      tags: data.tags.present ? data.tags.value : this.tags,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementSession(')
          ..write('sessionId: $sessionId, ')
          ..write('deviceId: $deviceId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    deviceId,
    startTime,
    endTime,
    status,
    type,
    tags,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementSession &&
          other.sessionId == this.sessionId &&
          other.deviceId == this.deviceId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.status == this.status &&
          other.type == this.type &&
          other.tags == this.tags &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MeasurementSessionsCompanion extends UpdateCompanion<MeasurementSession> {
  final Value<String> sessionId;
  final Value<String> deviceId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<String> status;
  final Value<String> type;
  final Value<String?> tags;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MeasurementSessionsCompanion({
    this.sessionId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementSessionsCompanion.insert({
    required String sessionId,
    required String deviceId,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    required String status,
    required String type,
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       deviceId = Value(deviceId),
       startTime = Value(startTime),
       status = Value(status),
       type = Value(type);
  static Insertable<MeasurementSession> custom({
    Expression<String>? sessionId,
    Expression<String>? deviceId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? status,
    Expression<String>? type,
    Expression<String>? tags,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (deviceId != null) 'device_id': deviceId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (status != null) 'status': status,
      if (type != null) 'type': type,
      if (tags != null) 'tags': tags,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementSessionsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? deviceId,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<String>? status,
    Value<String>? type,
    Value<String?>? tags,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MeasurementSessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      deviceId: deviceId ?? this.deviceId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementSessionsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('deviceId: $deviceId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EcgSamplesTable extends EcgSamples
    with TableInfo<$EcgSamplesTable, EcgSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EcgSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voltageMeta = const VerificationMeta(
    'voltage',
  );
  @override
  late final GeneratedColumn<double> voltage = GeneratedColumn<double>(
    'voltage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sequenceNumberMeta = const VerificationMeta(
    'sequenceNumber',
  );
  @override
  late final GeneratedColumn<int> sequenceNumber = GeneratedColumn<int>(
    'sequence_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRPeakMeta = const VerificationMeta(
    'isRPeak',
  );
  @override
  late final GeneratedColumn<bool> isRPeak = GeneratedColumn<bool>(
    'is_r_peak',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_r_peak" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _leadIdMeta = const VerificationMeta('leadId');
  @override
  late final GeneratedColumn<String> leadId = GeneratedColumn<String>(
    'lead_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    timestamp,
    voltage,
    sequenceNumber,
    quality,
    isRPeak,
    leadId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ecg_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<EcgSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('voltage')) {
      context.handle(
        _voltageMeta,
        voltage.isAcceptableOrUnknown(data['voltage']!, _voltageMeta),
      );
    } else if (isInserting) {
      context.missing(_voltageMeta);
    }
    if (data.containsKey('sequence_number')) {
      context.handle(
        _sequenceNumberMeta,
        sequenceNumber.isAcceptableOrUnknown(
          data['sequence_number']!,
          _sequenceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sequenceNumberMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('is_r_peak')) {
      context.handle(
        _isRPeakMeta,
        isRPeak.isAcceptableOrUnknown(data['is_r_peak']!, _isRPeakMeta),
      );
    }
    if (data.containsKey('lead_id')) {
      context.handle(
        _leadIdMeta,
        leadId.isAcceptableOrUnknown(data['lead_id']!, _leadIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionId, sequenceNumber},
  ];
  @override
  EcgSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EcgSample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      voltage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}voltage'],
      )!,
      sequenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence_number'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      ),
      isRPeak: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_r_peak'],
      )!,
      leadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lead_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EcgSamplesTable createAlias(String alias) {
    return $EcgSamplesTable(attachedDatabase, alias);
  }
}

class EcgSample extends DataClass implements Insertable<EcgSample> {
  final int id;
  final String sessionId;
  final DateTime timestamp;
  final double voltage;
  final int sequenceNumber;
  final int? quality;
  final bool isRPeak;
  final String? leadId;
  final DateTime createdAt;
  const EcgSample({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.voltage,
    required this.sequenceNumber,
    this.quality,
    required this.isRPeak,
    this.leadId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['voltage'] = Variable<double>(voltage);
    map['sequence_number'] = Variable<int>(sequenceNumber);
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<int>(quality);
    }
    map['is_r_peak'] = Variable<bool>(isRPeak);
    if (!nullToAbsent || leadId != null) {
      map['lead_id'] = Variable<String>(leadId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EcgSamplesCompanion toCompanion(bool nullToAbsent) {
    return EcgSamplesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestamp: Value(timestamp),
      voltage: Value(voltage),
      sequenceNumber: Value(sequenceNumber),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      isRPeak: Value(isRPeak),
      leadId: leadId == null && nullToAbsent
          ? const Value.absent()
          : Value(leadId),
      createdAt: Value(createdAt),
    );
  }

  factory EcgSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EcgSample(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      voltage: serializer.fromJson<double>(json['voltage']),
      sequenceNumber: serializer.fromJson<int>(json['sequenceNumber']),
      quality: serializer.fromJson<int?>(json['quality']),
      isRPeak: serializer.fromJson<bool>(json['isRPeak']),
      leadId: serializer.fromJson<String?>(json['leadId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'voltage': serializer.toJson<double>(voltage),
      'sequenceNumber': serializer.toJson<int>(sequenceNumber),
      'quality': serializer.toJson<int?>(quality),
      'isRPeak': serializer.toJson<bool>(isRPeak),
      'leadId': serializer.toJson<String?>(leadId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EcgSample copyWith({
    int? id,
    String? sessionId,
    DateTime? timestamp,
    double? voltage,
    int? sequenceNumber,
    Value<int?> quality = const Value.absent(),
    bool? isRPeak,
    Value<String?> leadId = const Value.absent(),
    DateTime? createdAt,
  }) => EcgSample(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    timestamp: timestamp ?? this.timestamp,
    voltage: voltage ?? this.voltage,
    sequenceNumber: sequenceNumber ?? this.sequenceNumber,
    quality: quality.present ? quality.value : this.quality,
    isRPeak: isRPeak ?? this.isRPeak,
    leadId: leadId.present ? leadId.value : this.leadId,
    createdAt: createdAt ?? this.createdAt,
  );
  EcgSample copyWithCompanion(EcgSamplesCompanion data) {
    return EcgSample(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      voltage: data.voltage.present ? data.voltage.value : this.voltage,
      sequenceNumber: data.sequenceNumber.present
          ? data.sequenceNumber.value
          : this.sequenceNumber,
      quality: data.quality.present ? data.quality.value : this.quality,
      isRPeak: data.isRPeak.present ? data.isRPeak.value : this.isRPeak,
      leadId: data.leadId.present ? data.leadId.value : this.leadId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EcgSample(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('voltage: $voltage, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('quality: $quality, ')
          ..write('isRPeak: $isRPeak, ')
          ..write('leadId: $leadId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    timestamp,
    voltage,
    sequenceNumber,
    quality,
    isRPeak,
    leadId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EcgSample &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestamp == this.timestamp &&
          other.voltage == this.voltage &&
          other.sequenceNumber == this.sequenceNumber &&
          other.quality == this.quality &&
          other.isRPeak == this.isRPeak &&
          other.leadId == this.leadId &&
          other.createdAt == this.createdAt);
}

class EcgSamplesCompanion extends UpdateCompanion<EcgSample> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<DateTime> timestamp;
  final Value<double> voltage;
  final Value<int> sequenceNumber;
  final Value<int?> quality;
  final Value<bool> isRPeak;
  final Value<String?> leadId;
  final Value<DateTime> createdAt;
  const EcgSamplesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.voltage = const Value.absent(),
    this.sequenceNumber = const Value.absent(),
    this.quality = const Value.absent(),
    this.isRPeak = const Value.absent(),
    this.leadId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EcgSamplesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required DateTime timestamp,
    required double voltage,
    required int sequenceNumber,
    this.quality = const Value.absent(),
    this.isRPeak = const Value.absent(),
    this.leadId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       timestamp = Value(timestamp),
       voltage = Value(voltage),
       sequenceNumber = Value(sequenceNumber);
  static Insertable<EcgSample> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<DateTime>? timestamp,
    Expression<double>? voltage,
    Expression<int>? sequenceNumber,
    Expression<int>? quality,
    Expression<bool>? isRPeak,
    Expression<String>? leadId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (voltage != null) 'voltage': voltage,
      if (sequenceNumber != null) 'sequence_number': sequenceNumber,
      if (quality != null) 'quality': quality,
      if (isRPeak != null) 'is_r_peak': isRPeak,
      if (leadId != null) 'lead_id': leadId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EcgSamplesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<DateTime>? timestamp,
    Value<double>? voltage,
    Value<int>? sequenceNumber,
    Value<int?>? quality,
    Value<bool>? isRPeak,
    Value<String?>? leadId,
    Value<DateTime>? createdAt,
  }) {
    return EcgSamplesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      voltage: voltage ?? this.voltage,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      quality: quality ?? this.quality,
      isRPeak: isRPeak ?? this.isRPeak,
      leadId: leadId ?? this.leadId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (voltage.present) {
      map['voltage'] = Variable<double>(voltage.value);
    }
    if (sequenceNumber.present) {
      map['sequence_number'] = Variable<int>(sequenceNumber.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (isRPeak.present) {
      map['is_r_peak'] = Variable<bool>(isRPeak.value);
    }
    if (leadId.present) {
      map['lead_id'] = Variable<String>(leadId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EcgSamplesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('voltage: $voltage, ')
          ..write('sequenceNumber: $sequenceNumber, ')
          ..write('quality: $quality, ')
          ..write('isRPeak: $isRPeak, ')
          ..write('leadId: $leadId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EcgSampleBatchesTable extends EcgSampleBatches
    with TableInfo<$EcgSampleBatchesTable, EcgSampleBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EcgSampleBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimestampMeta = const VerificationMeta(
    'startTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> startTimestamp =
      GeneratedColumn<DateTime>(
        'start_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _endTimestampMeta = const VerificationMeta(
    'endTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> endTimestamp = GeneratedColumn<DateTime>(
    'end_timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _samplingRateMeta = const VerificationMeta(
    'samplingRate',
  );
  @override
  late final GeneratedColumn<double> samplingRate = GeneratedColumn<double>(
    'sampling_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voltagesDataMeta = const VerificationMeta(
    'voltagesData',
  );
  @override
  late final GeneratedColumn<Uint8List> voltagesData =
      GeneratedColumn<Uint8List>(
        'voltages_data',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _rPeakIndicesMeta = const VerificationMeta(
    'rPeakIndices',
  );
  @override
  late final GeneratedColumn<Uint8List> rPeakIndices =
      GeneratedColumn<Uint8List>(
        'r_peak_indices',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _batchNumberMeta = const VerificationMeta(
    'batchNumber',
  );
  @override
  late final GeneratedColumn<int> batchNumber = GeneratedColumn<int>(
    'batch_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sampleCountMeta = const VerificationMeta(
    'sampleCount',
  );
  @override
  late final GeneratedColumn<int> sampleCount = GeneratedColumn<int>(
    'sample_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMetricsMeta = const VerificationMeta(
    'qualityMetrics',
  );
  @override
  late final GeneratedColumn<String> qualityMetrics = GeneratedColumn<String>(
    'quality_metrics',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    startTimestamp,
    endTimestamp,
    samplingRate,
    voltagesData,
    rPeakIndices,
    batchNumber,
    sampleCount,
    qualityMetrics,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ecg_sample_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<EcgSampleBatche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('start_timestamp')) {
      context.handle(
        _startTimestampMeta,
        startTimestamp.isAcceptableOrUnknown(
          data['start_timestamp']!,
          _startTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTimestampMeta);
    }
    if (data.containsKey('end_timestamp')) {
      context.handle(
        _endTimestampMeta,
        endTimestamp.isAcceptableOrUnknown(
          data['end_timestamp']!,
          _endTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endTimestampMeta);
    }
    if (data.containsKey('sampling_rate')) {
      context.handle(
        _samplingRateMeta,
        samplingRate.isAcceptableOrUnknown(
          data['sampling_rate']!,
          _samplingRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_samplingRateMeta);
    }
    if (data.containsKey('voltages_data')) {
      context.handle(
        _voltagesDataMeta,
        voltagesData.isAcceptableOrUnknown(
          data['voltages_data']!,
          _voltagesDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_voltagesDataMeta);
    }
    if (data.containsKey('r_peak_indices')) {
      context.handle(
        _rPeakIndicesMeta,
        rPeakIndices.isAcceptableOrUnknown(
          data['r_peak_indices']!,
          _rPeakIndicesMeta,
        ),
      );
    }
    if (data.containsKey('batch_number')) {
      context.handle(
        _batchNumberMeta,
        batchNumber.isAcceptableOrUnknown(
          data['batch_number']!,
          _batchNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batchNumberMeta);
    }
    if (data.containsKey('sample_count')) {
      context.handle(
        _sampleCountMeta,
        sampleCount.isAcceptableOrUnknown(
          data['sample_count']!,
          _sampleCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sampleCountMeta);
    }
    if (data.containsKey('quality_metrics')) {
      context.handle(
        _qualityMetricsMeta,
        qualityMetrics.isAcceptableOrUnknown(
          data['quality_metrics']!,
          _qualityMetricsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {sessionId, batchNumber},
  ];
  @override
  EcgSampleBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EcgSampleBatche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      startTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_timestamp'],
      )!,
      endTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_timestamp'],
      )!,
      samplingRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sampling_rate'],
      )!,
      voltagesData: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}voltages_data'],
      )!,
      rPeakIndices: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}r_peak_indices'],
      ),
      batchNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_number'],
      )!,
      sampleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_count'],
      )!,
      qualityMetrics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality_metrics'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EcgSampleBatchesTable createAlias(String alias) {
    return $EcgSampleBatchesTable(attachedDatabase, alias);
  }
}

class EcgSampleBatche extends DataClass implements Insertable<EcgSampleBatche> {
  final int id;
  final String sessionId;
  final DateTime startTimestamp;
  final DateTime endTimestamp;
  final double samplingRate;
  final Uint8List voltagesData;
  final Uint8List? rPeakIndices;
  final int batchNumber;
  final int sampleCount;
  final String? qualityMetrics;
  final DateTime createdAt;
  const EcgSampleBatche({
    required this.id,
    required this.sessionId,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.samplingRate,
    required this.voltagesData,
    this.rPeakIndices,
    required this.batchNumber,
    required this.sampleCount,
    this.qualityMetrics,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['start_timestamp'] = Variable<DateTime>(startTimestamp);
    map['end_timestamp'] = Variable<DateTime>(endTimestamp);
    map['sampling_rate'] = Variable<double>(samplingRate);
    map['voltages_data'] = Variable<Uint8List>(voltagesData);
    if (!nullToAbsent || rPeakIndices != null) {
      map['r_peak_indices'] = Variable<Uint8List>(rPeakIndices);
    }
    map['batch_number'] = Variable<int>(batchNumber);
    map['sample_count'] = Variable<int>(sampleCount);
    if (!nullToAbsent || qualityMetrics != null) {
      map['quality_metrics'] = Variable<String>(qualityMetrics);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EcgSampleBatchesCompanion toCompanion(bool nullToAbsent) {
    return EcgSampleBatchesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      startTimestamp: Value(startTimestamp),
      endTimestamp: Value(endTimestamp),
      samplingRate: Value(samplingRate),
      voltagesData: Value(voltagesData),
      rPeakIndices: rPeakIndices == null && nullToAbsent
          ? const Value.absent()
          : Value(rPeakIndices),
      batchNumber: Value(batchNumber),
      sampleCount: Value(sampleCount),
      qualityMetrics: qualityMetrics == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityMetrics),
      createdAt: Value(createdAt),
    );
  }

  factory EcgSampleBatche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EcgSampleBatche(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      startTimestamp: serializer.fromJson<DateTime>(json['startTimestamp']),
      endTimestamp: serializer.fromJson<DateTime>(json['endTimestamp']),
      samplingRate: serializer.fromJson<double>(json['samplingRate']),
      voltagesData: serializer.fromJson<Uint8List>(json['voltagesData']),
      rPeakIndices: serializer.fromJson<Uint8List?>(json['rPeakIndices']),
      batchNumber: serializer.fromJson<int>(json['batchNumber']),
      sampleCount: serializer.fromJson<int>(json['sampleCount']),
      qualityMetrics: serializer.fromJson<String?>(json['qualityMetrics']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'startTimestamp': serializer.toJson<DateTime>(startTimestamp),
      'endTimestamp': serializer.toJson<DateTime>(endTimestamp),
      'samplingRate': serializer.toJson<double>(samplingRate),
      'voltagesData': serializer.toJson<Uint8List>(voltagesData),
      'rPeakIndices': serializer.toJson<Uint8List?>(rPeakIndices),
      'batchNumber': serializer.toJson<int>(batchNumber),
      'sampleCount': serializer.toJson<int>(sampleCount),
      'qualityMetrics': serializer.toJson<String?>(qualityMetrics),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EcgSampleBatche copyWith({
    int? id,
    String? sessionId,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    double? samplingRate,
    Uint8List? voltagesData,
    Value<Uint8List?> rPeakIndices = const Value.absent(),
    int? batchNumber,
    int? sampleCount,
    Value<String?> qualityMetrics = const Value.absent(),
    DateTime? createdAt,
  }) => EcgSampleBatche(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    startTimestamp: startTimestamp ?? this.startTimestamp,
    endTimestamp: endTimestamp ?? this.endTimestamp,
    samplingRate: samplingRate ?? this.samplingRate,
    voltagesData: voltagesData ?? this.voltagesData,
    rPeakIndices: rPeakIndices.present ? rPeakIndices.value : this.rPeakIndices,
    batchNumber: batchNumber ?? this.batchNumber,
    sampleCount: sampleCount ?? this.sampleCount,
    qualityMetrics: qualityMetrics.present
        ? qualityMetrics.value
        : this.qualityMetrics,
    createdAt: createdAt ?? this.createdAt,
  );
  EcgSampleBatche copyWithCompanion(EcgSampleBatchesCompanion data) {
    return EcgSampleBatche(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      startTimestamp: data.startTimestamp.present
          ? data.startTimestamp.value
          : this.startTimestamp,
      endTimestamp: data.endTimestamp.present
          ? data.endTimestamp.value
          : this.endTimestamp,
      samplingRate: data.samplingRate.present
          ? data.samplingRate.value
          : this.samplingRate,
      voltagesData: data.voltagesData.present
          ? data.voltagesData.value
          : this.voltagesData,
      rPeakIndices: data.rPeakIndices.present
          ? data.rPeakIndices.value
          : this.rPeakIndices,
      batchNumber: data.batchNumber.present
          ? data.batchNumber.value
          : this.batchNumber,
      sampleCount: data.sampleCount.present
          ? data.sampleCount.value
          : this.sampleCount,
      qualityMetrics: data.qualityMetrics.present
          ? data.qualityMetrics.value
          : this.qualityMetrics,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EcgSampleBatche(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('startTimestamp: $startTimestamp, ')
          ..write('endTimestamp: $endTimestamp, ')
          ..write('samplingRate: $samplingRate, ')
          ..write('voltagesData: $voltagesData, ')
          ..write('rPeakIndices: $rPeakIndices, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('qualityMetrics: $qualityMetrics, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    startTimestamp,
    endTimestamp,
    samplingRate,
    $driftBlobEquality.hash(voltagesData),
    $driftBlobEquality.hash(rPeakIndices),
    batchNumber,
    sampleCount,
    qualityMetrics,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EcgSampleBatche &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.startTimestamp == this.startTimestamp &&
          other.endTimestamp == this.endTimestamp &&
          other.samplingRate == this.samplingRate &&
          $driftBlobEquality.equals(other.voltagesData, this.voltagesData) &&
          $driftBlobEquality.equals(other.rPeakIndices, this.rPeakIndices) &&
          other.batchNumber == this.batchNumber &&
          other.sampleCount == this.sampleCount &&
          other.qualityMetrics == this.qualityMetrics &&
          other.createdAt == this.createdAt);
}

class EcgSampleBatchesCompanion extends UpdateCompanion<EcgSampleBatche> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<DateTime> startTimestamp;
  final Value<DateTime> endTimestamp;
  final Value<double> samplingRate;
  final Value<Uint8List> voltagesData;
  final Value<Uint8List?> rPeakIndices;
  final Value<int> batchNumber;
  final Value<int> sampleCount;
  final Value<String?> qualityMetrics;
  final Value<DateTime> createdAt;
  const EcgSampleBatchesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.startTimestamp = const Value.absent(),
    this.endTimestamp = const Value.absent(),
    this.samplingRate = const Value.absent(),
    this.voltagesData = const Value.absent(),
    this.rPeakIndices = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.qualityMetrics = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EcgSampleBatchesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required DateTime startTimestamp,
    required DateTime endTimestamp,
    required double samplingRate,
    required Uint8List voltagesData,
    this.rPeakIndices = const Value.absent(),
    required int batchNumber,
    required int sampleCount,
    this.qualityMetrics = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       startTimestamp = Value(startTimestamp),
       endTimestamp = Value(endTimestamp),
       samplingRate = Value(samplingRate),
       voltagesData = Value(voltagesData),
       batchNumber = Value(batchNumber),
       sampleCount = Value(sampleCount);
  static Insertable<EcgSampleBatche> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<DateTime>? startTimestamp,
    Expression<DateTime>? endTimestamp,
    Expression<double>? samplingRate,
    Expression<Uint8List>? voltagesData,
    Expression<Uint8List>? rPeakIndices,
    Expression<int>? batchNumber,
    Expression<int>? sampleCount,
    Expression<String>? qualityMetrics,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (startTimestamp != null) 'start_timestamp': startTimestamp,
      if (endTimestamp != null) 'end_timestamp': endTimestamp,
      if (samplingRate != null) 'sampling_rate': samplingRate,
      if (voltagesData != null) 'voltages_data': voltagesData,
      if (rPeakIndices != null) 'r_peak_indices': rPeakIndices,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (sampleCount != null) 'sample_count': sampleCount,
      if (qualityMetrics != null) 'quality_metrics': qualityMetrics,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EcgSampleBatchesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<DateTime>? startTimestamp,
    Value<DateTime>? endTimestamp,
    Value<double>? samplingRate,
    Value<Uint8List>? voltagesData,
    Value<Uint8List?>? rPeakIndices,
    Value<int>? batchNumber,
    Value<int>? sampleCount,
    Value<String?>? qualityMetrics,
    Value<DateTime>? createdAt,
  }) {
    return EcgSampleBatchesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      samplingRate: samplingRate ?? this.samplingRate,
      voltagesData: voltagesData ?? this.voltagesData,
      rPeakIndices: rPeakIndices ?? this.rPeakIndices,
      batchNumber: batchNumber ?? this.batchNumber,
      sampleCount: sampleCount ?? this.sampleCount,
      qualityMetrics: qualityMetrics ?? this.qualityMetrics,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (startTimestamp.present) {
      map['start_timestamp'] = Variable<DateTime>(startTimestamp.value);
    }
    if (endTimestamp.present) {
      map['end_timestamp'] = Variable<DateTime>(endTimestamp.value);
    }
    if (samplingRate.present) {
      map['sampling_rate'] = Variable<double>(samplingRate.value);
    }
    if (voltagesData.present) {
      map['voltages_data'] = Variable<Uint8List>(voltagesData.value);
    }
    if (rPeakIndices.present) {
      map['r_peak_indices'] = Variable<Uint8List>(rPeakIndices.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<int>(batchNumber.value);
    }
    if (sampleCount.present) {
      map['sample_count'] = Variable<int>(sampleCount.value);
    }
    if (qualityMetrics.present) {
      map['quality_metrics'] = Variable<String>(qualityMetrics.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EcgSampleBatchesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('startTimestamp: $startTimestamp, ')
          ..write('endTimestamp: $endTimestamp, ')
          ..write('samplingRate: $samplingRate, ')
          ..write('voltagesData: $voltagesData, ')
          ..write('rPeakIndices: $rPeakIndices, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('qualityMetrics: $qualityMetrics, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HeartRateSamplesTable extends HeartRateSamples
    with TableInfo<$HeartRateSamplesTable, HeartRateSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeartRateSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heartRateMeta = const VerificationMeta(
    'heartRate',
  );
  @override
  late final GeneratedColumn<int> heartRate = GeneratedColumn<int>(
    'heart_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rrIntervalsMeta = const VerificationMeta(
    'rrIntervals',
  );
  @override
  late final GeneratedColumn<String> rrIntervals = GeneratedColumn<String>(
    'rr_intervals',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactDetectedMeta = const VerificationMeta(
    'contactDetected',
  );
  @override
  late final GeneratedColumn<bool> contactDetected = GeneratedColumn<bool>(
    'contact_detected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("contact_detected" IN (0, 1))',
    ),
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    timestamp,
    heartRate,
    rrIntervals,
    contactDetected,
    quality,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heart_rate_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeartRateSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('heart_rate')) {
      context.handle(
        _heartRateMeta,
        heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta),
      );
    } else if (isInserting) {
      context.missing(_heartRateMeta);
    }
    if (data.containsKey('rr_intervals')) {
      context.handle(
        _rrIntervalsMeta,
        rrIntervals.isAcceptableOrUnknown(
          data['rr_intervals']!,
          _rrIntervalsMeta,
        ),
      );
    }
    if (data.containsKey('contact_detected')) {
      context.handle(
        _contactDetectedMeta,
        contactDetected.isAcceptableOrUnknown(
          data['contact_detected']!,
          _contactDetectedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contactDetectedMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeartRateSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeartRateSample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      heartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}heart_rate'],
      )!,
      rrIntervals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rr_intervals'],
      ),
      contactDetected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}contact_detected'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HeartRateSamplesTable createAlias(String alias) {
    return $HeartRateSamplesTable(attachedDatabase, alias);
  }
}

class HeartRateSample extends DataClass implements Insertable<HeartRateSample> {
  final int id;
  final String sessionId;
  final DateTime timestamp;
  final int heartRate;
  final String? rrIntervals;
  final bool contactDetected;
  final int? quality;
  final String source;
  final DateTime createdAt;
  const HeartRateSample({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.heartRate,
    this.rrIntervals,
    required this.contactDetected,
    this.quality,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['heart_rate'] = Variable<int>(heartRate);
    if (!nullToAbsent || rrIntervals != null) {
      map['rr_intervals'] = Variable<String>(rrIntervals);
    }
    map['contact_detected'] = Variable<bool>(contactDetected);
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<int>(quality);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HeartRateSamplesCompanion toCompanion(bool nullToAbsent) {
    return HeartRateSamplesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestamp: Value(timestamp),
      heartRate: Value(heartRate),
      rrIntervals: rrIntervals == null && nullToAbsent
          ? const Value.absent()
          : Value(rrIntervals),
      contactDetected: Value(contactDetected),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory HeartRateSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeartRateSample(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      heartRate: serializer.fromJson<int>(json['heartRate']),
      rrIntervals: serializer.fromJson<String?>(json['rrIntervals']),
      contactDetected: serializer.fromJson<bool>(json['contactDetected']),
      quality: serializer.fromJson<int?>(json['quality']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'heartRate': serializer.toJson<int>(heartRate),
      'rrIntervals': serializer.toJson<String?>(rrIntervals),
      'contactDetected': serializer.toJson<bool>(contactDetected),
      'quality': serializer.toJson<int?>(quality),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HeartRateSample copyWith({
    int? id,
    String? sessionId,
    DateTime? timestamp,
    int? heartRate,
    Value<String?> rrIntervals = const Value.absent(),
    bool? contactDetected,
    Value<int?> quality = const Value.absent(),
    String? source,
    DateTime? createdAt,
  }) => HeartRateSample(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    timestamp: timestamp ?? this.timestamp,
    heartRate: heartRate ?? this.heartRate,
    rrIntervals: rrIntervals.present ? rrIntervals.value : this.rrIntervals,
    contactDetected: contactDetected ?? this.contactDetected,
    quality: quality.present ? quality.value : this.quality,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  HeartRateSample copyWithCompanion(HeartRateSamplesCompanion data) {
    return HeartRateSample(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      rrIntervals: data.rrIntervals.present
          ? data.rrIntervals.value
          : this.rrIntervals,
      contactDetected: data.contactDetected.present
          ? data.contactDetected.value
          : this.contactDetected,
      quality: data.quality.present ? data.quality.value : this.quality,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateSample(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('heartRate: $heartRate, ')
          ..write('rrIntervals: $rrIntervals, ')
          ..write('contactDetected: $contactDetected, ')
          ..write('quality: $quality, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    timestamp,
    heartRate,
    rrIntervals,
    contactDetected,
    quality,
    source,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeartRateSample &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestamp == this.timestamp &&
          other.heartRate == this.heartRate &&
          other.rrIntervals == this.rrIntervals &&
          other.contactDetected == this.contactDetected &&
          other.quality == this.quality &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class HeartRateSamplesCompanion extends UpdateCompanion<HeartRateSample> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<DateTime> timestamp;
  final Value<int> heartRate;
  final Value<String?> rrIntervals;
  final Value<bool> contactDetected;
  final Value<int?> quality;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const HeartRateSamplesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.rrIntervals = const Value.absent(),
    this.contactDetected = const Value.absent(),
    this.quality = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HeartRateSamplesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required DateTime timestamp,
    required int heartRate,
    this.rrIntervals = const Value.absent(),
    required bool contactDetected,
    this.quality = const Value.absent(),
    required String source,
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       timestamp = Value(timestamp),
       heartRate = Value(heartRate),
       contactDetected = Value(contactDetected),
       source = Value(source);
  static Insertable<HeartRateSample> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<DateTime>? timestamp,
    Expression<int>? heartRate,
    Expression<String>? rrIntervals,
    Expression<bool>? contactDetected,
    Expression<int>? quality,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (heartRate != null) 'heart_rate': heartRate,
      if (rrIntervals != null) 'rr_intervals': rrIntervals,
      if (contactDetected != null) 'contact_detected': contactDetected,
      if (quality != null) 'quality': quality,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HeartRateSamplesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<DateTime>? timestamp,
    Value<int>? heartRate,
    Value<String?>? rrIntervals,
    Value<bool>? contactDetected,
    Value<int?>? quality,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return HeartRateSamplesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      heartRate: heartRate ?? this.heartRate,
      rrIntervals: rrIntervals ?? this.rrIntervals,
      contactDetected: contactDetected ?? this.contactDetected,
      quality: quality ?? this.quality,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<int>(heartRate.value);
    }
    if (rrIntervals.present) {
      map['rr_intervals'] = Variable<String>(rrIntervals.value);
    }
    if (contactDetected.present) {
      map['contact_detected'] = Variable<bool>(contactDetected.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateSamplesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('heartRate: $heartRate, ')
          ..write('rrIntervals: $rrIntervals, ')
          ..write('contactDetected: $contactDetected, ')
          ..write('quality: $quality, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HrvSamplesTable extends HrvSamples
    with TableInfo<$HrvSamplesTable, HrvSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HrvSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rrIntervalsMeta = const VerificationMeta(
    'rrIntervals',
  );
  @override
  late final GeneratedColumn<String> rrIntervals = GeneratedColumn<String>(
    'rr_intervals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowSecondsMeta = const VerificationMeta(
    'windowSeconds',
  );
  @override
  late final GeneratedColumn<int> windowSeconds = GeneratedColumn<int>(
    'window_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rmssdMeta = const VerificationMeta('rmssd');
  @override
  late final GeneratedColumn<double> rmssd = GeneratedColumn<double>(
    'rmssd',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sdnnMeta = const VerificationMeta('sdnn');
  @override
  late final GeneratedColumn<double> sdnn = GeneratedColumn<double>(
    'sdnn',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pnn50Meta = const VerificationMeta('pnn50');
  @override
  late final GeneratedColumn<double> pnn50 = GeneratedColumn<double>(
    'pnn50',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meanRRMeta = const VerificationMeta('meanRR');
  @override
  late final GeneratedColumn<double> meanRR = GeneratedColumn<double>(
    'mean_r_r',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heartRateMeta = const VerificationMeta(
    'heartRate',
  );
  @override
  late final GeneratedColumn<double> heartRate = GeneratedColumn<double>(
    'heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressIndexMeta = const VerificationMeta(
    'stressIndex',
  );
  @override
  late final GeneratedColumn<int> stressIndex = GeneratedColumn<int>(
    'stress_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    timestamp,
    rrIntervals,
    windowSeconds,
    rmssd,
    sdnn,
    pnn50,
    meanRR,
    heartRate,
    stressIndex,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hrv_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<HrvSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('rr_intervals')) {
      context.handle(
        _rrIntervalsMeta,
        rrIntervals.isAcceptableOrUnknown(
          data['rr_intervals']!,
          _rrIntervalsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rrIntervalsMeta);
    }
    if (data.containsKey('window_seconds')) {
      context.handle(
        _windowSecondsMeta,
        windowSeconds.isAcceptableOrUnknown(
          data['window_seconds']!,
          _windowSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_windowSecondsMeta);
    }
    if (data.containsKey('rmssd')) {
      context.handle(
        _rmssdMeta,
        rmssd.isAcceptableOrUnknown(data['rmssd']!, _rmssdMeta),
      );
    }
    if (data.containsKey('sdnn')) {
      context.handle(
        _sdnnMeta,
        sdnn.isAcceptableOrUnknown(data['sdnn']!, _sdnnMeta),
      );
    }
    if (data.containsKey('pnn50')) {
      context.handle(
        _pnn50Meta,
        pnn50.isAcceptableOrUnknown(data['pnn50']!, _pnn50Meta),
      );
    }
    if (data.containsKey('mean_r_r')) {
      context.handle(
        _meanRRMeta,
        meanRR.isAcceptableOrUnknown(data['mean_r_r']!, _meanRRMeta),
      );
    }
    if (data.containsKey('heart_rate')) {
      context.handle(
        _heartRateMeta,
        heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta),
      );
    }
    if (data.containsKey('stress_index')) {
      context.handle(
        _stressIndexMeta,
        stressIndex.isAcceptableOrUnknown(
          data['stress_index']!,
          _stressIndexMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HrvSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HrvSample(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      rrIntervals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rr_intervals'],
      )!,
      windowSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}window_seconds'],
      )!,
      rmssd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rmssd'],
      ),
      sdnn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sdnn'],
      ),
      pnn50: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pnn50'],
      ),
      meanRR: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mean_r_r'],
      ),
      heartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heart_rate'],
      ),
      stressIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_index'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HrvSamplesTable createAlias(String alias) {
    return $HrvSamplesTable(attachedDatabase, alias);
  }
}

class HrvSample extends DataClass implements Insertable<HrvSample> {
  final int id;
  final String sessionId;
  final DateTime timestamp;
  final String rrIntervals;
  final int windowSeconds;
  final double? rmssd;
  final double? sdnn;
  final double? pnn50;
  final double? meanRR;
  final double? heartRate;
  final int? stressIndex;
  final DateTime createdAt;
  const HrvSample({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.rrIntervals,
    required this.windowSeconds,
    this.rmssd,
    this.sdnn,
    this.pnn50,
    this.meanRR,
    this.heartRate,
    this.stressIndex,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['rr_intervals'] = Variable<String>(rrIntervals);
    map['window_seconds'] = Variable<int>(windowSeconds);
    if (!nullToAbsent || rmssd != null) {
      map['rmssd'] = Variable<double>(rmssd);
    }
    if (!nullToAbsent || sdnn != null) {
      map['sdnn'] = Variable<double>(sdnn);
    }
    if (!nullToAbsent || pnn50 != null) {
      map['pnn50'] = Variable<double>(pnn50);
    }
    if (!nullToAbsent || meanRR != null) {
      map['mean_r_r'] = Variable<double>(meanRR);
    }
    if (!nullToAbsent || heartRate != null) {
      map['heart_rate'] = Variable<double>(heartRate);
    }
    if (!nullToAbsent || stressIndex != null) {
      map['stress_index'] = Variable<int>(stressIndex);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HrvSamplesCompanion toCompanion(bool nullToAbsent) {
    return HrvSamplesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestamp: Value(timestamp),
      rrIntervals: Value(rrIntervals),
      windowSeconds: Value(windowSeconds),
      rmssd: rmssd == null && nullToAbsent
          ? const Value.absent()
          : Value(rmssd),
      sdnn: sdnn == null && nullToAbsent ? const Value.absent() : Value(sdnn),
      pnn50: pnn50 == null && nullToAbsent
          ? const Value.absent()
          : Value(pnn50),
      meanRR: meanRR == null && nullToAbsent
          ? const Value.absent()
          : Value(meanRR),
      heartRate: heartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(heartRate),
      stressIndex: stressIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(stressIndex),
      createdAt: Value(createdAt),
    );
  }

  factory HrvSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HrvSample(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      rrIntervals: serializer.fromJson<String>(json['rrIntervals']),
      windowSeconds: serializer.fromJson<int>(json['windowSeconds']),
      rmssd: serializer.fromJson<double?>(json['rmssd']),
      sdnn: serializer.fromJson<double?>(json['sdnn']),
      pnn50: serializer.fromJson<double?>(json['pnn50']),
      meanRR: serializer.fromJson<double?>(json['meanRR']),
      heartRate: serializer.fromJson<double?>(json['heartRate']),
      stressIndex: serializer.fromJson<int?>(json['stressIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'rrIntervals': serializer.toJson<String>(rrIntervals),
      'windowSeconds': serializer.toJson<int>(windowSeconds),
      'rmssd': serializer.toJson<double?>(rmssd),
      'sdnn': serializer.toJson<double?>(sdnn),
      'pnn50': serializer.toJson<double?>(pnn50),
      'meanRR': serializer.toJson<double?>(meanRR),
      'heartRate': serializer.toJson<double?>(heartRate),
      'stressIndex': serializer.toJson<int?>(stressIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HrvSample copyWith({
    int? id,
    String? sessionId,
    DateTime? timestamp,
    String? rrIntervals,
    int? windowSeconds,
    Value<double?> rmssd = const Value.absent(),
    Value<double?> sdnn = const Value.absent(),
    Value<double?> pnn50 = const Value.absent(),
    Value<double?> meanRR = const Value.absent(),
    Value<double?> heartRate = const Value.absent(),
    Value<int?> stressIndex = const Value.absent(),
    DateTime? createdAt,
  }) => HrvSample(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    timestamp: timestamp ?? this.timestamp,
    rrIntervals: rrIntervals ?? this.rrIntervals,
    windowSeconds: windowSeconds ?? this.windowSeconds,
    rmssd: rmssd.present ? rmssd.value : this.rmssd,
    sdnn: sdnn.present ? sdnn.value : this.sdnn,
    pnn50: pnn50.present ? pnn50.value : this.pnn50,
    meanRR: meanRR.present ? meanRR.value : this.meanRR,
    heartRate: heartRate.present ? heartRate.value : this.heartRate,
    stressIndex: stressIndex.present ? stressIndex.value : this.stressIndex,
    createdAt: createdAt ?? this.createdAt,
  );
  HrvSample copyWithCompanion(HrvSamplesCompanion data) {
    return HrvSample(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      rrIntervals: data.rrIntervals.present
          ? data.rrIntervals.value
          : this.rrIntervals,
      windowSeconds: data.windowSeconds.present
          ? data.windowSeconds.value
          : this.windowSeconds,
      rmssd: data.rmssd.present ? data.rmssd.value : this.rmssd,
      sdnn: data.sdnn.present ? data.sdnn.value : this.sdnn,
      pnn50: data.pnn50.present ? data.pnn50.value : this.pnn50,
      meanRR: data.meanRR.present ? data.meanRR.value : this.meanRR,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      stressIndex: data.stressIndex.present
          ? data.stressIndex.value
          : this.stressIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HrvSample(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('rrIntervals: $rrIntervals, ')
          ..write('windowSeconds: $windowSeconds, ')
          ..write('rmssd: $rmssd, ')
          ..write('sdnn: $sdnn, ')
          ..write('pnn50: $pnn50, ')
          ..write('meanRR: $meanRR, ')
          ..write('heartRate: $heartRate, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    timestamp,
    rrIntervals,
    windowSeconds,
    rmssd,
    sdnn,
    pnn50,
    meanRR,
    heartRate,
    stressIndex,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HrvSample &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestamp == this.timestamp &&
          other.rrIntervals == this.rrIntervals &&
          other.windowSeconds == this.windowSeconds &&
          other.rmssd == this.rmssd &&
          other.sdnn == this.sdnn &&
          other.pnn50 == this.pnn50 &&
          other.meanRR == this.meanRR &&
          other.heartRate == this.heartRate &&
          other.stressIndex == this.stressIndex &&
          other.createdAt == this.createdAt);
}

class HrvSamplesCompanion extends UpdateCompanion<HrvSample> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<DateTime> timestamp;
  final Value<String> rrIntervals;
  final Value<int> windowSeconds;
  final Value<double?> rmssd;
  final Value<double?> sdnn;
  final Value<double?> pnn50;
  final Value<double?> meanRR;
  final Value<double?> heartRate;
  final Value<int?> stressIndex;
  final Value<DateTime> createdAt;
  const HrvSamplesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rrIntervals = const Value.absent(),
    this.windowSeconds = const Value.absent(),
    this.rmssd = const Value.absent(),
    this.sdnn = const Value.absent(),
    this.pnn50 = const Value.absent(),
    this.meanRR = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HrvSamplesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required DateTime timestamp,
    required String rrIntervals,
    required int windowSeconds,
    this.rmssd = const Value.absent(),
    this.sdnn = const Value.absent(),
    this.pnn50 = const Value.absent(),
    this.meanRR = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       timestamp = Value(timestamp),
       rrIntervals = Value(rrIntervals),
       windowSeconds = Value(windowSeconds);
  static Insertable<HrvSample> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<DateTime>? timestamp,
    Expression<String>? rrIntervals,
    Expression<int>? windowSeconds,
    Expression<double>? rmssd,
    Expression<double>? sdnn,
    Expression<double>? pnn50,
    Expression<double>? meanRR,
    Expression<double>? heartRate,
    Expression<int>? stressIndex,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (rrIntervals != null) 'rr_intervals': rrIntervals,
      if (windowSeconds != null) 'window_seconds': windowSeconds,
      if (rmssd != null) 'rmssd': rmssd,
      if (sdnn != null) 'sdnn': sdnn,
      if (pnn50 != null) 'pnn50': pnn50,
      if (meanRR != null) 'mean_r_r': meanRR,
      if (heartRate != null) 'heart_rate': heartRate,
      if (stressIndex != null) 'stress_index': stressIndex,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HrvSamplesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<DateTime>? timestamp,
    Value<String>? rrIntervals,
    Value<int>? windowSeconds,
    Value<double?>? rmssd,
    Value<double?>? sdnn,
    Value<double?>? pnn50,
    Value<double?>? meanRR,
    Value<double?>? heartRate,
    Value<int?>? stressIndex,
    Value<DateTime>? createdAt,
  }) {
    return HrvSamplesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      rrIntervals: rrIntervals ?? this.rrIntervals,
      windowSeconds: windowSeconds ?? this.windowSeconds,
      rmssd: rmssd ?? this.rmssd,
      sdnn: sdnn ?? this.sdnn,
      pnn50: pnn50 ?? this.pnn50,
      meanRR: meanRR ?? this.meanRR,
      heartRate: heartRate ?? this.heartRate,
      stressIndex: stressIndex ?? this.stressIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rrIntervals.present) {
      map['rr_intervals'] = Variable<String>(rrIntervals.value);
    }
    if (windowSeconds.present) {
      map['window_seconds'] = Variable<int>(windowSeconds.value);
    }
    if (rmssd.present) {
      map['rmssd'] = Variable<double>(rmssd.value);
    }
    if (sdnn.present) {
      map['sdnn'] = Variable<double>(sdnn.value);
    }
    if (pnn50.present) {
      map['pnn50'] = Variable<double>(pnn50.value);
    }
    if (meanRR.present) {
      map['mean_r_r'] = Variable<double>(meanRR.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<double>(heartRate.value);
    }
    if (stressIndex.present) {
      map['stress_index'] = Variable<int>(stressIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HrvSamplesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('rrIntervals: $rrIntervals, ')
          ..write('windowSeconds: $windowSeconds, ')
          ..write('rmssd: $rmssd, ')
          ..write('sdnn: $sdnn, ')
          ..write('pnn50: $pnn50, ')
          ..write('meanRR: $meanRR, ')
          ..write('heartRate: $heartRate, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AnalysisResultsTable extends AnalysisResults
    with TableInfo<$AnalysisResultsTable, AnalysisResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnalysisResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisTypeMeta = const VerificationMeta(
    'analysisType',
  );
  @override
  late final GeneratedColumn<String> analysisType = GeneratedColumn<String>(
    'analysis_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisTimestampMeta = const VerificationMeta(
    'analysisTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> analysisTimestamp =
      GeneratedColumn<DateTime>(
        'analysis_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _algorithmVersionMeta = const VerificationMeta(
    'algorithmVersion',
  );
  @override
  late final GeneratedColumn<String> algorithmVersion = GeneratedColumn<String>(
    'algorithm_version',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<int> confidence = GeneratedColumn<int>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processingTimeMsMeta = const VerificationMeta(
    'processingTimeMs',
  );
  @override
  late final GeneratedColumn<int> processingTimeMs = GeneratedColumn<int>(
    'processing_time_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    analysisId,
    sessionId,
    analysisType,
    analysisTimestamp,
    algorithmVersion,
    status,
    data,
    confidence,
    errorMessage,
    processingTimeMs,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('analysis_type')) {
      context.handle(
        _analysisTypeMeta,
        analysisType.isAcceptableOrUnknown(
          data['analysis_type']!,
          _analysisTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisTypeMeta);
    }
    if (data.containsKey('analysis_timestamp')) {
      context.handle(
        _analysisTimestampMeta,
        analysisTimestamp.isAcceptableOrUnknown(
          data['analysis_timestamp']!,
          _analysisTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisTimestampMeta);
    }
    if (data.containsKey('algorithm_version')) {
      context.handle(
        _algorithmVersionMeta,
        algorithmVersion.isAcceptableOrUnknown(
          data['algorithm_version']!,
          _algorithmVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_algorithmVersionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('processing_time_ms')) {
      context.handle(
        _processingTimeMsMeta,
        processingTimeMs.isAcceptableOrUnknown(
          data['processing_time_ms']!,
          _processingTimeMsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {analysisId};
  @override
  AnalysisResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisResult(
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      analysisType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_type'],
      )!,
      analysisTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}analysis_timestamp'],
      )!,
      algorithmVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}algorithm_version'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}confidence'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      processingTimeMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processing_time_ms'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AnalysisResultsTable createAlias(String alias) {
    return $AnalysisResultsTable(attachedDatabase, alias);
  }
}

class AnalysisResult extends DataClass implements Insertable<AnalysisResult> {
  final String analysisId;
  final String sessionId;
  final String analysisType;
  final DateTime analysisTimestamp;
  final String algorithmVersion;
  final String status;
  final String data;
  final int? confidence;
  final String? errorMessage;
  final int? processingTimeMs;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AnalysisResult({
    required this.analysisId,
    required this.sessionId,
    required this.analysisType,
    required this.analysisTimestamp,
    required this.algorithmVersion,
    required this.status,
    required this.data,
    this.confidence,
    this.errorMessage,
    this.processingTimeMs,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['analysis_id'] = Variable<String>(analysisId);
    map['session_id'] = Variable<String>(sessionId);
    map['analysis_type'] = Variable<String>(analysisType);
    map['analysis_timestamp'] = Variable<DateTime>(analysisTimestamp);
    map['algorithm_version'] = Variable<String>(algorithmVersion);
    map['status'] = Variable<String>(status);
    map['data'] = Variable<String>(data);
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<int>(confidence);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || processingTimeMs != null) {
      map['processing_time_ms'] = Variable<int>(processingTimeMs);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnalysisResultsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisResultsCompanion(
      analysisId: Value(analysisId),
      sessionId: Value(sessionId),
      analysisType: Value(analysisType),
      analysisTimestamp: Value(analysisTimestamp),
      algorithmVersion: Value(algorithmVersion),
      status: Value(status),
      data: Value(data),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      processingTimeMs: processingTimeMs == null && nullToAbsent
          ? const Value.absent()
          : Value(processingTimeMs),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnalysisResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisResult(
      analysisId: serializer.fromJson<String>(json['analysisId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      analysisType: serializer.fromJson<String>(json['analysisType']),
      analysisTimestamp: serializer.fromJson<DateTime>(
        json['analysisTimestamp'],
      ),
      algorithmVersion: serializer.fromJson<String>(json['algorithmVersion']),
      status: serializer.fromJson<String>(json['status']),
      data: serializer.fromJson<String>(json['data']),
      confidence: serializer.fromJson<int?>(json['confidence']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      processingTimeMs: serializer.fromJson<int?>(json['processingTimeMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'analysisId': serializer.toJson<String>(analysisId),
      'sessionId': serializer.toJson<String>(sessionId),
      'analysisType': serializer.toJson<String>(analysisType),
      'analysisTimestamp': serializer.toJson<DateTime>(analysisTimestamp),
      'algorithmVersion': serializer.toJson<String>(algorithmVersion),
      'status': serializer.toJson<String>(status),
      'data': serializer.toJson<String>(data),
      'confidence': serializer.toJson<int?>(confidence),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'processingTimeMs': serializer.toJson<int?>(processingTimeMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnalysisResult copyWith({
    String? analysisId,
    String? sessionId,
    String? analysisType,
    DateTime? analysisTimestamp,
    String? algorithmVersion,
    String? status,
    String? data,
    Value<int?> confidence = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    Value<int?> processingTimeMs = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AnalysisResult(
    analysisId: analysisId ?? this.analysisId,
    sessionId: sessionId ?? this.sessionId,
    analysisType: analysisType ?? this.analysisType,
    analysisTimestamp: analysisTimestamp ?? this.analysisTimestamp,
    algorithmVersion: algorithmVersion ?? this.algorithmVersion,
    status: status ?? this.status,
    data: data ?? this.data,
    confidence: confidence.present ? confidence.value : this.confidence,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    processingTimeMs: processingTimeMs.present
        ? processingTimeMs.value
        : this.processingTimeMs,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AnalysisResult copyWithCompanion(AnalysisResultsCompanion data) {
    return AnalysisResult(
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      analysisType: data.analysisType.present
          ? data.analysisType.value
          : this.analysisType,
      analysisTimestamp: data.analysisTimestamp.present
          ? data.analysisTimestamp.value
          : this.analysisTimestamp,
      algorithmVersion: data.algorithmVersion.present
          ? data.algorithmVersion.value
          : this.algorithmVersion,
      status: data.status.present ? data.status.value : this.status,
      data: data.data.present ? data.data.value : this.data,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      processingTimeMs: data.processingTimeMs.present
          ? data.processingTimeMs.value
          : this.processingTimeMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisResult(')
          ..write('analysisId: $analysisId, ')
          ..write('sessionId: $sessionId, ')
          ..write('analysisType: $analysisType, ')
          ..write('analysisTimestamp: $analysisTimestamp, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('status: $status, ')
          ..write('data: $data, ')
          ..write('confidence: $confidence, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('processingTimeMs: $processingTimeMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    analysisId,
    sessionId,
    analysisType,
    analysisTimestamp,
    algorithmVersion,
    status,
    data,
    confidence,
    errorMessage,
    processingTimeMs,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisResult &&
          other.analysisId == this.analysisId &&
          other.sessionId == this.sessionId &&
          other.analysisType == this.analysisType &&
          other.analysisTimestamp == this.analysisTimestamp &&
          other.algorithmVersion == this.algorithmVersion &&
          other.status == this.status &&
          other.data == this.data &&
          other.confidence == this.confidence &&
          other.errorMessage == this.errorMessage &&
          other.processingTimeMs == this.processingTimeMs &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AnalysisResultsCompanion extends UpdateCompanion<AnalysisResult> {
  final Value<String> analysisId;
  final Value<String> sessionId;
  final Value<String> analysisType;
  final Value<DateTime> analysisTimestamp;
  final Value<String> algorithmVersion;
  final Value<String> status;
  final Value<String> data;
  final Value<int?> confidence;
  final Value<String?> errorMessage;
  final Value<int?> processingTimeMs;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AnalysisResultsCompanion({
    this.analysisId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.analysisType = const Value.absent(),
    this.analysisTimestamp = const Value.absent(),
    this.algorithmVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.data = const Value.absent(),
    this.confidence = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.processingTimeMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisResultsCompanion.insert({
    required String analysisId,
    required String sessionId,
    required String analysisType,
    required DateTime analysisTimestamp,
    required String algorithmVersion,
    required String status,
    required String data,
    this.confidence = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.processingTimeMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : analysisId = Value(analysisId),
       sessionId = Value(sessionId),
       analysisType = Value(analysisType),
       analysisTimestamp = Value(analysisTimestamp),
       algorithmVersion = Value(algorithmVersion),
       status = Value(status),
       data = Value(data);
  static Insertable<AnalysisResult> custom({
    Expression<String>? analysisId,
    Expression<String>? sessionId,
    Expression<String>? analysisType,
    Expression<DateTime>? analysisTimestamp,
    Expression<String>? algorithmVersion,
    Expression<String>? status,
    Expression<String>? data,
    Expression<int>? confidence,
    Expression<String>? errorMessage,
    Expression<int>? processingTimeMs,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (analysisId != null) 'analysis_id': analysisId,
      if (sessionId != null) 'session_id': sessionId,
      if (analysisType != null) 'analysis_type': analysisType,
      if (analysisTimestamp != null) 'analysis_timestamp': analysisTimestamp,
      if (algorithmVersion != null) 'algorithm_version': algorithmVersion,
      if (status != null) 'status': status,
      if (data != null) 'data': data,
      if (confidence != null) 'confidence': confidence,
      if (errorMessage != null) 'error_message': errorMessage,
      if (processingTimeMs != null) 'processing_time_ms': processingTimeMs,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisResultsCompanion copyWith({
    Value<String>? analysisId,
    Value<String>? sessionId,
    Value<String>? analysisType,
    Value<DateTime>? analysisTimestamp,
    Value<String>? algorithmVersion,
    Value<String>? status,
    Value<String>? data,
    Value<int?>? confidence,
    Value<String?>? errorMessage,
    Value<int?>? processingTimeMs,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AnalysisResultsCompanion(
      analysisId: analysisId ?? this.analysisId,
      sessionId: sessionId ?? this.sessionId,
      analysisType: analysisType ?? this.analysisType,
      analysisTimestamp: analysisTimestamp ?? this.analysisTimestamp,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      status: status ?? this.status,
      data: data ?? this.data,
      confidence: confidence ?? this.confidence,
      errorMessage: errorMessage ?? this.errorMessage,
      processingTimeMs: processingTimeMs ?? this.processingTimeMs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (analysisType.present) {
      map['analysis_type'] = Variable<String>(analysisType.value);
    }
    if (analysisTimestamp.present) {
      map['analysis_timestamp'] = Variable<DateTime>(analysisTimestamp.value);
    }
    if (algorithmVersion.present) {
      map['algorithm_version'] = Variable<String>(algorithmVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<int>(confidence.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (processingTimeMs.present) {
      map['processing_time_ms'] = Variable<int>(processingTimeMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisResultsCompanion(')
          ..write('analysisId: $analysisId, ')
          ..write('sessionId: $sessionId, ')
          ..write('analysisType: $analysisType, ')
          ..write('analysisTimestamp: $analysisTimestamp, ')
          ..write('algorithmVersion: $algorithmVersion, ')
          ..write('status: $status, ')
          ..write('data: $data, ')
          ..write('confidence: $confidence, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('processingTimeMs: $processingTimeMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExportHistoryTable extends ExportHistory
    with TableInfo<$ExportHistoryTable, ExportHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExportHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exportIdMeta = const VerificationMeta(
    'exportId',
  );
  @override
  late final GeneratedColumn<String> exportId = GeneratedColumn<String>(
    'export_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exportTypeMeta = const VerificationMeta(
    'exportType',
  );
  @override
  late final GeneratedColumn<String> exportType = GeneratedColumn<String>(
    'export_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exportTimestampMeta = const VerificationMeta(
    'exportTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> exportTimestamp =
      GeneratedColumn<DateTime>(
        'export_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _parametersMeta = const VerificationMeta(
    'parameters',
  );
  @override
  late final GeneratedColumn<String> parameters = GeneratedColumn<String>(
    'parameters',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exportId,
    sessionId,
    exportType,
    filePath,
    fileSizeBytes,
    exportTimestamp,
    parameters,
    status,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'export_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExportHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('export_id')) {
      context.handle(
        _exportIdMeta,
        exportId.isAcceptableOrUnknown(data['export_id']!, _exportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exportIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('export_type')) {
      context.handle(
        _exportTypeMeta,
        exportType.isAcceptableOrUnknown(data['export_type']!, _exportTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_exportTypeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fileSizeBytesMeta);
    }
    if (data.containsKey('export_timestamp')) {
      context.handle(
        _exportTimestampMeta,
        exportTimestamp.isAcceptableOrUnknown(
          data['export_timestamp']!,
          _exportTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exportTimestampMeta);
    }
    if (data.containsKey('parameters')) {
      context.handle(
        _parametersMeta,
        parameters.isAcceptableOrUnknown(data['parameters']!, _parametersMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExportHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExportHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}export_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exportType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}export_type'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      exportTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}export_timestamp'],
      )!,
      parameters: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parameters'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $ExportHistoryTable createAlias(String alias) {
    return $ExportHistoryTable(attachedDatabase, alias);
  }
}

class ExportHistoryData extends DataClass
    implements Insertable<ExportHistoryData> {
  final int id;
  final String exportId;
  final String sessionId;
  final String exportType;
  final String filePath;
  final int fileSizeBytes;
  final DateTime exportTimestamp;
  final String? parameters;
  final String status;
  final String? errorMessage;
  const ExportHistoryData({
    required this.id,
    required this.exportId,
    required this.sessionId,
    required this.exportType,
    required this.filePath,
    required this.fileSizeBytes,
    required this.exportTimestamp,
    this.parameters,
    required this.status,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['export_id'] = Variable<String>(exportId);
    map['session_id'] = Variable<String>(sessionId);
    map['export_type'] = Variable<String>(exportType);
    map['file_path'] = Variable<String>(filePath);
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['export_timestamp'] = Variable<DateTime>(exportTimestamp);
    if (!nullToAbsent || parameters != null) {
      map['parameters'] = Variable<String>(parameters);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  ExportHistoryCompanion toCompanion(bool nullToAbsent) {
    return ExportHistoryCompanion(
      id: Value(id),
      exportId: Value(exportId),
      sessionId: Value(sessionId),
      exportType: Value(exportType),
      filePath: Value(filePath),
      fileSizeBytes: Value(fileSizeBytes),
      exportTimestamp: Value(exportTimestamp),
      parameters: parameters == null && nullToAbsent
          ? const Value.absent()
          : Value(parameters),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory ExportHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExportHistoryData(
      id: serializer.fromJson<int>(json['id']),
      exportId: serializer.fromJson<String>(json['exportId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exportType: serializer.fromJson<String>(json['exportType']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      exportTimestamp: serializer.fromJson<DateTime>(json['exportTimestamp']),
      parameters: serializer.fromJson<String?>(json['parameters']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exportId': serializer.toJson<String>(exportId),
      'sessionId': serializer.toJson<String>(sessionId),
      'exportType': serializer.toJson<String>(exportType),
      'filePath': serializer.toJson<String>(filePath),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'exportTimestamp': serializer.toJson<DateTime>(exportTimestamp),
      'parameters': serializer.toJson<String?>(parameters),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  ExportHistoryData copyWith({
    int? id,
    String? exportId,
    String? sessionId,
    String? exportType,
    String? filePath,
    int? fileSizeBytes,
    DateTime? exportTimestamp,
    Value<String?> parameters = const Value.absent(),
    String? status,
    Value<String?> errorMessage = const Value.absent(),
  }) => ExportHistoryData(
    id: id ?? this.id,
    exportId: exportId ?? this.exportId,
    sessionId: sessionId ?? this.sessionId,
    exportType: exportType ?? this.exportType,
    filePath: filePath ?? this.filePath,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    exportTimestamp: exportTimestamp ?? this.exportTimestamp,
    parameters: parameters.present ? parameters.value : this.parameters,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  ExportHistoryData copyWithCompanion(ExportHistoryCompanion data) {
    return ExportHistoryData(
      id: data.id.present ? data.id.value : this.id,
      exportId: data.exportId.present ? data.exportId.value : this.exportId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exportType: data.exportType.present
          ? data.exportType.value
          : this.exportType,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      exportTimestamp: data.exportTimestamp.present
          ? data.exportTimestamp.value
          : this.exportTimestamp,
      parameters: data.parameters.present
          ? data.parameters.value
          : this.parameters,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExportHistoryData(')
          ..write('id: $id, ')
          ..write('exportId: $exportId, ')
          ..write('sessionId: $sessionId, ')
          ..write('exportType: $exportType, ')
          ..write('filePath: $filePath, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('exportTimestamp: $exportTimestamp, ')
          ..write('parameters: $parameters, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exportId,
    sessionId,
    exportType,
    filePath,
    fileSizeBytes,
    exportTimestamp,
    parameters,
    status,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExportHistoryData &&
          other.id == this.id &&
          other.exportId == this.exportId &&
          other.sessionId == this.sessionId &&
          other.exportType == this.exportType &&
          other.filePath == this.filePath &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.exportTimestamp == this.exportTimestamp &&
          other.parameters == this.parameters &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage);
}

class ExportHistoryCompanion extends UpdateCompanion<ExportHistoryData> {
  final Value<int> id;
  final Value<String> exportId;
  final Value<String> sessionId;
  final Value<String> exportType;
  final Value<String> filePath;
  final Value<int> fileSizeBytes;
  final Value<DateTime> exportTimestamp;
  final Value<String?> parameters;
  final Value<String> status;
  final Value<String?> errorMessage;
  const ExportHistoryCompanion({
    this.id = const Value.absent(),
    this.exportId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exportType = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.exportTimestamp = const Value.absent(),
    this.parameters = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
  });
  ExportHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String exportId,
    required String sessionId,
    required String exportType,
    required String filePath,
    required int fileSizeBytes,
    required DateTime exportTimestamp,
    this.parameters = const Value.absent(),
    required String status,
    this.errorMessage = const Value.absent(),
  }) : exportId = Value(exportId),
       sessionId = Value(sessionId),
       exportType = Value(exportType),
       filePath = Value(filePath),
       fileSizeBytes = Value(fileSizeBytes),
       exportTimestamp = Value(exportTimestamp),
       status = Value(status);
  static Insertable<ExportHistoryData> custom({
    Expression<int>? id,
    Expression<String>? exportId,
    Expression<String>? sessionId,
    Expression<String>? exportType,
    Expression<String>? filePath,
    Expression<int>? fileSizeBytes,
    Expression<DateTime>? exportTimestamp,
    Expression<String>? parameters,
    Expression<String>? status,
    Expression<String>? errorMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exportId != null) 'export_id': exportId,
      if (sessionId != null) 'session_id': sessionId,
      if (exportType != null) 'export_type': exportType,
      if (filePath != null) 'file_path': filePath,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (exportTimestamp != null) 'export_timestamp': exportTimestamp,
      if (parameters != null) 'parameters': parameters,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }

  ExportHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? exportId,
    Value<String>? sessionId,
    Value<String>? exportType,
    Value<String>? filePath,
    Value<int>? fileSizeBytes,
    Value<DateTime>? exportTimestamp,
    Value<String?>? parameters,
    Value<String>? status,
    Value<String?>? errorMessage,
  }) {
    return ExportHistoryCompanion(
      id: id ?? this.id,
      exportId: exportId ?? this.exportId,
      sessionId: sessionId ?? this.sessionId,
      exportType: exportType ?? this.exportType,
      filePath: filePath ?? this.filePath,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      exportTimestamp: exportTimestamp ?? this.exportTimestamp,
      parameters: parameters ?? this.parameters,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exportId.present) {
      map['export_id'] = Variable<String>(exportId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exportType.present) {
      map['export_type'] = Variable<String>(exportType.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (exportTimestamp.present) {
      map['export_timestamp'] = Variable<DateTime>(exportTimestamp.value);
    }
    if (parameters.present) {
      map['parameters'] = Variable<String>(parameters.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExportHistoryCompanion(')
          ..write('id: $id, ')
          ..write('exportId: $exportId, ')
          ..write('sessionId: $sessionId, ')
          ..write('exportType: $exportType, ')
          ..write('filePath: $filePath, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('exportTimestamp: $exportTimestamp, ')
          ..write('parameters: $parameters, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PolarDevicesTable polarDevices = $PolarDevicesTable(this);
  late final $MeasurementSessionsTable measurementSessions =
      $MeasurementSessionsTable(this);
  late final $EcgSamplesTable ecgSamples = $EcgSamplesTable(this);
  late final $EcgSampleBatchesTable ecgSampleBatches = $EcgSampleBatchesTable(
    this,
  );
  late final $HeartRateSamplesTable heartRateSamples = $HeartRateSamplesTable(
    this,
  );
  late final $HrvSamplesTable hrvSamples = $HrvSamplesTable(this);
  late final $AnalysisResultsTable analysisResults = $AnalysisResultsTable(
    this,
  );
  late final $ExportHistoryTable exportHistory = $ExportHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    polarDevices,
    measurementSessions,
    ecgSamples,
    ecgSampleBatches,
    heartRateSamples,
    hrvSamples,
    analysisResults,
    exportHistory,
  ];
}

typedef $$PolarDevicesTableCreateCompanionBuilder =
    PolarDevicesCompanion Function({
      required String deviceId,
      required String name,
      Value<String?> firmwareVersion,
      Value<int?> batteryLevel,
      required String connectionStatus,
      Value<int?> signalQuality,
      required String electrodeStatus,
      required DateTime lastSeen,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PolarDevicesTableUpdateCompanionBuilder =
    PolarDevicesCompanion Function({
      Value<String> deviceId,
      Value<String> name,
      Value<String?> firmwareVersion,
      Value<int?> batteryLevel,
      Value<String> connectionStatus,
      Value<int?> signalQuality,
      Value<String> electrodeStatus,
      Value<DateTime> lastSeen,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PolarDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $PolarDevicesTable> {
  $$PolarDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batteryLevel => $composableBuilder(
    column: $table.batteryLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectionStatus => $composableBuilder(
    column: $table.connectionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get signalQuality => $composableBuilder(
    column: $table.signalQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get electrodeStatus => $composableBuilder(
    column: $table.electrodeStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PolarDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PolarDevicesTable> {
  $$PolarDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batteryLevel => $composableBuilder(
    column: $table.batteryLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectionStatus => $composableBuilder(
    column: $table.connectionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get signalQuality => $composableBuilder(
    column: $table.signalQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get electrodeStatus => $composableBuilder(
    column: $table.electrodeStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PolarDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PolarDevicesTable> {
  $$PolarDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get batteryLevel => $composableBuilder(
    column: $table.batteryLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get connectionStatus => $composableBuilder(
    column: $table.connectionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get signalQuality => $composableBuilder(
    column: $table.signalQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get electrodeStatus => $composableBuilder(
    column: $table.electrodeStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PolarDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PolarDevicesTable,
          PolarDevice,
          $$PolarDevicesTableFilterComposer,
          $$PolarDevicesTableOrderingComposer,
          $$PolarDevicesTableAnnotationComposer,
          $$PolarDevicesTableCreateCompanionBuilder,
          $$PolarDevicesTableUpdateCompanionBuilder,
          (
            PolarDevice,
            BaseReferences<_$AppDatabase, $PolarDevicesTable, PolarDevice>,
          ),
          PolarDevice,
          PrefetchHooks Function()
        > {
  $$PolarDevicesTableTableManager(_$AppDatabase db, $PolarDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PolarDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PolarDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PolarDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> firmwareVersion = const Value.absent(),
                Value<int?> batteryLevel = const Value.absent(),
                Value<String> connectionStatus = const Value.absent(),
                Value<int?> signalQuality = const Value.absent(),
                Value<String> electrodeStatus = const Value.absent(),
                Value<DateTime> lastSeen = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PolarDevicesCompanion(
                deviceId: deviceId,
                name: name,
                firmwareVersion: firmwareVersion,
                batteryLevel: batteryLevel,
                connectionStatus: connectionStatus,
                signalQuality: signalQuality,
                electrodeStatus: electrodeStatus,
                lastSeen: lastSeen,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String name,
                Value<String?> firmwareVersion = const Value.absent(),
                Value<int?> batteryLevel = const Value.absent(),
                required String connectionStatus,
                Value<int?> signalQuality = const Value.absent(),
                required String electrodeStatus,
                required DateTime lastSeen,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PolarDevicesCompanion.insert(
                deviceId: deviceId,
                name: name,
                firmwareVersion: firmwareVersion,
                batteryLevel: batteryLevel,
                connectionStatus: connectionStatus,
                signalQuality: signalQuality,
                electrodeStatus: electrodeStatus,
                lastSeen: lastSeen,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PolarDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PolarDevicesTable,
      PolarDevice,
      $$PolarDevicesTableFilterComposer,
      $$PolarDevicesTableOrderingComposer,
      $$PolarDevicesTableAnnotationComposer,
      $$PolarDevicesTableCreateCompanionBuilder,
      $$PolarDevicesTableUpdateCompanionBuilder,
      (
        PolarDevice,
        BaseReferences<_$AppDatabase, $PolarDevicesTable, PolarDevice>,
      ),
      PolarDevice,
      PrefetchHooks Function()
    >;
typedef $$MeasurementSessionsTableCreateCompanionBuilder =
    MeasurementSessionsCompanion Function({
      required String sessionId,
      required String deviceId,
      required DateTime startTime,
      Value<DateTime?> endTime,
      required String status,
      required String type,
      Value<String?> tags,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MeasurementSessionsTableUpdateCompanionBuilder =
    MeasurementSessionsCompanion Function({
      Value<String> sessionId,
      Value<String> deviceId,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<String> status,
      Value<String> type,
      Value<String?> tags,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MeasurementSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementSessionsTable> {
  $$MeasurementSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeasurementSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementSessionsTable> {
  $$MeasurementSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasurementSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementSessionsTable> {
  $$MeasurementSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MeasurementSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementSessionsTable,
          MeasurementSession,
          $$MeasurementSessionsTableFilterComposer,
          $$MeasurementSessionsTableOrderingComposer,
          $$MeasurementSessionsTableAnnotationComposer,
          $$MeasurementSessionsTableCreateCompanionBuilder,
          $$MeasurementSessionsTableUpdateCompanionBuilder,
          (
            MeasurementSession,
            BaseReferences<
              _$AppDatabase,
              $MeasurementSessionsTable,
              MeasurementSession
            >,
          ),
          MeasurementSession,
          PrefetchHooks Function()
        > {
  $$MeasurementSessionsTableTableManager(
    _$AppDatabase db,
    $MeasurementSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeasurementSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MeasurementSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementSessionsCompanion(
                sessionId: sessionId,
                deviceId: deviceId,
                startTime: startTime,
                endTime: endTime,
                status: status,
                type: type,
                tags: tags,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String deviceId,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                required String status,
                required String type,
                Value<String?> tags = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementSessionsCompanion.insert(
                sessionId: sessionId,
                deviceId: deviceId,
                startTime: startTime,
                endTime: endTime,
                status: status,
                type: type,
                tags: tags,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MeasurementSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementSessionsTable,
      MeasurementSession,
      $$MeasurementSessionsTableFilterComposer,
      $$MeasurementSessionsTableOrderingComposer,
      $$MeasurementSessionsTableAnnotationComposer,
      $$MeasurementSessionsTableCreateCompanionBuilder,
      $$MeasurementSessionsTableUpdateCompanionBuilder,
      (
        MeasurementSession,
        BaseReferences<
          _$AppDatabase,
          $MeasurementSessionsTable,
          MeasurementSession
        >,
      ),
      MeasurementSession,
      PrefetchHooks Function()
    >;
typedef $$EcgSamplesTableCreateCompanionBuilder =
    EcgSamplesCompanion Function({
      Value<int> id,
      required String sessionId,
      required DateTime timestamp,
      required double voltage,
      required int sequenceNumber,
      Value<int?> quality,
      Value<bool> isRPeak,
      Value<String?> leadId,
      Value<DateTime> createdAt,
    });
typedef $$EcgSamplesTableUpdateCompanionBuilder =
    EcgSamplesCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<DateTime> timestamp,
      Value<double> voltage,
      Value<int> sequenceNumber,
      Value<int?> quality,
      Value<bool> isRPeak,
      Value<String?> leadId,
      Value<DateTime> createdAt,
    });

class $$EcgSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $EcgSamplesTable> {
  $$EcgSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get voltage => $composableBuilder(
    column: $table.voltage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRPeak => $composableBuilder(
    column: $table.isRPeak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EcgSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $EcgSamplesTable> {
  $$EcgSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voltage => $composableBuilder(
    column: $table.voltage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRPeak => $composableBuilder(
    column: $table.isRPeak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EcgSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EcgSamplesTable> {
  $$EcgSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get voltage =>
      $composableBuilder(column: $table.voltage, builder: (column) => column);

  GeneratedColumn<int> get sequenceNumber => $composableBuilder(
    column: $table.sequenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<bool> get isRPeak =>
      $composableBuilder(column: $table.isRPeak, builder: (column) => column);

  GeneratedColumn<String> get leadId =>
      $composableBuilder(column: $table.leadId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EcgSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EcgSamplesTable,
          EcgSample,
          $$EcgSamplesTableFilterComposer,
          $$EcgSamplesTableOrderingComposer,
          $$EcgSamplesTableAnnotationComposer,
          $$EcgSamplesTableCreateCompanionBuilder,
          $$EcgSamplesTableUpdateCompanionBuilder,
          (
            EcgSample,
            BaseReferences<_$AppDatabase, $EcgSamplesTable, EcgSample>,
          ),
          EcgSample,
          PrefetchHooks Function()
        > {
  $$EcgSamplesTableTableManager(_$AppDatabase db, $EcgSamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EcgSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EcgSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EcgSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> voltage = const Value.absent(),
                Value<int> sequenceNumber = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<bool> isRPeak = const Value.absent(),
                Value<String?> leadId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EcgSamplesCompanion(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                voltage: voltage,
                sequenceNumber: sequenceNumber,
                quality: quality,
                isRPeak: isRPeak,
                leadId: leadId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required DateTime timestamp,
                required double voltage,
                required int sequenceNumber,
                Value<int?> quality = const Value.absent(),
                Value<bool> isRPeak = const Value.absent(),
                Value<String?> leadId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EcgSamplesCompanion.insert(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                voltage: voltage,
                sequenceNumber: sequenceNumber,
                quality: quality,
                isRPeak: isRPeak,
                leadId: leadId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EcgSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EcgSamplesTable,
      EcgSample,
      $$EcgSamplesTableFilterComposer,
      $$EcgSamplesTableOrderingComposer,
      $$EcgSamplesTableAnnotationComposer,
      $$EcgSamplesTableCreateCompanionBuilder,
      $$EcgSamplesTableUpdateCompanionBuilder,
      (EcgSample, BaseReferences<_$AppDatabase, $EcgSamplesTable, EcgSample>),
      EcgSample,
      PrefetchHooks Function()
    >;
typedef $$EcgSampleBatchesTableCreateCompanionBuilder =
    EcgSampleBatchesCompanion Function({
      Value<int> id,
      required String sessionId,
      required DateTime startTimestamp,
      required DateTime endTimestamp,
      required double samplingRate,
      required Uint8List voltagesData,
      Value<Uint8List?> rPeakIndices,
      required int batchNumber,
      required int sampleCount,
      Value<String?> qualityMetrics,
      Value<DateTime> createdAt,
    });
typedef $$EcgSampleBatchesTableUpdateCompanionBuilder =
    EcgSampleBatchesCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<DateTime> startTimestamp,
      Value<DateTime> endTimestamp,
      Value<double> samplingRate,
      Value<Uint8List> voltagesData,
      Value<Uint8List?> rPeakIndices,
      Value<int> batchNumber,
      Value<int> sampleCount,
      Value<String?> qualityMetrics,
      Value<DateTime> createdAt,
    });

class $$EcgSampleBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $EcgSampleBatchesTable> {
  $$EcgSampleBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTimestamp => $composableBuilder(
    column: $table.startTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTimestamp => $composableBuilder(
    column: $table.endTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get samplingRate => $composableBuilder(
    column: $table.samplingRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get voltagesData => $composableBuilder(
    column: $table.voltagesData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get rPeakIndices => $composableBuilder(
    column: $table.rPeakIndices,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualityMetrics => $composableBuilder(
    column: $table.qualityMetrics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EcgSampleBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $EcgSampleBatchesTable> {
  $$EcgSampleBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTimestamp => $composableBuilder(
    column: $table.startTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTimestamp => $composableBuilder(
    column: $table.endTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get samplingRate => $composableBuilder(
    column: $table.samplingRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get voltagesData => $composableBuilder(
    column: $table.voltagesData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get rPeakIndices => $composableBuilder(
    column: $table.rPeakIndices,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualityMetrics => $composableBuilder(
    column: $table.qualityMetrics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EcgSampleBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EcgSampleBatchesTable> {
  $$EcgSampleBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTimestamp => $composableBuilder(
    column: $table.startTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endTimestamp => $composableBuilder(
    column: $table.endTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get samplingRate => $composableBuilder(
    column: $table.samplingRate,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get voltagesData => $composableBuilder(
    column: $table.voltagesData,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get rPeakIndices => $composableBuilder(
    column: $table.rPeakIndices,
    builder: (column) => column,
  );

  GeneratedColumn<int> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qualityMetrics => $composableBuilder(
    column: $table.qualityMetrics,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EcgSampleBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EcgSampleBatchesTable,
          EcgSampleBatche,
          $$EcgSampleBatchesTableFilterComposer,
          $$EcgSampleBatchesTableOrderingComposer,
          $$EcgSampleBatchesTableAnnotationComposer,
          $$EcgSampleBatchesTableCreateCompanionBuilder,
          $$EcgSampleBatchesTableUpdateCompanionBuilder,
          (
            EcgSampleBatche,
            BaseReferences<
              _$AppDatabase,
              $EcgSampleBatchesTable,
              EcgSampleBatche
            >,
          ),
          EcgSampleBatche,
          PrefetchHooks Function()
        > {
  $$EcgSampleBatchesTableTableManager(
    _$AppDatabase db,
    $EcgSampleBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EcgSampleBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EcgSampleBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EcgSampleBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> startTimestamp = const Value.absent(),
                Value<DateTime> endTimestamp = const Value.absent(),
                Value<double> samplingRate = const Value.absent(),
                Value<Uint8List> voltagesData = const Value.absent(),
                Value<Uint8List?> rPeakIndices = const Value.absent(),
                Value<int> batchNumber = const Value.absent(),
                Value<int> sampleCount = const Value.absent(),
                Value<String?> qualityMetrics = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EcgSampleBatchesCompanion(
                id: id,
                sessionId: sessionId,
                startTimestamp: startTimestamp,
                endTimestamp: endTimestamp,
                samplingRate: samplingRate,
                voltagesData: voltagesData,
                rPeakIndices: rPeakIndices,
                batchNumber: batchNumber,
                sampleCount: sampleCount,
                qualityMetrics: qualityMetrics,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required DateTime startTimestamp,
                required DateTime endTimestamp,
                required double samplingRate,
                required Uint8List voltagesData,
                Value<Uint8List?> rPeakIndices = const Value.absent(),
                required int batchNumber,
                required int sampleCount,
                Value<String?> qualityMetrics = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EcgSampleBatchesCompanion.insert(
                id: id,
                sessionId: sessionId,
                startTimestamp: startTimestamp,
                endTimestamp: endTimestamp,
                samplingRate: samplingRate,
                voltagesData: voltagesData,
                rPeakIndices: rPeakIndices,
                batchNumber: batchNumber,
                sampleCount: sampleCount,
                qualityMetrics: qualityMetrics,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EcgSampleBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EcgSampleBatchesTable,
      EcgSampleBatche,
      $$EcgSampleBatchesTableFilterComposer,
      $$EcgSampleBatchesTableOrderingComposer,
      $$EcgSampleBatchesTableAnnotationComposer,
      $$EcgSampleBatchesTableCreateCompanionBuilder,
      $$EcgSampleBatchesTableUpdateCompanionBuilder,
      (
        EcgSampleBatche,
        BaseReferences<_$AppDatabase, $EcgSampleBatchesTable, EcgSampleBatche>,
      ),
      EcgSampleBatche,
      PrefetchHooks Function()
    >;
typedef $$HeartRateSamplesTableCreateCompanionBuilder =
    HeartRateSamplesCompanion Function({
      Value<int> id,
      required String sessionId,
      required DateTime timestamp,
      required int heartRate,
      Value<String?> rrIntervals,
      required bool contactDetected,
      Value<int?> quality,
      required String source,
      Value<DateTime> createdAt,
    });
typedef $$HeartRateSamplesTableUpdateCompanionBuilder =
    HeartRateSamplesCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<DateTime> timestamp,
      Value<int> heartRate,
      Value<String?> rrIntervals,
      Value<bool> contactDetected,
      Value<int?> quality,
      Value<String> source,
      Value<DateTime> createdAt,
    });

class $$HeartRateSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $HeartRateSamplesTable> {
  $$HeartRateSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrIntervals => $composableBuilder(
    column: $table.rrIntervals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get contactDetected => $composableBuilder(
    column: $table.contactDetected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeartRateSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $HeartRateSamplesTable> {
  $$HeartRateSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrIntervals => $composableBuilder(
    column: $table.rrIntervals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get contactDetected => $composableBuilder(
    column: $table.contactDetected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeartRateSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeartRateSamplesTable> {
  $$HeartRateSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<String> get rrIntervals => $composableBuilder(
    column: $table.rrIntervals,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get contactDetected => $composableBuilder(
    column: $table.contactDetected,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HeartRateSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeartRateSamplesTable,
          HeartRateSample,
          $$HeartRateSamplesTableFilterComposer,
          $$HeartRateSamplesTableOrderingComposer,
          $$HeartRateSamplesTableAnnotationComposer,
          $$HeartRateSamplesTableCreateCompanionBuilder,
          $$HeartRateSamplesTableUpdateCompanionBuilder,
          (
            HeartRateSample,
            BaseReferences<
              _$AppDatabase,
              $HeartRateSamplesTable,
              HeartRateSample
            >,
          ),
          HeartRateSample,
          PrefetchHooks Function()
        > {
  $$HeartRateSamplesTableTableManager(
    _$AppDatabase db,
    $HeartRateSamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeartRateSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeartRateSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeartRateSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> heartRate = const Value.absent(),
                Value<String?> rrIntervals = const Value.absent(),
                Value<bool> contactDetected = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HeartRateSamplesCompanion(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                heartRate: heartRate,
                rrIntervals: rrIntervals,
                contactDetected: contactDetected,
                quality: quality,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required DateTime timestamp,
                required int heartRate,
                Value<String?> rrIntervals = const Value.absent(),
                required bool contactDetected,
                Value<int?> quality = const Value.absent(),
                required String source,
                Value<DateTime> createdAt = const Value.absent(),
              }) => HeartRateSamplesCompanion.insert(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                heartRate: heartRate,
                rrIntervals: rrIntervals,
                contactDetected: contactDetected,
                quality: quality,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeartRateSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeartRateSamplesTable,
      HeartRateSample,
      $$HeartRateSamplesTableFilterComposer,
      $$HeartRateSamplesTableOrderingComposer,
      $$HeartRateSamplesTableAnnotationComposer,
      $$HeartRateSamplesTableCreateCompanionBuilder,
      $$HeartRateSamplesTableUpdateCompanionBuilder,
      (
        HeartRateSample,
        BaseReferences<_$AppDatabase, $HeartRateSamplesTable, HeartRateSample>,
      ),
      HeartRateSample,
      PrefetchHooks Function()
    >;
typedef $$HrvSamplesTableCreateCompanionBuilder =
    HrvSamplesCompanion Function({
      Value<int> id,
      required String sessionId,
      required DateTime timestamp,
      required String rrIntervals,
      required int windowSeconds,
      Value<double?> rmssd,
      Value<double?> sdnn,
      Value<double?> pnn50,
      Value<double?> meanRR,
      Value<double?> heartRate,
      Value<int?> stressIndex,
      Value<DateTime> createdAt,
    });
typedef $$HrvSamplesTableUpdateCompanionBuilder =
    HrvSamplesCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<DateTime> timestamp,
      Value<String> rrIntervals,
      Value<int> windowSeconds,
      Value<double?> rmssd,
      Value<double?> sdnn,
      Value<double?> pnn50,
      Value<double?> meanRR,
      Value<double?> heartRate,
      Value<int?> stressIndex,
      Value<DateTime> createdAt,
    });

class $$HrvSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $HrvSamplesTable> {
  $$HrvSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrIntervals => $composableBuilder(
    column: $table.rrIntervals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windowSeconds => $composableBuilder(
    column: $table.windowSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sdnn => $composableBuilder(
    column: $table.sdnn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pnn50 => $composableBuilder(
    column: $table.pnn50,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get meanRR => $composableBuilder(
    column: $table.meanRR,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HrvSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $HrvSamplesTable> {
  $$HrvSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrIntervals => $composableBuilder(
    column: $table.rrIntervals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windowSeconds => $composableBuilder(
    column: $table.windowSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sdnn => $composableBuilder(
    column: $table.sdnn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pnn50 => $composableBuilder(
    column: $table.pnn50,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get meanRR => $composableBuilder(
    column: $table.meanRR,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HrvSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HrvSamplesTable> {
  $$HrvSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get rrIntervals => $composableBuilder(
    column: $table.rrIntervals,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windowSeconds => $composableBuilder(
    column: $table.windowSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rmssd =>
      $composableBuilder(column: $table.rmssd, builder: (column) => column);

  GeneratedColumn<double> get sdnn =>
      $composableBuilder(column: $table.sdnn, builder: (column) => column);

  GeneratedColumn<double> get pnn50 =>
      $composableBuilder(column: $table.pnn50, builder: (column) => column);

  GeneratedColumn<double> get meanRR =>
      $composableBuilder(column: $table.meanRR, builder: (column) => column);

  GeneratedColumn<double> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<int> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HrvSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HrvSamplesTable,
          HrvSample,
          $$HrvSamplesTableFilterComposer,
          $$HrvSamplesTableOrderingComposer,
          $$HrvSamplesTableAnnotationComposer,
          $$HrvSamplesTableCreateCompanionBuilder,
          $$HrvSamplesTableUpdateCompanionBuilder,
          (
            HrvSample,
            BaseReferences<_$AppDatabase, $HrvSamplesTable, HrvSample>,
          ),
          HrvSample,
          PrefetchHooks Function()
        > {
  $$HrvSamplesTableTableManager(_$AppDatabase db, $HrvSamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HrvSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HrvSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HrvSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> rrIntervals = const Value.absent(),
                Value<int> windowSeconds = const Value.absent(),
                Value<double?> rmssd = const Value.absent(),
                Value<double?> sdnn = const Value.absent(),
                Value<double?> pnn50 = const Value.absent(),
                Value<double?> meanRR = const Value.absent(),
                Value<double?> heartRate = const Value.absent(),
                Value<int?> stressIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HrvSamplesCompanion(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                rrIntervals: rrIntervals,
                windowSeconds: windowSeconds,
                rmssd: rmssd,
                sdnn: sdnn,
                pnn50: pnn50,
                meanRR: meanRR,
                heartRate: heartRate,
                stressIndex: stressIndex,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required DateTime timestamp,
                required String rrIntervals,
                required int windowSeconds,
                Value<double?> rmssd = const Value.absent(),
                Value<double?> sdnn = const Value.absent(),
                Value<double?> pnn50 = const Value.absent(),
                Value<double?> meanRR = const Value.absent(),
                Value<double?> heartRate = const Value.absent(),
                Value<int?> stressIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HrvSamplesCompanion.insert(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                rrIntervals: rrIntervals,
                windowSeconds: windowSeconds,
                rmssd: rmssd,
                sdnn: sdnn,
                pnn50: pnn50,
                meanRR: meanRR,
                heartRate: heartRate,
                stressIndex: stressIndex,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HrvSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HrvSamplesTable,
      HrvSample,
      $$HrvSamplesTableFilterComposer,
      $$HrvSamplesTableOrderingComposer,
      $$HrvSamplesTableAnnotationComposer,
      $$HrvSamplesTableCreateCompanionBuilder,
      $$HrvSamplesTableUpdateCompanionBuilder,
      (HrvSample, BaseReferences<_$AppDatabase, $HrvSamplesTable, HrvSample>),
      HrvSample,
      PrefetchHooks Function()
    >;
typedef $$AnalysisResultsTableCreateCompanionBuilder =
    AnalysisResultsCompanion Function({
      required String analysisId,
      required String sessionId,
      required String analysisType,
      required DateTime analysisTimestamp,
      required String algorithmVersion,
      required String status,
      required String data,
      Value<int?> confidence,
      Value<String?> errorMessage,
      Value<int?> processingTimeMs,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AnalysisResultsTableUpdateCompanionBuilder =
    AnalysisResultsCompanion Function({
      Value<String> analysisId,
      Value<String> sessionId,
      Value<String> analysisType,
      Value<DateTime> analysisTimestamp,
      Value<String> algorithmVersion,
      Value<String> status,
      Value<String> data,
      Value<int?> confidence,
      Value<String?> errorMessage,
      Value<int?> processingTimeMs,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AnalysisResultsTableFilterComposer
    extends Composer<_$AppDatabase, $AnalysisResultsTable> {
  $$AnalysisResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get analysisId => $composableBuilder(
    column: $table.analysisId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysisType => $composableBuilder(
    column: $table.analysisType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get analysisTimestamp => $composableBuilder(
    column: $table.analysisTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processingTimeMs => $composableBuilder(
    column: $table.processingTimeMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnalysisResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnalysisResultsTable> {
  $$AnalysisResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get analysisId => $composableBuilder(
    column: $table.analysisId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysisType => $composableBuilder(
    column: $table.analysisType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get analysisTimestamp => $composableBuilder(
    column: $table.analysisTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processingTimeMs => $composableBuilder(
    column: $table.processingTimeMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnalysisResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnalysisResultsTable> {
  $$AnalysisResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get analysisId => $composableBuilder(
    column: $table.analysisId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get analysisType => $composableBuilder(
    column: $table.analysisType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get analysisTimestamp => $composableBuilder(
    column: $table.analysisTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get algorithmVersion => $composableBuilder(
    column: $table.algorithmVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processingTimeMs => $composableBuilder(
    column: $table.processingTimeMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AnalysisResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnalysisResultsTable,
          AnalysisResult,
          $$AnalysisResultsTableFilterComposer,
          $$AnalysisResultsTableOrderingComposer,
          $$AnalysisResultsTableAnnotationComposer,
          $$AnalysisResultsTableCreateCompanionBuilder,
          $$AnalysisResultsTableUpdateCompanionBuilder,
          (
            AnalysisResult,
            BaseReferences<
              _$AppDatabase,
              $AnalysisResultsTable,
              AnalysisResult
            >,
          ),
          AnalysisResult,
          PrefetchHooks Function()
        > {
  $$AnalysisResultsTableTableManager(
    _$AppDatabase db,
    $AnalysisResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnalysisResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnalysisResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnalysisResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> analysisId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> analysisType = const Value.absent(),
                Value<DateTime> analysisTimestamp = const Value.absent(),
                Value<String> algorithmVersion = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int?> confidence = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int?> processingTimeMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisResultsCompanion(
                analysisId: analysisId,
                sessionId: sessionId,
                analysisType: analysisType,
                analysisTimestamp: analysisTimestamp,
                algorithmVersion: algorithmVersion,
                status: status,
                data: data,
                confidence: confidence,
                errorMessage: errorMessage,
                processingTimeMs: processingTimeMs,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String analysisId,
                required String sessionId,
                required String analysisType,
                required DateTime analysisTimestamp,
                required String algorithmVersion,
                required String status,
                required String data,
                Value<int?> confidence = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<int?> processingTimeMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisResultsCompanion.insert(
                analysisId: analysisId,
                sessionId: sessionId,
                analysisType: analysisType,
                analysisTimestamp: analysisTimestamp,
                algorithmVersion: algorithmVersion,
                status: status,
                data: data,
                confidence: confidence,
                errorMessage: errorMessage,
                processingTimeMs: processingTimeMs,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnalysisResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnalysisResultsTable,
      AnalysisResult,
      $$AnalysisResultsTableFilterComposer,
      $$AnalysisResultsTableOrderingComposer,
      $$AnalysisResultsTableAnnotationComposer,
      $$AnalysisResultsTableCreateCompanionBuilder,
      $$AnalysisResultsTableUpdateCompanionBuilder,
      (
        AnalysisResult,
        BaseReferences<_$AppDatabase, $AnalysisResultsTable, AnalysisResult>,
      ),
      AnalysisResult,
      PrefetchHooks Function()
    >;
typedef $$ExportHistoryTableCreateCompanionBuilder =
    ExportHistoryCompanion Function({
      Value<int> id,
      required String exportId,
      required String sessionId,
      required String exportType,
      required String filePath,
      required int fileSizeBytes,
      required DateTime exportTimestamp,
      Value<String?> parameters,
      required String status,
      Value<String?> errorMessage,
    });
typedef $$ExportHistoryTableUpdateCompanionBuilder =
    ExportHistoryCompanion Function({
      Value<int> id,
      Value<String> exportId,
      Value<String> sessionId,
      Value<String> exportType,
      Value<String> filePath,
      Value<int> fileSizeBytes,
      Value<DateTime> exportTimestamp,
      Value<String?> parameters,
      Value<String> status,
      Value<String?> errorMessage,
    });

class $$ExportHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ExportHistoryTable> {
  $$ExportHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exportId => $composableBuilder(
    column: $table.exportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exportType => $composableBuilder(
    column: $table.exportType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exportTimestamp => $composableBuilder(
    column: $table.exportTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parameters => $composableBuilder(
    column: $table.parameters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExportHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ExportHistoryTable> {
  $$ExportHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exportId => $composableBuilder(
    column: $table.exportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exportType => $composableBuilder(
    column: $table.exportType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exportTimestamp => $composableBuilder(
    column: $table.exportTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parameters => $composableBuilder(
    column: $table.parameters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExportHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExportHistoryTable> {
  $$ExportHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exportId =>
      $composableBuilder(column: $table.exportId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get exportType => $composableBuilder(
    column: $table.exportType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get exportTimestamp => $composableBuilder(
    column: $table.exportTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parameters => $composableBuilder(
    column: $table.parameters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );
}

class $$ExportHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExportHistoryTable,
          ExportHistoryData,
          $$ExportHistoryTableFilterComposer,
          $$ExportHistoryTableOrderingComposer,
          $$ExportHistoryTableAnnotationComposer,
          $$ExportHistoryTableCreateCompanionBuilder,
          $$ExportHistoryTableUpdateCompanionBuilder,
          (
            ExportHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ExportHistoryTable,
              ExportHistoryData
            >,
          ),
          ExportHistoryData,
          PrefetchHooks Function()
        > {
  $$ExportHistoryTableTableManager(_$AppDatabase db, $ExportHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExportHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExportHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExportHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> exportId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exportType = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<DateTime> exportTimestamp = const Value.absent(),
                Value<String?> parameters = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => ExportHistoryCompanion(
                id: id,
                exportId: exportId,
                sessionId: sessionId,
                exportType: exportType,
                filePath: filePath,
                fileSizeBytes: fileSizeBytes,
                exportTimestamp: exportTimestamp,
                parameters: parameters,
                status: status,
                errorMessage: errorMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String exportId,
                required String sessionId,
                required String exportType,
                required String filePath,
                required int fileSizeBytes,
                required DateTime exportTimestamp,
                Value<String?> parameters = const Value.absent(),
                required String status,
                Value<String?> errorMessage = const Value.absent(),
              }) => ExportHistoryCompanion.insert(
                id: id,
                exportId: exportId,
                sessionId: sessionId,
                exportType: exportType,
                filePath: filePath,
                fileSizeBytes: fileSizeBytes,
                exportTimestamp: exportTimestamp,
                parameters: parameters,
                status: status,
                errorMessage: errorMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExportHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExportHistoryTable,
      ExportHistoryData,
      $$ExportHistoryTableFilterComposer,
      $$ExportHistoryTableOrderingComposer,
      $$ExportHistoryTableAnnotationComposer,
      $$ExportHistoryTableCreateCompanionBuilder,
      $$ExportHistoryTableUpdateCompanionBuilder,
      (
        ExportHistoryData,
        BaseReferences<_$AppDatabase, $ExportHistoryTable, ExportHistoryData>,
      ),
      ExportHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PolarDevicesTableTableManager get polarDevices =>
      $$PolarDevicesTableTableManager(_db, _db.polarDevices);
  $$MeasurementSessionsTableTableManager get measurementSessions =>
      $$MeasurementSessionsTableTableManager(_db, _db.measurementSessions);
  $$EcgSamplesTableTableManager get ecgSamples =>
      $$EcgSamplesTableTableManager(_db, _db.ecgSamples);
  $$EcgSampleBatchesTableTableManager get ecgSampleBatches =>
      $$EcgSampleBatchesTableTableManager(_db, _db.ecgSampleBatches);
  $$HeartRateSamplesTableTableManager get heartRateSamples =>
      $$HeartRateSamplesTableTableManager(_db, _db.heartRateSamples);
  $$HrvSamplesTableTableManager get hrvSamples =>
      $$HrvSamplesTableTableManager(_db, _db.hrvSamples);
  $$AnalysisResultsTableTableManager get analysisResults =>
      $$AnalysisResultsTableTableManager(_db, _db.analysisResults);
  $$ExportHistoryTableTableManager get exportHistory =>
      $$ExportHistoryTableTableManager(_db, _db.exportHistory);
}
