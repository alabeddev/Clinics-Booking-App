import 'package:flutter/material.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active_outlined,
            size: 100,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          Text(
            AppLocalizations.of(context)!.noNotificationsCurrently,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            AppLocalizations.of(context)!.appointmentAlertsWillAppearHere,
            style: TextStyle(fontSize: 1, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
