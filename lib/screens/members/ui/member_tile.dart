import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class MemberTile extends StatelessWidget {
  final String memberName;
  final String memberProfilePicture;

  const MemberTile(
      {Key? key, required this.memberName, required this.memberProfilePicture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => {},
            borderRadius: BorderRadius.circular(21.0),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21.0),
                color: AppColors.lightGray,
                image: DecorationImage(
                  image: AssetImage(memberProfilePicture),
                  alignment: FractionalOffset.fromOffsetAndSize(
                    const Offset(0.0, -10.0),
                    const Size(
                      48.0,
                      48.0,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          memberName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
