import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/utils/colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  int questionIndex = 0;
  var user = Hive.box('user').get('phone');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Center(
              child: Text('চলো কুইজ খেলে মেধা যাচাই করো!\nএখানে টো টি প্রশ্ন থাকবে, প্রতি প্রশ্নে ৫ পয়েন্ট করে পাবে। ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color2dark
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('quiz').snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  final questions = snapshot.data?.docs;
                  return Column(
                    children: [
                      Text(questions![questionIndex]['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      Text(questions[questionIndex]['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: color2dark
                        ),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: questions[questionIndex]['answer'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: color2, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(questions[questionIndex]['answer'][index]['text'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: color2dark
                                ),
                              ),
                              onTap: () {
                                if(questions[questionIndex]['answer'][index]['isCorrect']){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('সঠিক উত্তর! ৫ পয়েন্ট যুক্ত হয়েছে'),
                                    backgroundColor: Colors.green,
                                  ));

                                  FirebaseFirestore.instance.collection('users').doc(user).update({
                                    'points': FieldValue.increment(5)
                                  });

                                } else {
                                  List answers = questions[questionIndex]['answer'];

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('ভুল উত্তর! সঠিক উত্তরটি: ${answers.where((element) => element['isCorrect'] == true).first['text']}'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                                if(questionIndex < questions.length - 1){
                                  setState(() {
                                    questionIndex++;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          questionIndex > 0 ?
                          IconButton(
                            onPressed: () {
                              setState(() {
                                questionIndex--;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_circle_left_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                          )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          questionIndex < snapshot.data!.docs.length - 1 ?
                          IconButton(
                            onPressed: () {
                              setState(() {
                                questionIndex++;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_circle_right_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                          )
                              : SizedBox(),
                        ],
                      )

                    ],
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
