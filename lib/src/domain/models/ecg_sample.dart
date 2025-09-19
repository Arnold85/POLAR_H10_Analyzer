import 'package:json_annotation/json_annotation.dart';

part 'ecg_sample.g.dart';

/// Domain model representing an ECG sample point
@JsonSerializable()
class EcgSample {
  /// Session this sample belongs to
  final String sessionId;
  
  /// Timestamp of the sample
  final DateTime timestamp;
  
  /// ECG voltage value in millivolts (mV)
  final double voltage;
  
  /// Sample sequence number within session
  final int sequenceNumber;
  
  /// Quality indicator for this sample (0-100)
  final int? quality;
  
  /// Whether this sample contains an R-peak detection
  final bool isRPeak;
  
  /// Lead/channel identifier (for multi-lead ECG)
  final String? leadId;

  const EcgSample({
    required this.sessionId,
    required this.timestamp,
    required this.voltage,
    required this.sequenceNumber,
    this.quality,
    this.isRPeak = false,
    this.leadId,
  });

  factory EcgSample.fromJson(Map<String, dynamic> json) =>
      _$EcgSampleFromJson(json);

  Map<String, dynamic> toJson() => _$EcgSampleToJson(this);

  EcgSample copyWith({
    String? sessionId,
    DateTime? timestamp,
    double? voltage,
    int? sequenceNumber,
    int? quality,
    bool? isRPeak,
    String? leadId,
  }) {
    return EcgSample(
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      voltage: voltage ?? this.voltage,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      quality: quality ?? this.quality,
      isRPeak: isRPeak ?? this.isRPeak,
      leadId: leadId ?? this.leadId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EcgSample &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          sequenceNumber == other.sequenceNumber;

  @override
  int get hashCode => Object.hash(sessionId, sequenceNumber);

  @override
  String toString() {
    return 'EcgSample{sessionId: $sessionId, sequenceNumber: $sequenceNumber, voltage: ${voltage}mV, isRPeak: $isRPeak}';
  }
}

/// Batch of ECG samples for efficient processing
@JsonSerializable()
class EcgSampleBatch {
  /// Session this batch belongs to
  final String sessionId;
  
  /// Batch start timestamp
  final DateTime startTimestamp;
  
  /// Batch end timestamp
  final DateTime endTimestamp;
  
  /// Sampling rate in Hz
  final double samplingRate;
  
  /// ECG voltage values in sequence
  final List<double> voltages;
  
  /// R-peak indices within this batch
  final List<int> rPeakIndices;
  
  /// Batch sequence number
  final int batchNumber;
  
  /// Quality metrics for this batch
  final BatchQuality? quality;

  const EcgSampleBatch({
    required this.sessionId,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.samplingRate,
    required this.voltages,
    this.rPeakIndices = const [],
    required this.batchNumber,
    this.quality,
  });

  factory EcgSampleBatch.fromJson(Map<String, dynamic> json) =>
      _$EcgSampleBatchFromJson(json);

  Map<String, dynamic> toJson() => _$EcgSampleBatchToJson(this);

  /// Convert batch to individual ECG samples
  List<EcgSample> toSamples() {
    final samples = <EcgSample>[];
    final timeDelta = Duration(
      microseconds: (1000000 / samplingRate).round(),
    );
    
    for (int i = 0; i < voltages.length; i++) {
      final timestamp = startTimestamp.add(timeDelta * i);
      final isRPeak = rPeakIndices.contains(i);
      
      samples.add(EcgSample(
        sessionId: sessionId,
        timestamp: timestamp,
        voltage: voltages[i],
        sequenceNumber: (batchNumber * voltages.length) + i,
        isRPeak: isRPeak,
        quality: quality?.averageQuality,
      ));
    }
    
    return samples;
  }

  @override
  String toString() {
    return 'EcgSampleBatch{sessionId: $sessionId, batchNumber: $batchNumber, samples: ${voltages.length}, rPeaks: ${rPeakIndices.length}}';
  }
}

/// Quality metrics for a batch of ECG samples
@JsonSerializable()
class BatchQuality {
  /// Average signal quality (0-100)
  final int averageQuality;
  
  /// Signal-to-noise ratio
  final double? snr;
  
  /// Number of artifacts detected
  final int artifactCount;
  
  /// Baseline wander level
  final double? baselineWander;

  const BatchQuality({
    required this.averageQuality,
    this.snr,
    required this.artifactCount,
    this.baselineWander,
  });

  factory BatchQuality.fromJson(Map<String, dynamic> json) =>
      _$BatchQualityFromJson(json);

  Map<String, dynamic> toJson() => _$BatchQualityToJson(this);
}