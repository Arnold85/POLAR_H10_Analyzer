# Polar H10 Analyzer – Entwicklungsplan (Android-Fokus)

## 1. Zieldefinition & Rahmenbedingungen
- **Primäres Ziel**: Android-App zur Erfassung, Speicherung und Analyse von ECG-, Herzfrequenz- und RR-Daten eines Polar H10 Sensors.
- **Sekundärziel**: Architektur so gestalten, dass spätere iOS-Portierung möglich ist; Web/Desktop aktuell außer Scope.
- **Kerneigenschaften**: Lokale Datenspeicherung, Export (CSV, EDF, PDF), KI-gestützte Auswertungen (lokale Modelle bevorzugt, Cloud-LLM optional), modernes und leicht verständliches UI.
- **Nicht-Ziele**: Sicherheits- und Datenschutzanforderungen zunächst nachrangig, keine Trainingssteuerungsfunktionen.

## 2. Recherche & Analyse Polar BLE SDK
- SDK-Dokumentation und Beispielcode studieren (Streaming APIs, Datenformate, Berechtigungen).
- Prüfen, welche Streams simultan abrufbar sind (ECG, HR, Acceleration) und welche Samplingraten unterstützt werden.
- Lizenzbedingungen und mögliche Einschränkungen für KI-gestützte Auswertungen klären.
- Evaluieren, wie Signalqualität, Elektrodenstatus und Fehlerzustände gemeldet werden.

## 3. Architektur & Projektstruktur
- **Flutter-Schichtenmodell**: `core` (Logging, Fehlerbehandlung, Theme), `data` (Repositories, Datenquellen), `domain` (Use-Cases, Modelle), `features` (UI + Controller/State).
- **State-Management**: Riverpod für Abhängigkeits-Injektion und Zustandsverwaltung.
- **Routing**: GoRouter mit Shell-Navigation (Dashboard, Sessions, Analyse, Einstellungen).
- **Native Integration**: Eigenes Flutter-Plugin (`polar_bridge`) als Wrapper um das Polar BLE SDK (Kotlin, später Swift).
- **Testbarkeit**: Abstraktion der BLE-Schnittstelle für Mocks und Replay-Daten.

## 4. Projekt-Setup & Tooling
- Flutter-Version fixieren, `analysis_options.yaml` erweitern (striktere Lints, ggf. custom rules).
- Packages auswählen: `flutter_riverpod`, `go_router`, `freezed`/`json_serializable`, `drift` oder `isar`, `permission_handler`, `syncfusion_flutter_charts`, `printing`/`syncfusion_flutter_pdf`.
- Automatisiertes Formatting (`dart format`), Analyse (`flutter analyze`), Tests (`flutter test`) in CI verankern.
- Grundlegende App-Themes, Farb- und Typografie-System definieren (Material 3, Dark/Light).

## 5. BLE-Integration (Android)
- Polar SDK via Gradle einbinden, Mindest-API-Level und Bluetooth-/Location-Permissions konfigurieren.
- Verbindungslifecycle implementieren (Scan, Pairing, Authentifizierung, Reconnects, Foreground-Service für Langzeit-Streams).
- Datenkanäle zu Flutter mittels Method- & EventChannels oder Pigeon aufsetzen.
- Fehler- und Statusmodell definieren (z. B. `Disconnected`, `Connecting`, `Streaming`, `Error`).
- Mock- und Replay-Streams für Tests bereitstellen.

## 6. Datenmodell & Persistenz
- Domänenmodelle: `PolarDevice`, `MeasurementSession`, `EcgSample`, `HeartRateSample`, `AnalysisResult`.
- Speicherung: Lokale Datenbank (z. B. Drift) mit Tabellen für Sessions, Rohdaten (Chunking/Binning), Analyseergebnisse.
- Hintergrundprozesse zum Puffern und Batch-Speichern von Streamingdaten.
- Exportpipeline für CSV, EDF (über Bibliothek oder eigener Writer) und PDF-Berichte.

## 7. Analyse- und KI-Komponenten
- **Statistische Basis**: HRV-Metriken (RMSSD, SDNN, pNN50), Ruhe-/Maximalpuls, Stress-Indikatoren, Sympathikus/Parasympathikus-Verhältnis.
- **Signalverarbeitung**: Filterung, Artefakterkennung, R-Peak-Detektion, Zeit-/Frequenzdomänen-Features.
- **KI-Strategie**: Lokale Modelle mit TensorFlow Lite; optional Cloud-LLM für erklärende Texte/Weiterinterpretationen. Klarer Abstraktionslayer zum Umschalten.
- **Validierung**: Vergleich mit öffentlich verfügbaren Datensätzen, Definition von Metriken (Accuracy, Sensitivität) und QA-Prozess.

## 8. UI/UX & Visualisierung
- Modernes, minimalistisches Design (Material 3, adaptive Layouts, Dark Mode).
- **Hauptbereiche**:
  - Dashboard: Live-Daten, Verbindungstatus, Echtzeit-ECG-Plot, Stressindikatoren.
  - Sessions: Liste, Filter, Detailansichten mit Diagrammen und Exportoptionen.
  - Analyse: HRV-/Stressreports, KI-Kommentare, Warnhinweise.
  - Einstellungen: Geräteverwaltung, Aufzeichnungsoptionen, KI-Modus, Datenexport.
- Realtime-Visualisierung (Streaming-Charts) mit effizientem Rendern und Downsampling.

## 9. Reporting & Export
- CSV-Export für Rohdaten und Metadaten.
- EDF-Export (ECG-Standard) – Evaluieren vorhandener Dart/Native-Bibliotheken oder eigene Implementierung.
- PDF-Reports mit Diagrammen, HRV-Tabellen, KI-Zusammenfassungen; Sharing über Systemdialog.
- Versionierte Exportprofile für künftige Automatisierung.

## 10. Qualitätssicherung & Testing
- Unit-Tests (Domain, Parser, Use-Cases), Widget-Tests (UI-Stati), Integrationstests mit simulierten Streams.
- Native Instrumentation-Tests für BLE-Verbindung (Android).
- Manuelle Tests mit echten Geräten (verschiedene Smartphones, Störszenarien, lange Sessions).
- Monitoring & Logging (z. B. Firebase Crashlytics) für spätere Releases vorbereiten.

## 11. Roadmap (Iterationen)
1. **Foundations**: Projektstruktur, Navigation, Themes, Platzhalter-UI, Dokumentation.
2. **BLE-Basics**: Native Plugin, Gerätescan, Verbindung, Herzfrequenz-Stream.
3. **ECG & Persistenz**: ECG-Streaming, Pufferung, lokale Speicherung, Sessionverwaltung.
4. **Analyse**: Statistische Auswertungen, Charts, Export (CSV/PDF).
5. **KI-Prototyp**: Feature-Engineering, lokales Modell, Cloud-LLM-Schnittstelle.
6. **Verfeinerung**: EDF-Export, Hintergrundaufzeichnung, UI-Finish, Beta-Test.
7. **Portierung & Skalierung**: iOS-Proof-of-Concept, Performance-Tuning, Monitoring.

## 12. Nächste Schritte
- Architekturgrundgerüst in Flutter implementieren (Navigation, Themes, Platzhalterseiten).
- Native Plugin-Spezifikation für Polar BLE SDK ausarbeiten.
- Datenmodell-Entwurf (UML/Schema) vorbereiten.
- Ressourcen und Tools für Signalverarbeitung/Analyse evaluieren.
