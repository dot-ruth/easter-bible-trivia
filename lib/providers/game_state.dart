import 'package:flutter/material.dart';
import '../models/scene.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GameState extends ChangeNotifier {
  List<Scene> _scenes = [];
  Scene? _currentScene;
  Scene? get currentScene => _currentScene;

  Future<void> loadScenes() async {
    final String jsonString = await rootBundle.loadString('lib/data/scene.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _scenes = jsonList.map((s) => Scene.fromJson(s)).toList();
    _currentScene = _scenes.first;
    notifyListeners();
  }

  void makeChoice(Choice choice) {
    _currentScene = _scenes.firstWhere((s) => s.id == choice.outcomeSceneId);
    notifyListeners();
  }

  void reset() {
    _currentScene = _scenes.first;
    notifyListeners();
  }
}
