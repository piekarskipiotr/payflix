import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class FullScreenDialog extends StatelessWidget {
  final String headerText;
  final String? secondaryText;
  final IconData statusIcon;
  final Color statusIconColor;
  final Color statusIconBackgroundColor;
  final IconData buttonIcon;
  final VoidCallback buttonOnClick;
  final String buttonText;

  const FullScreenDialog({
    Key? key,
    required this.headerText,
    this.secondaryText,
    required this.statusIcon,
    required this.statusIconColor,
    required this.statusIconBackgroundColor,
    required this.buttonIcon,
    required this.buttonOnClick,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Column(
                children: [
                  Text(
                    headerText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  ClipOval(
                    child: Material(
                      color: statusIconBackgroundColor,
                      child: SizedBox(
                        width: 84.0,
                        height: 84.0,
                        child: Icon(
                          statusIcon,
                          color: statusIconColor,
                          size: 64.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  if (secondaryText != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Text(
                        secondaryText!,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Container(),
              Container(),
              Column(
                children: [
                  Material(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12.0),
                    child: InkWell(
                      onTap: buttonOnClick,
                      borderRadius: BorderRadius.circular(12.0),
                      child: SizedBox(
                        width: 48.0,
                        height: 48.0,
                        child: Center(
                          child: Icon(
                            buttonIcon,
                            color: Colors.black,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    buttonText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
