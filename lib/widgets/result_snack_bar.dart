import 'package:flutter/material.dart';

SnackBar resultSnackBar(BuildContext context, IconData icon, Color iconColor,
    String text, Color backgroundColor) {
  return SnackBar(
    content: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipOval(
          child: Material(
            color: Colors.white,
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Icon(
                icon,
                color: iconColor,
                size: 20.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Text(text),
      ],
    ),
    backgroundColor: backgroundColor,
  );
}
