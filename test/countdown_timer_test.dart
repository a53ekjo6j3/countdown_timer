import 'package:flutter_test/flutter_test.dart';

import 'package:countdown_timer/countdown_timer.dart';

void main() {
  test('Test CountdownTimerController start timer', () {
    final controller = CountdownTimerController();

    /// Test give DateTime
    controller.startTimer(dateTime: DateTime(0));

    /// Test give Duration
    controller.startTimer(duration: Duration.zero);

    /// Test assert
    expect(controller.startTimer, throwsAssertionError);
  });

  test('Test CountdownTimerController', () async {
    final controller = CountdownTimerController();

    /// Test give Duration
    controller.startTimer(duration: const Duration(seconds: 3));
    print(controller.current.toString());

    await Future.delayed(const Duration(seconds: 1));
    controller.pause();
    print(controller.current.toString());

    await Future.delayed(const Duration(seconds: 1));
    controller.resume();
    print(controller.current.toString());

    await Future.delayed(const Duration(seconds: 1));
    print(controller.current.toString());

    /// Test assert
    expect(controller.startTimer, throwsAssertionError);
  });

  test('Test CountdownTimerTime', () {
    var countdownTimerTime = CountdownTimerResult.empty();
    // ignore: avoid_print
    print(countdownTimerTime.toString());

    countdownTimerTime = CountdownTimerResult();
    // ignore: avoid_print
    print(countdownTimerTime.toString());

    countdownTimerTime = CountdownTimerResult(
      endTime: DateTime.now().add(
        const Duration(hours: 5, minutes: 3, seconds: 5),
      ),
    );
    // ignore: avoid_print
    print(countdownTimerTime.toString());

    countdownTimerTime = CountdownTimerResult(
        endTime: DateTime.now().add(const Duration(days: -5)));
    // ignore: avoid_print
    print(countdownTimerTime.toString());
  });
}
