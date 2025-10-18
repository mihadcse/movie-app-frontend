# How to Apply Bangla Language to All Pages

## Overview
This guide explains how to use the localization system throughout the CineMatch app to display text in English or Bangla based on user preference.

## Quick Start

### 1. Import Required Files
In any page where you want to use translations, add these imports:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';
```

### 2. Watch the Localization Provider
In your widget's `build` method:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final localizations = ref.watch(localizationProvider);
  
  // Now use localizations.anyString
  return Text(localizations.appName); // Will show "CineMatch" or "সিনেম্যাচ"
}
```

### 3. Replace Hardcoded Strings
Replace all hardcoded English strings with localization calls:

**Before:**
```dart
Text('Home')
```

**After:**
```dart
Text(localizations.home)
```

## Example: Profile Page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = ref.watch(localizationProvider);
    
    return ListView(
      children: [
        // Account Settings - Translates automatically
        _buildMenuItem(
          icon: Icons.settings_outlined,
          label: localizations.accountSettings,  // "Account Settings" or "অ্যাকাউন্ট সেটিংস"
          onTap: () => context.go('/settings'),
        ),
        
        // My Ratings
        _buildMenuItem(
          icon: Icons.star_outline,
          label: localizations.myRatings,  // "My Ratings" or "আমার রেটিংস"
          onTap: () => context.go('/my-ratings'),
        ),
        
        // Logout Button
        ElevatedButton(
          onPressed: _logout,
          child: Text(localizations.logout),  // "Logout" or "লগআউট"
        ),
      ],
    );
  }
}
```

## Example: Home Page Bottom Navigation

```dart
import '../providers/language_provider.dart';

class MainShell extends ConsumerStatefulWidget {
  // ...
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = ref.watch(localizationProvider);
    
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: localizations.home,  // "Home" or "হোম"
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            label: localizations.searchTab,  // "Search" or "খুঁজুন"
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            label: localizations.watchlist,  // "Watchlist" or "ওয়াচলিস্ট"
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: localizations.profile,  // "Profile" or "প্রোফাইল"
          ),
        ],
      ),
    );
  }
}
```

## Example: Login Page

```dart
import '../providers/language_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  // ...
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = ref.watch(localizationProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // App Name
          Text(localizations.appName),  // "CineMatch" or "সিনেম্যাচ"
          
          // Welcome Message
          Text(localizations.welcomeBack),  // English or Bangla welcome
          
          // Email Field
          TextFormField(
            decoration: InputDecoration(
              labelText: localizations.email,  // "Email" or "ইমেইল"
              hintText: localizations.enterEmail,  // "Enter your email" or "আপনার ইমেইল লিখুন"
            ),
          ),
          
          // Password Field
          TextFormField(
            decoration: InputDecoration(
              labelText: localizations.password,  // "Password" or "পাসওয়ার্ড"
              hintText: localizations.enterPassword,
            ),
          ),
          
          // Sign In Button
          ElevatedButton(
            onPressed: _login,
            child: Text(localizations.signIn),  // "Sign In" or "সাইন ইন"
          ),
          
          // Don't have account
          Row(
            children: [
              Text(localizations.dontHaveAccount),  // "Don't have an account?" or "কোন অ্যাকাউন্ট নেই?"
              TextButton(
                onPressed: _navigateToRegister,
                child: Text(localizations.signUp),  // "Sign Up" or "সাইন আপ"
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Available Translations

All available strings are in `lib/utils/app_localizations.dart`:

- **Common**: appName, loading, error, success, cancel, ok, save, delete, edit, search, filter, sort
- **Navigation**: home, searchTab, watchlist, profile
- **Login**: welcomeBack, signIn, email, password, forgotPassword, etc.
- **Register**: joinCineMatch, createAccount, fullName, confirmPassword, etc.
- **Home**: popularMovies, trendingNow, newReleases, watchNow, etc.
- **Search**: searchMovies, recentSearches, noResultsFound, etc.
- **Watchlist**: myWatchlist, toWatch, watching, watched, etc.
- **Profile**: accountSettings, geminiAIChat, myRatings, moodDiscovery, darkMode, logout
- **Settings**: language, currentLanguage, languageChanged, etc.
- **Movie Details**: cast, director, duration, releaseDate, overview, rateThisMovie, etc.
- **Chat**: askMeAnything, send, geminiAI, yourMovieCompanion
- **Mood**: howAreYouFeeling, selectYourMood, aiPoweredRecommendations
- **Genres**: action, comedy, drama, horror, romance, thriller, sciFi, fantasy

## Pages That Need Localization

### Priority 1 (Core Navigation):
1. ✅ **Settings Page** - Already done
2. **Router (MainShell)** - Bottom navigation labels
3. **Profile Page** - Menu items
4. **Login Page** - All text
5. **Register Page** - All text

### Priority 2 (Main Features):
6. **Home Page** - Section headers, buttons
7. **Search Page** - Placeholder, labels
8. **Watchlist Page** - Tab labels, empty state
9. **Movie Details** - Labels and buttons
10. **My Ratings Page** - Headers and labels

### Priority 3 (Secondary Features):
11. **Chat Page** - Placeholder, labels
12. **Mood Discovery** - Headers and descriptions
13. **Splash Screen** - Buttons

## Implementation Checklist

For each page, follow these steps:

1. [ ] Convert to `ConsumerWidget` or `ConsumerStatefulWidget` if not already
2. [ ] Add import: `import '../providers/language_provider.dart';`
3. [ ] Add in build method: `final localizations = ref.watch(localizationProvider);`
4. [ ] Find all hardcoded English strings
5. [ ] Replace with `localizations.stringName`
6. [ ] Test in English mode
7. [ ] Test in Bangla mode
8. [ ] Verify layout works with longer/shorter text

## Tips

### 1. ConsumerWidget vs Consumer
- Use `ConsumerWidget` for simple widgets
- Use `ConsumerStatefulWidget` for stateful widgets
- Use `Consumer` widget inside non-Consumer widgets

### 2. Adding New Translations
To add a new translatable string:

1. Open `lib/utils/app_localizations.dart`
2. Add a new getter:
```dart
String get myNewString => languageCode == 'bn' ? 'বাংলা টেক্সট' : 'English Text';
```

### 3. Dynamic Text
For text with variables:
```dart
Text('${localizations.currentLanguage}: ${language.displayName}')
```

### 4. Validation Messages
Validation messages can also be localized:
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return localizations.pleaseEnterEmail;
  }
  return null;
}
```

### 5. SnackBar Messages
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(localizations.loginSuccessful),
  ),
);
```

## Testing

### Test Language Switching:
1. Open the app
2. Go to Profile → Account Settings
3. Select Bangla (বাংলা)
4. Navigate to different pages
5. Verify all text is in Bangla
6. Switch back to English
7. Verify all text is in English

### Test Edge Cases:
- Long Bangla text in small containers
- Text overflow in buttons
- Layout adjustments for different text lengths
- RTL support if needed

## Current Status

✅ **Completed:**
- Settings Page - Fully localized
- Localization system setup
- Language provider with English and Bangla
- 100+ translated strings ready to use

⏳ **In Progress:**
- Need to apply to remaining pages

## Next Steps

1. Update Router/MainShell for bottom navigation labels
2. Update Profile Page menu items
3. Update Login and Register pages
4. Update Home, Search, Watchlist pages
5. Update Movie Details and My Ratings pages
6. Update Chat and Mood Discovery pages
7. Test thoroughly in both languages
8. Add persistent storage (SharedPreferences)

## Notes

- Language selection is currently stored in memory only
- For production, add SharedPreferences to persist choice
- All Bangla translations are standard Bengali (বাংলা)
- Unicode properly supported for Bengali script
- Font rendering works correctly in Flutter Web
