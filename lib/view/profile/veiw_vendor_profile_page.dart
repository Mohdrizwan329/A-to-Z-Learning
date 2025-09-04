import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';
import 'package:learning_a_to_z/res/thems/const_style.dart';

class ViewVendorProfileScreen extends StatelessWidget {
  const ViewVendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.backgroundColorWhite,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: ConstColors.backgroundColorWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: ConstColors.textColor,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Vendor Profile', style: ConstStyle.heading1),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFF0F0F0),
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/300?img=12',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Deepak Singh',
                  textAlign: TextAlign.center,
                  style: ConstStyle.heading5,
                ),
                const SizedBox(height: 6),
                Text('Contractor', style: ConstStyle.smallText),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: i < 4
                            ? const Color(0xFFFFC107)
                            : const Color(0xFFFFE08A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('4.6', style: ConstStyle.smallText),
                    const SizedBox(width: 4),
                    Text('(Reviews)', style: ConstStyle.smallText),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 19),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. '
                    'Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, '
                    'cuando un impresor (N. del T.).',
                    style: ConstStyle.smallText,
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Chat',
                      icon: Icons.chat_bubble_rounded,
                      background: ConstColors.primaryGreen, // green
                      onPressed: () {
                        // Get.to(() => VendorChatScreen());
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionButton(
                      label: 'Call',
                      icon: Icons.call_rounded,
                      background: ConstColors.primaryGreen, // red
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Call tapped')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 142,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: background,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
      ),
    );
  }
}
