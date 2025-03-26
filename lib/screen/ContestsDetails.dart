import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:sikhboi/screen/ContestsEntry.dart';
import 'package:sikhboi/widgets/loginPermission.dart';

import '../utils/colors.dart';
import '../utils/time_difference.dart';

class ContestsDetails extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  final String id;
  const ContestsDetails({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  State<ContestsDetails> createState() => _ContestsDetailsState();
}

class _ContestsDetailsState extends State<ContestsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কাজের বিস্তারিত'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [

          widget.data['image'] != ''
              ? Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(widget.data['image']),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: ()async{
                    var response = await Dio().get(
                        widget.data['image'],
                        options: Options(responseType: ResponseType.bytes));

                    final result = await ImageGallerySaverPlus.saveImage(
                        Uint8List.fromList(response.data)
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['isSuccess'] ? 'সফলভাবে সংরক্ষণ করা হয়েছে' : 'সংরক্ষণ করা যায়নি')));
                  },
                  icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.downloading_rounded),
                  )
              )
            ],
          )
              : Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: const Center(
              child: Text('কোন ছবি নেই'),
            ),
          ),

          const SizedBox(height: 18),
          Text(
            widget.data['title'],
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'প্রকাশের তারিখ: ${widget.data['time'].toDate().day}/${widget.data['time'].toDate().month}/${widget.data['time'].toDate().year}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                calculateTimeDifference(startDate: widget.data['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '') + ' আগে',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            'বাজেট: ${widget.data['price'].toString()} টাকা',
            style: TextStyle(
              fontSize: 20,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Text(
            'কাজের বিবরণ:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.data['description'],
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'পোস্টকারী:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.data['user']).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Text(snapshot.data['name'][0].toString().toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,

                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data['phone'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              }
          ),

          SizedBox(height: 20),
          MaterialButton(
            onPressed: (){
              if(Hive.box('user').get('phone') == '' || Hive.box('user').get('phone') == null){
                loginPermissionDialog(context);
              } else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContestsEntry(id: widget.id,data: widget.data,)));
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            height: 40,
            color: primaryColor,
            child: const Text(
              'কাজের এন্ট্রিগুলো দেখুন',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 40),

        ],
      ),
    );
  }
}