import 'package:flutter/material.dart';

class CustomGridViewBuilder<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;

  const CustomGridViewBuilder({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio,
    this.mainAxisExtent,
    this.padding = const EdgeInsets.all(8.0),
    this.isScrollable = false,
  }) : assert(
         childAspectRatio != null || mainAxisExtent != null,
         'Either childAspectRatio or mainAxisExtent must be provided',
       ),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final delegate = mainAxisExtent != null
        ? SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            mainAxisExtent: mainAxisExtent!,
          )
        : SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio ?? 1.0,
          );

    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: delegate,
      itemBuilder: (context, index) {
        final item = items[index];
        return itemBuilder(context, index, item);
      },
    );
  }
}
