import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        AppBarWithFixedTitle(
          title: getString(context).profile,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.qr_code,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
