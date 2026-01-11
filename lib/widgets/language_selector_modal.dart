import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:dream_boat_mobile/main.dart';
import 'package:dream_boat_mobile/l10n/app_localizations.dart';

/// A beautiful bottom sheet for selecting app language
class LanguageSelectorModal extends StatelessWidget {
  const LanguageSelectorModal({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    
    final languages = [
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E1B35).withOpacity(0.95),
            const Color(0xFF0F0F23).withOpacity(0.95),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 16), // Reduced from 24
          
          // Title
          Text(
            AppLocalizations.of(context)!.settingsLanguage,
            style: const TextStyle(
              color: Color(0xFFA78BFA),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16), // Reduced from 24
          
          // Language options
          ...languages.map((lang) {
            final isSelected = currentLocale.languageCode == lang['code'];
            return Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  MyApp.setLocale(context, Locale(lang['code'] as String));
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: const Color(0xFFA78BFA).withOpacity(0.15),
                highlightColor: const Color(0xFFA78BFA).withOpacity(0.08),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), // Reduced vert from 6
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Reduced vert from 16
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? const Color(0xFFA78BFA).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                        ? const Color(0xFFA78BFA)
                        : Colors.white.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        lang['flag'] as String,
                        style: const TextStyle(fontSize: 20), // Reduced from 24
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          lang['name'] as String,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 15, // Reduced from 16
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          LucideIcons.check,
                          color: Color(0xFFA78BFA),
                          size: 18, // Reduced from 20
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          const SizedBox(height: 24), // Reduced from 32
        ],
      ),
    );
  }
}
