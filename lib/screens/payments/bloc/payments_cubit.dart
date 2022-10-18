import 'dart:developer';
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/payment_month_action.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/month_payment_history.dart';
import 'package:payflix/data/model/month_payment_info.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/payments/bloc/payments_state.dart';

@injectable
class PaymentsCubit extends Cubit<PaymentsState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  final List<MonthPaymentInfo> _payments = List.empty(growable: true);

  PaymentsCubit(this._firestoreRepository, this._authRepository)
      : super(InitPaymentsState());

  int getDaysUntilNextPayment(PaymentInfo pi) => _payments.isEmpty
      ? 0
      : pi.getDaysUntilNextPayment(
          fromDate: _payments
              .firstWhere((element) =>
                  element.status == PaymentMonthStatus.unpaid ||
                  element.status == PaymentMonthStatus.priceModified)
              .date,
        );

  bool isItemEditable(MonthPaymentInfo mpi) {
    var highlightedMpi = _payments.firstWhere((element) =>
        element.status == PaymentMonthStatus.unpaid ||
        element.status == PaymentMonthStatus.priceModified);
    var previousIndex = _payments.indexOf(highlightedMpi) - 1;
    var currentMpiIndex = _payments.indexOf(mpi);

    return mpi == highlightedMpi || previousIndex == currentMpiIndex;
  }

  bool shouldBeHighlighted(MonthPaymentInfo mpi) =>
      mpi ==
      _payments.firstWhere((element) =>
          element.status == PaymentMonthStatus.unpaid ||
          element.status == PaymentMonthStatus.priceModified);

  Future changeMPIStatus(
    MonthPaymentInfo mpi,
    String userId,
    String groupId,
  ) async {
    emit(HandlingMonthPaymentInfo());
    var currentStatus = mpi.status;
    var now = clock.now();
    var today = DateTime(now.year, now.month, now.day);

    await _firestoreRepository.updateUserData(docReference: userId, data: {
      "payments.$groupId": FieldValue.arrayRemove([mpi.toJson()]),
    });

    if (currentStatus == PaymentMonthStatus.paid) {
      mpi.status = mpi.date.isBefore(today)
          ? PaymentMonthStatus.expired
          : PaymentMonthStatus.unpaid;
    } else {
      mpi.status = PaymentMonthStatus.paid;
    }

    mpi.history.add(
      MonthPaymentHistory(
        DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
          now.second,
        ),
        mpi.status == PaymentMonthStatus.paid
            ? PaymentMonthAction.markedAsPaid
            : PaymentMonthAction.markedAsUnpaid,
      ),
    );

    await _firestoreRepository.updateUserData(docReference: userId, data: {
      "payments.$groupId": FieldValue.arrayUnion([mpi.toJson()]),
    });

    emit(HandlingMonthPaymentInfoCompleted());
    await fetchPayments(groupId, userId);
  }

  List<MonthPaymentInfo> getPayments() => _payments.reversed.toList();

  Future fetchPayments(String groupId, String? userId) async {
    emit(FetchingPayments());

    var uid = userId ?? _authRepository.instance().currentUser!.uid;
    var user = await _firestoreRepository.getUserData(docReference: uid);
    var group = await _firestoreRepository.getGroupData(docReference: groupId);

    var isEdited = false;
    final payments = user.payments[group.getGroupId()] ?? [];
    final nextPayment = group.paymentInfo.getNextDate();
    // init payments dates if user don't have any
    if (payments.isEmpty) {
      isEdited = true;

      payments.addAll(
        [
          MonthPaymentInfo(
            group.getPaymentPerUser(),
            nextPayment,
            PaymentMonthStatus.unpaid,
            [],
          ),
          MonthPaymentInfo(
            group.getPaymentPerUser(),
            _getFuturePaymentDate(nextPayment, group.paymentInfo.dayOfTheMonth),
            PaymentMonthStatus.unpaid,
            [],
          ),
        ],
      );
    } else {
      // check if dates are missing and if generate them
      var now = clock.now();
      var today = DateTime(now.year, now.month, now.day);
      payments.sort((a, b) => a.date.compareTo(b.date));

      for (var mpi in payments) {
        if (mpi.status != PaymentMonthStatus.unpaid) {
          continue;
        }

        isEdited = true;
        if (mpi.date.isBefore(nextPayment)) {
          await _firestoreRepository
              .updateUserData(docReference: user.id, data: {
            "payments.$groupId": FieldValue.arrayRemove([mpi.toJson()]),
          });

          mpi.status = PaymentMonthStatus.expired;
        }
      }

      while (payments.last.date.isBefore(
          _getFuturePaymentDate(today, group.paymentInfo.dayOfTheMonth))) {
        isEdited = true;

        var date = _getFuturePaymentDate(
          payments.last.date,
          group.paymentInfo.dayOfTheMonth,
        );

        payments.add(MonthPaymentInfo(
          group.getPaymentPerUser(),
          date,
          date.isBefore(today)
              ? PaymentMonthStatus.expired
              : PaymentMonthStatus.unpaid,
          [],
        ));
      }
    }

    _payments.clear();
    _payments.addAll(payments);

    if (_payments[_payments.length - 2].status != PaymentMonthStatus.unpaid) {
      isEdited = true;

      var lastMpiDate = _payments.last.date;
      var nextDate =
          DateTime(lastMpiDate.year, lastMpiDate.month + 1, lastMpiDate.day);
      _payments.add(
        MonthPaymentInfo(
          group.getPaymentPerUser(),
          group.paymentInfo.getNextDate(fromDate: nextDate),
          PaymentMonthStatus.unpaid,
          [],
        ),
      );
    }

    if (isEdited) {
      await _firestoreRepository.updateUserData(
        docReference: user.id,
        data: {
          "payments.${group.getGroupId()}": FieldValue.arrayUnion(
            _payments.map((e) => e.toJson()).toList(),
          ),
        },
      );
    }

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
