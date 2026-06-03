import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/providers/user_provider.dart';
import 'package:clinics_booking/screens/profile_screen/widgets/profile_header.dart';
import 'package:clinics_booking/screens/profile_screen/widgets/settings_option.dart';
import 'package:clinics_booking/screens/profile_screen/widgets/logout_button.dart';
import 'package:clinics_booking/providers/locale_provider.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';
import 'package:clinics_booking/screens/notification_screen/notification.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(userState: userState),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.generalSettings,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SettingsOption(
                    icon: Icons.person_outline,
                    title: AppLocalizations.of(context)!.editProfile,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.featureComingSoon,
                          ),
                        ),
                      );
                    },
                  ),

                  SettingsOption(
                    icon: Icons.language_outlined,
                    title: AppLocalizations.of(context)!.language,
                    onTap: () => _showLanguageBottomSheet(context, ref),
                  ),

                  SettingsOption(
                    icon: Icons.notifications_none_rounded,
                    title: AppLocalizations.of(context)!.notifications,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                  ),

                  SettingsOption(
                    icon: Icons.info_outline_rounded,
                    title: AppLocalizations.of(context)!.aboutApp,
                    onTap: () => _showAboutDialog(context),
                  ),

                  const SizedBox(height: 40),

                  const LogoutButton(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: SingleChildScrollView(
          child: Row(
            children: [
              Icon(
                Icons.medical_services_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),

              const SizedBox(width: 10),

              Text(AppLocalizations.of(context)!.medicalClinicsBookingSystem),
            ],
          ),
        ),

        content: Text(
          AppLocalizations.of(context)!.appDevelopmentInfo,
          style: TextStyle(height: 1.6, fontSize: 15, color: Colors.black87),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseAppLanguage,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Text(
                  '\u{1F1FE}\u{1F1EA}',
                  style: TextStyle(fontSize: 24),
                ),
                title: Text(
                  AppLocalizations.of(context)!.arabic,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: currentLocale.languageCode == 'ar'
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,

                onTap: () {
                  ref.read(localeProvider.notifier).changeLocale('ar');

                  Navigator.of(context).pop();
                },
              ),

              const Divider(),

              ListTile(
                leading: const Text(
                  '\u{1F1FA}\u{1F1F8}',
                  style: TextStyle(fontSize: 24),
                ),
                title: Text(
                  AppLocalizations.of(context)!.english,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: currentLocale.languageCode == 'en'
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,

                onTap: () {
                  ref.read(localeProvider.notifier).changeLocale('en');

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
