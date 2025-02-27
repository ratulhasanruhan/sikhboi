import 'package:flutter/material.dart';

class GigDetails extends StatefulWidget {
  const GigDetails({super.key});

  @override
  State<GigDetails> createState() => _GigDetailsState();
}

class _GigDetailsState extends State<GigDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Top Grid of Mockups
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                _buildMockupImage('https://mockuptree.com/wp-content/uploads/edd/2025/02/Book_Dust_Jacket_Mockup_psd-960x640.jpg'), // Replace with your image paths
                _buildMockupImage('https://i.pinimg.com/originals/f5/c0/04/f5c004b223fff1267367adc4fbe1a0c0.jpg'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Profile Section
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your image
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Bappy Ahmed', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Graphics Designer'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Service Description
                  Text(
                    'আপনার গ্রাফিক্স ডিজাইন রিলেটেড যে কোন প্রয়োজনীয় ডিজাইন আমি করে দিতে পারবো।',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  // Service List
                  Text('সার্ভিস গুলোঃ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(leading: Text('•'), title: Text('লোগো ডিজাইন')),
                  ListTile(leading: Text('•'), title: Text('ব্যানার ডিজাইন')),
                  ListTile(leading: Text('•'), title: Text('সোস্যাল মিডিয়া')),
                  ListTile(leading: Text('•'), title: Text('কভার ডিজাইন')),
                  SizedBox(height: 16),
                  // Delivery/Revision/Pricing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(children: <Widget>[Text('ডেলিভারি'), Text('২ দিন')]),
                      Column(children: <Widget>[Text('রিভিশন'), Text('যতখুশি')]),
                      Column(children: <Widget>[Text('প্রাইজিং'), Text('৪৫০৮')]),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Message Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle message button press
                      },
                      child: Text('এখনই মেসেজ দিন'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockupImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
