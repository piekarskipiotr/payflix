import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_cubit.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_state.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InviteDialog extends StatelessWidget {
  const InviteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
        duration: const Duration(milliseconds: 200),
        child: AnimatedCrossFade(
          crossFadeState: context.watch<InviteDialogCubit>().showSecondary()
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          firstChild: Column(
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
              Text(
                getString(context).invite_dialog_header_text,
                style: GoogleFonts.oxygen(
                  color: AppColors.creamWhite,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              BlocBuilder<InviteDialogCubit, InviteDialogState>(
                builder: (context, state) {
                  return TextFormField(
                    initialValue: 'https://payflix.com/invite?=fsadw',
                    maxLines: 1,
                    readOnly: true,
                    style: GoogleFonts.oxygen(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15.0),
                      helperText:
                          context.watch<InviteDialogCubit>().showCopiedText()
                              ? getString(context).copied
                              : '',
                      helperStyle: GoogleFonts.oxygen(
                        color: AppColors.green,
                      ),
                      suffixIcon: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashRadius: 20.0,
                          onPressed: () => context
                              .read<InviteDialogCubit>()
                              .copyInviteLink(),
                          icon: const Icon(
                            Icons.copy,
                            size: 22.0,
                            color: AppColors.creamWhite,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 80.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: getString(context).cancel,
                      isLoading: false,
                      onClick: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      text: getString(context).show_qr,
                      onClick: () =>
                          context.read<InviteDialogCubit>().changeView(),
                      isLoading: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
          secondChild: Column(
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
              Text(
                getString(context).invite_dialog_2_header_text,
                style: GoogleFonts.oxygen(
                  color: AppColors.creamWhite,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              QrImage(
                data: 'https://github.com/piekarskipiotr/',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: AppColors.creamWhite,
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: getString(context).back,
                      isLoading: false,
                      onClick: () =>
                          context.read<InviteDialogCubit>().changeView(),
                    ),
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      text: getString(context).share,
                      onClick: () {},
                      isLoading: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
