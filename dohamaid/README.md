<div align="center">

# 🏠 Doha Maid — الخادم

### Your trusted home services marketplace in Qatar

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Version](https://img.shields.io/badge/Version-1.6.0+4-green)](./pubspec.yaml)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://flutter.dev/multi-platform)

</div>

---

## 📋 Table of Contents

### For Users
- [What is Doha Maid?](#-what-is-doha-maid)
- [Features](#-features)
- [Getting Started](#-getting-started)
- [App Screens & Flow](#-app-screens--flow)
- [Supported Languages](#-supported-languages)

### For Developers
- [Tech Stack](#-tech-stack)
- [Project Architecture](#-project-architecture)
- [Directory Structure](#-directory-structure)
- [State Management](#-state-management-cubits)
- [API Reference](#-api-reference)
- [Local Storage Keys](#-local-storage-keys)
- [Notification System](#-notification-system)
- [Theming & Styling](#-theming--styling)
- [Setup & Running](#-setup--running)
- [Environment & Configuration](#-environment--configuration)
- [Known Issues & TODOs](#-known-issues--todos)

---

## 👤 For Users

---

## 🏠 What is Doha Maid?

**Doha Maid** (Arabic: الخادم) is a mobile application that connects residents in Qatar with professional home service providers. Whether you need house cleaning, a domestic worker, nursing care, or pest control — Doha Maid brings verified companies to your fingertips.

> The app is available in **Arabic** and **English**, and fully supports **dark mode**.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🧹 **Cleaning Services** | Browse and book certified house cleaning companies |
| 👷 **Worker Companies** | Find domestic workers and maid placement agencies |
| 🤝 **Worker Suppliers** | Access direct worker supply services |
| 🏥 **Nursing Care** | Book professional nursing and elderly care services |
| 🐛 **Pest Control** | Hire anti-bug and pest control companies |
| 📅 **Easy Booking** | Multi-step booking: pick service → date → time → worker |
| 💰 **Price Estimation** | Get pricing before confirming any booking |
| 📋 **My Bookings** | View and manage all your active and past bookings |
| ❌ **Booking Cancellation** | Cancel bookings with status checks |
| 🗺️ **Location Selection** | Interactive Google Maps location picker |
| 💳 **Wallet Balance** | View your in-app balance |
| 👤 **Profile Management** | Update your personal details |
| 🔔 **Push Notifications** | Receive real-time booking updates |
| 🌙 **Dark Mode** | Full light/dark theme support |
| 🌍 **Bilingual** | Full Arabic (RTL) and English (LTR) support |

---

## 🚀 Getting Started

### 1. Create an Account
- Open the app and tap **Register**
- Enter your **name**, **phone number**, and **password**
- Verify your phone number via the **OTP code** sent to you

### 2. Browse Services
- After logging in, the **Home Screen** displays all available service categories
- Tap any category to browse companies

### 3. Book a Service
1. Select a **company** from the list
2. View **company details**, ratings, and services
3. Tap **Book Now**
4. Choose your **service**, **date**, **time**, and **worker**
5. Review the **price estimate**
6. Confirm your booking

### 4. Manage Your Bookings
- Go to **My Bookings** from the side drawer
- View all active and past bookings
- Cancel a booking if needed (subject to cancellation policy)

---

## 📱 App Screens & Flow

```
Splash Screen
      │
      ▼
Welcome / Onboarding ──► Sign In ──► OTP Verification
                              │
                              └──► Sign Up ──► OTP Verification
                                                    │
                                                    ▼
                                             Home Screen
                                             (Categories)
                                                    │
                              ┌─────────────────────┼───────────────────┐
                              ▼                     ▼                   ▼
                       Company List          Side Drawer          Notifications
                              │              │        │
                              ▼              ▼        ▼
                       Company Details  My Bookings  Profile
                              │
                              ▼
                       Booking Screen
                              │
                              ▼
                       Price Estimation
                              │
                              ▼
                       Booking Confirmed
```

---

## 🌍 Supported Languages

| Language | Code | Direction | Font |
|---|---|---|---|
| العربية (Arabic) | `ar` | RTL ← | Cairo |
| English | `en` | LTR → | Montserrat |

You can switch the language from the **Profile** or **Side Drawer** at any time. The selected language is persisted across app restarts.

---

---

## 👨‍💻 For Developers

---

## 🛠 Tech Stack

| Category | Package | Version |
|---|---|---|
| Framework | Flutter | ^3.11.1 SDK |
| State Management | `flutter_bloc` | ^9.1.1 |
| HTTP Client | `dio` | ^5.2.1 |
| Logging | `pretty_dio_logger` | ^1.4.0 |
| Local Storage | `shared_preferences` | ^2.5.4 |
| Localization | `easy_localization` | ^3.0.8 |
| Responsive UI | `flutter_screenutil` | ^5.9.3 |
| Firebase Core | `firebase_core` | ^4.4.0 |
| Push Notifications | `firebase_messaging` | ^16.1.1 |
| Local Notifications | `flutter_local_notifications` | ^17.0.0 |
| Analytics | `firebase_analytics` | ^12.1.1 |
| Maps | `google_maps_flutter` | ^2.14.0 |
| Geolocation | `geolocator` | ^14.0.2 |
| Geocoding | `geocoding` | ^4.0.0 |
| Image Cache | `cached_network_image` | ^3.4.1 |
| File Picker | `file_picker` | ^10.3.7 |
| In-App Browser | `flutter_inappwebview` | ^6.1.5 |
| Animations | `flutter_animate` | ^4.5.2 |
| Calendar | `table_calendar` | ^3.2.0 |
| Rating Bar | `flutter_rating_bar` | ^4.0.1 |
| Carousel | `carousel_slider` | ^5.1.1 |
| SVG | `flutter_svg` | ^2.2.1 |
| Dialogs | `awesome_dialog` | ^3.3.0 |
| Connectivity | `connectivity_plus` | ^7.0.0 |
| Permissions | `permission_handler` | ^12.0.1 |
| Intro Screen | `introduction_screen` | ^4.0.0 |
| URL Launcher | `url_launcher` | ^6.3.2 |
| Drawer | `flutter_slider_drawer` | ^3.0.2 |
| Equatable | `equatable` | ^2.0.7 |

---

## 🏗 Project Architecture

The project follows a **Feature-First Clean Architecture** with a clear separation of concerns using the **BLoC/Cubit** pattern.

```
Presentation Layer  (UI Screens + Widgets)
        │
        ▼
State Management    (Cubit / BLoC)
        │
        ▼
Service Layer       (Business Logic)
        │
        ▼
Data Layer          (API + Local Storage)
```

### Design Principles
- **Feature-first** folder structure — each feature owns its own `cubit/`, `data/`, `presentation/`, and `widget/` folders
- **Singleton services** — `ApiService` and `StorageLocalDataSource` are singletons
- **Global BLoC providers** at root — 18+ Cubits provided via `MultiBlocProvider` in `main.dart`
- **Dependency Injection** via constructor injection in cubits and services
- **Design size:** `390 × 844` (iPhone 14 reference) — all dimensions adapt using `flutter_screenutil`

---

## 📁 Directory Structure

```
dohamaid/
├── lib/
│   ├── main.dart                              # App entry point, Firebase init, BLoC setup
│   ├── firebase_options.dart                  # Firebase platform configuration
│   ├── loader.dart                            # Global loading widget
│   │
│   ├── core/                                  # Shared infrastructure
│   │   ├── config/
│   │   │   ├── app_color.dart                 # Color palette constants
│   │   │   └── app_theme.dart                 # Light & Dark ThemeData
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       ├── api_service.dart           # Dio singleton HTTP client
│   │   │       ├── storage_local_data_source.dart  # SharedPreferences wrapper
│   │   │       └── dynamic_links_service.dart      # ⚠️ Deprecated
│   │   ├── notifications/
│   │   │   └── push_notification_service.dart # FCM + local notifications
│   │   ├── presentation/
│   │   │   └── cubit/
│   │   │       ├── localization_cubit.dart    # AR ↔ EN language switching
│   │   │       ├── theme_cubit.dart           # Dark/Light mode
│   │   │       └── notification/              # Notification routing cubit
│   │   ├── services/                          # API call wrappers per domain
│   │   │   ├── auth_services.dart
│   │   │   ├── booking_services.dart
│   │   │   ├── companies_services.dart
│   │   │   └── home_services.dart
│   │   └── utils/
│   │       ├── api_constant.dart              # All API endpoint paths
│   │       ├── app_constants.dart             # General app constants
│   │       ├── app_route.dart                 # RouteObserver / route tracker
│   │       ├── responsive.dart                # Responsive helpers
│   │       └── validation.dart                # Form field validators
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/                          # auth_model, otp_model, data_model
│   │   │   ├── sign_in/                       # LoginCubit + LoginScreen
│   │   │   ├── sign_up/                       # RegisterCubit + SignUpScreen
│   │   │   └── verification_code/             # VerificationCodeCubit + OTP screen
│   │   │
│   │   ├── home/
│   │   │   ├── cubit/                         # HomeCubit + HomeState
│   │   │   ├── data/model/                    # HomeModel, Datum
│   │   │   ├── presentation/                  # HomeScreen
│   │   │   └── widget/
│   │   │
│   │   ├── companies/
│   │   │   ├── cleaning_companies/            # CleaningCompaniesCubit
│   │   │   ├── nursing_companies/             # NursingCompaniesCubit
│   │   │   ├── anti_bug_companies/            # AntiBugCompaniesCubit
│   │   │   ├── worker_companies/              # WorkerCompaniesCubit
│   │   │   ├── worker_suppliers/              # WorkerSuppliersCubit
│   │   │   ├── company_details/               # CompanyDetailsCubit + detail screen
│   │   │   ├── companies_services/            # Service listing
│   │   │   ├── cleanning_services/            # Cleaning-specific + CleaningServicesCubit
│   │   │   ├── booking_screens/               # BookingCubit + BookingScreen
│   │   │   ├── payment/                       # PaymentCubit + payment screen
│   │   │   ├── location_selection/            # Google Maps location picker
│   │   │   └── widget/                        # Shared company widgets
│   │   │
│   │   ├── bookings/
│   │   │   ├── cubit/                         # Booking list / cancel cubits
│   │   │   ├── data/                          # booking_list_model, booking_cancel_model
│   │   │   └── presentation/                  # BookingListScreen
│   │   │
│   │   ├── profile_screen/
│   │   │   ├── cubit/
│   │   │   ├── data/
│   │   │   └── presentation/                  # ProfileScreen
│   │   │
│   │   ├── drawer/                            # DrawerCubit + side navigation drawer
│   │   ├── splash/                            # SplashCubit + SplashScreen
│   │   ├── welcome/                           # WelcomeCubit + WelcomeScreen (onboarding)
│   │   ├── webview/                           # In-app WebViewContainer
│   │   └── locations/                         # Saved user locations management
│   │
│   ├── res/
│   │   └── assets_res.dart                    # Asset path constants
│   └── widget/
│       └── no_data_widget.dart                # Empty state GIF widget
│
├── assets/
│   ├── logo.png
│   ├── No data.gif
│   ├── icons/                                 # Category icons (1.png – 7.png)
│   ├── lang/                                  # Localization JSON files (ar.json, en.json)
│   ├── arabic-font/                           # Cairo font (9 weights)
│   └── english-font/                          # Montserrat font (9 weights)
│
├── android/                                   # Android-specific configuration
├── ios/                                       # iOS-specific configuration
├── pubspec.yaml                               # Dependencies & assets declaration
└── firebase.json                              # Firebase CLI config
```

---

## 🧠 State Management (Cubits)

All Cubits are registered globally via `MultiBlocProvider` in `main.dart`:

| Cubit | Responsibility |
|---|---|
| `LocalizationCubit` | Language switching (AR/EN), persists to SharedPrefs |
| `ThemeCubit` | Light/Dark mode, persists to SharedPrefs |
| `NotificationCubit` | FCM deep-link routing |
| `SplashCubit` | Splash screen animation & navigation logic |
| `WelcomeCubit` | Welcome/onboarding animation |
| `HomeCubit` | Home categories load + staggered fade/slide animations |
| `LoginCubit` | Login API call, token storage |
| `RegisterCubit` | Registration API call |
| `VerificationCodeCubit` | OTP submission and resend |
| `WorkerCompaniesCubit` | Fetch worker company list |
| `CleaningCompaniesCubit` | Fetch cleaning company list |
| `NursingCompaniesCubit` | Fetch nursing company list |
| `AntiBugCompaniesCubit` | Fetch pest control company list |
| `WorkerSuppliersCubit` | Fetch worker supplier list |
| `CompanyDetailsCubit` | Single company details & services |
| `CleaningServicesCubit` | Cleaning-specific service types |
| `BookingCubit` | Full booking flow state machine |
| `PaymentCubit` | Payment processing |
| `DrawerCubit` | Drawer open/close state |

### Typical State Flow

```
Initial → Loading → Loaded(data)
                └→ Error(message)
```

---

## 🌐 API Reference

**Base URL:** `https://dohamaid.com/api/`

All requests automatically include:
- `Authorization: Bearer <token>` (when logged in)
- `x-locale: ar | en` (current app language)
- `Content-Type: application/json`

### Authentication

| Endpoint | Method | Description | Auth |
|---|---|---|---|
| `register` | POST | Register new user | ❌ |
| `login` | POST | Login with phone + password | ❌ |
| `otp` | POST | Verify OTP code | ❌ |
| `otp/resend` | POST | Resend OTP | ❌ |
| `logout` | GET | Logout and invalidate token | ✅ |
| `user/delete` | GET | Delete account permanently | ✅ |

### User

| Endpoint | Method | Description | Auth |
|---|---|---|---|
| `user` | POST | Get current user profile | ✅ |
| `balance` | GET | Get user wallet balance | ✅ |
| `countries` | GET | Get country dial codes | ❌ |

### Home & Settings

| Endpoint | Method | Description | Auth |
|---|---|---|---|
| `settings` | GET | Home screen configuration | ✅ |
| `/sections/status` | POST | Check section visibility | ✅ |

### Companies

| Endpoint | Method | Company Type |
|---|---|---|
| `companies/1` | GET | Worker companies |
| `companies/2` | GET | Cleaning companies |
| `companies/3` | GET | Anti-bug / pest control |
| `companies/4` | GET | Nursing companies |
| `companies/8` | GET | Worker suppliers |
| `company/{id}` | GET | Single company details |
| `services` | GET | All available services |

### Booking

| Endpoint | Method | Description |
|---|---|---|
| `booking/services` | GET | Available services for booking |
| `booking/hours` | GET | Available time slots |
| `booking/workers` | GET | Available workers |
| `booking/times` | GET | Available booking times |
| `booking/pricing` | POST | Calculate booking price |
| `booking/new` | POST | Create new booking |
| `booking/list` | GET | User booking history |
| `/booking/cancel/status` | POST | Check cancellation eligibility |
| `/booking/cancel` | POST | Cancel a booking |

### Locations

| Endpoint | Method | Description |
|---|---|---|
| `locations` | GET | User's saved locations |

---

## 💾 Local Storage Keys

Managed by `StorageLocalDataSource` (SharedPreferences wrapper):

| Key | Type | Description |
|---|---|---|
| `ACTIVE_LOCALE` | String | Saved language code (`ar` / `en`) |
| `THEME_MODE` | bool | `true` = dark, `false` = light |
| `ONBOARDING_DONE` | bool | Whether onboarding was completed |
| `User_token` | String | Bearer auth token |
| `otp_verification` | bool | OTP verification pending flag |
| `user_phone_number` | String | Phone number during OTP flow |
| `user_country_code` | String | Country dial code during OTP flow |
| `NOTIFICATION_ROUTE` | String | Cached deep-link route from FCM |
| `NOTIFICATION_PAYLOAD` | String | Cached JSON payload from FCM |

---

## 🔔 Notification System

The app uses **Firebase Cloud Messaging (FCM)** for push notifications.

### Flow

```
FCM Server
    │
    ▼
PushNotificationService
(firebase_messaging + flutter_local_notifications)
    │
    ▼
NotificationCubit (state-based route trigger)
    │
    ▼
_handleNotificationNavigation() in main.dart
```

### Deep-Link Routes

Notification data payload must include a `page` key:

| `page` value | Navigates To |
|---|---|
| `home` | `HomeScreen` |
| `profile` | `ProfileScreen` |
| `login` | `LoginScreen` |
| `booking_list` | `BookingListScreen` |
| `web` | `WebViewContainer` (with `url` in payload) |

### Android Notification Channel
- **ID:** `high_importance_channel`
- **Importance:** MAX
- **Sound:** Enabled

---

## 🎨 Theming & Styling

### Brand Colors

| Color | Hex | Usage |
|---|---|---|
| Primary (Teal) | `#0E8982` | App bar, icons, brand elements |
| Secondary (Gold) | `#F4A416` | Accents, highlights, company borders |
| Dark Background | `#121212` | Dark mode scaffold |

### Light vs Dark Theme

| Property | Light | Dark |
|---|---|---|
| Background | `#FFFFFF` | `#121212` |
| Text | `Colors.black87` | `Colors.white70` |
| App Bar | Teal `#0E8982` | Teal `#0E8982` |
| Selected Nav | `#3949AB` (Indigo) | `#90CAF9` (Light Blue) |

### Typography

| Locale | Font | Weights Available |
|---|---|---|
| Arabic (`ar`) | Cairo | 200 · 300 · 400 · 500 · 600 · 700 · 800 · 900 |
| English (`en`) | Montserrat | 200 · 300 · 400 · 500 · 600 · 700 · 800 · 900 |

### Responsive Design
- Base design size: **390 × 844** (iPhone 14)
- Use `flutter_screenutil` extensions: `.w`, `.h`, `.sp`, `.r`

---

## ⚙️ Setup & Running

### Prerequisites

- Flutter SDK `^3.11.1`
- Dart SDK `^3.11.1`
- Android Studio / Xcode
- Firebase project with Android & iOS apps registered
- Google Maps API key

### 1. Clone the Repository

```bash
git clone <repository-url>
cd "doha maid/dohamaid"
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

- Place `google-services.json` → `android/app/`
- Place `GoogleService-Info.plist` → `ios/Runner/`
- `firebase_options.dart` is generated by the FlutterFire CLI

### 4. Google Maps Setup

**Android** — in `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

**iOS** — in `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 5. Run the App

```bash
# Debug
flutter run

# Release APK (Android)
flutter build apk --release

# Release (iOS)
flutter build ios --release
```

---

## 🔧 Environment & Configuration

All API endpoints are centralized in `lib/core/utils/api_constant.dart`.

> **To point to a staging server**, change `ApiConstant.baseUrl`.

### HTTP Client (`ApiService`)

| Setting | Value |
|---|---|
| Connect Timeout | 15 seconds |
| Receive Timeout | 15 seconds |
| Auto Retry | On connection errors and timeouts |
| Logging | Debug builds only (`PrettyDioLogger`) |

### Form Validation (`Validation` class)

| Field | Rules |
|---|---|
| Email | Required + valid email format |
| Password | Required + minimum 6 characters |
| Phone | Required + 7–15 digits, optional `+` prefix |
| Name | Required + minimum 2 characters |

---

## ⚠️ Known Issues & TODOs

### 🔴 Critical

- **Firebase Dynamic Links is deprecated** — `dynamic_links_service.dart` relies on Firebase Dynamic Links which was **shut down on August 25, 2025**. This must be replaced with a custom deep-link solution (e.g., `app_links` package).

### 🟡 Warnings

- **Inconsistent API paths** — Some constants in `ApiConstant` have a leading `/` (e.g., `/booking/cancel`) while others don't. This causes double-slash URLs with Dio's base URL. All paths should be standardized without a leading slash.

- **Empty file** — `lib/features/companies/booking_screens/data/service_option.dart` is 1 byte (empty). Populate or remove it.

- **Eager-loaded global Cubits** — `SplashCubit` and `WelcomeCubit` are only needed briefly. They should be locally scoped or lazy-provided instead of staying alive for the app's full lifecycle.

### 🟢 Future Improvements

- [ ] Add unit tests for all Cubits and Service classes
- [ ] Add widget tests for critical UI screens
- [ ] Add integration tests for the full booking flow
- [ ] Replace Firebase Dynamic Links with a modern deep-link package
- [ ] Standardize all `ApiConstant` paths (remove leading slashes)
- [ ] Remove or implement `service_option.dart`
- [ ] Lazy-load non-global Cubits (`SplashCubit`, `WelcomeCubit`)
- [ ] Add a global error handling / error boundary widget

---

## 📄 License

This project is private and not intended for public distribution.

---

<div align="center">
  Built with ❤️ using Flutter  |  Powered by Firebase
  <br/>
  <strong>Doha Maid — الخادم</strong>  |  Version 1.6.0
</div>
