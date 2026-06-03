import 'package:flutter_riverpod/legacy.dart';

final selectedDateProvider = StateProvider.autoDispose<DateTime?>(
  (ref) => null,
);

final selectedTimeProvider = StateProvider.autoDispose<String?>((ref) => null);

//TimeOfDay
