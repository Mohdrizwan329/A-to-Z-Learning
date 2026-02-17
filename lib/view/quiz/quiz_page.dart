import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiyan_learning/services/rewards_service.dart';
import 'package:jiyan_learning/services/daily_goals_service.dart';
import 'package:jiyan_learning/view/ads/Google_Ads_Page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bubbleController;
  late AnimationController _feedbackController;
  late Animation<double> _floatAnimation;
  late Animation<double> _feedbackAnimation;
  bool _isInitialized = false;

  final List<Map<String, dynamic>> _allQuestions = [
    // Alphabet Questions (20)
    {
      'question': 'What letter comes after A?',
      'options': ['B', 'C', 'D', 'Z'],
      'answer': 'B',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes before Z?',
      'options': ['X', 'Y', 'W', 'V'],
      'answer': 'Y',
      'category': 'Alphabet',
    },
    {
      'question': 'Which is a vowel?',
      'options': ['B', 'E', 'C', 'D'],
      'answer': 'E',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes after M?',
      'options': ['L', 'N', 'O', 'K'],
      'answer': 'N',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter is NOT a vowel?',
      'options': ['A', 'E', 'B', 'I'],
      'answer': 'B',
      'category': 'Alphabet',
    },
    {
      'question': 'What is the first letter of the alphabet?',
      'options': ['Z', 'A', 'B', 'C'],
      'answer': 'A',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes before D?',
      'options': ['E', 'C', 'B', 'F'],
      'answer': 'C',
      'category': 'Alphabet',
    },
    {
      'question': 'How many vowels are in the alphabet?',
      'options': ['3', '4', '5', '6'],
      'answer': '5',
      'category': 'Alphabet',
    },
    {
      'question': 'What is the last letter of the alphabet?',
      'options': ['Y', 'X', 'Z', 'W'],
      'answer': 'Z',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter comes after G?',
      'options': ['F', 'H', 'I', 'E'],
      'answer': 'H',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter is between K and M?',
      'options': ['J', 'L', 'N', 'I'],
      'answer': 'L',
      'category': 'Alphabet',
    },
    {
      'question': 'Which is a consonant?',
      'options': ['A', 'E', 'I', 'P'],
      'answer': 'P',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes after T?',
      'options': ['S', 'U', 'V', 'R'],
      'answer': 'U',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter starts the word "Apple"?',
      'options': ['E', 'A', 'P', 'L'],
      'answer': 'A',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter is the 5th in the alphabet?',
      'options': ['D', 'E', 'F', 'C'],
      'answer': 'E',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes after R?',
      'options': ['Q', 'S', 'T', 'P'],
      'answer': 'S',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter is the 10th in the alphabet?',
      'options': ['I', 'J', 'K', 'H'],
      'answer': 'J',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes before P?',
      'options': ['O', 'Q', 'N', 'R'],
      'answer': 'O',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter starts the word "Elephant"?',
      'options': ['A', 'E', 'I', 'L'],
      'answer': 'E',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter is between F and H?',
      'options': ['E', 'G', 'I', 'D'],
      'answer': 'G',
      'category': 'Alphabet',
    },

    // Math Questions (30)
    {
      'question': 'What is 5 + 3?',
      'options': ['6', '7', '8', '9'],
      'answer': '8',
      'category': 'Math',
    },
    {
      'question': 'What is 10 - 4?',
      'options': ['5', '6', '7', '8'],
      'answer': '6',
      'category': 'Math',
    },
    {
      'question': 'What is 3 × 4?',
      'options': ['10', '11', '12', '13'],
      'answer': '12',
      'category': 'Math',
    },
    {
      'question': 'What is 20 ÷ 4?',
      'options': ['4', '5', '6', '7'],
      'answer': '5',
      'category': 'Math',
    },
    {
      'question': 'What is 7 + 8?',
      'options': ['13', '14', '15', '16'],
      'answer': '15',
      'category': 'Math',
    },
    {
      'question': 'What is 15 - 9?',
      'options': ['4', '5', '6', '7'],
      'answer': '6',
      'category': 'Math',
    },
    {
      'question': 'What is 6 × 3?',
      'options': ['15', '16', '17', '18'],
      'answer': '18',
      'category': 'Math',
    },
    {
      'question': 'What is 36 ÷ 6?',
      'options': ['4', '5', '6', '7'],
      'answer': '6',
      'category': 'Math',
    },
    {
      'question': 'What is 9 + 9?',
      'options': ['16', '17', '18', '19'],
      'answer': '18',
      'category': 'Math',
    },
    {
      'question': 'What is 25 - 13?',
      'options': ['10', '11', '12', '13'],
      'answer': '12',
      'category': 'Math',
    },
    {
      'question': 'What is 5 × 5?',
      'options': ['20', '25', '30', '35'],
      'answer': '25',
      'category': 'Math',
    },
    {
      'question': 'What is 42 ÷ 7?',
      'options': ['5', '6', '7', '8'],
      'answer': '6',
      'category': 'Math',
    },
    {
      'question': 'What is 11 + 12?',
      'options': ['21', '22', '23', '24'],
      'answer': '23',
      'category': 'Math',
    },
    {
      'question': 'What is 30 - 17?',
      'options': ['11', '12', '13', '14'],
      'answer': '13',
      'category': 'Math',
    },
    {
      'question': 'What is 8 × 7?',
      'options': ['54', '55', '56', '57'],
      'answer': '56',
      'category': 'Math',
    },
    {
      'question': 'What is 81 ÷ 9?',
      'options': ['7', '8', '9', '10'],
      'answer': '9',
      'category': 'Math',
    },
    {
      'question': 'What is 14 + 17?',
      'options': ['29', '30', '31', '32'],
      'answer': '31',
      'category': 'Math',
    },
    {
      'question': 'What is 50 - 23?',
      'options': ['25', '26', '27', '28'],
      'answer': '27',
      'category': 'Math',
    },
    {
      'question': 'What is 9 × 9?',
      'options': ['72', '79', '81', '82'],
      'answer': '81',
      'category': 'Math',
    },
    {
      'question': 'What is 100 ÷ 10?',
      'options': ['8', '9', '10', '11'],
      'answer': '10',
      'category': 'Math',
    },
    {
      'question': 'What is 12 + 15?',
      'options': ['25', '26', '27', '28'],
      'answer': '27',
      'category': 'Math',
    },
    {
      'question': 'What is 45 - 18?',
      'options': ['25', '26', '27', '28'],
      'answer': '27',
      'category': 'Math',
    },
    {
      'question': 'What is 7 × 6?',
      'options': ['40', '41', '42', '43'],
      'answer': '42',
      'category': 'Math',
    },
    {
      'question': 'What is 63 ÷ 9?',
      'options': ['6', '7', '8', '9'],
      'answer': '7',
      'category': 'Math',
    },
    {
      'question': 'What is 19 + 24?',
      'options': ['41', '42', '43', '44'],
      'answer': '43',
      'category': 'Math',
    },
    {
      'question': 'What is 72 - 35?',
      'options': ['35', '36', '37', '38'],
      'answer': '37',
      'category': 'Math',
    },
    {
      'question': 'What is 4 × 8?',
      'options': ['30', '31', '32', '33'],
      'answer': '32',
      'category': 'Math',
    },
    {
      'question': 'What is 56 ÷ 8?',
      'options': ['5', '6', '7', '8'],
      'answer': '7',
      'category': 'Math',
    },
    {
      'question': 'What is 33 + 29?',
      'options': ['60', '61', '62', '63'],
      'answer': '62',
      'category': 'Math',
    },
    {
      'question': 'What is 88 - 44?',
      'options': ['42', '43', '44', '45'],
      'answer': '44',
      'category': 'Math',
    },

    // Animal Questions (20)
    {
      'question': 'Which animal says "Moo"?',
      'options': ['Dog', 'Cat', 'Cow', 'Bird'],
      'answer': 'Cow',
      'category': 'Animals',
    },
    {
      'question': 'Which animal is the King of Jungle?',
      'options': ['Tiger', 'Lion', 'Bear', 'Wolf'],
      'answer': 'Lion',
      'category': 'Animals',
    },
    {
      'question': 'How many legs does a spider have?',
      'options': ['6', '8', '10', '4'],
      'answer': '8',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has a long neck?',
      'options': ['Elephant', 'Giraffe', 'Zebra', 'Horse'],
      'answer': 'Giraffe',
      'category': 'Animals',
    },
    {
      'question': 'Which animal says "Woof"?',
      'options': ['Cat', 'Dog', 'Cow', 'Duck'],
      'answer': 'Dog',
      'category': 'Animals',
    },
    {
      'question': 'Which animal can fly?',
      'options': ['Fish', 'Bird', 'Dog', 'Cat'],
      'answer': 'Bird',
      'category': 'Animals',
    },
    {
      'question': 'Which animal lives in water?',
      'options': ['Lion', 'Tiger', 'Fish', 'Monkey'],
      'answer': 'Fish',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has a trunk?',
      'options': ['Giraffe', 'Elephant', 'Zebra', 'Lion'],
      'answer': 'Elephant',
      'category': 'Animals',
    },
    {
      'question': 'Which animal hops?',
      'options': ['Dog', 'Cat', 'Rabbit', 'Cow'],
      'answer': 'Rabbit',
      'category': 'Animals',
    },
    {
      'question': 'Which animal says "Meow"?',
      'options': ['Dog', 'Cat', 'Bird', 'Mouse'],
      'answer': 'Cat',
      'category': 'Animals',
    },
    {
      'question': 'Which is the largest land animal?',
      'options': ['Lion', 'Giraffe', 'Elephant', 'Bear'],
      'answer': 'Elephant',
      'category': 'Animals',
    },
    {
      'question': 'Which animal gives us honey?',
      'options': ['Ant', 'Bee', 'Butterfly', 'Spider'],
      'answer': 'Bee',
      'category': 'Animals',
    },
    {
      'question': 'Which animal is called man\'s best friend?',
      'options': ['Cat', 'Horse', 'Dog', 'Bird'],
      'answer': 'Dog',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has black and white stripes?',
      'options': ['Lion', 'Tiger', 'Zebra', 'Horse'],
      'answer': 'Zebra',
      'category': 'Animals',
    },
    {
      'question': 'Which animal gives us milk?',
      'options': ['Hen', 'Cow', 'Dog', 'Cat'],
      'answer': 'Cow',
      'category': 'Animals',
    },
    {
      'question': 'Which animal lives in a web?',
      'options': ['Bee', 'Ant', 'Spider', 'Butterfly'],
      'answer': 'Spider',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has a shell?',
      'options': ['Fish', 'Frog', 'Turtle', 'Snake'],
      'answer': 'Turtle',
      'category': 'Animals',
    },
    {
      'question': 'Which animal says "Quack"?',
      'options': ['Hen', 'Crow', 'Duck', 'Parrot'],
      'answer': 'Duck',
      'category': 'Animals',
    },
    {
      'question': 'Which is the fastest land animal?',
      'options': ['Lion', 'Cheetah', 'Tiger', 'Horse'],
      'answer': 'Cheetah',
      'category': 'Animals',
    },
    {
      'question': 'Which animal hangs upside down?',
      'options': ['Monkey', 'Bat', 'Bird', 'Squirrel'],
      'answer': 'Bat',
      'category': 'Animals',
    },

    // Color Questions (15)
    {
      'question': 'What color is the sky?',
      'options': ['Red', 'Green', 'Blue', 'Yellow'],
      'answer': 'Blue',
      'category': 'Colors',
    },
    {
      'question': 'What color is a banana?',
      'options': ['Red', 'Yellow', 'Blue', 'Green'],
      'answer': 'Yellow',
      'category': 'Colors',
    },
    {
      'question': 'What color do you get mixing red and blue?',
      'options': ['Green', 'Orange', 'Purple', 'Pink'],
      'answer': 'Purple',
      'category': 'Colors',
    },
    {
      'question': 'What color is grass?',
      'options': ['Blue', 'Green', 'Yellow', 'Red'],
      'answer': 'Green',
      'category': 'Colors',
    },
    {
      'question': 'What color is the sun?',
      'options': ['Blue', 'Green', 'Yellow', 'Purple'],
      'answer': 'Yellow',
      'category': 'Colors',
    },
    {
      'question': 'What color do you get mixing red and yellow?',
      'options': ['Orange', 'Purple', 'Green', 'Pink'],
      'answer': 'Orange',
      'category': 'Colors',
    },
    {
      'question': 'What color is snow?',
      'options': ['Blue', 'Yellow', 'White', 'Gray'],
      'answer': 'White',
      'category': 'Colors',
    },
    {
      'question': 'What color is an apple?',
      'options': ['Blue', 'Red', 'Purple', 'Pink'],
      'answer': 'Red',
      'category': 'Colors',
    },
    {
      'question': 'What color do you get mixing blue and yellow?',
      'options': ['Orange', 'Purple', 'Green', 'Brown'],
      'answer': 'Green',
      'category': 'Colors',
    },
    {
      'question': 'What color is a carrot?',
      'options': ['Red', 'Yellow', 'Orange', 'Green'],
      'answer': 'Orange',
      'category': 'Colors',
    },
    {
      'question': 'What color is chocolate?',
      'options': ['Black', 'Brown', 'Red', 'Orange'],
      'answer': 'Brown',
      'category': 'Colors',
    },
    {
      'question': 'What color is a strawberry?',
      'options': ['Blue', 'Green', 'Red', 'Yellow'],
      'answer': 'Red',
      'category': 'Colors',
    },
    {
      'question': 'What color is an eggplant?',
      'options': ['Red', 'Purple', 'Green', 'Brown'],
      'answer': 'Purple',
      'category': 'Colors',
    },
    {
      'question': 'What color is cotton?',
      'options': ['Black', 'Brown', 'White', 'Gray'],
      'answer': 'White',
      'category': 'Colors',
    },
    {
      'question': 'What color is the sea?',
      'options': ['Red', 'Green', 'Blue', 'Yellow'],
      'answer': 'Blue',
      'category': 'Colors',
    },

    // Shape Questions (15)
    {
      'question': 'How many sides does a triangle have?',
      'options': ['2', '3', '4', '5'],
      'answer': '3',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a ball?',
      'options': ['Square', 'Circle', 'Triangle', 'Rectangle'],
      'answer': 'Circle',
      'category': 'Shapes',
    },
    {
      'question': 'How many sides does a square have?',
      'options': ['3', '4', '5', '6'],
      'answer': '4',
      'category': 'Shapes',
    },
    {
      'question': 'What shape has 6 sides?',
      'options': ['Pentagon', 'Hexagon', 'Octagon', 'Triangle'],
      'answer': 'Hexagon',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a pizza slice?',
      'options': ['Square', 'Circle', 'Triangle', 'Rectangle'],
      'answer': 'Triangle',
      'category': 'Shapes',
    },
    {
      'question': 'How many corners does a rectangle have?',
      'options': ['2', '3', '4', '5'],
      'answer': '4',
      'category': 'Shapes',
    },
    {
      'question': 'What shape has no corners?',
      'options': ['Square', 'Triangle', 'Circle', 'Rectangle'],
      'answer': 'Circle',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a stop sign?',
      'options': ['Circle', 'Square', 'Octagon', 'Triangle'],
      'answer': 'Octagon',
      'category': 'Shapes',
    },
    {
      'question': 'How many sides does a pentagon have?',
      'options': ['4', '5', '6', '7'],
      'answer': '5',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a dice?',
      'options': ['Circle', 'Cube', 'Sphere', 'Cylinder'],
      'answer': 'Cube',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a wheel?',
      'options': ['Square', 'Triangle', 'Circle', 'Rectangle'],
      'answer': 'Circle',
      'category': 'Shapes',
    },
    {
      'question': 'How many sides does an octagon have?',
      'options': ['6', '7', '8', '9'],
      'answer': '8',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a door?',
      'options': ['Circle', 'Triangle', 'Rectangle', 'Oval'],
      'answer': 'Rectangle',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is an egg?',
      'options': ['Circle', 'Oval', 'Square', 'Triangle'],
      'answer': 'Oval',
      'category': 'Shapes',
    },
    {
      'question': 'What shape is a coin?',
      'options': ['Square', 'Triangle', 'Circle', 'Rectangle'],
      'answer': 'Circle',
      'category': 'Shapes',
    },

    // GK Questions (28)
    {
      'question': 'How many days are in a week?',
      'options': ['5', '6', '7', '8'],
      'answer': '7',
      'category': 'GK',
    },
    {
      'question': 'Which planet is called the Red Planet?',
      'options': ['Earth', 'Mars', 'Venus', 'Jupiter'],
      'answer': 'Mars',
      'category': 'GK',
    },
    {
      'question': 'What is the capital of India?',
      'options': ['Mumbai', 'Delhi', 'Kolkata', 'Chennai'],
      'answer': 'Delhi',
      'category': 'GK',
    },
    {
      'question': 'How many months are in a year?',
      'options': ['10', '11', '12', '13'],
      'answer': '12',
      'category': 'GK',
    },
    {
      'question': 'Which is the largest ocean?',
      'options': ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      'answer': 'Pacific',
      'category': 'GK',
    },
    {
      'question': 'How many continents are there?',
      'options': ['5', '6', '7', '8'],
      'answer': '7',
      'category': 'GK',
    },
    {
      'question': 'What do plants need to grow?',
      'options': ['Candy', 'Water', 'Toys', 'Books'],
      'answer': 'Water',
      'category': 'GK',
    },
    {
      'question': 'Which season comes after summer?',
      'options': ['Spring', 'Winter', 'Autumn', 'Monsoon'],
      'answer': 'Autumn',
      'category': 'GK',
    },
    {
      'question': 'How many hours are in a day?',
      'options': ['12', '20', '24', '30'],
      'answer': '24',
      'category': 'GK',
    },
    {
      'question': 'What is the freezing point of water?',
      'options': ['0°C', '10°C', '50°C', '100°C'],
      'answer': '0°C',
      'category': 'GK',
    },
    {
      'question': 'Which country has the Taj Mahal?',
      'options': ['Pakistan', 'India', 'Nepal', 'Bangladesh'],
      'answer': 'India',
      'category': 'GK',
    },
    {
      'question': 'How many legs does an insect have?',
      'options': ['4', '6', '8', '10'],
      'answer': '6',
      'category': 'GK',
    },
    {
      'question': 'What is baby frog called?',
      'options': ['Puppy', 'Kitten', 'Tadpole', 'Calf'],
      'answer': 'Tadpole',
      'category': 'GK',
    },
    {
      'question': 'Which is the smallest planet?',
      'options': ['Earth', 'Mars', 'Mercury', 'Venus'],
      'answer': 'Mercury',
      'category': 'GK',
    },
    {
      'question': 'How many bones do humans have?',
      'options': ['106', '156', '206', '256'],
      'answer': '206',
      'category': 'GK',
    },
    {
      'question': 'Which is the largest planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 'Jupiter',
      'category': 'GK',
    },
    {
      'question': 'How many minutes are in an hour?',
      'options': ['30', '45', '60', '90'],
      'answer': '60',
      'category': 'GK',
    },
    {
      'question': 'What is the boiling point of water?',
      'options': ['50°C', '80°C', '100°C', '120°C'],
      'answer': '100°C',
      'category': 'GK',
    },
    {
      'question': 'Which organ pumps blood in our body?',
      'options': ['Brain', 'Lungs', 'Heart', 'Liver'],
      'answer': 'Heart',
      'category': 'GK',
    },
    {
      'question': 'How many senses do humans have?',
      'options': ['3', '4', '5', '6'],
      'answer': '5',
      'category': 'GK',
    },
    {
      'question': 'Which is the longest river in the world?',
      'options': ['Amazon', 'Nile', 'Ganges', 'Yamuna'],
      'answer': 'Nile',
      'category': 'GK',
    },
    {
      'question': 'What is the national bird of India?',
      'options': ['Sparrow', 'Peacock', 'Parrot', 'Eagle'],
      'answer': 'Peacock',
      'category': 'GK',
    },
    {
      'question': 'How many teeth do adults have?',
      'options': ['20', '28', '32', '36'],
      'answer': '32',
      'category': 'GK',
    },
    {
      'question': 'Which gas do we breathe in?',
      'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
      'answer': 'Oxygen',
      'category': 'GK',
    },
    {
      'question': 'What is the national animal of India?',
      'options': ['Lion', 'Tiger', 'Elephant', 'Deer'],
      'answer': 'Tiger',
      'category': 'GK',
    },
    {
      'question': 'How many seconds are in a minute?',
      'options': ['30', '45', '60', '90'],
      'answer': '60',
      'category': 'GK',
    },
    {
      'question': 'Which planet is closest to the Sun?',
      'options': ['Venus', 'Earth', 'Mercury', 'Mars'],
      'answer': 'Mercury',
      'category': 'GK',
    },
    {
      'question': 'What is the capital of USA?',
      'options': ['New York', 'Los Angeles', 'Washington DC', 'Chicago'],
      'answer': 'Washington DC',
      'category': 'GK',
    },

    // Additional Alphabet Questions (10)
    {
      'question': 'What letter comes after W?',
      'options': ['V', 'X', 'Y', 'Z'],
      'answer': 'X',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter is the 15th in the alphabet?',
      'options': ['N', 'O', 'P', 'M'],
      'answer': 'O',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes before K?',
      'options': ['I', 'J', 'L', 'H'],
      'answer': 'J',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter starts the word "Queen"?',
      'options': ['P', 'Q', 'R', 'K'],
      'answer': 'Q',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter is the 20th in the alphabet?',
      'options': ['S', 'T', 'U', 'R'],
      'answer': 'T',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter comes after L?',
      'options': ['K', 'M', 'N', 'J'],
      'answer': 'M',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter is between S and U?',
      'options': ['R', 'T', 'V', 'Q'],
      'answer': 'T',
      'category': 'Alphabet',
    },
    {
      'question': 'What is the 3rd vowel in the alphabet?',
      'options': ['A', 'E', 'I', 'O'],
      'answer': 'I',
      'category': 'Alphabet',
    },
    {
      'question': 'Which letter starts the word "Umbrella"?',
      'options': ['U', 'V', 'W', 'Y'],
      'answer': 'U',
      'category': 'Alphabet',
    },
    {
      'question': 'What letter is the 26th in the alphabet?',
      'options': ['X', 'Y', 'Z', 'W'],
      'answer': 'Z',
      'category': 'Alphabet',
    },

    // Additional Math Questions (15)
    {
      'question': 'What is 15 + 15?',
      'options': ['28', '29', '30', '31'],
      'answer': '30',
      'category': 'Math',
    },
    {
      'question': 'What is 60 - 25?',
      'options': ['33', '34', '35', '36'],
      'answer': '35',
      'category': 'Math',
    },
    {
      'question': 'What is 12 × 3?',
      'options': ['34', '35', '36', '37'],
      'answer': '36',
      'category': 'Math',
    },
    {
      'question': 'What is 72 ÷ 8?',
      'options': ['7', '8', '9', '10'],
      'answer': '9',
      'category': 'Math',
    },
    {
      'question': 'What is 25 + 36?',
      'options': ['59', '60', '61', '62'],
      'answer': '61',
      'category': 'Math',
    },
    {
      'question': 'What is 90 - 45?',
      'options': ['43', '44', '45', '46'],
      'answer': '45',
      'category': 'Math',
    },
    {
      'question': 'What is 11 × 11?',
      'options': ['111', '121', '131', '141'],
      'answer': '121',
      'category': 'Math',
    },
    {
      'question': 'What is 48 ÷ 6?',
      'options': ['6', '7', '8', '9'],
      'answer': '8',
      'category': 'Math',
    },
    {
      'question': 'What is 27 + 38?',
      'options': ['63', '64', '65', '66'],
      'answer': '65',
      'category': 'Math',
    },
    {
      'question': 'What is 75 - 28?',
      'options': ['45', '46', '47', '48'],
      'answer': '47',
      'category': 'Math',
    },
    {
      'question': 'What is 6 × 9?',
      'options': ['52', '53', '54', '55'],
      'answer': '54',
      'category': 'Math',
    },
    {
      'question': 'What is 64 ÷ 8?',
      'options': ['6', '7', '8', '9'],
      'answer': '8',
      'category': 'Math',
    },
    {
      'question': 'What is 42 + 39?',
      'options': ['79', '80', '81', '82'],
      'answer': '81',
      'category': 'Math',
    },
    {
      'question': 'What is 100 - 37?',
      'options': ['61', '62', '63', '64'],
      'answer': '63',
      'category': 'Math',
    },
    {
      'question': 'What is 7 × 8?',
      'options': ['54', '55', '56', '57'],
      'answer': '56',
      'category': 'Math',
    },

    // Additional Animal Questions (10)
    {
      'question': 'Which animal has spots?',
      'options': ['Zebra', 'Leopard', 'Horse', 'Cow'],
      'answer': 'Leopard',
      'category': 'Animals',
    },
    {
      'question': 'Which animal gives us wool?',
      'options': ['Goat', 'Sheep', 'Cow', 'Dog'],
      'answer': 'Sheep',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has a hump?',
      'options': ['Horse', 'Camel', 'Elephant', 'Deer'],
      'answer': 'Camel',
      'category': 'Animals',
    },
    {
      'question': 'Which animal says "Neigh"?',
      'options': ['Donkey', 'Horse', 'Cow', 'Goat'],
      'answer': 'Horse',
      'category': 'Animals',
    },
    {
      'question': 'Which animal is known as ship of desert?',
      'options': ['Horse', 'Elephant', 'Camel', 'Donkey'],
      'answer': 'Camel',
      'category': 'Animals',
    },
    {
      'question': 'Which animal gives us eggs?',
      'options': ['Cow', 'Hen', 'Dog', 'Cat'],
      'answer': 'Hen',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has a pouch?',
      'options': ['Rabbit', 'Kangaroo', 'Bear', 'Deer'],
      'answer': 'Kangaroo',
      'category': 'Animals',
    },
    {
      'question': 'Which animal says "Roar"?',
      'options': ['Dog', 'Cat', 'Lion', 'Sheep'],
      'answer': 'Lion',
      'category': 'Animals',
    },
    {
      'question': 'Which animal climbs trees well?',
      'options': ['Fish', 'Monkey', 'Cow', 'Horse'],
      'answer': 'Monkey',
      'category': 'Animals',
    },
    {
      'question': 'Which animal has horns?',
      'options': ['Cat', 'Dog', 'Bull', 'Rabbit'],
      'answer': 'Bull',
      'category': 'Animals',
    },

    // Additional GK Questions (15)
    {
      'question': 'How many colors are in a rainbow?',
      'options': ['5', '6', '7', '8'],
      'answer': '7',
      'category': 'GK',
    },
    {
      'question': 'What is the national flower of India?',
      'options': ['Rose', 'Lotus', 'Sunflower', 'Lily'],
      'answer': 'Lotus',
      'category': 'GK',
    },
    {
      'question': 'Which is the hottest planet?',
      'options': ['Mercury', 'Venus', 'Mars', 'Jupiter'],
      'answer': 'Venus',
      'category': 'GK',
    },
    {
      'question': 'How many players in a cricket team?',
      'options': ['9', '10', '11', '12'],
      'answer': '11',
      'category': 'GK',
    },
    {
      'question': 'Which season comes after winter?',
      'options': ['Autumn', 'Summer', 'Spring', 'Monsoon'],
      'answer': 'Spring',
      'category': 'GK',
    },
    {
      'question': 'What is the national game of India?',
      'options': ['Cricket', 'Hockey', 'Football', 'Kabaddi'],
      'answer': 'Hockey',
      'category': 'GK',
    },
    {
      'question': 'How many weeks are in a year?',
      'options': ['50', '51', '52', '53'],
      'answer': '52',
      'category': 'GK',
    },
    {
      'question': 'Which planet has rings?',
      'options': ['Mars', 'Venus', 'Saturn', 'Mercury'],
      'answer': 'Saturn',
      'category': 'GK',
    },
    {
      'question': 'What gas do plants release?',
      'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
      'answer': 'Oxygen',
      'category': 'GK',
    },
    {
      'question': 'Which is the largest country?',
      'options': ['USA', 'China', 'Russia', 'India'],
      'answer': 'Russia',
      'category': 'GK',
    },
    {
      'question': 'How many sides does a triangle have?',
      'options': ['2', '3', '4', '5'],
      'answer': '3',
      'category': 'GK',
    },
    {
      'question': 'Which is the smallest continent?',
      'options': ['Africa', 'Europe', 'Australia', 'Antarctica'],
      'answer': 'Australia',
      'category': 'GK',
    },
    {
      'question': 'What is baby cat called?',
      'options': ['Puppy', 'Kitten', 'Calf', 'Cub'],
      'answer': 'Kitten',
      'category': 'GK',
    },
    {
      'question': 'How many eyes do spiders have?',
      'options': ['2', '4', '6', '8'],
      'answer': '8',
      'category': 'GK',
    },
    {
      'question': 'Which animal is known as gentle giant?',
      'options': ['Lion', 'Elephant', 'Tiger', 'Bear'],
      'answer': 'Elephant',
      'category': 'GK',
    },
  ];

  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  bool _answered = false;
  bool _isCorrect = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _setupQuiz();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _feedbackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );

    _isInitialized = true;
  }

  void _setupQuiz() {
    _questions = List.from(_allQuestions);
    _questions.shuffle(math.Random());
    _questions = _questions.take(50).toList(); // 50 questions per quiz
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _answered = false;
    _isCorrect = false;
    _selectedAnswer = null;
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bubbleController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  // Floating bubbles for playful effect
  List<Widget> _buildFloatingBubbles() {
    if (!_isInitialized) return [];

    final random = math.Random(42);
    return List.generate(12, (index) {
      final size = 20.0 + random.nextDouble() * 50;
      final left = random.nextDouble() * 400;
      final top = random.nextDouble() * 800;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          final progress = (_bubbleController.value + delay) % 1.0;
          final yOffset = -progress * 200;
          final opacity = (1 - progress) * 0.15;

          return Positioned(
            left: left,
            top: top + yOffset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: opacity),
                    Colors.white.withValues(alpha: opacity * 0.3),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void _selectAnswer(String answer) {
    if (_answered) return;

    final isCorrect = answer == _questions[_currentQuestionIndex]['answer'];

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctAnswers++;
      _score += 10;
      _feedbackController.forward(from: 0);
    }
  }

  void _goToNextQuestion() {
    if (!_answered || !_isCorrect) return;

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _isCorrect = false;
        _selectedAnswer = null;
      });
    } else {
      _showResults();
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _answered = false;
        _isCorrect = false;
        _selectedAnswer = null;
      });
    }
  }

  void _clearAndTryAgain() {
    setState(() {
      _answered = false;
      _isCorrect = false;
      _selectedAnswer = null;
    });
  }

  void _resetQuiz() {
    setState(() {
      _setupQuiz();
    });
  }

  RewardsService get _rewardsService {
    if (!Get.isRegistered<RewardsService>()) {
      Get.put(RewardsService(), permanent: true);
    }
    return Get.find<RewardsService>();
  }

  DailyGoalsService get _dailyGoalsService {
    if (!Get.isRegistered<DailyGoalsService>()) {
      Get.put(DailyGoalsService(), permanent: true);
    }
    return Get.find<DailyGoalsService>();
  }

  void _showResults() {
    // Award rewards based on performance
    _rewardsService.addStars(_correctAnswers);
    _rewardsService.addXP(_score);

    if (_correctAnswers == _questions.length) {
      _rewardsService.awardBadge('perfectionist');
    }

    // Update daily goals
    try {
      _dailyGoalsService.incrementGoalProgress('complete_1_quiz');
    } catch (e) {
      // Daily goals service not available
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result emoji based on score
            Text(
              _correctAnswers >= 40
                  ? "🏆"
                  : _correctAnswers >= 25
                  ? "⭐"
                  : "📚",
              style: const TextStyle(fontSize: 70),
            ),
            const SizedBox(height: 16),
            Text(
              _correctAnswers >= 40
                  ? 'Excellent!'
                  : _correctAnswers >= 25
                  ? 'Good Job!'
                  : 'Keep Practicing!',
              style: GoogleFonts.baloo2(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _correctAnswers >= 40
                    ? Colors.green
                    : _correctAnswers >= 25
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Correct Answers:',
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                      Text(
                        '$_correctAnswers / ${_questions.length}',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Score:', style: GoogleFonts.nunito(fontSize: 16)),
                      Text(
                        '$_score points',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stars Earned:',
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                      Text(
                        '⭐ $_correctAnswers',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Exit',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      setState(() {
                        _setupQuiz();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF56D97F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Play Again',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || !_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentQuestionIndex];
    final options = question['options'] as List<String>;
    final progress = (_currentQuestionIndex + 1) / _questions.length;
    final progressPercent = (progress * 100).toInt();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
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
            onPressed: _resetQuiz,
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        title: Text(
          "Quiz Time",
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
              Color(0xFFf5576c),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating bubbles background
            ..._buildFloatingBubbles(),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Progress Bar with percentage
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$progressPercent%',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Question Card with animation
                  if (_isInitialized)
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value * 0.3),
                          child: child,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text('❓', style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              question['question'],
                              style: GoogleFonts.nunito(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Options
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ...options.asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value;
                            final isSelected = _selectedAnswer == option;
                            final isCorrect = option == question['answer'];
                            final showResult = _answered;

                            Color bgColor = Colors.white;
                            Color textColor = Colors.black87;
                            IconData? icon;
                            List<Color> gradientColors = [
                              Colors.white,
                              Colors.white,
                            ];

                            if (showResult) {
                              if (isCorrect) {
                                gradientColors = [
                                  const Color(0xFF56D97F),
                                  const Color(0xFF11998E),
                                ];
                                textColor = Colors.white;
                                icon = Icons.check_circle;
                              } else if (isSelected) {
                                gradientColors = [
                                  const Color(0xFFFF6B6B),
                                  const Color(0xFFFF8E53),
                                ];
                                textColor = Colors.white;
                                icon = Icons.cancel;
                              }
                            }

                            final optionLabels = ['A', 'B', 'C', 'D'];

                            return GestureDetector(
                              onTap: () => _selectAnswer(option),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient:
                                      showResult && (isCorrect || isSelected)
                                      ? LinearGradient(colors: gradientColors)
                                      : null,
                                  color: showResult && (isCorrect || isSelected)
                                      ? null
                                      : bgColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: isSelected && !showResult
                                      ? Border.all(
                                          color: const Color(0xFF56D97F),
                                          width: 3,
                                        )
                                      : Border.all(
                                          color: Colors.grey.shade200,
                                          width: 1,
                                        ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color:
                                            showResult &&
                                                (isCorrect || isSelected)
                                            ? Colors.white.withValues(
                                                alpha: 0.3,
                                              )
                                            : const Color(
                                                0xFF667EEA,
                                              ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          optionLabels[index],
                                          style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                showResult &&
                                                    (isCorrect || isSelected)
                                                ? Colors.white
                                                : const Color(0xFF667EEA),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    if (icon != null)
                                      Icon(icon, color: Colors.white, size: 28),
                                  ],
                                ),
                              ),
                            );
                          }),

                          // Feedback message and Clear button in a Row (when wrong)
                          if (_answered && !_isCorrect)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  // Wrong message
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '✗ Wrong! Try again!',
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Clear button
                                  ElevatedButton.icon(
                                    onPressed: _clearAndTryAgain,
                                    icon: const Icon(Icons.refresh, size: 20),
                                    label: Text(
                                      'Clear',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Correct message
                          if (_answered && _isCorrect)
                            AnimatedBuilder(
                              animation: _feedbackAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _feedbackAnimation.value,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '✓ Correct! Great job!',
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Navigation buttons
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        // Previous button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _currentQuestionIndex > 0
                                ? _goToPreviousQuestion
                                : null,
                            icon: const Icon(Icons.arrow_back_ios, size: 18),
                            label: Text(
                              'Previous',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.9,
                              ),
                              foregroundColor: const Color(0xFF667EEA),
                              disabledBackgroundColor: Colors.white.withValues(
                                alpha: 0.3,
                              ),
                              disabledForegroundColor: Colors.white.withValues(
                                alpha: 0.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Next button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: (_answered && _isCorrect)
                                ? _goToNextQuestion
                                : null,
                            icon: Text(
                              _currentQuestionIndex == _questions.length - 1
                                  ? 'Finish'
                                  : 'Next',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            label: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF56D97F),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.withValues(
                                alpha: 0.5,
                              ),
                              disabledForegroundColor: Colors.white.withValues(
                                alpha: 0.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdsScreen(),
    );
  }
}
