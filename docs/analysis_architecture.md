# Analysis and AI Components Architecture

This document describes the implementation of section 7 "Analyse- und KI-Komponenten" from the development plan.

## Overview

The analysis and AI components provide the foundation for heart rate variability (HRV) analysis, signal processing, stress assessment, and AI-powered insights as specified in the development plan.

## Domain Models

### Core Analysis Models

#### HrvMetrics
Contains the statistical basis for HRV analysis:
- **RMSSD**: Root Mean Square of Successive Differences (parasympathetic activity)
- **SDNN**: Standard Deviation of NN intervals (overall HRV)
- **pNN50**: Percentage of NN intervals differing by >50ms (parasympathetic activity)

#### HeartRateAnalysis
Manages heart rate analysis including:
- Resting and maximum heart rate determination
- Heart rate zones (Zone 1-5 based on % HRR)
- Heart rate reserve calculations

#### StressIndicator
Provides stress analysis with:
- Overall stress level (0.0-1.0)
- Sympathetic/Parasympathetic nervous system activity
- Autonomic balance ratio
- Stress trend analysis

#### AnalysisResult
Combines all analysis components with:
- Complete HRV, heart rate, and stress analysis
- AI-generated insights and recommendations
- Validation metrics for quality assurance
- Processing metadata

## Interfaces

### Signal Processing
- **SignalProcessor**: Abstract interface for ECG signal processing
  - Filtering algorithms
  - Artifact detection and removal
  - R-Peak detection
  - Time and frequency domain feature extraction

### Analysis Engines
- **HrvCalculator**: HRV metrics calculation
- **HeartRateAnalyzer**: Heart rate zone and threshold analysis
- **StressAnalyzer**: Stress indicator and autonomic balance analysis

### AI Abstraction Layer
- **AnalysisEngine**: Main abstraction for switching between local/cloud AI
- **LocalAnalysisModel**: TensorFlow Lite local model interface
- **CloudLlmAnalyzer**: Cloud LLM interface for explanatory text

### Validation Framework
- **MetricsValidator**: Validation against public datasets
- **QualityAssurance**: QA process implementation
- Accuracy, sensitivity, and specificity metrics

## Key Features

### 1. Statistical Basis
- Implements all HRV metrics specified in the development plan
- Supports time-domain and frequency-domain analysis
- Provides autonomic nervous system balance assessment

### 2. Signal Processing Foundation
- Abstract interfaces for filtering and artifact detection
- R-Peak detection framework
- Feature extraction for both time and frequency domains

### 3. AI Strategy Implementation
- Clear abstraction layer for local vs. cloud models
- TensorFlow Lite integration ready
- Optional Cloud LLM support for explanatory text
- Model switching capabilities

### 4. Validation Framework
- Comparison against public datasets
- Accuracy, sensitivity, specificity metrics
- Quality assurance process
- Consistency validation across multiple runs

## Architecture Principles

1. **Separation of Concerns**: Clear boundaries between signal processing, analysis, and AI components
2. **Abstraction**: Interfaces allow easy switching between implementations
3. **Testability**: All components are designed for unit testing
4. **Extensibility**: Easy to add new metrics, models, or validation datasets
5. **Quality Focus**: Built-in validation and QA processes

## Dependencies Added

- `tflite_flutter`: TensorFlow Lite for local models
- `ml_linalg`: Linear algebra operations for signal processing
- `syncfusion_flutter_charts`: Visualization support
- `freezed` and `json_annotation`: Model generation support

## Testing

Unit tests are provided for all domain models covering:
- Model creation and validation
- Equality and hash code implementations
- Edge cases and boundary conditions
- Enum extensions and utility methods

## Future Development

This foundation supports the roadmap items:
- **Iteration 4 (Analyse)**: Statistical evaluations and charts
- **Iteration 5 (KI-Prototyp)**: Feature engineering and model integration
- **Iteration 6 (Verfeinerung)**: Advanced analysis and performance tuning

## Usage

The domain layer is exposed through `lib/src/domain/domain.dart` and can be used by:
- Data layer for persistence
- Feature layer for UI presentation
- Service layer for business logic implementation

All interfaces follow the established Flutter architecture patterns used in the project.