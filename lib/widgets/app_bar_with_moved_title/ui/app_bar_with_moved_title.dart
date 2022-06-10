import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_cubit.dart';

/*
 Remember to put this widget into BlocProvider
 and pass AppBarCubit as value, create new one
 or use getIt library
 */

class AppBarWithMovedTitle extends StatelessWidget {
  final String title;
  final String? secondaryText;
  final List<Widget>? actions;

  const AppBarWithMovedTitle({
    Key? key,
    required this.title,
    required this.actions,
    this.secondaryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0.0,
      expandedHeight: 200.0,
      backgroundColor: Colors.transparent,
      actions: actions,
      centerTitle: false,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: context.watch<AppBarCubit>().showRegularTitle() ? 1.0 : 0.0,
        child: Text(
          secondaryText ?? title,
          maxLines: 1,
          style: GoogleFonts.oxygen(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AppColors.creamWhite,
          ),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          var top = constraints.biggest.height;
          context.read<AppBarCubit>().handleTitle(top);

          return Container(
            decoration: BoxDecoration(
              gradient:
                  top <= 56.0 ? AppTheme.appBarGradientExperimental : null,
            ),
            child: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                bottom: 13.0,
              ),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: top > regularTitleTopValue + 10.0 ? 1.0 : 0.0,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.oxygen(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.creamWhite,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
