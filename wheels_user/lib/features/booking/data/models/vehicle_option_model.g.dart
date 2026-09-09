// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleOptionModel _$VehicleOptionModelFromJson(Map<String, dynamic> json) =>
    _VehicleOptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specs: json['specs'] as String,
      price: json['price'] as String,
      rating: json['rating'] as String,
      eta: json['eta'] as String,
      imagePath: json['imagePath'] as String,
    );

Map<String, dynamic> _$VehicleOptionModelToJson(_VehicleOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'specs': instance.specs,
      'price': instance.price,
      'rating': instance.rating,
      'eta': instance.eta,
      'imagePath': instance.imagePath,
    };
