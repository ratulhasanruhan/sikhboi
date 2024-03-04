import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screen/Login.dart';
import '../screen/Register.dart';


void loginPermissionDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Image.asset(
            'assets/permission.png',
            height: 100.h,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('এই ফিচারটি ব্যবহার করতে অনুগ্রহ করে লগইন অথবা নিবন্ধন করুন। ',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        child: Text('নিবন্ধন'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: Text('লগইন'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }
  );
}