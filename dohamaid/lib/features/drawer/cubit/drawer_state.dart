// lib/features/drawer/cubit/drawer_state.dart
part of 'drawer_cubit.dart';


abstract class DrawerState {}

class DrawerInitial extends DrawerState {}

class DrawerLoaded extends DrawerState {
  final List<DrawerItemModel> items;
  DrawerLoaded(this.items);
}

class DrawerItemSelected extends DrawerState {
  final String id;
  DrawerItemSelected(this.id);
}

class DrawerError extends DrawerState {
  final String message;
  DrawerError(this.message);
}
