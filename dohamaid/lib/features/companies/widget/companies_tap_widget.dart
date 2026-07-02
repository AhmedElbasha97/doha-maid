// ignore_for_file: deprecated_member_use

import 'package:dohamaid/core/data/datasources/storage_local_data_source.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/presentation/cubit/localization_cubit.dart';
import '../worker_companies/data/worker_companies_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

class CompaniesTapWidget extends StatelessWidget {
  const CompaniesTapWidget({super.key, required this.company, required this.onTap,});
  final WorkerCompanyData? company;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color:  AppColor.companyBorderColors, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
          flex: 2,
          child: Hero(
            tag: 'product_${company?.id}',
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: company?.thumb ?? "",
              imageBuilder: ((context, image) {
                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: image,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              placeholder: (context, image) {
                return Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color:  AppColor.cardSoft,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacity(0.1),
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 13.0,
                        spreadRadius: 2.0,
                      ),
                      BoxShadow(
                        color: AppColor.white.withOpacity(0.2),
                        offset: const Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Center(
                    child:  Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color:  AppColor.borderSoft,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(
                      duration: 1200.ms,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                  duration: 1200.ms,
                  color: Theme.of(context).colorScheme.background,
                );
              },
              errorWidget: (context, url, error) {
                return SizedBox(
                  height: 110,
                  width: 110,
                  child: Image.asset(
                    "assets/logo with out background.png",
                    fit: BoxFit.fitHeight,
                  ),
                );
              },
            ),
          ),
        ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company?.name??"",
                  style:  TextStyle(
                    fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                    fontSize: 18,
                    color: AppColor.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${company?.workers} ${"worker_suffix".tr()}",

                  style:  TextStyle(
                    fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                    fontSize: 14,
                    color: AppColor.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: StorageLocalDataSource.instance.getSavedLocaleCode() == "en"?Alignment.centerRight:Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap:onTap,

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:  AppColor.companyBorderColors,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  Text(
                            "more_button".tr(),
                            style:  TextStyle(
                              fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                              color: AppColor.white,
                              fontSize: 14,
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

          // IMAGE

        ],
      ),
    );
  }
}
