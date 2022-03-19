import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewer3d/viewer3d.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // CupertinoIcons.view_3d
    return Scaffold(
      appBar: AppBar(
        title: Text("Viewer3D"),
      ),
      body: MenuLayoutj(
        home: _buildHome,
        menu: _buildMenu,
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.transparent,
            child: Center(
                child: TextButton(
              onPressed: () {
                MenuLayoutj.toggle(context);
              },
              child: Text("menu"),
            )),
          ),
        ),
        ClipRect(child: Align(widthFactor: 1, child: View3D.me())),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MenuLayoutj.toggle(context);
      },
      child: ColoredBox(
        color: Colors.red,
        child: SizedBox.expand(
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
