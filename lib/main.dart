import 'package:flutter/material.dart';

import './screens/meals_screen.dart';
import './screens/tabs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      // home: CategoriesScreen(),
      routes: {
        '/': (_) => const TabsScreen(),
        MealsScreen.routeName: (_) => const MealsScreen()
      },
    );
  }
}
