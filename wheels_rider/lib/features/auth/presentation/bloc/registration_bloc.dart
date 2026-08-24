import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/registration/submit_personal_info_usecase.dart';
import '../../domain/usecases/registration/submit_address_usecase.dart';
import '../../domain/usecases/registration/upload_file_usecase.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final SubmitPersonalInfoUsecase submitPersonalInfoUsecase;
  final SubmitAddressUsecase submitAddressUsecase;
  final UploadFileUseCase uploadFileUseCase;

  RegistrationBloc({
    required this.submitPersonalInfoUsecase,
    required this.submitAddressUsecase,
    required this.uploadFileUseCase,
  }) : super(RegistrationState.initial()) {
    on<NextStepEvent>((event, emit) {
      if (state.currentStep < 9) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStepEvent>((event, emit) {
      if (state.currentStep > 1) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<UpdatePersonalInfoEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        mobileNumber: event.mobileNumber ?? state.data.mobileNumber,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<SubmitPersonalInfoEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));

      final updatedData = state.data.copyWith(
        profilePhotoPath: event.profilePhotoPath ?? state.data.profilePhotoPath,
        firstName: event.firstName ?? state.data.firstName,
        lastName: event.lastName ?? state.data.lastName,
        mobileNumber: event.mobileNumber ?? state.data.mobileNumber,
        email: event.email ?? state.data.email,
        dateOfBirth: event.dateOfBirth ?? state.data.dateOfBirth,
        gender: event.gender ?? state.data.gender,
        referralCode: event.referralCode ?? state.data.referralCode,
      );

      try {
        String? profilePhotoUrl;
        if (updatedData.profilePhotoPath != null && updatedData.profilePhotoPath!.isNotEmpty) {
          if (!updatedData.profilePhotoPath!.startsWith('http')) {
            // Upload the file first
            profilePhotoUrl = await uploadFileUseCase(updatedData.profilePhotoPath!);
          } else {
            profilePhotoUrl = updatedData.profilePhotoPath;
          }
        }

        // Format DOB from MM/DD/YYYY to YYYY-MM-DD
        String formattedDob = "";
        if (updatedData.dateOfBirth != null && updatedData.dateOfBirth!.isNotEmpty) {
          try {
            if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(updatedData.dateOfBirth!)) {
              formattedDob = updatedData.dateOfBirth!;
            } else {
              final parts = updatedData.dateOfBirth!.split('/');
              if (parts.length == 3) {
                final month = parts[0].padLeft(2, '0');
                final day = parts[1].padLeft(2, '0');
                final year = parts[2];
                formattedDob = "$year-$month-$day";
              } else {
                formattedDob = updatedData.dateOfBirth!;
              }
            }
          } catch (_) {
            formattedDob = updatedData.dateOfBirth!;
          }
        }

        final payload = {
          "first_name": updatedData.firstName ?? "",
          "last_name": updatedData.lastName ?? "",
          "mobile_number": updatedData.mobileNumber ?? "",
          "email": updatedData.email ?? "",
          "dob": formattedDob,
          "gender": updatedData.gender?.toUpperCase() ?? "",
          "referral_code": updatedData.referralCode ?? "",
          "profile_photo_url": profilePhotoUrl ?? "",
        };

        // Explicitly printing the payload body so it's shown in the console/run logs
        print('========================================');
        print('=== REGISTRATION STEP 1 REQUEST BODY ===');
        print(payload);
        print('========================================');

        await submitPersonalInfoUsecase(payload);
        
        emit(state.copyWith(
          data: updatedData.copyWith(
            profilePhotoPath: profilePhotoUrl ?? updatedData.profilePhotoPath,
          ),
          status: RegistrationStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });

    on<SubmitAddressDetailsEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));

      final updatedData = state.data.copyWith(
        mapLocation: event.mapLocation ?? state.data.mapLocation,
        houseNo: event.houseNo ?? state.data.houseNo,
        streetName: event.streetName ?? state.data.streetName,
        landmark: event.landmark ?? state.data.landmark,
        pincode: event.pincode ?? state.data.pincode,
        city: event.city ?? state.data.city,
        state: event.state ?? state.data.state,
      );

      final payload = {
        "house_no": updatedData.houseNo,
        "street_area": updatedData.streetName,
        "landmark": updatedData.landmark,
        "pincode": updatedData.pincode,
        "city": updatedData.city,
        "state": updatedData.state,
        "latitude": 17.4312, // TODO: Get actual lat from map
        "longitude": 78.4069 // TODO: Get actual lng from map
      };

      try {
        await submitAddressUsecase(payload);
        emit(state.copyWith(
          data: updatedData,
          status: RegistrationStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });

    on<UpdateIdentityVerificationEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        selfiePath: event.selfiePath ?? state.data.selfiePath,
        aadhaarNumber: event.aadhaarNumber ?? state.data.aadhaarNumber,
        aadhaarFrontPath: event.aadhaarFrontPath ?? state.data.aadhaarFrontPath,
        aadhaarBackPath: event.aadhaarBackPath ?? state.data.aadhaarBackPath,
        panNumber: event.panNumber ?? state.data.panNumber,
        panFrontPath: event.panFrontPath ?? state.data.panFrontPath,
        dlNumber: event.dlNumber ?? state.data.dlNumber,
        dlFrontPath: event.dlFrontPath ?? state.data.dlFrontPath,
        dlBackPath: event.dlBackPath ?? state.data.dlBackPath,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<UpdateVehicleDocumentsEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        regExpiryDate: event.regExpiryDate ?? state.data.regExpiryDate,
        rcFrontPath: event.rcFrontPath ?? state.data.rcFrontPath,
        insurancePath: event.insurancePath ?? state.data.insurancePath,
        pucPath: event.pucPath ?? state.data.pucPath,
        fitnessCertPath: event.fitnessCertPath ?? state.data.fitnessCertPath,
        permitPath: event.permitPath ?? state.data.permitPath,
        vehicleFrontViewPath:
            event.vehicleFrontViewPath ?? state.data.vehicleFrontViewPath,
        vehicleBackViewPath:
            event.vehicleBackViewPath ?? state.data.vehicleBackViewPath,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<UpdateVehicleDetailsEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        vehicleType: event.vehicleType ?? state.data.vehicleType,
        vehicleManufacturer:
            event.vehicleManufacturer ?? state.data.vehicleManufacturer,
        vehicleModel: event.vehicleModel ?? state.data.vehicleModel,
        vehicleRegNumber: event.vehicleRegNumber ?? state.data.vehicleRegNumber,
        vehicleYear: event.vehicleYear ?? state.data.vehicleYear,
        vehicleColor: event.vehicleColor ?? state.data.vehicleColor,
        vehicleChassisNumber:
            event.vehicleChassisNumber ?? state.data.vehicleChassisNumber,
        vehicleEngineNumber:
            event.vehicleEngineNumber ?? state.data.vehicleEngineNumber,
        vehicleTotalSeats:
            event.vehicleTotalSeats ?? state.data.vehicleTotalSeats,
        vehicleFuelType: event.vehicleFuelType ?? state.data.vehicleFuelType,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<UpdateBankDetailsEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        bankAccountHolderName:
            event.bankAccountHolderName ?? state.data.bankAccountHolderName,
        bankName: event.bankName ?? state.data.bankName,
        bankIfscCode: event.bankIfscCode ?? state.data.bankIfscCode,
        bankAccountNumber:
            event.bankAccountNumber ?? state.data.bankAccountNumber,
        bankUpiId: event.bankUpiId ?? state.data.bankUpiId,
        bankChequePath: event.bankChequePath ?? state.data.bankChequePath,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<UpdateEmergencyContactEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        emergencyContactName:
            event.emergencyContactName ?? state.data.emergencyContactName,
        emergencyContactRelation:
            event.emergencyContactRelation ??
            state.data.emergencyContactRelation,
        emergencyContactPhone:
            event.emergencyContactPhone ?? state.data.emergencyContactPhone,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<AgreeToTermsEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        agreedToTerms: event.agreedToTerms,
      );
      emit(state.copyWith(data: updatedData));
    });
  }
}
