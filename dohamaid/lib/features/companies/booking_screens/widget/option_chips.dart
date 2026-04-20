import 'package:dohamaid/core/config/app_color.dart';
import 'package:flutter/material.dart';

import '../data/booking_category_model.dart';

class OptionChips extends StatelessWidget {
  const OptionChips({
    super.key,
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final Datum? option;
  final bool selected;
  final ValueChanged<Datum?> onSelect;

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: selected ?  AppColor.mainColor : AppColor.gray100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onSelect(option),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              option?.name??"",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? AppColor.white : AppColor.textPrimaryDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
