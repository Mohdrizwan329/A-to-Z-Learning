import 'package:get/get_navigation/get_navigation.dart';
import 'package:learning_a_to_z/view/splash/splash_screen.dart';
import 'package:learning_a_to_z/view/home/home_page.dart';
import 'package:learning_a_to_z/view/world%20meaning%20Alphabet%20/Alphabet_meaning.dart';
import 'package:learning_a_to_z/view/numbers/Number_Page.dart';
import 'package:learning_a_to_z/view/tables/Table_Page.dart';
import 'package:learning_a_to_z/view/drawing/Drawing_Image_Page.dart';
import 'package:learning_a_to_z/view/math%20problem%20&%20solution/Problems_Pages.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: "/", page: () => const SplashScreen()),
    GetPage(name: "/home", page: () => HomeScreen()),
    GetPage(name: "/NumbersScreen", page: () => NumbersScreen()),
    GetPage(name: "/AlphabetMening", page: () => AlphabetMening()),
    GetPage(name: "/TableScreen", page: () => TableScreen()),
    GetPage(name: "/MathGridScreen", page: () => MathGridScreen()),
    GetPage(name: "/DrowingScreen", page: () => DrowingScreen()),
    GetPage(
      name: "/ImageDrowingScreen",
      page: () => ImageDrowingScreen(imagePath: ''),
    ),
  ];
}
