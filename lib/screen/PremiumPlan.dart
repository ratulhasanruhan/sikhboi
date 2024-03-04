import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/utils/constants.dart';

import '../utils/colors.dart';
import 'PaymentScreen.dart';

class PremiumPlan extends StatefulWidget {
  const PremiumPlan({Key? key}) : super(key: key);

  @override
  State<PremiumPlan> createState() => _PremiumPlanState();
}

class _PremiumPlanState extends State<PremiumPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Premium Plan'),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Lottie.network(
              'https://assets5.lottiefiles.com/packages/lf20_6bfqp4wi.json',
              height: 200,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: pinkish.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: pinkish.withOpacity(0.7)),
            ),
            child: Column(
              children: [
                Text(
                  'প্রিমিয়াম প্ল্যান',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '১০০/-',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '৪৯৯/-',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 30,
          ),
          Text(
            'এখনই সাবস্ক্রাইব করুন',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 5,
          ),

          MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(amount: premiumPrice, subscription: true, reason: 'subscription',),
                  ),
                );
              },
            minWidth: double.infinity,
            child: Text(
              'সাবস্ক্রাইব',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: pinkish,
            height: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          )
        ],
      ),
    );
  }
}
