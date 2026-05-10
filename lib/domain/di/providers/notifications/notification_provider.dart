import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

class CurrencyUpdateNotification {
  final bool success;
  final String message;

  CurrencyUpdateNotification({
    required this.success,
    required this.message,
  });
}

class NotificationState {
  final CurrencyUpdateNotification? currencyUpdateNotification;

  NotificationState({
    this.currencyUpdateNotification,
  });

  NotificationState copyWith({
    CurrencyUpdateNotification? currencyUpdateNotification,
    bool clearCurrencyUpdateNotification = false,
  }) {
    return NotificationState(
      currencyUpdateNotification: clearCurrencyUpdateNotification
          ? null
          : (currencyUpdateNotification ?? this.currencyUpdateNotification),
    );
  }
}

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  NotificationState build() => NotificationState();

  void showCurrencyUpdateNotification({
    required bool success,
    required String message,
  }) {
    state = state.copyWith(
      currencyUpdateNotification: CurrencyUpdateNotification(
        success: success,
        message: message,
      ),
    );
  }

  void clearCurrencyUpdateNotification() {
    state = state.copyWith(clearCurrencyUpdateNotification: true);
  }
}
