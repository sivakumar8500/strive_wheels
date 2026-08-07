import '../entities/payment_method_entity.dart';
import '../repositories/payment_method_repository.dart';

class GetPaymentMethodUseCase {
  final PaymentMethodRepository repository;

  GetPaymentMethodUseCase(this.repository);

  Future<PaymentMethodEntity> call([String vehicleId = 'v1']) async {
    return await repository.getPaymentMethodDetails(vehicleId);
  }
}
