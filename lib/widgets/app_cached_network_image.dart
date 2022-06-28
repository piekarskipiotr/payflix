import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String url;

  const AppCachedNetworkImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.containerBlack,
        highlightColor: AppColors.lighterGray,
        child: Image.asset(defAvatar),
      ),
    );
  }
}
