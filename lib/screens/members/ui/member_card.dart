import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class MemberCard extends StatelessWidget {
  final PayflixUser user;

  const MemberCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _avatars = [
      avatar1,
      avatar2,
      avatar3,
      avatar4,
      avatar5,
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          24.0,
        ),
        onTap: () => {},
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
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        top: 15.0,
                        right: 15.0,
                        bottom: 5.0,
                      ),
                      child: Image.asset(
                        _avatars[user.avatarID],
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
                            '${user.displayName} ${user.isCurrentUser! ? getString(context).current_user_tag : ''}',
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
