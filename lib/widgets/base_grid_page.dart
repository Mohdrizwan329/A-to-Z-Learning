import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../utils/grid_animations_mixin.dart';
import 'gradient_scaffold.dart';
import '../view/ads/Google_Ads_Page.dart';

/// Base widget for grid-based learning pages
/// Provides consistent layout with AppBar, gradient background, animated grid, and ads
///
/// Example usage:
/// ```dart
/// BaseGridPage<MyController>(
///   title: 'Alphabets',
///   emoji: '🔤',
///   controller: Get.find<MyController>(),
///   itemCount: 26,
///   itemBuilder: (context, index, isSelected, gradient, pulseAnimation) {
///     return GradientCard(
///       gradient: gradient,
///       isSelected: isSelected,
///       pulseAnimation: pulseAnimation,
///       child: GradientCardText(text: 'A'),
///     );
///   },
///   onItemTap: (index) => controller.handleTap(index),
///   selectedIndices: controller.selectedIndex,
/// )
/// ```
class BaseGridPage<T extends GetxController> extends StatefulWidget {
  final String title;
  final String? emoji;
  final String? subtitle;
  final T controller;
  final int itemCount;
  final Widget Function(
    BuildContext context,
    int index,
    bool isSelected,
    List<Color> gradient,
    Animation<double> pulseAnimation,
  )
  itemBuilder;
  final void Function(int index)? onItemTap;
  final RxSet<int> selectedIndices;
  final VoidCallback? onRefresh;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsets gridPadding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<Color>? appBarGradient;
  final List<Color>? bodyGradient;
  final bool showAds;
  final List<Widget>? actions;

  const BaseGridPage({
    super.key,
    required this.title,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
    required this.selectedIndices,
    this.emoji,
    this.subtitle,
    this.onItemTap,
    this.onRefresh,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.0,
    this.gridPadding = const EdgeInsets.all(16),
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.appBarGradient,
    this.bodyGradient,
    this.showAds = true,
    this.actions,
  });

  @override
  State<BaseGridPage<T>> createState() => _BaseGridPageState<T>();
}

class _BaseGridPageState<T extends GetxController>
    extends State<BaseGridPage<T>>
    with TickerProviderStateMixin, GridAnimationsMixin {
  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultActions = <Widget>[
      if (widget.onRefresh != null)
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 20),
          ),
          onPressed: widget.onRefresh,
          tooltip: 'Reset Progress',
        ),
    ];

    return GradientScaffold(
      title: widget.title,
      emoji: widget.emoji,
      subtitle: widget.subtitle,
      appBarGradient: widget.appBarGradient,
      bodyGradient: widget.bodyGradient,
      actions: widget.actions ?? defaultActions,
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => GridView.builder(
                padding: widget.gridPadding,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.crossAxisCount,
                  childAspectRatio: widget.childAspectRatio,
                  mainAxisSpacing: widget.mainAxisSpacing,
                  crossAxisSpacing: widget.crossAxisSpacing,
                ),
                itemCount: widget.itemCount,
                itemBuilder: (context, index) {
                  final isSelected = widget.selectedIndices.contains(index);
                  final gradient = AppColors.getGradientForIndex(index);

                  return buildAnimatedGridItem(
                    index: index,
                    isSelected: isSelected,
                    child: widget.itemBuilder(
                      context,
                      index,
                      isSelected,
                      gradient,
                      pulseAnimation,
                    ),
                  );
                },
              ),
            ),
          ),
          if (widget.showAds) const AdsScreen(),
        ],
      ),
    );
  }
}

/// Simple version without controller dependency
class SimpleGridPage extends StatefulWidget {
  final String title;
  final String? emoji;
  final String? subtitle;
  final int itemCount;
  final Widget Function(
    BuildContext context,
    int index,
    List<Color> gradient,
    Animation<double> pulseAnimation,
  )
  itemBuilder;
  final void Function(int index)? onItemTap;
  final VoidCallback? onRefresh;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool showAds;

  const SimpleGridPage({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.emoji,
    this.subtitle,
    this.onItemTap,
    this.onRefresh,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.0,
    this.showAds = true,
  });

  @override
  State<SimpleGridPage> createState() => _SimpleGridPageState();
}

class _SimpleGridPageState extends State<SimpleGridPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  @override
  void initState() {
    super.initState();
    initGridAnimations(this);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: widget.title,
      emoji: widget.emoji,
      subtitle: widget.subtitle,
      actions: widget.onRefresh != null
          ? [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                ),
                onPressed: widget.onRefresh,
              ),
            ]
          : null,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: widget.itemCount,
              itemBuilder: (context, index) {
                final gradient = AppColors.getGradientForIndex(index);

                return buildFloatingItem(
                  index: index,
                  child: GestureDetector(
                    onTap: widget.onItemTap != null
                        ? () => widget.onItemTap!(index)
                        : null,
                    child: widget.itemBuilder(
                      context,
                      index,
                      gradient,
                      pulseAnimation,
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.showAds) const AdsScreen(),
        ],
      ),
    );
  }
}
