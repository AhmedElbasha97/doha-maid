import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerState {
  const DatePickerState({this.showModal = false});

  final bool showModal;

  DatePickerState copyWith({bool? showModal}) {
    return DatePickerState(showModal: showModal ?? this.showModal);
  }
}

class DatePickerCubit extends Cubit<DatePickerState> {
  DatePickerCubit() : super(const DatePickerState());

  void open() => emit(state.copyWith(showModal: true));
}
