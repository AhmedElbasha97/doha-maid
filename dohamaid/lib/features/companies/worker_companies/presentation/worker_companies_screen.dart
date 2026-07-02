import  'package:dohamaid/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widget/no_data_widget.dart';
import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import '../../../webview/web_view.dart';
import '../../company_details/presentation/company_details_screen.dart';
import '../../widget/companies_more_data_loader.dart';
import '../../widget/companies_tap_widget.dart';
import '../cubit/worker_companies_cubit.dart';
import '../cubit/worker_companies_states.dart';
import 'package:dohamaid/core/config/app_color.dart';
import '../../widget/companies_search_bar.dart';


class WorkerCompaniesScreen extends StatefulWidget {
  const WorkerCompaniesScreen({super.key});

  @override
  State<WorkerCompaniesScreen> createState() => _WorkerCompaniesScreenState();
}

class _WorkerCompaniesScreenState extends State<WorkerCompaniesScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    final cubit = context.read<WorkerCompaniesCubit>();
    cubit.loadWorkerCompanies(controller);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {

        cubit.loadMore(context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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

            }        ),
        actions:[IconButton(onPressed: (){
          Navigator.maybePop(context);
        }, icon: const Icon(Icons.arrow_forward_ios, color:  AppColor.mainColor)) ],
      ),

      body: Column(
        children: [
          CompaniesSearchBar(
            controller: _searchCtrl,
            hintKey: 'search_companies_hint',
            onChanged: (q) => context.read<WorkerCompaniesCubit>().search(q,context),
            onCleared: () => context.read<WorkerCompaniesCubit>().search('',context),
          ),
          Expanded(
            child: BlocBuilder<WorkerCompaniesCubit, WorkerCompaniesState>(
              builder: (context, state) {

          if (state is WorkerCompaniesLoading) {
            return const Loader();
          }

          if (state is WorkerCompaniesError) {
            return Center(child: Text(state.message));
          }

          if (state is WorkerCompaniesLoaded || state is WorkerCompaniesLoadingMore) {
            final cubit = context.read<WorkerCompaniesCubit>();
            final displayed = (state is WorkerCompaniesLoaded
                ? state.displayedCompanies
                : (state as WorkerCompaniesLoadingMore).displayedCompanies) ??
                cubit.workerCompanies ??
                [];
           if (displayed.isEmpty) {
              return const NoDataWidget();
            } else {
              return   SafeArea(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: (displayed.length) +
                    (cubit.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayed.length&&cubit.isLoadingMore ) {
                    return const CompaniesMoreDataLoader();
                  }

                  final item = displayed[index];

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

                    },),
                  );
                },
              ),
            );
          }
          }

          return const SizedBox.shrink();
        },
      ),
      ),
        ],
    ),
    );

  }


}

