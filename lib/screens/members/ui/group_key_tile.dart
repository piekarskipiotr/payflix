import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'group_key_dialog.dart';

class GroupKeyTile extends StatelessWidget {
  const GroupKeyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    32.0,
                  ),
                  topLeft: Radius.circular(
                    32.0,
                  ),
                ),
              ),
              isScrollControlled: true,
              builder: (builder) => const GroupKeyDialog(),
            ),
            borderRadius: BorderRadius.circular(21.0),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21.0),
                color: AppColors.primary,
              ),
              child: const FittedBox(
                fit: BoxFit.fill,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.vpn_key,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0,),
        Text(
          getString(context).group_key,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
