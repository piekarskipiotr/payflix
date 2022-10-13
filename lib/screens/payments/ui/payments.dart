import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/payments/bloc/payments_cubit.dart';
import 'package:payflix/screens/payments/bloc/payments_state.dart';
import 'package:payflix/screens/payments/ui/month_item.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_cubit.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/ui/app_bar_with_moved_title.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'dart:math' as math;

class Payments extends StatefulWidget {
  final PayflixUser user;
  final Group group;
  final bool isAdmin;

  const Payments({
    Key? key,
    required this.user,
    required this.group,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  late PayflixUser _user;
  late Group _group;
  late ScrollController _scrollController;
  late bool _isAdmin;

  bool _showGradient = false;

  @override
  void initState() {
    _user = widget.user;
    _group = widget.group;
    _isAdmin = widget.isAdmin;

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
            BlocBuilder<PaymentsCubit, PaymentsState>(
              builder: (context, state) {
                final payments = context.read<PaymentsCubit>().getPayments();
                final days = context
                    .read<PaymentsCubit>()
                    .getDaysUntilNextPayment(_group.paymentInfo);

                return NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverSafeArea(
                        top: false,
                        sliver: BlocProvider.value(
                          value: getIt<AppBarCubit>(),
                          child: AppBarWithMovedTitle(
                            title: getString(context).payments,
                            actions: [
                              if (_isAdmin) ...[
                                Center(
                                  child: Text(
                                    _user.displayName,
                                    style: GoogleFonts.oxygen(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4.0,),
                              ],

                              IconButton(
                                onPressed: null,
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
                                        url: _isAdmin
                                            ? _user.avatar.url
                                            : _group.groupType.logo,
                                        placeholder: _isAdmin
                                            ? AppPlaceholder.avatar
                                            : AppPlaceholder.vod,
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
                          color: _showGradient
                              ? Theme.of(context).scaffoldBackgroundColor
                              : null,
                        ),
                        maxHeight: 28.0,
                        minHeight: 28.0,
                      ),
                      pinned: true,
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        child: Stack(
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _showGradient ? 1.0 : 0.0,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 204.0,
                                  decoration: BoxDecoration(
                                    gradient:
                                        AppTheme.appBarGradientExperimental,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: BlurContainer(
                                body: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5.0),
                                      Text(
                                        _handleDaysUntilPaymentText(days),
                                        style: GoogleFonts.oxygen(
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        days > 0
                                            ? getString(context)
                                                .till_next_payment
                                            : getString(context).it_s_today_sub,
                                        style: GoogleFonts.oxygen(
                                          fontSize: 14.0,
                                          color: AppColors.creamWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        maxHeight: 192.0,
                        minHeight: 192.0,
                      ),
                      pinned: true,
                    ),
                  ],
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (state is FetchingPayments) ...[
                        const CircularProgressIndicator(),
                      ] else ...[
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 92.0),
                          itemBuilder: (context, index) => BlocProvider.value(
                            value: context.read<PaymentsCubit>(),
                            child: MonthItem(
                              mpi: payments[index],
                              paymentInfo: _group.paymentInfo,
                              userId: _user.id,
                              groupId: _group.getGroupId(),
                              isEditable: _isAdmin
                                  ? context
                                      .watch<PaymentsCubit>()
                                      .isItemEditable(
                                        payments[index],
                                      )
                                  : false,
                              isHighlighted: context
                                  .watch<PaymentsCubit>()
                                  .shouldBeHighlighted(
                                    payments[index],
                                  ),
                            ),
                          ),
                          itemCount: payments.length,
                        ),
                      ],
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                            gradient: AppTheme.paymentsBottomOverlayGradient(
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _handleDaysUntilPaymentText(int days) {
    if (days == 0) {
      return getString(context).it_s_today;
    }

    return '$days ${days > 1 ? getString(context).days : getString(context).day}';
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
