import 'package:dohamaid/features/companies/worker_companies/presentation/worker_companies_screen.dart';
import 'package:dohamaid/features/webview/web_view.dart';
import 'package:dohamaid/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import '../../companies/anti_bug_companies/presentaion/anti_bug_companies_screen.dart';
import '../../companies/cleaning_companies/presentation/cleaning_companies_screen.dart';
import '../../companies/nursing_companies/presentation/nursing_companies_screen.dart';
import '../../companies/worker_suppliers/presentation/worker_suppliers_screen.dart';
import '../../drawer/cubit/drawer_cubit.dart';
import '../../drawer/presentation/drawer_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widget/home_tap_widget.dart';
import 'package:dohamaid/core/config/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeCubit cubit;
  late AnimationController controller;

  final GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    cubit = context.read<HomeCubit>();
    cubit.loadHomeData(controller);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColor.red, fontSize: 18),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildMainView(state),
        );
      },
    );
  }

  PreferredSizeWidget  _buildAppBar() {
    return AppBar(
      backgroundColor:  AppColor.appBarBackground,
      elevation: 3,
      title: Image.asset(
        "assets/logo with out background.png",
        scale: 4.5,
      ),
      centerTitle: true,
actions: const [SizedBox()],
      leading: IconButton(
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

    );
  }

  Widget _buildMainView(HomeState state) {
    if (state is HomeLoading) {
      return const Loader();
    }

    if (state is! HomeLoaded) {
      return const SizedBox();
    }

    return SafeArea(
      child: Column(
        children: [

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.homeData.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: cubit.fadeAnimations[index].value,
                      child: Transform.translate(
                        offset: cubit.slideAnimations[index].value * 50,
                        child: child,
                      ),
                    );
                  },
                  child:   HomeTapWidget(
                    title: state.homeData[index].name ?? "",
                    icon: cubit.icons[index],
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WorkerCompaniesScreen(),
                              settings: const RouteSettings(name: "WorkerCompaniesScreen"),
                          ),
                        );
                      }else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CleaningCompaniesScreen(),
                              settings: const RouteSettings(name: "CleaningCompaniesScreen"),
                          ),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AntiBugCompaniesScreen(),
                              settings: const RouteSettings(name: "AntiBugCompaniesScreen"),)
                        );} else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NursingCompaniesScreen(),
                              settings: const RouteSettings(name: "NursingCompaniesScreen"),)
                        );} else if (index == 4) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WorkerSuppliersScreen(),
                              settings: const RouteSettings(name: "WorkerSuppliersScreen"),),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewContainer(state.homeData[index].url??""),
                            settings: const RouteSettings(name: "WebViewContainer"),),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
