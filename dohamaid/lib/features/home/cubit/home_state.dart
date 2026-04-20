
import '../data/model/home_model.dart';

abstract class HomeState {}

// Initial boot state (before animations)
class HomeInitial extends HomeState {}

// When starting to load data
class HomeLoading extends HomeState {}

// When animations are ready and data is loaded
class HomeLoaded extends HomeState {
  final List<Datum> homeData;
  HomeLoaded(this.homeData);
}



// Error state
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
