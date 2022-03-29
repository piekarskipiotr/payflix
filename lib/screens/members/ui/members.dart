import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/members/ui/invite_card.dart';
import 'package:payflix/screens/members/ui/member_card.dart';

class Members extends StatelessWidget {
  const Members({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Positioned(
              right: -20.0,
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(
                    top: 40.0,
                  ),
                  child: Image.asset(
                    friends,
                    scale: 2.4,
                  ),
                ),
              ),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0.0,
                  expandedHeight: 200.0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.groupSettings,
                        arguments: false,
                      ),
                      icon: const Icon(
                        Icons.settings,
                      ),
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 13.0,
                    ),
                    title: Text(
                      getString(context).members,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oxygen(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.creamWhite,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 25.0,
                    right: 25.0,
                    left: 25.0,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25.0,
                      crossAxisSpacing: 25.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return index == 0
                            ? const InviteCard()
                            : const MemberCard();
                      },
                      childCount: 5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}