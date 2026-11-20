import 'dart:convert';
import 'lib/features/favourites/data/models/favorite_place_model.dart';

void main() {
  final jsonString = '''
  {
    "title": "Home",
    "address": "123 Main Street, Jubilee Hills, Hyderabad",
    "latitude": 17.4312,
    "longitude": 78.4069,
    "id": 2,
    "customer_id": 6,
    "created_at": "2026-08-27T11:00:58.123900Z"
  }
  ''';
  
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  try {
    final model = FavoritePlaceModel.fromJson(jsonMap);
    print("Success: \${model.title}, id: \${model.id}");
  } catch (e) {
    print("Error: \$e");
  }
}
