import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class TrackingQuizPage extends StatefulWidget {
  const TrackingQuizPage({super.key});

  @override
  State<TrackingQuizPage> createState() => _TrackingQuizPageState();
}

class Animal {
  final String name;
  final String? nameEs;
  final String image;
  final String? sound; // optional asset path under assets/sounds/
  final List<String> clues; // audio clue text, track clue, object/behavior clue
  final List<String>? cluesEs;
  final String fact;
  final String? factEs;

  Animal({
    required this.name,
    this.nameEs,
    required this.image,
    this.sound,
    required this.clues,
    this.cluesEs,
    required this.fact,
    this.factEs,
  });
}

class _TrackingQuizPageState extends State<TrackingQuizPage> {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();
  bool showSpanish = false;

  int _step = 0; // 0: home, 1: habitat select, 2: clues, 3: guess, 4: result
  String? _selectedHabitat;
  late Map<String, List<Animal>> _animalsByHabitat;
  late Animal _currentAnimal;
  List<Animal> _currentOptions = [];
  String? _selectedOption;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _buildDataset();
  }

  void _buildDataset() {
    // Minimal dataset using existing assets in the project. Add more animals if desired.
    _animalsByHabitat = {
      'Forest': [
        Animal(
          name: 'Fox',
          nameEs: 'Zorro',
          image: 'assets/images/fox.jpg',
          sound: null,
          clues: [
            'I am a nocturnal hunter with a bushy tail.',
            'Small paw prints with claw marks.',
            'I often eat small mammals and berries.',
          ],
          cluesEs: [
            'Soy un cazador nocturno con una cola espesa.',
            'Pequeñas huellas de patas con marcas de garras.',
            'A menudo como pequeños mamíferos y bayas.',
          ],
          fact: 'Foxes are omnivores and use their keen sense of hearing to locate prey under the snow.',
          factEs: 'Los zorros son omnívoros y usan su agudo sentido del oído para localizar presas bajo la nieve.',
        ),
        Animal(
          name: 'Owl',
          nameEs: 'Búho',
          image: 'assets/images/owl.jpg',
          sound: null,
          clues: [
            'I rotate my head and hunt at night.',
            'Tiny talon marks and wing impressions nearby.',
            'I hoot and I can see very well in the dark.',
          ],
          cluesEs: [
            'Giro mi cabeza y cazo de noche.',
            'Pequeñas marcas de garras y impresiones de alas cerca.',
            'Ululo y puedo ver muy bien en la oscuridad.',
          ],
          fact: 'Owls have asymmetrical ears to help locate prey precisely by sound.',
          factEs: 'Los búhos tienen oídos asimétricos para ayudar a localizar presas con precisión por el sonido.',
        ),
        Animal(
          name: 'Deer',
          nameEs: 'Ciervo',
          image: 'assets/images/deer.jpg',
          sound: null,
          clues: [
            'I graze on plants and can run fast.',
            'Hoof prints in pairs, two rounded halves.',
            'Often seen in herds near clearings.',
          ],
          cluesEs: [
            'Pasto plantas y puedo correr rápido.',
            'Huellas de pezuña en pares, dos mitades redondeadas.',
            'A menudo visto en manadas cerca de claros.',
          ],
          fact: 'Deer are herbivores and have a four-chambered stomach to help digest tough plants.',
          factEs: 'Los ciervos son herbívoros y tienen un estómago de cuatro cámaras para ayudar a digerir plantas duras.',
        ),
      ],

      'Desert': [
        Animal(
          name: 'Camel',
          nameEs: 'Camello',
          image: 'assets/images/camel.jpg',
          sound: null,
          clues: [
            'I can go long without water and have humps.',
            'Large, wide foot pads in the sand.',
            'I carry people and store fat in my humps.',
          ],
          cluesEs: [
            'Puedo pasar mucho tiempo sin agua y tengo jorobas.',
            'Grandes almohadillas de pies anchas en la arena.',
            'Llevo personas y almaceno grasa en mis jorobas.',
          ],
          fact: 'Camels store fat in their humps which helps them survive long periods without food.',
          factEs: 'Los camellos almacenan grasa en sus jorobas lo que les ayuda a sobrevivir largos periodos sin comida.',
        ),
        Animal(
          name: 'Fennec Fox',
          nameEs: 'Zorro Fennec',
          image: 'assets/images/fennec.jpg',
          sound: null,
          clues: [
            'I have very large ears to cool myself.',
            'Small paw prints with light padding.',
            'I hunt insects and live in burrows.',
          ],
          cluesEs: [
            'Tengo orejas muy grandes para enfriarme.',
            'Pequeñas huellas con almohadillado ligero.',
            'Cazo insectos y vivo en madrigueras.',
          ],
          fact: 'Fennec foxes are the smallest fox species and use their big ears for thermoregulation.',
          factEs: 'Los zorros fennec son la especie de zorro más pequeña y usan sus grandes orejas para termorregularse.',
        ),
        Animal(
          name: 'Meerkat',
          nameEs: 'Suricata',
          image: 'assets/images/meerkat.jpg',
          sound: null,
          clues: [
            'I stand on hind legs and look out for danger.',
            'Tiny clawed footprints and dig marks near burrows.',
            'I live in groups called mobs or gangs.',
          ],
          cluesEs: [
            'Me pongo de pie sobre las patas traseras y vigilo el peligro.',
            'Pequeñas huellas con garras y marcas de excavación cerca de madrigueras.',
            'Vivo en grupos llamados mobs o bandas.',
          ],
          fact: 'Meerkats are highly social and cooperatively care for pups and watch for predators.',
          factEs: 'Las suricatas son muy sociales y cuidan cooperativamente a las crías y vigilan a los depredadores.',
        ),
      ],

      'Ocean': [
        Animal(
          name: 'Dolphin',
          nameEs: 'Delfín',
          image: 'assets/images/dolphin.jpg',
          sound: null,
          clues: [
            'I am highly social and use echolocation.',
            'Curved skid marks in sand near the shore (dorsal fin traces).',
            'I leap from the water and ride waves.',
          ],
          cluesEs: [
            'Soy muy social y uso la ecolocación.',
            'Marcas curvas en la arena cerca de la orilla (huellas de la aleta dorsal).',
            'Salto fuera del agua y cabalgo las olas.',
          ],
          fact: 'Dolphins are intelligent marine mammals known for complex social behavior and communication.',
          factEs: 'Los delfines son mamíferos marinos inteligentes conocidos por su comportamiento social y comunicación compleja.',
        ),
        Animal(
          name: 'Sea Turtle',
          nameEs: 'Tortuga Marina',
          image: 'assets/images/sea_turtle.jpg',
          sound: null,
          clues: [
            'I return to beaches where I was born to lay eggs.',
            'Large flipper tracks leading to the sand.',
            'I have a hard shell and eat sea grasses or jellyfish.',
          ],
          cluesEs: [
            'Vuelvo a las playas donde nací para poner huevos.',
            'Grandes huellas de aletas que conducen a la arena.',
            'Tengo un caparazón duro y como pastos marinos o medusas.',
          ],
          fact: 'Sea turtles migrate long distances between feeding grounds and nesting beaches.',
          factEs: 'Las tortugas marinas migran largas distancias entre áreas de alimentación y playas de anidación.',
        ),
        Animal(
          name: 'Octopus',
          nameEs: 'Pulpo',
          image: 'assets/images/octopus.jpg',
          sound: null,
          clues: [
            'I can change color and squeeze through tiny holes.',
            'Suction-cup trails or ink stains near a crevice.',
            'I use my arms to open shells and hide in rocks.',
          ],
          cluesEs: [
            'Puedo cambiar de color y apretar por agujeros pequeños.',
            'Rastros de ventosas o manchas de tinta cerca de una grieta.',
            'Uso mis brazos para abrir conchas y esconderme en las rocas.',
          ],
          fact: 'Octopuses are cephalopods with remarkable problem-solving skills and three hearts.',
          factEs: 'Los pulpos son cefalópodos con notables habilidades para resolver problemas y tres corazones.',
        ),
      ],

      'Arctic': [
        Animal(
          name: 'Polar Bear',
          nameEs: 'Oso Polar',
          image: 'assets/images/polar_bear.jpg',
          sound: null,
          clues: [
            'I have thick white fur and hunt on the ice.',
            'Large paw prints with webbed toes in the snow.',
            'I primarily eat seals and can swim long distances.',
          ],
          cluesEs: [
            'Tengo un grueso pelaje blanco y cazo sobre el hielo.',
            'Grandes huellas de patas con dedos palmeados en la nieve.',
            'Principalmente como focas y puedo nadar largas distancias.',
          ],
          fact: 'Polar bears rely on sea ice to hunt seals; loss of ice threatens their survival.',
          factEs: 'Los osos polares dependen del hielo marino para cazar focas; la pérdida de hielo amenaza su supervivencia.',
        ),
        Animal(
          name: 'Penguin',
          nameEs: 'Pingüino',
          image: 'assets/images/penguin.png',
          sound: null,
          clues: [
            'I waddle and cannot fly but swim very well.',
            'Small short tracks with a sliding pattern on ice.',
            'I often form large colonies and feed on fish.',
          ],
          cluesEs: [
            'Camino tambaleándome y no puedo volar pero nado muy bien.',
            'Pequeñas huellas cortas con un patrón de deslizamiento sobre el hielo.',
            'A menudo formo grandes colonias y me alimento de peces.',
          ],
          fact: 'Penguins are flightless birds adapted to life in the water with flipper-like wings.',
          factEs: 'Los pingüinos son aves incapaces de volar adaptadas a la vida en el agua con alas en forma de aletas.',
        ),
        Animal(
          name: 'Harp Seal',
          nameEs: 'Foca Arpa',
          image: 'assets/images/harp_seal.jpg',
          sound: null,
          clues: [
            'I am a marine mammal with spotted fur and whiskers.',
            'Small rounded flipper marks on ice and wet sand.',
            'I rest on ice floes and feed on fish.',
          ],
          cluesEs: [
            'Soy un mamífero marino con pelaje manchado y bigotes.',
            'Pequeñas marcas redondeadas de aletas en hielo y arena mojada.',
            'Descanso en témpanos de hielo y me alimento de peces.',
          ],
          fact: 'Harp seals have a thick blubber layer to keep warm in cold Arctic waters.',
          factEs: 'Las focas arpa tienen una gruesa capa de grasa para mantenerse calientes en las frías aguas árticas.',
        ),
      ],
    };
  }

  void _startGame() {
    setState(() {
      _step = 1; // go to habitat select
      _selectedHabitat = null;
    });
  }

  void _selectHabitat(String habitat) {
    setState(() {
      _selectedHabitat = habitat;
      _pickNewAnimalForHabitat(habitat);
      _step = 2; // clues
      _selectedOption = null;
      _isCorrect = false;
    });
  }

  void _pickNewAnimalForHabitat(String habitat) {
    final list = _animalsByHabitat[habitat]!;
    _currentAnimal = list[_random.nextInt(list.length)];
    // build options: correct + 2 random others (from same habitat if possible, else global)
    final options = <Animal>[...list.where((a) => a.name != _currentAnimal.name)];
    options.shuffle(_random);
    final chosen = <Animal>[_currentAnimal];
    for (var i = 0; i < min(2, options.length); i++) chosen.add(options[i]);
    // if only two options so far, add a random from other habitats
    if (chosen.length < 3) {
      final other = _animalsByHabitat.values.expand((v) => v).where((a) => a.name != _currentAnimal.name).toList();
      other.shuffle(_random);
      if (other.isNotEmpty) chosen.add(other.first);
    }
    chosen.shuffle(_random);
    _currentOptions = chosen;
  }

  Future<void> _playAudioClue() async {
    final clue = showSpanish ? (_currentAnimal.cluesEs?.first ?? _currentAnimal.clues.first) : _currentAnimal.clues.first;
    await _tts.stop();
    try {
      await _tts.setLanguage(showSpanish ? 'es-ES' : 'en-US');
    } catch (_) {}
    await _tts.speak(clue);
  }

  Future<void> _playAnimalSound() async {
    final speakName = showSpanish ? (_currentAnimal.nameEs ?? _currentAnimal.name) : _currentAnimal.name;
    if (_currentAnimal.sound != null) {
      try {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(_currentAnimal.sound!));
      } catch (e) {
        // fallback to TTS name
        try {
          await _tts.setLanguage(showSpanish ? 'es-ES' : 'en-US');
        } catch (_) {}
        await _tts.speak(speakName);
      }
    } else {
      try {
        await _tts.setLanguage(showSpanish ? 'es-ES' : 'en-US');
      } catch (_) {}
      await _tts.speak(speakName);
    }
  }

  void _submitGuess(Animal option) {
    if (_selectedOption != null) return; // already answered
    setState(() {
      _selectedOption = option.name;
      _isCorrect = option.name == _currentAnimal.name;
    });
  }

  void _goToGuess() {
    setState(() => _step = 3);
  }

  void _goToResult() {
    setState(() => _step = 4);
  }

  void _nextLevel() {
    // pick next habitat (rotate) and pick new animal
    final habitats = _animalsByHabitat.keys.toList();
    final currentIndex = _selectedHabitat == null ? -1 : habitats.indexOf(_selectedHabitat!);
    final nextIndex = (currentIndex + 1) % habitats.length;
    final nextHabitat = habitats[nextIndex];
    setState(() {
      _selectedHabitat = nextHabitat;
      _pickNewAnimalForHabitat(nextHabitat);
      _step = 2; // show clues for new animal
      _selectedOption = null;
      _isCorrect = false;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showSpanish ? 'Rastreo' : 'Tracking Quiz'),
        backgroundColor: Colors.green.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text('EN', style: TextStyle(fontWeight: FontWeight.w600)),
                Switch(
                  value: showSpanish,
                  onChanged: (v) => setState(() => showSpanish = v),
                  activeColor: Colors.white,
                ),
                const Text('ES', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
              ],
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/quiz_background.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildStep(context),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildHome();
      case 1:
        return _buildHabitatSelect();
      case 2:
        return _buildClues();
      case 3:
        return _buildGuess();
      case 4:
        return _buildResult();
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  Widget _buildHome() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(showSpanish ? '¡Comenzar a rastrear!' : 'Start Tracking!', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _startGame,
            icon: const Icon(Icons.explore),
            label: Padding(padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0), child: Text(showSpanish ? 'Comenzar' : 'Start Tracking', style: const TextStyle(fontSize: 18))),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitatSelect() {
    final habitats = _animalsByHabitat.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Text(showSpanish ? 'Selecciona un hábitat' : 'Select a Habitat', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: habitats.map((h) {
              final icon = _habitatIcon(h);
              return GestureDetector(
                onTap: () => _selectHabitat(h),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(icon, size: 56, color: Colors.green.shade700),
                    const SizedBox(height: 12),
                    Text(h, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _habitatIcon(String h) {
    switch (h) {
      case 'Forest':
        return Icons.park;
      case 'Desert':
        return Icons.terrain;
      case 'Ocean':
        return Icons.water;
      case 'Arctic':
        return Icons.ac_unit;
      default:
        return Icons.public;
    }
  }

  Widget _buildClues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Text(showSpanish ? 'Hábitat: ${_selectedHabitat ?? "Desconocido"}' : 'Habitat: ${_selectedHabitat ?? "Unknown"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
  Text(showSpanish ? 'Pista 1 (Audio):' : 'Clue 1 (Audio):', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [
          ElevatedButton.icon(
            onPressed: _playAudioClue,
            icon: const Icon(Icons.volume_up),
            label: Text(showSpanish ? 'Reproducir pista' : 'Play Audio Clue'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(_currentAnimal.clues[0], style: const TextStyle(fontSize: 16))),
        ]),
        const SizedBox(height: 16),
  Text(showSpanish ? 'Pista 2 (Huella):' : 'Clue 2 (Track):', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.pets, size: 40, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(child: Text(_currentAnimal.clues[1], style: const TextStyle(fontSize: 16))),
          ]),
        ),
        const SizedBox(height: 16),
  Text(showSpanish ? 'Pista 3 (Objeto / Comportamiento):' : 'Clue 3 (Object / Behavior):', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const Icon(Icons.visibility, size: 40, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(child: Text(_currentAnimal.clues[2], style: const TextStyle(fontSize: 16))),
          ]),
        ),
        const Spacer(),
        Row(children: [
          ElevatedButton(
            onPressed: () => setState(() => _step = 1),
            child: Text(showSpanish ? 'Atrás' : 'Back'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _goToGuess,
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 12.0), child: Text(showSpanish ? 'Hacer una suposición' : 'Make a Guess')),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
            ),
          ),
        ])
      ],
    );
  }

  Widget _buildGuess() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  Text(showSpanish ? 'Adivina el animal' : 'Guess the Animal', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
  Text(showSpanish ? 'Hábitat: ${_selectedHabitat ?? ""}' : 'Habitat: ${_selectedHabitat ?? ""}', style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
      Expanded(
        child: ListView.separated(
          itemCount: _currentOptions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, idx) {
            final option = _currentOptions[idx];
            final selected = _selectedOption == option.name;
            Color? color;
            if (_selectedOption != null) {
              if (option.name == _currentAnimal.name) color = Colors.green.shade300;
              else if (selected) color = Colors.red.shade200;
              else color = Colors.grey.shade200;
            }
            return Container(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: SizedBox(width: 56, child: Image.asset(option.image, fit: BoxFit.cover)),
                title: Text(showSpanish ? (option.nameEs ?? option.name) : option.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                onTap: () => _submitGuess(option),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Row(children: [
  ElevatedButton(onPressed: () => setState(() => _step = 2), child: Text(showSpanish ? 'Atrás' : 'Back'), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600)),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedOption == null ? null : _goToResult,
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 12.0), child: Text(showSpanish ? 'Ver resultado' : 'See Result')),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
          ),
        ),
      ])
    ]);
  }

  Widget _buildResult() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
  Text(showSpanish ? 'Resultado' : 'Result', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text(_isCorrect ? (showSpanish ? '¡Correcto! 🎉' : 'Correct! 🎉') : (showSpanish ? 'No exactamente' : 'Not quite'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text((showSpanish ? 'Animal correcto: ' : 'Correct Animal: ') + (showSpanish ? (_currentAnimal.nameEs ?? _currentAnimal.name) : _currentAnimal.name), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(height: 180, child: Image.asset(_currentAnimal.image, fit: BoxFit.contain)),
            const SizedBox(height: 12),
            Text(showSpanish ? (_currentAnimal.factEs ?? _currentAnimal.fact) : _currentAnimal.fact, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: _playAnimalSound, icon: const Icon(Icons.volume_up), label: Text(showSpanish ? 'Reproducir sonido / Nombre' : 'Play Sound / Name')),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      Row(children: [
  ElevatedButton(onPressed: () => setState(() => _step = 3), child: Text(showSpanish ? 'Atrás' : 'Back'), style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade600)),
        const SizedBox(width: 12),
  Expanded(child: ElevatedButton(onPressed: _nextLevel, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12.0), child: Text(showSpanish ? 'Siguiente nivel' : 'Next Level')), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700))),
      ])
    ]);
  }
}
