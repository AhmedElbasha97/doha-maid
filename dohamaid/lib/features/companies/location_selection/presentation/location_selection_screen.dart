   import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/presentation/cubit/localization_cubit.dart';
import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import '../../booking_screens/data/booking_category_model.dart';
import '../cubit/location_selection_cubit.dart';
import '../cubit/location_selection_state.dart';
import '../data/place_suggestion.dart';
import '../../payment/cubit/payment_cubit.dart';
import '../../payment/screens/payment_screen.dart';
import 'package:dohamaid/core/config/app_color.dart';

const double _kDefaultMapLat = 25.2854;
const double _kDefaultMapLng = 51.5310;

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({
    super.key, this.selectedHours, this.selectedWorkers, this.selectedDate, this.arrivalTime, this.totalPrice, required this.selectedServices, this.note, required this.servicesId,
  });

  final String? totalPrice ;
  final List<Datum>? selectedServices ;
  final Datum? selectedHours;
  final Datum? selectedWorkers;
  final DateTime? selectedDate;
  final Datum? arrivalTime;
  final String? note;
  final  String servicesId;
  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? _mapController;
  final Completer<GoogleMapController> _mapCompleter = Completer();

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onNext(LocationSelectionState state) {
    if (!_hasAllRequiredFields(state)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('location_required_fields'.tr()),
          backgroundColor: AppColor.red.shade700,
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => PaymentCubit(),
          child: PaymentScreen(
            selectedDate: widget.selectedDate,
            selectedHours: widget.selectedHours,
            selectedServices: widget.selectedServices,
            selectedWorkers: widget.selectedWorkers,
            arrivalTime: widget.arrivalTime,
            totalPrice: widget.totalPrice,
            note: widget.note,
            address: state.address,
            servicesId: widget.servicesId,
          ),
        ),
      ),
    );
  }

  bool _hasAllRequiredFields(LocationSelectionState state) {
    print("${state.streetNumber} + ${state.regionName} + ${state.regionNumber} + ${state.buildingNumber}");

    return
        state.streetNumber.trim().isNotEmpty &&
        state.regionName.trim().isNotEmpty &&
        state.regionNumber.trim().isNotEmpty &&
        state.buildingNumber.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationSelectionCubit(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: _buildAppBar(context),
        body: BlocConsumer<LocationSelectionCubit, LocationSelectionState>(
          listener: (context, state) {
            if (state.error != null) {
              final msg = state.error == 'address_not_found'
                  ? "address_not_found".tr()
                  : "error_fetching_location".tr();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: AppColor.red.shade700,
                ),
              );
              context.read<LocationSelectionCubit>().clearError();
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MapSection(
                      state: state,
                      onMapCreated: (c) {
                        _mapController = c;
                        if (!_mapCompleter.isCompleted) {
                          _mapCompleter.complete(c);
                        }
                      },
                      onMapReady: _moveToUserLocation,
                      onMapTap: (latLng) => context
                          .read<LocationSelectionCubit>()
                          .updatePositionFromMap(latLng.latitude, latLng.longitude),
                      onCameraIdle: _onCameraIdle,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _UseCurrentLocationButton(
                            isLoading: state.isLoading,
                            onTap: () => context
                                .read<LocationSelectionCubit>()
                                .useCurrentLocation(),
                          ),
                          const SizedBox(height: 20),
                          _AddressFields(state: state),
                          const SizedBox(height: 20),
                          Text(
                            "saved_locations".tr(),
                            style:  TextStyle(
                              fontSize: 14,
                              fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                              color: AppColor.textSecondaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SavedLocationChip(
                            icon: Icons.home,
                            label: "homeAddress".tr(),
                            selected: state.selectedSavedLocation == SavedLocationType.home,
                            onTap: () => context
                                .read<LocationSelectionCubit>()
                                .selectSavedLocation(SavedLocationType.home),
                          ),
                          const SizedBox(height: 8),
                          _SavedLocationChip(
                            icon: Icons.work,
                            label: "work".tr(),
                            selected: state.selectedSavedLocation == SavedLocationType.work,
                            onTap: () => context
                                .read<LocationSelectionCubit>()
                                .selectSavedLocation(SavedLocationType.work),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  AppColor.secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _onNext(state),
                              child: Text(
                                "next".tr(),
                                style:  TextStyle(color: AppColor.white,  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _moveToUserLocation(LocationSelectionState state) {
    final lat = state.lat ?? _kDefaultMapLat;
    final lng = state.lng ?? _kDefaultMapLng;
    _mapCompleter.future.then((c) {
      c.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    });
  }

  void _onCameraIdle(LatLng target) {
    context.read<LocationSelectionCubit>().updatePositionFromMap(
          target.latitude,
          target.longitude,
        );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor:  AppColor.appBarBackground,
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
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_forward_ios, color: AppColor.mainColor),
        ),
      ],
    );
  }
}

class _MapSection extends StatefulWidget {
  const _MapSection({
    required this.state,
    required this.onMapCreated,
    required this.onMapReady,
    this.onMapTap,
    this.onCameraIdle,
  });

  final LocationSelectionState state;
  final void Function(GoogleMapController) onMapCreated;
  final void Function(LocationSelectionState) onMapReady;
  final void Function(LatLng)? onMapTap;
  /// Called when camera stops moving. Receives the last known map center (from [onCameraMove]).
  final void Function(LatLng)? onCameraIdle;

  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  LatLng? _lastCameraTarget;

  @override
  void didUpdateWidget(_MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.lat != widget.state.lat ||
        oldWidget.state.lng != widget.state.lng) {
      final lat = widget.state.lat ?? _kDefaultMapLat;
      final lng = widget.state.lng ?? _kDefaultMapLng;
      _lastCameraTarget = LatLng(lat, lng);
      widget.onMapReady(widget.state);
    }
  }

  void _onCameraMove(CameraPosition position) {
    _lastCameraTarget = position.target;
  }

  void _onCameraIdle() {
    final t = _lastCameraTarget;
    if (t != null && widget.onCameraIdle != null) {
      widget.onCameraIdle!(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.state.lat ?? _kDefaultMapLat;
    final lng = widget.state.lng ?? _kDefaultMapLng;
    final initialPosition = LatLng(lat, lng);
    _lastCameraTarget ??= initialPosition;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 280,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 15,
              ),
              onMapCreated: (c) {
                widget.onMapCreated(c);
                widget.onMapReady(widget.state);
              },
              onCameraMove: _onCameraMove,
              onTap: widget.onMapTap,
              onCameraIdle: _onCameraIdle,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: initialPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet,
                  ),
                ),
              },
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 20,
          right: 20,
          child: _SearchWithSuggestions(
            state: widget.state,
            locale: context.locale.languageCode,
          ),
        ),
        if (widget.state.isLoading)
          const Positioned(
            child: Center(
              child: CircularProgressIndicator(color: AppColor.secondaryColor),
            ),
          ),
      ],
    );
  }
}

class _SearchWithSuggestions extends StatefulWidget {
  const _SearchWithSuggestions({
    required this.state,
    required this.locale,
  });

  final LocationSelectionState state;
  final String locale;

  @override
  State<_SearchWithSuggestions> createState() => _SearchWithSuggestionsState();
}

class _SearchWithSuggestionsState extends State<_SearchWithSuggestions> {
  static const _debounceMs = 300;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _scheduleFetch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: _debounceMs), () {
      context.read<LocationSelectionCubit>().fetchSuggestions(
            query,
            language: widget.locale.isNotEmpty ? widget.locale : null,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationSelectionCubit>();
    final state = widget.state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchBar(
          query: state.searchQuery,
          onChanged: (v) {
            cubit.setSearchQuery(v);
            _scheduleFetch(v);
          },
          onSearch: () => cubit.searchAddress(state.searchQuery),
          isSearching: state.isLoading,
        ),
        if (state.suggestions.isNotEmpty || state.suggestionsLoading) ...[
          const SizedBox(height: 8),
          _SuggestionsList(
            suggestions: state.suggestions,
            suggestionsLoading: state.suggestionsLoading,
            onTap: (s) => cubit.selectSuggestion(s),
          ),
        ],
      ],
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  const _SuggestionsList({
    required this.suggestions,
    required this.suggestionsLoading,
    required this.onTap,
  });

  final List<PlaceSuggestion> suggestions;
  final bool suggestionsLoading;
  final void Function(PlaceSuggestion) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: suggestionsLoading && suggestions.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final s = suggestions[i];
                return ListTile(
                  leading: const Icon(
                    Icons.place_outlined,
                    color: AppColor.secondaryColor,
                    size: 22,
                  ),
                  title: Text(
                    s.description,
                    style:  TextStyle(
                      fontSize: 14,
                      color: AppColor.textPrimaryDark,
                      fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                    ),
                  ),
                    dense: true,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onTap(s);
                    },
                  );

              },
            ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.query,
    required this.onChanged,
    required this.onSearch,
    this.isSearching = false,
  });

  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onSearch;
  final bool isSearching;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(_SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query && _controller.text != widget.query) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColor.textSecondaryDark, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => widget.onSearch(),
              decoration: InputDecoration(
                hintText: "search_placeholder".tr(),
                hintStyle:  TextStyle(color: AppColor.textSecondaryDark, fontSize: 15,  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: widget.isSearching ? null : widget.onSearch,
            icon: widget.isSearching
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.secondaryColor,
                    ),
                  )
                : const Icon(Icons.search, color: AppColor.secondaryColor, size: 24),
            tooltip: "search".tr(),
          ),
        ],
      ),
    );
  }
}

class _UseCurrentLocationButton extends StatelessWidget {
  const _UseCurrentLocationButton({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color:  AppColor.borderLight),
          ),
          child: Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.secondaryColor,
                  ),
                )
              else
                const Icon(
                  Icons.my_location,
                  color: AppColor.secondaryColor,
                  size: 24,
                ),
              const SizedBox(width: 12),
              Text(
                "use_current_location".tr(),
                style:  TextStyle(
                  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
                  fontSize: 16,
                  color: AppColor.textPrimaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressFields extends StatelessWidget {
  const _AddressFields({required this.state});

  final LocationSelectionState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LocationSelectionCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AddressTextField(
          label: "street_name".tr(),
          value: state.streetName,
          onChanged: cubit.setStreetName,
          hint: "search_placeholder".tr(),
          focusNode: cubit.streetNameFocusNode,
          nextFocusNode: cubit.streetNumberFocusNode,

        ),
        const SizedBox(height: 12),
        _AddressTextField(
          label: "street_number".tr(),
          value: state.streetNumber,
          onChanged: cubit.setStreetNumber,
          keyboardType: TextInputType.number,
          focusNode: cubit.streetNumberFocusNode,
          nextFocusNode: cubit.regionNameFocusNode,
        ),
        const SizedBox(height: 12),
        _AddressTextField(
          label: "region_name".tr(),
          value: state.regionName,
          onChanged: cubit.setRegionName,
          keyboardType: TextInputType.streetAddress,
          focusNode: cubit.regionNameFocusNode,
          nextFocusNode: cubit.regionNumberFocusNode,
        ),
        const SizedBox(height: 12),
        _AddressTextField(
          label: "region_no".tr(),
          value: state.regionNumber,
          onChanged: cubit.setRegionNumber,
          keyboardType: TextInputType.number,
          focusNode: cubit.regionNumberFocusNode,
          nextFocusNode: cubit.buildingNumberFocusNode,
        ),
        const SizedBox(height: 12),
        _AddressTextField(
          label: "building_no".tr(),
          value: state.buildingNumber,
          onChanged: cubit.setBuildingNumber,
          keyboardType: TextInputType.number,
          focusNode: cubit.buildingNumberFocusNode,
          nextFocusNode: null,
        ),
      ],
    );
  }
}

class _AddressTextField extends StatefulWidget {
  const _AddressTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.keyboardType = TextInputType.streetAddress, this.focusNode, this.nextFocusNode,
  });
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final TextInputType keyboardType;

  @override
  State<_AddressTextField> createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<_AddressTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() => widget.onChanged(_controller.text);

  @override
  void didUpdateWidget(_AddressTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.removeListener(_onControllerChanged);
      _controller.text = widget.value;
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style:  TextStyle(
            fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",
            fontSize: 14,
            color: AppColor.textSecondaryDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          focusNode: widget.focusNode,
          textInputAction: widget.nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onSubmitted: (_) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.label,
            hintStyle:  TextStyle(color: AppColor.gray400,  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.secondaryColor),
            ),
            filled: true,
            fillColor:  AppColor.cardLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _SavedLocationChip extends StatelessWidget {
  const _SavedLocationChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ?  AppColor.secondaryColor :  AppColor.borderLight,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color:  AppColor.secondaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style:  TextStyle(  fontFamily: context.read<LocalizationCubit>().isArabic()?"Cairo":"Montserrat",

                  fontSize: 16,
                  color: AppColor.textPrimaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
