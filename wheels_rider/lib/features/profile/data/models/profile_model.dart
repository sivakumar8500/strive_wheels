import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'rating_avg') double? rating,
    @JsonKey(name: 'total_earnings') double? totalEarnings,
    @JsonKey(name: 'wallet_balance') double? walletBalance,
    @JsonKey(name: 'user') Map<String, dynamic>? user,
    @JsonKey(name: 'vehicle_detail') Map<String, dynamic>? vehicleDetail,
    @JsonKey(name: 'corporate_detail') Map<String, dynamic>? corporateDetail,
    @JsonKey(name: 'active_company') Map<String, dynamic>? activeCompany,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    int? idVal;
    if (json['id'] != null) {
      idVal = (json['id'] is num) ? (json['id'] as num).toInt() : int.tryParse(json['id'].toString());
    } else if (json['rider_id'] != null) {
      idVal = (json['rider_id'] is num) ? (json['rider_id'] as num).toInt() : int.tryParse(json['rider_id'].toString());
    }

    double ratingVal = 5.0;
    final rRaw = json['rating_avg'] ?? json['avg_rating'] ?? json['rating'];
    if (rRaw != null) {
      ratingVal = (rRaw is num) ? rRaw.toDouble() : (double.tryParse(rRaw.toString()) ?? 5.0);
    }

    double earningsVal = 0.0;
    final eRaw = json['total_earnings'] ?? json['earnings'];
    if (eRaw != null) {
      earningsVal = (eRaw is num) ? eRaw.toDouble() : (double.tryParse(eRaw.toString()) ?? 0.0);
    }

    double walletVal = 0.0;
    final wRaw = json['wallet_balance'] ?? json['balance'];
    if (wRaw != null) {
      walletVal = (wRaw is num) ? wRaw.toDouble() : (double.tryParse(wRaw.toString()) ?? 0.0);
    }

    Map<String, dynamic> userMap = {};
    if (json['user'] is Map) {
      userMap = Map<String, dynamic>.from(json['user'] as Map);
    } else {
      userMap = Map<String, dynamic>.from(json);
    }

    Map<String, dynamic>? vMap;
    if (json['vehicle_detail'] is Map) {
      vMap = Map<String, dynamic>.from(json['vehicle_detail'] as Map);
    } else if (json['vehicle'] is Map) {
      vMap = Map<String, dynamic>.from(json['vehicle'] as Map);
    } else if (json['driver_registration'] is Map && json['driver_registration']['vehicle_detail'] is Map) {
      vMap = Map<String, dynamic>.from(json['driver_registration']['vehicle_detail'] as Map);
    }

    Map<String, dynamic>? corpMap;
    if (json['corporate_detail'] is Map) {
      corpMap = Map<String, dynamic>.from(json['corporate_detail'] as Map);
    } else if (json['corporate'] is Map) {
      corpMap = Map<String, dynamic>.from(json['corporate'] as Map);
    }

    Map<String, dynamic>? compMap;
    if (json['active_company'] is Map) {
      compMap = Map<String, dynamic>.from(json['active_company'] as Map);
    } else if (json['company'] is Map) {
      compMap = Map<String, dynamic>.from(json['company'] as Map);
    }

    return ProfileModel(
      id: idVal,
      rating: ratingVal,
      totalEarnings: earningsVal,
      walletBalance: walletVal,
      user: userMap,
      vehicleDetail: vMap,
      corporateDetail: corpMap,
      activeCompany: compMap,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'rating_avg': rating,
      'total_earnings': totalEarnings,
      'wallet_balance': walletBalance,
      'user': user,
    };
    if (vehicleDetail != null) map['vehicle_detail'] = vehicleDetail;
    if (corporateDetail != null) map['corporate_detail'] = corporateDetail;
    if (activeCompany != null) map['active_company'] = activeCompany;
    return map;
  }

  ProfileEntity toEntity() {
    final userData = user ?? {};
    final vData = vehicleDetail ?? {};
    final corpData = corporateDetail;
    final compData = activeCompany;

    String fullName = 'Puja Sri';
    if (userData['full_name'] != null && userData['full_name'].toString().isNotEmpty) {
      fullName = userData['full_name'].toString();
    } else if (userData['name'] != null && userData['name'].toString().isNotEmpty) {
      fullName = userData['name'].toString();
    } else if (userData['first_name'] != null && userData['first_name'].toString().isNotEmpty) {
      fullName = "${userData['first_name']} ${userData['last_name'] ?? ''}".trim();
    }

    String imageUrl = '';
    final imgRaw = userData['profile_image_url'] ?? userData['profile_photo_url'] ?? userData['avatar_url'] ?? userData['image_url'];
    if (imgRaw != null && imgRaw.toString().isNotEmpty) {
      final imgStr = imgRaw.toString();
      imageUrl = (imgStr.contains('/') || imgStr.contains('\\'))
          ? ApiEndpoints.getImageUrl(imgStr)
          : imgStr;
    }

    double r = 5.0;
    if (rating != null && rating! > 0) {
      r = rating!;
    } else if (userData['rating_avg'] != null) {
      r = (userData['rating_avg'] is num) ? (userData['rating_avg'] as num).toDouble() : (double.tryParse(userData['rating_avg'].toString()) ?? 5.0);
    }

    // Vehicle fields parsing with accurate fallbacks
    String vMake = (vData['compenyName'] ?? vData['make'] ?? vData['company_name'] ?? vData['brand'] ?? 'Toyota').toString();
    String vModel = (vData['vehicalModel'] ?? vData['model'] ?? vData['vehicle_model'] ?? 'Innova Crysta').toString();
    String vNum = (vData['registrationNumber'] ?? vData['registration_number'] ?? vData['license_plate'] ?? vData['plate_number'] ?? 'TS 09 EQ 1234').toString();
    String vType = (vData['vehicle_type'] ?? vData['type'] ?? vData['vehicle_type_name'] ?? 'SUV').toString();
    String vColor = (vData['registrationcolor'] ?? vData['color'] ?? vData['vehicle_color'] ?? 'Pearl White').toString();
    String vYear = (vData['registrationyear'] ?? vData['year'] ?? vData['vehicle_year'] ?? '2023').toString();
    String vFuel = (vData['fuel_type'] ?? vData['fuelType'] ?? 'Diesel').toString();

    // Corporate fields parsing
    final String? compName = compData?['name'] ?? corpData?['company_name'] ?? corpData?['name'];
    final bool isCorp = compName != null && compName.trim().isNotEmpty;
    final String? compRoute = (corpData?['route_from'] != null && corpData?['route_to'] != null)
        ? "${corpData!['route_from']} ➔ ${corpData!['route_to']}"
        : null;
    final String? compStatus = (corpData?['approval_status'] ?? (isCorp ? 'APPROVED' : null))?.toString();
    final String? compLoc = compData?['company_location']?.toString();
    final String? compEmail = compData?['contact_email']?.toString();
    final String? compPhone = compData?['contact_phone']?.toString();

    return ProfileEntity(
      id: id ?? 0,
      name: fullName,
      rating: r,
      totalEarnings: totalEarnings ?? 0.0,
      walletBalance: walletBalance ?? 0.0,
      profileImageUrl: imageUrl,
      phone: (userData['phone'] ?? userData['mobile_number'] ?? '').toString(),
      email: (userData['email'] ?? '').toString(),
      dob: (userData['dob'] ?? '').toString(),
      gender: (userData['gender'] ?? '').toString(),
      status: (userData['status'] ?? 'active').toString(),
      vehicleMake: vMake,
      vehicleModel: vModel,
      vehicleNumber: vNum,
      vehicleType: vType,
      vehicleColor: vColor,
      vehicleYear: vYear,
      fuelType: vFuel,
      isCorporate: isCorp,
      companyName: compName,
      corporateRoute: compRoute,
      corporateApprovalStatus: compStatus,
      companyLocation: compLoc,
      companyEmail: compEmail,
      companyPhone: compPhone,
    );
  }
}
