import 'package:flutter/material.dart';
import 'package:flutter_context_menu/context_menu.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage() : super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.jetBrainsMonoTextTheme()),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage() : super();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void showData() {
    print("data");
  }

  ContextMenu menu;
  GlobalKey key = GlobalKey();
  GlobalKey key1 = GlobalKey();

  _MyHomePageState() {
    Map<String, Map> data = {
      "item1": {"icon": Icons.edit, "func": showData},
      "item2": {"icon": Icons.edit, "func": showData}
    };
    menu = ContextMenu(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              child: GestureDetector(
                  onTapDown: (details) {
                    menu.getWidgetPosition(details);
                  },
                  onLongPress: () {
                    menu.showMenuAboveWidget(key);
                  },
                  onTap: () => menu.hideMenu(),
                  child: Container(
                      key: key, color: Colors.red, height: 100, width: 300)),
            ),
            Container(
              margin: EdgeInsets.only(top: 300),
              child: GestureDetector(
                  onTapDown: (details) {
                    menu.getWidgetPosition(details);
                  },
                  onLongPress: () {
                    menu.showMenuAtFingerPosition(key1);
                  },
                  onTap: () => menu.hideMenu(),
                  child: Container(
                      key: key1, color: Colors.green, height: 100, width: 300)),
            ),
            menu
          ],
        ),
      ),
    );
  }
}
