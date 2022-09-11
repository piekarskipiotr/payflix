import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_cubit.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/ui/app_bar_with_moved_title.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'dart:math' as math;

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  late ScrollController _scrollController;
  bool _showGradient = false;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= 155.0) {
          if (!_showGradient) {
            setState(() {
              _showGradient = true;
            });
          }
        } else {
          if (_showGradient) {
            setState(() {
              _showGradient = false;
            });
          }
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as PayflixUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Positioned(
              right: -80.0,
              child: SingleChildScrollView(
                child: Transform.rotate(
                  angle: 10.0 * math.pi / 180.0,
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(
                      top: 100.0,
                    ),
                    child: Image.asset(
                      cash,
                      scale: 0.85,
                    ),
                  ),
                ),
              ),
            ),
            NestedScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: BlocProvider.value(
                      value: getIt<AppBarCubit>(),
                      child: AppBarWithMovedTitle(
                        title: getString(context).payments,
                        actions: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 38.0,
                            icon: Material(
                              elevation: 0,
                              clipBehavior: Clip.hardEdge,
                              color: AppColors.containerBlack,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  16.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: AppCachedNetworkImage(
                                    url: user.avatar.url,
                                    placeholder: AppPlaceholder.avatar,
                                    size: 38.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    child: Container(
                      margin: const EdgeInsets.only(top: 24.0),
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _showGradient ? 1.0 : 0.0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 172.0,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.appBarGradientExperimental,
                                ),
                              ),
                            ),
                          ),
                          BlurContainer(
                            body: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                children: [
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '10 ${getString(context).days}',
                                    style: GoogleFonts.oxygen(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    getString(context).till_next_payment,
                                    style: GoogleFonts.oxygen(
                                      fontSize: 12.0,
                                      color: AppColors.creamWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    maxHeight: 172.0,
                    minHeight: 172.0,
                  ),
                  pinned: true,
                ),
              ],
              body: Container(
                margin: const EdgeInsets.only(top: 24.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => BlurContainer(
                    body: Container(
                      height: 48.0,
                    ),
                  ),
                  itemCount: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: Container(
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
