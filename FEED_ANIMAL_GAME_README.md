# Feed the Animal Game - Asset Requirements

## Overview
The "Feed the Animal Game" is now integrated into the Quiz section. This game teaches kids about what different animals eat through an interactive drag-and-drop interface with English/Spanish toggle support.

## Features Implemented
✅ Drag-and-drop food selection
✅ English/Spanish language toggle with voice-over (TTS)
✅ Colorful, kid-friendly UI
✅ Sound effects and animal sounds
✅ Animations (happy, sad, confetti)
✅ Score tracking and level progression
✅ Animal facts after correct answers
✅ 10 different animals with varied diets

## Files Created
1. `/lib/models/animal_model.dart` - Animal data model and game data
2. `/lib/widgets/food_card.dart` - Reusable food card widget
3. `/lib/services/tts_service.dart` - Text-to-speech service for voice-overs
4. `/lib/pages/feed_animal_game.dart` - Main game page (already existed, now functional)

## Required Assets

### Animal Images (PNG or JPG format)
Place in `assets/images/` folder:
- ✅ elephant.jpg (exists)
- ✅ lion.jpg (exists)
- ✅ tiger.jpg (exists)
- ✅ penguin.png (exists)
- ✅ dolphin.jpg (exists)
- ✅ shark.jpg (exists)
- ✅ chimpanzee.jpg (exists - used as placeholder for monkey/gorilla)
- ✅ deer.jpg (exists - used as placeholder for giraffe)

### Optional: Better Images
For improved visual experience, add these:
- ❌ cow.png/jpg
- ❌ monkey.png/jpg
- ❌ giraffe.png/jpg
- ❌ gorilla.png/jpg

### Animal Sounds (MP3 format)
Place in `assets/sounds/` folder:
- ❌ cow.mp3
- ❌ lion.mp3
- ❌ monkey.mp3
- ❌ penguin.mp3
- ❌ elephant.mp3
- ❌ tiger.mp3
- ❌ dolphin.mp3
- ❌ giraffe.mp3
- ❌ gorilla.mp3
- ❌ shark.mp3

### Existing Sound Effects
- ✅ correct.mp3 (exists)
- ✅ wrong.mp3 (exists)

## Game Mechanics

### Animals and Their Diets
1. **Cow** - Grass (Herbivore)
2. **Lion** - Meat (Carnivore)
3. **Monkey** - Fruits (Omnivore)
4. **Penguin** - Fish
5. **Elephant** - Grass (Herbivore)
6. **Tiger** - Meat (Carnivore)
7. **Dolphin** - Fish
8. **Giraffe** - Grass (Herbivore)
9. **Gorilla** - Fruits
10. **Shark** - Fish

### Food Options
- 🥩 Meat (Red)
- 🌿 Grass (Green)
- 🐟 Fish (Blue)
- 🍎 Fruits (Orange)

### Level System
- **Level 1**: 4 food options
- **Level 2**: 6 food options (includes decoy items like Bones and Leaves)

### Scoring
- Correct answer: +10 points
- Wrong answer: Try again (no penalty)
- Perfect score (50/50): Unlock next level

## How to Play
1. Navigate to Quiz section in the app
2. Select "Feed Animals" card
3. Drag the correct food to the hungry animal
4. Hear animal sounds and fun facts
5. Complete 5 animals to see final score
6. Toggle between English 🇬🇧 and Spanish 🇪🇸 anytime

## Language Support
All text, food names, and animal facts are fully translated:
- English (default)
- Spanish

The app uses Flutter TTS for voice-over support in both languages.

## Dependencies
Already included in `pubspec.yaml`:
- `flutter_tts: ^3.8.3` - Text-to-speech
- `audioplayers: ^5.2.1` - Sound effects
- `confetti: ^0.7.0` - Celebration animations

## Testing Notes
- The game works without animal sound files (only TTS will play)
- Missing images will show a fallback icon
- Placeholder images are used for missing animals
- Test both English and Spanish modes
- Verify drag-and-drop works on different screen sizes

## Future Enhancements
- Add more animals (15-20 total)
- Add different difficulty modes
- Implement haptic feedback
- Add multiplayer mode
- Save high scores locally
- Add achievements system
