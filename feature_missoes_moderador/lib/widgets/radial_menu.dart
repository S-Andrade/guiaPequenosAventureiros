import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;


const double _defaultButtonSize = 48.0;

/// An item in a [RadialMenu].
///
/// The type `T` is the type of the value the entry represents. All the entries
/// in a given menu must represent values with consistent types.
class RadialMenuItem<T> extends StatelessWidget {
  /// Creates a circular action button for an item in a [RadialMenu].
  ///
  /// The [child] argument is required.
  const RadialMenuItem({
    Key key,
    @required this.child,
    this.value,
    this.tooltip,
    this.size = _defaultButtonSize,
    this.backgroundColor,
    this.iconColor,
    // this.iconSize: 24.0,
  })  : assert(child != null),
        assert(size != null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically an [Icon] widget.
  final Widget child;

  /// The value to return if the user selects this menu item.
  ///
  /// Eventually returned in a call to [RadialMenu.onSelected].
  final T value;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String tooltip;

  /// The color to use when filling the button.
  ///
  /// Defaults to the primary color of the current theme.
  final Color backgroundColor;

  /// The size of the button.
  ///
  /// Defaults to 48.0.
  final double size;

  /// The color to use when painting the child icon.
  ///
  /// Defaults to the primary icon theme color.
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final Color _iconColor =
        iconColor ?? Theme.of(context).primaryIconTheme.color;

    Widget result;

    if (child != null) {
      result = new Center(
        child: IconTheme.merge(
          data: new IconThemeData(
            color: _iconColor,
          ),
          child: child,
        ),
      );
    }

    if (tooltip != null) {
      result = new Tooltip(
        message: tooltip,
        child: result,
      );
    }

    result = new Container(
      width: size,
      height: size,
      child: result,
    );

    return result;
  }
}


/// The button at the center of a [RadialMenu] which controls its open/closed
/// state.
class RadialMenuCenterButton extends StatelessWidget {
  /// Drives the opening/closing animation of the [RadialMenu].
  final Animation<double> openCloseAnimationController;

  /// Drives the animation when an item in the [RadialMenu] is pressed.
  final Animation<double> activateAnimationController;

  /// Called when the user presses this button.
  final VoidCallback onPressed;

  /// The opened/closed state of the menu.
  ///
  /// Determines which of [closedColor] or [openedColor] should be used as the
  /// background color of the button.
  final bool isOpen;

  /// The color to use when painting the icon.
  ///
  /// Defaults to [Colors.black].
  final Color iconColor;

  /// Background color when it is in its closed state.
  ///
  /// Defaults to [Colors.white].
  final Color closedColor;

  /// Background color when it is in its opened state.
  ///
  /// Defaults to [Colors.grey].
  final Color openedColor;

  /// The size of the button.
  ///
  /// Defaults to 48.0.
  final double size;

  /// The animation progress for the [AnimatedIcon] in the center of the button.
  final Animation<double> _progress;

  /// The scale factor applied to the button.
  ///
  /// Animates from 1.0 to 0.0 when an an item is pressed in the menu and
  /// [activateAnimationController] progresses.
  final Animation<double> _scale;

  RadialMenuCenterButton({
    @required this.openCloseAnimationController,
    @required this.activateAnimationController,
    @required this.onPressed,
    @required this.isOpen,
    this.iconColor = Colors.black,
    this.closedColor = Colors.white,
    this.openedColor = Colors.grey,
    this.size = _defaultButtonSize,
  })  : _progress = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: openCloseAnimationController,
            curve: new Interval(
              0.0,
              0.5,
              curve: Curves.ease,
            ),
          ),
        ),
        _scale = new Tween(begin: 1.0, end: 0.0).animate(
          new CurvedAnimation(
            parent: activateAnimationController,
            curve: Curves.elasticIn,
          ),
        );

  @override
  Widget build(BuildContext context) {
    final AnimatedIcon animatedIcon = new AnimatedIcon(
      color: iconColor,
      icon: AnimatedIcons.menu_close,
      progress: _progress,
    );

    final Widget child = new Container(
      width: size,
      height: size,
      child: new Center(
        child: animatedIcon,
      ),
    );

    final Color color = isOpen ? openedColor : closedColor;

    return new ScaleTransition(
      scale: _scale,
      child: new RadialMenuButton(
        child: child,
        backgroundColor: color,
        onPressed: onPressed,
      ),
    );
  }
}




class RadialMenuButton extends StatelessWidget {

  const RadialMenuButton({
    @required this.child,
    this.backgroundColor,
    this.onPressed,
  });

  final Widget child;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color color = backgroundColor ?? Theme.of(context).primaryColor;

    return new Semantics(
      button: true,
      enabled: true,
      child: new Material(
        type: MaterialType.circle,
        color: color,
        child: new InkWell(
          onTap: onPressed,
          child: child,
        ),
      ),
    );
  }


}




const double _radiansPerDegree = Math.pi / 180;
final double _startAngle = -90.0 * _radiansPerDegree;

typedef double ItemAngleCalculator(int index);

/// A radial menu for selecting from a list of items.
///
/// A radial menu lets the user select from a number of items. It displays a
/// button that opens the menu, showing its items arranged in an arc. Selecting
/// an item triggers the animation of a progress bar drawn at the specified
/// [radius] around the central menu button.
///
/// The type `T` is the type of the values the radial menu represents. All the
/// entries in a given menu must represent values with consistent types.
/// Typically, an enum is used. Each [RadialMenuItem] in [items] must be
/// specialized with that same type argument.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [RadialMenuItem], the widget used to represent the [items].
///  * [RadialMenuCenterButton], the button used to open and close the menu.
class RadialMenu<T> extends StatefulWidget {
  /// Creates a dropdown button.
  ///
  /// The [items] must have distinct values.
  ///
  /// The [radius], [menuAnimationDuration], and [progressAnimationDuration]
  /// arguments must not be null (they all have defaults, so do not need to be
  /// specified).
  const RadialMenu({
    Key key,
    @required this.items,
    @required this.onSelected,
    this.radius = 100.0,
    this.menuAnimationDuration = const Duration(milliseconds: 1000),
    this.progressAnimationDuration = const Duration(milliseconds: 1000),
  })  : assert(radius != null),
        assert(menuAnimationDuration != null),
        assert(progressAnimationDuration != null),
        super(key: key);

  /// The list of possible items to select among.
  final List<RadialMenuItem<T>> items;

  /// Called when the user selects an item.
  final ValueChanged<T> onSelected;

  /// The radius of the arc used to lay out the items and draw the progress bar.
  ///
  /// Defaults to 100.0.
  final double radius;

  /// Duration of the menu opening/closing animation.
  ///
  /// Defaults to 1000 milliseconds.
  final Duration menuAnimationDuration;

  /// Duration of the action activation progress arc animation.
  ///
  /// Defaults to 1000 milliseconds.
  final Duration progressAnimationDuration;

  @override
  RadialMenuState createState() => new RadialMenuState();
}

class RadialMenuState extends State<RadialMenu> with TickerProviderStateMixin {
  AnimationController _menuAnimationController;
  AnimationController _progressAnimationController;
  bool _isOpen = false;
  int _activeItemIndex;

  // todo: xqwzts: allow users to pass in their own calculator as a param.
  // and change this to the default: radialItemAngleCalculator.
  double calculateItemAngle(int index) {
    double _itemSpacing = 360.0 / widget.items.length;
    return _startAngle + index * _itemSpacing * _radiansPerDegree;
  }

  @override
  void initState() {
    super.initState();
    _menuAnimationController = new AnimationController(
      duration: widget.menuAnimationDuration,
      vsync: this,
    );
    _progressAnimationController = new AnimationController(
      duration: widget.progressAnimationDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _openMenu() {
    _menuAnimationController.forward();
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _menuAnimationController.reverse();
    setState(() => _isOpen = false);
  }

  Future<Null> _activate(int itemIndex) async {
    setState(() => _activeItemIndex = itemIndex);
    await _progressAnimationController.forward().orCancel;
    if (widget.onSelected != null) {
      widget.onSelected(widget.items[itemIndex].value);
    }
  }

  /// Resets the menu to its initial (closed) state.
  void reset() {
    _menuAnimationController.reset();
    _progressAnimationController.reverse();
    setState(() {
      _isOpen = false;
      _activeItemIndex = null;
    });
  }

  Widget _buildActionButton(int index) {
    final RadialMenuItem item = widget.items[index];

    return new LayoutId(
      id: '${_RadialMenuLayout.actionButton}$index',
      child: new RadialMenuButton(
        child: item,
        backgroundColor: item.backgroundColor,
        onPressed: () => _activate(index),
      ),
    );
  }

  Widget _buildActiveAction(int index) {
    final RadialMenuItem item = widget.items[index];

    return new LayoutId(
      id: '${_RadialMenuLayout.activeAction}$index',
      child: new ArcProgressIndicator(
        controller: _progressAnimationController.view,
        radius: widget.radius,
        color: item.backgroundColor,
        icon: item.child is Icon ? (item.child as Icon).icon : null,
        iconColor: item.iconColor,
        startAngle: calculateItemAngle(index),
      ),
    );
  }

  Widget _buildCenterButton() {
    return new LayoutId(
      id: _RadialMenuLayout.menuButton,
      child: new RadialMenuCenterButton(
        openCloseAnimationController: _menuAnimationController.view,
        activateAnimationController: _progressAnimationController.view,
        isOpen: _isOpen,
        onPressed: _isOpen ? _closeMenu : _openMenu,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < widget.items.length; i++) {
      if (_activeItemIndex != i) {
        children.add(_buildActionButton(i));
      }
    }

    if (_activeItemIndex != null) {
      children.add(_buildActiveAction(_activeItemIndex));
    }

    children.add(_buildCenterButton());

    return new AnimatedBuilder(
      animation: _menuAnimationController,
      builder: (BuildContext context, Widget child) {
        return new CustomMultiChildLayout(
          delegate: new _RadialMenuLayout(
            itemCount: widget.items.length,
            radius: widget.radius,
            calculateItemAngle: calculateItemAngle,
            controller: _menuAnimationController.view,
          ),
          children: children,
        );
      },
    );
  }
}

class _RadialMenuLayout extends MultiChildLayoutDelegate {
  static const String menuButton = 'menuButton';
  static const String actionButton = 'actionButton';
  static const String activeAction = 'activeAction';

  final int itemCount;
  final double radius;
  final ItemAngleCalculator calculateItemAngle;

  final Animation<double> controller;

  final Animation<double> _progress;

  _RadialMenuLayout({
    @required this.itemCount,
    @required this.radius,
    @required this.calculateItemAngle,
    this.controller,
  }) : _progress = new Tween<double>(begin: 0.0, end: radius).animate(
            new CurvedAnimation(curve: Curves.elasticOut, parent: controller));

  Offset center;

  @override
  void performLayout(Size size) {
    center = new Offset(size.width / 2, size.height / 2);

    if (hasChild(menuButton)) {
      Size menuButtonSize;
      menuButtonSize = layoutChild(menuButton, new BoxConstraints.loose(size));

      // place the menubutton in the center
      positionChild(
        menuButton,
        new Offset(
          center.dx - menuButtonSize.width / 2,
          center.dy - menuButtonSize.height / 2,
        ),
      );
    }

    for (int i = 0; i < itemCount; i++) {
      final String actionButtonId = '$actionButton$i';
      final String actionArcId = '$activeAction$i';
      if (hasChild(actionArcId)) {
        final Size arcSize = layoutChild(
          actionArcId,
          new BoxConstraints.expand(
            width: _progress.value * 2,
            height: _progress.value * 2,
          ),
        );

        positionChild(
          actionArcId,
          new Offset(
            center.dx - arcSize.width / 2,
            center.dy - arcSize.height / 2,
          ),
        );
      }

      if (hasChild(actionButtonId)) {
        final Size buttonSize =
            layoutChild(actionButtonId, new BoxConstraints.loose(size));

        final double itemAngle = calculateItemAngle(i);

        positionChild(
          actionButtonId,
          new Offset(
            (center.dx - buttonSize.width / 2) +
                (_progress.value) * Math.cos(itemAngle),
            (center.dy - buttonSize.height / 2) +
                (_progress.value) * Math.sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(_RadialMenuLayout oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
      radius != oldDelegate.radius ||
      calculateItemAngle != oldDelegate.calculateItemAngle ||
      controller != oldDelegate.controller ||
      _progress != oldDelegate._progress;
}



/// Draws an [ActionIcon] and [_ArcProgressPainter] that represent an active action.
/// As the provided [Animation] progresses the ActionArc grows into a full
/// circle and the ActionIcon moves along it.
class ArcProgressIndicator extends StatelessWidget {
  // required
  final Animation<double> controller;
  final double radius;

  // optional
  final double startAngle;
  final double width;

  /// The color to use when filling the arc.
  ///
  /// Defaults to the accent color of the current theme.
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  // private
  final Animation<double> _progress;

  ArcProgressIndicator({
    @required this.controller,
    @required this.radius,
    this.startAngle = 0.0,
    this.width,
    this.color,
    this.icon,
    this.iconColor,
    this.iconSize,
  }) : _progress = new Tween(begin: 0.0, end: 1.0).animate(controller);

  @override
  Widget build(BuildContext context) {
    TextPainter _iconPainter;
    final ThemeData theme = Theme.of(context);
    final Color _iconColor = iconColor ?? theme.accentIconTheme.color;
    final double _iconSize = iconSize ?? IconTheme.of(context).size;

    if (icon != null) {
      _iconPainter = new TextPainter(
        textDirection: Directionality.of(context),
        text: new TextSpan(
          text: new String.fromCharCode(icon.codePoint),
          style: new TextStyle(
            inherit: false,
            color: _iconColor,
            fontSize: _iconSize,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
          ),
        ),
      )..layout();
    }

    return new CustomPaint(
      painter: new _ArcProgressPainter(
        controller: _progress,
        color: color ?? theme.accentColor,
        radius: radius,
        width: width ?? _iconSize * 2,
        startAngle: startAngle,
        icon: _iconPainter,
      ),
    );
  }
}

class _ArcProgressPainter extends CustomPainter {
  // required
  final Animation<double> controller;
  final Color color;
  final double radius;
  final double width;

  // optional
  final double startAngle;
  final TextPainter icon;

  _ArcProgressPainter({
    @required this.controller,
    @required this.color,
    @required this.radius,
    @required this.width,
    this.startAngle = 0.0,
    this.icon,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double sweepAngle = controller.value * 2 * Math.pi;

    canvas.drawArc(
      Offset.zero & size,
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    if (icon != null) {
      double angle = startAngle + sweepAngle;
      Offset offset = new Offset(
        (size.width / 2 - icon.size.width / 2) + radius * Math.cos(angle),
        (size.height / 2 - icon.size.height / 2) + radius * Math.sin(angle),
      );

      icon.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(_ArcProgressPainter other) {
    return controller.value != other.controller.value ||
        color != other.color ||
        radius != other.radius ||
        width != other.width ||
        startAngle != other.startAngle ||
        icon != other.icon;
  }
}