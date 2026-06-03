import 'package:flutter/material.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey.shade100;
    Color textColor = Colors.grey.shade800;

    final l10n = AppLocalizations.of(context)!;

    if (status == l10n.pending ||
        status == l10n.pendingWithHamza ||
        status == 'قيد الانتظار') {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
    } else if (status == l10n.confirmed || status == l10n.completed) {
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
    } else if (status == l10n.canceled ||
        status == l10n.canceledWithMaksoura ||
        status == 'ملغي') {
      bgColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
    }

    /* switch (status) {
      case 'قيد الانتظار':
      case 'قيد الأنتظار':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        break;

      case 'مؤكد':
      case 'مكتمل':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        break;

      case 'ملغي':
      case 'ملغى':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        break;

      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
    } */

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),

      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
