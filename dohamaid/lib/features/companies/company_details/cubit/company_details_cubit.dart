// ignore_for_file: depend_on_referenced_packages

import 'package:dohamaid/core/services/companies_services.dart';
import 'package:dohamaid/features/companies/company_details/presentation/company_details_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/data/datasources/api_service.dart';
import '../../../../core/utils/app_route.dart';
import '../../../home/presentation/home_screen.dart';
import '../../anti_bug_companies/presentaion/anti_bug_companies_screen.dart';
import '../../cleaning_companies/presentation/cleaning_companies_screen.dart';
import '../../nursing_companies/presentation/nursing_companies_screen.dart';
import '../../worker_companies/presentation/worker_companies_screen.dart';
import '../../worker_suppliers/presentation/worker_suppliers_screen.dart';
import '../data/company_detail_model.dart';
import 'package:dohamaid/core/config/app_color.dart';



part 'company_details_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  CompanyDetailsCubit() : super(CompanyDetailsInitial());
  bool comingFromCleaningCompany =false;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  CompanyDetailsModel? companyDetails;
  Future<void> showSignInSignUpDialog({
    required BuildContext context,
    VoidCallback? onSignIn,
    VoidCallback? onSignUp,
  }) async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: "auth_required_title".tr(),
        desc: "auth_required_desc".tr(),
        btnCancelText: "sign_in_btn".tr(),
        btnCancelOnPress: onSignIn ?? () {},
        btnOkText: "sign_up_btn".tr(),
        btnOkOnPress: onSignUp ?? () {},
        buttonsTextStyle:  const TextStyle(color: AppColor.white, fontSize: 17, fontWeight: FontWeight.bold),
        btnOkColor:  AppColor.mainColor,
        btnCancelColor:  AppColor.mainColor,

        showCloseIcon: true
    ).show();
  }

  List<String> getAllRoutes() {
    return  appRouteObserver.routeStack
        .map((r) => r.settings.name ?? r.runtimeType.toString())
        .toList();
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
  void _navigateIfNotOpen(
      BuildContext context, {
        required Widget screen,
        required String routeName,
      }) {
    if (isScreenAlreadyOpen(context, screen.runtimeType)) {
      List<String> routes = getAllRoutes();
    // [/, HomeScreen, HomeScreen, WorkerCompaniesScreen, CompanyDetailsScreen]
      for(String route in routes) {
        switch (route) {
          case "HomeScreen":
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
                settings: const RouteSettings(name: "HomeScreen"),
              ),
                  (route) => false,
            );
            break;

          case "WorkerCompaniesScreen":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WorkerCompaniesScreen(),
                settings: const RouteSettings(name: "WorkerCompaniesScreen"),
              ),
            );
            break;

          case "AntiBugCompaniesScreen":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AntiBugCompaniesScreen(),
                settings: const RouteSettings(name: "AntiBugCompaniesScreen"),
              ),
            );
            break;

          case "CleaningCompaniesScreen":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CleaningCompaniesScreen(),
                settings: const RouteSettings(name: "CleaningCompaniesScreen"),
              ),
            );
            break;

          case "NursingCompaniesScreen":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NursingCompaniesScreen(),
                settings: const RouteSettings(name: "NursingCompaniesScreen"),
              ),
            );
            break;

          case "WorkerSuppliersScreen":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WorkerSuppliersScreen(),
                settings: const RouteSettings(name: "WorkerSuppliersScreen"),
              ),
            );
            break;

          case "CompanyDetailsScreen":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => screen,
                settings: RouteSettings(name: routeName),
              ),
            );
            break;

          default:
            debugPrint("Unknown route: $route");
        }
}
    }
  }
  void resetState(BuildContext context) {

    _navigateIfNotOpen(
      context,
      screen: CompanyDetailsScreen(companyId: companyDetails?.data?.id??0, comingFromCleaningCompanies: comingFromCleaningCompany,),
      routeName: "CompanyDetailsScreen",
    );// or reload data as needed
  }
  // Init animation
  void initAnimation(TickerProvider vsync) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
  }

  Future<void> makeCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    await launchUrl(url);
  }

  Future<void> openWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/+974$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open WhatsApp";
    }
  }
  Future<void> sendEmail(String email) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'استفسار',
        'body': 'السلام عليكم، أود الاستفسار بخصوص خدماتكم.'
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open email client";
    }
  }
  Future<void> loadCompanyDetailsData(int id,bool? checker) async {
    emit(CompanyDetailsLoading());

    try {
      final response = await CompaniesServices(ApiService()).getCompanyDetails(id);
      comingFromCleaningCompany = checker??false;
      companyDetails = response;

      animationController.forward();

      emit(CompanyDetailsLoaded(companyDetails!));
    } catch (e) {
      emit(CompanyDetailsError(e.toString()));
    }
  }
}
