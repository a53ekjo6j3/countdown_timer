library countdown_timer;

import 'dart:async';

import 'package:flutter/material.dart';

typedef CountdownTimerBuilder = Widget Function(
  BuildContext context,
  CountdownTimerResult time,
);

class CountdownTimerResult {
  ///
  final DateTime? endTime;

  ///
  late bool _done;

  /// Is timer done
  bool get done => _done;

  ///
  late Duration _duration;

  /// Current duration
  Duration get duration => _duration;

  @override
  String toString() {
    if (duration.isNegative) {
      return '00:00:00';
    }

    var microseconds = duration.inMicroseconds;

    var hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    var hoursPadding = hours < 10 ? "0" : "";

    if (microseconds < 0) microseconds = -microseconds;

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? "0" : "";

    return "$hoursPadding$hours:"
        "$minutesPadding$minutes:"
        "$secondsPadding$seconds";
  }

  ///
  CountdownTimerResult.empty() : endTime = null {
    _duration = Duration.zero;
    _done = true;
  }

  ///
  CountdownTimerResult({this.endTime}) {
    if (endTime == null) {
      _duration = Duration.zero;
      _done = true;
    } else {
      _duration = endTime!.difference(DateTime.now());
      _done = _duration.isNegative;
    }
  }
}

///
class CountdownTimerController {
  ///
  final StreamController<CountdownTimerResult> _controller =
      StreamController<CountdownTimerResult>.broadcast();

  /// Current time
  CountdownTimerResult _current = CountdownTimerResult.empty();

  /// Current time
  CountdownTimerResult get current => _current;

  ///
  Timer? _timer;

  ///
  DateTime? _endTime;

  /// End time
  DateTime? get endTime => _endTime;

  ///
  bool _running = false;

  /// Is timer running
  bool get running => _running;

  ///
  void startTimer({DateTime? dateTime, Duration? duration}) {
    assert(dateTime != null || duration != null);
    cancel();
    if (dateTime != null) {
      _endTime = dateTime;
    } else if (duration != null) {
      _endTime = DateTime.now().add(duration);
    }
    CountdownTimerResult ctt = CountdownTimerResult(
      endTime: endTime,
    );
    _controller.sink.add(ctt);
    _current = ctt;
    if (ctt.done) {
      return;
    }
    _start();
  }

  ///
  void _timerCallback(Timer t) {
    if (!running) {
      return;
    }
    CountdownTimerResult ctt = CountdownTimerResult(endTime: endTime);
    if (ctt.done) {
      _running = false;
      _timer?.cancel();
      _timer = null;
    }
    _controller.sink.add(ctt);
    _current = ctt;
  }

  ///
  void _start() {
    if (_running) {
      return;
    }
    _running = true;
    _timer = Timer.periodic(const Duration(milliseconds: 1000), _timerCallback);
  }

  ///
  void pause() {
    if (!_running) {
      return;
    }
    _running = false;
    _timer?.cancel();
    _timer = null;
  }

  ///
  void resume() {
    if (_running) {
      return;
    }
    _running = true;
    startTimer(duration: current.duration);
  }

  ///
  void cancel() {
    if (!_running) {
      return;
    }
    _running = false;
    _timer?.cancel();
    _timer = null;
    CountdownTimerResult ctt = CountdownTimerResult.empty();
    _controller.sink.add(ctt);
    _current = ctt;
  }

  ///
  void _dispose() {
    cancel();
    _controller.close();
  }
}

/// CountdownTimer
class CountdownTimer extends StatefulWidget {
  ///
  final CountdownTimerController controller;

  ///
  final CountdownTimerBuilder builder;

  const CountdownTimer({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  ///
  StreamSubscription<CountdownTimerResult>? streamSubscription;

  ///
  late CountdownTimerResult countdownTimerTime;

  ///
  void initStreamSubscription() {
    streamSubscription = widget.controller._controller.stream.listen((event) {
      if (mounted) {
        setState(() {
          countdownTimerTime = event;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    countdownTimerTime =
        CountdownTimerResult(endTime: widget.controller.endTime);
    initStreamSubscription();
  }

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.controller._controller.hasListener) {
      initStreamSubscription();
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    widget.controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, countdownTimerTime);
  }
}
