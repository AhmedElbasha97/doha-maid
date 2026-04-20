// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:dohamaid/loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/datasources/api_service.dart';
import '../../../core/services/auth_services.dart';
import '../../drawer/cubit/drawer_cubit.dart';
import '../../drawer/presentation/drawer_screen.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../data/profile_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(AuthServices(ApiService()))..loadProfile(),
      child: Scaffold(
        appBar:AppBar(
          backgroundColor:  AppColor.appBarBackground,
          elevation: 3,
          title: Image.asset(
            "assets/logo with out background.png",
            scale: 4.5,
          ),
          centerTitle: true,
          leading:IconButton(onPressed: (){
            Navigator.maybePop(context);
          }, icon: const Icon(Icons.arrow_back_ios, color:  AppColor.mainColor)),
          actions:[ IconButton(
              icon: const Icon(Icons.menu, color:  AppColor.mainColor),
              onPressed: (){
                // inside any widget with context:
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'drawer',
                  pageBuilder: (ctx, anim1, anim2) {
                    return BlocProvider(
                      create: (_) => DrawerCubit()..load(),
                      child: const CustomDrawer(

                      ),
                    );
                  },
                  transitionBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: anim,
                      child: child,
                    );
                  },
                );

              }        )],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Loader();
              }


              if (state is ProfileLoaded) {
                return _buildProfile(context, state.profile);
              }


              return  Center(child: Text("error_loading".tr()));
            },
          ),
        ),
      ),
    );
  }




// ========== MAIN PROFILE UI ==========
  Widget _buildProfile(BuildContext context, ProfileModel? profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _animatedHeader(),
          const SizedBox(height: 24),


          _glassCard(children: [
            _infoRow(Icons.person, "name".tr(), profile?.name ?? ""),
            _infoRow(Icons.email_outlined, "email".tr(), profile?.email ?? ""),
            _infoRow(Icons.phone, "phone".tr(), profile?.mobile ?? "not_available".tr()),
            _infoRow(Icons.calendar_today, "created_at".tr(), profile?.createdAt ?? ""),
          ]),
          const SizedBox(height: 30),

          _logoutButton(context),
          const SizedBox(height: 10),
          _deleteButton(context),

        ],
      ),
    );
  }
}
// ========== Animated Header with Gradient ==========


// ========== Glass Card ==========
Widget _glassCard({required List<Widget> children}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(

        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.white.withOpacity(0.3)),
          boxShadow: const [
            BoxShadow(
              color: AppColor.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(children: children),
      ),
    ),
  );
}


// ========== Info Row ==========
Widget _infoRow(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.mainColor.withOpacity(0.1),

            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color:  AppColor.mainColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, color: AppColor.black54)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    ),
  );
}


// ========== Logout Button ==========
Widget _logoutButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      backgroundColor: AppColor.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
    ),
    onPressed: () {
      context.read<ProfileCubit>().showActionDialog(
      context: context,
      isLogout: true,
      onConfirm: () {
        context.read<ProfileCubit>().logoutUser(context);
      },
    );},
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.logout, color: AppColor.white),
        const SizedBox(width: 10),
        Text(
            "logout".tr()
          ,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.white),
        ),
      ],
    ),
  );
}
Widget _deleteButton(BuildContext context) {


  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      backgroundColor: AppColor.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
    ),
    onPressed: () {
      context.read<ProfileCubit>().showActionDialog(
        context: context,
        isLogout: false,
        onConfirm: () {
          context.read<ProfileCubit>().deleteUserAccount(context);
        },
      );
    },
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.delete, color: AppColor.white),
        const SizedBox(width: 10),
        Text(
            "delete_title".tr()
          ,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.white),
        ),
      ],
    ),
  );
}
// ========== Animated Header with Gradient ==========
Widget _animatedHeader() {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0, end: 1),
    duration: const Duration(milliseconds: 900),
    curve: Curves.easeOut,
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, 40 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      );
    },
    child: Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.secondaryColor, AppColor.mainColor],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:  AppColor.mainColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child:  Center(
        child: Text(
            "profile_title".tr()
          ,
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}