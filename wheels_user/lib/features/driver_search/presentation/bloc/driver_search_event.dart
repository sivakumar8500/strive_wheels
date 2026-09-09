abstract class DriverSearchEvent {
  const DriverSearchEvent();
}

class LoadDriverSearchEvent extends DriverSearchEvent {
  const LoadDriverSearchEvent();
}

class CancelDriverSearchEvent extends DriverSearchEvent {
  const CancelDriverSearchEvent();
}
