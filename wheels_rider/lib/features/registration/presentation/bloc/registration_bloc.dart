import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_registration_state_usecase.dart';
import '../../domain/usecases/submit_registration_usecase.dart';
import '../../domain/usecases/submit_bank_details_usecase.dart';
import '../../domain/usecases/submit_emergency_contact_usecase.dart';
import '../../domain/usecases/submit_instant_registration_usecase.dart';
import '../../domain/usecases/submit_personal_info_usecase.dart';
import '../../domain/usecases/submit_address_usecase.dart';
import '../../domain/usecases/submit_kyc_usecase.dart';
import '../../domain/usecases/submit_vehicle_details_usecase.dart';
import '../../domain/usecases/submit_vehicle_docs_usecase.dart';
import '../../domain/usecases/upload_file_usecase.dart';
import '../../data/models/registration_step_response.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final GetRegistrationStateUseCase getRegistrationStateUseCase;
  final SubmitInstantRegistrationUseCase submitInstantRegistrationUseCase;
  final SubmitPersonalInfoUsecase submitPersonalInfoUsecase;
  final SubmitAddressUsecase submitAddressUsecase;
  final SubmitKycUsecase submitKycUsecase;
  final SubmitVehicleDetailsUsecase submitVehicleDetailsUsecase;
  final SubmitVehicleDocsUsecase submitVehicleDocsUsecase;
  final SubmitBankDetailsUsecase submitBankDetailsUsecase;
  final SubmitEmergencyContactUsecase submitEmergencyContactUsecase;
  final SubmitRegistrationUsecase submitRegistrationUsecase;
  final UploadFileUseCase uploadFileUseCase;

  RegistrationBloc({
    required this.getRegistrationStateUseCase,
    required this.submitInstantRegistrationUseCase,
    required this.submitPersonalInfoUsecase,
    required this.submitAddressUsecase,
    required this.submitKycUsecase,
    required this.submitVehicleDetailsUsecase,
    required this.submitVehicleDocsUsecase,
    required this.submitBankDetailsUsecase,
    required this.submitEmergencyContactUsecase,
    required this.submitRegistrationUsecase,
    required this.uploadFileUseCase,
  }) : super(RegistrationState.initial()) {
    on<FetchRegistrationStateEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));
      try {
        final response = await getRegistrationStateUseCase();
        if (response.success && response.data != null && response.data!.currentStep > 0) {
          final nextStep = _getNextStep(response, response.data!.currentStep);
          emit(state.copyWith(
            currentStep: nextStep,
            status: RegistrationStatus.success,
          ));
        }
      } catch (_) {
        emit(state.copyWith(status: RegistrationStatus.initial));
      }
    });
    on<SubmitInstantRegistrationEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));
      try {
        final response = await submitInstantRegistrationUseCase();
        final nextStep = _getNextStep(response, 2);
        emit(state.copyWith(
          currentStep: nextStep,
          status: RegistrationStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    });

    on<NextStepEvent>((event, emit) {
      if (state.currentStep < 10) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStepEvent>((event, emit) {
      if (state.currentStep > 2) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<SetInitialStepEvent>((event, emit) {
      if (event.step >= 1 && event.step <= 10) {
        emit(state.copyWith(currentStep: event.step));
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
        debugPrint('========================================');
        debugPrint('=== REGISTRATION STEP 1 REQUEST BODY ===');
        debugPrint(payload.toString());
        debugPrint('========================================');

        final response = await submitPersonalInfoUsecase(payload);
        final nextStep = _getNextStep(response, state.currentStep + 1);
        
        emit(state.copyWith(
          currentStep: nextStep,
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
        final response = await submitAddressUsecase(payload);
        final nextStep = _getNextStep(response, state.currentStep + 1);
        emit(state.copyWith(
          currentStep: nextStep,
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

    on<UpdateIdentityVerificationEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));

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

      try {
        String? selfieUrl = updatedData.selfiePath;
        if (selfieUrl != null && selfieUrl.isNotEmpty && !selfieUrl.startsWith('http')) {
          selfieUrl = await uploadFileUseCase(selfieUrl);
        }
        String? aadhaarFrontUrl = updatedData.aadhaarFrontPath;
        if (aadhaarFrontUrl != null && aadhaarFrontUrl.isNotEmpty && !aadhaarFrontUrl.startsWith('http')) {
          aadhaarFrontUrl = await uploadFileUseCase(aadhaarFrontUrl);
        }
        String? aadhaarBackUrl = updatedData.aadhaarBackPath;
        if (aadhaarBackUrl != null && aadhaarBackUrl.isNotEmpty && !aadhaarBackUrl.startsWith('http')) {
          aadhaarBackUrl = await uploadFileUseCase(aadhaarBackUrl);
        }
        String? panFrontUrl = updatedData.panFrontPath;
        if (panFrontUrl != null && panFrontUrl.isNotEmpty && !panFrontUrl.startsWith('http')) {
          panFrontUrl = await uploadFileUseCase(panFrontUrl);
        }
        String? dlFrontUrl = updatedData.dlFrontPath;
        if (dlFrontUrl != null && dlFrontUrl.isNotEmpty && !dlFrontUrl.startsWith('http')) {
          dlFrontUrl = await uploadFileUseCase(dlFrontUrl);
        }
        String? dlBackUrl = updatedData.dlBackPath;
        if (dlBackUrl != null && dlBackUrl.isNotEmpty && !dlBackUrl.startsWith('http')) {
          dlBackUrl = await uploadFileUseCase(dlBackUrl);
        }

        final payload = {
          "selfie_url": selfieUrl ?? "",
          "aadhaar_number": updatedData.aadhaarNumber ?? "",
          "aadhaar_front_url": aadhaarFrontUrl ?? "",
          "aadhaar_back_url": aadhaarBackUrl ?? "",
          "pan_number": updatedData.panNumber ?? "",
          "pan_front_url": panFrontUrl ?? "",
          "dl_number": updatedData.dlNumber ?? "",
          "dl_front_url": dlFrontUrl ?? "",
          "dl_back_url": dlBackUrl ?? ""
        };

        final response = await submitKycUsecase(payload);
        final nextStep = _getNextStep(response, state.currentStep + 1);

        emit(state.copyWith(
          currentStep: nextStep,
          data: updatedData.copyWith(
            selfiePath: selfieUrl ?? updatedData.selfiePath,
            aadhaarFrontPath: aadhaarFrontUrl ?? updatedData.aadhaarFrontPath,
            aadhaarBackPath: aadhaarBackUrl ?? updatedData.aadhaarBackPath,
            panFrontPath: panFrontUrl ?? updatedData.panFrontPath,
            dlFrontPath: dlFrontUrl ?? updatedData.dlFrontPath,
            dlBackPath: dlBackUrl ?? updatedData.dlBackPath,
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

    on<UpdateVehicleDocumentsEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));

      final updatedData = state.data.copyWith(
        regDate: event.regDate ?? state.data.regDate,
        regExpiryDate: event.regExpiryDate ?? state.data.regExpiryDate,
        rcFrontPath: event.rcFrontPath ?? state.data.rcFrontPath,
        rcBackPath: event.rcBackPath ?? state.data.rcBackPath,
        insurancePath: event.insurancePath ?? state.data.insurancePath,
        pucPath: event.pucPath ?? state.data.pucPath,
        fitnessCertPath: event.fitnessCertPath ?? state.data.fitnessCertPath,
        permitPath: event.permitPath ?? state.data.permitPath,
        vehicleFrontViewPath:
            event.vehicleFrontViewPath ?? state.data.vehicleFrontViewPath,
        vehicleBackViewPath:
            event.vehicleBackViewPath ?? state.data.vehicleBackViewPath,
        vehicleLeftSideViewPath:
            event.vehicleLeftSideViewPath ?? state.data.vehicleLeftSideViewPath,
        vehicleRightSideViewPath:
            event.vehicleRightSideViewPath ?? state.data.vehicleRightSideViewPath,
        vehicleInsideView1Path:
            event.vehicleInsideView1Path ?? state.data.vehicleInsideView1Path,
        vehicleInsideView2Path:
            event.vehicleInsideView2Path ?? state.data.vehicleInsideView2Path,
      );

      try {
        Future<String?> upload(String? path) async {
          if (path != null && path.isNotEmpty && !path.startsWith('http')) {
            return await uploadFileUseCase(path);
          }
          return path;
        }

        final rcFrontUrl = await upload(updatedData.rcFrontPath);
        final rcBackUrl = await upload(updatedData.rcBackPath);
        final insuranceUrl = await upload(updatedData.insurancePath);
        final pucUrl = await upload(updatedData.pucPath);
        final fitnessUrl = await upload(updatedData.fitnessCertPath);
        final permitUrl = await upload(updatedData.permitPath);
        final frontViewUrl = await upload(updatedData.vehicleFrontViewPath);
        final backViewUrl = await upload(updatedData.vehicleBackViewPath);
        final leftSideViewUrl = await upload(updatedData.vehicleLeftSideViewPath);
        final rightSideViewUrl = await upload(updatedData.vehicleRightSideViewPath);
        final insideView1Url = await upload(updatedData.vehicleInsideView1Path);
        final insideView2Url = await upload(updatedData.vehicleInsideView2Path);

        String formatDate(String? dateStr) {
          if (dateStr == null || dateStr.isEmpty) return "";
          try {
            if (dateStr.contains('/')) {
              final parts = dateStr.split('/');
              if (parts.length == 3) {
                final month = parts[0].padLeft(2, '0');
                final day = parts[1].padLeft(2, '0');
                final year = parts[2];
                return "$year-$month-$day";
              }
            }
            return dateStr;
          } catch (_) {
            return dateStr;
          }
        }

        final vehicalPicks = <String>[];
        if (frontViewUrl != null && frontViewUrl.isNotEmpty) vehicalPicks.add(frontViewUrl);
        if (backViewUrl != null && backViewUrl.isNotEmpty) vehicalPicks.add(backViewUrl);
        if (leftSideViewUrl != null && leftSideViewUrl.isNotEmpty) vehicalPicks.add(leftSideViewUrl);
        if (rightSideViewUrl != null && rightSideViewUrl.isNotEmpty) vehicalPicks.add(rightSideViewUrl);
        if (insideView1Url != null && insideView1Url.isNotEmpty) vehicalPicks.add(insideView1Url);
        if (insideView2Url != null && insideView2Url.isNotEmpty) vehicalPicks.add(insideView2Url);

        final payload = {
          "registationDate": formatDate(updatedData.regDate),
          "ecpairDate": formatDate(updatedData.regExpiryDate),
          "rcFrontView": rcFrontUrl ?? "",
          "rcBackView": rcBackUrl ?? "",
          "insurancy": insuranceUrl ?? "",
          "poliction": pucUrl ?? "",
          "fitNessCirtificate": fitnessUrl ?? "",
          "permit": permitUrl ?? "",
          "vehicalPicks": vehicalPicks,
        };

        final response = await submitVehicleDocsUsecase(payload);
        if (response.success) {
          final nextStep = _getNextStep(response, state.currentStep + 1);
          emit(state.copyWith(
            currentStep: nextStep,
            data: updatedData.copyWith(
              rcFrontPath: rcFrontUrl,
              rcBackPath: rcBackUrl,
              insurancePath: insuranceUrl,
              pucPath: pucUrl,
              fitnessCertPath: fitnessUrl,
              permitPath: permitUrl,
              vehicleFrontViewPath: frontViewUrl,
              vehicleBackViewPath: backViewUrl,
              vehicleLeftSideViewPath: leftSideViewUrl,
              vehicleRightSideViewPath: rightSideViewUrl,
              vehicleInsideView1Path: insideView1Url,
              vehicleInsideView2Path: insideView2Url,
            ),
            status: RegistrationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: _getErrorMessage(response, "Failed to submit vehicle documents"),
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: _parseErrorMessage(e),
        ));
      }
    });

    on<UpdateVehicleDetailsEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));
      final updatedData = state.data.copyWith(
        vehicleTypeId: event.vehicleTypeId ?? state.data.vehicleTypeId,
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

      final payload = {
        "vehicle_type_id": updatedData.vehicleTypeId ?? 1,
        "compenyName": updatedData.vehicleManufacturer ?? "",
        "vehicalModel": updatedData.vehicleModel ?? "",
        "registrationNumber": updatedData.vehicleRegNumber ?? "",
        "registrationyear": int.tryParse(updatedData.vehicleYear ?? "") ?? DateTime.now().year,
        "registrationcolor": updatedData.vehicleColor ?? "",
        "chassisNumber": updatedData.vehicleChassisNumber ?? "",
        "engineNumber": updatedData.vehicleEngineNumber ?? "",
        "total_seats": int.tryParse((updatedData.vehicleTotalSeats ?? "").replaceAll(RegExp(r'[^0-9]'), '')) ?? 4,
        "fuel_type": (updatedData.vehicleFuelType ?? "PETROL").toUpperCase(),
      };

      try {
        final response = await submitVehicleDetailsUsecase(payload);
        if (response.success) {
          final nextStep = _getNextStep(response, state.currentStep + 1);
          emit(state.copyWith(
            currentStep: nextStep,
            data: updatedData,
            status: RegistrationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: _getErrorMessage(response, "Failed to submit vehicle details"),
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: _parseErrorMessage(e),
        ));
      }
    });

    on<UpdateBankDetailsEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));
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

      try {
        String? chequeUrl;
        if (updatedData.bankChequePath != null &&
            updatedData.bankChequePath!.isNotEmpty) {
          if (!updatedData.bankChequePath!.startsWith('http')) {
            chequeUrl = await uploadFileUseCase(updatedData.bankChequePath!);
          } else {
            chequeUrl = updatedData.bankChequePath;
          }
        }

        final payload = {
          "account_holder_name": updatedData.bankAccountHolderName ?? "",
          "bank_name": updatedData.bankName ?? "",
          "ifsc_code": updatedData.bankIfscCode ?? "",
          "account_number": updatedData.bankAccountNumber ?? "",
          "confirm_account_number": updatedData.bankAccountNumber ?? "",
          "upi_id": updatedData.bankUpiId ?? "",
          "cancelled_cheque_url": chequeUrl ?? "",
        };

        final response = await submitBankDetailsUsecase(payload);
        if (response.success) {
          final nextStep = _getNextStep(response, state.currentStep + 1);
          emit(state.copyWith(
            currentStep: nextStep,
            data: updatedData.copyWith(bankChequePath: chequeUrl),
            status: RegistrationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: _getErrorMessage(response, "Failed to submit bank details"),
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: _parseErrorMessage(e),
        ));
      }
    });

    on<UpdateEmergencyContactEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));
      final updatedData = state.data.copyWith(
        emergencyContactName:
            event.emergencyContactName ?? state.data.emergencyContactName,
        emergencyContactRelation:
            event.emergencyContactRelation ??
            state.data.emergencyContactRelation,
        emergencyContactPhone:
            event.emergencyContactPhone ?? state.data.emergencyContactPhone,
      );

      String formattedPhone = updatedData.emergencyContactPhone ?? "";
      if (formattedPhone.isNotEmpty && !formattedPhone.startsWith('+91')) {
        formattedPhone = "+91$formattedPhone";
      }

      final payload = {
        "contact_name": updatedData.emergencyContactName ?? "",
        "relationship_type": updatedData.emergencyContactRelation ?? "",
        "phone_number": formattedPhone,
      };

      try {
        final response = await submitEmergencyContactUsecase(payload);
        if (response.success) {
          final nextStep = _getNextStep(response, state.currentStep + 1);
          emit(state.copyWith(
            currentStep: nextStep,
            data: updatedData,
            status: RegistrationStatus.success,
          ));
        } else {
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: _getErrorMessage(response, "Failed to submit emergency contact"),
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: _parseErrorMessage(e),
        ));
      }
    });

    on<AgreeToTermsEvent>((event, emit) {
      final updatedData = state.data.copyWith(
        agreedToTerms: event.agreedToTerms,
      );
      emit(state.copyWith(data: updatedData));
    });

    on<SubmitRegistrationEvent>((event, emit) async {
      emit(state.copyWith(status: RegistrationStatus.loading));
      final payload = {
        "terms_accepted": true,
        "privacy_policy_accepted": true,
        "terms_version": "1.0",
        "privacy_policy_version": "1.0"
      };

      try {
        final response = await submitRegistrationUsecase(payload);
        if (response.success) {
          emit(state.copyWith(
            currentStep: 10,
            status: RegistrationStatus.success,
          ));
        } else {
          final errorMsg = response.message.isNotEmpty
              ? response.message
              : (response.data != null && response.data!.message.isNotEmpty
                  ? response.data!.message
                  : "Failed to submit final registration");
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: errorMsg,
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: RegistrationStatus.failure,
          errorMessage: _parseErrorMessage(e),
        ));
      }
    });
  }

  int _getNextStep(RegistrationStepResponse response, int fallback) {
    if (response.data?.nextStep != null && response.data!.nextStep! > 0) {
      return response.data!.nextStep!;
    }
    return fallback;
  }

  String _getErrorMessage(RegistrationStepResponse response, String fallback) {
    if (response.message.isNotEmpty) return response.message;
    if (response.data != null && response.data!.message.isNotEmpty) {
      return response.data!.message;
    }
    return fallback;
  }

  String _parseErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data is Map) {
        final map = error.response!.data as Map;
        if (map['message'] != null && map['message'].toString().isNotEmpty) {
          return map['message'].toString();
        }
      }
      if (error.message != null && error.message!.isNotEmpty) {
        return error.message!;
      }
    }
    final str = error.toString();
    if (str.startsWith('Exception: ')) {
      return str.substring(11);
    }
    return str;
  }
}
