import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.black,
      primaryColorLight: Colors.white,
    ),
    home: _Demo(),
  ));
}

class _Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(
      map: Container(
          color: Colors.blueGrey,
          child: Container(decoration: FlutterLogoDecoration())),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          DrawerHeader(child: FlutterLogo()),
          ListTile(leading: Icon(Icons.mail), title: Text('Hello')),
          ListTile(leading: Icon(Icons.send), title: Text('World')),
        ]),
      ),
      input: Card(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Where to?'),
        ),
      ),
      locationRefresher: LocationRefresher(),
      promoBanner: const EarnMoreWithVisaCard(),
      sliverFeedItems: <Widget>[
        SliverToBoxAdapter(child: FeedDivider()),
        SliverToBoxAdapter(child: FeedSingleItem()),
        SliverToBoxAdapter(child: FeedDivider()),
        SliverToBoxAdapter(child: FeedMultiItem()),
        SliverToBoxAdapter(child: FeedDivider()),
        SliverToBoxAdapter(child: FeedSingleItem()),
        SliverToBoxAdapter(child: FeedDivider()),
        SliverToBoxAdapter(child: FeedMultiItem()),
        SliverToBoxAdapter(child: FeedDivider()),
      ],
    );
  }
}

/// ===================================================================
/// Home
/// ===================================================================

class Home extends StatefulWidget {
  final Widget map;

  final Widget drawer;

  /// {@macro flutter.material.drawer.dragStartBehavior}
  final DragStartBehavior drawerDragStartBehavior;

  /// The color to use for the scrim that obscures primary content while a drawer is open.
  ///
  /// By default, the color is [Colors.black54]
  final Color? drawerScrimColor;

  /// The width of the area within which a horizontal swipe will open the
  /// drawer.
  ///
  /// By default, the value used is 20.0 added to the padding edge of
  /// `MediaQuery.of(context).padding` that corresponds to [alignment].
  /// This ensures that the drag area for notched devices is not obscured. For
  /// example, if `TextDirection.of(context)` is set to [TextDirection.ltr],
  /// 20.0 will be added to `MediaQuery.of(context).padding.left`.
  final double? drawerEdgeDragWidth;

  /// Determines if the [Scaffold.drawer] can be opened with a drag
  /// gesture.
  ///
  /// By default, the drag gesture is enabled.
  final bool drawerEnableOpenDragGesture;

  final Widget input;
  final Widget locationRefresher;
  final Widget? promoBanner;
  final List<Widget> sliverFeedItems;

  const Home({
    Key? key,
    required this.map,
    required this.drawer,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    required this.input,
    required this.locationRefresher,
    this.promoBanner,
    this.sliverFeedItems = const [],
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: widget.map),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _drawerKey.currentState?.open();
                  },
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              widget.input,
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return _FeedController(
              availableHeight: constraints.maxHeight,
              promoBanner: widget.promoBanner,
              sliverFeedItems: widget.sliverFeedItems,
            );
          },
        ),
        DrawerController(
          key: _drawerKey,
          alignment: DrawerAlignment.start,
          child: widget.drawer,
          dragStartBehavior: widget.drawerDragStartBehavior,
          scrimColor: widget.drawerScrimColor,
          edgeDragWidth: widget.drawerEdgeDragWidth,
          enableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        ),
      ],
    );
  }
}

/// ===================================================================
/// Promotion Banner
/// ===================================================================

class _FeedController extends StatefulWidget {
  const _FeedController({
    GlobalKey? key,
    required this.availableHeight,
    this.promoBanner,
    this.sliverFeedItems = const [],
    // required this.edgeDragHeight,
  }) : super(key: key);

  /// Total available height for the scroll area
  final double availableHeight;

  /// The widget below this widget in the tree.
  final Widget? promoBanner;

  final List<Widget> sliverFeedItems;

  /// The height of the area within which a vertical swipe will open the drawer.
  ///
  /// By default, the value used is the PromoBanner's height added to the padding
  /// edge of `MediaQuery.of(context).padding` that corresponds to [alignment].
  // final double edgeDragHeight;

  @override
  _FeedControllerState createState() => _FeedControllerState();
}

/// Total available space of the feed header when activated and collapsing.
const double _kPromoFlexibleSpace = 300;

/// The height of promotion banner when the feed drawer is inactive.
const double _kPromoBannerHeight = 150;

/// When dragging the promo banner faster than this velocity, the animation
/// controller is "fling" depends on the direction of the pan gesture.
const double _kMinFlingVelocity = 500;

const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class _FeedControllerState extends State<_FeedController>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Animation<double> scrollOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: _kBaseSettleDuration,
        reverseDuration: _kBaseSettleDuration * 1.5, // reverse should be slower
        vsync: this);

    scrollOffsetAnimation = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: widget.availableHeight - _kPromoFlexibleSpace,
      ),
    )..addListener(_animationChanged);

    _scrollController = ScrollController()..addListener(_scrollChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _animationChanged() {
    setState(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(scrollOffsetAnimation.value);
      }
    });
  }

  double backdropOpacity = 0.0;

  /// It determines whether AppBar should be visible or not.
  double appBarVisibility = 0.0;

  void _scrollChanged() {
    setState(() {
      // when scrolling over 30% the backdrop turn to black completely
      backdropOpacity = math.min(
        1.0,
        _scrollController.offset / (widget.availableHeight * 0.3),
      );

      appBarVisibility = backdropOpacity != 1.0 ? 0.0 : 1.0;

      bool isScrollOverFlexibleSpace = _scrollController.offset <
          widget.availableHeight - _kPromoFlexibleSpace;

      if (_controller.status == AnimationStatus.completed &&
          isScrollOverFlexibleSpace) _controller.reverse(from: 0.6);
    });
  }

  late AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
  }

  void _handleDragCancel() {
    if (_controller.isDismissed || _controller.isAnimating) return;
    if (_controller.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  void _move(double delta, Size size) {
    _controller.value = _controller.value + (-delta / size.height);
  }

  void _settle(Offset pixelsPerSecond, Size size) {
    if (_controller.isDismissed) return;

    // if dragging fast enough
    if (pixelsPerSecond.dy.abs() >= _kMinFlingVelocity) {
      double visualVelocity = -pixelsPerSecond.dy / size.height;
      _controller.fling(velocity: visualVelocity);
    } else if (_controller.value < 0.5) {
      // or drag lower than a thresholds will close the promo banner
      close();
    } else {
      open();
    }
  }

  void open() {
    _controller.fling(velocity: 1.0);
  }

  void close() {
    _controller.fling(velocity: -1.0);
  }

  final GlobalKey _gestureDetectorKey = GlobalKey();
  final GlobalKey _scrollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (_controller.status == AnimationStatus.dismissed) {
      final size = MediaQuery.of(context).size;
      return Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: GestureDetector(
          key: _gestureDetectorKey,
          onVerticalDragUpdate: (details) {
            _move(details.primaryDelta!, size);
          },
          onVerticalDragEnd: (details) {
            _settle(details.velocity.pixelsPerSecond, size);
          },
          child: widget.promoBanner,
        ),
      );
    } else {
      return PrimaryScrollController(
        controller: _scrollController,
        child: _buildScrollableContent(),
      );
    }
  }

  Widget _buildScrollableContent() {
    if (_controller.status == AnimationStatus.completed)
      return _buildCustomScrollView();

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      key: _gestureDetectorKey,
      onVerticalDragDown: _handleDragDown,
      onVerticalDragUpdate: (details) {
        _move(details.primaryDelta!, size);
      },
      onVerticalDragEnd: (details) {
        _settle(details.velocity.pixelsPerSecond, size);
      },
      onVerticalDragCancel: _handleDragCancel,
      child: _buildCustomScrollView(),
    );
  }

  Widget _buildCustomScrollView() {
    return RepaintBoundary(
      child: Stack(children: <Widget>[
        Container(
            color: Theme.of(context).primaryColor.withOpacity(backdropOpacity)),
        CustomScrollView(
          key: _scrollKey,
          primary: true,
          slivers: <Widget>[
            SliverOpacity(
              opacity: appBarVisibility,
              sliver: SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: _kBaseSettleDuration,
                      curve: Curves.easeOutExpo,
                    );
                  },
                ),
                title: Text('Messages'),
                centerTitle: false,
                pinned: true,
              ),
            ),
            SliverPromoBanner(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.promoBanner,
                  ),
                ],
              ),
            ),
            ...widget.sliverFeedItems,
          ],
        ),
      ]),
    );
  }
}

/// ===================================================================
/// Feed Header
/// ===================================================================

class SliverPromoBanner extends SingleChildRenderObjectWidget {
  SliverPromoBanner({Key? key, Widget? child}) : super(key: key, child: child);

  @override
  RenderSliverPromoBanner createRenderObject(BuildContext context) =>
      RenderSliverPromoBanner();
}

class RenderSliverPromoBanner extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a non-scrollable [RenderBox] which is
  /// sized to fit the remaining space in the viewport.
  RenderSliverPromoBanner({RenderBox? child}) : super(child: child);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    // The remaining space in the viewportMainAxisExtent. Can be <= 0 if we have
    // scrolled beyond the extent of the screen.
    double extent =
        constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;

    if (child != null) {
      double childExtent;
      switch (constraints.axis) {
        case Axis.horizontal:
          childExtent =
              child!.getMaxIntrinsicWidth(constraints.crossAxisExtent);
          break;
        case Axis.vertical:
          childExtent =
              child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);
          break;
      }

      // If the childExtent is greater than the computed extent, we want to use
      // that instead of potentially cutting off the child. This allows us to
      // safely specify a maxExtent.
      extent = math.max(extent, childExtent);
      child!.layout(constraints.asBoxConstraints(
        minExtent: extent,
        maxExtent: extent,
      ));
    }

    assert(
      extent.isFinite,
      'The calculated extent for the child of SliverFillRemaining is not finite. '
      'This can happen if the child is a scrollable, in which case, the '
      'hasScrollBody property of SliverFillRemaining should not be set to '
      'false.',
    );

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: extent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    if (child != null) {
      setChildParentData(child!, constraints, geometry!);
    }
  }
}

class EarnMoreWithVisaCard extends StatelessWidget {
  const EarnMoreWithVisaCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kPromoBannerHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Transform.rotate(
            angle: 0.01,
            origin: Offset(-200, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 60.0,
                padding: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(33, 33, 33, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'UBER',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              child: Container(
                height: 90.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.indigoAccent, Colors.lightBlue],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===================================================================
/// Feed Body
/// ===================================================================

class FeedSingleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        child: Card(
          shape: BeveledRectangleBorder(),
          margin: EdgeInsets.zero,
        ));
  }
}

class FeedMultiItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, i) {
          return Container(
            width: 300,
            child: Card(
              shape: BeveledRectangleBorder(),
              margin: EdgeInsets.zero,
            ),
          );
        },
        separatorBuilder: (_, __) =>
            Container(width: 6, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

/// ===================================================================
/// Miscellaneous
/// ===================================================================

class FeedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 6, color: Theme.of(context).primaryColor);
  }
}

class LocationRefresher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {},
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 16),
          Text('490 Post St', style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}
