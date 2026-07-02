import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/app_color.dart';
import '../../bookings/presentation/booking_list_screen.dart';
import '../../home/presentation/home_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: const RouteSettings(name: "HomeScreen"),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColor.gray100,
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.mainColor.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.mainColor,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColor.white,
                            size: 36.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Payment confirmed',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimaryDark,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your booking has been placed.\nA cleaner will be with you shortly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.textMuted,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookingListScreen(),
                          settings: const RouteSettings(name: "BookingListScreen"),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.mainColor,
                        foregroundColor: AppColor.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'View booking',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _goHome(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.textPrimaryDark,
                        side: const BorderSide(color: AppColor.borderLight),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Back to home',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}