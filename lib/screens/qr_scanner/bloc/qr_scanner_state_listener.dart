import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/joining_group_dialog/ui/joining_group_dialog.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_cubit.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerStateListener {
  static bool _isSnackBarShowing = false;

  static Future listenTo(
    BuildContext context,
    QrScannerState state,
    StreamSubscription<Barcode>? stream,
    QRViewController? qrController,
    QrScannerCubit cubit,
  ) async {
    if (state is CheckingTheFoundData) {
      stream?.pause();
    } else if (state is JoiningGroupCanceled) {
      // TODO: pop to scanner (fix stream repeating showing dialog)
      Navigator.popUntil(
        context,
        ModalRoute.withName(
          AppRoutes.home,
        ),
      );
    } else if (state is FoundDataIsIncorrect) {
      stream?.resume();
      if (!_isSnackBarShowing) {
        _isSnackBarShowing = true;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(
              errorSnackBar(
                context,
                getString(context).invalid_qr_code,
              ),
            )
            .closed
            .then((_) => _isSnackBarShowing = false);
      }
    } else if (state is UserIsAlreadyInThisGroup) {
      stream?.resume();
      if (!_isSnackBarShowing) {
        _isSnackBarShowing = true;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(
              errorSnackBar(
                context,
                getString(context).user_already_in_group,
              ),
            )
            .closed
            .then((_) => _isSnackBarShowing = false);
      }
    } else if (state is UserIsAlreadyInThisVodGroup) {
      stream?.resume();
      if (!_isSnackBarShowing) {
        _isSnackBarShowing = true;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(
              errorSnackBar(
                context,
                getString(context).user_already_in_vod_group_type,
              ),
            )
            .closed
            .then((_) => _isSnackBarShowing = false);
      }
    } else if (state is UserCanBeAddedToTheGroup) {
      ScaffoldMessenger.of(context).clearSnackBars();
      AppDialogController.showFullScreenDialog(
        context,
        BlocProvider.value(
          value: cubit.getJoiningGroupDialogCubit(),
          child: JoiningGroupDialog(
            adminEmailId: state.email,
            uid: state.uid,
            groupId: state.groupId,
          ),
        ),
      );
    } else if (state is AddingUserToGroupCompleted) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).added_to_group_successfully,
          animation: lottieSuccess2,
          onClick: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
        ),
      );
    }
  }
}
