import 'package:easy_localization/easy_localization.dart' show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_color.dart';
import '../../../core/presentation/cubit/localization_cubit.dart';


class CompaniesSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCleared;
  final String? hintKey;
  const CompaniesSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCleared,
    this.hintKey,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LocalizationCubit>().isArabic();
    final font = isArabic ? 'Cairo' : 'Montserrat';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: TextField(
        controller: controller,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        onChanged: onChanged,
        style: TextStyle(fontFamily: font, fontSize: 14),
        decoration: InputDecoration(
          hintText: (hintKey ?? 'search_hint'). tr(),
          hintStyle: TextStyle(
            fontFamily: font,
            color: AppColor.black87.withOpacity(0.45),
          ),
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColor.mainColor),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColor.mainColor, size: 20),
                onPressed: () {
                  controller.clear();
                  onCleared();
                },
              );
            },
          ),
          filled: true,
          fillColor: AppColor.cardSoft,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColor.mainColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
