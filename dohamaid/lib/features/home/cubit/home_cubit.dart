import 'package:dohamaid/core/services/home_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/data/datasources/api_service.dart';
import '../data/model/home_model.dart';
import '../presentation/home_screen.dart';
import 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  late AnimationController controller;

  late List<Animation<double>> fadeAnimations;
  late List<Animation<Offset>> slideAnimations;

   List<String> titles = [];

  final List<String> icons = [
    "assets/icons/1.png",
    "assets/icons/2.png",
    "assets/icons/2.png",
    "assets/icons/5.png",
    "assets/icons/6.png",
    "assets/icons/1.png",
    "assets/icons/2.png",
    "assets/icons/3.png",
    "assets/icons/4.png",
    "assets/icons/5.png",
    "assets/icons/6.png",
    "assets/icons/7.png",
    "assets/icons/2.png",
    "assets/icons/3.png",
    "assets/icons/4.png",
    "assets/icons/5.png",
    "assets/icons/6.png",
    "assets/icons/7.png",
    "assets/icons/1.png",
    "assets/icons/2.png",
    "assets/icons/2.png",
    "assets/icons/5.png",
    "assets/icons/6.png",
    "assets/icons/1.png",
    "assets/icons/2.png",
    "assets/icons/1.png",
    "assets/icons/2.png",
    "assets/icons/3.png",
    "assets/icons/4.png",
    "assets/icons/5.png",
    "assets/icons/6.png",
    "assets/icons/7.png",
  ];
  List<Datum> homeData = [];

  void resetState(  BuildContext context) {
   _navigateIfNotOpen(context, screen: const HomeScreen(), routeName: "HomeScreen");
  }
  bool isScreenAlreadyOpen(BuildContext context, Type screenType) {
    bool isOpen = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == "$screenType") {
        isOpen = true;
      }
      return true;
    });

    return isOpen;
  }
  void _navigateIfNotOpen(
      BuildContext context, {
        required Widget screen,
        required String routeName,
      }) {
    if (isScreenAlreadyOpen(context, screen.runtimeType)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
          settings: RouteSettings(name: routeName),
        ),
      );
    }
  }
  /// -------------------------
  /// LOAD DATA (Fake Example)
  /// -------------------------
  Future<void> loadHomeData(AnimationController ctrl) async {
   controller = ctrl;
   homeData.clear();
   titles =  [
     "company_home".tr(),
     "company_home1".tr(),
     "company_home2".tr(),
     "company_home3".tr(),
     "company_home4".tr(),
     "company_home5".tr(),
   ];
    try {
      emit(HomeLoading());

     HomeModel? data = await HomeServices(ApiService()).getAllHomeTaps();
    var homeTapFixedData = [
         Datum(id: 18,name: titles[5],active: 1,url: "cleaning services"),
    Datum(id: 1,name: titles[0],active: 1,url: "WorkerCompaniesScreen"),
    Datum(id: 2,name: titles[1],active: 1,url: "CleaningCompaniesScreen"),
    Datum(id: 3,name: titles[2],active: 1,url: "AntiBugCompaniesScreen"),
    Datum(id:4,name: titles[3],active: 1,url: "NursingCompaniesScreen"),
    Datum(id: 8,name: titles[4],active: 1,url: "WorkerSuppliersScreen")];
    List<Datum> homeListAfterChecking = [];
    for(var homeTap in homeTapFixedData){
      bool? checker = await homeTapChecker("${homeTap.id??0}");
      if(checker??false){
        homeListAfterChecking.add(Datum(
          id: homeTap.id,
          name: homeTap.name,
          active: 1,
          url: homeTap.url
        ));
      }else{
        homeListAfterChecking.add(Datum(
            id: homeTap.id,
            name: homeTap.name,
            active: 0,
            url: homeTap.url
        ));
      }
    }
     if(data?.data == []){
       homeData.clear();
       for(Datum? homeTap in (homeListAfterChecking) ) {
         if (homeTap?.active == 1) {
           homeData.add(homeTap!);
         }
       }
     }else{
       homeData.clear();
       if(homeListAfterChecking[0].active == 1) {
         homeData.add(homeListAfterChecking[0],);
       }
       for(Datum? homeTap in (data!.data!) ) {
         if (homeTap?.active == 1) {
           homeData.add(homeTap!);
         }


       }
       homeListAfterChecking.removeAt(0);
       for(Datum? homeTap in (homeListAfterChecking) ) {
         if (homeTap?.active == 1) {
           homeData.add(homeTap!);
         }
       }

     }
      _createAnimations(homeData.length);
      emit(HomeLoaded(homeData));
      ctrl.forward();
    } catch (e) {
      emit(HomeError("Failed to load data"));
    }
  }
  Future<bool?> homeTapChecker(String? homeTapId) async {
   try{
     bool? data = await HomeServices(ApiService()).checkAllHomeTaps(homeTapId);
     return data;
   }catch (e){
     emit(HomeError("Failed to load data"));
   }
   return null;
  }
  void _createAnimations(int count) {
    fadeAnimations = List.generate(
      count,
          (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(i * 0.1, 1, curve: Curves.easeOut),
        ),
      ),
    );

    slideAnimations = List.generate(
      count,
          (i) => Tween<Offset>(
        begin: const Offset(0, .3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(i * 0.1, 1, curve: Curves.easeOut),
        ),
      ),
    );
  }
  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
