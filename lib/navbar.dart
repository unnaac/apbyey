
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CustomNavBar({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icon2.png'),
              size: 60,
            ),
            color:
            selectedIndex == 0 ? Colors.red : Colors.black, // Warna aktif
            onPressed: () => onItemTapped(0),
          ),
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icon3.png'),
              size: 60,
            ),
            color: selectedIndex == 1 ? Colors.red : Colors.black,
            onPressed: () => onItemTapped(1),
          ),
          const SizedBox(width: 40), // Spasi untuk FAB
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icon4.png'),
              size: 60,
            ),
            color: selectedIndex == 2 ? Colors.red : Colors.black,
            onPressed: () => onItemTapped(2),
          ),
          IconButton(
            icon: const ImageIcon(
              AssetImage('assets/icon5.png'),
              size: 60,
            ),
            color: selectedIndex == 3 ? Colors.red : Colors.black,
            onPressed: () => onItemTapped(3),
          ),
        ],
      ),
    );
  }
}
