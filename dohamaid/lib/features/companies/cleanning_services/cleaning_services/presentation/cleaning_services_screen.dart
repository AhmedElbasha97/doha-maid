import 'package:dohamaid/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/app_color.dart';
import '../../../../../core/data/datasources/storage_local_data_source.dart';
import '../../../../../widget/no_data_widget.dart';
import '../../../../auth/sign_in/presentation/log_in_screen.dart';
import '../../../../auth/sign_up/presentation/regestier_screen.dart';
import '../../../../drawer/cubit/drawer_cubit.dart';
import '../../../../drawer/presentation/drawer_screen.dart';

import '../../../booking_screens/presentation/booking_screen.dart';
import '../../../company_details/cubit/company_details_cubit.dart';
import '../../../widget/companies_more_data_loader.dart';

import '../cubit/cleaning_services_cubit.dart';
import '../cubit/cleaning_services_state.dart';
import '../widget/cleaning_service_card.dart';
import '../widget/companies_search_bar.dart';

class CleaningServicesScreen extends StatefulWidget {
  const CleaningServicesScreen({super.key});

  @override
  State<CleaningServicesScreen> createState() =>
      _CleaningServicesScreenState();
}

class _CleaningServicesScreenState extends State<CleaningServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final cubit = context.read<CleaningServicesCubit>();
    cubit.loadServices(_animCtrl);

    // ── Scroll-aware pagination ───────────────────────────────────────────
    // We only request the next page when the user has actually scrolled
    // close to the end of the currently loaded items — this guarantees
    // pagination only returns data the user has reached.
    _scrollCtrl.addListener(() {
      final pos = _scrollCtrl.position;
      if (pos.pixels >= pos.maxScrollExtent - 250) {
        cubit.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColor.appBarBackground,
      appBar: AppBar(
        backgroundColor: AppColor.appBarBackground,
        elevation: 3,
        title: Image.asset('assets/logo with out background.png', scale: 4.5),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColor.mainColor),
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'drawer',
              pageBuilder: (ctx, a1, a2) => BlocProvider(
                create: (_) => DrawerCubit()..load(),
                child: const CustomDrawer(),
              ),
              transitionBuilder: (ctx, anim, _, child) =>
                  FadeTransition(opacity: anim, child: child),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_forward_ios,
                color: AppColor.mainColor),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────────────
          CompaniesSearchBar(
            controller: _searchCtrl,
            hintKey: 'search_services_hint',
            onChanged: (q) =>
                context.read<CleaningServicesCubit>().search(q),
            onCleared: () =>
                context.read<CleaningServicesCubit>().search(''),
          ),

          // ── List ───────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<CleaningServicesCubit, CleaningServicesState>(
              builder: (context, state) {
                // ── Loading (first load) ─────────────────────────────────
                if (state is CleaningServicesLoading) {
                  return const Loader();
                }

                // ── Error ────────────────────────────────────────────────
                if (state is CleaningServicesError) {
                  return Center(child: Text(state.message));
                }

                // ── Loaded / LoadingMore ─────────────────────────────────
                if (state is CleaningServicesLoaded ||
                    state is CleaningServicesLoadingMore) {
                  final cubit = context.read<CleaningServicesCubit>();

                  final List<dynamic> displayed;
                  if (state is CleaningServicesLoaded) {
                    displayed = state.displayedItems;
                  } else {
                    displayed = (state as CleaningServicesLoadingMore)
                        .displayedItems;
                  }

                  if (displayed.isEmpty) return const NoDataWidget();

                  final showLoader = state is CleaningServicesLoadingMore ||
                      (state is CleaningServicesLoaded && state.hasMore);

                  return SafeArea(
                    child: ListView.builder(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: displayed.length + (showLoader ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Loader row at the very bottom
                        if (index == displayed.length) {
                          return const CompaniesMoreDataLoader();
                        }

                        final item =
                            displayed[index] as dynamic; // CleaningServiceItem

                        // Safe animation index guard
                        final animIdx =
                            index.clamp(0, cubit.fadeAnimations.length - 1);
                        final hasFade = cubit.fadeAnimations.isNotEmpty;

                        return AnimatedBuilder(
                          animation: _animCtrl,
                          builder: (_, child) => Opacity(
                            opacity:
                                hasFade ? cubit.fadeAnimations[animIdx].value : 1.0,
                            child: Transform.translate(
                              offset: hasFade
                                  ? cubit.slideAnimations[animIdx].value * 50
                                  : Offset.zero,
                              child: child,
                            ),
                          ),
                          child: CleaningServiceCard(
                            item: item,
                            onTap: () {
                              if(StorageLocalDataSource.instance.userSignedIn()) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      BookingScreen(servicesId:"${item?.workerId??0}"),
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
                          ),
                        );
                      },
                    ),
                  );
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
