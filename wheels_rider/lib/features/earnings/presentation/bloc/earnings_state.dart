import '../../domain/entities/earnings_entity.dart';

abstract class EarningsState {}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final EarningsEntity earnings;

  EarningsLoaded(this.earnings);
}

class EarningsError extends EarningsState {
  final String message;

  EarningsError(this.message);
}
