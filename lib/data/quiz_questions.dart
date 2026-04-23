import 'quiz_models.dart';

// ---------------------------------------------------------------------------
// 1. Animals Quiz — migrated from JungleQuizPage 'Animals' section
// ---------------------------------------------------------------------------
const animalsQuizConfig = QuizConfig(
  titleEn: 'Animals Quiz',
  titleEs: 'Quiz de Animales',
  questionsPerRound: 3,
  questions: [
    QuizQuestion(
      questionEn: 'What animal is known as the king of the jungle?',
      questionEs: '¿Qué animal es conocido como el rey de la jungla?',
      options: [
        QuizOption(textEn: 'Elephant', textEs: 'Elefante', image: 'assets/images/elephant.jpg'),
        QuizOption(textEn: 'Tiger', textEs: 'Tigre', image: 'assets/images/tiger.jpg'),
        QuizOption(textEn: 'Lion', textEs: 'León', image: 'assets/images/lion.jpg'),
        QuizOption(textEn: 'Bear', textEs: 'Oso', image: 'assets/images/bear.jpg'),
      ],
      correctIndex: 2,
    ),
    QuizQuestion(
      questionEn: 'Which animal is a herbivore?',
      questionEs: '¿Qué animal es un herbívoro?',
      options: [
        QuizOption(textEn: 'Tiger', textEs: 'Tigre', image: 'assets/images/tiger.jpg'),
        QuizOption(textEn: 'Elephant', textEs: 'Elefante', image: 'assets/images/elephant.jpg'),
        QuizOption(textEn: 'Snake', textEs: 'Serpiente', image: 'assets/images/snake.webp'),
        QuizOption(textEn: 'Eagle', textEs: 'Águila', image: 'assets/images/eagle.jpg'),
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      questionEn: 'What do carnivores eat?',
      questionEs: '¿Qué comen los carnívoros?',
      options: [
        QuizOption(textEn: 'Fruits', textEs: 'Frutas', image: 'assets/images/herbivore.png'),
        QuizOption(textEn: 'Plants', textEs: 'Plantas', image: 'assets/images/grass.jpg'),
        QuizOption(textEn: 'Meat', textEs: 'Carne', image: 'assets/images/carnivore.png'),
        QuizOption(textEn: 'Leaves', textEs: 'Hojas', image: 'assets/images/herbivore.png'),
      ],
      correctIndex: 2,
    ),
  ],
);

// ---------------------------------------------------------------------------
// 2. Habitats Quiz — migrated from HabitatGamePage
// ---------------------------------------------------------------------------
const habitatsQuizConfig = QuizConfig(
  titleEn: 'Habitats Quiz',
  titleEs: 'Quiz de Hábitats',
  questionsPerRound: 4,
  questions: [
    QuizQuestion(
      questionEn: 'Which animal lives in the desert?',
      questionEs: '¿Qué animal vive en el desierto?',
      options: [
        QuizOption(textEn: 'Camel', textEs: 'Camello', image: 'assets/images/camel.jpg'),
        QuizOption(textEn: 'Penguin', textEs: 'Pingüino', image: 'assets/images/penguin.png'),
        QuizOption(textEn: 'Eagle', textEs: 'Águila', image: 'assets/images/eagle.jpg'),
        QuizOption(textEn: 'Bear', textEs: 'Oso', image: 'assets/images/bear.jpg'),
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      questionEn: 'Where do polar bears live?',
      questionEs: '¿Dónde viven los osos polares?',
      options: [
        QuizOption(textEn: 'Arctic', textEs: 'Ártico', image: 'assets/images/habitat_arctic.png'),
        QuizOption(textEn: 'Jungle', textEs: 'Selva', image: 'assets/images/habitat_forest.png'),
        QuizOption(textEn: 'Desert', textEs: 'Desierto', image: 'assets/images/habitat_desert.png'),
        QuizOption(textEn: 'Ocean', textEs: 'Océano', image: 'assets/images/habitat_ocean.png'),
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      questionEn: 'Which animal lives in the ocean?',
      questionEs: '¿Qué animal vive en el océano?',
      options: [
        QuizOption(textEn: 'Shark', textEs: 'Tiburón', image: 'assets/images/shark.jpg'),
        QuizOption(textEn: 'Tiger', textEs: 'Tigre', image: 'assets/images/tiger.jpg'),
        QuizOption(textEn: 'Eagle', textEs: 'Águila', image: 'assets/images/eagle.jpg'),
        QuizOption(textEn: 'Zebra', textEs: 'Cebra', image: 'assets/images/zebra.jpg'),
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      questionEn: 'Which habitat has cacti?',
      questionEs: '¿Qué hábitat tiene cactus?',
      options: [
        QuizOption(textEn: 'Rainforest', textEs: 'Selva tropical', image: 'assets/images/habitat_forest.png'),
        QuizOption(textEn: 'Arctic', textEs: 'Ártico', image: 'assets/images/habitat_arctic.png'),
        QuizOption(textEn: 'Desert', textEs: 'Desierto', image: 'assets/images/habitat_desert.png'),
        QuizOption(textEn: 'Ocean', textEs: 'Océano', image: 'assets/images/habitat_ocean.png'),
      ],
      correctIndex: 2,
    ),
  ],
);

// ---------------------------------------------------------------------------
// 3. Life Cycles Quiz — migrated from JungleQuizPage 'Life Cycles' section
// ---------------------------------------------------------------------------
const lifeCyclesQuizConfig = QuizConfig(
  titleEn: 'Life Cycles Quiz',
  titleEs: 'Quiz de Ciclos de Vida',
  questionsPerRound: 3,
  questions: [
    QuizQuestion(
      questionEn: 'What is the first stage of a butterfly life cycle?',
      questionEs: '¿Cuál es la primera etapa del ciclo de vida de una mariposa?',
      options: [
        QuizOption(textEn: 'Egg', textEs: 'Huevo', image: 'assets/images/butterfly_eggs.jpg'),
        QuizOption(textEn: 'Caterpillar', textEs: 'Oruga', image: 'assets/images/caterpillar.jpg'),
        QuizOption(textEn: 'Pupa', textEs: 'Crisálida', image: 'assets/images/chrysalis.jpg'),
        QuizOption(textEn: 'Adult', textEs: 'Adulto', image: 'assets/images/adult_butterfly.jpg'),
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      questionEn: 'What stage comes after the caterpillar?',
      questionEs: '¿Qué etapa viene después de la oruga?',
      options: [
        QuizOption(textEn: 'Egg', textEs: 'Huevo', image: 'assets/images/butterfly_eggs.jpg'),
        QuizOption(textEn: 'Pupa', textEs: 'Crisálida', image: 'assets/images/chrysalis.jpg'),
        QuizOption(textEn: 'Adult', textEs: 'Adulto', image: 'assets/images/adult_butterfly.jpg'),
        QuizOption(textEn: 'None', textEs: 'Ninguno'),
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      questionEn: 'Which stage is when the butterfly emerges?',
      questionEs: '¿En qué etapa emerge la mariposa?',
      options: [
        QuizOption(textEn: 'Egg', textEs: 'Huevo', image: 'assets/images/butterfly_eggs.jpg'),
        QuizOption(textEn: 'Caterpillar', textEs: 'Oruga', image: 'assets/images/caterpillar.jpg'),
        QuizOption(textEn: 'Pupa', textEs: 'Crisálida', image: 'assets/images/chrysalis.jpg'),
        QuizOption(textEn: 'Adult', textEs: 'Adulto', image: 'assets/images/adult_butterfly.jpg'),
      ],
      correctIndex: 3,
    ),
  ],
);

// ---------------------------------------------------------------------------
// 4. Food Chain Quiz — migrated from JungleQuizPage 'Food Chain' section
// ---------------------------------------------------------------------------
const foodChainQuizConfig = QuizConfig(
  titleEn: 'Food Chain Quiz',
  titleEs: 'Quiz de Cadena Alimentaria',
  questionsPerRound: 4,
  questions: [
    QuizQuestion(
      questionEn: 'Which one is a producer in the food chain?',
      questionEs: '¿Cuál es un productor en la cadena alimentaria?',
      options: [
        QuizOption(textEn: 'Grass', textEs: 'Hierba', image: 'assets/images/grass.jpg'),
        QuizOption(textEn: 'Snake', textEs: 'Serpiente', image: 'assets/images/snake.webp'),
        QuizOption(textEn: 'Frog', textEs: 'Rana', image: 'assets/images/frog.png'),
        QuizOption(textEn: 'Lion', textEs: 'León', image: 'assets/images/lion.jpg'),
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      questionEn: 'Who eats the grass in this chain?',
      questionEs: '¿Quién come la hierba en esta cadena?',
      options: [
        QuizOption(textEn: 'Grasshopper', textEs: 'Saltamontes', image: 'assets/images/grasshopper.webp'),
        QuizOption(textEn: 'Frog', textEs: 'Rana', image: 'assets/images/frog.png'),
        QuizOption(textEn: 'Snake', textEs: 'Serpiente', image: 'assets/images/snake.webp'),
        QuizOption(textEn: 'Tiger', textEs: 'Tigre', image: 'assets/images/tiger.jpg'),
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      questionEn: 'Who eats the grasshopper?',
      questionEs: '¿Quién come al saltamontes?',
      options: [
        QuizOption(textEn: 'Snake', textEs: 'Serpiente', image: 'assets/images/snake.webp'),
        QuizOption(textEn: 'Frog', textEs: 'Rana', image: 'assets/images/frog.png'),
        QuizOption(textEn: 'Lion', textEs: 'León', image: 'assets/images/lion.jpg'),
        QuizOption(textEn: 'Bear', textEs: 'Oso', image: 'assets/images/bear.jpg'),
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      questionEn: 'Who eats the frog?',
      questionEs: '¿Quién come a la rana?',
      options: [
        QuizOption(textEn: 'Snake', textEs: 'Serpiente', image: 'assets/images/snake.webp'),
        QuizOption(textEn: 'Tiger', textEs: 'Tigre', image: 'assets/images/tiger.jpg'),
        QuizOption(textEn: 'Eagle', textEs: 'Águila', image: 'assets/images/eagle.jpg'),
        QuizOption(textEn: 'Elephant', textEs: 'Elefante', image: 'assets/images/elephant.jpg'),
      ],
      correctIndex: 0,
    ),
  ],
);

// ---------------------------------------------------------------------------
// 5. Feed Animals Quiz — converted from FeedHungryAnimalGamePage drag-drop
//    "What does X eat?" with 4 food-type options (no images, text only)
// ---------------------------------------------------------------------------
const feedAnimalsQuizConfig = QuizConfig(
  titleEn: 'Feed Animals Quiz',
  titleEs: 'Quiz de Alimentar Animales',
  questionsPerRound: 5,
  questions: [
    // Shark → Fish
    QuizQuestion(
      questionEn: 'What does a Shark eat?',
      questionEs: '¿Qué come un Tiburón?',
      questionImage: 'assets/images/shark.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 2,
    ),
    // Lion → Meat
    QuizQuestion(
      questionEn: 'What does a Lion eat?',
      questionEs: '¿Qué come un León?',
      questionImage: 'assets/images/lion.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 0,
    ),
    // Monkey → Fruits
    QuizQuestion(
      questionEn: 'What does a Monkey eat?',
      questionEs: '¿Qué come un Mono?',
      questionImage: 'assets/images/chimpanzee.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 3,
    ),
    // Penguin → Fish
    QuizQuestion(
      questionEn: 'What does a Penguin eat?',
      questionEs: '¿Qué come un Pingüino?',
      questionImage: 'assets/images/penguin.png',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 2,
    ),
    // Elephant → Grass
    QuizQuestion(
      questionEn: 'What does an Elephant eat?',
      questionEs: '¿Qué come un Elefante?',
      questionImage: 'assets/images/elephant.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 1,
    ),
    // Tiger → Meat
    QuizQuestion(
      questionEn: 'What does a Tiger eat?',
      questionEs: '¿Qué come un Tigre?',
      questionImage: 'assets/images/tiger.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 0,
    ),
    // Dolphin → Fish
    QuizQuestion(
      questionEn: 'What does a Dolphin eat?',
      questionEs: '¿Qué come un Delfín?',
      questionImage: 'assets/images/dolphin.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 2,
    ),
    // Sheep → Grass
    QuizQuestion(
      questionEn: 'What does a Sheep eat?',
      questionEs: '¿Qué come una Oveja?',
      questionImage: 'assets/images/sheep.png',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 1,
    ),
    // Horse → Grass
    QuizQuestion(
      questionEn: 'What does a Horse eat?',
      questionEs: '¿Qué come un Caballo?',
      questionImage: 'assets/images/horse.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 1,
    ),
    // Gorilla → Fruits
    QuizQuestion(
      questionEn: 'What does a Gorilla eat?',
      questionEs: '¿Qué come un Gorila?',
      questionImage: 'assets/images/chimpanzee.jpg',
      options: [
        QuizOption(textEn: '🥩 Meat', textEs: '🥩 Carne'),
        QuizOption(textEn: '🌿 Grass', textEs: '🌿 Hierba'),
        QuizOption(textEn: '🐟 Fish', textEs: '🐟 Pescado'),
        QuizOption(textEn: '🍎 Fruits', textEs: '🍎 Frutas'),
      ],
      correctIndex: 3,
    ),
  ],
);
