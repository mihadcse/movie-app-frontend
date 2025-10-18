import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_background.dart';
import '../providers/language_provider.dart';
import '../utils/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    final localizations = ref.watch(localizationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(localizations.accountSettings),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Text(
            localizations.language,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                // English Option
                RadioListTile<Language>(
                  value: Language.english,
                  groupValue: currentLanguage,
                  onChanged: (Language? value) {
                    if (value != null) {
                      ref.read(languageProvider.notifier).setLanguage(value);
                      // Get new localizations after language change
                      final newLocalizations = AppLocalizations(value.code);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${newLocalizations.languageChanged} ${value.displayName}'),
                          backgroundColor: colorScheme.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: currentLanguage == Language.english
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🇬🇧',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        Language.english.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: currentLanguage == Language.english
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  activeColor: colorScheme.primary,
                ),
                
                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant,
                ),
                
                // Bangla Option
                RadioListTile<Language>(
                  value: Language.bangla,
                  groupValue: currentLanguage,
                  onChanged: (Language? value) {
                    if (value != null) {
                      ref.read(languageProvider.notifier).setLanguage(value);
                      // Get new localizations after language change
                      final newLocalizations = AppLocalizations(value.code);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${newLocalizations.languageChanged} ${value.displayName}'),
                          backgroundColor: colorScheme.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: currentLanguage == Language.bangla
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🇧🇩',
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        Language.bangla.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: currentLanguage == Language.bangla
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Current Language Info
          Card(
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${localizations.currentLanguage}: ${currentLanguage.displayName}',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Note
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        localizations.note,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.languagePreferenceSaved,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
