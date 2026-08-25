import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';
import 'package:jiyan_learning/services/tts_service.dart';

class SurpriseRewardsPage extends StatefulWidget {
  const SurpriseRewardsPage({super.key});

  @override
  State<SurpriseRewardsPage> createState() => _SurpriseRewardsPageState();
}

class _SurpriseRewardsPageState extends State<SurpriseRewardsPage> with TickerProviderStateMixin {
  final GetStorage _storage = GetStorage();
  late TabController _tabController;

  // Spin Wheel
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  bool isSpinning = false;
  int? wonPrizeIndex;
  int dailySpinsLeft = 3;

  // Mystery Box
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _openController;
  late Animation<double> _openAnimation;
  bool isOpening = false;
  bool boxOpened = false;
  Map<String, dynamic>? mysteryPrize;
  int dailyBoxesLeft = 2;

  // Scratch Card
  int dailyScratchLeft = 1;
  bool scratchRevealed = false;
  Map<String, dynamic>? scratchPrize;

  final List<Map<String, dynamic>> spinPrizes = [
    {'name': '5 Stars', 'emoji': '⭐', 'value': 5, 'type': 'stars', 'color': Color(0xFFFFD93D)},
    {'name': '10 Coins', 'emoji': '🪙', 'value': 10, 'type': 'coins', 'color': Color(0xFFFFAA5A)},
    {'name': '20 XP', 'emoji': '✨', 'value': 20, 'type': 'xp', 'color': Color(0xFFA78BFA)},
    {'name': '15 Stars', 'emoji': '🌟', 'value': 15, 'type': 'stars', 'color': Color(0xFFFFD93D)},
    {'name': '25 Coins', 'emoji': '💰', 'value': 25, 'type': 'coins', 'color': Color(0xFFFFAA5A)},
    {'name': '50 XP', 'emoji': '🎯', 'value': 50, 'type': 'xp', 'color': Color(0xFF4ECDC4)},
    {'name': 'Sticker', 'emoji': '🎨', 'value': 1, 'type': 'sticker', 'color': Color(0xFFFF6B6B)},
    {'name': 'Badge', 'emoji': '🏅', 'value': 1, 'type': 'badge', 'color': Color(0xFF667EEA)},
  ];

  final List<Map<String, dynamic>> mysteryPrizes = [
    {'name': '10 Stars', 'emoji': '⭐', 'rarity': 'common', 'color': Color(0xFFFFD93D)},
    {'name': '20 Coins', 'emoji': '🪙', 'rarity': 'common', 'color': Color(0xFFFFAA5A)},
    {'name': '30 XP', 'emoji': '✨', 'rarity': 'common', 'color': Color(0xFFA78BFA)},
    {'name': '50 Stars', 'emoji': '🌟', 'rarity': 'rare', 'color': Color(0xFFFFD93D)},
    {'name': '100 Coins', 'emoji': '💰', 'rarity': 'rare', 'color': Color(0xFFFFAA5A)},
    {'name': 'Special Sticker', 'emoji': '🦄', 'rarity': 'rare', 'color': Color(0xFFFF6B6B)},
    {'name': 'Trophy', 'emoji': '🏆', 'rarity': 'epic', 'color': Color(0xFF4ECDC4)},
    {'name': 'Secret Badge', 'emoji': '👑', 'rarity': 'legendary', 'color': Color(0xFF667EEA)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDailyLimits();

    // Spin wheel animation
    _spinController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _spinAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeOutCubic),
    );

    // Mystery box shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(_shakeController);

    // Mystery box open animation
    _openController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _openAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _openController, curve: Curves.elasticOut),
    );
  }

  void _loadDailyLimits() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastDate = _storage.read('surprise_last_date') ?? '';

    if (lastDate != today) {
      // Reset daily limits
      _storage.write('surprise_last_date', today);
      _storage.write('daily_spins', 3);
      _storage.write('daily_boxes', 2);
      _storage.write('daily_scratch', 1);
    }

    setState(() {
      dailySpinsLeft = _storage.read('daily_spins') ?? 3;
      dailyBoxesLeft = _storage.read('daily_boxes') ?? 2;
      dailyScratchLeft = _storage.read('daily_scratch') ?? 1;
    });
  }

  void _spinWheel() {
    if (isSpinning || dailySpinsLeft <= 0) return;

    setState(() {
      isSpinning = true;
      wonPrizeIndex = null;
    });

    // Random prize
    final random = Random();
    final prizeIndex = random.nextInt(spinPrizes.length);

    // Calculate rotation (5-8 full rotations + prize position)
    final rotations = 5 + random.nextInt(4);
    final prizeAngle = (prizeIndex / spinPrizes.length) * 2 * pi;
    final totalRotation = rotations * 2 * pi + (2 * pi - prizeAngle);

    _spinAnimation = Tween<double>(begin: 0, end: totalRotation).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeOutCubic),
    );

    _spinController.forward(from: 0).then((_) {
      setState(() {
        isSpinning = false;
        wonPrizeIndex = prizeIndex;
        dailySpinsLeft--;
        _storage.write('daily_spins', dailySpinsLeft);
      });
      _showPrizeDialog(spinPrizes[prizeIndex], 'Spin Wheel');
    });
  }

  void _openMysteryBox() async {
    if (isOpening || dailyBoxesLeft <= 0) return;

    setState(() {
      isOpening = true;
      boxOpened = false;
      mysteryPrize = null;
    });

    // Shake animation
    for (int i = 0; i < 10; i++) {
      await _shakeController.forward();
      await _shakeController.reverse();
    }

    // Random prize with rarity weights
    final random = Random();
    final roll = random.nextDouble();
    String rarity;
    if (roll < 0.5) {
      rarity = 'common';
    } else if (roll < 0.8) {
      rarity = 'rare';
    } else if (roll < 0.95) {
      rarity = 'epic';
    } else {
      rarity = 'legendary';
    }

    final rarityPrizes = mysteryPrizes.where((p) => p['rarity'] == rarity).toList();
    final prize = rarityPrizes[random.nextInt(rarityPrizes.length)];

    setState(() {
      mysteryPrize = prize;
      boxOpened = true;
      dailyBoxesLeft--;
      _storage.write('daily_boxes', dailyBoxesLeft);
    });

    await _openController.forward(from: 0);

    setState(() {
      isOpening = false;
    });

    _showPrizeDialog(prize, 'Mystery Box');
  }

  void _scratchCard() {
    if (dailyScratchLeft <= 0 || scratchRevealed) return;

    final random = Random();
    final prizes = [
      {'name': '100 Stars', 'emoji': '🌟', 'color': Color(0xFFFFD93D)},
      {'name': '200 Coins', 'emoji': '💰', 'color': Color(0xFFFFAA5A)},
      {'name': '500 XP', 'emoji': '🎯', 'color': Color(0xFF4ECDC4)},
      {'name': 'Rare Badge', 'emoji': '🎖️', 'color': Color(0xFF667EEA)},
      {'name': 'Special Avatar', 'emoji': '🦸', 'color': Color(0xFFFF6B6B)},
    ];

    setState(() {
      scratchPrize = prizes[random.nextInt(prizes.length)];
      scratchRevealed = true;
      dailyScratchLeft--;
      _storage.write('daily_scratch', dailyScratchLeft);
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _showPrizeDialog(scratchPrize!, 'Scratch Card');
    });
  }

  void _showPrizeDialog(Map<String, dynamic> prize, String source) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🎉", style: TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            const Text("Congratulations!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("You won from $source:", style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [prize['color'], prize['color'].withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: prize['color'].withValues(alpha: 0.4), blurRadius: 15)],
              ),
              child: Column(
                children: [
                  Text(prize['emoji'], style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 8),
                  Text(prize['name'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  if (prize.containsKey('rarity'))
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(prize['rarity'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [prize['color'], prize['color'].withValues(alpha: 0.7)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Collect!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _spinController.dispose();
    _shakeController.dispose();
    _openController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
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
        title: const Text("Surprise Rewards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: const [
            Tab(text: "Spin", icon: Icon(Icons.casino, size: 20)),
            Tab(text: "Mystery", icon: Icon(Icons.card_giftcard, size: 20)),
            Tab(text: "Scratch", icon: Icon(Icons.style, size: 20)),
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
            _buildSpinWheel(),
            _buildMysteryBox(),
            _buildScratchCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinWheel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("🎡", style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          const Text("Lucky Spin Wheel", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Spin to win amazing rewards!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("$dailySpinsLeft spins left today", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),

          // Spin Wheel
          Stack(
            alignment: Alignment.center,
            children: [
              // Wheel
              AnimatedBuilder(
                animation: _spinAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _spinAnimation.value,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20)],
                      ),
                      child: CustomPaint(
                        painter: WheelPainter(spinPrizes),
                        child: const SizedBox(width: 280, height: 280),
                      ),
                    ),
                  );
                },
              ),
              // Center button
              GestureDetector(
                onTap: dailySpinsLeft > 0 && !isSpinning ? () { TtsService.to.speak('Spin Wheel'); _spinWheel(); } : null,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: dailySpinsLeft > 0
                        ? [const Color(0xFFFF6B6B), const Color(0xFFFFAA5A)]
                        : [Colors.grey, Colors.grey.shade400],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10)],
                  ),
                  child: Center(
                    child: Text(
                      isSpinning ? "..." : "SPIN",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              // Pointer
              Positioned(
                top: 0,
                child: Container(
                  width: 30,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF6B6B), size: 30),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Prizes list
          const Text("🎯 Possible Prizes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: spinPrizes.map((prize) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(prize['emoji'], style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(prize['name'], style: TextStyle(color: prize['color'], fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMysteryBox() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("🎁", style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          const Text("Mystery Box", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Open the box for surprise rewards!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("$dailyBoxesLeft boxes left today", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),

          // Mystery Box
          GestureDetector(
            onTap: dailyBoxesLeft > 0 && !isOpening ? () { TtsService.to.speak('Mystery Box'); _openMysteryBox(); } : null,
            child: AnimatedBuilder(
              animation: Listenable.merge([_shakeAnimation, _openAnimation]),
              builder: (context, child) {
                return Transform.translate(
                  offset: isOpening && !boxOpened ? Offset(_shakeAnimation.value, 0) : Offset.zero,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Box
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: dailyBoxesLeft > 0
                              ? [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)]
                              : [Colors.grey, Colors.grey.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA78BFA).withValues(alpha: 0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!boxOpened) ...[
                              const Text("❓", style: TextStyle(fontSize: 60)),
                              const SizedBox(height: 12),
                              Text(
                                isOpening ? "Opening..." : "Tap to Open!",
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ] else ...[
                              Transform.scale(
                                scale: _openAnimation.value,
                                child: Column(
                                  children: [
                                    Text(mysteryPrize?['emoji'] ?? "🎁", style: const TextStyle(fontSize: 60)),
                                    const SizedBox(height: 8),
                                    Text(
                                      mysteryPrize?['name'] ?? "",
                                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        (mysteryPrize?['rarity'] ?? "").toString().toUpperCase(),
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Sparkles when opened
                      if (boxOpened)
                        ...List.generate(8, (i) {
                          final angle = (i / 8) * 2 * pi;
                          return Positioned(
                            left: 100 + cos(angle) * 120 * _openAnimation.value,
                            top: 100 + sin(angle) * 120 * _openAnimation.value,
                            child: Opacity(
                              opacity: _openAnimation.value,
                              child: const Text("✨", style: TextStyle(fontSize: 24)),
                            ),
                          );
                        }),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          // Rarity info
          const Text("🎲 Rarity Chances", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRarityChip("Common", "50%", Colors.grey),
              _buildRarityChip("Rare", "30%", Colors.blue),
              _buildRarityChip("Epic", "15%", Colors.purple),
              _buildRarityChip("Legendary", "5%", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRarityChip(String name, String chance, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(chance, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildScratchCard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("🎴", style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          const Text("Daily Scratch Card", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Scratch to reveal your prize!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dailyScratchLeft > 0 ? "1 scratch card available!" : "Come back tomorrow!",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),

          // Scratch Card
          GestureDetector(
            onTap: dailyScratchLeft > 0 && !scratchRevealed ? () { TtsService.to.speak('Scratch Card'); _scratchCard(); } : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 280,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: scratchRevealed
                    ? [scratchPrize?['color'] ?? Colors.purple, (scratchPrize?['color'] ?? Colors.purple).withValues(alpha: 0.7)]
                    : dailyScratchLeft > 0
                      ? [const Color(0xFF56D97F), const Color(0xFF11998E)]
                      : [Colors.grey, Colors.grey.shade600],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20)],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background pattern
                  if (!scratchRevealed)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CustomPaint(
                          painter: ScratchPatternPainter(),
                        ),
                      ),
                    ),
                  // Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!scratchRevealed) ...[
                        const Icon(Icons.touch_app, color: Colors.white, size: 50),
                        const SizedBox(height: 12),
                        const Text("TAP TO SCRATCH", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Win big rewards!", style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                      ] else ...[
                        Text(scratchPrize?['emoji'] ?? "🎁", style: const TextStyle(fontSize: 50)),
                        const SizedBox(height: 8),
                        Text(scratchPrize?['name'] ?? "", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("🎉 You Won! 🎉", style: TextStyle(color: Colors.white70)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text("💡 Daily Rewards Info", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildInfoRow("🎡 Spin Wheel", "3 spins per day"),
                _buildInfoRow("🎁 Mystery Box", "2 boxes per day"),
                _buildInfoRow("🎴 Scratch Card", "1 card per day"),
                const SizedBox(height: 8),
                Text("Resets at midnight!", style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

// Custom painter for spin wheel
class WheelPainter extends CustomPainter {
  final List<Map<String, dynamic>> prizes;

  WheelPainter(this.prizes);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = 2 * pi / prizes.length;

    for (int i = 0; i < prizes.length; i++) {
      final startAngle = i * sweepAngle - pi / 2;
      final paint = Paint()
        ..color = prizes[i]['color']
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw border
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Draw emoji
      final textPainter = TextPainter(
        text: TextSpan(text: prizes[i]['emoji'], style: const TextStyle(fontSize: 24)),
        textDirection: TextDirection.ltr,
      )..layout();

      final emojiAngle = startAngle + sweepAngle / 2;
      final emojiRadius = radius * 0.65;
      final emojiOffset = Offset(
        center.dx + cos(emojiAngle) * emojiRadius - textPainter.width / 2,
        center.dy + sin(emojiAngle) * emojiRadius - textPainter.height / 2,
      );

      textPainter.paint(canvas, emojiOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for scratch pattern
class ScratchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width + size.height; i += 15) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
