import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/members/bloc/remove_member_cubit.dart';
import 'package:payflix/screens/members/bloc/remove_member_state.dart';
import 'package:payflix/screens/members/bloc/remove_member_listener.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';

class RemoveMemberDialog extends StatelessWidget {
  final PayflixUser user;
  final Group group;
  final HomeCubit homeCubit;

  const RemoveMemberDialog({
    Key? key,
    required this.user,
    required this.group,
    required this.homeCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoveMemberCubit, RemoveMemberState>(
      listener: (context, state) => RemoveMemberListener.listenToState(
        context,
        state,
        homeCubit,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            bottom: 10.0,
          ),
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
                height: 12.0,
              ),
              SizedBox(
                width: 168.0,
                height: 168.0,
                child: Lottie.asset(
                  lottieFailure,
                  repeat: false,
                ),
              ),
              const SizedBox(
                height: 7.0,
              ),
              Text(
                getString(context).remove_user_header(user.displayName),
                style: GoogleFonts.oxygen(
                  color: AppColors.creamWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
              const SizedBox(
                height: 7.0,
              ),
              Text(
                getString(context).remove_user_body,
                style: GoogleFonts.oxygen(
                  color: AppColors.creamWhite,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(
                height: 64.0,
              ),
              BlocBuilder<RemoveMemberCubit, RemoveMemberState>(
                builder: (context, state) => PrimaryButton(
                  text: getString(context).remove,
                  onClick: () =>
                      context.read<RemoveMemberCubit>().removeUser(user, group),
                  isLoading: state is RemovingMember,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              SecondaryButton(
                text: getString(context).back,
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
