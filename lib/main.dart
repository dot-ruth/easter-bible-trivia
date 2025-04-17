import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_state.dart';
import 'screens/scene_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState()..loadScenes(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hearts Redeemed',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const SceneScreen(),
    );
  }
}
