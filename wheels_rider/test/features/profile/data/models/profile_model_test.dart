import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/features/profile/data/models/profile_model.dart';
import 'package:wheels_rider/features/profile/domain/entities/profile_entity.dart';

void main() {
  const tProfileModel = ProfileModel(id: 1, rating: 4.98, totalEarnings: 0.0, walletBalance: 0.0, user: {'full_name': 'Alex', 'profile_image_url': 'url', 'phone': '1234567890', 'email': 'test@test.com', 'dob': '1990-01-01', 'gender': 'Male'});

  const tProfileEntity = ProfileEntity(id: 1, name: 'Alex', rating: 4.98, profileImageUrl: 'url', totalEarnings: 0.0, walletBalance: 0.0, phone: '1234567890', email: 'test@test.com', dob: '1990-01-01', gender: 'Male');

  test('should convert to ProfileEntity', () {
    final result = tProfileModel.toEntity();
    expect(result, equals(tProfileEntity));
  });

  test('should return a valid model from JSON', () {
    final Map<String, dynamic> jsonMap = {"id": 1, "rating_avg": 4.98, "total_earnings": 0.0, "wallet_balance": 0.0, "user": {"full_name": "Alex", "profile_image_url": "url", "phone": "1234567890", "email": "test@test.com", "dob": "1990-01-01", "gender": "Male"}};

    final result = ProfileModel.fromJson(jsonMap);
    expect(result, equals(tProfileModel));
  });

  test('should return a JSON map containing the proper data', () {
    final result = tProfileModel.toJson();
    final Map<String, dynamic> expectedJsonMap = {"id": 1, "rating_avg": 4.98, "total_earnings": 0.0, "wallet_balance": 0.0, "user": {"full_name": "Alex", "profile_image_url": "url", "phone": "1234567890", "email": "test@test.com", "dob": "1990-01-01", "gender": "Male"}};
    expect(result, equals(expectedJsonMap));
  });
}
