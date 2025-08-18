import 'package:flutter/material.dart';
import 'package:blessing_of_olympus/app/screens/home_screen/home_screen.dart';
import 'package:blessing_of_olympus/app/screens/splash_screeen/splash_screen.dart';
import 'package:blessing_of_olympus/app/screens/no_connection_screen/no_internet_connection_screen.dart';
import 'package:blessing_of_olympus/app/screens/daily_bonus_screen/daily_bonus_screen.dart';
import 'package:blessing_of_olympus/app/screens/shop_screen/shop_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(title: '',),
    );
  }
}