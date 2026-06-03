import 'package:flutter/material.dart';
import 'package:clinics_booking/providers/doctors_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CategoriesList extends ConsumerWidget {
  const CategoriesList({super.key});

  final List<String> categories = const [
    'الكل',
    'طبيب باطنية',
    'أسنان وتجميل',
    'استشاري أمراض القلب',
    'أنف وأذن وحنجرة',
    'أخصائي عيون',
    'أخصائي أطفال',
    'أمراض جلدية وتجميل',
    'جراحة العظام والمفاصل',
    'مخ وأعصاب',
    'طب نفسي وارشاد أسري',
    'مسالك بولية',
    'تغذية علاجية'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;

            return GestureDetector(
              onTap: () {
                ref.read(selectedCategoryProvider.notifier).state = category;
              },
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.easeInOut,
                margin:  const EdgeInsetsDirectional.only(end: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: isSelected ? 0 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                        BoxShadow(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                           blurRadius: 8,
                           offset: const Offset(0, 4)
                        )
                      ] : [],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                    ),
                  ),
                ),
              ),
            );
          },
      ),
    ) ;
  }
}
