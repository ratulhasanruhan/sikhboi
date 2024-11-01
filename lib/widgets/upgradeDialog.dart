import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../screen/PremiumPlan.dart';
import '../utils/colors.dart';

upgradeDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Lottie.asset(
            'assets/premium.json',
            height: 100,
            width: 100,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'উপার্জন করতে হলে আপনার একাউন্টটি প্রিমিয়াম করতে হবে। ',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PremiumPlan()));
                },
                color: pinkish,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'প্রিমিয়াম করুন',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      });
}
