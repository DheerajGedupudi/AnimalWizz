// lib/data/animals.dart
// Centralized animal data used by the memory game (and others).
// Add new animals here; reference existing assets in assets/images.

const List<Map<String, String>> kAllAnimals = [
  // Herbivores
  {
    'name': 'Horse',
    'image': 'assets/images/horse.jpg',
    'description': 'Horses can sleep standing up and run fast.',
    'category': 'Herbivores',
  },
  {
    'name': 'Deer',
    'image': 'assets/images/deer.jpg',
    'description': 'Deer are swift herbivores with great hearing.',
    'category': 'Herbivores',
  },
  {
    'name': 'Zebra',
    'image': 'assets/images/zebra.jpg',
    'description': 'Zebras have unique black and white stripes.',
    'category': 'Herbivores',
  },
  {
    'name': 'Elephant',
    'image': 'assets/images/elephant.jpg',
    'description': 'Elephants are intelligent giants with strong trunks.',
    'category': 'Herbivores',
  },

  // Carnivores
  {
    'name': 'Lion',
    'image': 'assets/images/lion.jpg',
    'description': 'Lions live in prides and are powerful hunters.',
    'category': 'Carnivores',
  },
  {
    'name': 'Tiger',
    'image': 'assets/images/tiger.jpg',
    'description': 'Tigers have bold stripes and hunt alone.',
    'category': 'Carnivores',
  },
  {
    'name': 'Cheetah',
    'image': 'assets/images/cheetah.jpg',
    'description': 'Cheetahs are the fastest land animals.',
    'category': 'Carnivores',
  },
  {
    'name': 'Wolf',
    'image': 'assets/images/wolf.jpg',
    'description': 'Wolves hunt in packs and communicate by howling.',
    'category': 'Carnivores',
  },
  {
    'name': 'Fox',
    'image': 'assets/images/fox.jpg',
    'description': 'Foxes are clever hunters with bushy tails.',
    'category': 'Carnivores',
  },

  // Omnivores
  {
    'name': 'Bear',
    'image': 'assets/images/bear.jpg',
    'description': 'Bears eat plants, insects, and fish.',
    'category': 'Omnivores',
  },
  {
    'name': 'Pig',
    'image': 'assets/images/pig.jpg',
    'description': 'Pigs are smart omnivores with a strong sense of smell.',
    'category': 'Omnivores',
  },
  {
    'name': 'Chimpanzee',
    'image': 'assets/images/chimpanzee.jpg',
    'description': 'Chimpanzees use tools and live in social groups.',
    'category': 'Omnivores',
  },

  // Rainforest
  {
    'name': 'Toucan',
    'image': 'assets/images/toucan.jpg',
    'description': 'Toucans have colorful beaks and eat fruit.',
    'category': 'Rainforest',
  },
  {
    'name': 'Jaguar',
    'image': 'assets/images/jaguar.jpg',
    'description': 'Jaguars are strong swimmers and stealthy predators.',
    'category': 'Rainforest',
  },
  {
    'name': 'Sloth',
    'image': 'assets/images/sloth.jpg',
    'description': 'Sloths move slowly and hang from trees.',
    'category': 'Rainforest',
  },
  {
    'name': 'Poison Dart Frog',
    'image': 'assets/images/poison_frog.jpg',
    'description': 'Tiny, brightly colored, and toxic to predators.',
    'category': 'Rainforest',
  },

  // Desert
  {
    'name': 'Camel',
    'image': 'assets/images/camel.jpg',
    'description': 'Camels store fat in their humps for energy.',
    'category': 'Desert',
  },
  {
    'name': 'Fennec Fox',
    'image': 'assets/images/fennec.jpg',
    'description': 'Fennec foxes have large ears to release heat.',
    'category': 'Desert',
  },
  {
    'name': 'Meerkat',
    'image': 'assets/images/meerkat.jpg',
    'description': 'Meerkats stand upright to watch for danger.',
    'category': 'Desert',
  },
  {
    'name': 'Gila Monster',
    'image': 'assets/images/gila_monster.jpg',
    'description': 'A venomous desert lizard that moves slowly.',
    'category': 'Desert',
  },

  // Arctic
  {
    'name': 'Polar Bear',
    'image': 'assets/images/polar_bear.jpg',
    'description': 'Polar bears are strong swimmers on sea ice.',
    'category': 'Arctic',
  },
  {
    'name': 'Arctic Fox',
    'image': 'assets/images/arctic_fox.jpg',
    'description': 'Arctic foxes change fur color with the seasons.',
    'category': 'Arctic',
  },
  {
    'name': 'Walrus',
    'image': 'assets/images/walrus.jpg',
    'description': 'Walruses have long tusks and rest on ice floes.',
    'category': 'Arctic',
  },
  {
    'name': 'Harp Seal',
    'image': 'assets/images/harp_seal.jpg',
    'description': 'Harp seals are agile swimmers with white pups.',
    'category': 'Arctic',
  },
  {
    'name': 'Reindeer',
    'image': 'assets/images/reindeer.jpg',
    'description': 'Reindeer migrate long distances in herds.',
    'category': 'Arctic',
  },
  {
    'name': 'Snowy Owl',
    'image': 'assets/images/snowy_owl.jpg',
    'description': 'Snowy owls have white plumage and keen eyesight.',
    'category': 'Arctic',
  },

  // Ocean
  {
    'name': 'Dolphin',
    'image': 'assets/images/dolphin.jpg',
    'description': 'Dolphins are intelligent and communicate with clicks.',
    'category': 'Ocean',
  },
  {
    'name': 'Shark',
    'image': 'assets/images/shark.jpg',
    'description': 'Sharks are top ocean predators with sharp teeth.',
    'category': 'Ocean',
  },
  {
    'name': 'Octopus',
    'image': 'assets/images/octopus.jpg',
    'description': 'Octopuses are clever and can change color.',
    'category': 'Ocean',
  },
  {
    'name': 'Jellyfish',
    'image': 'assets/images/jellyfish.jpg',
    'description': 'Jellyfish drift and can give a sting.',
    'category': 'Ocean',
  },
  {
    'name': 'Clownfish',
    'image': 'assets/images/clownfish.jpg',
    'description': 'Clownfish live among anemone tentacles.',
    'category': 'Ocean',
  },
  {
    'name': 'Sea Turtle',
    'image': 'assets/images/sea_turtle.jpg',
    'description': 'Sea turtles travel long distances in the ocean.',
    'category': 'Ocean',
  },

  // Forest
  {
    'name': 'Eagle',
    'image': 'assets/images/eagle.jpg',
    'description': 'Eagles soar high and have sharp vision.',
    'category': 'Forest',
  },
  {
    'name': 'Hawk',
    'image': 'assets/images/hawk.png',
    'description': 'Hawks are swift birds of prey.',
    'category': 'Forest',
  },
  {
    'name': 'Woodpecker',
    'image': 'assets/images/woodpecker.jpg',
    'description': 'Woodpeckers drum on trees to find insects.',
    'category': 'Forest',
  },
  {
    'name': 'Squirrel',
    'image': 'assets/images/squirrel.jpg',
    'description': 'Squirrels gather nuts and leap through trees.',
    'category': 'Forest',
  },
];

