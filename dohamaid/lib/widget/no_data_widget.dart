// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:dohamaid/core/utils/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dohamaid/core/config/app_color.dart';

class NoDataWidget extends StatefulWidget {
  /// If null → use localized default
  final String? messageKey;

  const NoDataWidget({
    super.key,
    this.messageKey,
  });

  @override
  State<NoDataWidget> createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleText =
    (widget.messageKey ?? 'no_data_title').tr();

    return FadeTransition(
      opacity: _fade,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      isDark
                          ? AppColor.white.withOpacity(0.05)
                          :  AppColor.mainColor.withOpacity(0.05),
                      isDark
                          ? AppColor.white.withOpacity(0.02)
                          :  AppColor.mainColor.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color:  AppColor.mainColor.withOpacity(0.2),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: screenHeight(context) * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          "assets/No data.gif",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      titleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColor.white : Colors.blueGrey[700],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'no_data_retry'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColor.white70 : AppColor.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
