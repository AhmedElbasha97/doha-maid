import 'package:dohamaid/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import '../../../../widget/no_data_widget.dart';
import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import '../../../webview/web_view.dart';
import '../../company_details/presentation/company_details_screen.dart';
import '../../widget/companies_more_data_loader.dart';
import '../../widget/companies_tap_widget.dart';
import '../cubit/nursing_companies_cubit.dart';
import '../cubit/nursing_companies_state.dart';
import 'package:dohamaid/core/config/app_color.dart';




class NursingCompaniesScreen extends StatefulWidget {
  const NursingCompaniesScreen({super.key});

  @override
  State<NursingCompaniesScreen> createState() => _NursingCompaniesScreenState();
}

class _NursingCompaniesScreenState extends State<NursingCompaniesScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    final cubit = context.read<NursingCompaniesCubit>();
    cubit.loadNursingCompanies(controller);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        cubit.loadMore(context);
      }
    });
  }
  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar:AppBar(
        backgroundColor:  AppColor.appBarBackground,
        elevation: 3,
        title: Image.asset(
          "assets/logo with out background.png",
          scale: 4.5,
        ),
        centerTitle: true,
        leading:IconButton(
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
        ),
        actions:[IconButton(onPressed: (){
          Navigator.maybePop(context);
        }, icon: const Icon(Icons.arrow_forward_ios, color:  AppColor.mainColor)) ],
      ),

      body: BlocBuilder<NursingCompaniesCubit, NursingCompaniesState>(
        builder: (context, state) {

          if (state is NursingCompaniesLoading) {
            return const Loader();
          }

          if (state is NursingCompaniesError) {
            return Center(child: Text(state.message));
          }

          if (state is NursingCompaniesLoaded || state is NursingCompaniesLoadingMore) {
            final cubit = context.read<NursingCompaniesCubit>();
            if (cubit.nursingCompanies?.isEmpty??true) {
              return const NoDataWidget();
            } else {
              return SafeArea(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: (cubit.nursingCompanies?.length ?? 0) +
                    (cubit.hasMore? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == cubit.nursingCompanies?.length) {
                    return const CompaniesMoreDataLoader();
                  }

                  final item = cubit.nursingCompanies?[index];

                  return AnimatedBuilder(
                    animation: controller,
                    builder: (_, child) {
                      return Opacity(
                        opacity: cubit.fadeAnimations[index].value,
                        child: Transform.translate(
                          offset: cubit.slideAnimations[index].value * 50,
                          child: child,
                        ),
                      );
                    },
                    child: CompaniesTapWidget(company: item, onTap: () {

                        if (cubit.activateWebViewUrls == 0) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                CompanyDetailsScreen(companyId: item?.id ?? 0,),
                            settings: const RouteSettings(
                                name: "CompanyDetailsScreen"),));
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WebViewContainer(item?.url ?? ""),
                              settings: const RouteSettings(
                                  name: "WebViewContainer"),),
                          );
                        }
                      }
                    ,),
                  );
                },
              ),
            );
          }
          }

          return const SizedBox();
        },
      ),
    );
  }


}