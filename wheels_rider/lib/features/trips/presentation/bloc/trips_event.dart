abstract class TripsEvent {}

class GetTripsEvent extends TripsEvent {
  final int limit;
  final int offset;

  GetTripsEvent({this.limit = 50, this.offset = 0});
}
