import 'package:flutter/material.dart';
import 'package:sikhboi/screen/MessageList.dart';
import 'package:sikhboi/utils/assets_path.dart';
import 'package:sikhboi/utils/colors.dart';

class FreelanceMain extends StatefulWidget {
  const FreelanceMain({super.key});

  @override
  State<FreelanceMain> createState() => _FreelanceMainState();
}

class _FreelanceMainState extends State<FreelanceMain> {

  String searchText = 'Gigs';

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
                            searchText = 'Gigs';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                            color: searchText == 'Gigs' ? primaryColor : light_green,
                            border: Border.all(
                              color: searchText == 'Gigs' ? primaryColor : color2dark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Gigs",
                            style: TextStyle(
                              color: searchText == 'Gigs' ? Colors.white : color2dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      InkWell(
                        onTap: (){
                          setState(() {
                            searchText = 'Buyer Requests';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                            color: searchText == 'Buyer Requests' ? primaryColor : light_green,
                            border: Border.all(
                              color: searchText == 'Buyer Requests' ? primaryColor : color2dark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Buyer Requests",
                            style: TextStyle(
                              color: searchText == 'Buyer Requests' ? Colors.white : color2dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      InkWell(
                        onTap: (){
                          setState(() {
                            searchText = 'Contests';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                            color: searchText == 'Contests' ? primaryColor : light_green,
                            border: Border.all(
                              color: searchText == 'Contests' ? primaryColor : color2dark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Contests",
                            style: TextStyle(
                              color: searchText == 'Contests' ? Colors.white : color2dark,
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
                        onTap: (){},
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
      body: Center(
      ),
    );
  }
}
