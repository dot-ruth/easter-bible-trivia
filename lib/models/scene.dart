class Choice {
  final String text;
  final String outcomeSceneId;

  Choice({required this.text, required this.outcomeSceneId});

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      text: json['text'],
      outcomeSceneId: json['outcomeSceneId']
    );
  }
}

class Scene {
  final String id;
  final String narrative;
  final String imagePath;
  final List<Choice> choices;

  Scene({
    required this.id,
    required this.narrative,
    required this.imagePath,
    required this.choices,
  });

  factory Scene.fromJson(Map<String, dynamic> json) {
    var choiceList = (json['choices'] as List)
        .map((c) => Choice.fromJson(c))
        .toList();
    return Scene(
      id: json['id'],
      narrative: json['narrative'],
      imagePath: json['imagePath'],
      choices: choiceList,
    );
  }
}
