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
        theme: ThemeData(textTheme: GoogleFonts.soraTextTheme()),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage() : super();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ContextMenu menu = ContextMenu();
  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: menu),
            Container(
              margin: EdgeInsets.only(top: 50, left: 30),
              child: GestureDetector(
                  onLongPress: () {
                    menu.showMenu(key);
                  },
                  onTap: () => menu.hideMenu(),
                  child: Container(
                      key: key, color: Colors.red, height: 100, width: 300)),
            ),
          ],
        ),
      ),
    );
  }
}
