import 'package:equatable/equatable.dart';

enum NotificationPermissionStatus { unknown, granted, denied }

enum NotificationLifecycleStatus { idle, loading, ready, failure }

class NotificationState extends Equatable {
  const NotificationState({
    this.permissionStatus = NotificationPermissionStatus.unknown,
    this.lifecycleStatus = NotificationLifecycleStatus.idle,
    this.route,
    this.payload = const <String, dynamic>{},
    this.errorMessage,
  });

  final NotificationPermissionStatus permissionStatus;
  final NotificationLifecycleStatus lifecycleStatus;
  final String? route;
  final Map<String, dynamic> payload;
  final String? errorMessage;

  NotificationState copyWith({
    NotificationPermissionStatus? permissionStatus,
    NotificationLifecycleStatus? lifecycleStatus,
    String? route,
    bool clearRoute = false,
    Map<String, dynamic>? payload,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      permissionStatus: permissionStatus ?? this.permissionStatus,
      lifecycleStatus: lifecycleStatus ?? this.lifecycleStatus,
      route: clearRoute ? null : (route ?? this.route),
      payload: payload ?? this.payload,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        permissionStatus,
        lifecycleStatus,
        route,
        payload,
        errorMessage,
      ];
}
