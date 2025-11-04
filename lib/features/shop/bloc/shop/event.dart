import 'dart:async';

abstract class ShopEvent {}

class SelectionChanged extends ShopEvent {}

class BalanceChanged extends ShopEvent {}

class ShopEvents {
  static final StreamController<ShopEvent> _controller =
      StreamController<ShopEvent>.broadcast();

  static Stream<ShopEvent> get stream => _controller.stream;

  static void emit(ShopEvent event) => _controller.add(event);
}
