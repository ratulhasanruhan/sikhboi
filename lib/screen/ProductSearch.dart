import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sikhboi/screen/ProductDetails.dart';

import '../utils/colors.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({Key? key}) : super(key: key);

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF272A2F),
        ),
        title: Text(
          'সার্চ',
          style: TextStyle(
            color: Color(0xFF272A2F),
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2c2c2c).withOpacity(0.1),
                          blurRadius: 49,
                          spreadRadius: -2,
                          offset: Offset(0, 3),
                        )
                      ]
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FeatherIcons.search,
                        color: Color(0xFFcdcdcd),
                      ),
                      hintText: 'এখানে লিখুন...',
                      hintStyle: TextStyle(
                        color: Color(0xFFcdcdcd),
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                  flex: 0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6,
                    color: color2,
                    shadowColor: waterColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: InkWell(
                          child: Icon(
                            FeatherIcons.search,
                            color:Colors.white ,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          StreamBuilder(
              stream: searchQuery != ''
                  ? FirebaseFirestore.instance.collection('products').where('name', isGreaterThanOrEqualTo: searchQuery , isLessThan: searchQuery + '\uf7ff').snapshots()
                  : FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){

                  return GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index){
                        return Card(
                          elevation: 0.7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(data: snapshot.data.docs[index].data(), id: snapshot.data.docs[index].id)));
                                  },
                                  child: Column(
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
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '৳'+' ${snapshot.data.docs[index]['price']}',
                                      style: TextStyle(
                                        color: Colors.black87,
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
                        );
                      }
                  );
                }
                return Center(
                  child: CircularProgressIndicator( color: color2,),
                );
              }
          )

        ],
      ),
    );
  }
}
