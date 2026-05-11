// Reexporta HomeScreen como MainShell para que main.dart lo encuentre
export 'home/home_screen.dart' show HomeScreen;

import 'package:flutter/material.dart';
import 'home/home_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}