import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/providers/notifications_provider.dart';
import 'package:clinics_booking/screens/notification_screen/widgets/notification_empty_state.dart';
import 'package:clinics_booking/screens/notification_screen/widgets/notification_tile.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: notifications.isEmpty
          ? const NotificationEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onDismissed: (direction) {
                    ref
                        .read(notificationProvider.notifier)
                        .deleteNotification(
                          notification.id,
                          notification.userId,
                        );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.notificationDeleted,
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: NotificationTile(notification: notification),
                );
              },
            ),
    );
  }
}
