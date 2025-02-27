import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../screen/GigDetails.dart';

Widget gigCard({
      required String title,
      required String description,
      required String price,
      required String gigId,
      required BuildContext context,
      bool isGig = true,
    }) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GigDetails(gigId: gigId, isGig: isGig,)));
    },
    borderRadius: BorderRadius.circular(12),
    child: Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image on the Left
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: FutureBuilder(
              future: FirebaseStorage.instance.ref().child('gigs/$gigId/1.jpg').getDownloadURL(),
              builder: (context, future) {
                if(future.hasData){
                  return Image.network(
                    future.data.toString(),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  );
                }
                return Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            ),
          ),
          const SizedBox(width: 12),

          // Text Details on the Right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '৳ $price',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 8,),
              ],
            ),
          ),

        ],
      ),
    ),
  );
}