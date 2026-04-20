import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../notifications/push_notification_service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._service) : super(const NotificationState());

  final PushNotificationService _service;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedFromBackgroundSubscription;

  Future<void> initialize() async {
    emit(state.copyWith(lifecycleStatus: NotificationLifecycleStatus.loading));

    try {
      await _service.initialize();
      final settings = await _service.requestPermissions();

      final permissionStatus = settings.authorizationStatus ==
                  AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional
          ? NotificationPermissionStatus.granted
          : NotificationPermissionStatus.denied;

      emit(state.copyWith(permissionStatus: permissionStatus));

      _foregroundSubscription = _service.foregroundMessages.listen(
        _onForegroundMessage,
      );

      _openedFromBackgroundSubscription = _service.openedFromBackground.listen(
        _handleInteractionMessage,
      );

      final initialMessage = await _service.getInitialMessage();
      if (initialMessage != null) {
        await _handleInteractionMessage(initialMessage);
      } else {
        final savedRoute = _service.getSavedRoute();
        if (savedRoute != null && savedRoute.isNotEmpty) {
          emit(
            state.copyWith(
              route: savedRoute,
              payload: _service.getSavedPayload(),
              lifecycleStatus: NotificationLifecycleStatus.ready,
            ),
          );
        } else {
          emit(state.copyWith(lifecycleStatus: NotificationLifecycleStatus.ready));
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          lifecycleStatus: NotificationLifecycleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    await _service.showLocal(message);
    await _service.cacheRouteFromMessage(message);
  }

  Future<void> _handleInteractionMessage(RemoteMessage message) async {
    await _service.cacheRouteFromMessage(message);

    final route = message.data['page']?.toString().trim();
    emit(
      state.copyWith(
        route: route,
        payload: Map<String, dynamic>.from(message.data),
        lifecycleStatus: NotificationLifecycleStatus.ready,
      ),
    );
  }

  Future<void> markRouteHandled() async {
    await _service.clearCachedRoute();
    emit(state.copyWith(clearRoute: true));
  }

  @override
  Future<void> close() async {
    await _foregroundSubscription?.cancel();
    await _openedFromBackgroundSubscription?.cancel();
    return super.close();
  }
}
