// lib/screens/home/widgets/premium_banner.dart
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(Icons.workspace_premium, color: AppColors.yellow),
        title: const Text('Go To Premium Now',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text(
            'Support Us & get unlimited access\nto the premium features'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Implement navigation to premium screen
        },
      ),
    );
  }
}
