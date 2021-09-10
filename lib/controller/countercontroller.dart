import 'package:get/get.dart';

class CounterController extends GetxController {
  int counter = 0;
  inc() {
    counter++;

    update();
    return counter;
  }
}
