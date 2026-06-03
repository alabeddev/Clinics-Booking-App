import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك'**
  String get welcome;

  /// No description provided for @newuser.
  ///
  /// In ar, this message translates to:
  /// **'مستخدم جديد'**
  String get newuser;

  /// No description provided for @medicalSpecialties.
  ///
  /// In ar, this message translates to:
  /// **'التخصصات الطبية'**
  String get medicalSpecialties;

  /// No description provided for @availableDoctors.
  ///
  /// In ar, this message translates to:
  /// **'الأطباء المتاحون'**
  String get availableDoctors;

  /// No description provided for @searchHere.
  ///
  /// In ar, this message translates to:
  /// **'ابحث هنا'**
  String get searchHere;

  /// No description provided for @searchDoctorOrSpecialty.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن طبيب أو تخصص'**
  String get searchDoctorOrSpecialty;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @bookings.
  ///
  /// In ar, this message translates to:
  /// **'الحجوزات'**
  String get bookings;

  /// No description provided for @myAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get myAccount;

  /// No description provided for @doctorDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الدكتور'**
  String get doctorDetails;

  /// No description provided for @clinicLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقع العيادة'**
  String get clinicLocation;

  /// No description provided for @availableTimes.
  ///
  /// In ar, this message translates to:
  /// **'الأوقات المتاحة'**
  String get availableTimes;

  /// No description provided for @bookingPrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الحجز'**
  String get bookingPrice;

  /// No description provided for @aboutDoctor.
  ///
  /// In ar, this message translates to:
  /// **'نبذة عن الطبيب'**
  String get aboutDoctor;

  /// No description provided for @selectBookingDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر موعد الحجز'**
  String get selectBookingDate;

  /// No description provided for @selectDay.
  ///
  /// In ar, this message translates to:
  /// **'اختر اليوم'**
  String get selectDay;

  /// No description provided for @selectHour.
  ///
  /// In ar, this message translates to:
  /// **'اختر الساعة'**
  String get selectHour;

  /// No description provided for @continueBooking.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الحجز'**
  String get continueBooking;

  /// No description provided for @confirmBooking.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحجز'**
  String get confirmBooking;

  /// No description provided for @appointmentSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الموعد'**
  String get appointmentSummary;

  /// No description provided for @doctor.
  ///
  /// In ar, this message translates to:
  /// **'الطبيب'**
  String get doctor;

  /// No description provided for @specialty.
  ///
  /// In ar, this message translates to:
  /// **'التخصص'**
  String get specialty;

  /// No description provided for @location.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get location;

  /// No description provided for @bookingDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحجز'**
  String get bookingDate;

  /// No description provided for @hour.
  ///
  /// In ar, this message translates to:
  /// **'الساعة'**
  String get hour;

  /// No description provided for @paymentDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الدفع'**
  String get paymentDetails;

  /// No description provided for @bookingFees.
  ///
  /// In ar, this message translates to:
  /// **'رسوم الحجز'**
  String get bookingFees;

  /// No description provided for @clinicNotesOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات للعيادة (اختياري)'**
  String get clinicNotesOptional;

  /// No description provided for @chronicDiseasesNote.
  ///
  /// In ar, this message translates to:
  /// **'اكتب هنا اذا كنت تعاني من أمراض مزمنة أو أي ملاحظة'**
  String get chronicDiseasesNote;

  /// No description provided for @sendingBookingRequest.
  ///
  /// In ar, this message translates to:
  /// **'جاري ارسال طلب الحجز'**
  String get sendingBookingRequest;

  /// No description provided for @bookingRequestSentSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم ارسال طلبك بنجاح'**
  String get bookingRequestSentSuccess;

  /// No description provided for @myAppointments.
  ///
  /// In ar, this message translates to:
  /// **'مواعيدي'**
  String get myAppointments;

  /// No description provided for @upcomingAppointments.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد القادمة'**
  String get upcomingAppointments;

  /// No description provided for @previousAppointments.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد السابقة'**
  String get previousAppointments;

  /// No description provided for @cancelAppointment.
  ///
  /// In ar, this message translates to:
  /// **'الغاء الموعد'**
  String get cancelAppointment;

  /// No description provided for @cancelBooking.
  ///
  /// In ar, this message translates to:
  /// **'الغاء الحجز'**
  String get cancelBooking;

  /// No description provided for @cancelConfirmationMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد الغاء هذا الموعد نهائياً؟ لا يمكن التراجع عن هذا'**
  String get cancelConfirmationMessage;

  /// No description provided for @back.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get back;

  /// No description provided for @yesCancel.
  ///
  /// In ar, this message translates to:
  /// **'نعم، الغاء'**
  String get yesCancel;

  /// No description provided for @pressAgainToExit.
  ///
  /// In ar, this message translates to:
  /// **'اضغط مره أخرى للخروج'**
  String get pressAgainToExit;

  /// No description provided for @pleaseSelectDateFirst.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار تاريخ الموعد اولا'**
  String get pleaseSelectDateFirst;

  /// No description provided for @bookingStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الحجز'**
  String get bookingStatus;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @generalSettings.
  ///
  /// In ar, this message translates to:
  /// **'الاعدادات العامه'**
  String get generalSettings;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل البيانات الشخصية'**
  String get editProfile;

  /// No description provided for @featureComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'سيتم تفعيل هذه الميزة قريباً'**
  String get featureComingSoon;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @chooseAppLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختر لغة التطبيق'**
  String get chooseAppLanguage;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الاشعارات'**
  String get notifications;

  /// No description provided for @appointmentHistoryEmpty.
  ///
  /// In ar, this message translates to:
  /// **'سجل المواعيد فارغ'**
  String get appointmentHistoryEmpty;

  /// No description provided for @aboutApp.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get aboutApp;

  /// No description provided for @noClinicVisitedYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تقم بزيارة أي عيادة حتى الان'**
  String get noClinicVisitedYet;

  /// No description provided for @medicalClinicsBookingSystem.
  ///
  /// In ar, this message translates to:
  /// **'نظام حجز عيادات طبية'**
  String get medicalClinicsBookingSystem;

  /// No description provided for @integratedAppDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق متكامل لحجز وأداره المواعيد الطبية'**
  String get integratedAppDescription;

  /// No description provided for @noDoctorsAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد أطباء متاحين حالياً'**
  String get noDoctorsAvailable;

  /// No description provided for @close.
  ///
  /// In ar, this message translates to:
  /// **'أغلاق'**
  String get close;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @confirmLogout.
  ///
  /// In ar, this message translates to:
  /// **'هل انت متأكد انك تريد تسجيل الخروج من حسابك؟'**
  String get confirmLogout;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'الغاء'**
  String get cancel;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @confirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get confirm;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مواعيد قادمة'**
  String get noUpcomingAppointments;

  /// No description provided for @clinicManagementSystem.
  ///
  /// In ar, this message translates to:
  /// **'نظام أدارة العيادات'**
  String get clinicManagementSystem;

  /// No description provided for @bookNowWithBestDoctors.
  ///
  /// In ar, this message translates to:
  /// **'أحجز موعدك الآن مع أفضل الأطباء'**
  String get bookNowWithBestDoctors;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دخول'**
  String get login;

  /// No description provided for @enter.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get enter;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب ؟ إنشاء حساب'**
  String get dontHaveAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get createNewAccount;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لدي حساب بالفعل ؟ تسجيل دخول'**
  String get alreadyHaveAccount;

  /// No description provided for @appDevelopmentInfo.
  ///
  /// In ar, this message translates to:
  /// **'تم تطويره كجزء من مشروع شخصي لتطوير مهاراتي والتعلم، تم تطويره بأستخدام Flutter/Dart والتقنيات المستخدمه Firebase, Riverpod'**
  String get appDevelopmentInfo;

  /// No description provided for @pleaseEnterName.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء ادخال اسم'**
  String get pleaseEnterName;

  /// No description provided for @nameMinLength.
  ///
  /// In ar, this message translates to:
  /// **'يجب ان يكون الاسم 3 احرف على الاقل'**
  String get nameMinLength;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء ادخال رقم الهاتف'**
  String get pleaseEnterPhone;

  /// No description provided for @phoneLengthWarning.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب ان يتكون من 9 ارقام'**
  String get phoneLengthWarning;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء ادخال بريد الكتروني صالح'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء ادخال كلمه مرور'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In ar, this message translates to:
  /// **'كلمه المرور يجب ان لاتقل عن 6 خانات'**
  String get passwordMinLength;

  /// No description provided for @arabic.
  ///
  /// In ar, this message translates to:
  /// **'العربيه'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'الانجليزيه'**
  String get english;

  /// No description provided for @pm.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get pm;

  /// No description provided for @am.
  ///
  /// In ar, this message translates to:
  /// **'ص'**
  String get am;

  /// No description provided for @notSpecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get notSpecified;

  /// No description provided for @unknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get unknown;

  /// No description provided for @doctorNotAvailable.
  ///
  /// In ar, this message translates to:
  /// **'طبيب غير متوفر'**
  String get doctorNotAvailable;

  /// No description provided for @errorFetchingData.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في جلب البيانات'**
  String get errorFetchingData;

  /// No description provided for @userDataNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على بيانات المستخدم'**
  String get userDataNotFound;

  /// No description provided for @errorFetchingTimesCheckInternet.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في جلب الاوقات، تحقق من اتصالك بالانترنت'**
  String get errorFetchingTimesCheckInternet;

  /// No description provided for @clinicNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات للعياده'**
  String get clinicNotes;

  /// No description provided for @pleaseSelectDateAndTimeFirst.
  ///
  /// In ar, this message translates to:
  /// **'الرجأ أختيار تاريخ ووقت الحجز أولآ'**
  String get pleaseSelectDateAndTimeFirst;

  /// No description provided for @selectBookingTime.
  ///
  /// In ar, this message translates to:
  /// **'أختر وقت الحجز'**
  String get selectBookingTime;

  /// No description provided for @loginRequiredToBook.
  ///
  /// In ar, this message translates to:
  /// **'عذرآ، يجب تسجيل الدخول أولآ لأتمام الحجز'**
  String get loginRequiredToBook;

  /// No description provided for @errorReadingAppointmentData.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ في قراءة بيانات الموعد، الرجاء المحاولة مجددا'**
  String get errorReadingAppointmentData;

  /// No description provided for @pending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get pending;

  /// No description provided for @pendingWithHamza.
  ///
  /// In ar, this message translates to:
  /// **'قيد الأنتظار'**
  String get pendingWithHamza;

  /// No description provided for @canceled.
  ///
  /// In ar, this message translates to:
  /// **'ملغي'**
  String get canceled;

  /// No description provided for @canceledWithMaksoura.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get canceledWithMaksoura;

  /// No description provided for @confirmed.
  ///
  /// In ar, this message translates to:
  /// **'مؤكد'**
  String get confirmed;

  /// No description provided for @completed.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get completed;

  /// No description provided for @appointmentDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الموعد'**
  String get appointmentDetails;

  /// No description provided for @notificationDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف الاشعار'**
  String get notificationDeleted;

  /// No description provided for @noNotificationsCurrently.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات حالياً'**
  String get noNotificationsCurrently;

  /// No description provided for @appointmentAlertsWillAppearHere.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات المواعيد ستظهر هنا'**
  String get appointmentAlertsWillAppearHere;

  /// No description provided for @welcomeToOurClinic.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في عيادتنا 🏥'**
  String get welcomeToOurClinic;

  /// No description provided for @welcomeUserMessage.
  ///
  /// In ar, this message translates to:
  /// **'الأخ {userName}، يسعدنا انضمامك إلينا، نتمنى لك رحلة علاجية مريحة.'**
  String welcomeUserMessage(String userName);

  /// No description provided for @bookingConfirmationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الحجز 🗓'**
  String get bookingConfirmationTitle;

  /// No description provided for @bookingRequestedSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم طلب حجز موعد مع {doctorName} بنجاح.'**
  String bookingRequestedSuccessfully(String doctorName);

  /// No description provided for @scheduledReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير مجدول ⏰️'**
  String get scheduledReminder;

  /// No description provided for @reminderSetSuccessfully.
  ///
  /// In ar, this message translates to:
  /// **'تم ضبط منبه لتذكيرك بموعد مع {doctorName} قبل ساعتين من الحضور.'**
  String reminderSetSuccessfully(String doctorName);

  /// No description provided for @upcomingAppointmentReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير بموعدك القادم ⏰️'**
  String get upcomingAppointmentReminder;

  /// No description provided for @appointmentInTwoHours.
  ///
  /// In ar, this message translates to:
  /// **'لديك موعد مع {doctorName} بعد ساعتين من الآن..'**
  String appointmentInTwoHours(String doctorName);

  /// No description provided for @immediateAppointmentReminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير فوري بموعدك ⏰️'**
  String get immediateAppointmentReminder;

  /// No description provided for @appointmentVerySoon.
  ///
  /// In ar, this message translates to:
  /// **'لديك موعد قريباً جداً مع {doctorName}'**
  String appointmentVerySoon(String doctorName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
