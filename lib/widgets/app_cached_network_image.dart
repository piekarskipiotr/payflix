import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String url;
  final AppPlaceholder placeholder;
  final Color? color;
  final BlendMode? blendMode;
  final double? size;

  const AppCachedNetworkImage({
    Key? key,
    required this.url,
    required this.placeholder,
    this.color,
    this.blendMode,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      color: color,
      colorBlendMode: blendMode,
      fadeInCurve: Curves.easeInSine,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutCurve: Curves.easeOutSine,
      fadeOutDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.containerBlack,
        highlightColor: AppColors.lighterGray,
        child: Image.asset(placeholder.image),
      ),
    );
  }
}
