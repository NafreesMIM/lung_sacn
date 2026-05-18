# LungScan+ - Lung Cancer Risk Assessment Application

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com)

## Table of Contents

- [Project Description](#project-description)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing Guidelines](#contributing-guidelines)
- [License](#license)
- [Troubleshooting](#troubleshooting)
- [Contact Information](#contact-information)

## Project Description

**LungScan+** is a comprehensive mobile application designed to assess lung cancer risk and provide users with personalized health insights. The application leverages machine learning technologies and real-time data integration to deliver accurate risk assessments based on user health metrics and lifestyle factors.

### Purpose & Scope
- Provide preliminary lung cancer risk assessments using a trained TensorFlow Lite logistic regression model
- Enable secure user authentication and personal health data management
- Facilitate access to nearby medical facilities and healthcare resources
- Allow users to share assessment results with healthcare providers
- Support cross-platform deployment (Android, iOS, Web, Linux, macOS, Windows)

### Value Proposition
- **Non-invasive screening tool**: Quick and accessible risk assessment for users
- **Data security**: Firebase-backed authentication and encrypted data storage
- **Machine learning integration**: Advanced predictive model for accurate risk estimation
- **Location-aware services**: Find nearby healthcare facilities based on user location
- **User-friendly interface**: Intuitive design following Material Design principles

---

## Features

### Core Functionality
- 🔐 **User Authentication**: Secure Firebase authentication system with email/password support
- 🧠 **AI-Powered Risk Assessment**: TensorFlow Lite ML model for lung cancer risk prediction
- 📊 **Health Data Management**: Store and retrieve user health metrics in Firestore
- 📍 **Location Services**: Google Maps integration to locate nearby medical facilities
- 📤 **Data Sharing**: Share assessment results with contacts or healthcare providers
- ⚙️ **Settings Screen**: Customizable user preferences and account management

### Technical Capabilities
- Multi-platform support (Android, iOS, Web, Desktop)
- Real-time data synchronization with Firestore
- Offline-first ML inference using on-device model
- RESTful API integration for external services
- Material Design UI with responsive layouts

---

## Installation

### Prerequisites
- **Flutter SDK**: Version 3.7.0 or higher ([Download](https://flutter.dev/docs/get-started/install))
- **Dart SDK**: Included with Flutter
- **Android**: Android Studio with SDK 21+
- **iOS**: Xcode 14+ (macOS only)
- **Firebase Account**: Create one at [Firebase Console](https://console.firebase.google.com)
- **Git**: For version control ([Download](https://git-scm.com))

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/lung_scan_new.git
cd lung_scan_new
```

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

### Step 3: Configure Firebase

1. **Create a Firebase Project**:
   - Visit [Firebase Console](https://console.firebase.google.com)
   - Click "Add Project" and follow the setup wizard

2. **Add Android App**:
   - In Firebase Console, select your project → Settings ⚙️
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`

3. **Add iOS App** (if developing for iOS):
   - Download `GoogleService-Info.plist`
   - Add to Xcode: Project Navigator → Runner → Add Files

4. **Enable Firebase Services**:
   - Enable Authentication (Email/Password)
   - Enable Cloud Firestore
   - Set Firestore rules for security

### Step 4: Configure API Keys

Update the following in your codebase:
- **Google Maps API Key**: Required for location services
- **Firebase Web Config**: For web platform deployment

### Step 5: Run the Application

**For Android**:
```bash
flutter run -d android
```

**For iOS** (macOS only):
```bash
flutter run -d ios
```

**For Web**:
```bash
flutter run -d chrome
```

**For Desktop (Windows/Linux/macOS)**:
```bash
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

---

## Usage

### Getting Started

1. **Launch the Application**
   - Run the app using the commands above
   - You'll be directed to the login/authentication screen

2. **Create an Account**
   - Tap "Sign Up" or "Register"
   - Enter your email and password
   - Verify your email address

3. **Access the Home Screen**
   - After login, you'll see the main dashboard
   - Navigate through different sections using the bottom navigation or drawer menu

### Performing a Risk Assessment

1. **Enter Health Information**
   - Fill in required health metrics (age, smoking status, family history, etc.)
   - Provide accurate information for better predictions

2. **Run the Assessment**
   - Tap the "Assess Risk" button
   - The ML model processes your data locally
   - View your personalized risk score and recommendations

3. **Review Results**
   - Analyze the detailed report with risk factors
   - See personalized health recommendations
   - Understand the key contributors to your risk score

### Finding Healthcare Facilities

1. **Open Location Services**
   - Navigate to "Nearby Facilities" section
   - Grant location permissions when prompted

2. **View Nearby Hospitals & Clinics**
   - Map displays nearby medical facilities
   - Tap facilities for contact information and directions
   - Call or visit directly from the app

### Sharing Results

1. **Select Assessment**
   - Open a previous assessment result

2. **Share**
   - Tap the "Share" button
   - Choose sharing method (email, messaging, etc.)
   - Send to healthcare providers or family members

### Account Management

1. **Access Settings**
   - Tap the settings icon
   - Update profile information
   - Manage notification preferences
   - Review privacy settings
   - Sign out when finished

---

## Dependencies

Key packages used in this project:

```yaml
# Firebase & Backend
firebase_core: ^3.15.1
firebase_auth: ^5.6.2
cloud_firestore: ^5.6.11

# Machine Learning
tflite_flutter: ^0.11.0

# Location & Maps
geolocator: ^14.0.2
google_maps_flutter: ^2.2.3

# UI & Utilities
share_plus: ^11.0.0
url_launcher: ^6.2.1
intl: ^0.20.2

# File Handling
path_provider: ^2.1.1
```

---

## Project Structure

```
lung_scan_new/
├── lib/
│   ├── main.dart                      # Application entry point
│   ├── screens/
│   │   └── settings_screen.dart       # User settings & preferences
│   └── ...                            # Additional screens & widgets
├── assets/
│   ├── images/                        # App images and icons
│   └── model/
│       ├── logistic_regression_model.tflite  # ML model
│       └── preprocessing_info.json            # Model preprocessing config
├── android/                           # Android-specific code
├── ios/                               # iOS-specific code
├── web/                               # Web platform files
├── linux/                             # Linux desktop support
├── macos/                             # macOS desktop support
├── windows/                           # Windows desktop support
├── test/                              # Unit and widget tests
└── pubspec.yaml                       # Flutter dependencies
```

---

## Contributing Guidelines

We welcome contributions from the community! Whether you're fixing bugs, adding features, or improving documentation, your help is appreciated.

### Getting Started with Contributing

1. **Fork the Repository**
   ```bash
   # Click "Fork" button on GitHub
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/NafreesMIM/lung_scan.git
   cd lung_scan_new
   ```

3. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or for bug fixes:
   git checkout -b bugfix/issue-description
   ```

### Code Standards

- **Dart Style Guide**: Follow [Dart conventions](https://dart.dev/guides/language/effective-dart)
- **Flutter Best Practices**: Adhere to [Flutter best practices](https://flutter.dev/docs/testing/best-practices)
- **Naming Conventions**:
  - Classes: `PascalCase` (e.g., `LoginScreen`)
  - Methods/variables: `camelCase` (e.g., `fetchUserData()`)
  - Constants: `camelCase` with `const` keyword
- **Code Organization**:
  - Keep files under 300 lines
  - Separate concerns into different files
  - Use meaningful variable and function names
- **Comments**: Add comments for complex logic; use English
- **Formatting**: Run `flutter format lib/` before committing

### Making Changes

1. **Create Meaningful Commits**
   ```bash
   git add .
   git commit -m "feat: add new risk factor analysis feature"
   # or
   git commit -m "fix: resolve Firebase initialization issue"
   ```

2. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   ```

3. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Provide a clear description of your changes
   - Reference any related issues (e.g., "Fixes #123")

### Commit Message Format

Use the following format for commit messages:

```
<type>(<scope>): <subject>

<body>

<footer>
```

- **type**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **scope**: `auth`, `ml`, `ui`, `firebase`, etc.
- **subject**: Brief, imperative description (max 50 chars)

**Example**:
```
feat(ml): implement new preprocessing pipeline for health data
fix(auth): correct Firebase token refresh logic
```

### Reporting Issues

- Use GitHub Issues for bug reports and feature requests
- Provide clear descriptions, steps to reproduce, and expected behavior
- Include screenshots or logs when relevant
- Check existing issues to avoid duplicates

### Review Process

- Maintainers will review your PR within 3-5 business days
- Be open to feedback and suggestions
- Make requested changes in a timely manner
- Once approved, your PR will be merged!

---

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### MIT License Summary
- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ⚠️ Liability (not provided)
- ⚠️ Warranty (not provided)

**Please include the license header** in any modified files:

```dart
// Copyright (c) 2026 LungScan+ Contributors
// Licensed under the MIT License. See LICENSE file in the project root.
```

---

## Troubleshooting

### Common Issues

#### 1. **"Android SDK not found"**
```bash
# Solution: Set ANDROID_HOME environment variable
# Windows:
set ANDROID_HOME=C:\Users\YourUsername\AppData\Local\Android\sdk
# Linux/macOS:
export ANDROID_HOME=~/Android/Sdk
flutter doctor
```

#### 2. **Firebase Initialization Error**
- Verify `google-services.json` is in `android/app/`
- Check Firebase project configuration matches your app
- Ensure Firebase APIs are enabled in Firebase Console

#### 3. **TensorFlow Lite Model Not Found**
```bash
# Verify model file exists
ls assets/model/logistic_regression_model.tflite

# Check pubspec.yaml has correct asset paths
# Rebuild and run
flutter clean
flutter pub get
flutter run
```

#### 4. **Google Maps API Key Missing**
- Obtain API key from [Google Cloud Console](https://console.cloud.google.com)
- Add to `android/app/src/main/AndroidManifest.xml`
- Add to iOS Info.plist for iOS development

#### 5. **Dependency Version Conflicts**
```bash
# Update dependencies to compatible versions
flutter pub upgrade
# or resolve specific conflicts
flutter pub get --no-offline
```

#### 6. **Location Permission Denied**
- Grant location permissions in app settings
- For Android: Check `android/app/src/main/AndroidManifest.xml`
- For iOS: Update `ios/Runner/Info.plist` with location usage description

### Enable Debug Logs

```dart
// Add this in main.dart to see detailed logs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable Firebase debug logging
  if (kDebugMode) {
    FirebaseAuth.instance.setLanguageCode('en');
  }
  
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

### Getting Additional Help

- Check [Flutter Documentation](https://flutter.dev/docs)
- Review [Firebase Docs](https://firebase.google.com/docs)
- Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

## Contact Information

### Get Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/yourusername/lung_scan_new/issues)
- **Discussions**: [Community Q&A](https://github.com/yourusername/lung_scan_new/discussions)
- **Email Support**: support@lungscan.app
- **Documentation**: [Wiki & Guides](https://github.com/yourusername/lung_scan_new/wiki)

### Connect with Us

- **Twitter**: [@LungScanApp](https://twitter.com/lungscanapp)
- **LinkedIn**: [LungScan+ Team](https://linkedin.com/company/lungscan)
- **Website**: [www.lungscan.app](https://www.lungscan.app)
- **Blog**: [Latest Updates](https://blog.lungscan.app)

### Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

---

## Additional Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [TensorFlow Lite Guide](https://www.tensorflow.org/lite/guide)
- [Material Design Guidelines](https://material.io/design)

### Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Powered by [Firebase](https://firebase.google.com)
- ML Model powered by [TensorFlow Lite](https://www.tensorflow.org/lite)
- Maps integration using [Google Maps](https://maps.google.com)

---

## Changelog

### Version 1.0.0 (Initial Release)
- User authentication with Firebase
- Lung cancer risk assessment using ML model
- Firestore database integration
- Location services and nearby facilities search
- Result sharing capabilities
- Settings and profile management

---

**Last Updated**: May 7, 2026

For more information, visit our [GitHub Repository](https://github.com/yourusername/lung_scan_new).
