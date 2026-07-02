// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/app_color.dart';
import '../../../../../core/presentation/cubit/localization_cubit.dart';

import '../data/cleaning_services_model.dart';

class CleaningServiceCard extends StatelessWidget {
  final CleaningServiceItem item;
  final VoidCallback onTap;

  const CleaningServiceCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<LocalizationCubit>().isArabic();
    final font = isArabic ? 'Cairo' : 'Montserrat';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.companyBorderColors, width: 2),
      ),
      child: Row(
        children: [
          // ── Thumbnail ────────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: CachedNetworkImage(
              imageUrl: item.thumb ?? '',
              imageBuilder: (context, image) => ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: image, fit: BoxFit.cover),
                  ),
                ),
              ),
              placeholder: (_, __) => Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: AppColor.cardSoft,
                  borderRadius: BorderRadius.circular(15),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                      duration: 1200.ms,
                      color: Theme.of(context).colorScheme.background),
              errorWidget: (_, __, ___) => SizedBox(
                height: 110,
                width: 110,
                child: Image.asset(
                  'assets/logo with out background.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),

          // ── Info ─────────────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service name
                  Text(
                    item.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Company name
                  Row(
                    children: [
                      Icon(Icons.business_outlined,
                          size: 14, color: AppColor.mainColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.companyName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: font,
                            fontSize: 13,
                            color: AppColor.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price badge
                  Align(
                      alignment: Alignment.centerRight,
                      child: _PriceBadge(item: item, font: font)),

                  const SizedBox(height: 8),

                  // More button
                  Align(
                    alignment: Alignment.centerRight,

                    child: InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.companyBorderColors,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'more_button'.tr(),
                          style: TextStyle(
                            fontFamily: font,
                            color: AppColor.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final CleaningServiceItem item;
  final String font;
  const _PriceBadge({required this.item, required this.font});

  @override
  Widget build(BuildContext context) {
    if (!item.hasPriceInfo) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: AppColor.mainColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'contact_for_price'.tr(),
          style: TextStyle(
            fontFamily: font,
            fontSize: 11,
            color: AppColor.mainColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.companyBorderColors.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${item.parsedPrice!.toStringAsFixed(0)} ${'currency'.tr()}',
        style: TextStyle(
          fontFamily: font,
          fontSize: 13,
          color: AppColor.companyBorderColors,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
