class TimerModel {
  int pomodoroDuration;
  int shortBreakDuration;
  int longBreakDuration;
  int remainingTime;
  bool isWorking;
  int completedCycles;
  int cyclesUntilLongBreak;

  TimerModel({
    required this.pomodoroDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    this.remainingTime = 0,
    this.isWorking = true,
    this.completedCycles = 0,
    this.cyclesUntilLongBreak = 4,
  });
}
