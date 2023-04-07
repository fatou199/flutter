import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

class Materiel extends StatefulWidget {
  const Materiel({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<Materiel> createState() => _MaterielState();
}

class _MaterielState extends State<Materiel> {
  final List<bool> _selectedMateriel = <bool>[true, false, false];
  bool vertical = false;
  int _selectedCardIndex = -1;

  // partie video
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  // partie audio
  final audioPlayer = audio.AudioPlayer();
  // indique si la lecture est en cours ou non
  bool isPlaying = false;
  // durée totale de la piste audio en cours de lecture.
  Duration duration = Duration.zero;
  // position actuelle de la lecture dans la piste audio.
  Duration position = Duration.zero;

  // liste d'element dans le togglebutton
  List<Widget> crocheton = <Widget>[
    const Text('Crochet'),
    const Text('Fil'),
    const Text('Marqueur')
  ];

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('video/video-crochet.mp4');
    _controller.addListener(() {
      if (!_controller.value.isPlaying && _isPlaying) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    _controller.initialize().then((_) {
      setState(() {});
    });

    // lire les states: play, pause, stop
    // est déclenché chaque fois que l'état du lecteur audio change
    audioPlayer.onPlayerStateChanged.listen((audio.PlayerState state) {
      setState(() {
        isPlaying = state == audio.PlayerState.PLAYING;
      });
    });

    // est déclenché chaque fois que la durée de la piste audio change
    audioPlayer.onDurationChanged.listen((Duration newDuration) {
      setState(() => duration = newDuration);
    });

    // est déclenché périodiquement (environ toutes les 100 millisecondes)
    // pour signaler la position actuelle de lecture de la piste audio
    audioPlayer.onAudioPositionChanged.listen((Duration newPosition) {
      setState(() => position = newPosition);
    });
  }

  // permet de libérer les ressources utilisées par l'objet
  // ex: _controller.dispose();
  // libère les ressources du _controller utilisé pour lire la vidéo
  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

// permet de mettre en pause ou de relancer la lecture de la vidéo.
  void _togglePlaying() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  // renvoie une chaîne de caractères sous la forme "minutes:secondes"
  // pour représenter la durée en minutes et secondes.
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Faîtes votre choix pour en savoir plus:',
            ),
            const SizedBox(height: 40),
            ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedMateriel.length; i++) {
                    _selectedMateriel[i] = i == index;
                    _selectedCardIndex = index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.green[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.green[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedMateriel,
              children: crocheton,
            ),
            Visibility(
              visible: _selectedCardIndex == 0,
              child: Expanded(
                child: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: _togglePlaying,
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  body: GFCard(
                      titlePosition: GFPosition.start,
                      title: const GFListTile(
                        titleText: 'Apprendre le crochet ',
                      ),
                      content: SizedBox(
                        height: 500, // Hauteur fixe de 200 pixels
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(
                            _controller,
                          ),
                        ),
                      )),
                ),
              ),
            ),
            Visibility(
              visible: _selectedCardIndex == 1,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/fil.jpg',
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 23),
                  const Text(
                    'Podcats',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Flutter crocheton',
                    style: TextStyle(fontSize: 20),
                  ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds
                        .toDouble()
                        .clamp(0.0, duration.inSeconds.toDouble()),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      if (position <= duration) {
                        await audioPlayer.seek(position);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration - position))
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 50,
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          String url = 'assets/audio/podcast_crochet.mp3';
                          await audioPlayer.play(url);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: _selectedCardIndex == 2,
              child: GFCard(
                boxFit: BoxFit.cover,
                titlePosition: GFPosition.start,
                image: Image.asset(
                  'assets/marqueur.jpg',
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                ),
                showImage: true,
                title: const GFListTile(
                  titleText: 'Les Marqueurs',
                ),
                content: Column(
                  children: const [
                    Text(
                      "Les marqueurs crochet sont utilisés dans le tricot et le crochet pour marquer l'emplacement d'un point important dans un motif ou pour marquer le début ou la fin d'une rangée. Ils peuvent être placés sur l'aiguille de tricot ou sur les mailles elles-mêmes.",
                    ),
                    SizedBox(height: 10),
                    Text(
                      'L\'utilisation de marqueurs crochet peut aider les tricoteurs et les crocheteurs à suivre les motifs de manière plus précise et à éviter les erreurs. Par exemple, dans un motif de dentelle complexe, un marqueur crochet peut être utilisé pour marquer l\'endroit où commence un motif répété, de sorte que le tricoteur puisse facilement repérer l\'endroit où il doit insérer des augmentations ou des diminutions.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
