import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/validators/edit_profile_validation.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_cubit.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_state.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_state_listener.dart';
import 'package:payflix/screens/picking_avatar_dialog/ui/picking_avatar_dialog.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
import 'package:payflix/widgets/primary_button.dart';

class EditProfileDialog extends StatelessWidget {
  final PayflixUser user;
  final GlobalKey<FormState> formKey;

  const EditProfileDialog({Key? key, required this.user, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileDialogCubit, EditProfileDialogState>(
      listener: (context, state) =>
          EditProfileDialogStateListener.listenToState(context, state),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            getString(context).edit_profile,
            style: GoogleFonts.oxygen(
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          bottom: true,
          child: Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BlocBuilder<EditProfileDialogCubit,
                          EditProfileDialogState>(
                        builder: (context, state) {
                          var avatar = context
                              .read<EditProfileDialogCubit>()
                              .getAvatar();

                          return Center(
                            child: SizedBox(
                              width: 86.0,
                              height: 86.0,
                              child: Material(
                                elevation: 0,
                                clipBehavior: Clip.antiAlias,
                                type: MaterialType.circle,
                                color: AppColors.creamWhite,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    elevation: 0,
                                    clipBehavior: Clip.antiAlias,
                                    type: MaterialType.circle,
                                    color: avatar.background,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 8.0,
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: AppCachedNetworkImage(
                                                  url: avatar.url,
                                                  placeholder: AppPlaceholder.avatar,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 28.0,
                                                  color: AppColors.creamWhite,
                                                ),
                                              ),
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                AppDialogController
                                                    .showBottomSheetDialog(
                                                  context: context,
                                                  dialog: BlocProvider.value(
                                                    value: context
                                                        .read<
                                                            EditProfileDialogCubit>()
                                                        .getDialogCubit(),
                                                    child: PickingAvatarDialog(
                                                      initialAvatar:
                                                          user.avatar,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22.0),
                      TextFormField(
                        initialValue: user.displayName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            EditProfileValidation.validateDisplayName(
                                context, value),
                        onSaved: (value) => context
                            .read<EditProfileDialogCubit>()
                            .setUserDisplayName(value!),
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        style: GoogleFonts.oxygen(),
                        decoration: InputDecoration(
                          hintText: getString(context).profile_name,
                        ),
                      ),
                      const SizedBox(
                        height: 27.0,
                      ),
                      BlocBuilder<EditProfileDialogCubit,
                          EditProfileDialogState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            text: getString(context).save,
                            onClick: state is SavingUserProfileChanges
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      context
                                          .read<EditProfileDialogCubit>()
                                          .saveUserProfileChanges();
                                    }
                                  },
                            isLoading: state is SavingUserProfileChanges,
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: getString(context).edit_profile_email_id_info_1,
                          style: GoogleFonts.oxygen(
                            fontSize: 13.0,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: user.email,
                              style: GoogleFonts.oxygen(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: getString(context)
                                  .edit_profile_email_id_info_2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
