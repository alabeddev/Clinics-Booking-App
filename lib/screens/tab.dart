import 'package:flutter/material.dart';
import 'package:clinics_booking/screens/doctors_screen/doctors_screen.dart';
import 'package:clinics_booking/screens/booking_screen/booking_screen.dart';
import 'package:clinics_booking/screens/profile_screen/profile_screen.dart';
import 'package:clinics_booking/l10n/app_localizations.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = const [
    DoctorsScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  DateTime? _lastBackPressed;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _handleBackPress() {
    if (_selectedPageIndex != 0) {
      setState(() {
        _selectedPageIndex = 0;
      });
      return;
    }

    final now = DateTime.now();

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pressAgainToExit),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: AppLocalizations.of(context)!.bookings,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: AppLocalizations.of(context)!.myAccount,
            ),
          ],
        ),
      ),
    );
  }
}
