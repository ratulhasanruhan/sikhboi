import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FreelancerProfile extends StatefulWidget {
  const FreelancerProfile({super.key});

  @override
  State<FreelancerProfile> createState() => _FreelancerProfileState();
}

class _FreelancerProfileState extends State<FreelancerProfile> {

  var type = Hive.box('user').get('type');
  var phone = Hive.box('user').get('phone');

  bool isSeller = Hive.box('user').get('type') == 'seller';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isSeller ? 'Seller Profile' : 'Buyer Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(isSeller ? 'freelance_seller' : 'freelance_buyer').doc(phone).snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture
                  FutureBuilder(
                    future: FirebaseStorage.instance.ref(isSeller ? 'freelance_seller' : 'freelance_buyer').child(phone).getDownloadURL(),
                    builder: (context, future) {
                      if(future.hasData){
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(future.data.toString()),
                        );
                      }
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
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
                    isSeller ? snapshot.data['skill'] : snapshot.data['company_name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Contact Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.email, color: Colors.white),
                    label: const Text('Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contact Information
                  sectionTitle('Contact'),
                  const SizedBox(height: 8),
                  contactInfo(Icons.location_on, 'Shariatpur'),
                  contactInfo(Icons.work, '5 Years Experience'),
                  contactInfo(Icons.email, 'abir@gmail.com'),
                  const SizedBox(height: 20),

                  // About Me Section
                  sectionTitle('About me'),
                  const SizedBox(height: 8),
                  const Text(
                    'আমি বাপ্পি, একজন গ্রাফিক্স এবং ভিজ্যুয়াল ডিজাইনার। আমি ক্রিয়েটিভ ডিজাইনিংয়ে অভিজ্ঞ এবং বিভিন্ন ধরনের সামাজিক মিডিয়া, পণ্য বিপণন এবং লোগো ডিজাইনের জন্য নির্ভরযোগ্য সেবা প্রদান করে থাকি।',
                    style: TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Skills Section
                  sectionTitle('Skills'),
                  const SizedBox(height: 8),
                  const Text(
                    'লোগো ডিজাইন, ব্যানার ডিজাইন, সোশাল মিডিয়া ডিজাইন, ফেসবুক কভার ডিজাইন',
                    style: TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Portfolio Section
                  sectionTitle('Portfolio'),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      portfolioItem('https://via.placeholder.com/100'),
                      portfolioItem('https://via.placeholder.com/100'),
                      portfolioItem('https://via.placeholder.com/100'),
                      portfolioItem('https://via.placeholder.com/100'),
                      portfolioItem('https://via.placeholder.com/100'),
                      portfolioItem('https://via.placeholder.com/100'),
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
      ),
    );
  }

  // Widget for Contact Information
  Widget contactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
