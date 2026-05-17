  // lib/features/drawer/cubit/drawer_cubit.dart
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dohamaid/features/webview/web_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/datasources/storage_local_data_source.dart';
import '../../../core/presentation/cubit/localization_cubit.dart';
import '../../auth/sign_in/presentation/log_in_screen.dart';
import '../../auth/sign_up/presentation/regestier_screen.dart';
import '../../bookings/presentation/booking_list_screen.dart';
import '../../companies/anti_bug_companies/presentaion/anti_bug_companies_screen.dart';
import '../../companies/cleaning_companies/presentation/cleaning_companies_screen.dart';
import '../../companies/nursing_companies/presentation/nursing_companies_screen.dart';
import '../../companies/worker_companies/presentation/worker_companies_screen.dart';
import '../../companies/worker_suppliers/presentation/worker_suppliers_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../locations/presentation/location_list_screen.dart';
import '../../profile_screen/presentation/profile_screen.dart';
import '../data/drawer_model.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());

  /// Example initial data. Replace with API/profile fetch as needed.
  final List<DrawerItemModel> _initialItems = [
    DrawerItemModel(id: 'home', title: "home".tr(), icon: Icons.home),
     DrawerItemModel(
      id: 'about',
      title: 'about'.tr(),
      icon: Icons.info_outline,
      children: [
        DrawerItemModel(id: 'about_us', title:  'about_us'.tr(), icon: Icons.info),
        DrawerItemModel(id: 'team', title: 'team'.tr(), icon: Icons.group),
      ],
    ),
     DrawerItemModel(
      id: 'companies',
      title: 'companies'.tr(),
      icon: Icons.apartment,
      children: [
        DrawerItemModel(id: 'worker_companies', title: 'worker_companies'.tr(), icon: Icons.work),
        DrawerItemModel(id: 'cleaning_companies', title:'cleaning_companies'.tr(), icon: Icons.cleaning_services),
        DrawerItemModel(id: 'AntiBugCompanies', title:'AntiBugCompanies'.tr(), icon: Icons.bug_report_rounded),
        DrawerItemModel(id: 'nursing_companies', title: 'nursing_companies'.tr(), icon: Icons.local_hospital),
        DrawerItemModel(id: 'worker_suppliers', title:'worker_suppliers'.tr(), icon: Icons.wc_outlined),
      ],
    ),

     DrawerItemModel(id: 'privacyPolicy', title: 'privacy_Policy'.tr(), icon: Icons.privacy_tip),
     DrawerItemModel(id: 'termsAndCondition', title:'terms_And_Condition'.tr(), icon: Icons.import_contacts_sharp),
     DrawerItemModel(id: 'news', title:'news'.tr(), icon: Icons.article_outlined),
     DrawerItemModel(id: 'contact', title: 'contact'.tr(), icon: Icons.contact_phone),
     DrawerItemModel(id: 'language', title: 'language'.tr(), icon: Icons.public),
  ];

  /// Public access to menu
  List<DrawerItemModel> get items => _items;
  List<DrawerItemModel> _items = [];

  /// track expanded submenus by parent id
  final Set<String> expanded = {};

  /// selected item id
  String? selectedId;
  void resetState() {
    emit( DrawerInitial()); // or reload data as needed
  }
  /// load initial drawer data (could call API)
  void load() {
    if (StorageLocalDataSource.instance.userSignedIn()) {
      _initialItems.insert(4, DrawerItemModel(id: 'profile', title: 'profile'.tr(), icon: Icons.person));
      _initialItems.insert(5,  DrawerItemModel(id: 'booking_list', title:'booking_list_title'.tr(), icon: Icons.list_alt),

      );
      _initialItems.insert(6,  DrawerItemModel(id: 'locations', title:'location'.tr(), icon: Icons.location_on),);
    }else{
      _initialItems.insert(4, DrawerItemModel(id: 'login', title: 'login_title'.tr(), icon: Icons.login));
      _initialItems.insert(5, DrawerItemModel(id: 'register', title: 'register_title'.tr(), icon: Icons.login));
    }
    _items = List.from(_initialItems);

    emit(DrawerLoaded(_items));
  }

  /// toggle submenu expansion
  void toggle(String id) {
    if (expanded.contains(id)) {
      expanded.remove(id);
    } else expanded.add(id);
    emit(DrawerLoaded(_items));
  }
  void _navigateIfNotOpen(
      BuildContext context, {
        required Widget screen,
        required String routeName,
      }) {
    if (!isScreenAlreadyOpen(context, screen.runtimeType)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: routeName),
        ),
      );
    }


  }
  void handleDrawerNavigation(BuildContext context, String id) {
    switch (id) {
      //auth
      case "login":
        _navigateIfNotOpen(
          context,
          screen: const LoginScreen(),
          routeName: "LoginScreen",
        );
        break;
      case "register":
        _navigateIfNotOpen(
          context,
          screen: const RegisterScreen(),
          routeName: "RegisterScreen",
        );
        break;
    // ---------------- HOME ----------------
      case "home":
        _navigateIfNotOpen(
          context,
          screen: const HomeScreen(),
          routeName: "HomeScreen",
        );
        break;

    // ---------------- ABOUT ----------------
      case "about_us":
        _navigateIfNotOpen(
          context,
          screen: const WebViewContainer( "https://dohamaid.com/ar/about/1"),
          routeName: "WebViewContainer",
        );
        break;

      case "team":
        _navigateIfNotOpen(
          context,
          screen: const WebViewContainer( "https://dohamaid.com/qa/ar/page/4/mobile"),
          routeName: "WebViewContainer",
        );
        break;

    // ---------------- COMPANIES ----------------
      case "worker_companies":
        _navigateIfNotOpen(
          context,
          screen: const WorkerCompaniesScreen(),
          routeName: "WorkerCompaniesScreen",
        );
        break;
        case "profile":
        _navigateIfNotOpen(
          context,
          screen: const ProfileScreen(),
          routeName: "profileScreen",
        );
        break;

      case "cleaning_companies":
        _navigateIfNotOpen(
          context,
          screen: const CleaningCompaniesScreen(),
          routeName: "CleaningCompaniesScreen",
        );
        break;

      case "AntiBugCompanies":
        _navigateIfNotOpen(
          context,
          screen: const AntiBugCompaniesScreen(),
          routeName: "AntiBugCompaniesScreen",
        );
        break;

      case "nursing_companies":
        _navigateIfNotOpen(
          context,
          screen: const NursingCompaniesScreen(),
          routeName: "NursingCompaniesScreen",
        );
        break;

      case "worker_suppliers":
        _navigateIfNotOpen(
          context,
          screen: const WorkerSuppliersScreen(),
          routeName: "WorkerSuppliersScreen",
        );
        break;
      case "booking_list":
        _navigateIfNotOpen(
          context,
          screen: const BookingListScreen(),
          routeName: "BookingListScreen",
        );
        break;
      case "locations":
        _navigateIfNotOpen(
          context,
          screen: const LocationListScreen(),
          routeName: "LocationListScreen",
        );
        break;
        case "termsAndCondition":
        _navigateIfNotOpen(
          context,
          screen: const WebViewContainer( "https://dohamaid.com/ar/about/10"),
          routeName: "WebViewContainer",
        );
        break;
        case "privacyPolicy":
          _navigateIfNotOpen(
            context,
            screen: const WebViewContainer( "https://dohamaid.com/ar/about/3"),
            routeName: "WebViewContainer",
          );
        break;

    // // ---------------- NEWS ----------------
      case "news":
        _navigateIfNotOpen(
          context,
          screen: const WebViewContainer( "https://dohamaid.com/ar/blog"),
          routeName: "WebViewContainer",
        );
        break;

    // ---------------- CONTACT ----------------
      case "contact":
        _navigateIfNotOpen(
          context,
          screen: const WebViewContainer( "https://dohamaid.com/ar/contact"),
          routeName: "WebViewContainer",
        );
        break;
    //
    // // ---------------- LANGUAGE ----------------
      case "language":
        context.read<LocalizationCubit>().toggleLanguage(context);

        // Update EasyLocalization


        final newLocale = context.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
        context.setLocale(newLocale);
        break;
    // }
    }
  }
  bool isScreenAlreadyOpen(BuildContext context, Type screenType) {
    bool isOpen = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == "$screenType") {
        isOpen = true;
      }
      return true;
    });

    return isOpen;
  }
  /// select item (fires navigation outside)
  void select(String id,BuildContext context) {
    selectedId = id;
    handleDrawerNavigation(context, id);
    emit(DrawerItemSelected(id));

  }
}
