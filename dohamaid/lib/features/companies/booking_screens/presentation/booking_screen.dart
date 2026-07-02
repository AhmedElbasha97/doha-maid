import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../loader.dart';
import '../../../../widget/no_data_widget.dart';
import '../../../drawer/cubit/drawer_cubit.dart';
import '../../../drawer/presentation/drawer_screen.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../data/booking_category_model.dart';
import '../../location_selection/presentation/location_selection_screen.dart';
import '../widget/date_picker_sheet.dart';
import '../widget/option_chips.dart';
import '../widget/services_tile.dart';
import '../widget/time_picker_sheet.dart';
import 'package:dohamaid/core/config/app_color.dart';
class BookingScreen extends StatefulWidget {
   const BookingScreen({super.key, required this.servicesId});
 final  String servicesId;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();


    final cubit = context.read<BookingCubit>();

   cubit.initDefaultDate(widget.servicesId);
  }

  @override
  Widget build(BuildContext context) {
    return   _BookingView();
  }
}

class _BookingView extends StatelessWidget {
  const _BookingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
      body: BlocBuilder<BookingCubit, BookingStates>(
        builder: (context, state) {
          if (state is BookingLoadingState) {
            return const Loader();
          }

          if (state is BookingErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is BookingLoadedState ) {
            final cubit = context.read<BookingCubit>();

            if ((cubit.bookingWorkers?.data?.isEmpty??true) ||
                (cubit.bookingHours?.data?.isEmpty??true) ||
                (cubit.bookingServices?.data?.isEmpty??true) ||
                (cubit.bookingTimes?.data?.isEmpty??true)
            ){
              return const NoDataWidget();
            } else {
              final cubit = context.read<BookingCubit>();
              return GestureDetector(

                    onTap: () => context.read<BookingCubit>().unFocusText(),
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DateField(
                          formatted: cubit.formattedDate.isEmpty
                              ? 'Fri, 23 Jan 26'
                              : cubit.formattedDate,
                          onTap: () => _showDatePicker(context, state,cubit),
                        ),
                        const SizedBox(height: 24),
                        _SectionLabel(label: "numberOfProviders".tr()),
                        const SizedBox(height: 8),
                    Row(
                      children: cubit.bookingWorkers?.data?.map((v) {
                        return OptionChips(
                          option: v,
                          selected: cubit.selectedWorkers == v,
                          onSelect: (v) {
                              cubit
                                  .setProviderCount(v);

                              },
                        );
                      }).toList()??[SizedBox()],

                        ),
                        const SizedBox(height: 20),
                        _SectionLabel(label: "cleaningHours".tr()),
                        const SizedBox(height: 8),
                    Row(
                      children:  cubit.bookingHours?.data?.map((v) {
                       return OptionChips(
                          option: v,
                          selected: cubit.selectedHours == v,
                          onSelect: (v) =>
                              cubit
                                  .setCleaningHours(v),
                        )
                        ;
                      }).toList()??[SizedBox()],


                        ),
                        const SizedBox(height: 20),
                        _SectionLabel(label: "arrivalTime".tr()),
                        const SizedBox(height: 8),
                        _TimeField(
                          value: cubit.arrivalTime ??
                              Datum(name: "selectStartTime".tr(), id: 0),
                          onTap: () => _showTimePicker(context,cubit),
                        ),
                        const SizedBox(height: 24),
                        _SectionLabel(label: "services".tr()),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.6,
                          children:
                            cubit.bookingServices?.data?.map((e){
                              return ServiceCard(
                                label:e.name??"",
                                icon: Icons.cleaning_services,
                                selected: (cubit.selectedServices
                                    .contains(e)),
                                onTap: () =>
                                    context
                                        .read<BookingCubit>()
                                        .toggleService(e),
                              );
                            }).toList()??[],


                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SectionLabel(label: "yourNotes".tr()),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  AppColor.secondaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {


                                context.read<BookingCubit>().unFocusText();


                              },
                              child: Text("done".tr(), style: const TextStyle(color: AppColor.white),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          focusNode: context.read<BookingCubit>().textFocusNode,
                          maxLines: 4,
                          controller: cubit.notes,
                          decoration: InputDecoration(
                            hintText: "yourNotes".tr(),

                            hintStyle: const TextStyle(color: AppColor.textSecondaryDark),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColor.secondaryColor)
                            ),
                            filled: true,
                            fillColor:  AppColor.cardLight,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: BlocBuilder<BookingCubit, BookingStates>(
          builder: (context, state) {
            if (state is BookingLoadingState) {
              return SizedBox();
            }

            if (state is BookingErrorState) {
              return  SizedBox();
            }

            if (state is BookingLoadedState ) {
              final cubit = context.read<BookingCubit>()
;
              if ((cubit.bookingWorkers?.data?.isEmpty??true) ||
                  (cubit.bookingHours?.data?.isEmpty??true) ||
                  (cubit.bookingServices?.data?.isEmpty??true) ||
                  (cubit.bookingTimes?.data?.isEmpty??true)
              ){
                return  SizedBox();
              } else {
                return _BottomBar(cubit);
              }
            }
            return  SizedBox();


  },
),
    );
  }

  void _showDatePicker(BuildContext context, BookingLoadedState booking,BookingCubit cubit) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => DatePickerSheet(
        selectedDate: cubit.selectedDate,
        onDateSelected: (d) {
         cubit
.setDate(d);
          Navigator.pop(context);

        },
        onClose: () {},
      ),
    );
  }

  void _showTimePicker(BuildContext context,BookingCubit cubit) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => TimePickerSheet(
        timeSlots:cubit.bookingTimes?.data,
        onTimeSelected: (t) {
         cubit
.setArrivalTime(t);
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimaryDark,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.formatted, required this.onTap});

  final String formatted;
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
            border: Border.all(color: AppColor.mainColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color:  AppColor.secondaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                formatted,
                style: const TextStyle(
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

class _TimeField extends StatelessWidget {
  const _TimeField({required this.value, required this.onTap});

  final Datum? value;
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
            border: Border.all(color: AppColor.mainColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: AppColor.secondaryColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value?.name??"",
                  style: TextStyle(
                    fontSize: 16,
                    color: (value?.name?.contains('Select')??true) || (value?.name?.contains('اختر')??true)
                        ? AppColor.textSecondaryDark
                        :AppColor.textPrimaryDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar(this.cubit);
    final BookingCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "total".tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.textSecondaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  BlocBuilder<BookingCubit, BookingStates>(
                    buildWhen: (_, __) => true, // BUG FIX 11: was `cubit.totalPrice != cubit.totalPrice` (always false — same ref). Price display never updated.
                    builder: (context, state) {
                      return Text(
                        '${cubit.totalPrice} ${"currencyQAR".tr()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:  AppColor.textPrimaryDark,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
           Expanded(
              flex: 2,
              child:  cubit.checkingThePrice?  Container(
                  width:screenWidth(context)*0.24,
                  height:screenHeight(context)*0.07,
                  decoration: const BoxDecoration( color:  AppColor.mainColor, shape: BoxShape.circle ),
                  child: const Padding( padding: EdgeInsets.all(8.0),
                    child: Center( child: CircularProgressIndicator(color: AppColor.white, ), ),)
              )
                  :ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  AppColor.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {


                    cubit.getTotalPrice(context);


                },
                child: Text("next".tr(), style: const TextStyle(color: AppColor.white),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

