import 'package:flutter/material.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({super.key, required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
      ),
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.bookingFees,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Text(
                '$price ريال ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
