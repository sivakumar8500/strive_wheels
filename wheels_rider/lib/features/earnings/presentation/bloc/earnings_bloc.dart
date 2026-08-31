import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_earnings_usecase.dart';
import 'earnings_event.dart';
import 'earnings_state.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final GetEarningsUseCase getEarningsUseCase;

  EarningsBloc({required this.getEarningsUseCase}) : super(EarningsInitial()) {
    on<GetEarningsEvent>(_onGetEarnings);
  }

  Future<void> _onGetEarnings(GetEarningsEvent event, Emitter<EarningsState> emit) async {
    emit(EarningsLoading());
    try {
      final earnings = await getEarningsUseCase(event.limit, event.offset);
      emit(EarningsLoaded(earnings));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }
}
