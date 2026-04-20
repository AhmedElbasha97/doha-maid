import 'package:flutter/material.dart';
import 'package:dohamaid/core/config/app_color.dart';

Widget buildButton(BuildContext context,
    {required String text, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:  AppColor.mainColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.white),
      ),
    ),
  );
}
