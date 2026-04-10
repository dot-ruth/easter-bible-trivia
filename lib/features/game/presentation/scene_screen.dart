import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/glass_card.dart';
import '../models/scene.dart';
import '../state/game_state.dart';
import 'widgets/choice_button.dart';

class SceneScreen extends StatelessWidget {
  const SceneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final scene = gameState.currentScene;

    if (scene == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (gameState.isGameOver) {
      return _SummaryView(scene: scene);
    }

    if (scene.id == 'start_screen') {
      return _StartView(scene: scene);
    }

    return _SceneView(scene: scene);
  }
}

Future<void> showHintSheet(BuildContext context, String hintVerse) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hint verse',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                hintVerse,
                style: const TextStyle(fontSize: 16, height: 1.35),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _StartView extends StatelessWidget {
  final Scene scene;

  const _StartView({required this.scene});

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: _Background(
        imagePath: scene.imagePath,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Spacer(),
                GlassCard(
                  child: Column(
                    children: [
                      Text(
                        'Easter Bible Trivia',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Follow the story, choose wisely, and see how many you get right.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => gameState.makeChoice(scene.choices.first),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Start'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  final Scene scene;

  const _SummaryView({required this.scene});

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();
    final isWin = scene.id == 'correct';

    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isWin ? 'He is risen!' : 'Not quite—try again',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isWin ? Colors.white : null,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: [
                    Text(
                      'Correct answers',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isWin ? Colors.white : null,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${gameState.totalCorrect}'
                      '${gameState.totalAnswered > 0 ? ' / ${gameState.totalScenes - 3}' : ''}',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: isWin ? Colors.white : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      scene.narrative,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isWin ? Colors.white : null,
                          ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: gameState.reset,
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Play again'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isWin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Summary'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'Restart',
              onPressed: gameState.reset,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: _Background(
          imagePath: scene.imagePath,
          child: SafeArea(child: content),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        actions: [
          IconButton(
            tooltip: 'Restart',
            onPressed: gameState.reset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: content,
    );
  }
}

class _SceneView extends StatelessWidget {
  final Scene scene;

  const _SceneView({required this.scene});

  IconData? _choiceIcon(Choice c) {
    final t = c.text.trim().toLowerCase();
    if (t == 'previous scene' || t.startsWith('previous')) return Icons.arrow_back_rounded;
    return Icons.check_circle_outline_rounded;
  }

  bool _isPreviousChoice(Choice c) {
    final t = c.text.trim().toLowerCase();
    return t == 'previous scene' || t.startsWith('previous');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();
    final hintVerse = context.select<GameState, String?>((s) => s.hintVerse);
    final canGoBack = context.select<GameState, bool>((s) => s.canGoBack);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (hintVerse != null)
            IconButton(
              tooltip: 'Hint',
              onPressed: () => showHintSheet(context, hintVerse),
              icon: const Icon(Icons.lightbulb_outline_rounded),
            ),
          IconButton(
            tooltip: 'Restart',
            onPressed: () => gameState.reset(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _Background(
        imagePath: scene.imagePath,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final fade = FadeTransition(opacity: animation, child: child);
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.03, 0.02),
                        end: Offset.zero,
                      ).animate(animation),
                      child: fade,
                    );
                  },
                  child: GlassCard(
                    key: ValueKey(scene.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          scene.narrative,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 14),
                        if (gameState.totalAnswered > 0)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Score: ${gameState.totalCorrect}/${gameState.totalScenes - 3}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ...scene.choices.map((c) {
                          final isPrev = _isPreviousChoice(c);
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ChoiceButton(
                              text: c.text,
                              icon: _choiceIcon(c),
                              onPressed: isPrev && !canGoBack ? null : () => gameState.makeChoice(c),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final String imagePath;
  final Widget child;

  const _Background({required this.imagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath.trim().isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasImage)
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          )
        else
          Container(color: const Color(0xFF6D4C41)),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xCC000000),
                Color(0x66000000),
                Color(0xAA000000),
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(color: Colors.transparent),
        ),
        child,
      ],
    );
  }
}

