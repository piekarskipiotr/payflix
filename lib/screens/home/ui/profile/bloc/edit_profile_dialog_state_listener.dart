import 'package:flutter/widgets.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/error_code_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class EditProfileDialogStateListener {
  static listenToState(BuildContext context, EditProfileDialogState state) {
    if (state is SavingUserProfileChangesFailed) {
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          ErrorCodeHelper.tryConvertErrorCodeToMessage(
            context,
            state.error,
          ),
        ),
      );
    } else if (state is SavingUserProfileChangesSucceeded) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).user_profile_updated_successfully,
          animation: lottieSuccess2,
          onClick: () => Navigator.popUntil(
            context,
            ModalRoute.withName(
              AppRoutes.home,
            ),
          ),
        ),
      );
    } else if (state is UserDataSameAsPrevious) {
      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
    }
  }
}
