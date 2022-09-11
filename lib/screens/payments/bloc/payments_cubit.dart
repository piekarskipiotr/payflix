import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/screens/payments/bloc/payments_state.dart';

@injectable
class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit() : super(InitPaymentsState());

  @override
  void onChange(Change<PaymentsState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
