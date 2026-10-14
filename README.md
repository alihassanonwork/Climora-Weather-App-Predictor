# Climora 🌤️
> **Weather, beautifully understood.**

A premium, modern, production-ready Flutter weather application for Android (with responsive adaptations), powered by the real-time [Open-Meteo](https://open-meteo.com/) Forecast and Geocoding APIs. Climora pairs meteorological rigor with a distinctive Navy-Blue and Sky-Blue visual aesthetic, offering rich weather insights without clutter or fabricated numbers.

---

## ✨ Features & Highlights

### 1. Visual Design & Atmospheric Identity
- **Material 3 Theme System**: Custom navy and sky-blue palette with full support for Light Theme, Dark Theme, and System Default.
- **Dynamic Weather Gradients**: Hero banner backgrounds dynamically adjust according to live WMO weather codes and local diurnal phases (day/night).
- **Readable Typography**: Large temperature typography, accessible contrast ratios, and touch-friendly controls.
- **Micro-Animations**: Pulsing sun loader, smooth sheet interactions, and fluid transitions.

### 2. Meteorological Precision (Open-Meteo Integration)
- **Live Data Integrity**: Uses actual meteorological endpoints with sound Dart models—no mock or fabricated numbers.
- **Hero Dashboard**: Displays live temperature, apparent ("feels-like") temperature, WMO weather condition description, today's high/low, and last-updated timestamp.
- **24-Hour Hourly Forecast Strip**: Horizontally scrollable timeline featuring hour labels, weather icons, temperatures, and precipitation probabilities.
- **Detailed Metrics Grid**:
  - **Wind**: Speed with directional compass points (e.g., `WNW (280°)`)
  - **Humidity**: Relative humidity with air dryness/comfort classification
  - **Surface Pressure**: Atmospheric barometric pressure
  - **UV Index**: Live UV index with qualitative category (Low, Moderate, High, Very High, Extreme)
  - **Precipitation**: Current rainfall volume and today's rain probability
  - **Sun Cycle**: Sunrise and sunset times
- **5-Day Calendar Forecast**:
  - Displays weekday and short calendar dates
  - Compact temperature-range gradient bars indicating relative thermal spreads
  - Precipitation probability and max wind speed
  - Tap any day to open a **Day Detail Sheet** containing complete metrics and hourly progressions for that specific day.
- **Intelligent Weather Insights**:
  - Natural language, rule-based daily outlook derived from real API metrics.
  - UV exposure advice and sunscreen recommendations.
  - Meteorological notices (High Wind Advisory, Freezing Conditions, Heavy Rainfall, Elevated UV) with an explicit emergency notice disclaimer.

### 3. City Search, GPS & Persistent Favorites
- **Geocoding Search**: Search worldwide cities with a 350ms debounce to avoid spamming the network.
- **Duplicate Disambiguation**: Lists region (`admin1`) and country to differentiate duplicate city names (e.g., Springfield, IL vs Springfield, MO).
- **GPS Device Location**: One-tap current location detection using `geolocator`, with clear permission handling and non-blocking fallback to manual search.
- **Local Persistence**: Saved favorite cities and recent searches stored locally using `shared_preferences`.
- **Popular Destinations**: Quick-select chips for major global cities.

### 4. Unit Customization & Settings
- **Temperature**: Celsius (°C) and Fahrenheit (°F)
- **Wind Speed**: km/h, m/s, and mph
- **Atmospheric Pressure**: hPa, mmHg, and inHg
- **Precipitation**: Millimeters (mm) and Inches (in)
- **Live Reactivity**: Changing any unit updates every screen and card instantly and survives app restarts.
- **API Attribution**: Clear attribution to Open-Meteo in accordance with the CC BY 4.0 license.

---

## 🏛️ Architecture & Code Quality

Climora adheres to a feature-based architecture separating domain models, data sources, business logic, and presentation:

```
lib/
├── app.dart                                # MaterialApp entry point & theme switcher
├── main.dart                               # Initializer, persistent storage setup, ProviderScope
├── core/
│   ├── config/app_config.dart              # API endpoints, timeouts, and attribution
│   ├── constants/app_constants.dart        # Popular cities & preference keys
│   ├── errors/app_exceptions.dart          # Typed exceptions (Network, Api, Location, Cache)
│   ├── theme/                              # ClimoraColors & ClimoraTheme (Material 3)
│   └── utils/                              # UnitConverter, WeatherInterpreter, DateFormatter, WeatherSummaryHelper
├── data/
│   ├── models/                             # CityLocation, CurrentWeather, DailyForecast, HourlyForecast, WeatherData, UserSettings
│   ├── services/                           # WeatherApiService, GeocodingApiService, LocationService, StorageService
│   └── repositories/                       # WeatherRepository (caching, fallback, coordination)
├── features/
│   ├── forecast/screens/                   # DayDetailSheet modal
│   ├── home/                               # HomeScreen, WeatherHero, HourlyStrip, MetricsGrid, 5-Day Card, Insights
│   ├── search/                             # SearchScreen, CitySearchTile, CitySearchController
│   └── settings/                           # SettingsScreen, SettingsController
└── shared/widgets/                         # ClimoraCard, WeatherIconWidget, LoadingView, ErrorView, EmptyView
```

### Architecture Highlights:
- **Riverpod 3**: Clean dependency injection and state management using `Notifier` and `AsyncNotifier`.
- **Defensive Error Handling**: Network interruptions, GPS denial, and API rate limits render friendly, recoverable error views with retry buttons.
- **Local Caching**: Recent weather responses are cached locally to minimize redundant network requests and enable offline resilience.

---

## 🧪 Testing & Verification

The project includes unit and widget test suites covering data models, unit conversions, meteorological interpreters, rule engines, and core UI widgets:

```bash
# Format codebase
dart format .

# Static analysis (0 warnings, 0 errors)
flutter analyze

# Execute all test suites
flutter test
```

### Test Suite Summary:
- `test/unit/model_parsing_test.dart`: Open-Meteo JSON deserialization & caching tests
- `test/unit/unit_converter_test.dart`: Temperature, wind, pressure, precipitation, and compass conversions
- `test/unit/weather_interpreter_test.dart`: WMO weather codes 0–99 and UV index thresholds
- `test/unit/weather_summary_helper_test.dart`: Rule-based natural language summaries & alert triggers
- `test/widget_test.dart`: Widget tests for `ErrorView`, `EmptyView`, `WeatherHero`, `MetricsGrid`, `HourlyForecastStrip`, and `DailyForecastCard`

**Verification Status**: **21 of 21 tests passing**, 0 static analysis issues.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.24.0 or newer)
- Android Studio / VS Code with Flutter extension
- Android device or emulator (Android 7.0 / API 24+)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Climora-Weather-App-Predictor.git
   cd Climora-Weather-App-Predictor
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

---

## 📄 Attribution & License

- Weather data and Geocoding provided by [Open-Meteo.com](https://open-meteo.com/) under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license.
- Open-Meteo is free for non-commercial use with no API key required.
