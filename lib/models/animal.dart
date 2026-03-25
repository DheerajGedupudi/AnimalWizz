class Animal {
  final String name;
  final String nameEs;
  final String image;
  final String description;
  final String descriptionEs;
  final String category; // Memory game filter: Herbivores, Carnivores, Omnivores, Rainforest, Desert, Arctic, Ocean, Forest
  final String? habitat; // Habitat page filter: Desert, Forest, Arctic, Ocean (null if not in a habitat page)
  final String? sound;

  const Animal({
    required this.name,
    required this.nameEs,
    required this.image,
    required this.description,
    required this.descriptionEs,
    required this.category,
    this.habitat,
    this.sound,
  });
}
