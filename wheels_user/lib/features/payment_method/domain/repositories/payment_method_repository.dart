import '../entities/payment_method_entity.dart';

abstract class PaymentMethodRepository {
  Future<PaymentMethodEntity> getPaymentMethodDetails([String vehicleId = 'v1']);
}
