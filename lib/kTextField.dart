import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sikhboi/utils/colors.dart';

class kTextField extends StatelessWidget {
  const kTextField({Key? key,
    required this.type,
    required this.controller,
    required this.hint,
    required this.icon,
  }) : super(key: key);

  final TextInputType type;
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: blackColor,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          fillColor: offWhite,
          filled: true,
          hintText: hint,
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none
          ),
          hintStyle: TextStyle(
              fontFamily: 'Ador'
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 8, top: 5, bottom: 5),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: primaryColor,),
                  VerticalDivider(color: darkWhite,thickness:1),
                ],
              ),
            ),
          )
      ),
      validator: (val){
        if(val!.isEmpty){
          return 'আপনার $hint লিখুন';
        }
        return null;
      },
    );
  }
}
