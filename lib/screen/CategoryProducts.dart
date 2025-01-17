import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'ProductDetails.dart';

class CategoryProducts extends StatefulWidget {
  final String name;
  final String video;
  CategoryProducts({required this.name, Key? key, required this.video}) : super(key: key);

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body:  ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12, left: 12, right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: YoutubePlayer(
                controller: YoutubePlayerController.fromVideoId(
                  videoId: widget.video,
                  autoPlay: true,
                  params: const YoutubePlayerParams(
                    showControls: true,
                    showFullscreenButton: true,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('products').where('category', isEqualTo: widget.name).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length ,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index){
                        return Card(
                          elevation: 0.7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(data: snapshot.data.docs[index].data(), id: snapshot.data.docs[index].id)));
                            },
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          snapshot.data.docs[index]['image'][0],
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: double.infinity,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '৳'+' ${snapshot.data.docs[index]['price']}',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '৳'+' ${snapshot.data.docs[index]['price']*1.2}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
          ),
        ],
      ),
    );
  }
}
