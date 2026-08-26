import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/utils/app_colors.dart';
import 'package:jiyan_learning/utils/grid_animations_mixin.dart';
import 'package:jiyan_learning/widgets/gradient_scaffold.dart';

import 'package:jiyan_learning/utils/responsive.dart';

class GlobalCulturesDetailPage extends StatefulWidget {
  final int sectionIndex;

  const GlobalCulturesDetailPage({super.key, required this.sectionIndex});

  @override
  State<GlobalCulturesDetailPage> createState() =>
      _GlobalCulturesDetailPageState();
}

class _GlobalCulturesDetailPageState extends State<GlobalCulturesDetailPage>
    with TickerProviderStateMixin, GridAnimationsMixin {
  static final List<Map<String, dynamic>> sections = [
    {
      'title': 'World Cultures',
      'emoji': '🌍',
      'description':
          'Every country has its own special culture! Culture includes food, clothes, music, dance, and traditions that make each place unique.',
      'elements': [
        {'name': 'Food', 'emoji': '🍜'},
        {'name': 'Clothes', 'emoji': '👘'},
        {'name': 'Music', 'emoji': '🎵'},
        {'name': 'Dance', 'emoji': '💃'},
        {'name': 'Festivals', 'emoji': '🎉'},
        {'name': 'Languages', 'emoji': '🗣️'},
      ],
    },
    {
      'title': 'Asian Cultures',
      'emoji': '🌏',
      'cultures': [
        {
          'country': 'India',
          'flag': '🇮🇳',
          'food': 'Curry & Biryani',
          'dress': 'Saree & Kurta',
          'festival': 'Diwali',
          'greeting': 'Namaste 🙏',
        },
        {
          'country': 'Japan',
          'flag': '🇯🇵',
          'food': 'Sushi & Ramen',
          'dress': 'Kimono',
          'festival': 'Cherry Blossom',
          'greeting': 'Konnichiwa',
        },
        {
          'country': 'China',
          'flag': '🇨🇳',
          'food': 'Noodles & Dim Sum',
          'dress': 'Hanfu',
          'festival': 'Chinese New Year',
          'greeting': 'Ni Hao',
        },
        {
          'country': 'Thailand',
          'flag': '🇹🇭',
          'food': 'Pad Thai',
          'dress': 'Chut Thai',
          'festival': 'Songkran',
          'greeting': 'Sawadee',
        },
      ],
    },
    {
      'title': 'European Cultures',
      'emoji': '🏰',
      'cultures': [
        {
          'country': 'France',
          'flag': '🇫🇷',
          'food': 'Croissants & Crepes',
          'dress': 'Beret & Stripes',
          'festival': 'Bastille Day',
          'greeting': 'Bonjour',
        },
        {
          'country': 'Italy',
          'flag': '🇮🇹',
          'food': 'Pizza & Pasta',
          'dress': 'Fashion Capital!',
          'festival': 'Carnival',
          'greeting': 'Ciao',
        },
        {
          'country': 'Spain',
          'flag': '🇪🇸',
          'food': 'Paella & Tapas',
          'dress': 'Flamenco Dress',
          'festival': 'La Tomatina',
          'greeting': 'Hola',
        },
        {
          'country': 'Germany',
          'flag': '🇩🇪',
          'food': 'Pretzels & Sausages',
          'dress': 'Lederhosen',
          'festival': 'Oktoberfest',
          'greeting': 'Guten Tag',
        },
      ],
    },
    {
      'title': 'African Cultures',
      'emoji': '🦁',
      'cultures': [
        {
          'country': 'Egypt',
          'flag': '🇪🇬',
          'food': 'Koshari & Falafel',
          'dress': 'Galabeya',
          'festival': 'Sham el-Nessim',
          'greeting': 'Salaam',
        },
        {
          'country': 'Kenya',
          'flag': '🇰🇪',
          'food': 'Ugali & Nyama Choma',
          'dress': 'Kikoy & Kanga',
          'festival': 'Madaraka Day',
          'greeting': 'Jambo',
        },
        {
          'country': 'Nigeria',
          'flag': '🇳🇬',
          'food': 'Jollof Rice',
          'dress': 'Agbada & Gele',
          'festival': 'Eyo Festival',
          'greeting': 'Bawo ni',
        },
        {
          'country': 'South Africa',
          'flag': '🇿🇦',
          'food': 'Braai & Bobotie',
          'dress': 'Colorful Prints',
          'festival': 'Heritage Day',
          'greeting': 'Sawubona',
        },
      ],
    },
    {
      'title': 'American Cultures',
      'emoji': '🗽',
      'cultures': [
        {
          'country': 'USA',
          'flag': '🇺🇸',
          'food': 'Burgers & Apple Pie',
          'dress': 'Jeans & T-shirt',
          'festival': 'Thanksgiving',
          'greeting': 'Hello',
        },
        {
          'country': 'Mexico',
          'flag': '🇲🇽',
          'food': 'Tacos & Burritos',
          'dress': 'Sombrero & Serape',
          'festival': 'Day of the Dead',
          'greeting': 'Hola',
        },
        {
          'country': 'Brazil',
          'flag': '🇧🇷',
          'food': 'Feijoada & Açaí',
          'dress': 'Carnival Costumes',
          'festival': 'Rio Carnival',
          'greeting': 'Olá',
        },
        {
          'country': 'Argentina',
          'flag': '🇦🇷',
          'food': 'Asado & Empanadas',
          'dress': 'Gaucho Attire',
          'festival': 'Tango Festival',
          'greeting': 'Hola',
        },
      ],
    },
    {
      'title': 'World Greetings',
      'emoji': '👋',
      'greetings': [
        {'language': 'English', 'greeting': 'Hello', 'emoji': '🇬🇧'},
        {'language': 'Spanish', 'greeting': 'Hola', 'emoji': '🇪🇸'},
        {'language': 'French', 'greeting': 'Bonjour', 'emoji': '🇫🇷'},
        {'language': 'Hindi', 'greeting': 'Namaste', 'emoji': '🇮🇳'},
        {'language': 'Japanese', 'greeting': 'Konnichiwa', 'emoji': '🇯🇵'},
        {'language': 'Chinese', 'greeting': 'Ni Hao', 'emoji': '🇨🇳'},
        {'language': 'Arabic', 'greeting': 'Salaam', 'emoji': '🇸🇦'},
        {'language': 'Swahili', 'greeting': 'Jambo', 'emoji': '🇰🇪'},
        {'language': 'Korean', 'greeting': 'Annyeong', 'emoji': '🇰🇷'},
        {'language': 'German', 'greeting': 'Guten Tag', 'emoji': '🇩🇪'},
      ],
    },
    {
      'title': 'World Foods',
      'emoji': '🍜',
      'foods': [
        {'food': 'Pizza', 'country': 'Italy', 'emoji': '🍕'},
        {'food': 'Sushi', 'country': 'Japan', 'emoji': '🍣'},
        {'food': 'Tacos', 'country': 'Mexico', 'emoji': '🌮'},
        {'food': 'Curry', 'country': 'India', 'emoji': '🍛'},
        {'food': 'Croissant', 'country': 'France', 'emoji': '🥐'},
        {'food': 'Noodles', 'country': 'China', 'emoji': '🍜'},
        {'food': 'Kebab', 'country': 'Turkey', 'emoji': '🥙'},
        {'food': 'Falafel', 'country': 'Middle East', 'emoji': '🧆'},
      ],
    },
    {
      'title': 'World Celebrations',
      'emoji': '🎉',
      'celebrations': [
        {
          'festival': 'Diwali',
          'country': 'India',
          'emoji': '🪔',
          'about': 'Festival of Lights',
        },
        {
          'festival': 'Christmas',
          'country': 'Worldwide',
          'emoji': '🎄',
          'about': 'Birth of Jesus',
        },
        {
          'festival': 'Chinese New Year',
          'country': 'China',
          'emoji': '🧧',
          'about': 'Lunar New Year',
        },
        {
          'festival': 'Holi',
          'country': 'India',
          'emoji': '🎨',
          'about': 'Festival of Colors',
        },
        {
          'festival': 'Eid',
          'country': 'Islamic World',
          'emoji': '🌙',
          'about': 'End of Ramadan',
        },
        {
          'festival': 'Carnival',
          'country': 'Brazil',
          'emoji': '🎭',
          'about': 'Dance & Costumes',
        },
      ],
    },
    {
      'title': 'Be a World Citizen!',
      'emoji': '🌟',
      'tips': [
        {
          'tip': 'Respect all cultures',
          'emoji': '🙏',
          'desc': 'Every culture is special',
        },
        {
          'tip': 'Try new foods',
          'emoji': '🍴',
          'desc': 'Taste dishes from other countries',
        },
        {
          'tip': 'Learn new words',
          'emoji': '📚',
          'desc': 'Say hello in different languages',
        },
        {
          'tip': 'Celebrate diversity',
          'emoji': '🌈',
          'desc': 'Our differences make us beautiful',
        },
        {
          'tip': 'Make global friends',
          'emoji': '🤝',
          'desc': 'Connect with kids worldwide',
        },
        {'tip': 'Be curious', 'emoji': '🔍', 'desc': 'Ask questions and learn'},
      ],
      'motto': 'Different cultures, One world, One family!',
    },
  ];

  @override
  void initState() {
    super.initState();
    initGridAnimations(this, floatRange: 3.0);
  }

  @override
  void dispose() {
    disposeGridAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final section = sections[widget.sectionIndex];
    final gradient = AppColors.getGradientForIndex(widget.sectionIndex);

    return GradientScaffold(
      title: section['title'],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Main Card
            buildFloatingItem(
              index: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      section['emoji'],
                      style: const TextStyle(fontSize: 70),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      section['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // Content based on type
            if (section.containsKey('elements')) _buildIntroCards(section),
            if (section.containsKey('cultures')) _buildCultureCards(section),
            if (section.containsKey('greetings')) _buildGreetingCards(section),
            if (section.containsKey('foods')) _buildFoodCards(section),
            if (section.containsKey('celebrations'))
              _buildCelebrationCards(section),
            if (section.containsKey('tips')) _buildTipCards(section),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCards(Map<String, dynamic> section) {
    final elements = section['elements'] as List;
    return Column(
      children: [
        // Description card
        buildFloatingItem(
          index: 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              section['description'],
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Element cards
        ...elements.asMap().entries.map<Widget>((entry) {
          final idx = entry.key;
          final element = entry.value;
          final cardGradient = AppColors.getGradientForIndex(
            widget.sectionIndex + idx + 2,
          );
          return buildFloatingItem(
            index: idx + 2,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: cardGradient[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(element['emoji'], style: const TextStyle(fontSize: 36)),
                  SizedBox(width: 16.w),
                  Text(
                    element['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCultureCards(Map<String, dynamic> section) {
    return Column(
      children: (section['cultures'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final culture = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(culture['flag'], style: const TextStyle(fontSize: 40)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            culture['country'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              culture['greeting'],
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(child: _buildCultureChip('🍜', culture['food'])),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildCultureChip('👘', culture['dress'])),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildCultureChip('🎉', culture['festival']),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCultureChip(String emoji, String value) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCards(Map<String, dynamic> section) {
    return Column(
      children: (section['greetings'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final greeting = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(greeting['emoji'], style: const TextStyle(fontSize: 32)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting['language'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        greeting['greeting'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFoodCards(Map<String, dynamic> section) {
    return Column(
      children: (section['foods'] as List).asMap().entries.map<Widget>((entry) {
        final idx = entry.key;
        final food = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(food['emoji'], style: const TextStyle(fontSize: 36)),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['food'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        food['country'],
                        style: GoogleFonts.nunito(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCelebrationCards(Map<String, dynamic> section) {
    return Column(
      children: (section['celebrations'] as List).asMap().entries.map<Widget>((
        entry,
      ) {
        final idx = entry.key;
        final celebration = entry.value;
        final cardGradient = AppColors.getGradientForIndex(
          widget.sectionIndex + idx + 1,
        );
        return buildFloatingItem(
          index: idx + 1,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    celebration['emoji'],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        celebration['festival'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        celebration['country'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        celebration['about'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipCards(Map<String, dynamic> section) {
    final tips = section['tips'] as List;
    return Column(
      children: [
        ...tips.asMap().entries.map<Widget>((entry) {
          final idx = entry.key;
          final tip = entry.value;
          final cardGradient = AppColors.getGradientForIndex(
            widget.sectionIndex + idx + 1,
          );
          return buildFloatingItem(
            index: idx + 1,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: cardGradient[0].withValues(alpha: 0.3),
                    blurRadius: 6.r,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(tip['emoji'], style: const TextStyle(fontSize: 28)),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['tip'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          tip['desc'],
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (section.containsKey('motto'))
          buildFloatingItem(
            index: tips.length + 1,
            child: Container(
              margin: EdgeInsets.only(top: 6.h, bottom: 10.h),
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB74D), Color(0xFFFFD54F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
                    blurRadius: 8.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('🌍🤝🌏', style: TextStyle(fontSize: 36)),
                  SizedBox(height: 8.h),
                  Text(
                    section['motto'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 3.r,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
