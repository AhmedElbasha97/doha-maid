// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:dohamaid/core/config/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/cubit/localization_cubit.dart';

class HomeTapWidget extends StatelessWidget {
  const HomeTapWidget({super.key, required this.title, required this.icon, required this.onTap});
      final String title;
      final String icon;
     final  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.mainColor, AppColor.actionGreen],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColor.purple.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.white.withOpacity(0.2),
              radius: 22,
              child: Image.asset(icon, ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style:  TextStyle(
                  color: AppColor.white,
                  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios, color: AppColor.white, size: 20),
          ],
        ),
      ),
    );
  }
}
