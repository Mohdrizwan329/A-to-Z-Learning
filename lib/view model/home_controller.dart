import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/PoemApp.dart';
import 'package:learning_a_to_z/view/world%20meaning%20Alphabet%20/Alphabet_meaning.dart';
import 'package:learning_a_to_z/view/Alphabets/Capital_Alphbet_Page.dart';
import 'package:learning_a_to_z/view/Alphabets/Small_Alphbet_Page.dart';
import 'package:learning_a_to_z/view/numbers/Number_Page.dart';
import 'package:learning_a_to_z/view/tables/Table_Page.dart';
import 'package:learning_a_to_z/view/drawing/Drawing_Image_Page.dart';
import 'package:learning_a_to_z/view/drawing/Drawing_Page.dart';
import 'package:learning_a_to_z/view/hindi%20world%20meaning/hindi_letters_page.dart';
import 'package:learning_a_to_z/view/learn%20set/learning_set_grid_page.dart';
import 'package:learning_a_to_z/view/math%20problem%20&%20solution/Problems_Pages.dart';
import 'package:learning_a_to_z/view/math%20qustion/Math_Qustions_Page.dart';

class ClassItem {
  final String title;
  final String subtitle;
  final Widget? page;

  const ClassItem({
    required this.title,
    required this.subtitle,
    required this.page,
  });
}

IconData getIconForTitle(String title) {
  title = title.toLowerCase();

  if (title.contains("number") || title.contains("1 to 100")) {
    return Icons.numbers;
  } else if (title.contains("capital")) {
    return Icons.abc;
  } else if (title.contains("small")) {
    return Icons.text_fields;
  } else if (title.contains("alphabet")) {
    return Icons.sort_by_alpha;
  } else if (title.contains("Hindi")) {
    return Icons.book;
  } else if (title.contains("math problem")) {
    return Icons.calculate;
  } else if (title.contains("table")) {
    return Icons.grid_on;
  } else if (title.contains("drawing")) {
    return Icons.brush;
  } else if (title.contains("question")) {
    return Icons.question_answer;
  } else if (title.contains("learning set")) {
    return Icons.book;
  } else if (title.contains("poetry")) {
    return Icons.menu_book;
  } else if (title.contains("coming soon")) {
    return Icons.lock;
  }
  return Icons.school;
}

class HomeController extends GetxController {
  var classItems = <ClassItem>[].obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    classItems.assignAll([
      ClassItem(title: '1 to 100', subtitle: 'Numbers', page: NumbersScreen()),
      ClassItem(
        title: 'Capital Letters',
        subtitle: 'Alphabets',
        page: CapitalAlphbet26(),
      ),
      ClassItem(
        title: 'Small Letters',
        subtitle: 'Alphabets',
        page: SmallAlphbet26(),
      ),
      ClassItem(
        title: 'Hindi Letters',
        subtitle: 'Alphabets',
        page: HindiLettersPage(),
      ),
      ClassItem(title: 'Alphabet', subtitle: 'Name', page: AlphabetMening()),
      ClassItem(
        title: 'Math Problem',
        subtitle: 'Solution',
        page: MathGridScreen(),
      ),
      ClassItem(title: '2 to 40', subtitle: 'Tables', page: TableScreen()),
      ClassItem(
        title: 'Drawing',
        subtitle: 'Creativity',
        page: KidsDrowingScreen(),
      ),
      ClassItem(
        title: 'Drawing Image',
        subtitle: 'Creativity',
        page: DrowingScreen(),
      ),
      ClassItem(
        title: 'Math Questions',
        subtitle: 'Test',
        page: MathQustionGridScreen(),
      ),
      ClassItem(
        title: 'Learning Sets',
        subtitle: '20 Name',
        page: LearningSetsGridScreen(),
      ),
      ClassItem(title: 'Poetry', subtitle: 'Test', page: PoemListPage()),
      for (int i = 0; i < 4; i++)
        ClassItem(title: 'Coming Soon', subtitle: '', page: null),
    ]);
  }

  List<ClassItem> get filteredItems {
    if (searchQuery.value.isEmpty) {
      return classItems;
    } else {
      return classItems
          .where(
            (item) =>
                item.title.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                item.subtitle.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
