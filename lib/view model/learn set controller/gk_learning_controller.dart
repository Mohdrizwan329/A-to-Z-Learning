import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiyan_learning/services/progress_service.dart';

class GKLearningController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final GetStorage box = GetStorage();

  ProgressService get _progressService {
    if (!Get.isRegistered<ProgressService>()) {
      Get.put(ProgressService(), permanent: true);
    }
    return Get.find<ProgressService>();
  }

  final RxInt currentIndex = 0.obs;
  final RxBool showAnswer = false.obs;
  final RxString selectedCategory = 'Space'.obs;

  static const String _cacheKey = 'gk_progress_index';

  // All available categories
  final List<String> categories = [
    'Space',
    'Animals',
    'Human Body',
    'India',
    'Science',
    'Geography',
    'Numbers',
    'Inventions',
    'Sports',
    'General',
    'Science & Technology',
    'Environment',
    'Countries',
    'History',
  ];

  final List<Map<String, String>> gkQuestions = [
    // Solar System & Space (20 questions)
    {'question': 'Which planet is called the Red Planet?', 'answer': 'Mars', 'category': 'Space', 'emoji': '🔴'},
    {'question': 'What is the closest star to Earth?', 'answer': 'The Sun', 'category': 'Space', 'emoji': '☀️'},
    {'question': 'How many planets are in our solar system?', 'answer': '8 Planets', 'category': 'Space', 'emoji': '🪐'},
    {'question': 'Which is the largest planet?', 'answer': 'Jupiter', 'category': 'Space', 'emoji': '🌍'},
    {'question': 'Who was the first man on the Moon?', 'answer': 'Neil Armstrong', 'category': 'Space', 'emoji': '🌙'},
    {'question': 'Which planet is known for its rings?', 'answer': 'Saturn', 'category': 'Space', 'emoji': '🪐'},
    {'question': 'What is the smallest planet?', 'answer': 'Mercury', 'category': 'Space', 'emoji': '🌑'},
    {'question': 'Which planet is closest to the Sun?', 'answer': 'Mercury', 'category': 'Space', 'emoji': '☀️'},
    {'question': 'What is the hottest planet?', 'answer': 'Venus', 'category': 'Space', 'emoji': '🔥'},
    {'question': 'Which planet rotates on its side?', 'answer': 'Uranus', 'category': 'Space', 'emoji': '🌀'},
    {'question': 'What is a shooting star?', 'answer': 'A meteor', 'category': 'Space', 'emoji': '⭐'},
    {'question': 'What is the Milky Way?', 'answer': 'Our Galaxy', 'category': 'Space', 'emoji': '🌌'},
    {'question': 'Who was the first woman in space?', 'answer': 'Valentina Tereshkova', 'category': 'Space', 'emoji': '👩‍🚀'},
    {'question': 'What is an astronaut?', 'answer': 'Person who travels to space', 'category': 'Space', 'emoji': '🧑‍🚀'},
    {'question': 'How long does Earth take to orbit the Sun?', 'answer': '365 days (1 year)', 'category': 'Space', 'emoji': '🌍'},
    {'question': 'What causes day and night?', 'answer': 'Earth rotation', 'category': 'Space', 'emoji': '🌓'},
    {'question': 'What is a constellation?', 'answer': 'Group of stars forming pattern', 'category': 'Space', 'emoji': '✨'},
    {'question': 'Which planet has the Great Red Spot?', 'answer': 'Jupiter', 'category': 'Space', 'emoji': '🔴'},
    {'question': 'What is the Moon made of?', 'answer': 'Rock and dust', 'category': 'Space', 'emoji': '🌙'},
    {'question': 'Who was the first Indian in space?', 'answer': 'Rakesh Sharma', 'category': 'Space', 'emoji': '🇮🇳'},
    {'question': 'What is a black hole?', 'answer': 'Region with strong gravity', 'category': 'Space', 'emoji': '🕳️'},
    {'question': 'Which planet is called Earth twin?', 'answer': 'Venus', 'category': 'Space', 'emoji': '🌍'},
    {'question': 'What is a comet made of?', 'answer': 'Ice and dust', 'category': 'Space', 'emoji': '☄️'},
    {'question': 'How many moons does Mars have?', 'answer': '2 Moons', 'category': 'Space', 'emoji': '🌙'},
    {'question': 'What is the name of our galaxy?', 'answer': 'Milky Way', 'category': 'Space', 'emoji': '🌌'},
    {'question': 'Which planet has the most moons?', 'answer': 'Saturn', 'category': 'Space', 'emoji': '🪐'},
    {'question': 'What causes a solar eclipse?', 'answer': 'Moon blocks Sun', 'category': 'Space', 'emoji': '🌑'},
    {'question': 'What causes a lunar eclipse?', 'answer': 'Earth blocks sunlight to Moon', 'category': 'Space', 'emoji': '🌕'},
    {'question': 'What is ISS?', 'answer': 'International Space Station', 'category': 'Space', 'emoji': '🛸'},
    {'question': 'Which is the coldest planet?', 'answer': 'Neptune', 'category': 'Space', 'emoji': '🥶'},
    {'question': 'What is a light year?', 'answer': 'Distance light travels in one year', 'category': 'Space', 'emoji': '💫'},
    {'question': 'Who was the first person in space?', 'answer': 'Yuri Gagarin', 'category': 'Space', 'emoji': '🧑‍🚀'},
    {'question': 'What is the Sun made of?', 'answer': 'Hydrogen and Helium', 'category': 'Space', 'emoji': '☀️'},
    {'question': 'Which planet spins backwards?', 'answer': 'Venus', 'category': 'Space', 'emoji': '🔄'},
    {'question': 'What is an asteroid?', 'answer': 'Rocky object in space', 'category': 'Space', 'emoji': '🪨'},
    {'question': 'How old is the Sun?', 'answer': 'About 4.6 billion years', 'category': 'Space', 'emoji': '☀️'},
    {'question': 'What is ISRO?', 'answer': 'Indian Space Research Organisation', 'category': 'Space', 'emoji': '🚀'},
    {'question': 'Which planet has the shortest day?', 'answer': 'Jupiter (10 hours)', 'category': 'Space', 'emoji': '⏰'},
    {'question': 'What is the Big Bang?', 'answer': 'Theory of universe origin', 'category': 'Space', 'emoji': '💥'},

    // Animals (20 questions)
    {'question': 'Which is the largest animal on Earth?', 'answer': 'Blue Whale', 'category': 'Animals', 'emoji': '🐋'},
    {'question': 'Which animal is known as the King of the Jungle?', 'answer': 'Lion', 'category': 'Animals', 'emoji': '🦁'},
    {'question': 'How many legs does a spider have?', 'answer': '8 Legs', 'category': 'Animals', 'emoji': '🕷️'},
    {'question': 'Which bird cannot fly?', 'answer': 'Ostrich, Penguin, Kiwi', 'category': 'Animals', 'emoji': '🐧'},
    {'question': 'Which is the fastest animal?', 'answer': 'Cheetah', 'category': 'Animals', 'emoji': '🐆'},
    {'question': 'Which animal has a long trunk?', 'answer': 'Elephant', 'category': 'Animals', 'emoji': '🐘'},
    {'question': 'Which animal is called ship of the desert?', 'answer': 'Camel', 'category': 'Animals', 'emoji': '🐪'},
    {'question': 'How many legs does a butterfly have?', 'answer': '6 Legs', 'category': 'Animals', 'emoji': '🦋'},
    {'question': 'Which animal gives us wool?', 'answer': 'Sheep', 'category': 'Animals', 'emoji': '🐑'},
    {'question': 'Which is the tallest animal?', 'answer': 'Giraffe', 'category': 'Animals', 'emoji': '🦒'},
    {'question': 'Which animal has black and white stripes?', 'answer': 'Zebra', 'category': 'Animals', 'emoji': '🦓'},
    {'question': 'Which animal lives in a den?', 'answer': 'Lion', 'category': 'Animals', 'emoji': '🦁'},
    {'question': 'Which animal gives us milk?', 'answer': 'Cow', 'category': 'Animals', 'emoji': '🐄'},
    {'question': 'Which bird is known for its colorful feathers?', 'answer': 'Peacock', 'category': 'Animals', 'emoji': '🦚'},
    {'question': 'Which animal hangs upside down?', 'answer': 'Bat', 'category': 'Animals', 'emoji': '🦇'},
    {'question': 'Which animal has a shell on its back?', 'answer': 'Tortoise/Turtle', 'category': 'Animals', 'emoji': '🐢'},
    {'question': 'Which animal says "Meow"?', 'answer': 'Cat', 'category': 'Animals', 'emoji': '🐱'},
    {'question': 'Which animal says "Woof"?', 'answer': 'Dog', 'category': 'Animals', 'emoji': '🐕'},
    {'question': 'Which animal has a pouch?', 'answer': 'Kangaroo', 'category': 'Animals', 'emoji': '🦘'},
    {'question': 'Which animal is known as mans best friend?', 'answer': 'Dog', 'category': 'Animals', 'emoji': '🐶'},
    {'question': 'Which is the slowest animal?', 'answer': 'Sloth', 'category': 'Animals', 'emoji': '🦥'},
    {'question': 'Which animal has the longest neck?', 'answer': 'Giraffe', 'category': 'Animals', 'emoji': '🦒'},
    {'question': 'Which animal is called the ship of desert?', 'answer': 'Camel', 'category': 'Animals', 'emoji': '🐫'},
    {'question': 'How many legs does an octopus have?', 'answer': '8 Legs', 'category': 'Animals', 'emoji': '🐙'},
    {'question': 'Which is the smallest bird?', 'answer': 'Hummingbird', 'category': 'Animals', 'emoji': '🐦'},
    {'question': 'Which animal is known for changing colors?', 'answer': 'Chameleon', 'category': 'Animals', 'emoji': '🦎'},
    {'question': 'What is a group of wolves called?', 'answer': 'Pack', 'category': 'Animals', 'emoji': '🐺'},
    {'question': 'Which animal produces honey?', 'answer': 'Bee', 'category': 'Animals', 'emoji': '🐝'},
    {'question': 'Which is the largest bird?', 'answer': 'Ostrich', 'category': 'Animals', 'emoji': '🦤'},
    {'question': 'Which animal is known for its memory?', 'answer': 'Elephant', 'category': 'Animals', 'emoji': '🐘'},
    {'question': 'What is a baby horse called?', 'answer': 'Foal', 'category': 'Animals', 'emoji': '🐴'},
    {'question': 'Which animal can live without water longest?', 'answer': 'Camel', 'category': 'Animals', 'emoji': '🐪'},
    {'question': 'Which animal has the sharpest eyesight?', 'answer': 'Eagle', 'category': 'Animals', 'emoji': '🦅'},
    {'question': 'What is a group of crows called?', 'answer': 'Murder', 'category': 'Animals', 'emoji': '🐦‍⬛'},
    {'question': 'Which animal sleeps standing up?', 'answer': 'Horse', 'category': 'Animals', 'emoji': '🐎'},
    {'question': 'Which is the national animal of Australia?', 'answer': 'Kangaroo', 'category': 'Animals', 'emoji': '🦘'},
    {'question': 'Which animal has the longest lifespan?', 'answer': 'Tortoise', 'category': 'Animals', 'emoji': '🐢'},
    {'question': 'What is a baby frog called?', 'answer': 'Tadpole', 'category': 'Animals', 'emoji': '🐸'},
    {'question': 'Which animal uses echolocation?', 'answer': 'Bat and Dolphin', 'category': 'Animals', 'emoji': '🦇'},

    // Human Body (20 questions)
    {'question': 'How many bones are in the human body?', 'answer': '206 Bones', 'category': 'Human Body', 'emoji': '🦴'},
    {'question': 'Which organ pumps blood in our body?', 'answer': 'Heart', 'category': 'Human Body', 'emoji': '❤️'},
    {'question': 'How many teeth does an adult have?', 'answer': '32 Teeth', 'category': 'Human Body', 'emoji': '🦷'},
    {'question': 'What is the largest organ of the body?', 'answer': 'Skin', 'category': 'Human Body', 'emoji': '👋'},
    {'question': 'Which part of the body helps us think?', 'answer': 'Brain', 'category': 'Human Body', 'emoji': '🧠'},
    {'question': 'How many senses do we have?', 'answer': '5 Senses', 'category': 'Human Body', 'emoji': '👁️'},
    {'question': 'Which organ helps us breathe?', 'answer': 'Lungs', 'category': 'Human Body', 'emoji': '🫁'},
    {'question': 'What color is blood?', 'answer': 'Red', 'category': 'Human Body', 'emoji': '🩸'},
    {'question': 'How many eyes do we have?', 'answer': '2 Eyes', 'category': 'Human Body', 'emoji': '👀'},
    {'question': 'Which part helps us hear?', 'answer': 'Ears', 'category': 'Human Body', 'emoji': '👂'},
    {'question': 'Which part helps us smell?', 'answer': 'Nose', 'category': 'Human Body', 'emoji': '👃'},
    {'question': 'How many fingers do we have?', 'answer': '10 Fingers', 'category': 'Human Body', 'emoji': '🖐️'},
    {'question': 'What protects our brain?', 'answer': 'Skull', 'category': 'Human Body', 'emoji': '💀'},
    {'question': 'Which part helps us taste?', 'answer': 'Tongue', 'category': 'Human Body', 'emoji': '👅'},
    {'question': 'What carries blood in our body?', 'answer': 'Blood vessels', 'category': 'Human Body', 'emoji': '🩸'},
    {'question': 'How many lungs do we have?', 'answer': '2 Lungs', 'category': 'Human Body', 'emoji': '🫁'},
    {'question': 'What helps us move our body?', 'answer': 'Muscles', 'category': 'Human Body', 'emoji': '💪'},
    {'question': 'Where is food digested?', 'answer': 'Stomach', 'category': 'Human Body', 'emoji': '🫃'},
    {'question': 'What gives color to our skin?', 'answer': 'Melanin', 'category': 'Human Body', 'emoji': '🎨'},
    {'question': 'How many chambers does the heart have?', 'answer': '4 Chambers', 'category': 'Human Body', 'emoji': '❤️'},
    {'question': 'What is the smallest bone in body?', 'answer': 'Stapes (in ear)', 'category': 'Human Body', 'emoji': '🦴'},
    {'question': 'What is the largest bone in body?', 'answer': 'Femur (thigh bone)', 'category': 'Human Body', 'emoji': '🦴'},
    {'question': 'How many muscles are in human body?', 'answer': 'Over 600 muscles', 'category': 'Human Body', 'emoji': '💪'},
    {'question': 'What is the hardest substance in body?', 'answer': 'Tooth enamel', 'category': 'Human Body', 'emoji': '🦷'},
    {'question': 'How many kidneys do we have?', 'answer': '2 Kidneys', 'category': 'Human Body', 'emoji': '🫘'},
    {'question': 'What do kidneys filter?', 'answer': 'Blood', 'category': 'Human Body', 'emoji': '🩸'},
    {'question': 'What carries oxygen in blood?', 'answer': 'Red blood cells', 'category': 'Human Body', 'emoji': '🔴'},
    {'question': 'What fights germs in our body?', 'answer': 'White blood cells', 'category': 'Human Body', 'emoji': '⚪'},
    {'question': 'How many ribs do we have?', 'answer': '24 Ribs (12 pairs)', 'category': 'Human Body', 'emoji': '🦴'},
    {'question': 'What connects muscles to bones?', 'answer': 'Tendons', 'category': 'Human Body', 'emoji': '🔗'},
    {'question': 'What connects bones to bones?', 'answer': 'Ligaments', 'category': 'Human Body', 'emoji': '🔗'},
    {'question': 'What is the voice box called?', 'answer': 'Larynx', 'category': 'Human Body', 'emoji': '🗣️'},
    {'question': 'How many vertebrae in spine?', 'answer': '33 Vertebrae', 'category': 'Human Body', 'emoji': '🦴'},
    {'question': 'What controls body temperature?', 'answer': 'Hypothalamus', 'category': 'Human Body', 'emoji': '🌡️'},
    {'question': 'What is the windpipe called?', 'answer': 'Trachea', 'category': 'Human Body', 'emoji': '🌬️'},
    {'question': 'How many toes do we have?', 'answer': '10 Toes', 'category': 'Human Body', 'emoji': '🦶'},
    {'question': 'What produces insulin?', 'answer': 'Pancreas', 'category': 'Human Body', 'emoji': '🏥'},
    {'question': 'What is the colored part of eye?', 'answer': 'Iris', 'category': 'Human Body', 'emoji': '👁️'},
    {'question': 'How many taste buds do we have?', 'answer': 'About 10,000', 'category': 'Human Body', 'emoji': '👅'},

    // India (20 questions)
    {'question': 'What is the capital of India?', 'answer': 'New Delhi', 'category': 'India', 'emoji': '🇮🇳'},
    {'question': 'What is the national animal of India?', 'answer': 'Tiger', 'category': 'India', 'emoji': '🐅'},
    {'question': 'What is the national bird of India?', 'answer': 'Peacock', 'category': 'India', 'emoji': '🦚'},
    {'question': 'What is the national flower of India?', 'answer': 'Lotus', 'category': 'India', 'emoji': '🪷'},
    {'question': 'How many states are in India?', 'answer': '28 States', 'category': 'India', 'emoji': '🗺️'},
    {'question': 'What is the national fruit of India?', 'answer': 'Mango', 'category': 'India', 'emoji': '🥭'},
    {'question': 'What is the national game of India?', 'answer': 'Hockey', 'category': 'India', 'emoji': '🏑'},
    {'question': 'What is the national anthem of India?', 'answer': 'Jana Gana Mana', 'category': 'India', 'emoji': '🎵'},
    {'question': 'Who wrote the national anthem?', 'answer': 'Rabindranath Tagore', 'category': 'India', 'emoji': '✍️'},
    {'question': 'What is the currency of India?', 'answer': 'Indian Rupee', 'category': 'India', 'emoji': '💰'},
    {'question': 'Which is the longest river in India?', 'answer': 'Ganga', 'category': 'India', 'emoji': '🏞️'},
    {'question': 'What is the national tree of India?', 'answer': 'Banyan Tree', 'category': 'India', 'emoji': '🌳'},
    {'question': 'Which is the largest state of India?', 'answer': 'Rajasthan', 'category': 'India', 'emoji': '🏜️'},
    {'question': 'Which is the smallest state of India?', 'answer': 'Goa', 'category': 'India', 'emoji': '🏖️'},
    {'question': 'What is Indias national song?', 'answer': 'Vande Mataram', 'category': 'India', 'emoji': '🎶'},
    {'question': 'Which city is known as Pink City?', 'answer': 'Jaipur', 'category': 'India', 'emoji': '🏰'},
    {'question': 'Which monument is in Agra?', 'answer': 'Taj Mahal', 'category': 'India', 'emoji': '🕌'},
    {'question': 'What is the national aquatic animal?', 'answer': 'Ganges River Dolphin', 'category': 'India', 'emoji': '🐬'},
    {'question': 'Which is the highest peak in India?', 'answer': 'Kanchenjunga', 'category': 'India', 'emoji': '🏔️'},
    {'question': 'What is Republic Day date?', 'answer': '26 January', 'category': 'India', 'emoji': '🎉'},
    {'question': 'What is Independence Day date?', 'answer': '15 August', 'category': 'India', 'emoji': '🇮🇳'},
    {'question': 'Who is known as Missile Man of India?', 'answer': 'APJ Abdul Kalam', 'category': 'India', 'emoji': '🚀'},
    {'question': 'Which is the national river of India?', 'answer': 'Ganga', 'category': 'India', 'emoji': '🏞️'},
    {'question': 'Which city is called Silicon Valley of India?', 'answer': 'Bangalore', 'category': 'India', 'emoji': '💻'},
    {'question': 'Which is the largest city of India?', 'answer': 'Mumbai', 'category': 'India', 'emoji': '🏙️'},
    {'question': 'What is the national emblem of India?', 'answer': 'Lion Capital of Ashoka', 'category': 'India', 'emoji': '🦁'},
    {'question': 'Which dance is from Kerala?', 'answer': 'Kathakali', 'category': 'India', 'emoji': '💃'},
    {'question': 'Which festival is called Festival of Lights?', 'answer': 'Diwali', 'category': 'India', 'emoji': '🪔'},
    {'question': 'Which festival is called Festival of Colors?', 'answer': 'Holi', 'category': 'India', 'emoji': '🎨'},
    {'question': 'Who wrote Vande Mataram?', 'answer': 'Bankim Chandra Chatterjee', 'category': 'India', 'emoji': '✍️'},
    {'question': 'Which is the longest bridge in India?', 'answer': 'Bhupen Hazarika Setu', 'category': 'India', 'emoji': '🌉'},
    {'question': 'What is the national sport of India?', 'answer': 'Hockey', 'category': 'India', 'emoji': '🏑'},
    {'question': 'Which is the southernmost point of India?', 'answer': 'Kanyakumari', 'category': 'India', 'emoji': '🧭'},
    {'question': 'How many Union Territories in India?', 'answer': '8 Union Territories', 'category': 'India', 'emoji': '🗺️'},
    {'question': 'Which language is most spoken in India?', 'answer': 'Hindi', 'category': 'India', 'emoji': '🗣️'},
    {'question': 'What is the national motto of India?', 'answer': 'Satyameva Jayate', 'category': 'India', 'emoji': '📜'},
    {'question': 'Which is the hottest place in India?', 'answer': 'Sri Ganganagar, Rajasthan', 'category': 'India', 'emoji': '🌡️'},
    {'question': 'Which is the coldest place in India?', 'answer': 'Dras, Ladakh', 'category': 'India', 'emoji': '❄️'},
    {'question': 'Who was first woman PM of India?', 'answer': 'Indira Gandhi', 'category': 'India', 'emoji': '👩'},

    // Science (20 questions)
    {'question': 'What do plants need to make food?', 'answer': 'Sunlight, Water, Air', 'category': 'Science', 'emoji': '🌱'},
    {'question': 'What is H2O commonly known as?', 'answer': 'Water', 'category': 'Science', 'emoji': '💧'},
    {'question': 'What gas do we breathe in?', 'answer': 'Oxygen', 'category': 'Science', 'emoji': '🌬️'},
    {'question': 'What gas do plants release?', 'answer': 'Oxygen', 'category': 'Science', 'emoji': '🌳'},
    {'question': 'How many colors are in a rainbow?', 'answer': '7 Colors', 'category': 'Science', 'emoji': '🌈'},
    {'question': 'What is the process plants use to make food?', 'answer': 'Photosynthesis', 'category': 'Science', 'emoji': '🌿'},
    {'question': 'What are the three states of matter?', 'answer': 'Solid, Liquid, Gas', 'category': 'Science', 'emoji': '🧊'},
    {'question': 'What makes things fall down?', 'answer': 'Gravity', 'category': 'Science', 'emoji': '🍎'},
    {'question': 'What is the center of an atom called?', 'answer': 'Nucleus', 'category': 'Science', 'emoji': '⚛️'},
    {'question': 'What type of energy does the Sun give?', 'answer': 'Light and Heat', 'category': 'Science', 'emoji': '☀️'},
    {'question': 'What do magnets attract?', 'answer': 'Iron and Steel', 'category': 'Science', 'emoji': '🧲'},
    {'question': 'What is the formula for water?', 'answer': 'H2O', 'category': 'Science', 'emoji': '💧'},
    {'question': 'What gas do we breathe out?', 'answer': 'Carbon Dioxide', 'category': 'Science', 'emoji': '💨'},
    {'question': 'What is evaporation?', 'answer': 'Liquid turning to gas', 'category': 'Science', 'emoji': '♨️'},
    {'question': 'What is condensation?', 'answer': 'Gas turning to liquid', 'category': 'Science', 'emoji': '💦'},
    {'question': 'What causes shadows?', 'answer': 'Blocking of light', 'category': 'Science', 'emoji': '🌑'},
    {'question': 'What is the study of living things?', 'answer': 'Biology', 'category': 'Science', 'emoji': '🔬'},
    {'question': 'What is friction?', 'answer': 'Force that slows motion', 'category': 'Science', 'emoji': '🛑'},
    {'question': 'What are the primary colors?', 'answer': 'Red, Blue, Yellow', 'category': 'Science', 'emoji': '🎨'},
    {'question': 'What is temperature measured in?', 'answer': 'Celsius or Fahrenheit', 'category': 'Science', 'emoji': '🌡️'},
    {'question': 'What is the chemical symbol for water?', 'answer': 'H2O', 'category': 'Science', 'emoji': '💧'},
    {'question': 'What is the chemical symbol for oxygen?', 'answer': 'O2', 'category': 'Science', 'emoji': '🌬️'},
    {'question': 'What is the study of stars called?', 'answer': 'Astronomy', 'category': 'Science', 'emoji': '⭐'},
    {'question': 'What is the study of weather called?', 'answer': 'Meteorology', 'category': 'Science', 'emoji': '🌤️'},
    {'question': 'What makes up everything?', 'answer': 'Atoms', 'category': 'Science', 'emoji': '⚛️'},
    {'question': 'What is the fourth state of matter?', 'answer': 'Plasma', 'category': 'Science', 'emoji': '⚡'},
    {'question': 'What is sound measured in?', 'answer': 'Decibels', 'category': 'Science', 'emoji': '🔊'},
    {'question': 'What gives plants green color?', 'answer': 'Chlorophyll', 'category': 'Science', 'emoji': '🌿'},
    {'question': 'What is the study of animals called?', 'answer': 'Zoology', 'category': 'Science', 'emoji': '🦁'},
    {'question': 'What is the study of plants called?', 'answer': 'Botany', 'category': 'Science', 'emoji': '🌱'},
    {'question': 'What type of energy is stored in food?', 'answer': 'Chemical energy', 'category': 'Science', 'emoji': '🍎'},
    {'question': 'What is the unit of force?', 'answer': 'Newton', 'category': 'Science', 'emoji': '💪'},
    {'question': 'What is the unit of electric current?', 'answer': 'Ampere', 'category': 'Science', 'emoji': '⚡'},
    {'question': 'What causes rust?', 'answer': 'Oxygen and water', 'category': 'Science', 'emoji': '🔩'},
    {'question': 'What is melting?', 'answer': 'Solid to liquid', 'category': 'Science', 'emoji': '🧊'},
    {'question': 'What is freezing?', 'answer': 'Liquid to solid', 'category': 'Science', 'emoji': '❄️'},
    {'question': 'What is sublimation?', 'answer': 'Solid to gas directly', 'category': 'Science', 'emoji': '💨'},
    {'question': 'What instrument measures temperature?', 'answer': 'Thermometer', 'category': 'Science', 'emoji': '🌡️'},
    {'question': 'What instrument measures air pressure?', 'answer': 'Barometer', 'category': 'Science', 'emoji': '📊'},

    // Geography (20 questions)
    {'question': 'Which is the largest ocean?', 'answer': 'Pacific Ocean', 'category': 'Geography', 'emoji': '🌊'},
    {'question': 'Which is the longest river?', 'answer': 'Nile River', 'category': 'Geography', 'emoji': '🏞️'},
    {'question': 'Which is the highest mountain?', 'answer': 'Mount Everest', 'category': 'Geography', 'emoji': '🏔️'},
    {'question': 'Which is the largest country?', 'answer': 'Russia', 'category': 'Geography', 'emoji': '🗺️'},
    {'question': 'Which is the smallest country?', 'answer': 'Vatican City', 'category': 'Geography', 'emoji': '🏰'},
    {'question': 'How many continents are there?', 'answer': '7 Continents', 'category': 'Geography', 'emoji': '🌍'},
    {'question': 'Which is the largest continent?', 'answer': 'Asia', 'category': 'Geography', 'emoji': '🌏'},
    {'question': 'Which is the smallest continent?', 'answer': 'Australia', 'category': 'Geography', 'emoji': '🦘'},
    {'question': 'What is the capital of USA?', 'answer': 'Washington D.C.', 'category': 'Geography', 'emoji': '🇺🇸'},
    {'question': 'Which ocean is the coldest?', 'answer': 'Arctic Ocean', 'category': 'Geography', 'emoji': '🧊'},
    {'question': 'Which is the deepest ocean?', 'answer': 'Pacific Ocean', 'category': 'Geography', 'emoji': '🌊'},
    {'question': 'Which country has the most islands?', 'answer': 'Sweden', 'category': 'Geography', 'emoji': '🏝️'},
    {'question': 'What is the largest island?', 'answer': 'Greenland', 'category': 'Geography', 'emoji': '🏝️'},
    {'question': 'Which river flows through Egypt?', 'answer': 'Nile River', 'category': 'Geography', 'emoji': '🏛️'},
    {'question': 'What is the driest place on Earth?', 'answer': 'Atacama Desert', 'category': 'Geography', 'emoji': '🏜️'},
    {'question': 'Which is the longest mountain range?', 'answer': 'Andes Mountains', 'category': 'Geography', 'emoji': '⛰️'},
    {'question': 'What are the poles of Earth called?', 'answer': 'North and South Pole', 'category': 'Geography', 'emoji': '🧭'},
    {'question': 'Which line divides Earth into two halves?', 'answer': 'Equator', 'category': 'Geography', 'emoji': '🌐'},
    {'question': 'What is a volcano?', 'answer': 'Mountain that erupts lava', 'category': 'Geography', 'emoji': '🌋'},
    {'question': 'Which country has the most people?', 'answer': 'India', 'category': 'Geography', 'emoji': '👨‍👩‍👧‍👦'},
    {'question': 'What is the largest lake in the world?', 'answer': 'Caspian Sea', 'category': 'Geography', 'emoji': '🌊'},
    {'question': 'Which is the longest wall in the world?', 'answer': 'Great Wall of China', 'category': 'Geography', 'emoji': '🧱'},
    {'question': 'What is the deepest point on Earth?', 'answer': 'Mariana Trench', 'category': 'Geography', 'emoji': '🌊'},
    {'question': 'Which is the largest waterfall?', 'answer': 'Victoria Falls', 'category': 'Geography', 'emoji': '💧'},
    {'question': 'What is the hottest continent?', 'answer': 'Africa', 'category': 'Geography', 'emoji': '🌍'},
    {'question': 'What is the coldest continent?', 'answer': 'Antarctica', 'category': 'Geography', 'emoji': '🧊'},
    {'question': 'Which ocean is between America and Europe?', 'answer': 'Atlantic Ocean', 'category': 'Geography', 'emoji': '🌊'},
    {'question': 'Which country has most time zones?', 'answer': 'France', 'category': 'Geography', 'emoji': '⏰'},
    {'question': 'What is the capital of Japan?', 'answer': 'Tokyo', 'category': 'Geography', 'emoji': '🇯🇵'},
    {'question': 'Which is the windiest place on Earth?', 'answer': 'Antarctica', 'category': 'Geography', 'emoji': '🌬️'},
    {'question': 'What is the longest river in Asia?', 'answer': 'Yangtze River', 'category': 'Geography', 'emoji': '🏞️'},
    {'question': 'Which sea is the saltiest?', 'answer': 'Dead Sea', 'category': 'Geography', 'emoji': '🧂'},
    {'question': 'What is the largest canyon?', 'answer': 'Grand Canyon', 'category': 'Geography', 'emoji': '🏜️'},
    {'question': 'Which country has the Amazon River?', 'answer': 'Brazil', 'category': 'Geography', 'emoji': '🇧🇷'},
    {'question': 'What are imaginary lines from pole to pole?', 'answer': 'Longitude', 'category': 'Geography', 'emoji': '🌐'},
    {'question': 'What are imaginary lines parallel to equator?', 'answer': 'Latitude', 'category': 'Geography', 'emoji': '🌐'},
    {'question': 'Which is the highest waterfall?', 'answer': 'Angel Falls', 'category': 'Geography', 'emoji': '💧'},
    {'question': 'What is the largest peninsula?', 'answer': 'Arabian Peninsula', 'category': 'Geography', 'emoji': '🏜️'},
    {'question': 'Which strait connects two oceans?', 'answer': 'Strait of Gibraltar', 'category': 'Geography', 'emoji': '⛵'},

    // Numbers & Math (20 questions)
    {'question': 'How many days are in a week?', 'answer': '7 Days', 'category': 'Numbers', 'emoji': '📅'},
    {'question': 'How many months are in a year?', 'answer': '12 Months', 'category': 'Numbers', 'emoji': '🗓️'},
    {'question': 'How many hours are in a day?', 'answer': '24 Hours', 'category': 'Numbers', 'emoji': '⏰'},
    {'question': 'How many minutes are in an hour?', 'answer': '60 Minutes', 'category': 'Numbers', 'emoji': '⏱️'},
    {'question': 'How many sides does a triangle have?', 'answer': '3 Sides', 'category': 'Numbers', 'emoji': '🔺'},
    {'question': 'How many sides does a square have?', 'answer': '4 Sides', 'category': 'Numbers', 'emoji': '⬜'},
    {'question': 'How many sides does a hexagon have?', 'answer': '6 Sides', 'category': 'Numbers', 'emoji': '⬡'},
    {'question': 'What is 5 + 5?', 'answer': '10', 'category': 'Numbers', 'emoji': '➕'},
    {'question': 'What is 10 - 3?', 'answer': '7', 'category': 'Numbers', 'emoji': '➖'},
    {'question': 'What is 4 x 4?', 'answer': '16', 'category': 'Numbers', 'emoji': '✖️'},
    {'question': 'What is 20 ÷ 4?', 'answer': '5', 'category': 'Numbers', 'emoji': '➗'},
    {'question': 'How many seconds in a minute?', 'answer': '60 Seconds', 'category': 'Numbers', 'emoji': '⏲️'},
    {'question': 'How many weeks in a year?', 'answer': '52 Weeks', 'category': 'Numbers', 'emoji': '📆'},
    {'question': 'What comes after 99?', 'answer': '100', 'category': 'Numbers', 'emoji': '💯'},
    {'question': 'How many zeros in 1000?', 'answer': '3 Zeros', 'category': 'Numbers', 'emoji': '0️⃣'},
    {'question': 'What is half of 20?', 'answer': '10', 'category': 'Numbers', 'emoji': '½'},
    {'question': 'How many sides does a pentagon have?', 'answer': '5 Sides', 'category': 'Numbers', 'emoji': '⭐'},
    {'question': 'What is double of 15?', 'answer': '30', 'category': 'Numbers', 'emoji': '2️⃣'},
    {'question': 'How many days in February (normal year)?', 'answer': '28 Days', 'category': 'Numbers', 'emoji': '📅'},
    {'question': 'What is the smallest two-digit number?', 'answer': '10', 'category': 'Numbers', 'emoji': '🔢'},
    {'question': 'What is the largest two-digit number?', 'answer': '99', 'category': 'Numbers', 'emoji': '🔢'},
    {'question': 'How many sides does an octagon have?', 'answer': '8 Sides', 'category': 'Numbers', 'emoji': '🛑'},
    {'question': 'What is 7 x 8?', 'answer': '56', 'category': 'Numbers', 'emoji': '✖️'},
    {'question': 'What is 100 ÷ 5?', 'answer': '20', 'category': 'Numbers', 'emoji': '➗'},
    {'question': 'What is a dozen?', 'answer': '12', 'category': 'Numbers', 'emoji': '🥚'},
    {'question': 'What is half a dozen?', 'answer': '6', 'category': 'Numbers', 'emoji': '6️⃣'},
    {'question': 'How many degrees in a circle?', 'answer': '360 Degrees', 'category': 'Numbers', 'emoji': '⭕'},
    {'question': 'How many degrees in a right angle?', 'answer': '90 Degrees', 'category': 'Numbers', 'emoji': '📐'},
    {'question': 'What is 15 + 27?', 'answer': '42', 'category': 'Numbers', 'emoji': '➕'},
    {'question': 'What is 50 - 18?', 'answer': '32', 'category': 'Numbers', 'emoji': '➖'},
    {'question': 'How many centimeters in a meter?', 'answer': '100 cm', 'category': 'Numbers', 'emoji': '📏'},
    {'question': 'How many millimeters in a centimeter?', 'answer': '10 mm', 'category': 'Numbers', 'emoji': '📏'},
    {'question': 'How many grams in a kilogram?', 'answer': '1000 grams', 'category': 'Numbers', 'emoji': '⚖️'},
    {'question': 'What is the square of 5?', 'answer': '25', 'category': 'Numbers', 'emoji': '5️⃣'},
    {'question': 'What is the cube of 2?', 'answer': '8', 'category': 'Numbers', 'emoji': '🧊'},
    {'question': 'How many sides does a decagon have?', 'answer': '10 Sides', 'category': 'Numbers', 'emoji': '🔟'},
    {'question': 'What is 9 x 9?', 'answer': '81', 'category': 'Numbers', 'emoji': '✖️'},
    {'question': 'How many days in a leap year?', 'answer': '366 Days', 'category': 'Numbers', 'emoji': '📅'},
    {'question': 'What is the value of Pi (approx)?', 'answer': '3.14', 'category': 'Numbers', 'emoji': '🥧'},

    // Inventions (20 questions)
    {'question': 'Who invented the telephone?', 'answer': 'Alexander Graham Bell', 'category': 'Inventions', 'emoji': '📞'},
    {'question': 'Who invented the light bulb?', 'answer': 'Thomas Edison', 'category': 'Inventions', 'emoji': '💡'},
    {'question': 'Who invented the airplane?', 'answer': 'Wright Brothers', 'category': 'Inventions', 'emoji': '✈️'},
    {'question': 'Who discovered gravity?', 'answer': 'Isaac Newton', 'category': 'Inventions', 'emoji': '🍎'},
    {'question': 'Who invented the computer?', 'answer': 'Charles Babbage', 'category': 'Inventions', 'emoji': '💻'},
    {'question': 'Who invented the telescope?', 'answer': 'Hans Lippershey', 'category': 'Inventions', 'emoji': '🔭'},
    {'question': 'Who invented the radio?', 'answer': 'Guglielmo Marconi', 'category': 'Inventions', 'emoji': '📻'},
    {'question': 'Who invented the television?', 'answer': 'John Logie Baird', 'category': 'Inventions', 'emoji': '📺'},
    {'question': 'Who invented the car?', 'answer': 'Karl Benz', 'category': 'Inventions', 'emoji': '🚗'},
    {'question': 'Who invented the camera?', 'answer': 'Joseph Nicéphore Niépce', 'category': 'Inventions', 'emoji': '📷'},
    {'question': 'Who invented dynamite?', 'answer': 'Alfred Nobel', 'category': 'Inventions', 'emoji': '🧨'},
    {'question': 'Who invented the bicycle?', 'answer': 'Karl von Drais', 'category': 'Inventions', 'emoji': '🚲'},
    {'question': 'Who invented the thermometer?', 'answer': 'Galileo Galilei', 'category': 'Inventions', 'emoji': '🌡️'},
    {'question': 'Who invented the stethoscope?', 'answer': 'René Laennec', 'category': 'Inventions', 'emoji': '🩺'},
    {'question': 'Who invented the refrigerator?', 'answer': 'Jacob Perkins', 'category': 'Inventions', 'emoji': '🧊'},
    {'question': 'Who invented the battery?', 'answer': 'Alessandro Volta', 'category': 'Inventions', 'emoji': '🔋'},
    {'question': 'Who invented the World Wide Web?', 'answer': 'Tim Berners-Lee', 'category': 'Inventions', 'emoji': '🌐'},
    {'question': 'Who invented the microscope?', 'answer': 'Zacharias Janssen', 'category': 'Inventions', 'emoji': '🔬'},
    {'question': 'Who invented the sewing machine?', 'answer': 'Elias Howe', 'category': 'Inventions', 'emoji': '🧵'},
    {'question': 'Who invented the ballpoint pen?', 'answer': 'László Bíró', 'category': 'Inventions', 'emoji': '🖊️'},
    {'question': 'Who invented the electric motor?', 'answer': 'Michael Faraday', 'category': 'Inventions', 'emoji': '⚡'},
    {'question': 'Who invented the parachute?', 'answer': 'André-Jacques Garnerin', 'category': 'Inventions', 'emoji': '🪂'},
    {'question': 'Who invented the calculator?', 'answer': 'Blaise Pascal', 'category': 'Inventions', 'emoji': '🔢'},
    {'question': 'Who invented the barometer?', 'answer': 'Evangelista Torricelli', 'category': 'Inventions', 'emoji': '📊'},
    {'question': 'Who invented the safety pin?', 'answer': 'Walter Hunt', 'category': 'Inventions', 'emoji': '📌'},
    {'question': 'Who invented the typewriter?', 'answer': 'Christopher Sholes', 'category': 'Inventions', 'emoji': '⌨️'},
    {'question': 'Who invented the elevator?', 'answer': 'Elisha Otis', 'category': 'Inventions', 'emoji': '🛗'},
    {'question': 'Who invented the washing machine?', 'answer': 'Jacob Christian Schäffer', 'category': 'Inventions', 'emoji': '🧺'},
    {'question': 'Who invented the vacuum cleaner?', 'answer': 'Hubert Cecil Booth', 'category': 'Inventions', 'emoji': '🧹'},
    {'question': 'Who invented the diesel engine?', 'answer': 'Rudolf Diesel', 'category': 'Inventions', 'emoji': '🚂'},
    {'question': 'Who invented the fountain pen?', 'answer': 'Petrache Poenaru', 'category': 'Inventions', 'emoji': '🖋️'},
    {'question': 'Who invented the telescope?', 'answer': 'Hans Lippershey', 'category': 'Inventions', 'emoji': '🔭'},
    {'question': 'Who invented the X-ray machine?', 'answer': 'Wilhelm Röntgen', 'category': 'Inventions', 'emoji': '🩻'},
    {'question': 'Who invented the stethoscope?', 'answer': 'René Laennec', 'category': 'Inventions', 'emoji': '🩺'},
    {'question': 'Who invented the phonograph?', 'answer': 'Thomas Edison', 'category': 'Inventions', 'emoji': '🎵'},
    {'question': 'Who invented the electric fan?', 'answer': 'Schuyler Wheeler', 'category': 'Inventions', 'emoji': '🌀'},
    {'question': 'Who invented the safety razor?', 'answer': 'King Camp Gillette', 'category': 'Inventions', 'emoji': '🪒'},
    {'question': 'Who invented the zipper?', 'answer': 'Whitcomb Judson', 'category': 'Inventions', 'emoji': '🧥'},
    {'question': 'Who invented the ATM?', 'answer': 'John Shepherd-Barron', 'category': 'Inventions', 'emoji': '🏧'},

    // Sports (20 questions)
    {'question': 'How many players are in a cricket team?', 'answer': '11 Players', 'category': 'Sports', 'emoji': '🏏'},
    {'question': 'How many players are in a football team?', 'answer': '11 Players', 'category': 'Sports', 'emoji': '⚽'},
    {'question': 'Which country invented cricket?', 'answer': 'England', 'category': 'Sports', 'emoji': '🏴󠁧󠁢󠁥󠁮󠁧󠁿'},
    {'question': 'What sport uses a shuttlecock?', 'answer': 'Badminton', 'category': 'Sports', 'emoji': '🏸'},
    {'question': 'Which is the national game of India?', 'answer': 'Hockey', 'category': 'Sports', 'emoji': '🏑'},
    {'question': 'How many players in a basketball team?', 'answer': '5 Players', 'category': 'Sports', 'emoji': '🏀'},
    {'question': 'What color is a tennis ball?', 'answer': 'Yellow/Green', 'category': 'Sports', 'emoji': '🎾'},
    {'question': 'How many holes in a golf course?', 'answer': '18 Holes', 'category': 'Sports', 'emoji': '⛳'},
    {'question': 'Which sport uses a bat and ball?', 'answer': 'Cricket, Baseball', 'category': 'Sports', 'emoji': '🏏'},
    {'question': 'What is the highest score in cricket?', 'answer': '6 Runs (Sixer)', 'category': 'Sports', 'emoji': '🏏'},
    {'question': 'Which sport is played at Wimbledon?', 'answer': 'Tennis', 'category': 'Sports', 'emoji': '🎾'},
    {'question': 'How long is an Olympic swimming pool?', 'answer': '50 meters', 'category': 'Sports', 'emoji': '🏊'},
    {'question': 'Which sport has a goalkeeper?', 'answer': 'Football, Hockey', 'category': 'Sports', 'emoji': '🥅'},
    {'question': 'What is a marathon distance?', 'answer': '42.195 km', 'category': 'Sports', 'emoji': '🏃'},
    {'question': 'Which country hosts the Tour de France?', 'answer': 'France', 'category': 'Sports', 'emoji': '🚴'},
    {'question': 'How many rings in Olympic symbol?', 'answer': '5 Rings', 'category': 'Sports', 'emoji': '🏅'},
    {'question': 'Which sport uses a puck?', 'answer': 'Ice Hockey', 'category': 'Sports', 'emoji': '🏒'},
    {'question': 'What is the World Cup trophy made of?', 'answer': 'Gold', 'category': 'Sports', 'emoji': '🏆'},
    {'question': 'Which sport has a slam dunk?', 'answer': 'Basketball', 'category': 'Sports', 'emoji': '🏀'},
    {'question': 'How many innings in a Test cricket match?', 'answer': '4 Innings', 'category': 'Sports', 'emoji': '🏏'},
    {'question': 'What is the national sport of Japan?', 'answer': 'Sumo Wrestling', 'category': 'Sports', 'emoji': '🤼'},
    {'question': 'How many players in a volleyball team?', 'answer': '6 Players', 'category': 'Sports', 'emoji': '🏐'},
    {'question': 'What is the national sport of USA?', 'answer': 'Baseball', 'category': 'Sports', 'emoji': '⚾'},
    {'question': 'How many players in a hockey team?', 'answer': '11 Players', 'category': 'Sports', 'emoji': '🏑'},
    {'question': 'What is the national sport of Canada?', 'answer': 'Ice Hockey', 'category': 'Sports', 'emoji': '🏒'},
    {'question': 'How long is a cricket pitch?', 'answer': '22 yards', 'category': 'Sports', 'emoji': '🏏'},
    {'question': 'What is a hat-trick in cricket?', 'answer': '3 wickets in 3 balls', 'category': 'Sports', 'emoji': '🎩'},
    {'question': 'Which sport is played on grass court?', 'answer': 'Tennis, Cricket', 'category': 'Sports', 'emoji': '🌿'},
    {'question': 'What is the duration of a football match?', 'answer': '90 minutes', 'category': 'Sports', 'emoji': '⚽'},
    {'question': 'What is a century in cricket?', 'answer': '100 runs', 'category': 'Sports', 'emoji': '💯'},
    {'question': 'Which game is played on ice?', 'answer': 'Ice Hockey, Skating', 'category': 'Sports', 'emoji': '⛸️'},
    {'question': 'What is the national sport of China?', 'answer': 'Table Tennis', 'category': 'Sports', 'emoji': '🏓'},
    {'question': 'How many sets in a tennis match?', 'answer': '3 or 5 sets', 'category': 'Sports', 'emoji': '🎾'},
    {'question': 'What is a Grand Slam in tennis?', 'answer': 'Winning 4 major titles', 'category': 'Sports', 'emoji': '🏆'},
    {'question': 'Which sport uses a javelin?', 'answer': 'Athletics (Javelin throw)', 'category': 'Sports', 'emoji': '🎯'},
    {'question': 'What is the weight of a cricket ball?', 'answer': '156-163 grams', 'category': 'Sports', 'emoji': '🏏'},
    {'question': 'Which game is played in water?', 'answer': 'Water Polo, Swimming', 'category': 'Sports', 'emoji': '🏊'},
    {'question': 'What is the national sport of Brazil?', 'answer': 'Football', 'category': 'Sports', 'emoji': '⚽'},
    {'question': 'How many overs in T20 cricket?', 'answer': '20 overs per team', 'category': 'Sports', 'emoji': '🏏'},

    // General (20 questions)
    {'question': 'What is the color of milk?', 'answer': 'White', 'category': 'General', 'emoji': '🥛'},
    {'question': 'Which fruit is known as the king of fruits?', 'answer': 'Mango', 'category': 'General', 'emoji': '🥭'},
    {'question': 'What do bees make?', 'answer': 'Honey', 'category': 'General', 'emoji': '🍯'},
    {'question': 'What is baby cat called?', 'answer': 'Kitten', 'category': 'General', 'emoji': '🐱'},
    {'question': 'What is baby dog called?', 'answer': 'Puppy', 'category': 'General', 'emoji': '🐶'},
    {'question': 'What is the color of grass?', 'answer': 'Green', 'category': 'General', 'emoji': '🌿'},
    {'question': 'What is the color of sky?', 'answer': 'Blue', 'category': 'General', 'emoji': '🌤️'},
    {'question': 'How many letters in English alphabet?', 'answer': '26 Letters', 'category': 'General', 'emoji': '🔤'},
    {'question': 'What is baby cow called?', 'answer': 'Calf', 'category': 'General', 'emoji': '🐄'},
    {'question': 'What is the opposite of hot?', 'answer': 'Cold', 'category': 'General', 'emoji': '❄️'},
    {'question': 'What is the opposite of big?', 'answer': 'Small', 'category': 'General', 'emoji': '📏'},
    {'question': 'What is a group of fish called?', 'answer': 'School', 'category': 'General', 'emoji': '🐟'},
    {'question': 'What is a group of lions called?', 'answer': 'Pride', 'category': 'General', 'emoji': '🦁'},
    {'question': 'What do we use to cut paper?', 'answer': 'Scissors', 'category': 'General', 'emoji': '✂️'},
    {'question': 'What is frozen water called?', 'answer': 'Ice', 'category': 'General', 'emoji': '🧊'},
    {'question': 'Which season comes after winter?', 'answer': 'Spring', 'category': 'General', 'emoji': '🌸'},
    {'question': 'What do we use to write?', 'answer': 'Pen/Pencil', 'category': 'General', 'emoji': '✏️'},
    {'question': 'How many vowels are there?', 'answer': '5 (A, E, I, O, U)', 'category': 'General', 'emoji': '🔡'},
    {'question': 'What is the color of banana?', 'answer': 'Yellow', 'category': 'General', 'emoji': '🍌'},
    {'question': 'What is the color of tomato?', 'answer': 'Red', 'category': 'General', 'emoji': '🍅'},
    {'question': 'What is the queen of fruits?', 'answer': 'Mangosteen', 'category': 'General', 'emoji': '🍇'},
    {'question': 'What is baby sheep called?', 'answer': 'Lamb', 'category': 'General', 'emoji': '🐑'},
    {'question': 'What is the opposite of dark?', 'answer': 'Light', 'category': 'General', 'emoji': '💡'},
    {'question': 'What is baby goat called?', 'answer': 'Kid', 'category': 'General', 'emoji': '🐐'},
    {'question': 'How many seasons are there?', 'answer': '4 Seasons', 'category': 'General', 'emoji': '🍂'},
    {'question': 'What is the opposite of tall?', 'answer': 'Short', 'category': 'General', 'emoji': '📏'},
    {'question': 'What is a group of bees called?', 'answer': 'Swarm', 'category': 'General', 'emoji': '🐝'},
    {'question': 'What is baby duck called?', 'answer': 'Duckling', 'category': 'General', 'emoji': '🦆'},
    {'question': 'What is the opposite of fast?', 'answer': 'Slow', 'category': 'General', 'emoji': '🐢'},
    {'question': 'What is a group of elephants called?', 'answer': 'Herd', 'category': 'General', 'emoji': '🐘'},
    {'question': 'What is baby chicken called?', 'answer': 'Chick', 'category': 'General', 'emoji': '🐥'},
    {'question': 'What is the opposite of happy?', 'answer': 'Sad', 'category': 'General', 'emoji': '😢'},
    {'question': 'What is the color of an orange fruit?', 'answer': 'Orange', 'category': 'General', 'emoji': '🍊'},
    {'question': 'What is a female deer called?', 'answer': 'Doe', 'category': 'General', 'emoji': '🦌'},
    {'question': 'What is the opposite of up?', 'answer': 'Down', 'category': 'General', 'emoji': '⬇️'},
    {'question': 'What is a male duck called?', 'answer': 'Drake', 'category': 'General', 'emoji': '🦆'},
    {'question': 'What day comes after Monday?', 'answer': 'Tuesday', 'category': 'General', 'emoji': '📅'},
    {'question': 'What month comes after March?', 'answer': 'April', 'category': 'General', 'emoji': '🗓️'},
    {'question': 'What is the opposite of young?', 'answer': 'Old', 'category': 'General', 'emoji': '👴'},

    // Science & Technology (20 questions)
    {'question': 'What is the speed of light?', 'answer': '300,000 km/s', 'category': 'Science & Technology', 'emoji': '💡'},
    {'question': 'Who invented the World Wide Web?', 'answer': 'Tim Berners-Lee', 'category': 'Science & Technology', 'emoji': '🌐'},
    {'question': 'What does CPU stand for?', 'answer': 'Central Processing Unit', 'category': 'Science & Technology', 'emoji': '🖥️'},
    {'question': 'What is the chemical symbol for Gold?', 'answer': 'Au', 'category': 'Science & Technology', 'emoji': '🥇'},
    {'question': 'Who invented the Radio?', 'answer': 'Guglielmo Marconi', 'category': 'Science & Technology', 'emoji': '📻'},
    {'question': 'What is the hardest natural substance?', 'answer': 'Diamond', 'category': 'Science & Technology', 'emoji': '💎'},
    {'question': 'Who founded Microsoft?', 'answer': 'Bill Gates', 'category': 'Science & Technology', 'emoji': '🪟'},
    {'question': 'What is the freezing point of water?', 'answer': '0°C or 32°F', 'category': 'Science & Technology', 'emoji': '🧊'},
    {'question': 'Who invented the Steam Engine?', 'answer': 'James Watt', 'category': 'Science & Technology', 'emoji': '🚂'},
    {'question': 'What does DNA stand for?', 'answer': 'Deoxyribonucleic Acid', 'category': 'Science & Technology', 'emoji': '🧬'},
    {'question': 'Who discovered Penicillin?', 'answer': 'Alexander Fleming', 'category': 'Science & Technology', 'emoji': '💊'},
    {'question': 'What is the boiling point of water?', 'answer': '100°C or 212°F', 'category': 'Science & Technology', 'emoji': '♨️'},
    {'question': 'Who invented the Printing Press?', 'answer': 'Johannes Gutenberg', 'category': 'Science & Technology', 'emoji': '🖨️'},
    {'question': 'What is the study of earthquakes called?', 'answer': 'Seismology', 'category': 'Science & Technology', 'emoji': '🌋'},
    {'question': 'Who founded Apple Inc?', 'answer': 'Steve Jobs', 'category': 'Science & Technology', 'emoji': '🍎'},
    {'question': 'What does RAM stand for?', 'answer': 'Random Access Memory', 'category': 'Science & Technology', 'emoji': '🧠'},
    {'question': 'Who invented the smartphone?', 'answer': 'IBM (Simon)', 'category': 'Science & Technology', 'emoji': '📱'},
    {'question': 'What is Wi-Fi?', 'answer': 'Wireless Internet', 'category': 'Science & Technology', 'emoji': '📶'},
    {'question': 'What does GPS stand for?', 'answer': 'Global Positioning System', 'category': 'Science & Technology', 'emoji': '🛰️'},
    {'question': 'Who is known as father of computer?', 'answer': 'Charles Babbage', 'category': 'Science & Technology', 'emoji': '💻'},
    {'question': 'What does USB stand for?', 'answer': 'Universal Serial Bus', 'category': 'Science & Technology', 'emoji': '🔌'},
    {'question': 'What does HTML stand for?', 'answer': 'HyperText Markup Language', 'category': 'Science & Technology', 'emoji': '🌐'},
    {'question': 'Who founded Facebook?', 'answer': 'Mark Zuckerberg', 'category': 'Science & Technology', 'emoji': '📘'},
    {'question': 'What does PDF stand for?', 'answer': 'Portable Document Format', 'category': 'Science & Technology', 'emoji': '📄'},
    {'question': 'What is AI?', 'answer': 'Artificial Intelligence', 'category': 'Science & Technology', 'emoji': '🤖'},
    {'question': 'Who founded Amazon?', 'answer': 'Jeff Bezos', 'category': 'Science & Technology', 'emoji': '📦'},
    {'question': 'What does SIM stand for?', 'answer': 'Subscriber Identity Module', 'category': 'Science & Technology', 'emoji': '📱'},
    {'question': 'What is the brain of computer?', 'answer': 'CPU', 'category': 'Science & Technology', 'emoji': '🧠'},
    {'question': 'What does LED stand for?', 'answer': 'Light Emitting Diode', 'category': 'Science & Technology', 'emoji': '💡'},
    {'question': 'Who founded Google?', 'answer': 'Larry Page and Sergey Brin', 'category': 'Science & Technology', 'emoji': '🔍'},
    {'question': 'What is Bluetooth named after?', 'answer': 'A Danish King', 'category': 'Science & Technology', 'emoji': '📶'},
    {'question': 'What does WWW stand for?', 'answer': 'World Wide Web', 'category': 'Science & Technology', 'emoji': '🌐'},
    {'question': 'Who invented email?', 'answer': 'Ray Tomlinson', 'category': 'Science & Technology', 'emoji': '📧'},
    {'question': 'What is the full form of URL?', 'answer': 'Uniform Resource Locator', 'category': 'Science & Technology', 'emoji': '🔗'},
    {'question': 'Who founded Tesla?', 'answer': 'Elon Musk', 'category': 'Science & Technology', 'emoji': '🚗'},
    {'question': 'What does ROM stand for?', 'answer': 'Read Only Memory', 'category': 'Science & Technology', 'emoji': '💾'},
    {'question': 'What is 5G?', 'answer': 'Fifth Generation Network', 'category': 'Science & Technology', 'emoji': '📶'},
    {'question': 'What does VR stand for?', 'answer': 'Virtual Reality', 'category': 'Science & Technology', 'emoji': '🥽'},
    {'question': 'Who invented Java programming?', 'answer': 'James Gosling', 'category': 'Science & Technology', 'emoji': '☕'},

    // Environment (20 questions)
    {'question': 'What is the main cause of global warming?', 'answer': 'Greenhouse gases', 'category': 'Environment', 'emoji': '🌡️'},
    {'question': 'Which layer protects Earth from UV rays?', 'answer': 'Ozone Layer', 'category': 'Environment', 'emoji': '🛡️'},
    {'question': 'What is the largest rainforest?', 'answer': 'Amazon Rainforest', 'category': 'Environment', 'emoji': '🌳'},
    {'question': 'What percentage of Earth is covered by water?', 'answer': 'About 71%', 'category': 'Environment', 'emoji': '🌊'},
    {'question': 'Which gas do trees absorb?', 'answer': 'Carbon Dioxide (CO2)', 'category': 'Environment', 'emoji': '🌲'},
    {'question': 'What is recycling?', 'answer': 'Reusing waste materials', 'category': 'Environment', 'emoji': '♻️'},
    {'question': 'What is the main source of energy for Earth?', 'answer': 'The Sun', 'category': 'Environment', 'emoji': '☀️'},
    {'question': 'What animal is most affected by melting ice?', 'answer': 'Polar Bear', 'category': 'Environment', 'emoji': '🐻‍❄️'},
    {'question': 'What is deforestation?', 'answer': 'Cutting down forests', 'category': 'Environment', 'emoji': '🪓'},
    {'question': 'Which is a renewable energy source?', 'answer': 'Solar, Wind, Water', 'category': 'Environment', 'emoji': '⚡'},
    {'question': 'What is the largest desert in the world?', 'answer': 'Sahara Desert', 'category': 'Environment', 'emoji': '🏜️'},
    {'question': 'What is biodiversity?', 'answer': 'Variety of life on Earth', 'category': 'Environment', 'emoji': '🦋'},
    {'question': 'What is pollution?', 'answer': 'Harmful substances in environment', 'category': 'Environment', 'emoji': '🏭'},
    {'question': 'Which day is Earth Day?', 'answer': 'April 22', 'category': 'Environment', 'emoji': '🌍'},
    {'question': 'What are endangered species?', 'answer': 'Animals at risk of extinction', 'category': 'Environment', 'emoji': '🦏'},
    {'question': 'What is climate change?', 'answer': 'Long-term weather pattern changes', 'category': 'Environment', 'emoji': '🌡️'},
    {'question': 'What is water pollution?', 'answer': 'Contamination of water bodies', 'category': 'Environment', 'emoji': '🚰'},
    {'question': 'What is air pollution?', 'answer': 'Harmful gases in air', 'category': 'Environment', 'emoji': '💨'},
    {'question': 'Which day is World Environment Day?', 'answer': 'June 5', 'category': 'Environment', 'emoji': '🌿'},
    {'question': 'What is composting?', 'answer': 'Turning waste into fertilizer', 'category': 'Environment', 'emoji': '🍂'},
    {'question': 'What is the 3R rule?', 'answer': 'Reduce, Reuse, Recycle', 'category': 'Environment', 'emoji': '♻️'},
    {'question': 'What causes acid rain?', 'answer': 'Sulfur dioxide and nitrogen oxide', 'category': 'Environment', 'emoji': '🌧️'},
    {'question': 'What is organic farming?', 'answer': 'Farming without chemicals', 'category': 'Environment', 'emoji': '🌾'},
    {'question': 'What is a carbon footprint?', 'answer': 'Amount of CO2 we produce', 'category': 'Environment', 'emoji': '👣'},
    {'question': 'What is smog?', 'answer': 'Smoke + Fog', 'category': 'Environment', 'emoji': '🌫️'},
    {'question': 'What is global warming?', 'answer': 'Rise in Earth temperature', 'category': 'Environment', 'emoji': '🌡️'},
    {'question': 'What is soil erosion?', 'answer': 'Washing away of top soil', 'category': 'Environment', 'emoji': '🏔️'},
    {'question': 'What is the Green Revolution?', 'answer': 'Increase in food production', 'category': 'Environment', 'emoji': '🌾'},
    {'question': 'What are fossil fuels?', 'answer': 'Coal, Oil, Natural Gas', 'category': 'Environment', 'emoji': '⛽'},
    {'question': 'What is a wildlife sanctuary?', 'answer': 'Protected area for animals', 'category': 'Environment', 'emoji': '🦁'},
    {'question': 'What is afforestation?', 'answer': 'Planting new forests', 'category': 'Environment', 'emoji': '🌲'},
    {'question': 'What is noise pollution?', 'answer': 'Harmful loud sounds', 'category': 'Environment', 'emoji': '🔊'},
    {'question': 'What is a national park?', 'answer': 'Protected natural area', 'category': 'Environment', 'emoji': '🏞️'},
    {'question': 'What is World Wildlife Day?', 'answer': 'March 3', 'category': 'Environment', 'emoji': '🐾'},
    {'question': 'What causes floods?', 'answer': 'Heavy rainfall, poor drainage', 'category': 'Environment', 'emoji': '🌊'},
    {'question': 'What is drought?', 'answer': 'Long period without rain', 'category': 'Environment', 'emoji': '☀️'},
    {'question': 'What is e-waste?', 'answer': 'Electronic waste', 'category': 'Environment', 'emoji': '📱'},
    {'question': 'What is Van Mahotsav?', 'answer': 'Tree planting festival in India', 'category': 'Environment', 'emoji': '🌳'},
    {'question': 'What is plastic pollution?', 'answer': 'Harmful plastic in environment', 'category': 'Environment', 'emoji': '🥤'},

    // Countries (20 questions)
    {'question': 'What is the capital of Japan?', 'answer': 'Tokyo', 'category': 'Countries', 'emoji': '🇯🇵'},
    {'question': 'What is the capital of France?', 'answer': 'Paris', 'category': 'Countries', 'emoji': '🇫🇷'},
    {'question': 'What is the capital of USA?', 'answer': 'Washington D.C.', 'category': 'Countries', 'emoji': '🇺🇸'},
    {'question': 'What is the capital of China?', 'answer': 'Beijing', 'category': 'Countries', 'emoji': '🇨🇳'},
    {'question': 'What is the capital of Australia?', 'answer': 'Canberra', 'category': 'Countries', 'emoji': '🇦🇺'},
    {'question': 'What is the capital of UK?', 'answer': 'London', 'category': 'Countries', 'emoji': '🇬🇧'},
    {'question': 'What is the capital of Germany?', 'answer': 'Berlin', 'category': 'Countries', 'emoji': '🇩🇪'},
    {'question': 'What is the capital of Russia?', 'answer': 'Moscow', 'category': 'Countries', 'emoji': '🇷🇺'},
    {'question': 'What is the capital of Brazil?', 'answer': 'Brasília', 'category': 'Countries', 'emoji': '🇧🇷'},
    {'question': 'What is the capital of Canada?', 'answer': 'Ottawa', 'category': 'Countries', 'emoji': '🇨🇦'},
    {'question': 'Which country has the most population?', 'answer': 'India', 'category': 'Countries', 'emoji': '👨‍👩‍👧‍👦'},
    {'question': 'Which country is known as Land of Rising Sun?', 'answer': 'Japan', 'category': 'Countries', 'emoji': '🌅'},
    {'question': 'What is the capital of Egypt?', 'answer': 'Cairo', 'category': 'Countries', 'emoji': '🇪🇬'},
    {'question': 'Which country has the Eiffel Tower?', 'answer': 'France', 'category': 'Countries', 'emoji': '🗼'},
    {'question': 'What is the capital of Italy?', 'answer': 'Rome', 'category': 'Countries', 'emoji': '🇮🇹'},
    {'question': 'Which country has the Great Wall?', 'answer': 'China', 'category': 'Countries', 'emoji': '🏯'},
    {'question': 'What is the capital of Spain?', 'answer': 'Madrid', 'category': 'Countries', 'emoji': '🇪🇸'},
    {'question': 'Which country has the Pyramids?', 'answer': 'Egypt', 'category': 'Countries', 'emoji': '🔺'},
    {'question': 'What is the capital of South Korea?', 'answer': 'Seoul', 'category': 'Countries', 'emoji': '🇰🇷'},
    {'question': 'Which country is known for Kangaroos?', 'answer': 'Australia', 'category': 'Countries', 'emoji': '🦘'},
    {'question': 'What is the capital of Thailand?', 'answer': 'Bangkok', 'category': 'Countries', 'emoji': '🇹🇭'},
    {'question': 'What is the capital of Nepal?', 'answer': 'Kathmandu', 'category': 'Countries', 'emoji': '🇳🇵'},
    {'question': 'What is the capital of Sri Lanka?', 'answer': 'Colombo', 'category': 'Countries', 'emoji': '🇱🇰'},
    {'question': 'What is the capital of Pakistan?', 'answer': 'Islamabad', 'category': 'Countries', 'emoji': '🇵🇰'},
    {'question': 'What is the capital of Bangladesh?', 'answer': 'Dhaka', 'category': 'Countries', 'emoji': '🇧🇩'},
    {'question': 'Which country has Statue of Liberty?', 'answer': 'USA', 'category': 'Countries', 'emoji': '🗽'},
    {'question': 'Which country has Big Ben?', 'answer': 'United Kingdom', 'category': 'Countries', 'emoji': '🕰️'},
    {'question': 'Which country has Leaning Tower of Pisa?', 'answer': 'Italy', 'category': 'Countries', 'emoji': '🗼'},
    {'question': 'What is the capital of Singapore?', 'answer': 'Singapore', 'category': 'Countries', 'emoji': '🇸🇬'},
    {'question': 'What is the capital of Malaysia?', 'answer': 'Kuala Lumpur', 'category': 'Countries', 'emoji': '🇲🇾'},
    {'question': 'Which country has Christ the Redeemer?', 'answer': 'Brazil', 'category': 'Countries', 'emoji': '🇧🇷'},
    {'question': 'What is the capital of Indonesia?', 'answer': 'Jakarta', 'category': 'Countries', 'emoji': '🇮🇩'},
    {'question': 'What is the capital of Saudi Arabia?', 'answer': 'Riyadh', 'category': 'Countries', 'emoji': '🇸🇦'},
    {'question': 'Which country has the Colosseum?', 'answer': 'Italy', 'category': 'Countries', 'emoji': '🏛️'},
    {'question': 'What is the capital of Vietnam?', 'answer': 'Hanoi', 'category': 'Countries', 'emoji': '🇻🇳'},
    {'question': 'Which country is called Land of Thousand Lakes?', 'answer': 'Finland', 'category': 'Countries', 'emoji': '🇫🇮'},
    {'question': 'What is the capital of Turkey?', 'answer': 'Ankara', 'category': 'Countries', 'emoji': '🇹🇷'},
    {'question': 'Which country has Burj Khalifa?', 'answer': 'UAE (Dubai)', 'category': 'Countries', 'emoji': '🏙️'},
    {'question': 'What is the capital of South Africa?', 'answer': 'Pretoria', 'category': 'Countries', 'emoji': '🇿🇦'},

    // History (20 questions)
    {'question': 'Who was the first President of USA?', 'answer': 'George Washington', 'category': 'History', 'emoji': '🇺🇸'},
    {'question': 'Who discovered America?', 'answer': 'Christopher Columbus', 'category': 'History', 'emoji': '🚢'},
    {'question': 'Who built the Taj Mahal?', 'answer': 'Shah Jahan', 'category': 'History', 'emoji': '🕌'},
    {'question': 'Who was the first Prime Minister of India?', 'answer': 'Jawaharlal Nehru', 'category': 'History', 'emoji': '🇮🇳'},
    {'question': 'When did World War II end?', 'answer': '1945', 'category': 'History', 'emoji': '⚔️'},
    {'question': 'Who was known as Father of the Nation in India?', 'answer': 'Mahatma Gandhi', 'category': 'History', 'emoji': '🕊️'},
    {'question': 'When did India get independence?', 'answer': '15 August 1947', 'category': 'History', 'emoji': '🎉'},
    {'question': 'Who invented the wheel?', 'answer': 'Ancient Mesopotamians', 'category': 'History', 'emoji': '🛞'},
    {'question': 'Which civilization built the Pyramids?', 'answer': 'Ancient Egyptians', 'category': 'History', 'emoji': '🔺'},
    {'question': 'Who was the first woman to fly in space?', 'answer': 'Valentina Tereshkova', 'category': 'History', 'emoji': '👩‍🚀'},
    {'question': 'When did the Titanic sink?', 'answer': '1912', 'category': 'History', 'emoji': '🚢'},
    {'question': 'Who painted the Mona Lisa?', 'answer': 'Leonardo da Vinci', 'category': 'History', 'emoji': '🎨'},
    {'question': 'Who wrote Romeo and Juliet?', 'answer': 'William Shakespeare', 'category': 'History', 'emoji': '📖'},
    {'question': 'When was the first Olympics held?', 'answer': '776 BC in Greece', 'category': 'History', 'emoji': '🏅'},
    {'question': 'Who was the first Emperor of China?', 'answer': 'Qin Shi Huang', 'category': 'History', 'emoji': '🏯'},
    {'question': 'Who invented the printing press?', 'answer': 'Johannes Gutenberg', 'category': 'History', 'emoji': '📜'},
    {'question': 'When was the French Revolution?', 'answer': '1789', 'category': 'History', 'emoji': '🇫🇷'},
    {'question': 'Who was Cleopatra?', 'answer': 'Queen of Ancient Egypt', 'category': 'History', 'emoji': '👑'},
    {'question': 'Who founded Buddhism?', 'answer': 'Gautama Buddha', 'category': 'History', 'emoji': '🧘'},
    {'question': 'When was the Great Wall of China built?', 'answer': 'Around 221 BC', 'category': 'History', 'emoji': '🧱'},
    {'question': 'Who was Alexander the Great?', 'answer': 'King of Macedonia', 'category': 'History', 'emoji': '👑'},
    {'question': 'When did World War I start?', 'answer': '1914', 'category': 'History', 'emoji': '⚔️'},
    {'question': 'Who was the first woman President of India?', 'answer': 'Pratibha Patil', 'category': 'History', 'emoji': '👩'},
    {'question': 'Who wrote the Indian Constitution?', 'answer': 'Dr. B.R. Ambedkar', 'category': 'History', 'emoji': '📜'},
    {'question': 'When was the United Nations formed?', 'answer': '1945', 'category': 'History', 'emoji': '🌍'},
    {'question': 'Who was the Iron Man of India?', 'answer': 'Sardar Vallabhbhai Patel', 'category': 'History', 'emoji': '🇮🇳'},
    {'question': 'Who was Nelson Mandela?', 'answer': 'South African leader', 'category': 'History', 'emoji': '🇿🇦'},
    {'question': 'When did man first walk on Moon?', 'answer': '1969', 'category': 'History', 'emoji': '🌙'},
    {'question': 'Who was Martin Luther King Jr?', 'answer': 'American civil rights leader', 'category': 'History', 'emoji': '✊'},
    {'question': 'Who was Abraham Lincoln?', 'answer': '16th US President', 'category': 'History', 'emoji': '🎩'},
    {'question': 'When was electricity discovered?', 'answer': 'Around 1752 by Benjamin Franklin', 'category': 'History', 'emoji': '⚡'},
    {'question': 'Who was Mother Teresa?', 'answer': 'Catholic nun who helped poor', 'category': 'History', 'emoji': '🙏'},
    {'question': 'When was the Berlin Wall demolished?', 'answer': '1989', 'category': 'History', 'emoji': '🧱'},
    {'question': 'Who was Albert Einstein?', 'answer': 'Famous physicist', 'category': 'History', 'emoji': '🧠'},
    {'question': 'When did India become a Republic?', 'answer': '26 January 1950', 'category': 'History', 'emoji': '🇮🇳'},
    {'question': 'Who founded the Mughal Empire?', 'answer': 'Babur', 'category': 'History', 'emoji': '👑'},
    {'question': 'Who was Ashoka the Great?', 'answer': 'Mauryan Emperor', 'category': 'History', 'emoji': '🦁'},
    {'question': 'When was Indian National Congress formed?', 'answer': '1885', 'category': 'History', 'emoji': '🏛️'},
    {'question': 'Who was Subhash Chandra Bose?', 'answer': 'Indian freedom fighter', 'category': 'History', 'emoji': '🇮🇳'},
  ];

  // Get filtered questions based on selected category
  List<Map<String, String>> get filteredQuestions {
    return gkQuestions
        .where((q) => q['category'] == selectedCategory.value)
        .toList();
  }

  // Change category and reset index
  void changeCategory(String category) {
    selectedCategory.value = category;
    currentIndex.value = 0;
    showAnswer.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _loadProgress();
    _configureTTS();
  }

  Future<void> _configureTTS() async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
    } catch (e) {
      // TTS configuration error
    }
  }

  Future<void> speakQuestion() async {
    try {
      await flutterTts.stop();
      await flutterTts.speak(filteredQuestions[currentIndex.value]['question']!);
    } catch (e) {
      // TTS error
    }
  }

  Future<void> speakAnswer() async {
    try {
      await flutterTts.stop();
      await flutterTts.speak('The answer is ${filteredQuestions[currentIndex.value]['answer']}');
    } catch (e) {
      // TTS error
    }
  }

  void nextQuestion() {
    if (currentIndex.value < filteredQuestions.length - 1) {
      _progressService.markItemCompleted(ProgressService.kGK, currentIndex.value);
      currentIndex.value++;
      showAnswer.value = false;
      box.write(_cacheKey, currentIndex.value);
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      showAnswer.value = false;
    }
  }

  void revealAnswer() {
    showAnswer.value = true;
    speakAnswer();
    _progressService.markItemCompleted(ProgressService.kGK, currentIndex.value);
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < filteredQuestions.length) {
      currentIndex.value = index;
      showAnswer.value = false;
    }
  }

  double get progressPercentage =>
      _progressService.getProgressPercentage(ProgressService.kGK);

  String get progressString =>
      _progressService.getProgressString(ProgressService.kGK);

  bool isItemCompleted(int index) =>
      _progressService.isItemCompleted(ProgressService.kGK, index);

  void _loadProgress() {
    final savedIndex = box.read<int>(_cacheKey);
    if (savedIndex != null && savedIndex >= 0 && savedIndex < gkQuestions.length) {
      currentIndex.value = savedIndex;
    }
  }

  void resetProgress() {
    currentIndex.value = 0;
    showAnswer.value = false;
    box.remove(_cacheKey);
    _progressService.resetProgress(ProgressService.kGK);
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
