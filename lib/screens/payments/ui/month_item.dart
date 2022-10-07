import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/month_payment_info.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/screens/payments/bloc/payments_cubit.dart';
import 'package:payflix/screens/payments/ui/month_item_details_dialog.dart';

class MonthItem extends StatefulWidget {
  final MonthPaymentInfo mpi;
  final PaymentInfo paymentInfo;
  final String userId;
  final String groupId;
  final bool isHighlighted;

  const MonthItem({
    Key? key,
    required this.mpi,
    required this.paymentInfo,
    required this.userId,
    required this.groupId,
    required this.isHighlighted,
  }) : super(key: key);

  @override
  State<MonthItem> createState() => _MonthItemState();
}

class _MonthItemState extends State<MonthItem> {
  late MonthPaymentInfo _mpi;
  late PaymentInfo _paymentInfo;
  late String _userId;
  late String _groupId;
  late bool _isHighlighted;

  @override
  void initState() {
    _mpi = widget.mpi;
    _paymentInfo = widget.paymentInfo;
    _userId = widget.userId;
    _groupId = widget.groupId;
    _isHighlighted = widget.isHighlighted;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0,
        right: (_isHighlighted ? 10.0 : 24.0),
        bottom: 18.0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => AppDialogController.showBottomSheetDialog(
            context: context,
            dialog: BlocProvider.value(
              value: context.read<PaymentsCubit>(),
              child: MonthItemDetailsDialog(
                mpi: _mpi,
                paymentInfo: _paymentInfo,
                userId: _userId,
                groupId: _groupId,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isHighlighted
                      ? AppColors.primary
                      : AppColors.containerBlack,
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 15.0,
                    right: 20.0,
                    bottom: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _mpi.status.bgColor,
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                            width: 2,
                            color: _mpi.status.bgColor ?? AppColors.creamWhite,
                          ),
                        ),
                        child: Icon(
                          _mpi.status.icon,
                          color: AppColors.creamWhite,
                          size: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(
                          _mpi.monthName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.oxygen(
                            color: AppColors.creamWhite,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.creamWhite,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
