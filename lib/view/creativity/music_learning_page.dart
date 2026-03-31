import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:jiyan_learning/services/progress_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';
import 'package:jiyan_learning/services/tts_service.dart';

class MusicLearningPage extends StatefulWidget {
  const MusicLearningPage({super.key});

  @override
  State<MusicLearningPage> createState() => _MusicLearningPageState();
}

class _MusicLearningPageState extends State<MusicLearningPage> with TickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  late TabController _tabController;
  int selectedInstrument = -1;

  final List<Map<String, dynamic>> instruments = [
    {'name': 'Piano', 'emoji': '🎹', 'sound': 'A keyboard instrument', 'color': Color(0xFF667EEA)},
    {'name': 'Guitar', 'emoji': '🎸', 'sound': 'A string instrument', 'color': Color(0xFFFF6B6B)},
    {'name': 'Drums', 'emoji': '🥁', 'sound': 'A percussion instrument', 'color': Color(0xFFFFAA5A)},
    {'name': 'Violin', 'emoji': '🎻', 'sound': 'A bowed string instrument', 'color': Color(0xFF4ECDC4)},
    {'name': 'Flute', 'emoji': '🪈', 'sound': 'A wind instrument', 'color': Color(0xFF56D97F)},
    {'name': 'Trumpet', 'emoji': '🎺', 'sound': 'A brass instrument', 'color': Color(0xFFA78BFA)},
    {'name': 'Saxophone', 'emoji': '🎷', 'sound': 'A woodwind instrument', 'color': Color(0xFFFF8E53)},
    {'name': 'Xylophone', 'emoji': '🎵', 'sound': 'A percussion instrument with bars', 'color': Color(0xFF00CED1)},
  ];

  final List<Map<String, dynamic>> musicNotes = [
    {'note': 'Do', 'symbol': '🎵', 'color': Color(0xFFFF6B6B), 'frequency': 'C'},
    {'note': 'Re', 'symbol': '🎵', 'color': Color(0xFFFFAA5A), 'frequency': 'D'},
    {'note': 'Mi', 'symbol': '🎵', 'color': Color(0xFFFFD93D), 'frequency': 'E'},
    {'note': 'Fa', 'symbol': '🎵', 'color': Color(0xFF56D97F), 'frequency': 'F'},
    {'note': 'Sol', 'symbol': '🎵', 'color': Color(0xFF4ECDC4), 'frequency': 'G'},
    {'note': 'La', 'symbol': '🎵', 'color': Color(0xFF667EEA), 'frequency': 'A'},
    {'note': 'Si', 'symbol': '🎵', 'color': Color(0xFFA78BFA), 'frequency': 'B'},
    {'note': 'Do\'', 'symbol': '🎵', 'color': Color(0xFFFF6B6B), 'frequency': 'C2'},
  ];

  final List<Map<String, dynamic>> musicFacts = [
    {'emoji': '🎵', 'fact': 'Music has 7 main notes: Do Re Mi Fa Sol La Si'},
    {'emoji': '🎹', 'fact': 'Piano has 88 keys - 52 white and 36 black'},
    {'emoji': '🎸', 'fact': 'Guitar usually has 6 strings'},
    {'emoji': '🥁', 'fact': 'Drums are one of the oldest instruments'},
    {'emoji': '🎻', 'fact': 'Violin is played with a bow'},
    {'emoji': '🎺', 'fact': 'Trumpet is made of brass metal'},
    {'emoji': '🎤', 'fact': 'Your voice is also a musical instrument!'},
    {'emoji': '🎧', 'fact': 'Music can make you happy or calm'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.4);
  }

  void _speakText(String text) {
    flutterTts.speak(text);
  }

  void _playNote(String note) {
    flutterTts.speak(note);
  }

  void _resetProgress() {
    ProgressService.to.resetProgress(ProgressService.kMusicNotes);
    ProgressService.to.resetProgress(ProgressService.kMusicInstruments);
    ProgressService.to.resetProgress(ProgressService.kMusicFacts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        elevation: 8,
        title: const Text(
          "Music Learning",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.refresh, color: Colors.white, size: 20),
            ),
            onPressed: _resetProgress,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Notes"),
            Tab(text: "Instruments"),
            Tab(text: "Facts"),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB), Color(0xFFF5576C)],
            stops: [0.0, 0.3, 0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNotesTab(),
            _buildInstrumentsTab(),
            _buildFactsTab(),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }

  Widget _buildProgressBar(String progressKey) {
    return Obx(() {
      final progress = ProgressService.to.getProgressPercentage(progressKey) / 100;
      final progressString = ProgressService.to.getProgressString(progressKey);
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                ),
                Text(
                  '$progressString completed',
                  style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kMusicNotes),
        Expanded(
          child: Obx(() {
            // Access observable to trigger rebuild
            final _ = ProgressService.to.completedItems[ProgressService.kMusicNotes];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: musicNotes.length,
              itemBuilder: (context, index) {
                final note = musicNotes[index];
                final Color noteColor = note['color'];
                final isCompleted = ProgressService.to.isItemCompleted(ProgressService.kMusicNotes, index);

                return GestureDetector(
                  onTap: () {
                    TtsService.to.speak(note['note']);
                    _playNote(note['note']);
                    ProgressService.to.markItemCompleted(ProgressService.kMusicNotes, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [noteColor, noteColor.withValues(alpha: 0.7)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: note['color'].withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(note['symbol'], style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note['note'],
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Note: ${note['frequency']}',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          )
                        else
                          const Icon(Icons.volume_up, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInstrumentsTab() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kMusicInstruments),
        Expanded(
          child: Obx(() {
            // Access observable to trigger rebuild
            final _ = ProgressService.to.completedItems[ProgressService.kMusicInstruments];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: instruments.length,
              itemBuilder: (context, index) {
                final instrument = instruments[index];
                final Color instrumentColor = instrument['color'];
                final isCompleted = ProgressService.to.isItemCompleted(ProgressService.kMusicInstruments, index);

                return GestureDetector(
                  onTap: () {
                    TtsService.to.speak(instrument['name']);
                    _speakText("${instrument['name']}. ${instrument['sound']}");
                    ProgressService.to.markItemCompleted(ProgressService.kMusicInstruments, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [instrumentColor, instrumentColor.withValues(alpha: 0.7)]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: instrumentColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(instrument['emoji'], style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                instrument['name'],
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                instrument['sound'],
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          )
                        else
                          const Icon(Icons.volume_up, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFactsTab() {
    return Column(
      children: [
        _buildProgressBar(ProgressService.kMusicFacts),
        Expanded(
          child: Obx(() {
            // Access observable to trigger rebuild
            final _ = ProgressService.to.completedItems[ProgressService.kMusicFacts];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: musicFacts.length,
              itemBuilder: (context, index) {
                final fact = musicFacts[index];
                final colors = [
                  [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
                  [Color(0xFF667EEA), Color(0xFF764BA2)],
                  [Color(0xFFFFAA5A), Color(0xFFFFCB80)],
                  [Color(0xFF56D97F), Color(0xFF11998E)],
                  [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
                ];
                final gradient = colors[index % colors.length];
                final isCompleted = ProgressService.to.isItemCompleted(ProgressService.kMusicFacts, index);

                return GestureDetector(
                  onTap: () {
                    TtsService.to.speak(fact['fact']);
                    _speakText(fact['fact']);
                    ProgressService.to.markItemCompleted(ProgressService.kMusicFacts, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(fact['emoji'], style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            fact['fact'],
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          )
                        else
                          const Icon(Icons.volume_up, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
