import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_countdown/slide_countdown.dart';

class LiveWaiting extends StatefulWidget {
  const LiveWaiting({super.key, required this.duration});
  final Duration duration;

  @override
  State<LiveWaiting> createState() => _LiveWaitingState();
}

class _LiveWaitingState extends State<LiveWaiting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('লাইভ ক্লাস',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '"শিখবোই একাডেমির লাইভ ক্লাসে আপনাকে স্বাগতম"',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Text(
                      "COUNTDOWN",
                      style: GoogleFonts.oswald(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SlideCountdownSeparated(
                          duration: const Duration(minutes: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'ক্লাস শুরু হবে রাত ৯ টায়',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
