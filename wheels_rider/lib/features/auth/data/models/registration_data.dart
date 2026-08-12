class RegistrationData {
  final String? profilePhotoPath;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? referralCode;

  // Address Details (Step 2)
  final String? mapLocation;
  final String? houseNo;
  final String? streetName;
  final String? landmark;
  final String? pincode;
  final String? city;
  final String? state;

  // Identity Verification (Step 3)
  final String? selfiePath;
  final String? aadhaarNumber;
  final String? aadhaarFrontPath;
  final String? aadhaarBackPath;
  final String? panNumber;
  final String? panFrontPath;
  final String? dlNumber;
  final String? dlFrontPath;
  final String? dlBackPath;

  // Vehicle Documents (Step 4)
  final String? regExpiryDate;
  final String? rcFrontPath;
  final String? insurancePath;
  final String? pucPath;
  final String? fitnessCertPath;
  final String? permitPath;
  final String? vehicleFrontViewPath;
  final String? vehicleBackViewPath;

  // Vehicle Details (Step 5)
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

  // Bank Details (Step 6)
  final String? bankAccountHolderName;
  final String? bankName;
  final String? bankIfscCode;
  final String? bankAccountNumber;
  final String? bankUpiId;
  final String? bankChequePath;

  // Emergency Contact (Step 7)
  final String? emergencyContactName;
  final String? emergencyContactRelation;
  final String? emergencyContactPhone;

  // Terms Agreement (Step 8/9)
  final bool agreedToTerms;

  const RegistrationData({
    this.profilePhotoPath,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.referralCode,
    this.mapLocation,
    this.houseNo,
    this.streetName,
    this.landmark,
    this.pincode,
    this.city,
    this.state,
    this.selfiePath,
    this.aadhaarNumber,
    this.aadhaarFrontPath,
    this.aadhaarBackPath,
    this.panNumber,
    this.panFrontPath,
    this.dlNumber,
    this.dlFrontPath,
    this.dlBackPath,
    this.regExpiryDate,
    this.rcFrontPath,
    this.insurancePath,
    this.pucPath,
    this.fitnessCertPath,
    this.permitPath,
    this.vehicleFrontViewPath,
    this.vehicleBackViewPath,
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
    this.bankAccountHolderName,
    this.bankName,
    this.bankIfscCode,
    this.bankAccountNumber,
    this.bankUpiId,
    this.bankChequePath,
    this.emergencyContactName,
    this.emergencyContactRelation,
    this.emergencyContactPhone,
    this.agreedToTerms = false,
  });

  RegistrationData copyWith({
    String? profilePhotoPath,
    String? firstName,
    String? lastName,
    String? mobileNumber,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? referralCode,
    String? mapLocation,
    String? houseNo,
    String? streetName,
    String? landmark,
    String? pincode,
    String? city,
    String? state,
    String? selfiePath,
    String? aadhaarNumber,
    String? aadhaarFrontPath,
    String? aadhaarBackPath,
    String? panNumber,
    String? panFrontPath,
    String? dlNumber,
    String? dlFrontPath,
    String? dlBackPath,
    String? regExpiryDate,
    String? rcFrontPath,
    String? insurancePath,
    String? pucPath,
    String? fitnessCertPath,
    String? permitPath,
    String? vehicleFrontViewPath,
    String? vehicleBackViewPath,
    String? vehicleType,
    String? vehicleManufacturer,
    String? vehicleModel,
    String? vehicleRegNumber,
    String? vehicleYear,
    String? vehicleColor,
    String? vehicleChassisNumber,
    String? vehicleEngineNumber,
    String? vehicleTotalSeats,
    String? vehicleFuelType,
    String? bankAccountHolderName,
    String? bankName,
    String? bankIfscCode,
    String? bankAccountNumber,
    String? bankUpiId,
    String? bankChequePath,
    String? emergencyContactName,
    String? emergencyContactRelation,
    String? emergencyContactPhone,
    bool? agreedToTerms,
  }) {
    return RegistrationData(
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      referralCode: referralCode ?? this.referralCode,
      mapLocation: mapLocation ?? this.mapLocation,
      houseNo: houseNo ?? this.houseNo,
      streetName: streetName ?? this.streetName,
      landmark: landmark ?? this.landmark,
      pincode: pincode ?? this.pincode,
      city: city ?? this.city,
      state: state ?? this.state,
      selfiePath: selfiePath ?? this.selfiePath,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      aadhaarFrontPath: aadhaarFrontPath ?? this.aadhaarFrontPath,
      aadhaarBackPath: aadhaarBackPath ?? this.aadhaarBackPath,
      panNumber: panNumber ?? this.panNumber,
      panFrontPath: panFrontPath ?? this.panFrontPath,
      dlNumber: dlNumber ?? this.dlNumber,
      dlFrontPath: dlFrontPath ?? this.dlFrontPath,
      dlBackPath: dlBackPath ?? this.dlBackPath,
      regExpiryDate: regExpiryDate ?? this.regExpiryDate,
      rcFrontPath: rcFrontPath ?? this.rcFrontPath,
      insurancePath: insurancePath ?? this.insurancePath,
      pucPath: pucPath ?? this.pucPath,
      fitnessCertPath: fitnessCertPath ?? this.fitnessCertPath,
      permitPath: permitPath ?? this.permitPath,
      vehicleFrontViewPath: vehicleFrontViewPath ?? this.vehicleFrontViewPath,
      vehicleBackViewPath: vehicleBackViewPath ?? this.vehicleBackViewPath,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleManufacturer: vehicleManufacturer ?? this.vehicleManufacturer,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleRegNumber: vehicleRegNumber ?? this.vehicleRegNumber,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleChassisNumber: vehicleChassisNumber ?? this.vehicleChassisNumber,
      vehicleEngineNumber: vehicleEngineNumber ?? this.vehicleEngineNumber,
      vehicleTotalSeats: vehicleTotalSeats ?? this.vehicleTotalSeats,
      vehicleFuelType: vehicleFuelType ?? this.vehicleFuelType,
      bankAccountHolderName:
          bankAccountHolderName ?? this.bankAccountHolderName,
      bankName: bankName ?? this.bankName,
      bankIfscCode: bankIfscCode ?? this.bankIfscCode,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankUpiId: bankUpiId ?? this.bankUpiId,
      bankChequePath: bankChequePath ?? this.bankChequePath,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactRelation:
          emergencyContactRelation ?? this.emergencyContactRelation,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    );
  }
}
