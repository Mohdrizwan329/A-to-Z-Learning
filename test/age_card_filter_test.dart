// Pins the home screen's age routing: picking an age card on the selection
// screen must leave exactly the agreed set of cards on the home grid, in the
// agreed category. The expectations below are written out by hand rather than
// read back off HomeController, so a card that quietly changes age group --
// or a new card added to the wrong one -- fails here instead of shipping.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:jiyan_learning/services/age_content_service.dart';
import 'package:jiyan_learning/view%20model/home%20controller/home_controller.dart';

/// The card set each age card must produce, category by category.
const Map<AgeGroup, Map<String, List<String>>> expected = {
  // 2-4 Years (Toddler / Nursery) -- 20 cards
  AgeGroup.toddler: {
    'Core Learning': ['Numbers', 'Capital Letters', 'Hindi Letters', 'Learning Sets', 'Rhymes & Songs', 'General Knowledge', 'Stories', 'Sensory Learning', 'Visual Learning', 'Audio Learning', 'Play Based Learning', 'Montessori Learning', 'Activity Based'],
    'Games & Quiz': ['Matching Game', 'Tracing Game', 'Puzzle Game'],
    'Writing': ['Kids Drawing', 'Drawing Image'],
    'Life Skills': ['Good Habits'],
    'Health': ['Mindfulness'],
  },
  // 4-6 Years (LKG / UKG) -- 30 cards
  AgeGroup.lkgUkg: {
    'Core Learning': ['Numbers', 'Capital Letters', 'Small Letters', 'Hindi Letters', 'A to Z Words', 'Tables', 'Learning Sets', 'Rhymes & Songs', 'General Knowledge', 'Stories', 'Exploratory Learning', 'Discovery Learning', 'Experiential Learning', 'Kinesthetic Learning'],
    'Games & Quiz': ['Quiz Time', 'Drag & Drop', 'Matching Game', 'Tracing Game', 'Puzzle Game', 'Adaptive Quiz', 'Memory Match'],
    'Literacy': ['Sight Words', 'Listening Skills'],
    'Writing': ['Kids Drawing', 'Drawing Image'],
    'Math & Logic': ['Math Practice', 'Money Concepts'],
    'Creativity': ['Story Creation'],
    'Health': ['Empathy Learning', 'Confidence'],
  },
  // 6-8 Years (Class 1-2) -- 26 cards
  AgeGroup.class1To2: {
    'Core Learning': ['Numbers', 'Hindi Letters', 'Tables', 'Learning Sets', 'General Knowledge', 'Stories'],
    'Games & Quiz': ['Quiz Time', 'Drag & Drop', 'Matching Game', 'Puzzle Game', 'Memory Match'],
    'Literacy': ['Sight Words', 'Spelling Practice', 'Reading Fluency', 'Sentence Formation'],
    'Writing': ['Kids Drawing', 'Cursive Writing'],
    'Math & Logic': ['Math Problem Solve Practice', 'Math Practice', 'Money Concepts'],
    'Knowledge': ['Science Basics', 'Environment', 'Social Skills'],
    'Health': ['Calm Down', 'Know Yourself', 'Focus Improvement'],
  },
  // 8-10 Years (Class 3-4) -- 24 cards
  AgeGroup.class3To4: {
    'Core Learning': ['Tables', 'General Knowledge', 'Stories'],
    'Games & Quiz': ['Quiz Time', 'Skill Evaluation'],
    'Writing': ['Kids Drawing'],
    'Math & Logic': ['Math Problem Solve Practice', 'Math Practice', 'Money Concepts'],
    'Knowledge': ['STEM Hub', 'Design Thinking', 'Computer Awareness', 'Keyboard & Mouse', 'Internet Safety', 'Digital Etiquette', 'DIY Learning'],
    'Life Skills': ['Hygiene Habits', 'Time Management', 'Safety Skills', 'Money Habits', 'Planning Skills', 'Goal Setting', 'Task Sequencing', 'Working Memory'],
  },
  // 10-12 Years (Class 5-6) -- 28 cards
  AgeGroup.class5To6: {
    'Core Learning': ['Tables', 'General Knowledge', 'Stories'],
    'Games & Quiz': ['Quiz Time', 'Quiz Battle'],
    'Writing': ['Kids Drawing'],
    'Math & Logic': ['Math Problem Solve Practice', 'Math Practice', 'Money Concepts'],
    'Knowledge': ['World Map', 'Famous Places', 'Engineering for Kids', 'STEM Challenges', 'STEAM Page', 'Climate Awareness', 'Recycling', 'Sustainable Habits', 'Citizenship', 'Rights & Duties'],
    'Life Skills': ['Think About Thinking', 'Self Reflection', 'Learning Strategy'],
    'Health': ['Nutrition', 'Exercise', 'Mental Health', 'Body Safety', 'Family & Relationships'],
    'Culture': ['Global Cultures'],
  },
};

/// Age carried by each card on the selection screen, as the card spells it out.
const Map<AgeGroup, String> cardLabel = {
  AgeGroup.toddler: '2-4 Years / Toddler / Nursery',
  AgeGroup.lkgUkg: '4-6 Years / LKG / UKG',
  AgeGroup.class1To2: '6-8 Years / Class 1-2',
  AgeGroup.class3To4: '8-10 Years / Class 3-4',
  AgeGroup.class5To6: '10-12 Years / Class 5-6',
};

void main() {
  late Directory dir;
  late AgeContentService ages;
  late HomeController home;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    dir = await Directory.systemTemp.createTemp('age_cards');
    // GetStorage asks path_provider where to write; in tests nothing answers
    // that channel, so point it at a temp directory of our own.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => dir.path,
    );
    await GetStorage.init();
    Get.testMode = true;
    ages = Get.put(await AgeContentService().init(), permanent: true);
    home = Get.put(HomeController());
  });

  tearDownAll(() async {
    Get.reset();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  for (final group in AgeGroup.values) {
    final want = expected[group]!;

    test('${cardLabel[group]} shows exactly its own cards', () async {
      await ages.setAgeGroup(group);

      final got = <String, List<String>>{};
      for (final item in home.displayItems) {
        got.putIfAbsent(item.category, () => []).add(item.title);
      }

      expect(got.keys.toSet(), want.keys.toSet(),
          reason: 'categories on the ${cardLabel[group]} home screen');
      for (final category in want.keys) {
        expect(got[category], want[category],
            reason: '$category cards for ${cardLabel[group]}');
      }
    });

    test('${cardLabel[group]} shows ${want.values.expand((e) => e).length} cards in total', () async {
      await ages.setAgeGroup(group);
      expect(home.displayItems.length, want.values.expand((e) => e).length);
    });
  }

  test('every card names its own age groups, none falls through to "all"', () {
    final loose = home.classItems
        .where((i) => i.ageGroups.contains(AgeGroupFilter.all))
        .map((i) => i.title)
        .toList();
    expect(loose, isEmpty,
        reason: 'these cards would show on every age card regardless of the pick');
  });

  test('the whole catalogue is reachable from some age card', () {
    final reachable = <String>{};
    for (final want in expected.values) {
      reachable.addAll(want.values.expand((e) => e));
    }
    final orphans = home.classItems
        .map((i) => i.title)
        .where((t) => !reachable.contains(t))
        .toList();
    expect(orphans, isEmpty, reason: 'cards no age card can ever show');
  });
}
