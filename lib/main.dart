import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:sikhboi/controller/QuestionCOntroller.dart';
import 'package:sikhboi/screen/Home.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //MobileAds.instance.initialize();

  await Hive.initFlutter();
  await Hive.openBox('user');

  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: 480.0,
    app: MyApp(),
  );

  runApp(runnableApp);
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = Hive.box('user');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box.put('banner', false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuestionController()),
      ],
      child:  MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Ador',
            ),
            debugShowCheckedModeBanner: false,
            home: HomePage(),
      ),
    );
  }
}


Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        child: app,
      ),
    ),
  );
}