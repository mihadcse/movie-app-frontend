# Language Settings Implementation

## Overview
Added a settings page with language selection functionality that allows users to switch between English and Bangla (Bengali) languages.

## Features Implemented

### 1. Settings Page (`lib/screens/settings_page.dart`)
- **Location**: Account Settings accessible from Profile page
- **Languages Supported**:
  - English (🇬🇧) - Default language
  - Bangla/Bengali (🇧🇩) - বাংলা

### 2. Language Provider
- **Provider**: `languageProvider` using Riverpod StateNotifier
- **Enum**: `Language` with two options:
  - `Language.english` - Display: "English", Code: "en"
  - `Language.bangla` - Display: "বাংলা", Code: "bn"

### 3. UI Components

#### Language Selection Cards
- Radio buttons with visual indicators
- Flag emojis for each language (🇬🇧 for English, 🇧🇩 for Bangla)
- Highlighted background when selected
- Bold text for active language

#### Current Language Info Card
- Shows selected language in a highlighted card
- Displays message in the selected language:
  - English: "Current language: English"
  - Bangla: "বর্তমান ভাষা: বাংলা"

#### Feedback
- Snackbar notification when language changes:
  - English: "Language changed to English"
  - Bangla: "ভাষা বাংলায় পরিবর্তিত হয়েছে"

### 4. Navigation

**Profile Page → Settings Page**
- Menu item: "Account Settings"
- Icon: `Icons.settings_outlined`
- Route: `/settings`

**Settings Page Navigation**
- Back button returns to Profile page
- Uses gradient background consistent with app theme

## Code Structure

### Language Provider
```dart
enum Language {
  english('English', 'en'),
  bangla('বাংলা', 'bn');
}

class LanguageNotifier extends StateNotifier<Language> {
  LanguageNotifier() : super(Language.english);
  
  void setLanguage(Language language) {
    state = language;
  }
}
```

### Usage in App
```dart
// Watch current language
final currentLanguage = ref.watch(languageProvider);

// Change language
ref.read(languageProvider.notifier).setLanguage(Language.bangla);
```

## Router Configuration

Added to `lib/router.dart`:
```dart
GoRoute(
  path: '/settings',
  name: 'settings',
  builder: (context, state) => const SettingsPage(),
)
```

## Future Enhancements

### 1. Persistent Storage
Currently, the language preference is stored in memory. Future implementation should include:
- SharedPreferences to persist language selection
- Load saved language on app start

```dart
// TODO: Implement in LanguageNotifier
void setLanguage(Language language) async {
  state = language;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', language.code);
}
```

### 2. Full Localization
To implement complete app localization:

1. **Add flutter_localizations**:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
```

2. **Create ARB files**:
- `lib/l10n/app_en.arb` (English)
- `lib/l10n/app_bn.arb` (Bangla)

3. **Configure in pubspec.yaml**:
```yaml
flutter:
  generate: true
```

4. **Update MaterialApp**:
```dart
MaterialApp(
  locale: Locale(currentLanguage.code),
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'),
    Locale('bn'),
  ],
  // ...
)
```

### 3. Additional Languages
Easy to extend:
```dart
enum Language {
  english('English', 'en'),
  bangla('বাংলা', 'bn'),
  hindi('हिंदी', 'hi'),
  urdu('اردو', 'ur'),
  // Add more languages...
}
```

## Design Features

### Visual Design
- ✅ Gradient background (consistent with app theme)
- ✅ Material 3 design components
- ✅ Card-based layout
- ✅ Clear visual hierarchy
- ✅ Responsive touch targets

### User Experience
- ✅ Immediate feedback on language change
- ✅ Visual confirmation of selected language
- ✅ Easy navigation (back button)
- ✅ Clear labeling with native script
- ✅ Accessible with proper contrast

### Accessibility
- ✅ Radio buttons for single selection
- ✅ Large touch targets
- ✅ Clear icons and labels
- ✅ Proper color contrast
- ✅ Semantic navigation

## Testing Checklist

- [x] Settings page accessible from Profile
- [x] English language selection works
- [x] Bangla language selection works
- [x] Selected language is highlighted
- [x] Snackbar shows on language change
- [x] Current language info card updates
- [x] Back navigation works correctly
- [x] Gradient background displays properly
- [ ] Language persists after app restart (TODO)
- [ ] Full app localization (TODO)

## Files Modified/Created

**Created:**
- `lib/screens/settings_page.dart` - Settings page with language selection

**Modified:**
- `lib/router.dart` - Added `/settings` route
- `lib/screens/profile_page.dart` - Added navigation to settings

**Dependencies:**
- No new dependencies required
- Uses existing Riverpod for state management

## Usage Instructions

1. Open the app and navigate to Profile page
2. Tap on "Account Settings"
3. Select your preferred language (English or বাংলা)
4. Language preference is immediately applied
5. Confirmation message appears in selected language

## Notes

- Language provider is global and can be accessed from any widget
- Current implementation stores language in memory only
- For production, implement persistent storage with SharedPreferences
- Ready for full localization with flutter_localizations
