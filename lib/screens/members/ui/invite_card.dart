import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_cubit.dart';
import 'package:payflix/screens/members/ui/invite_dialog.dart';

class InviteCard extends StatelessWidget {
  const InviteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          24.0,
        ),
        onTap: () => AppDialogController.showBottomSheetDialog(
          context,
          BlocProvider(
            create: (_) => InviteDialogCubit(),
            child: const InviteDialog(),
          ),
        ),
        child: SizedBox(
          height: 162.0,
          width: 162.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              24.0,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(
                    24.0,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(
                    20.0,
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: AppColors.creamWhite,
                    size: 64.0,
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
