import 'package:flutter/material.dart';
import '../models/scene.dart';

class GameState extends ChangeNotifier {
  final List<Scene> _scenes = [];
  Scene? _currentScene;
  Scene? get currentScene => _currentScene;

  void makeChoice(Choice choice) {
    _currentScene = _scenes.firstWhere((s) => s.id == choice.outcomeSceneId);
    notifyListeners();
  }

  void reset() {
    _currentScene = _scenes.first;
    notifyListeners();
  }
}
