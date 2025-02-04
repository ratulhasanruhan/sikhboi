import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/Dictionary.dart';
import 'package:sikhboi/utils/colors.dart';

import 'PaymentScreen.dart';

class PremiumDictionary extends StatefulWidget {
  const PremiumDictionary({super.key});

  @override
  State<PremiumDictionary> createState() => _PremiumDictionaryState();
}

class _PremiumDictionaryState extends State<PremiumDictionary> {

  var box = Hive.box('user');
  var firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    box.get('dictionary_trial') == null ? box.put('dictionary_trial', DateTime.now()) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      body: Column(
        children: [
          if(box.get('dictionary_trial') == null || DateTime.now().difference(box.get('dictionary_trial')).inDays < 3)
            Flexible(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: color2dark,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Text(
                      'আপনি ৩ দিন ফ্রি ট্রায়াল পাচ্ছেন। \nযা আরো ${3 - DateTime.now().difference(box.get('dictionary_trial')).inDays} দিন অবশিষ্ট আছে।',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Dictionary(
                        type: 'freelance_dictionary'
                    ),
                  ),
                ],
              ),
            )
          else if(DateTime.now().difference(box.get('dictionary_trial')).inDays >= 3)
            Column(
              children: [
                Text(
                  'আপনার ট্রায়াল শেষ হয়ে গেছে। প্রিমিয়াম সাবস্ক্রিপশন নিতে চাইলে ক্লিক করুন।',
                  style: TextStyle(
                    color: color2,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await firestore.collection('users').doc(box.get('phone')).get().then((value) {
                          if(value.data()?['point'] >= 1500){
                            firestore.collection('user').doc(box.get('phone')).update({
                              'point': value.data()?['point'] - 1500,
                            }).then((value) {
                              box.put('dictionary_trial', DateTime.now().add(Duration(days: 365)));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('সাবস্ক্রিপশন সফল হয়েছে!'),
                                duration: Duration(seconds: 3),
                              ));
                              setState(() {
                              });
                            });
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('আপনার পয়েন্ট পর্যাপ্ত নেই!'),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color2,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'পয়েন্ট দিয়ে কিনুন',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                          amount: 100,
                          subscription: true,
                          reason: 'dictionary',
                        )));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color2dark,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'টাকা দিয়ে কিনুন',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          else
            Flexible(
              child: Dictionary(
                  type: 'freelance_dictionary'
              ),
            ),
        ],
      ),
    );
  }
}
