// ignore_for_file: avoid_print, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContextMenu extends StatefulWidget {
  _ContextMenuState state;
  Map data;

  ContextMenu(this.data, {Key key}) : super(key: key);

  void getWidgetPosition(TapDownDetails details) {
    state._getFingerPosition(details);
  }

  void showMenuAboveWidget(GlobalKey widgetKey) {
    state.showMenuAboveWidget(widgetKey);
  }

  void showMenuAtFingerPosition(GlobalKey widgetKey) {
    state.showMenuAtFingerPosition(widgetKey);
  }

  void hideMenu() {
    state.hideMenu();
  }

  @override
  _ContextMenuState createState() {
    state = _ContextMenuState(data);
    return state;
  }
}

class _ContextMenuState extends State<ContextMenu> {
  GlobalKey key;
  double _opacity = 0.0;
  double _menuHeight = 0;
  double _menuWidth = 0;
  final int _displayVisibilityDuration = 100;

  double _fingerXpos = 0;
  double _fingerYpos = 0;

  Color backgroundColor = Colors.black;
  Color iconColor = Colors.white;
  Color textColor = Colors.white;
  Map<String, Map> data;

  _ContextMenuState(this.data);

  _getFingerPosition(TapDownDetails details) {
    if (_opacity == 0) {
      _fingerXpos = details.localPosition.dx;
      _fingerYpos = details.localPosition.dy;

      _menuWidth = key.currentContext.size.width;
      _menuHeight = key.currentContext.size.height;
    }
  }

  List<Widget> _buildItemsList(Map<String, Map> itemData) {
    List<Widget> view = [];

    itemData.forEach((key, Map data) {
      view.add(GestureDetector(
          onLongPress: () {},
          onTap: () {
            data["func"]();
          },
          child: SizedBox(
            height: 30,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    data["icon"],
                    color: iconColor,
                    size: 15,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      key,
                      style: TextStyle(color: textColor, fontSize: 13),
                    ))
              ],
            ),
          )));
    });

    return view;
  }

  void showMenuAboveWidget(GlobalKey widgetKey) {
    RenderBox box = widgetKey.currentContext.findRenderObject() as RenderBox;
    Offset widgetPosition = box.localToGlobal(Offset.zero);
    print(_fingerXpos);
    setState(() {
      //Center the menu to the widget
      _fingerXpos = widgetPosition.dx -
          ((_menuWidth / 2) - widgetKey.currentContext.size.width / 2);
      _fingerYpos = widgetPosition.dy - _menuHeight;
      _opacity = 1;
    });
  }

  void showMenuAtFingerPosition(GlobalKey widgetKey) {
    RenderBox box = widgetKey.currentContext.findRenderObject() as RenderBox;
    Offset widgetPosition = box.localToGlobal(Offset.zero);
    setState(() {
      print(_fingerYpos);
      _fingerYpos += widgetPosition.dy;
      _fingerXpos += widgetPosition.dx;
      _opacity = 1;
    });
  }

  void hideMenu() {
    setState(() {
      _opacity = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    key = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (TapDownDetails details) {
        _getFingerPosition(details);
        RenderBox box = key.currentContext.findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        double x = position.dx;
        double y = position.dy;
        double screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth - _fingerXpos < _menuWidth) {
          setState(() {
            _fingerXpos = _fingerXpos - _menuWidth;
          });
        }
      },
      onTap: () {
        setState(() {
          _opacity = 0;
        });
      },
      child: Stack(
        children: [
          Positioned(
            top: _fingerYpos - 30,
            left: _fingerXpos,
            child: AnimatedOpacity(
              curve: Curves.decelerate,
              duration: Duration(milliseconds: _displayVisibilityDuration),
              opacity: _opacity,
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                key: key,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: Row(
                  children: [
                    Row(
                      children: _buildItemsList(data),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
