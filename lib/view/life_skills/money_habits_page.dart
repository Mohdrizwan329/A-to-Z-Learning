import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MoneyHabitsPage extends StatefulWidget {
  const MoneyHabitsPage({super.key});

  @override
  State<MoneyHabitsPage> createState() => _MoneyHabitsPageState();
}

class _MoneyHabitsPageState extends State<MoneyHabitsPage> {
  int currentSection = 0;

  final List<Map<String, dynamic>> sections = [
    {
      'title': 'What is Money?',
      'emoji': '💰',
      'color': Color(0xFF4CAF50),
      'intro': 'Money is what we use to buy things we need and want!',
      'types': [
        {'type': 'Coins', 'emoji': '🪙', 'examples': '1₹, 2₹, 5₹, 10₹'},
        {'type': 'Notes', 'emoji': '💵', 'examples': '10₹, 20₹, 50₹, 100₹, 500₹'},
        {'type': 'Digital Money', 'emoji': '📱', 'examples': 'UPI, Cards'},
      ],
      'funFact': 'Long ago, people traded things like shells, beads, and animals instead of money!',
    },
    {
      'title': 'Needs vs Wants',
      'emoji': '🤔',
      'color': Color(0xFF2196F3),
      'intro': 'Understanding the difference helps you spend wisely!',
      'needs': [
        {'item': 'Food', 'emoji': '🍎', 'why': 'We need food to stay alive and healthy'},
        {'item': 'Clothes', 'emoji': '👕', 'why': 'We need clothes to stay warm'},
        {'item': 'Home', 'emoji': '🏠', 'why': 'We need shelter to be safe'},
        {'item': 'School', 'emoji': '📚', 'why': 'We need education to learn'},
        {'item': 'Medicine', 'emoji': '💊', 'why': 'We need medicine when sick'},
      ],
      'wants': [
        {'item': 'Toys', 'emoji': '🧸', 'why': 'Nice to have, but not essential'},
        {'item': 'Video Games', 'emoji': '🎮', 'why': 'Fun, but we can live without'},
        {'item': 'Candy', 'emoji': '🍬', 'why': 'Tasty, but not necessary'},
        {'item': 'Latest Phone', 'emoji': '📱', 'why': 'Older phone works too'},
      ],
      'tip': 'Always make sure needs are met before buying wants!',
    },
    {
      'title': 'Saving Money',
      'emoji': '🐷',
      'color': Color(0xFFE91E63),
      'intro': 'Saving helps you buy bigger things later!',
      'whySave': [
        {'reason': 'For something special you want', 'emoji': '⭐'},
        {'reason': 'For emergencies', 'emoji': '🚨'},
        {'reason': 'To help others', 'emoji': '🤝'},
        {'reason': 'For your future', 'emoji': '🔮'},
      ],
      'howToSave': [
        {'tip': 'Use a piggy bank', 'emoji': '🐷'},
        {'tip': 'Save a little from pocket money', 'emoji': '💵'},
        {'tip': 'Set a savings goal', 'emoji': '🎯'},
        {'tip': 'Don\'t buy things you don\'t need', 'emoji': '🛑'},
        {'tip': 'Count your savings weekly', 'emoji': '🔢'},
      ],
      'savingsGoal': {
        'example': 'Want a ₹500 toy? Save ₹50 per week = 10 weeks!',
        'emoji': '📅',
      },
    },
    {
      'title': 'Earning Money',
      'emoji': '💪',
      'color': Color(0xFFFF9800),
      'intro': 'Money doesn\'t grow on trees! Here\'s how it\'s earned:',
      'howParentsEarn': [
        {'job': 'Go to work', 'emoji': '💼'},
        {'job': 'Run a business', 'emoji': '🏪'},
        {'job': 'Provide services', 'emoji': '🔧'},
        {'job': 'Sell things', 'emoji': '🛍️'},
      ],
      'howKidsCanEarn': [
        {'task': 'Do extra chores', 'emoji': '🧹'},
        {'task': 'Help with garden work', 'emoji': '🌱'},
        {'task': 'Wash the car', 'emoji': '🚗'},
        {'task': 'Walk neighbor\'s dog', 'emoji': '🐕'},
        {'task': 'Sell lemonade', 'emoji': '🍋'},
        {'task': 'Help with small tasks', 'emoji': '✋'},
      ],
      'important': 'Working hard and being responsible earns money!',
    },
    {
      'title': 'Spending Wisely',
      'emoji': '🛒',
      'color': Color(0xFF9C27B0),
      'intro': 'Think before you buy!',
      'questions': [
        {'q': 'Do I really need this?', 'emoji': '🤔'},
        {'q': 'Can I afford it?', 'emoji': '💰'},
        {'q': 'Is it worth the price?', 'emoji': '⚖️'},
        {'q': 'Will I use it often?', 'emoji': '📊'},
        {'q': 'Can I wait and save?', 'emoji': '⏰'},
      ],
      'smartShopping': [
        {'tip': 'Compare prices', 'emoji': '🔍'},
        {'tip': 'Look for sales', 'emoji': '🏷️'},
        {'tip': 'Don\'t buy just because friends have it', 'emoji': '👫'},
        {'tip': 'Make a shopping list', 'emoji': '📝'},
        {'tip': 'Stick to your budget', 'emoji': '💪'},
      ],
    },
    {
      'title': 'Making a Budget',
      'emoji': '📊',
      'color': Color(0xFF00BCD4),
      'intro': 'A budget is a plan for your money!',
      'parts': [
        {'part': 'Money In', 'emoji': '📥', 'desc': 'How much money you get'},
        {'part': 'Money Out', 'emoji': '📤', 'desc': 'How much you spend'},
        {'part': 'Savings', 'emoji': '🐷', 'desc': 'What\'s left to save'},
      ],
      'example': {
        'title': 'Example: Weekly Pocket Money Budget',
        'income': '₹100 pocket money',
        'spend': [
          {'item': 'Snacks', 'amount': '₹30'},
          {'item': 'School supplies', 'amount': '₹20'},
          {'item': 'Fun', 'amount': '₹20'},
        ],
        'save': '₹30 in piggy bank',
      },
      'rule': 'The 50-30-20 Rule: 50% needs, 30% wants, 20% savings!',
    },
    {
      'title': 'Sharing & Giving',
      'emoji': '🤝',
      'color': Color(0xFF795548),
      'intro': 'Using money to help others is wonderful!',
      'ways': [
        {'way': 'Donate to charity', 'emoji': '🎁', 'example': 'Help people in need'},
        {'way': 'Buy gifts for family', 'emoji': '🎂', 'example': 'Birthday presents'},
        {'way': 'Help a friend', 'emoji': '👫', 'example': 'Share school supplies'},
        {'way': 'Support a cause', 'emoji': '🌍', 'example': 'Plant trees, save animals'},
      ],
      'benefits': [
        'Makes you feel happy',
        'Helps people who need it',
        'Creates kindness',
        'Teaches gratitude',
      ],
    },
    {
      'title': 'Money Safety',
      'emoji': '🔒',
      'color': Color(0xFF673AB7),
      'intro': 'Keep your money safe!',
      'rules': [
        {'rule': 'Keep money in a safe place', 'emoji': '🏦'},
        {'rule': 'Don\'t show money in public', 'emoji': '🙈'},
        {'rule': 'Count your change', 'emoji': '🔢'},
        {'rule': 'Tell parents if you find money', 'emoji': '👨‍👩‍👧'},
        {'rule': 'Never share bank passwords', 'emoji': '🔐'},
        {'rule': 'Beware of scams', 'emoji': '⚠️'},
      ],
      'scamWarnings': [
        'Nobody gives free money',
        'Don\'t share personal info online',
        'If it sounds too good, it probably is',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final section = sections[currentSection];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Money Habits',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFAA5A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
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
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressDots(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildSectionContent(section),
                ),
              ),
              _buildNavButtons(section),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProgressDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(sections.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: index == currentSection ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == currentSection
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(section['emoji'], style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 12),
              Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: section['color'],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                section['intro'],
                style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildDynamicContent(section),
      ],
    );
  }

  Widget _buildDynamicContent(Map<String, dynamic> section) {
    switch (section['title']) {
      case 'What is Money?':
        return _buildWhatIsMoney(section);
      case 'Needs vs Wants':
        return _buildNeedsVsWants(section);
      case 'Saving Money':
        return _buildSaving(section);
      case 'Earning Money':
        return _buildEarning(section);
      case 'Spending Wisely':
        return _buildSpending(section);
      case 'Making a Budget':
        return _buildBudget(section);
      case 'Sharing & Giving':
        return _buildSharing(section);
      case 'Money Safety':
        return _buildSafety(section);
      default:
        return const SizedBox();
    }
  }

  Widget _buildWhatIsMoney(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Types of Money:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...(section['types'] as List).map((type) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(type['emoji'], style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['type'],
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              type['examples'],
                              style: GoogleFonts.nunito(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['funFact'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNeedsVsWants(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✅ NEEDS (Must Have):', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 10),
              ...(section['needs'] as List).map((need) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(need['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(need['item'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(need['why'], style: GoogleFonts.nunito(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('⭐ WANTS (Nice to Have):', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.orange)),
              const SizedBox(height: 10),
              ...(section['wants'] as List).map((want) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(want['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(want['item'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(want['why'], style: GoogleFonts.nunito(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section['tip'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaving(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('❓ Why Save?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['whySave'] as List).map((reason) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(reason['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(reason['reason'], style: GoogleFonts.nunito(fontSize: 14)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💡 How to Save:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['howToSave'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(tip['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(tip['tip'], style: GoogleFonts.nunito(fontSize: 14)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(section['savingsGoal']['emoji'], style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  section['savingsGoal']['example'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEarning(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👨‍💼 How Parents Earn:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['howParentsEarn'] as List).map((job) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(job['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(job['job'], style: GoogleFonts.nunito(fontSize: 14)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👧 How Kids Can Earn:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: (section['howKidsCanEarn'] as List).length,
                itemBuilder: (context, index) {
                  final task = section['howKidsCanEarn'][index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(task['emoji'], style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            task['task'],
                            style: GoogleFonts.nunito(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: section['color'].withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('💪', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section['important'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpending(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('❓ Ask Yourself:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['questions'] as List).map((q) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(q['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(q['q'], style: GoogleFonts.nunito(fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🛒 Smart Shopping Tips:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['smartShopping'] as List).map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(tip['emoji'], style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(tip['tip'], style: GoogleFonts.nunito(fontSize: 14)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudget(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text('📊 Parts of a Budget:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: (section['parts'] as List).map<Widget>((part) {
                  return Column(
                    children: [
                      Text(part['emoji'], style: const TextStyle(fontSize: 32)),
                      Text(part['part'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(part['desc'], style: GoogleFonts.nunito(fontSize: 10)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.cyan.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📝 ${section['example']['title']}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text('📥', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text('Income: ${section['example']['income']}', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...(section['example']['spend'] as List).map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['item'], style: GoogleFonts.nunito()),
                      Text(item['amount'], style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text('🐷', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text('Save: ${section['example']['save']}', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section['rule'],
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharing(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💝 Ways to Give:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['ways'] as List).map((way) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: section['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(way['emoji'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(way['way'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(way['example'], style: GoogleFonts.nunito(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✨ Benefits of Giving:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(section['benefits'] as List).map((benefit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(benefit, style: GoogleFonts.nunito(fontSize: 13)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafety(Map<String, dynamic> section) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🛡️ Safety Rules:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...(section['rules'] as List).map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: section['color'].withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(rule['emoji'], style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(rule['rule'], style: GoogleFonts.nunito(fontSize: 14))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    'Scam Warnings:',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...(section['scamWarnings'] as List).map((warning) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(warning, style: GoogleFonts.nunito(fontSize: 13))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButtons(Map<String, dynamic> section) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentSection > 0)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection--),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            const SizedBox(width: 100),
          if (currentSection < sections.length - 1)
            ElevatedButton.icon(
              onPressed: () => setState(() => currentSection++),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: section['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.check),
              label: const Text('Done!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
