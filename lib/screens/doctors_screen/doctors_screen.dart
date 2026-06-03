import 'package:clinics_booking/providers/notifications_provider.dart';
import 'package:clinics_booking/screens/notification_screen/notification.dart';
import 'package:clinics_booking/screens/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/providers/user_provider.dart';
import 'package:clinics_booking/providers/doctors_provider.dart';
import 'package:clinics_booking/screens/doctors_screen/widgets/categories_list.dart';
import 'package:clinics_booking/screens/doctors_screen/widgets/doctor_card.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';
//import 'package:clinics_booking/providers/notifications_provider.dart';

class DoctorsScreen extends ConsumerWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider);
    final doctorsList = ref.watch(filteredDoctorsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                //height: size.height * 0.25,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      //Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white24,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.welcome,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                user.value?.uname ??
                                    AppLocalizations.of(context)!.newuser,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        Consumer(
                          builder: (context, ref, child) {
                            final showBadge = ref.watch(unreadBadgeProvider);

                            return IconButton(
                              onPressed: () {
                                ref.read(unreadBadgeProvider.notifier).state =
                                    false;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(),
                                  ),
                                );
                              },
                              icon: Badge(
                                isLabelVisible: showBadge,
                                //label: Text(notifications.length.toString()),
                                smallSize: 14,
                                backgroundColor: Colors.redAccent,
                                child: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.white,
                                  size: 45,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.searchHere,
                        hintText: AppLocalizations.of(
                          context,
                        )!.searchDoctorOrSpecialty,
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                        //contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.medicalSpecialties,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    CategoriesList(),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.availableDoctors,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 8),
                    if (doctorsList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.noDoctorsAvailable,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: doctorsList.length,
                        itemBuilder: (context, index) {
                          final doctor = doctorsList[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: DoctorCard(doctor: doctor),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
