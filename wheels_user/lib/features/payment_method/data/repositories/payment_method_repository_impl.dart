import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_local_datasource.dart';
import '../models/payment_method_model.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodLocalDataSource localDataSource;

  PaymentMethodRepositoryImpl({required this.localDataSource});

  @override
  Future<PaymentMethodEntity> getPaymentMethodDetails([String vehicleId = 'v1']) async {
    final model = await localDataSource.getPaymentMethodDetails(vehicleId);
    return model.toEntity();
  }
}
