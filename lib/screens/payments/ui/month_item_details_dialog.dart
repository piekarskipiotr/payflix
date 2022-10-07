import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payflix/data/enum/payment_month_action.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/month_payment_info.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/payments/bloc/payments_cubit.dart';
import 'package:payflix/screens/payments/bloc/payments_state.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';

class MonthItemDetailsDialog extends StatelessWidget {
  final MonthPaymentInfo mpi;
  final PaymentInfo paymentInfo;
  final String userId;
  final String groupId;

  const MonthItemDetailsDialog({
    Key? key,
    required this.mpi,
    required this.paymentInfo,
    required this.userId,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentsCubit, PaymentsState>(
      listener: (context, state) {
        if (state is HandlingMonthPaymentInfoCompleted) {
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: AppColors.lighterGray,
                  borderRadius: BorderRadius.circular(28.0),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mpi.monthName,
                        style: GoogleFonts.oxygen(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.creamWhite,
                        ),
                      ),
                      Text(
                        '${paymentInfo.monthlyPayment} PLN',
                        style: GoogleFonts.oxygen(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.creamWhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    mpi.status.getName(context),
                    style: GoogleFonts.oxygen(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.creamWhite,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Divider(
                    height: 1,
                    color: AppColors.lighterGray,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    getString(context).history,
                    style: GoogleFonts.oxygen(
                      fontSize: 16.0,
                      color: AppColors.creamWhite,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  if (mpi.history.isNotEmpty) ...[
                    for (var e in mpi.history) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.action.getName(context),
                            style: GoogleFonts.oxygen(
                              fontSize: 14.0,
                              color: AppColors.creamWhite,
                            ),
                          ),
                          Text(
                            DateFormat('dd-MM-yyyy HH:mm:ss').format(e.date),
                            style: GoogleFonts.oxygen(
                              fontSize: 14.0,
                              color: AppColors.creamWhite,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                    ],
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getString(context).nothing_yet,
                          style: GoogleFonts.oxygen(
                            fontSize: 14.0,
                            color: AppColors.creamWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(
                    height: 64.0,
                  ),
                  Text(
                    mpi.status == PaymentMonthStatus.paid
                        ? getString(context).history_details_unpaid
                        : getString(context).history_details_paid,
                    style: GoogleFonts.oxygen(
                      fontSize: 12.0,
                      color: AppColors.creamWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              BlocBuilder<PaymentsCubit, PaymentsState>(
                builder: (context, state) => PrimaryButton(
                  text: mpi.status == PaymentMonthStatus.paid
                      ? getString(context).mark_as_unpaid
                      : getString(context).mark_as_paid,
                  onClick: () => context.read<PaymentsCubit>().changeMPIStatus(
                        mpi,
                        paymentInfo,
                        userId,
                        groupId,
                      ),
                  isLoading: state is HandlingMonthPaymentInfo,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              SecondaryButton(
                text: getString(context).close,
                isLoading: false,
                onClick: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
