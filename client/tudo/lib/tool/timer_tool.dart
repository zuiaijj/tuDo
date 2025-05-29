import 'dart:async';

import 'package:tudo/common/log/td_logger.dart';

typedef OnTimerTickCallback = void Function(int millisUntilFinished);

/// 定时器、倒计时timer工具类
class TimerTool {
  TimerTool({this.mInterval = 1, this.mTotalSec = 0});

  Timer? _mTimer;

  /// Timer是否启动.
  bool _isActive = false;

  /// Timer间隔 单位秒，默认1秒.
  int mInterval = 1;

  /// 倒计时总时间, 单位秒
  int mTotalSec = 0;

  OnTimerTickCallback? _onTimerTickCallback;

  /// 设置Timer间隔.
  void setInterval(int interval) {
    if (interval <= 0) interval = 1;
    mInterval = interval;
  }

  /// 设置倒计时总时间.
  void setTotalTime(int totalTime) {
    if (totalTime <= 0) return;
    mTotalSec = totalTime;
  }

  /// 启动定时Timer.
  void startTimer() {
    if (_isActive || mInterval <= 0) return;
    _isActive = true;
    TdLogger.d('startTimer');
    Duration duration = Duration(seconds: mInterval);
    _doCallback(0);
    _mTimer = Timer.periodic(duration, (Timer timer) {
      _doCallback(timer.tick);
    });
  }

  /// 启动倒计时Timer.
  void startCountDown() {
    if (_isActive || mInterval <= 0 || mTotalSec <= 0) return;
    _isActive = true;
    Duration duration = Duration(seconds: mInterval);
    _doCallback(mTotalSec);

    _mTimer = Timer.periodic(duration, (Timer timer) {
      int time = mTotalSec - mInterval;
      mTotalSec = time;
      if (time >= mInterval) {
        _doCallback(time);
      } else if (time == 0) {
        _doCallback(time);
        TdLogger.d('startCountDown time up');
        cancel();
      } else {
        timer.cancel();
        Future.delayed(Duration(seconds: time), () {
          TdLogger.d('startCountDown time up');
          mTotalSec = 0;
          _doCallback(0);
          cancel();
        });
      }
    });
  }

  _doCallback(int time) => _onTimerTickCallback?.call(time);

  /// 更新倒计时总时间
  void updateTotalTime(int totalTime) {
    cancel();
    mTotalSec = totalTime;
    startCountDown();
  }

  /// 判断Timer是否启动.
  bool isActive() => _isActive;

  /// 暂停计时器
  pauseTimer() {}

  /// 取消计时器.
  void cancel() {
    _mTimer?.cancel();
    _mTimer = null;
    _isActive = false;
  }

  /// 设置倒计时器的监听
  void setOnTimerTickCallback(OnTimerTickCallback callback) {
    _onTimerTickCallback = callback;
  }
}
