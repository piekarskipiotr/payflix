import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class WhereToGetGroupKeyDialog extends StatelessWidget {
  const WhereToGetGroupKeyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        top: true,
        bottom: true,
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
                    ),
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
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: getString(context).where_key,
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: const <TextSpan>[
                    TextSpan(
                      text: '?',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 45.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 92.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 92.0,
                          height: 92.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21.0),
                            color: AppColors.lightGray,
                            image: DecorationImage(
                              image: const AssetImage(defaultMan),
                              alignment: FractionalOffset.fromOffsetAndSize(
                                  const Offset(0.0, -15.0),
                                  const Size(92.0, 92.0)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              getString(context).first_step_where_key,
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 16.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 92.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 92.0,
                          height: 92.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21.0),
                            color: AppColors.primary,
                          ),
                          child: const Icon(Icons.vpn_key, color: Colors.white, size: 56.0,),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              getString(context).second_step_where_key,
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 16.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 92.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 92.0,
                          height: 92.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21.0),
                            color: AppColors.lightGray,
                            image: DecorationImage(
                              image: const AssetImage(jumpingWoman),
                              alignment: FractionalOffset.fromOffsetAndSize(
                                const Offset(15.0, -25.0),
                                const Size(92.0, 92.0),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Text(
                              getString(context).third_step_where_key,
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 16.0,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  getString(context).understand,
                  style: const TextStyle(fontSize: 16.0, color: AppColors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
