class Choice {
  final String text;
  final String outcomeSceneId;
  final int impact;

  Choice({required this.text, required this.outcomeSceneId, required this.impact});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      text: json['text'],
      outcomeSceneId: json['outcomeSceneId'],
      impact: json['impact'],
    );
  }
}

class Scene {
  final String id;
  final String character;
  final String narrative;
  final List<Choice> choices;

  Scene({
    required this.id,
    required this.character,
    required this.narrative,
    required this.choices,
  });

  factory Scene.fromJson(Map<String, dynamic> json) {
    var choiceList = (json['choices'] as List)
        .map((c) => Choice.fromJson(c))
        .toList();
    return Scene(
      id: json['id'],
      character: json['character'],
      narrative: json['narrative'],
      choices: choiceList,
    );
  }
}
