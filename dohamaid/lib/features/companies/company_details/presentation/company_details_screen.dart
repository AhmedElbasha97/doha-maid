// ignore_for_file: deprecated_member_use

import 'package:dohamaid/features/companies/company_details/widget/product_image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../../core/presentation/cubit/localization_cubit.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../loader.dart';
import '../../../../widget/no_data_widget.dart';
import '../../../auth/sign_in/presentation/log_in_screen.dart';
import '../../../auth/sign_up/presentation/regestier_screen.dart';
import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import '../cubit/company_details_cubit.dart';
import '../widget/cleaning_services_tap.dart';
import 'package:dohamaid/core/config/app_color.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final int companyId;
  final bool? comingFromCleaningCompanies;
  const CompanyDetailsScreen({super.key, required this.companyId,  this.comingFromCleaningCompanies = false});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen>
    with TickerProviderStateMixin {
  late CompanyDetailsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<CompanyDetailsCubit>();

    cubit.initAnimation(this);
    cubit.loadCompanyDetailsData(widget.companyId, widget.comingFromCleaningCompanies);
  }
  CarouselSliderController carouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  AppColor.appBarBackground,
        elevation: 3,
        title: Image.asset(
          "assets/logo with out background.png",
          scale: 4.5,
        ),
        centerTitle: true,
        leading:IconButton(onPressed: (){
          Navigator.maybePop(context);
        }, icon: const Icon(Icons.arrow_back_ios, color:  AppColor.mainColor)),
        actions:[ IconButton(
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

            }
        )],
      ),

      body: SafeArea(
        child: BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
          builder: (context, state) {

            if (state is CompanyDetailsLoading) {
              return const Loader();
            }

            if (state is CompanyDetailsError) {
              return Center(child: Text(state.message, style: const TextStyle(color: AppColor.red)));
            }

            if (state is CompanyDetailsLoaded) {
              final data = state.model;

              if (data?.data == null) {
                return const NoDataWidget();
              } else {
                return AnimatedBuilder(
                animation: cubit.animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: cubit.fadeAnimation.value,
                    child: Transform.translate(
                      offset: cubit.slideAnimation.value * 40,
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      /// Carousel Slider
                      CarouselSlider.builder(
                        carouselController: carouselController,


                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        itemCount: data?.data?.images?.length,
                        itemBuilder: (BuildContext context, int index,
                            int realIndex) {
                          return ProductImageWidget(
                            imageUrl: data?.data?.images?[index],
                            activeIndex: index,
                            imageTotalCount: "${data?.data?.images?.length}",
                            imagesLink: data?.data?.images,);
                        },
                      ),

                      const SizedBox(height: 20),

                      /// Name
                      Text(
                        data?.data?.name??"",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text("company_details_phone_label".tr(),
                                        style:  TextStyle(
                                            fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                       )),
                                Expanded(
                                  flex: 3,
                                  child:
                                  callButton(context.read<LocalizationCubit>().isArabic()?"يتصل":"call"),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text("company_details_whatsapp_label".tr(),
                                        style: TextStyle(
                                            fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                       )),
                                Expanded(
                                  flex: 3,
                                  child:
                                  whatsappButton(context.read<LocalizationCubit>().isArabic()?"واتساب":"Whats App"),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text("company_details_email_label".tr(),
                                        style: TextStyle(
                                            fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                       )),
                                Expanded(
                                  flex: 12,
                                  child:
                                  emailButton( context.read<LocalizationCubit>().isArabic()? "أرسل بريدًا إلكترونيًا":"Send an email"),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Info box

                      _infoBox("company_details_address_title".tr(), data?.data?.address??""),
                      _infoBox("company_details_country_title".tr(), data?.data?.country?.name??""),
                      _infoBox("company_details_type_title".tr(), data?.data?.type?.name??""),
                     widget.comingFromCleaningCompanies == false?const SizedBox(): Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                          Text(
                          "${"cleaningServices".tr()}: ",
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                            cubit.companyDetails?.data?.services?.isEmpty??true? Center(
                              child: Text("cleaningServicesNotAvailable".tr() , style: const TextStyle(
                                color: AppColor.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),),
                            ): Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                children:cubit.companyDetails!.data!.services!.map((e) {
                                  return CleaningServicesTap(companyServices: e, onTap: () {  },);
                                },
                              ).toList(),
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

            return const SizedBox();
          },
        ),
      ),
    );
  }
  Widget emailButton(String email) {
    return GestureDetector(
      onTap: (){
        if(StorageLocalDataSource.instance.userSignedIn()) {
          cubit.sendEmail(email);
        }else{
          cubit.showSignInSignUpDialog(context: context,onSignIn: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                  settings: const RouteSettings(name: "LoginScreen"),));

          },
          onSignUp: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegisterScreen(),
                  settings: const RouteSettings(name: "RegisterScreen"),) );
          });
        }
        },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              AppColor.actionBlue, // Google blue
              AppColor.actionBlueDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color:  AppColor.actionBlue.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.email_outlined, size: 22, color: AppColor.white),
            const SizedBox(width: 12),
             SizedBox(
              width: screenWidth(context) * 0.4,
               child: Text(
                email,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColor.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                           ),
             ),
          ],
        ),
      ),
    );
  }
  Widget _infoBox(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text("$title:",
                  style:  TextStyle(
                      fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                      fontSize: 16, fontWeight: FontWeight.bold), )),
          Expanded(
              child:
              Text(value, style:  TextStyle(
                  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                  fontSize: 16), textAlign: TextAlign.right)),

        ],
      ),
    );
  }
  Widget whatsappButton(String phone) {
    return GestureDetector(
        onTap: (){
          if(StorageLocalDataSource.instance.userSignedIn()) {
          cubit.openWhatsApp(phone);
          }else{
            cubit.showSignInSignUpDialog(context: context,
            onSignUp:
                (){
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
            },

            );
          }
        },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              AppColor.actionWhatsapp, // WhatsApp green
              AppColor.actionTealDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color:  AppColor.actionWhatsapp.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             const Icon(Icons.message, color: AppColor.white, size: 24),
            const SizedBox(width: 12),
            Text(
              phone,
              style:  TextStyle(
                fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                color: AppColor.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget callButton(String phone) {
    return GestureDetector(
      onTapDown: (_) {},
      onTapCancel: () {},
        onTap: (){
          if(StorageLocalDataSource.instance.userSignedIn()) {
          cubit.makeCall(phone);
          }else{
            cubit.showSignInSignUpDialog(context: context,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              AppColor.actionGreen,
              AppColor.actionGreenDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.green.withOpacity(0.35),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.call, color: AppColor.white, size: 24),
            const SizedBox(width: 9),
            Text(
              phone,
              style:  TextStyle(
                fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                color: AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
