// lib/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import '../utils/app_colors.dart'; // <-- 1. Impor file warna Anda

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemCount = 4;
          final itemWidth = constraints.maxWidth / itemCount;
          const indicatorWidth = 90.0;

          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: (selectedIndex * itemWidth) +
                    (itemWidth - indicatorWidth) / 2,
                child: Container(
                  width: indicatorWidth,
                  height: 45,
                  decoration: BoxDecoration(
                    // 2. GANTI WARNA DI SINI
                    color: AppColors.creamYellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, itemWidth),
                  _buildNavItem(1, Icons.task_outlined, Icons.task, itemWidth),
                  _buildNavItem(2, Icons.calendar_today_outlined,
                      Icons.calendar_today, itemWidth),
                  _buildNavItem(
                      3, Icons.person_outline, Icons.person, itemWidth),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData activeIcon, double width) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: 70,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: isSelected
              ? Row(
                  key: ValueKey('selected_$index'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 3. GANTI WARNA IKON AKTIF
                    Icon(activeIcon, color: AppColors.darkBrown, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      _getLabel(index),
                      style: const TextStyle(
                        // 4. GANTI WARNA TEKS AKTIF
                        color: AppColors.darkBrown,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Icon(
                  key: ValueKey('unselected_$index'),
                  icon,
                  // 5. GANTI WARNA IKON TIDAK AKTIF
                  color: AppColors.iconGrey,
                  size: 24,
                ),
        ),
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Jadwal';
      case 2:
        return 'Tugas';
      case 3:
        return 'Profil';
      default:
        return '';
    }
  }
}
