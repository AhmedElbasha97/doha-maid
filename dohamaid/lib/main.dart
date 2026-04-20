import 'package:dohamaid/core/notifications/push_notification_service.dart';
import 'package:dohamaid/core/presentation/cubit/notification/notification_cubit.dart';
import 'package:dohamaid/core/presentation/cubit/notification/notification_state.dart';
import 'package:dohamaid/features/auth/sign_in/presentation/log_in_screen.dart';
import 'package:dohamaid/features/auth/verification_code/cubit/verification_code_cubit.dart';
import 'package:dohamaid/features/bookings/presentation/booking_list_screen.dart';
import 'package:dohamaid/features/home/presentation/home_screen.dart';
import 'package:dohamaid/features/profile_screen/presentation/profile_screen.dart';
import 'package:dohamaid/features/webview/web_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/config/app_theme.dart';
import 'core/data/datasources/storage_local_data_source.dart';
import 'core/presentation/cubit/localization_cubit.dart';
import 'core/presentation/cubit/theme_cubit.dart';
import 'core/utils/app_route.dart';
import 'features/auth/sign_in/cubit/log_in_cubit.dart';
import 'features/auth/sign_up/cubit/regestier_cubit.dart';
import 'features/companies/anti_bug_companies/cubit/anti_bug_companies_cubit.dart';
import 'features/companies/booking_screens/cubit/booking_cubit.dart';
import 'features/companies/cleaning_companies/cubit/cleaning_companies_cubit.dart';
import 'features/companies/company_details/cubit/company_details_cubit.dart';
import 'features/companies/nursing_companies/cubit/nursing_companies_cubit.dart';
import 'features/companies/payment/cubit/payment_cubit.dart';
import 'features/companies/worker_companies/cubit/worker_companies_cubit.dart';
import 'features/companies/worker_suppliers/cubit/worker_suppliers_cubit.dart';
import 'features/drawer/cubit/drawer_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/splash/cubit/splash_cubit.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/welcome/cubit/welcome_cuibit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await StorageLocalDataSource.init();
  final storage = StorageLocalDataSource.instance;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final savedLocaleCode = await storage.getSavedLocaleCode();
  final initialLocale = (savedLocaleCode != null && savedLocaleCode.isNotEmpty)
      ? Locale(savedLocaleCode)
      : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      startLocale: initialLocale,
      child: MyApp(storage: storage),
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageLocalDataSource storage;

  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => LocalizationCubit(storage)..loadLocale(context),
            ),
            BlocProvider(create: (_) => LoginCubit()),
            BlocProvider(create: (_) => RegisterCubit()),
            BlocProvider(create: (_) => PaymentCubit()),
            BlocProvider(create: (_) => ThemeCubit(storage)..loadTheme()),
            BlocProvider(create: (_) => SplashCubit()..startSplashAnimation()),
            BlocProvider(create: (_) => WelcomeCubit()..startAnimation()),
            BlocProvider(create: (_) => HomeCubit()),
            BlocProvider(create: (_) => VerificationCodeCubit()),
            BlocProvider(create: (_) => WorkerCompaniesCubit()),
            BlocProvider(create: (_) => BookingCubit()),
            BlocProvider(create: (_) => CleaningCompaniesCubit()),
            BlocProvider(create: (_) => NursingCompaniesCubit()),
            BlocProvider(create: (_) => AntiBugCompaniesCubit()),
            BlocProvider(create: (_) => WorkerSuppliersCubit()),
            BlocProvider(create: (_) => CompanyDetailsCubit()),
            BlocProvider(create: (_) => DrawerCubit()),
            BlocProvider(
              create: (_) => NotificationCubit(PushNotificationService())
                ..initialize(),
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<NotificationCubit, NotificationState>(
                listenWhen: (previous, current) =>
                    previous.route != current.route && current.route != null,
                listener: (context, state) async {
                  await _handleNotificationNavigation(context, state);
                },
              ),
            ],
            child: BlocBuilder<LocalizationCubit, Locale>(
              builder: (_, localeState) {
                return BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (_, themeMode) {
                    return MaterialApp(
                      navigatorKey: appNavigatorKey,
                      debugShowCheckedModeBanner: false,
                      title: 'alkhadam',
                      navigatorObservers: [appRouteObserver],
                      locale: context.locale,
                      supportedLocales: context.supportedLocales,
                      localizationsDelegates: context.localizationDelegates,
                      themeMode: themeMode,
                      theme: AppTheme.lightTheme(context.locale),
                      darkTheme: AppTheme.darkTheme(context.locale),
                      home: const SplashScreen(),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleNotificationNavigation(
    BuildContext context,
    NotificationState state,
  ) async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null || state.route == null || state.route!.isEmpty) return;

    final route = state.route!;
    Widget? screen;

    switch (route) {
      case 'home':
        screen = const HomeScreen();
        break;
      case 'profile':
        screen = const ProfileScreen();
        break;
      case 'login':
        screen = const LoginScreen();
        break;
      case 'booking_list':
        screen = const BookingListScreen();
        break;
      case 'web':
        final url = state.payload['url']?.toString();
        if (url != null && url.isNotEmpty) {
          screen = WebViewContainer(url);
        }
        break;
      default:
        screen = null;
    }

    if (screen != null) {
      navigator.push(MaterialPageRoute(builder: (_) => screen!));
      await context.read<NotificationCubit>().markRouteHandled();
    }
  }
}
