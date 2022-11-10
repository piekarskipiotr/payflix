import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  final String permission;
  final String asset;

  const PermissionDialog({
    Key? key,
    required this.permission,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: SizedBox(
                height: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 92.0,
                  ),
                  Image.asset(
                    asset,
                    width: 256.0,
                    height: 256.0,
                  ),
                  const SizedBox(
                    height: 74.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text(
                      getString(context).push_notification_permission_title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oxygen(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.creamWhite,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                    ),
                    child: Text(
                      getString(context).push_notification_permission_subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oxygen(
                        color: AppColors.creamWhite,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                  child: PrimaryButton(
                    text: getString(context).open_settings,
                    onClick: () async {
                      await openAppSettings();
                      Navigator.pop(context);
                    },
                    isLoading: false,
                  ),
                ),
                const SizedBox(height: 12.0,),
                ListTile(
                  onTap: () => Navigator.pop(context),
                  title: Text(
                    getString(context).close_dialog,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oxygen(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColors.creamWhite,
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
