# Animal Wizz

Animal Wizz is an interactive Flutter app that helps kids learn about animals, habitats, food chains, and life cycles through playful, voice-enabled games.

Entry point: `lib/main.dart`

## Features

- Home and navigation with bottom tabs (Home, Lessons, Quiz) and animated transitions.
- Memory Game: flip-and-match pictures and names; easy/medium/hard, initial peek timer, tries/stars, confetti, sound and TTS, English/Spanish toggle.
- Habitat Scenes: Desert, Forest, Arctic, Ocean pages; tap animals for images and facts; language switch and “Listen” via TTS.
- Quiz Hub: topic selector (Animals, Habitats, Life Cycles, Food Chain) with responsive grid.
- Multiple‑choice Quiz: timed questions, English/Spanish toggle, TTS for prompts, confetti on correct.
- Food Chain Game: drag-and-drop Producer → Primary → Secondary → Tertiary with scoring, per‑item info dialogs, narrated summary.
- Life Cycles Game: drag-and-drop stage sequencing (Butterfly, Frog) with bounce/shake feedback and narration.

## Directory Layout

```
lib/
  main.dart
  data/
    animals.dart
  pages/
    jungle_lessons.dart
    memory_game_page.dart
    food_chain_game_page.dart
    life_cycles_game_page.dart
    quiz_selection_page.dart
    quiz_page.dart
    habitat_game_page.dart
    desert_game_page.dart
    forest_game_page.dart
    arctic_game_page.dart
    ocean_game_page.dart
  widgets/
    drag_drop_quiz_widget.dart
    subtopic_card.dart

assets/
  images/            # Animal images, backgrounds, icons
  sounds/
    correct.mp3
    wrong.mp3

pubspec.yaml         # SDK constraints, dependencies, assets
```

## Project Framework Details

- Framework: Flutter (Material Design)
- Language: Dart (SDK constraint: `^3.7.0`)
- Navigation: `MaterialApp` routes + in-app navigation
- State management: StatefulWidgets with `setState`
- Internationalization: Manual English/Spanish toggles across games
- Media: Text‑to‑Speech for narration; sound effects for feedback; lightweight animations and confetti
- Platforms: Mobile + desktop + web (project scaffolding for Android, iOS, Web, macOS, Windows, Linux)

## Setup

- Prerequisites: Flutter (stable) with Dart 3.7+
- Install packages: `flutter pub get`
- Run on device: `flutter run`
- Optional web: `flutter run -d chrome`

Assets are declared in `pubspec.yaml`. Add new images to `assets/images/` and run `flutter pub get` if you change asset lists.

## Key Packages

- `flutter_tts` — text‑to‑speech narration
- `audioplayers` — sound effects (correct/wrong; optional animal SFX if added and declared)
- `confetti` — celebration effects for wins/correct answers
- `flutter_animate`, `animate_do` — simple, declarative UI animations
- `cupertino_icons` — platform icons

