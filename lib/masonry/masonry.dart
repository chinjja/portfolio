import 'package:flutter/widgets.dart';
import 'package:portfolio/masonry/rendering/masonry.dart';

class Masonry extends MultiChildRenderObjectWidget {
  Masonry({
    Key? key,
    required List<Widget> children,
    required this.horizontalExtent,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    this.horizontalAlignment = MainAxisAlignment.spaceAround,
  })  : assert(children.isNotEmpty),
        assert(horizontalExtent >= 0.0),
        assert(horizontalSpacing >= 0.0),
        assert(verticalSpacing >= 0.0),
        super(key: key, children: children);

  final double horizontalExtent;
  final double horizontalSpacing;
  final double verticalSpacing;
  final MainAxisAlignment horizontalAlignment;

  @override
  RenderMasonry createRenderObject(BuildContext context) {
    return RenderMasonry(
      horizontalExtent: horizontalExtent,
      horizontalSpacing: horizontalSpacing,
      horizontalAlignment: horizontalAlignment,
      verticalSpacing: verticalSpacing,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMasonry renderObject) {
    renderObject
      ..horizontalExtent = horizontalExtent
      ..horizontalSpacing = horizontalSpacing
      ..horizontalAlignment = horizontalAlignment
      ..verticalSpacing = verticalSpacing;
  }
}
