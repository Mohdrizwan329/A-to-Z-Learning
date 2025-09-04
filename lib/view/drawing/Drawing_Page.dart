import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';
import 'package:learning_a_to_z/res/utils/size_config.dart';
import 'package:learning_a_to_z/widgets/Custom_AppBar_Page.dart';
import 'package:painter/painter.dart';

class KidsDrowingScreen extends StatefulWidget {
  const KidsDrowingScreen({super.key});

  @override
  State<KidsDrowingScreen> createState() => _KidsDrowingScreenState();
}

class _KidsDrowingScreenState extends State<KidsDrowingScreen> {
  late PainterController controller;

  @override
  void initState() {
    super.initState();
    controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  void _refreshCanvas() {
    setState(() {
      controller = _newController();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,

      appBar: CustomAppBar(
        titleStyle: ConstStyle.heading2.copyWith(
          fontSize: SizeConfig.getProportionateScreenWidth(20),
        ),
        title: "Kids Coloring",
        showBackButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: ConstColors.textColorWhit,
            size: SizeConfig.getProportionateScreenWidth(20),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.cleaning_services,
              color: ConstColors.textColorWhit,
              size: SizeConfig.getProportionateScreenWidth(22),
            ),
            onPressed: () {
              setState(() {
                controller.eraseMode = true;
                controller.thickness = 15.0;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: ConstColors.textColorWhit,
              size: SizeConfig.getProportionateScreenWidth(22),
            ),
            onPressed: () {
              _refreshCanvas();
            },
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "thicker",
            mini: true,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: SizeConfig.getProportionateScreenWidth(20),
            ),
            onPressed: () {
              setState(() {
                controller.thickness += 2;
              });
            },
          ),
          SizedBox(height: SizeConfig.getProportionateScreenHeight(10)),

          FloatingActionButton(
            heroTag: "thinner",
            mini: true,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: SizeConfig.getProportionateScreenWidth(20),
            ),
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
            child: Icon(
              Icons.brush,
              color: Colors.white,
              size: SizeConfig.getProportionateScreenWidth(22),
            ),
            onPressed: () {
              controller.eraseMode = false;
              controller.drawColor = Colors.black;
              controller.thickness = 5.0;
            },
          ),
        ],
      ),

      body: Painter(controller),

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
                    _buildColorBox(Colors.red),
                    _buildColorBox(Colors.green),
                    _buildColorBox(Colors.blue),
                    _buildColorBox(Colors.orange),
                    _buildColorBox(Colors.purple),
                    _buildColorBox(Colors.yellow),
                    _buildColorBox(Colors.pink),
                    _buildColorBox(Colors.brown),
                    _buildColorBox(Colors.black),
                    _buildColorBox(Colors.teal),
                    _buildColorBox(Colors.cyan),
                    _buildColorBox(Colors.lime),
                    _buildColorBox(Colors.indigo),
                    _buildColorBox(Colors.amber),
                    _buildColorBox(Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color) {
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
          border: Border.all(
            color: Colors.black12,
            width: SizeConfig.getProportionateScreenWidth(2),
          ),
        ),
      ),
    );
  }
}
