import 'dart:developer';
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/month_payment_info.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/payments/bloc/payments_state.dart';

@singleton
class PaymentsCubit extends Cubit<PaymentsState> {
  final FirestoreRepository _firestoreRepository;
  final List<MonthPaymentInfo> _payments = List.empty(growable: true);

  PaymentsCubit(this._firestoreRepository) : super(InitPaymentsState());

  List<MonthPaymentInfo> getPayments() => _payments.reversed.toList();

  Future fetchPayments(PayflixUser user, Group group) async {
    emit(FetchingPayments());
    var isEdited = false;
    final payments = user.payments[group.getGroupId()] ?? [];

    // init payments dates if user don't have any
    if (payments.isEmpty) {
      isEdited = true;

      var nextPayment = group.paymentInfo.getNextDate();
      payments.addAll(
        [
          MonthPaymentInfo(
            nextPayment,
            PaymentMonthStatus.unpaid,
          ),
          MonthPaymentInfo(
            _getFuturePaymentDate(nextPayment, group.paymentInfo.dayOfTheMonth),
            PaymentMonthStatus.unpaid,
          ),
        ],
      );
    } else {
      // check if dates are missing and if generate them
      var now = clock.now();
      var today = DateTime(now.year, now.month, 1);
      while (payments.last.date.isBefore(_getFuturePaymentDate(today, group.paymentInfo.dayOfTheMonth))) {
        isEdited = true;

        var date = _getFuturePaymentDate(payments.last.date, group.paymentInfo.dayOfTheMonth);
        payments.add(
          MonthPaymentInfo(
            date,
            date.isBefore(today)
                ? PaymentMonthStatus.expired
                : PaymentMonthStatus.unpaid,
          ),
        );
      }
    }

    if (isEdited) {
      await _firestoreRepository.updateUserData(
        docReference: user.id,
        data: {
          "payments": {
            group.getGroupId(): FieldValue.arrayUnion(
              payments.map((e) => e.toJson()).toList(),
            ),
          },
        },
      );
    }

    _payments.clear();
    _payments.addAll(payments);
    emit(FetchingPaymentsCompleted());
  }

  DateTime _getFuturePaymentDate(DateTime date, int dayOfTheMonth) {
    var today = DateTime(date.year, date.month + 1, 1);
    var days = _daysInMonth(today);

    DateTime nextDate;
    if (days < dayOfTheMonth) {
      nextDate = DateTime(today.year, today.month, days);
    } else {
      nextDate = DateTime(today.year, today.month, dayOfTheMonth);
    }

    return nextDate;
  }

  int _daysInMonth(DateTime date) => DateTimeRange(
        start: DateTime(date.year, date.month, 1),
        end: DateTime(date.year, date.month + 1),
      ).duration.inDays;

  @override
  void onChange(Change<PaymentsState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
