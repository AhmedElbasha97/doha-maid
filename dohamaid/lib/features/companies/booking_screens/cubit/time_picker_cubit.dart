import 'package:flutter_bloc/flutter_bloc.dart';

class TimePickerState {
  const TimePickerState({
    this.showModal = false,
    this.selectedTime,
  });

  final bool showModal;
  final String? selectedTime;

  TimePickerState copyWith({bool? showModal, String? selectedTime}) {
    return TimePickerState(
      showModal: showModal ?? this.showModal,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}

class TimePickerCubit extends Cubit<TimePickerState> {
  TimePickerCubit() : super(const TimePickerState());

  void open() => emit(state.copyWith(showModal: true));
  void closeModal() => emit(state.copyWith(showModal: false));
  void select(String time) => emit(state.copyWith(selectedTime: time, showModal: false));
}
