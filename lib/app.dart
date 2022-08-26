import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:todoism/page/home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      builder: (context, child) {
        return ContextMenuOverlay(child: child!);
      },
    );
  }
}
