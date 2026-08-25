import 'package:flutter/foundation.dart';
import '../../data/models/registration_data.dart';

@immutable
abstract class RegistrationEvent {
  const RegistrationEvent();
}

class NextStepEvent extends RegistrationEvent {}

class PreviousStepEvent extends RegistrationEvent {}

class SetInitialStepEvent extends RegistrationEvent {
  final int step;
  const SetInitialStepEvent({required this.step});
}


class UpdatePersonalInfoEvent extends RegistrationEvent {
  final String? mobileNumber;

  const UpdatePersonalInfoEvent({this.mobileNumber});
}

class SubmitPersonalInfoEvent extends RegistrationEvent {
  final String? profilePhotoPath;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? referralCode;

  const SubmitPersonalInfoEvent({
    this.profilePhotoPath,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.referralCode,
  });
}

class SubmitAddressDetailsEvent extends RegistrationEvent {
  final String? mapLocation;
  final String? houseNo;
  final String? streetName;
  final String? landmark;
  final String? pincode;
  final String? city;
  final String? state;

  const SubmitAddressDetailsEvent({
    this.mapLocation,
    this.houseNo,
    this.streetName,
    this.landmark,
    this.pincode,
    this.city,
    this.state,
  });
}

class UpdateIdentityVerificationEvent extends RegistrationEvent {
  final String? selfiePath;
  final String? aadhaarNumber;
  final String? aadhaarFrontPath;
  final String? aadhaarBackPath;
  final String? panNumber;
  final String? panFrontPath;
  final String? dlNumber;
  final String? dlFrontPath;
  final String? dlBackPath;

  const UpdateIdentityVerificationEvent({
    this.selfiePath,
    this.aadhaarNumber,
    this.aadhaarFrontPath,
    this.aadhaarBackPath,
    this.panNumber,
    this.panFrontPath,
    this.dlNumber,
    this.dlFrontPath,
    this.dlBackPath,
  });
}

class UpdateVehicleDocumentsEvent extends RegistrationEvent {
  final String? regExpiryDate;
  final String? rcFrontPath;
  final String? insurancePath;
  final String? pucPath;
  final String? fitnessCertPath;
  final String? permitPath;
  final String? vehicleFrontViewPath;
  final String? vehicleBackViewPath;

  const UpdateVehicleDocumentsEvent({
    this.regExpiryDate,
    this.rcFrontPath,
    this.insurancePath,
    this.pucPath,
    this.fitnessCertPath,
    this.permitPath,
    this.vehicleFrontViewPath,
    this.vehicleBackViewPath,
  });
}

class UpdateVehicleDetailsEvent extends RegistrationEvent {
  final String? vehicleType;
  final String? vehicleManufacturer;
  final String? vehicleModel;
  final String? vehicleRegNumber;
  final String? vehicleYear;
  final String? vehicleColor;
  final String? vehicleChassisNumber;
  final String? vehicleEngineNumber;
  final String? vehicleTotalSeats;
  final String? vehicleFuelType;

  const UpdateVehicleDetailsEvent({
    this.vehicleType,
    this.vehicleManufacturer,
    this.vehicleModel,
    this.vehicleRegNumber,
    this.vehicleYear,
    this.vehicleColor,
    this.vehicleChassisNumber,
    this.vehicleEngineNumber,
    this.vehicleTotalSeats,
    this.vehicleFuelType,
  });
}

class UpdateBankDetailsEvent extends RegistrationEvent {
  final String? bankAccountHolderName;
  final String? bankName;
  final String? bankIfscCode;
  final String? bankAccountNumber;
  final String? bankUpiId;
  final String? bankChequePath;

  const UpdateBankDetailsEvent({
    this.bankAccountHolderName,
    this.bankName,
    this.bankIfscCode,
    this.bankAccountNumber,
    this.bankUpiId,
    this.bankChequePath,
  });
}

class UpdateEmergencyContactEvent extends RegistrationEvent {
  final String? emergencyContactName;
  final String? emergencyContactRelation;
  final String? emergencyContactPhone;

  const UpdateEmergencyContactEvent({
    this.emergencyContactName,
    this.emergencyContactRelation,
    this.emergencyContactPhone,
  });
}

class AgreeToTermsEvent extends RegistrationEvent {
  final bool agreedToTerms;

  const AgreeToTermsEvent(this.agreedToTerms);
}
