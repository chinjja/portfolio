import 'package:flutter/rendering.dart';

class MasonryParentData extends ContainerBoxParentData<RenderBox> {}

class _MasonryData {
  double height = 0.0;
  int count = 0;

  void addHeight(double height) {
    this.height += height;
    count += 1;
  }

  void reset() {
    height = 0.0;
    count = 0;
  }

  bool isOverflow(double height, double threshold) {
    return count > 0 && this.height + height > threshold;
  }
}

class RenderMasonry extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MasonryParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MasonryParentData> {
  RenderMasonry({
    required double horizontalExtent,
    required double horizontalSpacing,
    required double verticalSpacing,
    required MainAxisAlignment horizontalAlignment,
  })  : _horizontalExtent = horizontalExtent,
        _horizontalSpacing = horizontalSpacing,
        _horizontalAlignment = horizontalAlignment,
        _verticalSpacing = verticalSpacing;
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! MasonryParentData) {
      child.parentData = MasonryParentData();
    }
  }

  double _horizontalExtent;
  double get horizontalExtent => _horizontalExtent;
  set horizontalExtent(double value) {
    if (_horizontalExtent != value) {
      _horizontalExtent = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  double _horizontalSpacing;
  double get horizontalSpacing => _horizontalSpacing;
  set horizontalSpacing(double value) {
    if (_horizontalSpacing != value) {
      _horizontalSpacing = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  double _verticalSpacing;
  double get verticalSpacing => _verticalSpacing;
  set verticalSpacing(double value) {
    if (_verticalSpacing != value) {
      _verticalSpacing = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  MainAxisAlignment _horizontalAlignment;
  MainAxisAlignment get horizontalAlignment => _horizontalAlignment;
  set horizontalAlignment(MainAxisAlignment value) {
    if (_horizontalAlignment != value) {
      _horizontalAlignment = value;
      markNeedsLayout();
      markNeedsSemanticsUpdate();
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  double computeMinIntrinsicHeight(double width) {
    return computeDryLayout(BoxConstraints.tightFor(width: width)).height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeDryLayout(BoxConstraints.tightFor(width: width)).height;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final cols =
        (constraints.maxWidth ~/ (horizontalExtent + horizontalSpacing))
            .clamp(1, 3);

    final childHeights = <double>[];
    var totalHeight = 0.0;
    var child = firstChild;
    while (child != null) {
      final childHeight = child.getDryLayout(constraints).height;
      childHeights.add(childHeight);
      totalHeight += childHeight;
      child = childAfter(child);
    }
    var i = 0;
    final list = [_MasonryData()];
    final heightThreshold = totalHeight / cols * 1.2;
    for (double childHeight in childHeights) {
      if (i < cols - 1 && list[i].isOverflow(childHeight, heightThreshold)) {
        i++;
        list.add(_MasonryData());
      }
      list[i].addHeight(childHeight);
    }

    final maxData = list.reduce((a, b) => a.height > b.height ? a : b);
    return constraints.constrain(
      Size(
        constraints.maxWidth + horizontalSpacing * (cols - 1),
        maxData.height + verticalSpacing * (maxData.count - 1),
      ),
    );
  }

  @override
  void performLayout() {
    final cols =
        (constraints.maxWidth ~/ (horizontalExtent + horizontalSpacing))
            .clamp(1, 3);

    double childWidth;
    double horizontalOffset;
    switch (horizontalAlignment) {
      case MainAxisAlignment.spaceAround:
        horizontalOffset = horizontalSpacing / 2;
        final w = constraints.maxWidth - horizontalSpacing * cols;
        childWidth = w / cols;
        break;
      case MainAxisAlignment.spaceBetween:
        horizontalOffset = 0;
        final w = constraints.maxWidth - horizontalSpacing * (cols - 1);
        childWidth = w / cols;
        break;
      case MainAxisAlignment.spaceEvenly:
        horizontalOffset = horizontalSpacing;
        final w = constraints.maxWidth - horizontalSpacing * (cols + 1);
        childWidth = w / cols;
        break;
      case MainAxisAlignment.start:
        horizontalOffset = 0;
        childWidth = horizontalExtent;
        break;
      case MainAxisAlignment.center:
        horizontalOffset = constraints.maxWidth / 2 -
            (horizontalExtent * cols + horizontalSpacing * (cols - 1)) / 2;
        childWidth = horizontalExtent;
        break;
      case MainAxisAlignment.end:
        horizontalOffset = constraints.maxWidth -
            horizontalExtent * cols -
            horizontalSpacing * (cols - 1);
        childWidth = horizontalExtent;
        break;
    }
    final childConstraints = BoxConstraints.tightFor(width: childWidth);
    var totalHeight = 0.0;
    var child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      totalHeight += child.size.height;
      child = childAfter(child);
    }

    var i = 0;
    final data = _MasonryData();
    final heightThreshold = totalHeight / cols * 1.2;

    child = firstChild;
    while (child != null) {
      final childHeight = child.size.height;
      if (i < cols - 1 && data.isOverflow(childHeight, heightThreshold)) {
        i++;
        data.reset();
      }
      final parentData = child.parentData as MasonryParentData;
      parentData.offset = Offset(
        horizontalOffset + (child.size.width + horizontalSpacing) * i,
        data.height + verticalSpacing * data.count,
      );
      data.addHeight(childHeight);
      child = parentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
