# 🏙️ CityAlert (Smart City)

> A Flutter-based citizen reporting mobile application designed to connect citizens with city services. Developed as an end-of-semester project at ESTSB, this application replicates a provided Figma prototype pixel-for-pixel, offering a complete UI flow in both Light and Dark themes.

## ✨ Features

* **Interactive Map:** Google Maps integration with custom markers, location tracking, and category filters.
* **Report Generation:** Camera and gallery integration to capture issues, attach GPS coordinates, and categorize reports (e.g., Roads, Lighting, Cleanliness).
* **User Dashboard ("Mon espace"):** Track report statuses (Reported, In Progress, Resolved) and view submission history.
* **Dynamic Theming:** Seamless system-synced Light and Dark mode using Material 3, mapping exactly to Figma's color tokens.
* **Community Engagement:** Upvote issues, read official responses, and interact via the comments section.
* **Settings & Profile:** Manage app preferences (theme, notification toggles, proximity radius) with persistent state handling.

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.24 or newer recommended)
* An Android device or emulator (A physical device is required to test the camera functionality)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/cityalert.git
   cd cityalert
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### 🗺️ Google Maps Setup (Required)
The Map screen requires a valid Google Maps API key to function (otherwise, it will display a gray grid).

1. Go to the **Google Cloud Console**, create a project, and enable the **Maps SDK for Android**.
2. Generate an API Key (ensure billing is enabled; development usage falls under the free tier).
3. Open `android/app/src/main/AndroidManifest.xml` and add your key inside the `<application>` tag:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY_HERE"/>
   ```
   *(Note: Never commit your actual API key to GitHub. Restrict it using your package name and SHA-1 footprint in the Cloud Console).*

### 🔒 Permissions
The app requires permissions for Internet, Camera, and GPS. These are already configured in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## 📂 Project Architecture

```text
lib/
 ├── main.dart                       # Entry point, Theme configuration
 ├── core/
 │   ├── theme/                      # Figma design tokens (Colors, Typography, Elevation)
 │   ├── models/                     # Data models (Report, ReportStatus, Category)
 │   ├── data/                       # Repositories (Mock data / Firebase ready)
 │   └── utils/                      # Helpers (e.g., relative date formatting)
 ├── shared/widgets/                 # Reusable UI components (Cards, Badges, Buttons)
 └── features/
     ├── onboarding/                 # 3-slide introduction
     ├── home/                       # App shell and Bottom Navigation
     ├── map/                        # Google Maps, custom markers, and search
     ├── new_report/                 # Reporting form & Camera plugin logic
     └── my_area/                    # User dashboard and history
```

## 🎨 Design System: Figma to Flutter

The application implements a strict design system based on the Figma prototype:

| Figma Component | Flutter Implementation |
| :--- | :--- |
| Color Styles (`CityAlert/Light/*`, `Dark/*`) | `CityAlertColors.light` / `.dark` |
| Text Styles (`Display` → `Caption strong`) | `AppText.display` ... `captionStrong` |
| Effect (`Elevation 1`: Y1, Blur 3, Black 8%) | `AppShadows.elevation1` |
| White Cards (12px Radius + Shadow) | `SurfaceCard` |
| Status Badge | `StatusBadge` |
| Report List Item | `ReportCard` |
| Empty / Loading States | `EmptyStateCard` / `SkeletonCard` |
| Bottom Navigation (72px) | `CityBottomNav` |
| Map Markers (40×44) & Filters | `MarkerIconFactory`, `MapFilterChips` |
| Primary / Secondary Buttons | `CityButton`, `CityButton(style: secondary)` |

### Development Notes & UI Deductions
* **Missing Figma States Handled:** Designed dynamic states for selected filter chips, camera capture flows (retake/gallery), loading buttons, error handling, and disabled text fields.
* **Bottom Navigation:** Unified the navigation bar styling across both the Map and Dashboard tabs using the primary active indicator (`#E6F7F5`), correcting an inconsistency found in the original design files.
* **Custom Toasts:** Standard Material SnackBars were replaced with `CityToast` to match the custom floating notifications designed in Figma.
* **Map Markers:** Replicated the exact 36×40 teardrop shape with a 3px border dynamically drawn over the Google Maps canvas.

## 🔜 Roadmap

- [ ] **Firebase Integration:** Swap `MockReportsRepository` with a new `FirestoreReportsRepository` to handle real-time data syncing.
- [ ] **Authentication:** Implement Firebase Auth for the "Edit Profile" and Login flows.
- [ ] **Advanced Location:** Enable the "Edit Location" map picker feature for new reports.
