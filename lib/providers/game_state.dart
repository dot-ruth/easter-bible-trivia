import 'package:flutter/material.dart';
import '../models/scene.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class GameState extends ChangeNotifier {
  List<Scene> _scenes = [];
  Scene? _currentScene;
  int _understandingScore = 0;
  String? _selectedCharacter;
  String? get selectedCharacter => _selectedCharacter;

  Scene? get currentScene => _currentScene;
  int get understandingScore => _understandingScore;

  void selectCharacter(String name) {
  _selectedCharacter = name;
  notifyListeners();
}

  Future<void> loadScenes() async {
    final String jsonString = await rootBundle.loadString('lib/data/scene.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _scenes = jsonList.map((s) => Scene.fromJson(s)).toList();
    _currentScene = _scenes.first;
    notifyListeners();
  }

  void makeChoice(Choice choice) {
    _understandingScore += choice.impact;
    if (choice.outcomeSceneId == 'final') {
  int score = _understandingScore;

  String endingId;
  if (score >= 6) {
    endingId = 'ending_good';
  } else if (score >= 3) {
    endingId = 'ending_neutral';
  } else {
    endingId = 'ending_fallen';
  }
  _currentScene = _scenes.firstWhere((s) => s.id == endingId);

  // gameState.goToScene(endingId);
} else {
  _currentScene = _scenes.firstWhere((s) => s.id == choice.outcomeSceneId);
  // gameState.increaseSpiritualScore(points);
  // gameState.goToScene(nextSceneId);
}

    _currentScene = _scenes.firstWhere((s) => s.id == choice.outcomeSceneId);
    notifyListeners();
  }

  void reset() {
    _understandingScore = 0;
    _currentScene = _scenes.first;
    notifyListeners();
  }
}
