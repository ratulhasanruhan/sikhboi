import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/FreelancerProfile.dart';
import 'package:sikhboi/screen/MessageList.dart';
import 'package:sikhboi/utils/assets_path.dart';
import 'package:sikhboi/utils/colors.dart';

import '../widgets/gig_card.dart';

class FreelanceMain extends StatefulWidget {
  const FreelanceMain({super.key});

  @override
  State<FreelanceMain> createState() => _FreelanceMainState();
}

class _FreelanceMainState extends State<FreelanceMain> {

  String selectedType = 'Gigs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: AppBar(
        backgroundColor: Color(0xFFCFE7C1),
        leading: Image.asset(
          AssetsPath.grobin_2,
          height: 80,
        ),
        leadingWidth: 150,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFCFE7C1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedType = 'Gigs';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedType == 'Gigs' ? primaryColor : light_green,
                            border: Border.all(
                              color: selectedType == 'Gigs' ? primaryColor : color2dark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Gigs",
                            style: TextStyle(
                              color: selectedType == 'Gigs' ? Colors.white : color2dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedType = 'Buyer Requests';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedType == 'Buyer Requests' ? primaryColor : light_green,
                            border: Border.all(
                              color: selectedType == 'Buyer Requests' ? primaryColor : color2dark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Buyer Requests",
                            style: TextStyle(
                              color: selectedType == 'Buyer Requests' ? Colors.white : color2dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedType = 'Contests';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedType == 'Contests' ? primaryColor : light_green,
                            border: Border.all(
                              color: selectedType == 'Contests' ? primaryColor : color2dark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Contests",
                            style: TextStyle(
                              color: selectedType == 'Contests' ? Colors.white : color2dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MessageList()));
                        },
                        child: Icon(
                          Icons.mail_rounded,
                          color: color2dark,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FreelancerProfile(
                            user: Hive.box('user').get('phone'),
                            isSeller: Hive.box('user').get('type') == 'seller',
                          )));
                        },
                        child: Icon(
                          Icons.account_circle,
                          color: color2dark,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if(selectedType == 'Gigs')
              FirestoreListView(
                query: FirebaseFirestore.instance.collection('gigs'),
                shrinkWrap: true,
                itemBuilder: (context, snapshot){
                  return gigCard(
                    title: snapshot.data()['title'],
                    gigId: snapshot.id,
                    description: snapshot.data()['description'],
                    price: snapshot.data()['price'],
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
