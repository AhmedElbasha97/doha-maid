// ignore_for_file: use_build_context_synchronously

import 'package:dohamaid/core/services/auth_services.dart';
import 'package:dohamaid/features/profile_screen/cubit/profile_state.dart';
import 'package:dohamaid/features/welcome/presentation/welcome_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/datasources/storage_local_data_source.dart';
import '../../auth/data/data_model.dart';
import '../../home/presentation/home_screen.dart';
import '../data/profile_model.dart';
import '../presentation/profile_screen.dart';
import 'package:dohamaid/core/config/app_color.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthServices repo;
  ProfileCubit(this.repo) : super(ProfileInitial());
   ProfileModel? profileData;
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen(),    settings: const RouteSettings(name: "HomeScreen"),
        ),
            (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: routeName),
        ),
      );
    }
  }
  void resetState(BuildContext context) {
    _navigateIfNotOpen(
      context,
      screen: const ProfileScreen(),
      routeName: "ProfileScreen",
    );// or reload data as needed
  }
  Future<void> showActionDialog({
    required BuildContext context,
    required bool isLogout, // true = logout, false = delete
    required VoidCallback onConfirm,
  }) async {
    AwesomeDialog(
      context: context,
      dialogType: isLogout ? DialogType.warning : DialogType.error,
      animType: AnimType.bottomSlide,
      title: isLogout
          ? "logout_title".tr()
          : "delete_title".tr(),
      desc: isLogout
          ?  "logout_desc".tr()
          :  "delete_desc".tr(),
      btnCancelText: "cancel_btn".tr(),
      btnCancelOnPress: () {},
      btnOkText: isLogout
          ? "logout_btn".tr()
          : "delete_btn".tr(),
      btnOkOnPress: onConfirm,
      btnOkColor: isLogout ? AppColor.orange : AppColor.red,
      showCloseIcon: true,
    ).show();
  }
  Future<void> logoutUser(BuildContext context) async {
    try {
      DataModel? response = await repo.loggingOut();

      if (response == null || response.success == false) {
        showAppMessage(context, "logoutFail".tr(), success: false);
        return;
      }else{
        showAppMessage(context, "logoutSuccess".tr(), success: true);
        await StorageLocalDataSource.instance.loggingOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen(),    settings: const RouteSettings(name: "WelcomeScreen"),
          ),
              (route) => false,
        );
      }

      showAppMessage(context, "logoutSuccess".tr(), success: true);

    } catch (e) {
      showAppMessage(context, "logoutFail".tr(), success: false);
    }
  }
  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      DataModel? response = await repo.deletingAnAccount();
      if (response == null || response.success == false) {
        showAppMessage(context, "deleteFail".tr(), success: false);
        return;
      }else{
        await StorageLocalDataSource.instance.loggingOut();
        showAppMessage(context, "deleteSuccess".tr(), success: true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen(),    settings: const RouteSettings(name: "WelcomeScreen"),
          ),
              (route) => false,
        );
      }



    } catch (e) {
      showAppMessage(context, "deleteFail".tr(), success: false);
    }
  }

  void showAppMessage(BuildContext context, String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColor.white, fontSize: 16),
        ),
        backgroundColor: success ? AppColor.green : AppColor.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void loadProfile() async {
    emit(ProfileLoading());
    try {
      final data = await repo.getProfileData();
      profileData = data;
      emit(ProfileLoaded(data));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}