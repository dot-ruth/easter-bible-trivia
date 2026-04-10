import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/game/state/game_state.dart';
import '../features/game/presentation/scene_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resurrection',
      theme: AppTheme.light(),
      home: ChangeNotifierProvider(
        create: (_) => GameState()..loadScenes(),
        child: const SceneScreen(),
      ),
    );
  }
}

