import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:clinics_booking/data/dummy_doctors.dart';
import 'package:clinics_booking/models/doctor.dart';

final doctorsProvider = Provider<List<DoctorModel>>((ref) {
  return dummy_Doctors;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>(
  (ref) => null,
); // 'الكل'

final filteredDoctorsProvider = Provider<List<DoctorModel>>((ref) {
  final doctors = ref.watch(doctorsProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim().toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return doctors.where((doctor) {
    final matchesCategory =
        selectedCategory == null || doctor.specialty == selectedCategory;
    final matchesSearch =
        doctor.dname.toLowerCase().contains(searchQuery) ||
        doctor.specialty.toLowerCase().contains(searchQuery);

    return matchesCategory && matchesSearch;
  }).toList();
});
