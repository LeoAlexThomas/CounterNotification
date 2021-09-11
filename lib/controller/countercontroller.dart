import 'package:get/get.dart';

class CounterController extends GetxController {
  int counter = 0;

  initilaizeCounter(int data) {
    counter = data;
    update();
  }

  inc() {
    counter++;

    update();
    return counter;
  }
}
