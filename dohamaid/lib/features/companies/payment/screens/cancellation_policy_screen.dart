import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import 'package:dohamaid/core/config/app_color.dart';

class CancellationPolicyScreen extends StatelessWidget {
  const CancellationPolicyScreen({super.key, this.onAgree});

  final VoidCallback? onAgree;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar:AppBar(
        backgroundColor:  AppColor.appBarBackground,
        elevation: 3,
        title: Image.asset(
          "assets/logo with out background.png",
          scale: 4.5,
        ),
        centerTitle: true,
        leading:IconButton(
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

            }        ),
        actions:[IconButton(onPressed: (){
          Navigator.maybePop(context);
        }, icon: const Icon(Icons.arrow_forward_ios, color:  AppColor.mainColor)) ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "cancellationPolicy".tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.secondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "cancellation".tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 24),
            _Bullet(text: "policyBullet1".tr()),
            const SizedBox(height: 16),
            _Bullet(text:"policyBullet2".tr()),
            const SizedBox(height: 16),
            _Bullet(text: "policyBullet3".tr()),
            const SizedBox(height: 16),
            _Bullet(text: "policyBullet4".tr()),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onAgree?.call();
                  Navigator.of(context).pop();
                },
                child: Text("iAgree".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 16, color: AppColor.textPrimaryDark)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: AppColor.textPrimaryDark, height: 1.5),
          ),
        ),
      ],
    );
  }
}
