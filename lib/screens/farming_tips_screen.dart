import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FarmingTipsScreen extends StatefulWidget {
  const FarmingTipsScreen({super.key});

  @override
  State<FarmingTipsScreen> createState() => _FarmingTipsScreenState();
}

class _FarmingTipsScreenState extends State<FarmingTipsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Tips'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              size: 100,
              color: AppColors.accent,
            ),
            SizedBox(height: 20),
            Text(
              'Farming Tips',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Expert farming advice will be available here',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
