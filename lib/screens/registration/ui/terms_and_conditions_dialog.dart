import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 39.0,
                ),
                Container(
                  height: 5.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: Icon(
                        Icons.close,
                        size: 20.0,
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              top: 8.0,
              right: 15.0,
              bottom: 15.0,
            ),
            child: Text(
              getString(context).terms_and_conditions,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // content
          const SizedBox(
            height: 300,
            child: Center(child: Text('content')),
          )
        ],
      ),
    );
  }
}
