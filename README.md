# Project Kisan

A comprehensive Flutter app designed to empower farmers with digital tools for crop management, market insights, and access to government subsidies.

## 🌱 Features

### Core Functionality
- **Crop Disease Diagnosis**: AI-powered image analysis for crop disease detection
- **Market Prices**: Real-time market price updates with filtering and search
- **Government Subsidies**: Information about available schemes and application processes
- **Multi-language Support**: English and Kannada localization
- **Offline Support**: Limited functionality available without internet connection

### User Experience
- **Intuitive Onboarding**: Step-by-step introduction to app features
- **Responsive Design**: Optimized for various screen sizes
- **Accessibility**: High contrast, large tap areas, and clear navigation
- **Modern UI**: Clean design with consistent branding

### Technical Features
- **Clean Architecture**: Organized codebase with proper separation of concerns
- **State Management**: Provider pattern for efficient state handling
- **Local Storage**: Persistent data storage for user preferences
- **Mock Data**: Comprehensive mock data for development and testing

## 🏗️ Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart
│   ├── crop_price.dart
│   ├── crop_diagnosis.dart
│   └── government_subsidy.dart
├── providers/                # State management
│   ├── app_state_provider.dart
│   ├── localization_provider.dart
│   └── theme_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── crop_diagnosis_screen.dart
│   ├── market_prices_screen.dart
│   ├── subsidies_screen.dart
│   ├── profile_screen.dart
│   ├── help_screen.dart
│   ├── settings_screen.dart
│   └── offline_screen.dart
├── widgets/                  # Reusable UI components
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── custom_card.dart
│   └── common_widgets.dart
├── utils/                    # Utilities and constants
│   ├── app_colors.dart
│   ├── app_theme.dart
│   ├── app_localization.dart
│   └── mock_data.dart
└── assets/                   # Static assets
    ├── images/
    ├── icons/
    ├── fonts/
    └── localization/
```

## 🎨 Design System

### Colors
- **Primary**: #2D7A46 (Green)
- **Accent**: #F8B133 (Orange)
- **Background**: #F2F7F1 (Light Green)
- **Success**: #38A169
- **Error**: #E53E3E
- **Warning**: #D69E2E

### Typography
- **Font Family**: Poppins
- **Sizes**: H1 (28px), H2 (24px), H3 (20px), H4 (18px), Body (16px/14px)
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Spacing
- **XS**: 4px
- **SM**: 8px
- **MD**: 16px
- **LG**: 24px
- **XL**: 32px
- **XXL**: 48px

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/project-kisan.git
cd project-kisan
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Development Setup

1. **Code Generation** (if needed)
```bash
flutter packages pub run build_runner build
```

2. **Localization** (if adding new languages)
```bash
flutter gen-l10n
```

3. **Testing**
```bash
flutter test
```

## 📱 Features in Detail

### 1. Crop Disease Diagnosis
- Camera integration for image capture
- Gallery selection for existing images
- Mock AI analysis with confidence scores
- Treatment and prevention recommendations
- Diagnosis history tracking

### 2. Market Prices
- Real-time price updates (mocked)
- Category-based filtering (Vegetables, Fruits, Grains)
- Search functionality
- Price trend indicators
- Market location information

### 3. Government Subsidies
- Comprehensive scheme information
- Eligibility criteria and required documents
- Application process guidance
- Deadline tracking with alerts
- Contact information for support

### 4. User Profile
- Personal information management
- Language preference settings
- Login/logout functionality
- Data persistence

### 5. Help & Support
- FAQ section with common questions
- Tutorial videos (placeholder)
- Contact support options
- Issue reporting system

## 🌐 Localization

The app supports multiple languages:
- **English** (default)
- **Kannada** (ಕನ್ನಡ)

Translation files are located in `assets/localization/`:
- `en.json` - English translations
- `kn.json` - Kannada translations

## 🔄 State Management

The app uses the Provider pattern for state management:

- **AppStateProvider**: Manages authentication, user data, and app-wide state
- **LocalizationProvider**: Handles language switching and locale management
- **ThemeProvider**: Manages theme preferences (light/dark mode)

## 💾 Data Storage

- **SharedPreferences**: User preferences, settings, and simple data
- **Local Storage**: Offline data caching and user information
- **Mock Data**: Comprehensive mock data for all features

## 🎯 Accessibility Features

- **Minimum Touch Targets**: 48x48 pixels for all interactive elements
- **High Contrast**: Colors meet WCAG accessibility standards
- **Clear Navigation**: Intuitive navigation patterns
- **Text Scaling**: Support for system font size preferences
- **Screen Reader Support**: Semantic labels and descriptions

## 📊 Mock Data

The app includes comprehensive mock data for:
- Crop prices with market information
- Government subsidy schemes
- Crop diagnosis results
- User profiles and preferences
- FAQ and tutorial content

## 🔧 Configuration

### Environment Variables
- API endpoints (for future backend integration)
- Feature flags
- Debug settings

### Build Configuration
- Android: `android/app/build.gradle`
- iOS: `ios/Runner.xcodeproj`

## 🚀 Future Enhancements

### Backend Integration
- Real-time crop disease detection API
- Live market price feeds
- Government subsidy database
- User authentication system

### AI Features
- Enhanced crop disease recognition
- Pest identification
- Crop yield prediction
- Weather integration

### Advanced Features
- Push notifications
- Social features for farmers
- Marketplace integration
- Expert consultation booking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Provider package for state management
- All contributors and supporters of the project

## 📞 Support

For support, email bhargavadepu@outlook.com or create an issue in the GitHub repository.

---

**Project Kisan** - Empowering farmers through digital innovation 🌾
