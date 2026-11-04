/// Đo thời gian màn đọc đang hoạt động bằng đồng hồ đơn điệu.
class ActiveReadingClock {
  ActiveReadingClock({Duration Function()? elapsed}) {
    final stopwatch = Stopwatch()..start();
    _elapsed = elapsed ?? (() => stopwatch.elapsed);
    _last = _elapsed();
  }
  late final Duration Function() _elapsed;
  late Duration _last;
  Duration _pending = Duration.zero;
  bool _active = false;

  void _sample() {
    final now = _elapsed();
    final delta = now - _last;
    if (_active && !delta.isNegative) _pending += delta;
    _last = now;
  }

  void setActive(bool active) {
    _sample();
    _active = active;
  }

  Duration take() {
    _sample();
    final result = _pending;
    _pending = Duration.zero;
    return result;
  }
}
