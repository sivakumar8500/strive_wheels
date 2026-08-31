abstract class EarningsEvent {}

class GetEarningsEvent extends EarningsEvent {
  final int limit;
  final int offset;

  GetEarningsEvent({this.limit = 50, this.offset = 0});
}
