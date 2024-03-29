import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/ui/groups/group_quick_actions_dialog.dart';
import 'package:payflix/screens/payments/bloc/payments_cubit.dart';
import 'package:payflix/screens/payments/ui/payments.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final PayflixUser user;
  final bool isAdmin;

  const GroupCard({
    Key? key,
    required this.group,
    required this.user,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          24.0,
        ),
        onTap: () => isAdmin
            ? Navigator.pushNamed(
                context,
                AppRoutes.members,
                arguments: [group, context.read<HomeCubit>()],
              )
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<HomeCubit>()),
                      BlocProvider.value(
                        value: getIt<PaymentsCubit>()
                          ..fetchPayments(group.getGroupId(), user.id),
                      ),
                    ],
                    child: Payments(
                      group: group,
                      user: user,
                      isAdmin: isAdmin,
                    ),
                  ),
                ),
              ),
        onLongPress: () => AppDialogController.showBottomSheetDialog(
          context: context,
          dialog: BlocProvider.value(
            value: context.read<HomeCubit>().getGQADialogCubit(),
            child: GroupQuickActionsDialog(
              group: group,
              isAdmin: isAdmin,
            ),
          ),
          isSidePadding: false,
          onClose: () async => await Future.delayed(
            const Duration(milliseconds: 100),
            () => context.read<HomeCubit>().getGQADialogCubit().restartView(),
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
                  color: AppColors.containerBlack,
                  borderRadius: BorderRadius.circular(
                    24.0,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: 15.0,
                        top: 15.0,
                        right: 15.0,
                        bottom: group.groupType == GroupType.disneyPlus
                            ? 30.0
                            : 15.0,
                      ),
                      child: AppCachedNetworkImage(
                        url: group.groupType.logo,
                        placeholder: AppPlaceholder.vod,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.memberTextOverlayGradient,
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 25.0,
                            right: 15.0,
                            bottom: 15.0,
                          ),
                          child: Text(
                            group.groupType.vodName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oxygen(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.creamWhite,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isAdmin) ...[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 9.0,
                              top: 4.0,
                              right: 9.0,
                              bottom: 4.0,
                            ),
                            child: Text('Admin'),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
