// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class ContextMenu extends StatefulWidget {
  const ContextMenu() : super();

  @override
  _ContextMenuState createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  GlobalKey key = GlobalKey();
  bool visible = false;
  double fingerXpos = 0;
  double fingerYpos = 0;
  Color backgroundColor = Colors.black;
  Color iconColor = Colors.white;
  Color textColor = Colors.white;
  Map<String, IconData> data = {"item1": Icons.star, "item2": Icons.star};

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      onTap: () {
        setState(() {
          visible = false;
        });
      },
      onLongPress: () {
        setState(() {
          visible = true;
        });
        print(key.currentWidget);
      },
      child: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            Visibility(
              visible: visible,
              child: Positioned(
                  top: fingerYpos - 30,
                  left: fingerXpos,
                  child: Container(
                    key: key,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2))),
                    // height: 30,
                    child: Row(
                      children: [
                        Row(
                          children: buildItemsList(data),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
