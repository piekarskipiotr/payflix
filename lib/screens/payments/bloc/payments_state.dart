abstract class PaymentsState {
  @override
  String toString() => runtimeType.toString();
}

class InitPaymentsState extends PaymentsState {}

class FetchingPayments extends PaymentsState {}

class FetchingPaymentsCompleted extends PaymentsState {}
