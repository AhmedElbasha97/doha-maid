// lib/features/drawer/custom_drawer.dart
// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/presentation/cubit/theme_cubit.dart';
import '../cubit/drawer_cubit.dart';
import '../data/drawer_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, });

  /// callback to perform navigation from host

  @override
  Widget build(BuildContext context) {
    // RTL direction
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(), // tap outside to dismiss
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final drawerWidth = width > 600 ? 420.0 : width * 0.92;
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: drawerWidth),
            child: Material(
              color: AppColor.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: BlocBuilder<DrawerCubit, DrawerState>(
                  builder: (context, state) {
                    // initial loading (empty)
                    if (state is DrawerInitial) {
                      // trigger load if not loaded
                      context.read<DrawerCubit>().load();
                      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                    }

                    final cubit = context.read<DrawerCubit>();
                    final items = cubit.items;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // top close & spacing
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: AppColor.secondaryColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),

                        // menu content
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 6),
                                ...items.map((it) => _buildRow(context, it, cubit)),

                                const SizedBox(height: 12),

                                _themeSwitcher(context),

                                const SizedBox(height: 18),
                                // footer logo
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/logo with out background.png',
                                        height: 64,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text("Since 2014 منذ", style: TextStyle(color: AppColor.black54)),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRow(BuildContext context, DrawerItemModel it, DrawerCubit cubit) {
    final bool hasChildren = (it.children?.isNotEmpty ?? false);
    final bool expanded = cubit.expanded.contains(it.id);

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (hasChildren) {
              cubit.toggle(it.id);
            } else {
              Navigator.of(context).pop();
              cubit.select(it.id,context);


            }
          },
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColor.borderExtraSoft, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // right: icon inside bubble
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:  AppColor.borderExtraSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(it.icon, color:  AppColor.secondaryColor),
                ),

                // center: title
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      it.title,
                      style: const TextStyle(
                        color: AppColor.mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // left: chevron or nothing
                hasChildren
                    ? Transform.rotate(
                  angle: expanded ? 3.14 / 2 : 0,
                  child:  Icon((context.locale.languageCode == 'en' ) ?  Icons.keyboard_arrow_right: Icons.keyboard_arrow_left, color: AppColor.black54),
                )
                    : const SizedBox(width: 24),
              ],
            ),
          ),
        ),

        // children
        if (hasChildren && expanded)
          Column(
            children: it.children!.map((c) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  cubit.select(c.id,context);


                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  alignment: Alignment.centerRight,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColor.gray100, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:  AppColor.borderExtraSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(c.icon, color:  AppColor.mainColor, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          c.title,
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColor.black87, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
Widget _themeSwitcher(BuildContext context) {
  return BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, themeMode) {
      final isDark = themeMode == ThemeMode.dark;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:  AppColor.borderExtraSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color:  AppColor.secondaryColor,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                isDark ? 'dark_mode'.tr() : 'light_mode'.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColor.mainColor,
                ),
              ),
            ),

            ColoredBox(
              color: isDark ?  AppColor.tintSoft:  AppColor.tintSoft  ,

              child: Switch(
                value: isDark,
                inactiveThumbColor:   AppColor.mainColor,
                inactiveTrackColor: AppColor.tintSoft,
                activeTrackColor:  AppColor.mainColor,
                activeThumbColor:  AppColor.tintSoft,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (_) {
                  Navigator.of(context).pop();

                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}