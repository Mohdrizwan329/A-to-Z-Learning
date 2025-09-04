import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/view/ads/Google_Ads_Page.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:painter/painter.dart';
import 'package:scribble/scribble.dart';

class ImageDrowingScreen extends StatefulWidget {
  final String imagePath;

  const ImageDrowingScreen({super.key, required this.imagePath});

  @override
  State<ImageDrowingScreen> createState() => _ImageDrowingScreenState();
}

class _ImageDrowingScreenState extends State<ImageDrowingScreen> {
  late ScribbleNotifier notifier;
  late PainterController controller;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier();
    controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
        controller = _newController();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2,
        title: "Kids Coloring",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.photo, color: ConstColors.textColorWhit),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: Icon(
              Icons.cleaning_services,
              color: ConstColors.textColorWhit,
            ),
            onPressed: () {
              controller.eraseMode = true;
              controller.thickness = 15.0;
            },
          ),
          IconButton(
            onPressed: () => notifier.clear(),
            icon: Icon(Icons.delete, color: ConstColors.textColorWhit),
          ),
        ],
      ),

      // Floating Buttons responsive
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "thicker",
            mini: true,
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => setState(() => controller.thickness += 2),
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),

          FloatingActionButton(
            heroTag: "thinner",
            mini: true,
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove, color: Colors.white),
            onPressed: () {
              setState(() {
                if (controller.thickness > 2) {
                  controller.thickness -= 2;
                }
              });
            },
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),

          FloatingActionButton(
            heroTag: "brush",
            backgroundColor: Colors.purple,
            child: const Icon(Icons.brush, color: Colors.white),
            onPressed: () {
              controller.eraseMode = false;
              controller.drawColor = Colors.black;
              controller.thickness = 5.0;
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: pickedImage != null
                ? Image.file(pickedImage!, fit: BoxFit.contain)
                : Image.asset("assets/elephant.png", fit: BoxFit.contain),
          ),
          Positioned.fill(child: Painter(controller)),
        ],
      ),

      // Responsive bottom bar
      bottomNavigationBar: Container(
        height: SizeConfig.getProportionateScreenHeight(90),
        color: ConstColors.appBarBackgroundcolor,
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Colors',
                style: ConstStyle.heading2.copyWith(
                  fontSize: SizeConfig.getProportionateScreenWidth(15),
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(5)),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildColorButton(Colors.red),
                    _buildColorButton(Colors.green),
                    _buildColorButton(Colors.blue),
                    _buildColorButton(Colors.orange),
                    _buildColorButton(Colors.purple),
                    _buildColorButton(Colors.yellow),
                    _buildColorButton(Colors.pink),
                    _buildColorButton(Colors.brown),
                    _buildColorButton(Colors.black),
                    _buildColorButton(Colors.teal),
                    _buildColorButton(Colors.cyan),
                    _buildColorButton(Colors.lime),
                    _buildColorButton(Colors.indigo),
                    _buildColorButton(Colors.amber),
                    _buildColorButton(Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        controller.eraseMode = false;
        controller.drawColor = color;
      },
      child: Container(
        width: SizeConfig.getProportionateScreenWidth(30),
        height: SizeConfig.getProportionateScreenHeight(30),
        margin: EdgeInsets.only(
          right: SizeConfig.getProportionateScreenWidth(10),
        ),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 2),
        ),
      ),
    );
  }
}

class DrowingScreen extends StatelessWidget {
  const DrowingScreen({super.key});

  final List<Map<String, String>> images = const [
    {"name": "Elephant", "path": "assets/elephant.png"},
    {"name": "Lion", "path": "assets/elephant.png"},
    {"name": "Bird", "path": "assets/elephant.png"},
    {"name": "Cat", "path": "assets/elephant.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: CustomAppBar(
        title: "Choose Picture",
        showBackButton: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(12),
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ImageDrowingScreen(imagePath: image["path"]!),
              ),
            ),
            child: Card(
              color: ConstColors.textColorWhit,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SizeConfig.getProportionateScreenWidth(12),
                ),
                side: BorderSide(
                  color: ConstColors.dividerColor,
                  width: SizeConfig.getProportionateScreenWidth(1),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(image["path"]!, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      SizeConfig.getProportionateScreenWidth(8),
                    ),
                    child: Text(
                      image["name"]!,
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateScreenWidth(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1, thickness: 1, color: Colors.grey.shade400),
          Container(
            height: SizeConfig.getProportionateScreenHeight(60),
            color: ConstColors.appBarBackgroundcolor,
            child: Center(child: AdsScreen()),
          ),
        ],
      ),
    );
  }
}
