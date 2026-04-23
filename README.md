# Animal Wizz

Animal Wizz is an interactive Flutter app that helps kids learn about animals, habitats, food chains, and life cycles through playful, voice-enabled games.

Entry point: `lib/main.dart`

## Features

- Home and navigation with bottom tabs (Home, Lessons, Quiz) and animated transitions.
- Memory Game: flip-and-match pictures and names; easy/medium/hard, initial peek timer, tries/stars, confetti, sound and TTS, English/Spanish toggle.
- Habitat Scenes: Desert, Forest, Arctic, Ocean — single configurable `HabitatPage` widget driven by `HabitatConfig`. Tap animals for images and bilingual facts. Prev/next habitat arrows, back button, and "Listen" via TTS.
- Quiz Hub: topic selector (Animals, Habitats, Life Cycles, Food Chain) with responsive grid.
- Multiple-choice Quiz: timed questions, English/Spanish toggle, TTS for prompts, confetti on correct.
- Habitat Quiz: multi-choice questions about which animals live where.
- Tracking Quiz: clue-based animal detective game across 4 habitats.
- Feed Animal Game: drag food to the correct animal with bilingual facts and TTS.
- Word Puzzle: crossword-style fill game with animal clues.
- Food Chain Game: drag-and-drop Producer → Primary → Secondary → Tertiary with scoring, per-item info dialogs, narrated summary.
- Life Cycles Game: drag-and-drop stage sequencing (Butterfly, Frog) with bounce/shake feedback and narration.

## Architecture

### Data Layer

All animal data lives in a single typed source:

- `models/animal.dart` — `Animal` class with `name`, `nameEs`, `image`, `description`, `descriptionEs`, `category`, `habitat`, `sound`
- `data/animals.dart` — centralized list of all animals with helper functions:
  - `animalsForHabitat(name)` — filters by habitat (Desert, Forest, Arctic, Ocean)
  - `animalsForCategory(name)` — filters by category (Herbivores, Carnivores, Omnivores, Rainforest, Desert, Arctic, Ocean, Forest)

Game-specific data (feeding game food types, tracking quiz clues, quiz questions) remains in their respective page files since those fields are game-specific, not animal-specific.

### Habitat Pages

The 4 habitat pages (Desert, Forest, Arctic, Ocean) are powered by a single `HabitatPage` widget with a `HabitatConfig`:

```dart
const desertConfig = HabitatConfig(
  name: 'Desert',
  backgroundImage: 'assets/images/desser_bg.png',
  bannerText: "🏜️ Let's explore the desert habitat!",
  prevRoute: '/arctic',
  nextRoute: '/forest',
  arrowColor: Color(0xFF3E2723),
);
```

Animals are loaded from the central data layer via `animalsForHabitat(config.name)`.

## Directory Layout

```
lib/
  main.dart
  models/
    animal.dart              # Unified Animal model
    animal_model.dart        # FoodType + AnimalModel (feeding game)
  data/
    animals.dart             # Central animal data (39 animals)
  pages/
    habitat_page.dart        # Unified habitat viewer + configs
    jungle_lessons.dart      # Lessons hub (topic carousel)
    memory_game_page.dart    # Flip & match memory game
    feed_animal_game.dart    # Drag food to animal game
    tracking_quiz_page.dart  # Clue-based animal detective
    food_chain_game_page.dart
    life_cycles_game_page.dart
    quiz_selection_page.dart # Quiz topic grid
    quiz_page.dart           # Timed multi-choice quiz
    habitat_game_page.dart   # Habitat multi-choice quiz
    animal_word_puzzle_page.dart
    subtopic_detail_page.dart
  services/
    tts_service.dart         # TTS wrapper (underused — standardization planned)
  widgets/
    drag_drop_quiz_widget.dart
    food_card.dart
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
- State management: StatefulWidgets with `setState` (Provider migration planned)
- Internationalization: Manual English/Spanish toggles across games
- Media: Text-to-Speech for narration; sound effects for feedback; lightweight animations and confetti
- Platforms: Mobile + desktop + web (project scaffolding for Android, iOS, Web, macOS, Windows, Linux)

## Setup

- Prerequisites: Flutter (stable) with Dart 3.7+
- Install packages: `flutter pub get`
- Run on device: `flutter run`
- Optional web: `flutter run -d chrome`

Assets are declared in `pubspec.yaml`. Add new images to `assets/images/` and run `flutter pub get` if you change asset lists.

## Key Packages

- `flutter_tts` — text-to-speech narration
- `audioplayers` — sound effects (correct/wrong; optional animal SFX if added and declared)
- `confetti` — celebration effects for wins/correct answers
- `flutter_animate`, `animate_do` — simple, declarative UI animations
- `cupertino_icons` — platform icons
