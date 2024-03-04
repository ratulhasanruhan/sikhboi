import 'package:flutter/cupertino.dart';

class QuestionController extends ChangeNotifier {
  bool disabled = true;

  void setDisabled(bool value) {
    disabled = value;
    notifyListeners();
  }

}