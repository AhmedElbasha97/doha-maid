import 'package:dohamaid/core/utils/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../loader.dart';
import '../../../widget/no_data_widget.dart';
import '../../drawer/cubit/drawer_cubit.dart';
import '../../drawer/presentation/drawer_screen.dart';
import '../cubit/location_list_cubit.dart';
import '../cubit/booking_list_state.dart';
import '../data/location_list_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

class LocationListScreen extends StatelessWidget {
  const LocationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationListCubit()..getBookingList(),
      child: Scaffold(
        appBar: AppBar(
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
        body: Container(
          color:  AppColor.surfaceLight,
          child: BlocBuilder<LocationListCubit, LocationListState>(
            builder: (context, state) {
              if (state is LocationListLoading) {
                return const Loader();
              }

              if (state is LocationListError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state is LocationListLoaded) {
                if (state.locationListResponse.data?.isEmpty ?? true) {
                  return NoDataWidget();
                }

                return SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.locationListResponse.data?.length??0,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (_, index) =>
                              _LocationCard(item: state.locationListResponse.data?[index]??LocationListItem()),
                        ),
                      ),


                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.item});

  final LocationListItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LocationMapPreview(item: item),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Text(
                item.address??"",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColor.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                '${"street_number".tr()}: ${item.streetNo}'+
                    '- ${"region_name".tr()}: ${item.region}'+
                    '- ${"region_no".tr()}: ${item.regionNo}'+
                    ' - ${"building_no".tr()}: ${item.buildingNo}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColor.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),

            ],
          ),
        ],
      ),
    );
  }
}

class _LocationMapPreview extends StatelessWidget {
  const _LocationMapPreview({required this.item});

  final LocationListItem item;

  @override
  Widget build(BuildContext context) {
    if (!item.hasValidCoordinates) {
      return _fallbackMapPlaceholder();
    }

    final latLng = LatLng(item.latitude!, item.longitude!);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: SizedBox(
        width: double.infinity,
        height: screenHeight(context) * 0.15,
        child: IgnorePointer(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: latLng, zoom: 14),
            markers: {
              Marker(
                markerId: MarkerId('booking-${item.streetNo}'),
                position: latLng,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
              ),
            },
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            liteModeEnabled: true,
          ),
        ),
      ),
    );
  }

  Widget _fallbackMapPlaceholder() {
    return Container(
      width: 98,
      height: 98,
      decoration: BoxDecoration(
        color:  AppColor.locationChipBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.location_on, color: AppColor.locationIcon, size: 32),
    );
  }
}