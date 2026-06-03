import 'package:flutter/material.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class NotesInputField extends StatelessWidget {
  const NotesInputField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.chronicDiseasesNote,
        hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }
}
