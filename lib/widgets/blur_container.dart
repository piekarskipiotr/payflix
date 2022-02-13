import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class BlurContainer extends StatelessWidget {
  final Widget body;

  const BlurContainer({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
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
            child: Padding(
              padding: const EdgeInsets.all(
                20.0,
              ),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
