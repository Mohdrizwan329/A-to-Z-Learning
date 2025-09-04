import 'package:flutter/material.dart';
import 'package:learning_a_to_z/res/thems/const_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  Widget buildIcon(int index, IconData icon) {
    final bool isSelected = index == currentIndex;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isSelected ? ConstColors.backgroundColorBlack : Colors.white,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: ConstColors.appBarBackgroundcolor,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      items: [
        BottomNavigationBarItem(
          icon: buildIcon(0, Icons.house_sharp),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: buildIcon(1, Icons.book),
          label: "Booking",
        ),

        BottomNavigationBarItem(
          icon: buildIcon(3, Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
