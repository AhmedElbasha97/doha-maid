// ============================================================
//  booking_list_screen.dart
// ============================================================

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dohamaid/core/utils/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/presentation/cubit/localization_cubit.dart';
import '../../../loader.dart';
import '../../../widget/no_data_widget.dart';
import '../../drawer/cubit/drawer_cubit.dart';
import '../../drawer/presentation/drawer_screen.dart';
import '../cubit/booking_list_cubit.dart';
import '../cubit/booking_list_state.dart';
import '../data/booking_list_model.dart';
import 'package:dohamaid/core/config/app_color.dart';

/// Statuses for which the Cancel button is hidden — adjust this list to
/// match whatever exact strings your API returns for finalized bookings.
const List<String> _kNonCancellableStatuses = [
  'cancelled',
  'canceled',
  'completed',
  'rejected',
];

extension _BookingCancelable on BookingListItem {
  bool get isCancellable =>
      !_kNonCancellableStatuses.contains(status.toLowerCase().trim());
}

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  // ── AwesomeDialog helpers ─────────────────────────────────────────────

  void _showSuccessDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'success'.tr(),
      desc: message,
      btnOkText: 'ok'.tr(),
      btnOkColor: AppColor.mainColor,
      btnOkOnPress: () {},
    ).show();
  }

  void _showNotAllowedDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'cannotCancelTitle'.tr(),
      desc: 'cannotCancelMessage'.tr(),
      btnOkText: 'ok'.tr(),
      btnOkColor: AppColor.mainColor,
      btnOkOnPress: () {},
    ).show();
  }

  void _showErrorDialog(BuildContext context, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'error'.tr(),
      desc: message,
      btnOkText: 'ok'.tr(),
      btnOkColor: AppColor.mainColor,
      btnOkOnPress: () {},
    ).show();
  }

  /// Confirmation step before actually calling the cancel flow —
  /// good UX practice so a misclick doesn't cancel a booking outright.
  Future<bool> _confirmCancelIntent(BuildContext context) async {
    bool confirmed = false;

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'cancelReservationTitle'.tr(),
      desc: 'cancelReservationConfirm'.tr(),
      btnCancelText: 'no'.tr(),
      btnOkText: 'yesCancel'.tr(),
      btnCancelOnPress: () {},
      btnOkOnPress: () => confirmed = true,
    ).show();

    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingListCubit()..getBookingList(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appBarBackground,
          elevation: 3,
          title: Image.asset(
            "assets/logo with out background.png",
            scale: 4.5,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppColor.mainColor),
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'drawer',
                pageBuilder: (ctx, anim1, anim2) {
                  return BlocProvider(
                    create: (_) => DrawerCubit()..load(),
                    child: const CustomDrawer(),
                  );
                },
                transitionBuilder: (ctx, anim, secAnim, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.arrow_forward_ios, color: AppColor.mainColor),
            ),
          ],
        ),
        body: Container(
          color: AppColor.surfaceLight,
          child: BlocConsumer<BookingListCubit, BookingListState>(
            listenWhen: (prev, curr) =>
                curr is ShowCancelSuccessDialog ||
                curr is ShowCancelNotAllowedDialog ||
                curr is ShowCancelErrorDialog,
            listener: (context, state) {
              if (state is ShowCancelSuccessDialog) {
                _showSuccessDialog(context, state.message);
              } else if (state is ShowCancelNotAllowedDialog) {
                _showNotAllowedDialog(context, state.message);
              } else if (state is ShowCancelErrorDialog) {
                _showErrorDialog(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is BookingListLoading) {
                return const Loader();
              }

              if (state is BookingListError) {
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

              // BookingListLoaded, plus the dialog-trigger states which
              // also carry a usable list via the cubit's cached response.
              BookingListResponse? response;
              int? checkingId;
              int? cancellingId;

              if (state is BookingListLoaded) {
                response = state.bookingListResponse;
                checkingId = state.checkingCancelForId;
                cancellingId = state.cancellingForId;
              } else {
                response = context.read<BookingListCubit>().bookingListResponse;
              }

              if (response == null) return const SizedBox.shrink();
              if (response.data.isEmpty) return NoDataWidget();

              return SafeArea(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: response.data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, index) {
                    final item = response!.data[index];
                    return _BookingCard(
                      item: item,
                      isCheckingCancel: checkingId == item.id,
                      isCancelling: cancellingId == item.id,
                      onCancelTap: () async {
                        final confirmed = await _confirmCancelIntent(context);
                        if (confirmed && context.mounted) {
                          context.read<BookingListCubit>().requestCancelBooking(item.id);
                        }
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.item,
    required this.isCheckingCancel,
    required this.isCancelling,
    required this.onCancelTap,
  });

  final BookingListItem item;
  final bool isCheckingCancel;
  final bool isCancelling;
  final VoidCallback onCancelTap;

  bool get _isBusy => isCheckingCancel || isCancelling;

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
          _BookingMapPreview(item: item),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.work, color: AppColor.locationIcon, size: 21),
                  const SizedBox(width: 8),
                  Text(
                    '${'booking_id'.tr()} #${item.id}',
                    style: TextStyle(
                      fontFamily: context.read<LocalizationCubit>().isArabic()
                          ? "Cairo"
                          : "Montserrat",
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${"numberOfProviders".tr()}: ${item.workersNo}' +
                    '- ${"cleaningHours".tr()}: ${item.hoursNo}' +
                    '- ${"services".tr()}: ${item.services}' +
                    ' - ${"arrivalTime".tr()}: ${item.arrivalTime}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: context.read<LocalizationCubit>().isArabic()
                      ? "Cairo"
                      : "Montserrat",
                  color: AppColor.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                item.notes,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: context.read<LocalizationCubit>().isArabic()
                      ? "Cairo"
                      : "Montserrat",
                  color: AppColor.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: context.read<LocalizationCubit>().isArabic()
                      ? "Cairo"
                      : "Montserrat",
                  color: AppColor.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                '${"street_number".tr()}: ${item.streetNo}' +
                    '- ${"region_name".tr()}: ${item.region}' +
                    '- ${"region_no".tr()}: ${item.regionNo}' +
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
              Text(
                '${'status'.tr()}: ${item.status} • ${item.date}',
                style: TextStyle(
                  fontFamily: context.read<LocalizationCubit>().isArabic()
                      ? "Cairo"
                      : "Montserrat",
                  color: AppColor.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // ── Cancel Reservation button ──────────────────────────
              if (item.isCancellable) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isBusy ? null : onCancelTap,
                    icon: _isBusy
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.red,
                            ),
                          )
                        : const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(
                      isCheckingCancel
                          ? 'checkingStatus'.tr()
                          : isCancelling
                              ? 'cancelling'.tr()
                              : 'cancelReservation'.tr(),
                      style: TextStyle(
                        fontFamily: context.read<LocalizationCubit>().isArabic()
                            ? "Cairo"
                            : "Montserrat",
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.red,
                      side: BorderSide(color: AppColor.red, width: 1.4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingMapPreview extends StatelessWidget {
  const _BookingMapPreview({required this.item});

  final BookingListItem item;

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
                markerId: MarkerId('booking-${item.id}'),
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
        color: AppColor.locationChipBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.location_on, color: AppColor.locationIcon, size: 32),
    );
  }
}
