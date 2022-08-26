import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SliverMultiBoxDemo(),
    ),
  ));
}

class SliverMultiBoxDemo extends StatelessWidget {
  final List<_Event> events = _events();

  SliverMultiBoxDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        for (var e in events) _SliverEventTile(child: _EventTile(model: e))
      ],
    );
  }
}

class _SliverEventTile extends SingleChildRenderObjectWidget {
  final _EventTile child;

  _SliverEventTile({required this.child}) : super(child: child);

  @override
  _RenderSliverEventTile createRenderObject(BuildContext context) =>
      _RenderSliverEventTile(child.m.title);
}

class _RenderSliverEventTile extends RenderSliverSingleBoxAdapter {
  final String title;

  _RenderSliverEventTile(
    this.title, {
    RenderBox? child,
  }) : super(child: child);

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final constraints = this.constraints;

    const min = 150.0;
    const max = 350.0;
    double childExtent;

    final delta = constraints.remainingPaintExtent -
        (constraints.viewportMainAxisExtent - max / 2);

    if (delta > 0) {
      childExtent = min + delta;
    } else {
      childExtent = min;
    }

    child!.layout(constraints.asBoxConstraints(
      minExtent: childExtent,
      maxExtent: childExtent,
    ));

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}

class _EventTile extends StatefulWidget {
  final _Event m;

  const _EventTile({Key? key, required _Event model})
      : m = model,
        super(key: key);

  @override
  __EventTileState createState() => __EventTileState();
}

class __EventTileState extends State<_EventTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.m.colorTheme,
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(widget.m.title,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text('${widget.m.time} * ${widget.m.location}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 2),
          Text(widget.m.speaker,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _Event {
  final Color colorTheme;
  final String title;
  final DateTime time;
  final String location;
  final String speaker;

  _Event({
    required this.colorTheme,
    required this.title,
    required this.time,
    required this.location,
    required this.speaker,
  });
}

Color _randomColor() {
  final r = math.Random();
  return Color.fromRGBO(
    r.nextInt(256),
    r.nextInt(256),
    r.nextInt(256),
    1,
  );
}

List<_Event> _events() {
  return [
    _Event(
        colorTheme: _randomColor(),
        title: 'Finishing',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Craftsmanship',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Opportunity',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Starting Over',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Identity I',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Identify II',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Overview',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Getting Started',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
    _Event(
        colorTheme: _randomColor(),
        title: 'Novice',
        time: DateTime(2020, 1, 6, 16, 45),
        location: 'The Grid',
        speaker: 'Kim Pedersen'),
  ];
}
