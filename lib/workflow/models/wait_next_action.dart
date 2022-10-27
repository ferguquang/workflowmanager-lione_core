import 'dart:async';

typedef DoAction<T> = void Function(T data);
typedef DoActionMoreParams<T> = void Function(List<T> data);

class WaitNextAction<T> {
  Duration duration = Duration(seconds: 2);
  DoAction<T> doAction;
  DoActionMoreParams<T> doActionMoreData;

  WaitNextAction(this.doAction, {Duration duration, this.doActionMoreData}) {
    if (duration != null) this.duration = duration;
  }

  Timer timer;

  action(T data) {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    timer = Timer(duration, () {
      if (doAction != null) {
        doAction(data);
      }
    });
  }

  actionMoreData(List<T> data) {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    timer = Timer(duration, () {
      if (doActionMoreData != null) {
        doActionMoreData(data);
      }
    });
  }

  cancel() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
  }
}
