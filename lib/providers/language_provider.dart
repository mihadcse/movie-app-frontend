import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_localizations.dart';

// Language enum
enum Language {
  english('English', 'en'),
  bangla('বাংলা', 'bn');

  final String displayName;
  final String code;
  const Language(this.displayName, this.code);
}

// Language Notifier
class LanguageNotifier extends StateNotifier<Language> {
  LanguageNotifier() : super(Language.english);

  void setLanguage(Language language) {
    state = language;
    // TODO: Implement actual localization storage (SharedPreferences)
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, Language>((ref) {
  return LanguageNotifier();
});

// Localization Provider - provides translated strings based on current language
final localizationProvider = Provider<AppLocalizations>((ref) {
  final currentLanguage = ref.watch(languageProvider);
  return AppLocalizations(currentLanguage.code);
});
