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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              index: 0,
              label: 'Home',
            ),
            _buildNavItem(
              icon: Icons.timeline,
              activeIcon: Icons.timeline,
              index: 1,
              label: 'Timeline',
            ),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              index: 2,
              label: 'Notifikasi',
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              index: 3,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;
    final Color iconColor = isSelected ? Colors.red : Colors.grey.shade600;

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onItemTapped(index),
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 28,
                color: iconColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: iconColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
