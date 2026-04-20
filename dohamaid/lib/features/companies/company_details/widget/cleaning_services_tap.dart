// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../auth/sign_in/presentation/log_in_screen.dart';
import '../../../auth/sign_up/presentation/regestier_screen.dart';
import '../../booking_screens/presentation/booking_screen.dart';
import '../cubit/company_details_cubit.dart';
import '../data/company_detail_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

class CleaningServicesTap extends StatelessWidget {
  const CleaningServicesTap({super.key, required this.companyServices, required this.onTap,});
  final Service? companyServices;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color:  AppColor.secondaryColor, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Hero(
              tag: 'product_${companyServices?.workerId}',
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: companyServices?.thumb ?? "",
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
                  companyServices?.name??"",
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColor.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${companyServices?.price} ${"currencyQAR".tr()}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: StorageLocalDataSource.instance.getSavedLocaleCode() == "en"?Alignment.centerRight:Alignment.centerLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(StorageLocalDataSource.instance.userSignedIn()) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  BookingScreen(servicesId: companyServices?.workerId??""),
                              settings: const RouteSettings(
                                  name: "BookingScreen"),));
                          }else{
                            context.read<CompanyDetailsCubit>().showSignInSignUpDialog(context: context,
                                onSignUp: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                    settings: const RouteSettings(name: "RegisterScreen"),) );
                            },
                                onSignIn: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                    settings: const RouteSettings(name: "LoginScreen"),) );
                            });
                          }

                        },
                        child: Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:  AppColor.secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  Text(
                            "reservationOfServices".tr(),
                            maxLines: 2,
                            style: const TextStyle(
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