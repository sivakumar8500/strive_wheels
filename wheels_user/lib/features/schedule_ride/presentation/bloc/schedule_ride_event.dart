abstract class ScheduleRideEvent {
  const ScheduleRideEvent();
}

class LoadScheduleRideEvent extends ScheduleRideEvent {
  const LoadScheduleRideEvent();
}

class SelectScheduleDateEvent extends ScheduleRideEvent {
  final String date;

  const SelectScheduleDateEvent(this.date);
}

class ToggleAmPmEvent extends ScheduleRideEvent {
  final bool isAm;

  const ToggleAmPmEvent(this.isAm);
}

class ToggleInstantNotificationEvent extends ScheduleRideEvent {
  final bool value;

  const ToggleInstantNotificationEvent(this.value);
}

class ConfirmScheduleEvent extends ScheduleRideEvent {
  const ConfirmScheduleEvent();
}
