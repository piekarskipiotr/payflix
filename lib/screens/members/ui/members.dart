import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/opacity_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/members/ui/group_key_tile.dart';
import 'package:payflix/screens/members/ui/member_tile.dart';

class Members extends StatelessWidget {
  const Members({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              elevation: 0.0,
              pinned: true,
              expandedHeight: 150.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.groupSettings),
                    icon: const Icon(
                      Icons.settings,
                      size: 22.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  var top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50.0,
                      bottom: 13.0,
                    ),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity:
                          OpacityHelper.calculateHeaderOpacity(top, 81.0, 91.0),
                      child: top < 86
                          ? Text(
                              getString(context).members,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              getString(context).members,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                top: 60.0,
                bottom: 15.0,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25.0,
                  crossAxisSpacing: 5.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return index == 0
                        ? const GroupKeyTile()
                        : const MemberTile(
                            memberName: 'member name',
                            memberProfilePicture: defaultMan,
                          );
                  },
                  childCount: 4,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
