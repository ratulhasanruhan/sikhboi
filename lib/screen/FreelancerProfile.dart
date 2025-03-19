import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/CreateBuyerRequest.dart';
import 'package:sikhboi/utils/assets_path.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/widgets/gig_card.dart';

import 'CreateGig.dart';
import 'MessageList.dart';

class FreelancerProfile extends StatefulWidget {
  const FreelancerProfile({super.key, required this.user, required this.isSeller});
  final String user;
  final bool isSeller;

  @override
  State<FreelancerProfile> createState() => _FreelancerProfileState();
}

class _FreelancerProfileState extends State<FreelancerProfile> {

  var localUser = Hive.box('user').get('phone');

  var type = Hive.box('user').get('type');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.isSeller ? 'Seller Profile' : 'Buyer Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.isSeller ? 'freelance_seller' : 'freelance_buyer').doc(widget.user).snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Picture
                  FutureBuilder(
                    future: FirebaseStorage.instance.ref(widget.isSeller ? 'freelance_seller/${widget.user}/' : 'freelance_buyer/${widget.user}/').child('profile.jpg').getDownloadURL(),
                    builder: (context, future) {
                      if(future.hasData){
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(future.data.toString()),
                        );
                      }
                      return CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      );
                    }
                  ),
                  const SizedBox(height: 10),
                  // Name and Role
                  Text(
                    snapshot.data['name'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.isSeller ? snapshot.data['skill'] : snapshot.data['company_name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Contact Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact Information
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sectionTitle('Contact'),
                          widget.isSeller?
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    TextEditingController _controller = TextEditingController();

                                    return AlertDialog(
                                      title: Text('Message to ${snapshot.data['name']}'),
                                      content: TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          hintText: 'Write a message...',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        maxLines: 3,
                                        minLines: 2,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            await FirebaseFirestore.instance.collection('chat').add({
                                              'time': Timestamp.now(),
                                              'user': [
                                                Hive.box('user').get('phone'),
                                                widget.user,
                                              ],
                                              'sms' : [
                                                {
                                                  'text': _controller.text,
                                                  'user': Hive.box('user').get('phone'),
                                                  'time': Timestamp.now(),
                                                }
                                              ]
                                            }).then((value) {
                                              Navigator.pop(context);
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MessageList()));
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent')));
                                            });
                                          },
                                          child: const Text('Send'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            icon: const Icon(Icons.email, color: Colors.white),
                            label: const Text(
                                'Contact',
                                style: TextStyle(
                                    color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                              : SizedBox()
                        ],
                      ),
                      const SizedBox(height: 8),
                      contactInfo(Icons.location_on, snapshot.data['address']),
                      contactInfo(Icons.work, widget.isSeller ? snapshot.data['workExperience'] + ' Years Experience' : snapshot.data['company_name']),
                      contactInfo(Icons.email, snapshot.data['email']),
                      const SizedBox(height: 20),

                      // About Me Section
                      sectionTitle('About me'),
                      const SizedBox(height: 8),
                       Text(
                         widget.isSeller ? snapshot.data['aboutMe'] : snapshot.data['company_description'],
                        style: TextStyle(color: Colors.black87),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),

                      // Skills Section
                      widget.isSeller
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle('Skills'),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.data['skill'],
                            style: TextStyle(color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                      : const SizedBox(),

                      // Portfolio Section
                      sectionTitle(widget.isSeller ? 'Portfolio' : 'Our Company'),
                      const SizedBox(height: 8),
                      widget.isSeller
                      ? GridView.count(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for(int i = 1; i < 10; i++)
                            FutureBuilder(
                              future: FirebaseStorage.instance.ref('freelance_seller/${widget.user}/').child('work_$i.jpg').getDownloadURL(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  return portfolioItem(snapshot.data.toString());
                                }
                                return portfolioItem('https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg');
                              }
                            ),
                        ],
                      )
                      : GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          FutureBuilder(
                              future: FirebaseStorage.instance.ref('freelance_buyer/${widget.user}/').child('company.jpg').getDownloadURL(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return portfolioItem(snapshot.data.toString());
                              }
                              return portfolioItem('https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png');
                            }
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle(widget.isSeller ? 'My Gigs' : 'My Posts'),

                          widget.user == localUser ?
                          ElevatedButton(
                            onPressed: () {
                              if(widget.isSeller){
                                if (type == 'pending') {
                                  FirebaseFirestore.instance.collection('freelance_seller').doc(localUser).get().then((value) {
                                    if (value.exists) {
                                      String status = value['status'];

                                      if(status == 'active'){
                                        Hive.box('user').put('type', 'seller');
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGig()));
                                      }
                                      else if(status == 'pending'){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Pending'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.watch_later_outlined, color: color2, size: 50),
                                                  Text(
                                                    'Your account is under review. Please wait for approval.',
                                                    textAlign: TextAlign.center,

                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      else{
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Rejected'),
                                              content: Text('Your account is rejected. Please contact with admin.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  });
                                }
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGig()));
                                }
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBuyerRequest()));
                              }
                            },
                            child: Text(
                              widget.isSeller ? 'Publish Gig' : 'Work Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FirestoreListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        query: FirebaseFirestore.instance.collection(widget.isSeller ? 'gigs' : 'buyer_request').where('user', isEqualTo: widget.user),
                        itemBuilder: (context, snapshot) {
                          return gigCard(
                            title: snapshot['title'],
                            description: snapshot['description'],
                            price: snapshot['price'],
                            gigId: snapshot.id,
                            context: context
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }

  // Widget for Section Title
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.green,
        decorationColor: Colors.green,
        decoration: TextDecoration.underline,
      ),
    );
  }

  // Widget for Contact Information
  Widget contactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Widget for Portfolio Item
  Widget portfolioItem(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100,),
                        Icon(Icons.error),
                        Text('Image not found'),
                        SizedBox(height: 100,),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error);
          },
        ),
      ),
    );
  }
}
