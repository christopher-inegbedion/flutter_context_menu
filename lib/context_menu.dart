// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContextMenu extends StatefulWidget {
  _ContextMenuState state;

  ContextMenu({Key key}) : super(key: key);

  void showMenu(GlobalKey widgetKey) {
    state.showMenu(widgetKey);
  }

  void hideMenu() {
    state.hideMenu();
  }

  @override
  _ContextMenuState createState() {
    state = _ContextMenuState();
    return state;
  }
}

class _ContextMenuState extends State<ContextMenu> {
  GlobalKey key;
  double opacity = 0.0;
  double menuHeight = 0;
  double menuWidth = 0;
  double fingerXpos = 0;
  double fingerYpos = 0;
  Color backgroundColor = Colors.black;
  Color iconColor = Colors.white;
  Color textColor = Colors.white;
  Map<String, IconData> data = {"item1": Icons.edit, "item2": Icons.star};

  _onTapDown(TapDownDetails details) {
    fingerXpos = details.localPosition.dx;
    fingerYpos = details.localPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + fingerXpos.toString() + ", " + fingerYpos.toString());
  }

  List<Widget> buildItemsList(Map<String, IconData> itemData) {
    List<Widget> view = [];

    itemData.forEach((key, IconData icon) {
      view.add(GestureDetector(
          onLongPress: () {},
          onTap: () {},
          child: SizedBox(
            height: 30,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Icon(
                    icon,
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

  void showMenu(GlobalKey widgetKey) {
    RenderBox box = widgetKey.currentContext.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    print(widgetKey.currentContext.size.width);
    setState(() {
      fingerXpos = position.dx -
          ((menuWidth / 2) - widgetKey.currentContext.size.width / 2);
      fingerYpos = position.dy - menuHeight;
      opacity = 1;
    });
  }

  void hideMenu() {
    setState(() {
      opacity = 0;
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
        _onTapDown(details);
        RenderBox box = key.currentContext.findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        double x = position.dx;
        double y = position.dy;
        menuWidth = key.currentContext.size.width;
        menuHeight = key.currentContext.size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        if (screenWidth - fingerXpos < menuWidth) {
          setState(() {
            fingerXpos = fingerXpos - menuWidth;
          });
        }
      },
      onTap: () {
        setState(() {
          opacity = 0;
        });
      },
      // onLongPress: () {
      //   setState(() {
      //     opacity = 1;
      //   });
      // },
      child: Stack(
        children: [
          Positioned(
            top: fingerYpos - 30,
            left: fingerXpos,
            child: Opacity(
              opacity: opacity,
              child: Container(
                key: key,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(2))),
                child: Row(
                  children: [
                    Row(
                      children: buildItemsList(data),
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
