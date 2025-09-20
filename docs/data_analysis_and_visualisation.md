# Data Analysis and Visualisation Strategy
Hier ist ein klar strukturierter Visualisierungs- und Auswertungsplan für deine Flutter-App (Polar H10, Live auf Smartphone + spätere Analyse). Ich trenne sauber nach „Live“ vs. „Session/Offline“, ordne die Datenquellen (ECG-Samples, HR, RR) zu, und nenne konkrete Flutter-Pakete inkl. Short-Rationale.


## 1) Datenströme und Sampling-Annahmen

* **ECG (samples\[voltage], optional samplingRate/startTimeStamp)** → 130/500 Hz (je nach Polar-Einstellung), gleichmäßig getaktet; hoher Datendurchsatz → eigenes Rendering sinnvoll.
* **HR-Events (hr, rrs\[])** → 1–2 Hz; geringe Last; ideal für Metrik-Kacheln und Trendlinien.
* **RR-Intervalle (ms)** → ungleichmäßig; für HRV, Tachogramm, Poincaré, Histogramme.

---

## 2) Live-Visualisierung (auf dem Smartphone)

#### 2.1 ECG-Streifen (5–10 s „laufender“ Strip)

**Zweck:** Rhythmusgefühl, Artefakt-Erkennung, Elektrodenkontakt.
**UI/Tech:**

* **CustomPainter** für maximale Performance (durchgehendes Canvas-Zeichnen, segmentweise Shift/Blit anstatt kompletter Rebuilds). Gute Chart-Libs sind flexibel, aber für 500 Hz und 60 fps ist Canvas typischerweise schneller. Praxis-Guides bestätigen Canvas/CustomPainter als High-Perf-Pfad. ([Plague Fox][1])
* Dynamische Y-Skalierung (Gain), Baseline-Wander-Filter (HP 0.5 Hz), Soft-Clipping.
* **Overlays:** erkannte R-Peaks (Punkte), Artefakte (rote Marker), „No-contact“ Banner.

#### 2.2 Live-Tachogramm (RR über Zeit, 1–3 min Fenster)

**Zweck:** Unregelmäßigkeit/Variabilität live sichtbar.
**UI/Tech:** Line-Chart mit 1–2 Hz Updates.
**Paket:** **Syncfusion Flutter Charts** (stabile, performante Live-Updates via `ChartSeriesController.updateDataSource`). ([Dart packages][2])

#### 2.3 Live-HR-Kachel + Zonen-Gauge

**Zweck:** Sofortblick (bpm), Trainings-/Ruhebezug.
**UI/Tech:** große Zahl + Mini-Sparklines + Gauge (Zone 1–5).
**Pakete:** **syncfusion\_flutter\_charts** (Sparklines) + **syncfusion\_flutter\_gauges** (Gauge). ([Dart packages][2])

#### 2.4 Live-Poincaré-„Trail“

**Zweck:** HRV-Qualitätsindikator (Form/Dispersion).
**UI/Tech:** Scatter mit „decay“ (letzte 120–300 RR-Paare), Intervallberechnung auf Isolate.
**Paket:** **Syncfusion Charts** oder **fl\_chart** (Scatter). ([Dart packages][2])

#### 2.5 Qualitäts-/Artefakt-Anzeige

**Zweck:** Nutzerfeedback (Elektroden, Bewegungsartefakte).
**UI/Tech:** horizontale Qualitätsleiste (grün/gelb/rot), Event-Toasts bei Kontaktverlust.

**Performance-Hinweise Live:**

* ECG-Strip in **CustomPainter**, alles andere in **Charts** kombinieren.
* Daten-Pipeline: Ringpuffer (ECG), Downsampling (z. B. 500 Hz→250/125 Hz) vor dem Zeichnen.
* Rechenlast (Filter, R-Peak) in **Isolates** verlagern; Charts nur mit reduzierten Punkten füttern (≤2–5 k Punkte/Fenster).

---

## 3) Offline/Session-Analyse (gespeicherte Daten)

#### 3.1 Session-Übersicht (Timeline)

* **Widgets:**

  1. HR-Trend (bpm) über gesamte Dauer
  2. Tachogramm (RR)
  3. Artefakt-Heatmap (Signalqualität)
  4. Event-Leiste (Marker: Start/Stop, Elektroden-off, Spitzen)
* **Interaktion:** Bereichsauswahl (Brush/Zoom), „Go to ECG segment“.

**Paket:** **Syncfusion Flutter Charts** (große Datenmengen, Zoom/Pan, Trackball). Performance-Blog hebt Render-Boost & reduzierten Speicher hervor. ([Dart packages][2])

#### 3.2 HRV-Zeitfenster-Kacheln

* **Metriken:** RMSSD, SDNN, pNN50 (bewegliches 1–5-min Fenster; outlier-gefiltert).
* **Visuals:** Liniendiagramme je Metrik + Tabellen-Kachel (Perzentile, Median, IQR).
  **Paket:** Syncfusion Charts (Line + BoxPlot) + DataTable.

#### 3.3 Poincaré (SD1/SD2)

* **Plots:** Gesamt-Poincaré, segmentierte Poincaré pro ausgewähltem Abschnitt; SD1/SD2-Ellipse.
* **Nutzen:** Parasympathischer Tonus/Beat-to-Beat-Variabilität.

#### 3.4 Histogramme (RR, HR) + Dichte

* **Plots:** RR-Histogram (10–20 ms Bins), HR-Histogram; optional Kernel-Dichte.
* **Nutzen:** Unregelmäßigkeiten, Mehrgipfligkeit.

#### 3.5 Frequenzdomäne (HRV)

* **Methoden:** Lomb-Scargle (ungleichmäßige RR), alternativ resampling→Welch.
* **Plots:** LF/HF-Spektrum, LF/HF-Ratio-Zeitreihe.
* **Tech:** **fftea** (Dart-FFT) ist verfügbar; bei Lomb-Scargle ggf. eigene Implementierung/Isolate. ([Dart packages][3])

#### 3.6 Episoden-Detektion

* **Ereignisse:** Brady/Tachy (Schwellen), Pausen (>2 s), hohe RR-Varianz-Segmente, Suspekt-Episoden (Screening).
* **Plots:** Markierungen auf HR-Trend/Tachogramm, Event-Tabelle (Start/Ende/Dauer).

#### 3.7 „Schlaf-Skizze“ (Heuristik)

* **Nur grob aus HR/RR:** Low-HR+hohe HRV-Plateaus → NREM-Hinweis; phasenweise höhere HRV-Volatilität → REM-Hinweis. Kein Polysomno-Ersatz, aber als Hypnogram-Approx darstellbar (grau/hell markierte Abschnitte).

---

## 4) Komponenten-Landkarte (Flutter-Pakete)

| Zweck               | Empfehlung                      | Begründung                                                                                             |
| ------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Live-ECG-Strip      | **CustomPainter**               | Höchste Render-Kontrolle/-Performance für 500 Hz; Canvas-Optimierungen dokumentiert. ([Plague Fox][1]) |
| Live/Offline-Charts | **syncfusion\_flutter\_charts** | Reife API, Live-Update-Beispiele, Performance-Boosts. ([Dart packages][2])                             |
| Alternativ/leicht   | **fl\_chart**                   | Leichtgewichtig, gute Line/Scatter; weniger Features. ([Dart packages][4])                             |
| Grammar-of-Graphics | **graphic**                     | Hohe Flexibilität bei komplexen Spezifikationen. ([Dart packages][5])                                  |
| Gauge               | **syncfusion\_flutter\_gauges** | Stabil, M3-kompatibel. ([fluttergems.dev][6])                                                          |
| FFT/HRV-Freq        | **fftea**                       | Dart-FFT/STFT; Isolate-fähig. ([Dart packages][3])                                                     |

> Polar SDK/Referenz (Android): offizielle GitHub-Repos & aktuelle Releases zur Bridge-Pflege. ([GitHub][7])

---

## 5) Interaktions- und UX-Details

**Live:**

* Start/Stop-FAB, Status (Connected/Streaming), Batterie-Icon, Elektroden-Status.
* Einfache Gain-Buttons (×0.5/×1/×2), Paper-Speed (25/50 mm/s-Äquivalent).
* „Freeze“-Modus (kurz pausieren, pinchen/zoomen, weiterlaufen lassen).

**Offline:**

* Zeitbalken mit Brush (RangeSelector) → synchronisiert alle Charts.
* Trackball/Crosshair mit Tooltips (RR, HR, RMSSD etc.).
* Events als Timeline-Pillen; Tap → springt zum ECG-Segment.

---

## 6) Verarbeitungspipeline (Performance-Skizze)

**Live-Threading:**

* BLE-Ingress → **StreamController** (back-pressure aware).
* **Isolate A**: Signal-Conditioning (HP-Filter, optional Notch), R-Peak (Pan/Tompkins-Variante), Downsampling (z. B. 500→125 Hz) für das **ECG-Rendering**.
* **Isolate B**: RR-Puffer → RMSSD/SDNN/pNN50 Rolling-Window (1–5 min) → Live-Poincaré.
* UI-Thread: nur rendering-fertige Arrays (Float32List) konsumieren.

**Offline-Jobs:**

* Batch-Decoder (komprimierte BLOBs), Artefakt-Detektion (Amplitude-Clipping, Flatline, High-Slope), RR-Cleaning (ectopy removal), HRV-Zeitfenster, Frequenzanalyse (Lomb-Scargle/FFT) → Persistenz + Charts.

---

## 7) Konkrete Visuals (Minimal-Viable → Ausbau)

**MVP Live (Sprint 1–2):**

1. ECG-Strip (CustomPainter, 8 s Fenster)
2. HR-Kachel + Sparklines
3. Live-Tachogramm (60–180 s Fenster)
4. Qualitätsleiste + Elektroden-Status

**MVP Offline (Sprint 3–4):**

1. Session-Übersicht (HR-Trend + RR-Tachogramm + Event-Leiste)
2. HRV-Kacheln (RMSSD/SDNN/pNN50 Trend)
3. Poincaré (gesamt + selektierter Bereich)
4. RR/HR-Histogramme

**Erweiterungen (Sprint 5+):**

* Frequenzdomäne (LF/HF, Spectral Timeline)
* „Schlaf-Skizze“ (heuristisch)
* Episoden-Detektion (Brady/Tachy/Pauses)
* Export (PDF mit Charts)

---

## 8) Umsetzungshinweise (Flutter/Dart)

* **Syncfusion Live-Updates:** `ChartSeriesController.updateDataSource(addRemoveParams…)` für flackerfreie Streams; Beispiele zeigen genau das Live-Szenario. ([syncfusion.com][8])
* **CustomPainter ECG:** Double-Buffer (offscreen `ui.Image`), nur „rechte Kante“ neu malen (Scroll-Illusion), konstante Frametimes.
* **FFT/HRV:** **fftea** in Isolate (keine UI-Janks). ([Dart packages][3])
* **Datenpfad:** Deine vorhandene `polar_bridge`-Events (`hr`, `ecg`, `rrs`) mappen direkt auf die oben genannten Widgets; SamplingRate/StartTimestamp an der Bridge priorisieren (du hast das im Projekt bereits angelegt).

---

## 9) Warum genau diese Pakete?

* **Syncfusion Charts/Gauges:** Stabil, aktiv gepflegt, bewiesene Live-Performance und umfangreiche Interaktion (Zoom/Trackball/Brush). ([Dart packages][2])
* **fl\_chart:** gute, einfache Alternative (wenn du Lizenzfreiheit/kleine Abhängigkeiten priorisierst). ([Dart packages][4])
* **graphic:** wenn du künftig eine „Grammar of Graphics“-Konfiguration (ggplot-artig) möchtest. ([Dart packages][5])
* **CustomPainter:** unschlagbar für hochfrequente Strips. Praxis-Guides zu Canvas-Optimierung verfügbar. ([Plague Fox][1])
* **fftea:** native FFT in Dart, keine Plattform-Lib nötig. ([Dart packages][3])

---

## 10) Nächste konkrete Schritte (hands-on)

1. **ECG-Strip als CustomPainter** (8 s Fenster, 125 Hz Downsample, Gain-Buttons).
2. **Live-HR-Kachel + Tachogramm** mit **Syncfusion** und `updateDataSource`. ([GitHub][9])
3. **RR-Rolling-HRV** (RMSSD/SDNN/pNN50) auf Isolate; **Live-Poincaré** (Scatter).
4. **Session-Viewer**: HR-Trend + Tachogramm + Event-Leiste (Zoom/Brush).
5. **Artefakt-Pipeline** (Amplitude/Flatline/Slope), Farbbalken in Live/Offline.
6. **Frequenzanalyse** (fftea; optional später Lomb-Scargle).

Wenn du möchtest, skizziere ich dir direkt die Flutter-Widgets (Gerüstcode) für:

* den **CustomPainter-ECG-Strip** (mit Ringpuffer, Gain, Offscreen-Canvas),
* ein **Syncfusion-Live-LineChart** mit Controller-Update,
* und die **Poincaré-Scatter**-Komponente.

[1]: https://plugfox.dev/high-performance-canvas-rendering/?utm_source=chatgpt.com "High-Performance Canvas Rendering"
[2]: https://pub.dev/packages/syncfusion_flutter_charts?utm_source=chatgpt.com "syncfusion_flutter_charts | Flutter package"
[3]: https://pub.dev/packages/fftea?utm_source=chatgpt.com "fftea | Dart package"
[4]: https://pub.dev/packages/fl_chart?utm_source=chatgpt.com "fl_chart | Flutter package"
[5]: https://pub.dev/packages/graphic?utm_source=chatgpt.com "graphic | Flutter package"
[6]: https://fluttergems.dev/plots-visualization/?utm_source=chatgpt.com "Top Flutter Charts, Plots, Visualization packages for line ..."
[7]: https://github.com/polarofficial/polar-ble-sdk?utm_source=chatgpt.com "GitHub - polarofficial/polar-ble-sdk: Repository includes ..."
[8]: https://www.syncfusion.com/blogs/post/updating-live-data-in-flutter-charts?utm_source=chatgpt.com "Updating Live Data in Flutter Charts - A Complete Guide"
[9]: https://github.com/SyncfusionExamples/how-to-create-a-real-time-flutter-chart-in-10-minutes?utm_source=chatgpt.com "SyncfusionExamples/how-to-create-a-real-time-flutter-chart ..."

Bibliothek / Framework	GitHub Repository (falls vorhanden)
Syncfusion Flutter Widgets / syncfusion_flutter_charts	https://github.com/syncfusion/flutter-widgets 
GitHub

fftea	https://github.com/liamappelbe/fftea 
GitHub
+1