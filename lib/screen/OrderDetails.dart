import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';
import 'package:sikhboi/utils/Checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OrderDetails extends StatefulWidget {
  final int price;
  final String productName;
  final String productId;

  const OrderDetails({Key? key, required this.price, required this.productName, required this.productId}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _formKey = GlobalKey<FormState>();
  var box = Hive.box('user');

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController jelaController = TextEditingController();
  TextEditingController postController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(box.get('phone') != '' || box.get('phone') != null){
      setData();
    }
  }

  void setData() async{
    phoneController.text = box.get('phone');

    await FirebaseFirestore.instance.collection('users').doc(box.get('phone')).get().then((value) {
      nameController.text = value['name'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "ডেলিভারী তথ্য",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Text(
              "'পছন্দের পণ্যটি হাতে পেতে\nআপনার ঠিকানা দিয়ে সহায়তা করুন' ধন্যবাদ!",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "আপনার নাম",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'আপনার নাম লিখুন';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "আপনার মোবাইল নাম্বার",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'আপনার মোবাইল নাম্বার লিখুন';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: promoCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "প্রোমো কোড",
                hintText: "যার মাদ্ধমে প্রোডাক্ট সম্পর্কে জানতে পেরেছেন তার কোড",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: jelaController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: "জেলার নাম",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'আপনার জেলার নাম লিখুন';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: postController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "পোস্ট কোড",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'আপনার পোস্ট কোড লিখুন';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: addressController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: "ঠিকানা",
                hintText: "আপনার ঠিকানা সহজভাবে বুঝিয়ে লিখুন,\nযাতে আমরা অতি দ্রুত আপনার কাছে পণ্য পৌঁছে দিতে পারি",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              minLines: 3,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'আপনার ঠিকানা লিখুন';
                }
                return null;
              },
            ),
            SizedBox(
              height: 18,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "সর্বমোট প্রদান করতে হবে",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "৳ ${widget.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    if(promoCodeController.text.isNotEmpty){
                      if(await checkIfDocExists(promoCodeController.text.trim())){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                          amount: widget.price,
                          subscription: false,
                          reason: 'order',
                          data: {
                            'name': nameController.text,
                            'phone': phoneController.text,
                            'promoCode': '',
                            'jela': jelaController.text,
                            'post': postController.text,
                            'address': addressController.text,
                            'price': widget.price,
                            'product': widget.productName,
                            'productID': widget.productId,
                            'image': '',
                            'status': 'pending',
                          },
                        )));
                      }
                      else{
                        showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message:
                              "দুঃখিত, আপনার প্রোমো কোডটি সঠিক নয়",
                            ),
                        );
                      }
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                        amount: widget.price,
                        subscription: false,
                        reason: 'order',
                        data: {
                          'name': nameController.text,
                          'phone': phoneController.text,
                          'promoCode': '',
                          'jela': jelaController.text,
                          'post': postController.text,
                          'address': addressController.text,
                          'price': widget.price,
                          'product': widget.productName,
                          'productID': widget.productId,
                          'image': '',
                          'status': 'pending',
                        },
                      )));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  "পেমেন্ট করুন",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
