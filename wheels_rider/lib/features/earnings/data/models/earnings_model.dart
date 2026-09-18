import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/earnings_entity.dart';

part 'earnings_model.freezed.dart';

@freezed
abstract class EarningsActivityModel with _$EarningsActivityModel {
  const EarningsActivityModel._();

  const factory EarningsActivityModel({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    required double amount,
    required DateTime timestamp,
  }) = _EarningsActivityModel;

  factory EarningsActivityModel.fromJson(Map<String, dynamic> json) {
    final idVal = (json['id'] ?? json['booking_id'] ?? '').toString();
    final typeVal = (json['type'] ?? 'TRIP').toString();
    final bookingId = (json['booking_id'] ?? '').toString();
    final titleVal = (json['title'] ?? (bookingId.isNotEmpty ? 'Ride #$bookingId' : 'Completed Ride')).toString();
    final subtitleVal = (json['subtitle'] ?? 'Ride earnings').toString();

    final amtVal = json['net_earnings'] ?? json['amount'] ?? json['gross_amount'] ?? 0.0;
    final double amountVal = (amtVal is num) ? amtVal.toDouble() : (double.tryParse(amtVal.toString()) ?? 0.0);

    final tsRaw = json['timestamp'] ?? json['created_at'] ?? json['date'];
    DateTime parsedTime = DateTime.now();
    if (tsRaw != null) {
      parsedTime = DateTime.tryParse(tsRaw.toString()) ?? DateTime.now();
    }

    return EarningsActivityModel(
      id: idVal,
      type: typeVal,
      title: titleVal,
      subtitle: subtitleVal,
      amount: amountVal,
      timestamp: parsedTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'subtitle': subtitle,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
  };

  EarningsActivityEntity toEntity() {
    return EarningsActivityEntity(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      amount: amount,
      timestamp: timestamp,
    );
  }
}

@freezed
abstract class EarningsModel with _$EarningsModel {
  const EarningsModel._();

  const factory EarningsModel({
    @JsonKey(name: 'total_earnings') required double totalEarnings,
    required int trips,
    required double hours,
    required double rating,
    @JsonKey(name: 'recent_activities') required List<EarningsActivityModel> recentActivities,
  }) = _EarningsModel;

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    final totalEarningsVal = json['total_earnings'] ?? json['totalEarnings'] ?? json['total'] ?? 0.0;
    final double totalEarnings = (totalEarningsVal is num) ? totalEarningsVal.toDouble() : (double.tryParse(totalEarningsVal.toString()) ?? 0.0);

    final tripsVal = json['trips'] ?? json['total_trips'] ?? 0;
    final int trips = (tripsVal is num) ? tripsVal.toInt() : (int.tryParse(tripsVal.toString()) ?? 0);

    final hoursVal = json['hours'] ?? json['total_hours'] ?? 0.0;
    final double hours = (hoursVal is num) ? hoursVal.toDouble() : (double.tryParse(hoursVal.toString()) ?? 0.0);

    final ratingVal = json['rating'] ?? json['average_rating'] ?? 5.0;
    final double rating = (ratingVal is num) ? ratingVal.toDouble() : (double.tryParse(ratingVal.toString()) ?? 5.0);

    List<EarningsActivityModel> activities = [];
    if (json['recent_activities'] is List) {
      activities = (json['recent_activities'] as List)
          .map((e) => EarningsActivityModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (json['activities'] is List) {
      activities = (json['activities'] as List)
          .map((e) => EarningsActivityModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (json['data'] is List) {
      activities = (json['data'] as List)
          .map((e) => EarningsActivityModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return EarningsModel(
      totalEarnings: totalEarnings,
      trips: trips,
      hours: hours,
      rating: rating,
      recentActivities: activities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_earnings': totalEarnings,
      'trips': trips,
      'hours': hours,
      'rating': rating,
      'recent_activities': recentActivities.map((e) => e.toJson()).toList(),
    };
  }

  EarningsEntity toEntity() {
    return EarningsEntity(
      totalEarnings: totalEarnings,
      trips: trips,
      hours: hours,
      rating: rating,
      recentActivities: recentActivities.map((e) => e.toEntity()).toList(),
    );
  }
}
